import 'package:domicile/model/service.dart';
import 'package:domicile/model/user.dart';
import 'package:domicile/utils/serviceCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailUser extends StatelessWidget {
  final UserM user;
  DetailUser({required this.user});
  @override
  Widget build(BuildContext context) {
    final List<Service> srvs = Provider.of<List<Service>>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Informations de l'utilisateur"),
      ),
      body: srvs == null
          ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
        ),
      )
          : ListView.builder(
          padding: EdgeInsets.only(top: 10),
          itemCount: srvs.length + 1,
          itemBuilder: (_, i) {
            if (i == 0) {
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.red,
                      backgroundImage: user.image != null
                          ? NetworkImage(user.image)
                          : null,
                      child: user.image != null
                          ? Container()
                          : Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                  Text(
                    "Pseudo: ${user.pseudo}",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text("Email: ${user.emailController}",
                      style: Theme.of(context).textTheme.headline6),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(top: 20, left: 10),
                    child: Text("Publications: ${srvs.length}",
                        style: Theme.of(context).textTheme.headline6),
                  ),
                ],
              );
            } else {
              final srv = srvs[i - 1];
              return i == srvs.length
                  ? Container(
                child: SCard(srv: srv),
                margin: EdgeInsets.only(bottom: 80),
              )
                  : SCard(srv: srv);
            }
          }),
    );
  }
}