import 'package:domicile/model/comment.dart';
import 'package:domicile/model/user.dart';
import 'package:domicile/services/db.dart';
import 'package:domicile/ul/service_screen/comment/stream_comment_count.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CommentComponent extends StatefulWidget {
  Comment comment;
  CommentComponent({required this.comment});

  @override
  _CommentComponentState createState() => _CommentComponentState();
}

class _CommentComponentState extends State<CommentComponent> {
  late UserM userPost;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  getUser() async {
    final u = await DBServices().getUser(widget.comment.id_user);
    if (u != null) {
      userPost = u;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(top: 10, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (userPost != null)
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey,
              backgroundImage:
              userPost.image != null ? NetworkImage(userPost.image) : null,
              child: userPost.image != null
                  ? Container()
                  : Icon(Icons.person, color: Colors.black),
            ),
          Container(
            margin: EdgeInsets.only(left: 10),
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (userPost != null)
                  Text(
                    "${userPost.pseudo}",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellowAccent),
                  ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 3),
                  color: Colors.black.withOpacity(.3),
                  height: 1,
                  width: width / 1.5,
                ),
                Container(
                  alignment: Alignment.centerRight,
                  width: width / 1.5,
                  child: Text(
                    "${widget.comment.msg}",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        FontAwesomeIcons.solidThumbsUp,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () async {},
                    ),
                    Text("0",
                        style: TextStyle(fontSize: 17, color: Colors.white)),
                    IconButton(
                      icon: Icon(
                        FontAwesomeIcons.solidThumbsDown,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () async {},
                    ),
                    Text("0",
                        style: TextStyle(fontSize: 17, color: Colors.white)),
                    StreamProvider<int>.value(
                      value: DBServices()
                          .getCountCommentComment(widget.comment.id),
                      initialData: 0,
                      child: StreamCommentComment(
                        comment: widget.comment,
                        user: userPost,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}