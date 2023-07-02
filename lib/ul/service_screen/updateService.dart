import 'dart:io';

import 'package:domicile/model/service.dart';
import 'package:domicile/services/db.dart';
import 'package:domicile/utils/getImage.dart';
import 'package:domicile/utils/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UpdateService extends StatefulWidget {
  late Service s;
  UpdateService({required this.s});
  @override
  _UpdateServiceState createState() => _UpdateServiceState();
}

class _UpdateServiceState extends State<UpdateService> {
  final key = GlobalKey<FormState>();
  late String nom, slogan, prix, descrition, statut, tel;
  List<dynamic> images = [];

  Service srv = Service(detailSup: '', images: [], nom: '', slogan: '', prix: '', id: '', uid: '', tel: '', statut: '', dislike: [], like: [], favories: []);
  void initState() {
    // TODO: implement initState
    super.initState();
    nom = widget.s.nom;
    prix = widget.s.prix;
    slogan = widget.s.slogan;
    descrition = widget.s.detailSup;
    images.addAll(widget.s.images);
    srv = widget.s;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Modifier " + widget.s.nom),
          backgroundColor: Colors.green,
          actions: [Icon(FontAwesomeIcons.motorcycle)],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Form(
              key: key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    initialValue: nom,
                    validator: (e) => e!.isEmpty ? "Remplir se champ" : null,
                    onChanged: (e) => nom = e,
                    decoration: InputDecoration(
                        hintText: "Nom du service",
                        labelText: "Nom",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    initialValue: slogan,
                    validator: (e) => e!.isEmpty ? "Remplir se champ" : null,
                    onChanged: (e) => slogan = e,
                    decoration: InputDecoration(
                        hintText: "Slogan du service",
                        labelText: "Slogan",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    initialValue: prix,
                    keyboardType: TextInputType.number,
                    validator: (e) => e!.isEmpty ? "Prix se champ" : null,
                    onChanged: (e) => prix = e,
                    decoration: InputDecoration(
                        hintText: "Prix du vehicule",
                        labelText: "Prix",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    initialValue: descrition,
                    validator: (e) => e!.isEmpty ? "Remplir se champ" : null,
                    onChanged: (e) => descrition = e,
                    maxLines: 5,
                    decoration: InputDecoration(
                        hintText: "Détails supplémentaires",
                        labelText: "Détails",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (e) => e!.isEmpty ? "Remplir se champ" : null,
                    onChanged: (e) => tel = e,
                    decoration: InputDecoration(
                        hintText: "Votre Numéro Tel",
                        labelText: "Teléphone",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (e) => e!.isEmpty ? "Remplir se champ" : null,
                    onChanged: (e) => statut = e,
                    decoration: InputDecoration(
                        hintText: "Statut du service",
                        labelText: "Statut",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    children: [
                      for (int i = 0; i < images.length; i++)
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(.4)),
                          margin: EdgeInsets.only(right: 5, bottom: 5),
                          height: 70,
                          width: 70,
                          child: Stack(
                            children: [
                              if (images[i] is File)
                                Image.file(
                                  images[i],
                                  fit: BoxFit.fitHeight,
                                ),
                              if (images[i] is String)
                                Image.network(
                                  images[i],
                                  fit: BoxFit.fitHeight,
                                ),
                              Align(
                                alignment: Alignment.center,
                                child: IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.minusCircle,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      images.removeAt(i);
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      InkWell(
                        onTap: () async {
                          final data = await showModalBottomSheet(
                              context: context,
                              builder: (ctx) {
                                return GetImage();
                              });
                          if (data != null)
                            setState(() {
                              images.add(data);
                            });
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          color: Colors.green,
                          child: Icon(
                            FontAwesomeIcons.plusCircle,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (key.currentState!.validate() && images.length > 0) {
                          loading(context);
                          srv.nom = nom;
                          srv.slogan = slogan;
                          srv.prix = prix;
                          srv.detailSup = descrition;
                          srv.statut = statut;
                          srv.tel = tel;
                          srv.uid = FirebaseAuth.instance.currentUser!.uid;
                          srv.images = [];
                          for (var i = 0; i < images.length; i++) {
                            if (images[i] is File) {
                              String? urlImage = await DBServices()
                                  .uploadImage(images[i], path: "srvs");
                              if (urlImage != null) srv.images.add(urlImage);
                            } else {
                              srv.images.add(images[i]);
                            }
                          }
                          if (images.length == srv.images.length) {
                            bool update =
                            await DBServices().updateservice(srv);
                            if (update) {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            }
                            ;
                          }
                        } else {
                          print("veillez remplir tous les champs");
                        }
                      },
                      child: Text("Modifier",
                          style: TextStyle(color: Colors.white,fontSize: 20)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}