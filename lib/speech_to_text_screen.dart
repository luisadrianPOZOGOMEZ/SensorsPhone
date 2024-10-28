import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class SpeechToTextScreen extends StatefulWidget {
  @override
  _SpeechToTextScreenState createState() => _SpeechToTextScreenState();
}

class _SpeechToTextScreenState extends State<SpeechToTextScreen> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = '';
  bool _speechEnabled = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    // Solicita el permiso de micrófono
    PermissionStatus status = await Permission.microphone.request();
    if (status.isGranted) {
      // Intenta inicializar el reconocimiento de voz
      _speechEnabled = await _speech.initialize(
        onStatus: (status) => print('Status: $status'),
        onError: (error) => print('Error: $error'),
      );
    }
    setState(() {});
  }

  void _startListening() async {
    if (_speechEnabled) {
      setState(() {
        _isListening = true;
      });

      await _speech.listen(
        onResult: (result) {
          setState(() {
            _text = result.recognizedWords;
          });
        },
        localeId: 'es_ES', // Idioma español
      );
    }
  }

  void _stopListening() async {
    if (_isListening) {
      await _speech.stop();
      setState(() {
        _isListening = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SingleChildScrollView(
                child: Text(
                  _text.isEmpty ? 'Presiona el botón y comienza a hablar...' : _text,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _speechEnabled
                ? (_isListening ? _stopListening : _startListening)
                : null,
            icon: Icon(_isListening ? Icons.stop : Icons.mic),
            label: Text(_isListening ? 'Detener' : 'Comenzar'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              textStyle: TextStyle(fontSize: 18),
            ),
          ),
          if (!_speechEnabled)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'El reconocimiento de voz no está disponible en este dispositivo o no se otorgaron permisos',
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}
