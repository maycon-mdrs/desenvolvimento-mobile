import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;
  final File? initialImage;

  ImageInput(this.onSelectImage, {this.initialImage});

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  @override
  void initState() {
    super.initState();
    if (widget.initialImage != null) {
      _storedImage = widget.initialImage;
    }
  }

  Future<void> _takePicture() async {
    final ImagePicker _picker = ImagePicker();
    XFile? imageFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    if (imageFile == null) return;

    _saveImage(imageFile);
  }

  Future<void> _selectImageFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    XFile? imageFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );

    if (imageFile == null) return;

    _saveImage(imageFile);
  }

  Future<void> _saveImage(XFile imageFile) async {
    setState(() {
      _storedImage = File(imageFile.path);
    });

    final appDir = await syspaths.getApplicationDocumentsDirectory();
    String fileName = path.basename(_storedImage!.path);
    final savedImage = await _storedImage!.copy('${appDir.path}/$fileName');
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 180,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          alignment: Alignment.center,
          child: _storedImage != null
              ? Image.file(
                  _storedImage!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : Text('Nenhuma Imagem!'),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            children: [
              TextButton.icon(
                icon: Icon(Icons.camera),
                label: Text('Tirar foto'),
                onPressed: _takePicture,
              ),
              TextButton.icon(
                icon: Icon(Icons.image),
                label: Text('Escolher da Galeria'),
                onPressed: _selectImageFromGallery,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
