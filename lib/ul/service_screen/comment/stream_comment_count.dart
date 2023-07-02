import 'package:domicile/model/comment.dart';
import 'package:domicile/model/fournisseur.dart';
import 'package:domicile/model/service.dart';
import 'package:domicile/model/user.dart';
import 'package:domicile/services/db.dart';
import 'package:domicile/ul/service_screen/comment/coment_comment.dart';
import 'package:domicile/ul/service_screen/comment/comment_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StreamComment extends StatelessWidget {
  Service service;

  StreamComment({required this.service});
  @override
  Widget build(BuildContext context) {
    final comment_lenght = Provider.of<int>(context);
    String count = "";
    if (comment_lenght != null) {
      count = comment_lenght > 1
          ? "$comment_lenght commentaires"
          : "$comment_lenght commentaire";
    }
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.message,
            color: Colors.grey,
            size: 20,
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => StreamProvider<List<Comment>>.value(
                  value: DBServices().gecomment(service.id),
                  initialData: [],
                  child: CommentWidget(
                    service: service,
                  ),
                )));
          },
        ),
        Text(count)
      ],
    );
  }
}

class StreamCommentComment extends StatelessWidget {
  Comment comment;
  UserM user;
  StreamCommentComment({required this.comment, required this.user});
  @override
  Widget build(BuildContext context) {
    final comment_lenght = Provider.of<int>(context);
    int count = 0;
    if (comment_lenght != null) {
      count = comment_lenght;
    }
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.message,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => StreamProvider<List<Comment>>.value(
                  value: DBServices().gecommentComment(comment.id),
                  initialData: [],
                  child: CommentCommentWidget(
                      comment: comment, user: this.user),
                )));
          },
        ),
        Text("$count", style: TextStyle(fontSize: 17, color: Colors.white))
      ],
    );
  }
}