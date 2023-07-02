import 'package:domicile/model/service.dart';
import 'package:domicile/model/user.dart';
import 'package:domicile/services/db.dart';
import 'package:domicile/utils/slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart';


class SrvDetail extends StatefulWidget {
  late final Service s;
  @override
  final key = GlobalKey<ScaffoldState>();
  SrvDetail({required this.s});

  @override
  State<SrvDetail> createState() => _SrvDetailState();
}

class _SrvDetailState extends State<SrvDetail> {
  Color color = Colors.green;

  late UserM user;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        title: Text(widget.s.nom),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Sliders(imgs: widget.s.images),
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.s),
              title: Text(
                widget.s.nom,
                style: TextStyle(fontSize: 20),
                semanticsLabel: widget.s.slogan,
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

