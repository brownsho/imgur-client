import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/userInfo.dart';
import 'package:epicture/services/fetchUploadImages.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imgur/imgur.dart' as imgur;

class UserBody extends StatefulWidget {
  final String accessToken;

  @override
  UserBody({this.accessToken}) : super();

  @override
  _UserBodyState createState() => _UserBodyState();
}

class _UserBodyState extends State<UserBody> {
  UserInfo userInfo;
  FetchUploadImages favorites;
  String username = '';
  String email = '';
  List images = List();
  bool isLoading = true;
  File _image;
  final picker = ImagePicker();
  String avatar =
      'https://i.imgur.com/XzARrBw_d.png?maxwidth=290&fidelity=grand';

  @override
  void initState() {
    super.initState();
    setUserInfo();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void setFavorites() async {
    favorites =
        FetchUploadImages(accessToken: widget.accessToken, username: username);
    await favorites.fetch();
    setState(() {
      this.images = favorites.images;
      this.isLoading = false;
    });
  }

  Future<void> setUserInfo() async {
    userInfo = UserInfo(accessToken: widget.accessToken);
    await userInfo.getUser();
    setState(() {
      username = userInfo.username;
      email = userInfo.email;
      avatar = userInfo.avatarLink;
    });
    setFavorites();
  }

  Future<void> uploadImage(bool camera) async {
    dynamic file;

    if (camera) {
      file = await picker.getImage(source: ImageSource.camera);
    } else {
      file = await picker.getImage(source: ImageSource.gallery);
    }

    setState(() {
      this.isLoading = true;
    });

    final client =
        imgur.Imgur(imgur.Authentication.fromToken(widget.accessToken));
    if (file != null) {
      await client.image
          .uploadImage(imageFile: File(file.path))
          .then((value) => print('Uploaded image to: ${value.link}'));
    }

    setState(() {
      if (file != null) {
        this.setFavorites();
      }
    });
  }

  Future<dynamic> openDialog() async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.cloud_upload),
                SizedBox(width: 10),
                Text(
                  'Upload an image',
                  style: TextStyle(fontSize: 13, fontFamily: 'Montserrat'),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    FlatButton(
                      child: Row(
                        children: [
                          Icon(Icons.camera),
                          SizedBox(width: 10),
                          Text(
                            'Take a photo',
                            style: TextStyle(
                                fontSize: 11, fontFamily: 'Montserrat'),
                          )
                        ],
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await this.uploadImage(true);
                      },
                    ),
                    SizedBox(height: 1),
                    FlatButton(
                      child: Row(
                        children: [
                          Icon(Icons.photo_album),
                          SizedBox(width: 10),
                          Text(
                            'Choose from gallery',
                            style: TextStyle(
                                fontSize: 11, fontFamily: 'Montserrat'),
                          )
                        ],
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await this.uploadImage(false);
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    if (this.isLoading)
      return Center(
        child: CircularProgressIndicator(
            backgroundColor: Color(0xff2EE3B8),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
      );
    else
      return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.control_point),
          backgroundColor: Color(0xff2EE3B8),
          onPressed: () async {
            await this.openDialog();
          },
          label: Text('Upload'),
        ),
        body: ListView.builder(
            itemCount: 1,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(avatar),
                        radius: 40,
                      ),
                    ),
                    Divider(
                      height: 60,
                      color: Colors.grey[800],
                    ),
                    Text(
                      'NAME',
                      style: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 2.0,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '$username',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 10,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Email',
                      style: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 2.0,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.email,
                          color: Colors.grey[400],
                        ),
                        SizedBox(width: 10),
                        Text(
                          '$email',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 10,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Your uploads',
                      style: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 2.0,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: images.map((e) {
                        return Padding(
                          padding: const EdgeInsets.all(12),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: ClipRRect(
                                    child: Image.network(
                                      e,
                                      width: 400,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    // )
                  ],
                ),
              );
            }),
      );
  }
}
