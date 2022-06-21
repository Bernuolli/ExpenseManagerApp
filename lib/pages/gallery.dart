import 'dart:io';

import '../localization_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart';


class ImageGallery extends StatefulWidget{
  @override
  _ImageGallery_State createState() => _ImageGallery_State();
}

class _ImageGallery_State extends State<ImageGallery> {
  String lng = "English";
  var image;
  List imageArray = [];

  _openGallery() async{
    image = await ImagePicker().pickImage(source: ImageSource.camera);
    imageArray.add(image);
    setState(() {
      imageArray;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('main_title'.tr),
        actions: [
          DropdownButton<String>(
            items: LocalizationService.langs.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            value: this.lng,
            underline: Container(color: Colors.transparent),
            isExpanded: false,
            onChanged: (newVal) {
              setState(() {
                this.lng = newVal!;
                LocalizationService().changeLocale(newVal);
              });
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              child: Center(
                child: (
                  FlatButton(
                    color: Color(0xffadd8e6),
                    onPressed: () {
                      _openGallery();
                    },
                    child: Center(
                      child: (
                        Text('camera'.tr)
                      ),
                    ),
                  )
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * .8,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2
                )
              ),
              child: imageArray.isEmpty ? Center(
                child: Text('no_image'.tr)
              ) : GridView.count(
                crossAxisCount: 2,
                children: List.generate(imageArray.length, (index){
                  var img = imageArray[index];
                  File file = File( img.path );
                  return Image.file(file);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

