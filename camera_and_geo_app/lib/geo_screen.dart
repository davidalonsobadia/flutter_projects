import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class GeoScreen extends StatefulWidget {
  const GeoScreen({super.key, required this.goToHomeScreen});
  final void Function() goToHomeScreen;

  @override
  State<StatefulWidget> createState() {
    return _GeoScreen();
  }
}

class _GeoScreen extends State<GeoScreen> {
  Position? _position;
  String? _currentLocationAddress;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _position != null
                  ? Text('Current Location: $_position')
                  : const Text('No Location Data'),
              _currentLocationAddress != null
                  ? Text('Address: $_currentLocationAddress')
                  : const Text('No Location Address Data'),
              const SizedBox(
                height: 20,
              ),
              FilledButton(
                onPressed: widget.goToHomeScreen,
                child: const Text('Back'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _getCurrentLocation() {
    _determinePosition().then(
      (pos) => setState(
        () {
          _position = pos;
          _getCurrentLocationAddress(pos);
        },
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return Geolocator.getCurrentPosition();
  }

  void _getCurrentLocationAddress(Position position) async {
    try {
      List<Placemark> listPlaceMarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = listPlaceMarks[0];
      setState(() {
        _currentLocationAddress =
            '${place.locality}, ${place.postalCode}, ${place.country}';
      });
    } catch (e) {
      print(e);
    }
  }
}
