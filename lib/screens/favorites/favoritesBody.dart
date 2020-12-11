import 'package:epicture/services/fetchFavorites.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FavoritesBody extends StatefulWidget {
  final Map authData;

  const FavoritesBody({Key key, this.authData}) : super(key: key);
  @override
  _FavoritesBodyState createState() => _FavoritesBodyState();
}

class _FavoritesBodyState extends State<FavoritesBody> {
  List images = List();
  FetchFavorites fetchFavorites;
  bool isLoading = true;

  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchFavorites = FetchFavorites(
        token: widget.authData['accessToken'],
        username: widget.authData['accountUsername']);
    this.fetchData();
  }

  void fetchData() async {
    await fetchFavorites.fetch();
    setState(() {
      this.images = fetchFavorites.images;
      this.isLoading = false;
    });
  }

  void handleUnlike(String imageId, index) {
    setState(() {
      http.post('https://api.imgur.com/3/image/$imageId/favorite', headers: {
        'Authorization': 'Bearer ${widget.authData['accessToken']}'
      });
      this.images.removeAt(index);
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      child: Image.network(this.images[index]['link']),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
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
                              IconButton(
                                icon: Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                                onPressed: () => this.handleUnlike(
                                    this.images[index]['id'], index),
                              ),
                              SizedBox(width: 5),
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
