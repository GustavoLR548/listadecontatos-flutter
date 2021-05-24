import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:listadecontatos/widgets/imagePicker/modalBottomSheet.dart';
import 'package:listadecontatos/widgets/misc/icontext.dart';
import 'package:image_cropper/image_cropper.dart';

final placeholder = File('assets/images/icon.jpg');

class PickUserImage extends StatefulWidget {
  final void Function(String pickedImage) sendImageData;
  final String? initialValue;
  PickUserImage(this.sendImageData, {this.initialValue});

  @override
  _PickUserImageState createState() => _PickUserImageState();
}

class _PickUserImageState extends State<PickUserImage> {
  File? _pickedImage;
  String? initialValue;

  void initState() {
    super.initState();
    if (widget.initialValue != null) this.initialValue = widget.initialValue;
  }

  void _pickAndFormatImage() async {
    final picker = ImagePicker();

    ImageSource? imageSource = await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => ModalBottomSheet());

    if (imageSource == null) return;

    final pickedImage = await picker.getImage(
      source: imageSource,
    );
    if (pickedImage == null) return;
    final pickedImageFile = File(pickedImage.path);
    File? croppedFile = await cropUserSelectedImage(pickedImageFile.path);

    if (croppedFile == null) return;
    setState(() {
      _pickedImage = croppedFile;
    });
    widget.sendImageData(_pickedImage?.path ?? placeholder.path);
  }

  Future<File?> cropUserSelectedImage(String path) async =>
      await ImageCropper.cropImage(
          maxHeight: 250,
          maxWidth: 250,
          compressQuality: 80,
          sourcePath: path,
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

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey,
        backgroundImage: buildImage(),
      ),
      TextButton(
        onPressed: _pickAndFormatImage,
        child: IconText('Selecionar Imagem', Icons.image),
      )
    ]);
  }

  ImageProvider buildImage() {
    if (initialValue != null && _pickedImage == null)
      return NetworkImage(initialValue ?? '');
    else if (_pickedImage != null)
      return FileImage(_pickedImage ?? placeholder);

    return AssetImage(placeholder.path);
  }
}
