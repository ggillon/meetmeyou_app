import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';

class ImageCrop extends StatefulWidget {
  const ImageCrop({Key? key, required this.image}) : super(key: key);
  final File image;

  @override
  _ImageCropState createState() => _ImageCropState();
}

class _ImageCropState extends State<ImageCrop> {
  File? _croppedFile;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 0.8 * screenWidth,
                      maxHeight: 0.7 * screenHeight,
                    ),
                    child: Image.file(_croppedFile == null ? widget.image : _croppedFile!)),
              ),
            ),
            const SizedBox(height: 24.0),
            _menu(),
          ],
        ),
      )
    );
  }

  Widget _menu() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: "delete",
          onPressed: () {
         setState(() {
           _croppedFile = null;
           Navigator.of(context).pop(_croppedFile);
         });
          },
          backgroundColor: Colors.redAccent,
          tooltip: 'Delete',
          child: const Icon(Icons.delete),
        ),
     //   _croppedFile == null ?
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: FloatingActionButton(
              heroTag: "crop",
              onPressed: () {
                _cropImage();
              },
              backgroundColor: const Color(0xFFBC764A),
              tooltip: 'Crop',
              child: const Icon(Icons.crop),
            ),
          ),
            //:
        Padding(
          padding: const EdgeInsets.only(left: 32.0),
          child: FloatingActionButton(
            heroTag: "done",
            onPressed: () {
              Navigator.of(context).pop(_croppedFile ?? widget.image);
            },
            backgroundColor: ColorConstants.primaryColor,
            tooltip: 'Done',
            child: const Icon(Icons.done),
          ),
        )
      ],
    );
  }

  Future<Null> _cropImage() async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: widget.image.path,
    //  aspectRatio: CropAspectRatio(ratioX: 2, ratioY: 1),
      aspectRatioPresets: Platform.isAndroid
      ? [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
      ]
      : [
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio5x3,
      CropAspectRatioPreset.ratio5x4,
      CropAspectRatioPreset.ratio7x5,
      CropAspectRatioPreset.ratio16x9
      ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      // androidUiSettings: AndroidUiSettings(
      //     toolbarTitle: 'Cropper',
      //     toolbarColor: Colors.deepOrange,
      //     toolbarWidgetColor: Colors.white,
      //     initAspectRatio: CropAspectRatioPreset.original,
      //     lockAspectRatio: false),
      // iosUiSettings:IOSUiSettings(
      //   title: 'Cropper',
      // )
    );
    if (croppedFile != null) {
      _croppedFile = File(croppedFile.path);
      setState(() {});
    }
  }
}
