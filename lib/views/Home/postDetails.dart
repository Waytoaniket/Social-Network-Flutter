import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:socail_network_flutter/services/constant.dart';
import 'package:socail_network_flutter/views/Home/widgets/commentList.dart';
import 'package:socail_network_flutter/views/Home/widgets/userInfoDetail.dart';
import 'package:socail_network_flutter/views/Home/widgets/widgetsDetail.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:socail_network_flutter/services/Database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostDetails extends StatefulWidget {
  final String postId, userId;

  PostDetails({@required this.postId, @required this.userId});
  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  static String uid, comment = '1';
  MaterialColor flag = Colors.grey;
  TextEditingController commentController = new TextEditingController();
  DatabaseMethods _databaseMethods = DatabaseMethods();
  getUserId() async {
    if (!mounted) return;
    await SharedPreferences.getInstance().then((value) => {
          this.setState(() {
            uid = value.getString('id');
          })
        });
  }

  @override
  void initState() {
    getUserId();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildListView(),
    );
  }

  ListView buildListView() {
    return ListView(padding: EdgeInsets.only(top: 35), children: <Widget>[
      Container(
          child: StreamBuilder(
              stream: Firestore.instance
                  .collection('posts')
                  .document(widget.postId)
                  .snapshots(),
              builder: (context, snapshot) {
                var post = snapshot.data;
                if (post == null) {
                  return Text('Loading');
                }
                return buildDetailStream(context, post);
              })),
      CommentList(comments: _databaseMethods.getComments(widget.postId)),
    ]);
  }

  Column buildDetailStream(BuildContext context, post) {
    return Column(children: <Widget>[
      buildUserInfo(context, post),
      buildUserDesc(post),
      buildUserImage(post),
      buildUserVideo(post),
      Column(
        children: <Widget>[
          SizedBox(height: 10),
          LikeAndShare(
              postId: widget.postId,
              desc: post['description'],
              name: post['displayName']),
        ],
      ),
      Column(
        children: <Widget>[
          Divider(
              thickness: 1,
              color: Colors.grey.shade500,
              indent: 15,
              endIndent: 15),
          Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text(
                  'Comments',
                  style: TextStyle(
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
                ),
              )),
          Divider(
              thickness: 1,
              color: Colors.grey.shade500,
              indent: 15,
              endIndent: 15),
        ],
      ),
      buildCommentInput(),
    ]);
  }

  Row buildCommentInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 25,
          backgroundImage: NetworkImage(Constants.photoUrl),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
          child: Container(
            width: 300,
            color: Colors.white,
            child: Container(
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: commentController,
                decoration: InputDecoration(
                  hintText: "Add Comment",
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  fillColor: Colors.grey.shade100,
                  contentPadding: EdgeInsets.all(8),
                  border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  if (value.length >= 1) {
                    setState(() {
                      flag = Colors.blue;
                      comment = value;
                    });
                  } else {
                    setState(() {
                      comment = value;
                      flag = Colors.grey;
                    });
                  }
                },
              ),
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.send,
            size: 35,
          ),
          color: flag,
          onPressed: () {
            if (comment.length >= 1) {
              uploadComment(comment, uid, widget.postId);
              Fluttertoast.showToast(msg: 'Comment Successful');
              commentController.clear();
              setState(() {
                comment = '';
                flag = Colors.grey;
              });
            } else {
              Fluttertoast.showToast(msg: 'Comment is too Short!');
            }
          },
        )
      ],
    );
  }
}
