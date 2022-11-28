import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:karaoke_real_one/pages/Screen-Profile/profile_widget.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:karaoke_real_one/fb_connect.dart';
import 'package:getwidget/getwidget.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  PlatformFile? pickedFile;

  final _userNameController = TextEditingController();
  final _userImageController = TextEditingController();

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  // final result = FilePicker.platform.pickFiles();

  @override
  void dispose() {
    _userNameController.dispose();
    _userImageController.dispose();
    super.dispose();
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Widget build(BuildContext context) => Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(
            "Edit Profile",
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          leading: BackButton(),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Column(
              children: [
                const SizedBox(height: 120),
                if (pickedFile == null)
                  Container(
                    child: noImage(),
                  ),
                if (pickedFile != null)
                  Container(
                    child: Stack(
                      children: [
                        haveImage(),
                        Positioned(
                          bottom: 0,
                          right: 4,
                          child: buildEditIcon(Colors.black),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 150),
                selectFileBtn(),
                SizedBox(height: 20),
                uploadFileBtn(),
              ],
            ),
          ),
        ),
      );

  Widget noImage() {
    return ProfileWidget(
      imagePath:
          'https://i.pinimg.com/280x280_RS/2e/45/66/2e4566fd829bcf9eb11ccdb5f252b02f.jpg',
      isEdit: true,
      onClicked: selectFile,
    );
  }

  Widget haveImage() {
    final image = File(pickedFile!.path!);

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Image.file(
          File(pickedFile!.path!),
          fit: BoxFit.cover,
          width: 128,
          height: 128,
        ),
      ),
    );
  }

  Widget selectFileBtn() {
    return GFButton(
      color: Colors.green,
      blockButton: false,
      fullWidthButton: true,
      shape: GFButtonShape.pills,
      text: "Select Image",
      onPressed: selectFile,
    );
  }

  Widget uploadFileBtn() {
    return GFButton(
      color: Colors.green,
      blockButton: false,
      fullWidthButton: true,
      shape: GFButtonShape.pills,
      text: "Upload Image",
      onPressed: () async {
        if (pickedFile != null) {
          await uploadfile("userName");
        } else {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                    content: Stack(children: [
                  Text('Pls select your new Profile picture!'),
                ]));
              });
        }
      },
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.black,
        all: 3,
        child: buildCircle(
          color: Color.fromARGB(255, 0, 255, 8),
          all: 8,
          child: Icon(
            Icons.add_a_photo,
            color: Colors.black,
            size: 20,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );

  Future uploadfile(String userName) async {
    final storageRef = FirebaseStorage.instance.ref();
    final mountainsRef =
        storageRef.child("users_img/" + userName + "-profile-pics.jpg");
    File myPics = File(pickedFile!.path!);
    try {
      await mountainsRef.putFile(myPics);
    } catch (e) {}
    final img_url = await storageRef
        .child("users_img/" + userName + "-profile-pics.jpg")
        .getDownloadURL();
    await updatePics(img_url.toString());
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: Stack(children: [
            Text('Changing profile picture is successed!'),
          ]));
        });
  }

  Future updatePics(String img) async {
    final user = FirebaseAuth.instance.currentUser!;
    String msg = await fb_connect().updatePics(user.uid, img);
  }

  Future updateUserName(String userName) async {
    final user = FirebaseAuth.instance.currentUser!;
    String msg = await fb_connect().updateUserName(user.uid, userName);
  }
}
