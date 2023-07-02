import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domicile/model/comment.dart';
import 'package:domicile/model/service.dart';
import 'package:domicile/model/user.dart';
import 'package:domicile/services/db.dart';
import 'package:domicile/ul/service_screen/comment/comment_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentWidget extends StatelessWidget {
  Service service;
  CommentWidget({required this.service});
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final comments = Provider.of<List<Comment>>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Liste des commentaires"),
        backgroundColor: Colors.green,
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
                child: Text("Aucune voitures"),
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
                  backgroundColor: Colors.green,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () async {
                      bool commentOk = await DBServices().add_comment(Comment(
                          id_comment_pub: service.id,
                          id_user: UserM.currentUser!.id,
                          msg: commentController.text,
                          dislike: [],
                          id: '',
                          id_comment: '',
                          like: [],
                          date_comment: null
                      ));
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