import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensorsScreen extends StatefulWidget {
  @override
  _SensorsScreenState createState() => _SensorsScreenState();
}

class _SensorsScreenState extends State<SensorsScreen> {
  List<String> _sensors = [];
  Map<String, List<double>> _sensorValues = {};

  @override
  void initState() {
    super.initState();
    _initSensors();
  }

  void _initSensors() {
    // Intentar acceder a cada sensor y agregarlo si está disponible
    accelerometerEvents.listen((AccelerometerEvent event) {
      if (!_sensors.contains('Acelerómetro')) {
        setState(() {
          _sensors.add('Acelerómetro');
        });
      }
      setState(() {
        _sensorValues['Acelerómetro'] = [event.x, event.y, event.z];
      });
    });

    gyroscopeEvents.listen((GyroscopeEvent event) {
      if (!_sensors.contains('Giroscopio')) {
        setState(() {
          _sensors.add('Giroscopio');
        });
      }
      setState(() {
        _sensorValues['Giroscopio'] = [event.x, event.y, event.z];
      });
    });

    magnetometerEvents.listen((MagnetometerEvent event) {
      if (!_sensors.contains('Magnetómetro')) {
        setState(() {
          _sensors.add('Magnetómetro');
        });
      }
      setState(() {
        _sensorValues['Magnetómetro'] = [event.x, event.y, event.z];
      });
    });
  }

  String _formatSensorValues(List<double>? values) {
    if (values == null) return 'No hay datos';
    return 'X: ${values[0].toStringAsFixed(2)}, Y: ${values[1].toStringAsFixed(2)}, Z: ${values[2].toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sensores Disponibles:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          if (_sensors.isEmpty)
            Center(
              child: Text(
                'No se detectaron sensores',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _sensors.length,
                itemBuilder: (context, index) {
                  final sensor = _sensors[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sensor,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            _formatSensorValues(_sensorValues[sensor]),
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}