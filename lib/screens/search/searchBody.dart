import 'package:epicture/services/fetchSearch.dart';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchBody extends StatefulWidget {
  final Map authData;

  const SearchBody({Key key, this.authData}) : super(key: key);
  @override
  _SearchBodyState createState() => _SearchBodyState();
}

class _SearchBodyState extends State<SearchBody> {
  List images = List();
  FetchSearch fetchSearch;

  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void fetchData(String query) async {
    this.fetchSearch = FetchSearch(
        clientID: widget.authData['clientID'],
        username: widget.authData['accountUsername'],
        token: widget.authData['accessToken']);
    await fetchSearch.fetch(query);
    setState(() {
      this.images = fetchSearch.images;
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 20, 5, 20),
      child: FloatingSearchBar.builder(
        pinned: true,
        trailing: Icon(
          Icons.search,
        ),
        itemCount: this.images.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(17),
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
        onChanged: (String value) {
          this.fetchData(value);
        },
      ),
    );
  }
}
