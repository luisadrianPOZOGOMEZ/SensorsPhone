import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'geolocator_screen.dart';
import 'qr_screen.dart'; 
import 'sensors_screen.dart';
import 'speech_to_text_screen.dart';
import 'text_to_speech_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    _HomeContent(),
    GeolocatorScreen(),
    QRScreen(), 
    SensorsScreen(),
    SpeechToTextScreen(),
    TextToSpeechScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitleForIndex(_selectedIndex)),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.location_on),
            label: 'GPS',
          ),
          NavigationDestination(
            icon: Icon(Icons.qr_code),
            label: 'QR',
          ),
          NavigationDestination(
            icon: Icon(Icons.sensors),
            label: 'Sensores',
          ),
          NavigationDestination(
            icon: Icon(Icons.mic),
            label: 'Speech',
          ),
          NavigationDestination(
            icon: Icon(Icons.volume_up),
            label: 'TTS',
          ),
        ],
      ),
    );
  }

  String _getTitleForIndex(int index) {
    switch (index) {
      case 0:
        return 'Presentación';
      case 1:
        return 'Geolocalización';
      case 2:
        return 'Lector QR';
      case 3:
        return 'Sensores';
      case 4:
        return 'Speech to Text';
      case 5:
        return 'Text to Speech';
      default:
        return 'Presentación';
    }
  }
}

class _HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/63227.png',
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              'Ingeniería en Software',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Luis Adrián Pozo Gómez 221218\nProgramación Movil\n9A',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () => _launchURL(context, 'https://github.com/luisadrianPOZOGOMEZ/MFA-security.git'),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.link),
                  SizedBox(width: 8),
                  Text('Abrir GitHub', style: TextStyle(fontSize: 16)),
                  Icon(Icons.code, size: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo abrir el enlace.')),
      );
    }
  }
}
