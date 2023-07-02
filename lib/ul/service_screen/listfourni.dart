import 'package:domicile/model/fournisseur.dart';
import 'package:domicile/ul/service_screen/addFourni.dart';
import 'package:domicile/utils/providerCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FourniListe extends StatefulWidget {
  @override
  State<FourniListe> createState() => _FourniListeState();
}

class _FourniListeState extends State<FourniListe> {
  @override
  Widget build(BuildContext context) {
    final List<Fourni> prvs = Provider.of<List<Fourni>>(context);
    print(prvs);
    return Scaffold(
      appBar: AppBar(
        title: Text("Liste de fournisseur"),
        backgroundColor: Colors.lightBlue),
      body: ListView.builder(
        itemCount: prvs.length,
        itemBuilder: (ctx,i) {
          final prv = prvs[i];
          return prvs == null
          ? CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlue),
          )
              :PCard(prv: prv);
        },
      ),
    floatingActionButton: FloatingActionButton(
    backgroundColor: Colors.lightBlue,
    child: Icon(Icons.add),
    onPressed: () {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => AddFourni()));
    }
    ),
    );
  }
}
