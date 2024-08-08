import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickImage});

  final void Function(File image) onPickImage;

  @override
  State<UserImagePicker> createState() {
    return _UserImagePickerState();
  }
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _userImage;

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _userImage = File(pickedImage.path);
    });

    widget.onPickImage(_userImage!);
  }

  void _openBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Container(
            padding: const EdgeInsets.only(top: 12),
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage();
                  },
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage: _userImage != null ? FileImage(_userImage!) : null,
        ),
        if (_userImage == null)
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            left: 0,
            child: IconButton(
              onPressed: _openBottomSheet,
              icon: const Icon(Icons.camera_alt),
            ),
          ),
        // TextButton.icon(
        //   onPressed: _openBottomSheet,
        //   icon: const Icon(Icons.image),
        //   label: Text(
        //     'Add image',
        //     style: TextStyle(
        //       color: Theme.of(context).colorScheme.primary,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
