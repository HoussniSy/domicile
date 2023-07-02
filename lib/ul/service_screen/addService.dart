import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domicile/model/service.dart';
import 'package:domicile/services/db.dart';
import 'package:domicile/utils/getImage.dart';
import 'package:domicile/utils/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddService extends StatefulWidget {

  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {

  final key = GlobalKey<FormState>();
  late String nom, slogan, prix, descrition, statut, tel;
  Service srv = Service(detailSup: '', images: [], nom: '', slogan: '', prix: '', statut: '', id: '', uid: '', tel: '', dislike: [], like: [], favories: []);
  List<File> images = [];
  final CollectionReference servicecol =
  FirebaseFirestore.instance.collection("Service");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter un service"),
        backgroundColor: Colors.green,
        actions: [Icon(FontAwesomeIcons.peopleGroup)],
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
                  validator: (e) => e!.isEmpty ? "Remplir se champ" : null,
                  onChanged: (e) => nom = e,
                  decoration: InputDecoration(
                  hintText: "Nom du service",
                  labelText: "Nom Service",
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (e) => e!.isEmpty ? "Remplir se champ" : null,
                    onChanged: (e) => slogan = e,
                    decoration: InputDecoration(
                        hintText: "Slogan du service",
                        labelText: "Slogan Service",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (e) => e!.isEmpty ? "Remplir se champ" : null,
                    onChanged: (e) => prix = e,
                    decoration: InputDecoration(
                        hintText: "Prix du service",
                        labelText: "Prix",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
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
                      for (int i = 0; i <images.length; i++)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.4)
                        ),
                        margin: EdgeInsets.only(right: 5, bottom: 5),
                        width: 70,
                        height: 70,
                        child: Stack(
                            children: [
                              Image.file(images[i],
                              fit: BoxFit.fitHeight,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: IconButton(
                                  icon: Icon(
                                      FontAwesomeIcons.minusCircle,
                                    color: Colors.white,),
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
                          if(data != null)
                            setState(() {
                            images.add(data);
                          });
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          color: Colors.green,
                          child: Icon(FontAwesomeIcons.plusCircle,
                          color: Colors.white,),
                        ),
                      ),
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
                              String? urlImage = await DBServices().uploadImage(
                                  images[i], path: "services");
                              if (urlImage != null) srv.images.add(urlImage);
                            }
                            if (images.length == srv.images.length) {
                              bool save = await DBServices().saveservice(srv);
                              if (save) {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              }
                            }
                          } else {
                              print("veillez remplir tous les champs");
                            }
                        },
                        child: Text("Enregistrer",
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
