import 'package:cached_network_image/cached_network_image.dart';
import 'package:domicile/model/fournisseur.dart';
import 'package:domicile/services/db.dart';
import 'package:domicile/ul/service_screen/comment/stream_comment_count.dart';
import 'package:domicile/ul/service_screen/fourniseurDetail.dart';
import 'package:domicile/ul/service_screen/updateFourni.dart';
import 'package:domicile/utils/constant.dart';
import 'package:domicile/utils/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class PCard extends StatelessWidget {
  Fourni prv;
  Color likeColor = Colors.grey;
  Color dislikeColor = Colors.grey;
  Icon favIcon = Icon(
    FontAwesomeIcons.heart,
    size: 20,
  );
  PCard({required this.prv});
  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;
    if (prv.like.contains(user?.uid)) {
      likeColor = Colors.lightBlue;
      dislikeColor = Colors.grey;
    } else if (prv.dislike.contains(user?.uid)) {
      dislikeColor = Colors.red;
      likeColor = Colors.grey;
    } else {
      dislikeColor = Colors.grey;
      likeColor = Colors.grey;
    }

    if (prv.favories.contains(user?.uid))
      favIcon = Icon(
        FontAwesomeIcons.solidHeart,
        size: 20,
        color: Colors.red,
      );
    else
      favIcon = Icon(
        FontAwesomeIcons.heart,
        size: 20,
        color: Colors.teal,
      );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => PrvDetail(
                f: prv,
              )));
        },
        child: Column(
          children: [
            Container(
              height: 100,
              width: 700,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(prv.images.first))),
              child: Container(
                alignment: Alignment.topRight,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  color: Colors.white,
                  child: IconButton(
                    icon: favIcon,
                    onPressed: () async {
                      if (prv.favories.contains(user!.uid))
                        prv.favories.remove(user.uid);
                      else
                        prv.favories.add(user.uid);
                      await DBServices().updatefourni(prv);
                    },
                  ),
                ),
              ),
              // child: ,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10, top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(prv.nom,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    height: 1)),
                            Text(prv.adresse),
                            Text(prv.competence),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              FontAwesomeIcons.solidThumbsUp,
                              color: likeColor,
                              size: 20,
                            ),
                            onPressed: () async {
                              if (prv.like.contains(user!.uid)) {
                                prv.like.remove(user.uid);
                              } else if (prv.dislike.contains(user.uid)) {
                                prv.dislike.remove(user.uid);
                                prv.like.add(user.uid);
                              } else {
                                prv.like.add(user.uid);
                              }
                              await DBServices().updatefourni(prv);
                            },
                          ),
                          Text(prv.like.length.toString()),
                          IconButton(
                            icon: Icon(
                              FontAwesomeIcons.solidThumbsDown,
                              color: dislikeColor,
                              size: 20,
                            ),
                            onPressed: () async {
                              if (prv.dislike.contains(user!.uid)) {
                                prv.dislike.remove(user.uid);
                              } else if (prv.like.contains(user.uid)) {
                                prv.like.remove(user.uid);
                                prv.dislike.add(user.uid);
                              } else {
                                prv.dislike.add(user.uid);
                              }
                              await DBServices().updatefourni(prv);
                            },
                          ),
                          Text(prv.dislike.length.toString()),
                        ],
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          mydialog(context,
                              title: "Suppression",
                              content: "Voulez-vous supprimer " + prv.adresse,
                              ok: () async {
                                Navigator.of(context).pop();
                                loading(context);
                                bool delete =
                                await DBServices().deleteservice(prv.id);
                                if (delete != null) {
                                  Navigator.of(context).pop();
                                }
                              });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.cyan),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) =>
                                  UpdateFourni(f: prv)
                          ));
                        },
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
