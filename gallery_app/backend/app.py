# app.py
from flask import Flask, request, jsonify, send_file
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from werkzeug.utils import secure_filename
from PIL import Image, ImageOps
import os
import uuid
from datetime import datetime
import math


app = Flask(__name__)
CORS(app)

# Configuration
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///images.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['UPLOAD_FOLDER'] = 'uploads'
app.config['THUMBNAIL_FOLDER'] = 'thumbnails'
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024  # 16MB max file size

# Create upload directories
os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)
os.makedirs(app.config['THUMBNAIL_FOLDER'], exist_ok=True)

db = SQLAlchemy(app)

# Models
class ImageModel(db.Model):
    __tablename__ = 'images'
    
    id = db.Column(db.String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    filename = db.Column(db.String(255), nullable=False)
    original_filename = db.Column(db.String(255), nullable=False)
    file_path = db.Column(db.String(500), nullable=False)
    thumbnail_path = db.Column(db.String(500), nullable=False)
    file_size = db.Column(db.Integer, nullable=False)
    upload_date = db.Column(db.DateTime, default=datetime.utcnow)
    user_id = db.Column(db.String(36), default='default_user')  # Simplified for demo
    
    def to_dict(self, base_url):
        return {
            'id': self.id,
            'filename': self.original_filename,
            'thumbnail_url': f'{base_url}/api/images/{self.id}/thumbnail',
            'full_url': f'{base_url}/api/images/{self.id}/full',
            'upload_date': self.upload_date.isoformat(),
            'file_size': self.file_size,
            'user_id': self.user_id
        }

# Utility functions
def allowed_file(filename):
    ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif', 'bmp', 'webp'}
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def create_thumbnail(image_path, thumbnail_path, size=(300, 300)):
    """Create a thumbnail from the original image"""
    try:
        with Image.open(image_path) as img:
            # Convert RGBA to RGB if necessary
            img = ImageOps.exif_transpose(img)
            
            if img.mode in ('RGBA', 'LA', 'P'):
                background = Image.new('RGB', img.size, (255, 255, 255))
                if img.mode == 'P':
                    img = img.convert('RGBA')
                background.paste(img, mask=img.split()[-1] if img.mode == 'RGBA' else None)
                img = background
            
            # Create thumbnail maintaining aspect ratio
            img.thumbnail(size, Image.Resampling.LANCZOS)
            img.save(thumbnail_path, 'JPEG', quality=85, optimize=True)
            return True
    except Exception as e:
        print(f"Error creating thumbnail: {e}")
        return False

def get_base_url():
    """Get the base URL for the API"""
    return request.url_root.rstrip('/')

# Routes
@app.route('/api/images', methods=['GET'])
def get_images():
    """Get paginated list of images"""
    try:
        page = request.args.get('page', 1, type=int)
        limit = request.args.get('limit', 20, type=int)
        
        # Validate pagination parameters
        if page < 1:
            page = 1
        if limit < 1 or limit > 100:
            limit = 20
        
        # Query images with pagination
        query = ImageModel.query.order_by(ImageModel.upload_date.desc())
        total_count = query.count()
        total_pages = math.ceil(total_count / limit)
        
        images = query.offset((page - 1) * limit).limit(limit).all()
        
        base_url = get_base_url()
        
        response_data = {
            'items': [img.to_dict(base_url) for img in images],
            'current_page': page,
            'total_pages': total_pages,
            'total_count': total_count,
            'has_next': page < total_pages,
            'has_prev': page > 1
        }
        
        return jsonify(response_data), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/images', methods=['POST'])
def upload_image():
    """Upload a new image"""
    try:
        # Check if image file is present
        if 'image' not in request.files:
            return jsonify({'error': 'No image file provided'}), 400
        
        file = request.files['image']
        if file.filename == '':
            return jsonify({'error': 'No file selected'}), 400
        
        if not allowed_file(file.filename):
            return jsonify({'error': 'File type not allowed'}), 400
        
        # Generate unique filename
        original_filename = secure_filename(file.filename)
        file_extension = original_filename.rsplit('.', 1)[1].lower()
        unique_filename = f"{uuid.uuid4()}.{file_extension}"
        
        # Save paths
        file_path = os.path.join(app.config['UPLOAD_FOLDER'], unique_filename)
        thumbnail_filename = f"thumb_{unique_filename.rsplit('.', 1)[0]}.jpg"
        thumbnail_path = os.path.join(app.config['THUMBNAIL_FOLDER'], thumbnail_filename)
        
        # Save original file
        file.save(file_path)
        file_size = os.path.getsize(file_path)
        
        # Create thumbnail
        if not create_thumbnail(file_path, thumbnail_path):
            return jsonify({'error': 'Failed to create thumbnail'}), 500
        
        # Save to database
        new_image = ImageModel(
            filename=unique_filename,
            original_filename=original_filename,
            file_path=file_path,
            thumbnail_path=thumbnail_path,
            file_size=file_size
        )
        
        db.session.add(new_image)
        db.session.commit()
        
        base_url = get_base_url()
        return jsonify(new_image.to_dict(base_url)), 201
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@app.route('/api/images/<image_id>', methods=['DELETE'])
def delete_image(image_id):
    """Delete an image"""
    try:
        image = ImageModel.query.get(image_id)
        if not image:
            return jsonify({'error': 'Image not found'}), 404
        
        # Delete files from filesystem
        try:
            if os.path.exists(image.file_path):
                os.remove(image.file_path)
            if os.path.exists(image.thumbnail_path):
                os.remove(image.thumbnail_path)
        except OSError as e:
            print(f"Error deleting files: {e}")
        
        # Delete from database
        db.session.delete(image)
        db.session.commit()
        
        return jsonify({'message': 'Image deleted successfully'}), 200
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@app.route('/api/images/<image_id>/thumbnail', methods=['GET'])
def serve_thumbnail(image_id):
    """Serve image thumbnail"""
    try:
        image = ImageModel.query.get(image_id)
        if not image:
            return jsonify({'error': 'Image not found'}), 404
        
        if not os.path.exists(image.thumbnail_path):
            return jsonify({'error': 'Thumbnail not found'}), 404
        
        return send_file(
            image.thumbnail_path,
            mimetype='image/jpeg',
            as_attachment=False,
            download_name=f"thumb_{image.original_filename}"
        )
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/images/<image_id>/full', methods=['GET'])
def serve_full_image(image_id):
    """Serve full-size image"""
    try:
        image = ImageModel.query.get(image_id)
        if not image:
            return jsonify({'error': 'Image not found'}), 404
        
        if not os.path.exists(image.file_path):
            return jsonify({'error': 'Image file not found'}), 404
        
        # Determine mimetype based on file extension
        file_extension = image.filename.rsplit('.', 1)[1].lower()
        mimetype_map = {
            'jpg': 'image/jpeg',
            'jpeg': 'image/jpeg',
            'png': 'image/png',
            'gif': 'image/gif',
            'bmp': 'image/bmp',
            'webp': 'image/webp'
        }
        mimetype = mimetype_map.get(file_extension, 'application/octet-stream')
        
        return send_file(
            image.file_path,
            mimetype=mimetype,
            as_attachment=False,
            download_name=image.original_filename
        )
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/health', methods=['GET'])
def health_check():
    """Health check endpoint"""
    return jsonify({
        'status': 'healthy',
        'timestamp': datetime.utcnow().isoformat(),
        'total_images': ImageModel.query.count()
    }), 200

# Error handlers
@app.errorhandler(413)
def too_large(e):
    return jsonify({'error': 'File too large'}), 413

@app.errorhandler(404)
def not_found(e):
    return jsonify({'error': 'Endpoint not found'}), 404

@app.errorhandler(500)
def internal_error(e):
    return jsonify({'error': 'Internal server error'}), 500

# Initialize database
with app.app_context():
    db.create_all()

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)

