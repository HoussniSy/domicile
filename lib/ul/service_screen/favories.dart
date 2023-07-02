
import 'package:domicile/model/service.dart';
import 'package:domicile/utils/serviceCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Favories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Service> services = Provider.of<List<Service>>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text("Mes favories"),
        ),
        body: services == null
            ? Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          ),
        )
            : services.length == 0
            ? Center(
          child: Text("Aucun favories"),
        )
            : ListView.builder(
          itemCount: services.length,
          itemBuilder: (ctx, i) {
            final srv = services[i];
            return i == services.length - 1
                ? Container(
              child: SCard(srv: srv),
              margin: EdgeInsets.only(bottom: 80),
            )
                : SCard(srv: srv);
          },
        ));
  }
}