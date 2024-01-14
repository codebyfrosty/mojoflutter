import 'package:flutter/material.dart';
import 'package:flutter_ar/model/product_model.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ARPage extends StatefulWidget {
  final ProductDetailData product;
  const ARPage({super.key, required this.product});

  @override
  State<ARPage> createState() => _ARPageState();
}

class _ARPageState extends State<ARPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Model Viewer'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(),
            onPressed: () => _dialogBuilder(context),
            child: Text("Instruksi",
                style: TextStyle(
                  color: Colors.white,
                )),
          )
        ],
      ),
      body: ModelViewer(
        backgroundColor: Colors.transparent,
        src: widget.product.model.url,
        alt: 'A 3D model of an astronaut',
        ar: true,
        autoRotate: true,
        cameraControls: true,
        arPlacement: ArPlacement.floor,
        // iosSrc: 'https://modelviewer.dev/shared-assets/models/Astronaut.usdz',
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Instruksi'),
          content: const Text(
            'Untuk mengakses fitur Augmented Reality silahkan klik tombol di pojok kanan bawah',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Mengerti'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
