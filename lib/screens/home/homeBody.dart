import 'package:epicture/services/fetchGallery.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeBody extends StatefulWidget {
  final Map authData;

  const HomeBody({Key key, this.authData}) : super(key: key);
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  FetchGallery gallery;
  List images = List();
  bool isLoading = true;

  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    gallery = FetchGallery(
        clientID: widget.authData['clientID'],
        token: widget.authData['accessToken'],
        username: widget.authData['accountUsername']);
    fetchData();
  }

  void fetchData() async {
    await gallery.fetch();
    setState(() {
      this.images = gallery.images;
      this.isLoading = false;
    });
  }

  void handleFavorite(bool isLiked, Map image, String imageId) {
    if (isLiked) {
      setState(() {
        image['favorite_count']--;
        image['iconFavoriteColor'] = Colors.black;
        image['isLiked'] = false;
        http.post('https://api.imgur.com/3/image/$imageId/favorite', headers: {
          'Authorization': 'Bearer ${widget.authData['accessToken']}'
        });
      });
    } else {
      setState(() {
        image['iconFavoriteColor'] = Colors.red;
        image['favorite_count']++;
        image['isLiked'] = true;
        http.post('https://api.imgur.com/3/image/$imageId/favorite', headers: {
          'Authorization': 'Bearer ${widget.authData['accessToken']}'
        });
      });
    }
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
      return Container(
        child: ListView.builder(
          itemCount: this.images.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(12),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      child: Image.network(this.images[index]['link']),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            this.images[index]['title'],
                            style: TextStyle(fontFamily: 'Montserrat'),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.remove_red_eye_outlined,
                                color: Colors.grey[800],
                              ),
                              SizedBox(width: 5),
                              Text(
                                this.images[index]['views'].toString(),
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Color(0xff2EE3B8),
                                ),
                              ),
                              SizedBox(width: 20),
                              Icon(
                                Icons.mode_comment_outlined,
                                color: Colors.grey[800],
                              ),
                              SizedBox(width: 5),
                              Text(
                                this.images[index]['comment_count'].toString(),
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Color(0xff2EE3B8),
                                ),
                              ),
                              SizedBox(width: 20),
                              IconButton(
                                icon: Icon(Icons.favorite_outline),
                                color: this.images[index]['iconFavoriteColor'],
                                onPressed: () => {
                                  this.handleFavorite(
                                      this.images[index]['isLiked'],
                                      this.images[index],
                                      this.images[index]['id'])
                                },
                              ),
                              SizedBox(width: 5),
                              Text(
                                this.images[index]['favorite_count'].toString(),
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Color(0xff2EE3B8),
                                ),
                              ),
                              SizedBox(width: 30),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.thumb_up,
                                          size: 15,
                                        ),
                                        padding: EdgeInsets.zero,
                                        constraints: BoxConstraints(),
                                        onPressed: () => {},
                                      ),
                                      Text(
                                        this.images[index]['ups'].toString(),
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Color(0xff2EE3B8),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.thumb_down,
                                          size: 15,
                                        ),
                                        padding: EdgeInsets.zero,
                                        constraints: BoxConstraints(),
                                        onPressed: () => {},
                                      ),
                                      Text(
                                        this.images[index]['downs'].toString(),
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Color(0xff2EE3B8),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
  }
}
