import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class RecordingButton extends StatefulWidget {
  const RecordingButton({super.key});

  @override
  State<RecordingButton> createState() => _RecordingButtonState();
}

class _RecordingButtonState extends State<RecordingButton> {
  bool isRecording = false;
  late final AudioRecorder _audioRecorder;
  String? _audioPath;

  @override
  void initState() {
    _audioRecorder = AudioRecorder();
    super.initState();
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  String _generateRandomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return List.generate(
      10,
      (index) => chars[random.nextInt(chars.length)],
      growable: false,
    ).join();
  }

  Future<void> _startRecording() async {
    try {
      debugPrint(
          '=========>>>>>>>>>>> RECORDING!!!!!!!!!!!!!!! <<<<<<===========');

      String filePath = await getApplicationDocumentsDirectory()
          .then((value) => '${value.path}/${_generateRandomId()}.wav');

      await _audioRecorder.start(
        const RecordConfig(
          // specify the codec to be `.wav`
          encoder: AudioEncoder.wav,
        ),
        path: filePath,
      );
    } catch (e) {
      debugPrint('ERROR WHILE RECORDING: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      String? path = await _audioRecorder.stop();

      setState(() {
        _audioPath = path!;
      });
      debugPrint('=========>>>>>> PATH: $_audioPath <<<<<<===========');
    } catch (e) {
      debugPrint('ERROR WHILE STOP RECORDING: $e');
    }
  }

  void _record() async {
    if (isRecording == false) {
      final status = await Permission.microphone.request();

      if (status == PermissionStatus.granted) {
        setState(() {
          isRecording = true;
        });
        await _startRecording();
      } else if (status == PermissionStatus.permanentlyDenied) {
        debugPrint('Permission permanently denied');
        // TODO: handle this case
      }
    } else {
      await _stopRecording();

      setState(() {
        isRecording = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomRecordingWaveWidget(
        isRecording: isRecording,
        onMicPressed: _record,
      ),
    );
  }
}

class CustomRecordingWaveWidget extends StatefulWidget {
  final bool isRecording;
  final void Function() onMicPressed;

  const CustomRecordingWaveWidget({
    super.key,
    required this.onMicPressed,
    required this.isRecording,
  });

  @override
  State<CustomRecordingWaveWidget> createState() => _RecordingWaveWidgetState();
}

class _RecordingWaveWidgetState extends State<CustomRecordingWaveWidget> {
  List<double> _heights = [0.05, 0.07, 0.1, 0.07, 0.05];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(CustomRecordingWaveWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording != oldWidget.isRecording) {
      if (widget.isRecording) {
        _startAnimating();
      } else {
        _heights = [0.05, 0.07, 0.1, 0.07, 0.05];
        _timer?.cancel();
      }
    }
  }

  void _startAnimating() {
    _timer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      setState(() {
        // This is a simple way to rotate the list, creating a wave effect.
        _heights.add(_heights.removeAt(0));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.onMicPressed,
        child: SizedBox(
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _heights.map((height) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 3,
                height: 200 * height,
                margin: const EdgeInsets.only(right: 2),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(50),
                ),
              );
            }).toList(),
          ),
        ));
  }
}
