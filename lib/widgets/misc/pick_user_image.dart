import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:listadecontatos/widgets/misc/icontext.dart';
import 'package:image_cropper/image_cropper.dart';

final placeholder = File('assets/images/icon.jpg');

class PickUserImage extends StatefulWidget {
  final void Function(File pickedImage) sendImageData;
  final ImageSource imageSource;
  final File? initialValue;
  PickUserImage(this.sendImageData,
      {this.imageSource = ImageSource.camera, this.initialValue});

  @override
  _PickUserImageState createState() => _PickUserImageState();
}

class _PickUserImageState extends State<PickUserImage> {
  File? _pickedImage;

  void initState() {
    super.initState();
    if (widget.initialValue != null) _pickedImage = widget.initialValue;
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: widget.imageSource,
    );
    if (pickedImage == null) return;
    final pickedImageFile = File(pickedImage.path);
    File? croppedFile = await ImageCropper.cropImage(
        maxHeight: 250,
        maxWidth: 250,
        compressQuality: 80,
        sourcePath: pickedImageFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Recorte sua imagem',
            toolbarColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Theme.of(context).accentColor,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    if (croppedFile == null) return;
    setState(() {
      _pickedImage = croppedFile;
    });
    widget.sendImageData(_pickedImage ?? placeholder);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey,
        backgroundImage: _pickedImage == null
            ? AssetImage(placeholder.path) as ImageProvider
            : FileImage(_pickedImage ?? placeholder),
      ),
      TextButton(
        onPressed: _pickImage,
        child: IconText('Selecionar Imagem', Icons.image),
      )
    ]);
  }
}
