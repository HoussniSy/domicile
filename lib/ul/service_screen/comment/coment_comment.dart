import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domicile/model/comment.dart';
import 'package:domicile/model/user.dart';
import 'package:domicile/services/db.dart';
import 'package:domicile/ul/service_screen/comment/comment_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentCommentWidget extends StatelessWidget {
  Comment comment;
  UserM user;
  CommentCommentWidget({required this.comment, required this.user});
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final comments = Provider.of<List<Comment>>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Commentaire de ${user.pseudo}"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: comments == null
                  ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              )
                  : comments.length == 0
                  ? Center(
                child: Text("Aucun commentaire"),
              )
                  : ListView.builder(
                itemCount: comments.length,
                itemBuilder: (ctx, i) {
                  final comment = comments[i];
                  return CommentComponent(comment: comment);
                },
              )),
          Container(
            padding: EdgeInsets.all(5),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: commentController,
                    minLines: 1,
                    maxLines: 5,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                CircleAvatar(
                  radius: 25,
                  child: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () async {
                      bool commentOk = await DBServices().add_comment(Comment(
                          id_user: UserM.currentUser!.id,
                          id_comment: comment.id,
                          msg: commentController.text,
                          dislike: [],
                          id: '',
                          like: [],
                          id_comment_pub: '',
                          date_comment: null));
                      if (commentOk) commentController.clear();
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}