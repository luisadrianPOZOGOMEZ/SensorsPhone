import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class GeolocatorScreen extends StatefulWidget {
  @override
  _GeolocatorScreenState createState() => _GeolocatorScreenState();
}

class _GeolocatorScreenState extends State<GeolocatorScreen> {
  Position? _currentPosition;
  String _error = '';
  Timer? _locationUpdateTimer;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _startLocationUpdates();
  }

  @override
  void dispose() {
    _locationUpdateTimer?.cancel(); // Cancela el temporizador al salir de la pantalla
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _error = 'Los servicios de ubicación están desactivados');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _error = 'Permisos de ubicación denegados');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => _error = 'Los permisos de ubicación están permanentemente denegados');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() => _currentPosition = position);
    } catch (e) {
      setState(() => _error = 'Error: $e');
    }
  }

  void _startLocationUpdates() {
    _locationUpdateTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() => _currentPosition = position);
    });
  }

  void _openInGoogleMaps() async {
    if (_currentPosition != null) {
      final url =
          'https://www.google.com/maps/search/?api=1&query=${_currentPosition!.latitude},${_currentPosition!.longitude}';
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        setState(() => _error = 'No se pudo abrir Google Maps');
      }
    } else {
      setState(() => _error = 'Ubicación no disponible');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_error.isNotEmpty)
              Text(
                _error,
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            if (_currentPosition != null) ...[
              Text(
                'Coordenadas actuales:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Latitud: ${_currentPosition!.latitude}',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Longitud: ${_currentPosition!.longitude}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _openInGoogleMaps,
                icon: Icon(Icons.map),
                label: Text('Abrir en Google Maps'),
              ),
            ] else if (_error.isEmpty)
              CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
