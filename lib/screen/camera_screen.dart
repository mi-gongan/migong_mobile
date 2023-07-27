import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:migong/components/camera_screen/photo_preview.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  bool _isCameraReady = false;

  @override
  void initState() {
    super.initState();

    availableCameras().then((cameras) {
      if (cameras.isNotEmpty && _cameraController == null) {
        _cameraController = CameraController(
          cameras[1],
          ResolutionPreset.medium,
        );

        _cameraController!.initialize().then((_) {
          setState(() {
            _isCameraReady = true;
          });
        });
      }
    });
  }

  void _onTakePicture(BuildContext context) {
    _cameraController!.takePicture().then((image) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PhotoPreview(
            imagePath: image.path,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a photo')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: _cameraController != null && _isCameraReady
                  ? CameraPreview(_cameraController!)
                  : Container(
                      color: Colors.grey,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: _cameraController != null
                    ? () => _onTakePicture(context)
                    : null,
                child: const Text('Take a photo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
