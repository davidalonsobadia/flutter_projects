// models/image_model.dart
class ImageModel {
  final String id;
  final String filename;
  final String thumbnailUrl;
  final String fullUrl;
  final DateTime uploadDate;
  final int fileSize;
  final String userId;

  ImageModel({
    required this.id,
    required this.filename,
    required this.thumbnailUrl,
    required this.fullUrl,
    required this.uploadDate,
    required this.fileSize,
    required this.userId,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'],
      filename: json['filename'],
      thumbnailUrl: json['thumbnail_url'],
      fullUrl: json['full_url'],
      uploadDate: DateTime.parse(json['upload_date']),
      fileSize: json['file_size'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filename': filename,
      'thumbnail_url': thumbnailUrl,
      'full_url': fullUrl,
      'upload_date': uploadDate.toIso8601String(),
      'file_size': fileSize,
      'user_id': userId,
    };
  }
}
