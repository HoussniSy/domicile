import 'package:domicile/model/fournisseur.dart';
import 'package:domicile/model/service.dart';
import 'package:domicile/model/user.dart';
import 'package:domicile/services/db.dart';
import 'package:domicile/utils/slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart';


class PrvDetail extends StatefulWidget {
  late final Fourni f;
  @override
  final key = GlobalKey<ScaffoldState>();
  PrvDetail({required this.f});

  @override
  State<PrvDetail> createState() => _PrvDetailState();
}

class _PrvDetailState extends State<PrvDetail> {
  Color color = Colors.lightBlue;

  late UserM user;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        title: Text(widget.f.nom),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Sliders(imgs: widget.f.images),
            SizedBox(
              height: 10,
            ),
            ListTile(
                leading: Icon(FontAwesomeIcons.s),
                title: Text(
                  widget.f.nom,
                  style: TextStyle(fontSize: 20),
                  semanticsLabel: widget.f.adresse,
                )
            ),
            Divider(
              color: Colors.black,
            ),
            Text("User"),
            Divider(
              color: Colors.black,
            ),
            if (user != null)
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: color,
                  backgroundImage:
                  user.image != null ? NetworkImage(user.image) : null,
                  child: user.image != null
                      ? Container()
                      : Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  radius: 30,
                ),
                subtitle: Text(user.emailController),
                title: Text(
                  user.pseudo,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  ListTile item(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}

