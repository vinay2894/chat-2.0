import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DetailPageController extends ChangeNotifier {
  File? image;

  void addImage({required File img}) {
    image = img;
    notifyListeners();
  }
}
