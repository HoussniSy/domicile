import 'package:cached_network_image/cached_network_image.dart';
import 'package:domicile/model/service.dart';
import 'package:domicile/services/db.dart';
import 'package:domicile/ul/service_screen/comment/stream_comment_count.dart';
import 'package:domicile/ul/service_screen/serviceDetails.dart';
import 'package:domicile/ul/service_screen/updateService.dart';
import 'package:domicile/utils/constant.dart';
import 'package:domicile/utils/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SCard extends StatelessWidget {
  late Service srv;
  Color likeColor = Colors.grey;
  Color dislikeColor = Colors.grey;
  Icon favIcon = Icon(
    FontAwesomeIcons.heart,
    size: 20,
  );
  SCard({required this.srv});
  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;
    if (srv.like.contains(user?.uid)) {
      likeColor = Colors.lightBlue;
      dislikeColor = Colors.grey;
    } else if (srv.dislike.contains(user?.uid)) {
      dislikeColor = Colors.red;
      likeColor = Colors.grey;
    } else {
      dislikeColor = Colors.grey;
      likeColor = Colors.grey;
    }

    if (srv.favories.contains(user?.uid))
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
              builder: (ctx) => SrvDetail(
                s: srv,
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
                        image: CachedNetworkImageProvider(srv.images.first))),
                child: Container(
                  alignment: Alignment.topRight,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    color: Colors.white,
                    child: IconButton(
                      icon: favIcon,
                      onPressed: () async {
                        if (srv.favories.contains(user!.uid))
                          srv.favories.remove(user.uid);
                        else
                          srv.favories.add(user.uid);
                        await DBServices().updateservice(srv);
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
                              Text(srv.nom,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      height: 1)),
                              Text(srv.slogan),
                              Text(srv.detailSup),
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
                                if (srv.like.contains(user!.uid)) {
                                  srv.like.remove(user.uid);
                                } else if (srv.dislike.contains(user.uid)) {
                                  srv.dislike.remove(user.uid);
                                  srv.like.add(user.uid);
                                } else {
                                  srv.like.add(user.uid);
                                }
                                await DBServices().updateservice(srv);
                              },
                            ),
                            Text(srv.like.length.toString()),
                            IconButton(
                              icon: Icon(
                                FontAwesomeIcons.solidThumbsDown,
                                color: dislikeColor,
                                size: 20,
                              ),
                              onPressed: () async {
                                if (srv.dislike.contains(user!.uid)) {
                                  srv.dislike.remove(user.uid);
                                } else if (srv.like.contains(user.uid)) {
                                  srv.like.remove(user.uid);
                                  srv.dislike.add(user.uid);
                                } else {
                                  srv.dislike.add(user.uid);
                                }
                                await DBServices().updateservice(srv);
                              },
                            ),
                            Text(srv.dislike.length.toString()),
                            StreamProvider<int>.value(
                              value: DBServices().getCountComment(srv.id),
                              initialData: 0, // Provide an initial integer value here
                              child: StreamComment(service: srv),
                            )
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
                                content: "Voulez-vous supprimer " + srv.nom,
                                ok: () async {
                                  Navigator.of(context).pop();
                                  loading(context);
                                  bool delete =
                                  await DBServices().deleteservice(srv.id);
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
                                     UpdateService(s: srv)
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