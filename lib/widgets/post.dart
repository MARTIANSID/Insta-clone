import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluffy/models/user.dart';
import 'package:fluffy/pages/home.dart';
import 'package:fluffy/widgets/progress.dart';
import 'package:flutter/material.dart';

class Post extends StatefulWidget {
  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String medialUrl;
  final Map<String, bool> likes;

  Post({
    this.postId,
    this.ownerId,
    this.username,
    this.location,
    this.description,
    this.medialUrl,
    this.likes,
  });
factory Post.fromDocument(DocumentSnapshot doc){

  return Post(
    postId: doc['postId'],
    ownerId: doc['ownerId'],
    username: doc['username'],
    location: doc['location'],
    description: doc['description'],
    medialUrl: doc['medialUrl'],
    

  );
}
  int noOfLLikes(likes) {
    if (likes == 0) {
      return 0;
    }
    int count = 0;
    likes.forEach((key, value) {
      if (value == true) {
        count++;
      }
    });
    return count;
  }

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: usersRef.document(widget.ownerId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        } else {
          User user = User.fromDocument(snapshot.data);
          return Column(children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: CachedNetworkImageProvider(user.photoUrl),
              ),
              title: Text(
                widget.username,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                widget.location,
                style: TextStyle(color: Colors.white),
              ),
            ),
            Divider(
              height: 2.0,
              color: Colors.white54,
            ),
            Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.60,
                child: Image.network(
                  widget.medialUrl,
                  fit: BoxFit.cover,
                )),
            SizedBox(
              height: 30,
            ),
            Row(children: <Widget>[
              Icon(
                Icons.favorite,
              ),
              Icon(Icons.message)
            ])
          ]);
        }
      },
    );
  }
}
