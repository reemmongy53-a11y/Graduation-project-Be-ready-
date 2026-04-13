import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_project/core/user_session/user_session.dart';
import 'package:new_project/design/AppColor.dart';
import 'package:new_project/design/AppImage.dart';
import 'package:new_project/providers/ThemeProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DataFile extends StatefulWidget {
  const DataFile({super.key, required this.name, required this.email});

  final String name;
  final String email;

  @override
  State<DataFile> createState() => _DataFileState();
}

class _DataFileState extends State<DataFile> {
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('profile_image');
    if (path != null && File(path).existsSync()) {
      setState(() {
        selectedImage = File(path);
      });
    }
  }


  Future<void> _saveImage(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image', path);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 1.0,
                  ),
                  child: InkWell(
                    onTap: () async {
                      final picker = ImagePicker();
                      final image = await picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (image != null) {
                        await _saveImage(image.path);
                        setState(() {
                          selectedImage = File(image.path);
                        });
                      }
                    },
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: selectedImage != null
                          ? FileImage(selectedImage!)
                          : AssetImage(AppImage.person) as ImageProvider,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome, ${widget.name}!',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: AppColor.royalBlue),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        Text(
                          UserSession.email,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                            color: Provider.of<ThemeProvider>(context).isDarkMode ? AppColor.softGray : AppColor.gray,
                        ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}