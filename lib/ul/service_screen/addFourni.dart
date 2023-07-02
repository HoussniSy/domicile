import 'dart:io';

import 'package:domicile/model/fournisseur.dart';
import 'package:domicile/services/db.dart';
import 'package:domicile/utils/getImage.dart';
import 'package:domicile/utils/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddFourni extends StatefulWidget {

  @override
  State<AddFourni> createState() => _AddFourniState();
}

class _AddFourniState extends State<AddFourni> {
  final key = GlobalKey<FormState>();
  late String nom, adresse, code, competence, tel, experience;
  List<File> images = [];
  Fourni prv = Fourni(images: [], id: '', uid: '', dislike: [], like: [], favories: [], nom: '', competence: '', experience: '', code: '', tel: '', adresse: '');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Ajouter un fournisseur"),
          backgroundColor: Colors.lightBlue,
          actions: [Icon(FontAwesomeIcons.person)],
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
                        hintText: "Nom du vehicule",
                        labelText: "Nom",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (e) => e!.isEmpty ? "Remplir se champ" : null,
                    onChanged: (e) => adresse = e,
                    decoration: InputDecoration(
                        hintText: "Adresse du vehicule",
                        labelText: "Adresse",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (e) => e!.isEmpty ? "Remplir se champ" : null,
                    onChanged: (e) => code = e,
                    decoration: InputDecoration(
                        hintText: "Code du vehicule",
                        labelText: "Code Postal",
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
                        hintText: "Teléphone du vehicule",
                        labelText: "Teléphone",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (e) => e!.isEmpty ? "Remplir se champ" : null,
                    onChanged: (e) => competence = e,
                    maxLines: 3,
                    decoration: InputDecoration(
                        hintText: "competenece Aquise",
                        labelText: "Compétence",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),TextFormField(
                    validator: (e) => e!.isEmpty ? "Remplir se champ" : null,
                    onChanged: (e) => experience = e,
                    maxLines: 3,
                    decoration: InputDecoration(
                        hintText: "expérience du technicien",
                        labelText: "Exprience",
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
                          margin: EdgeInsets.only(right: 5, bottom: 5),
                          height: 80,
                          width: 80,
                          child: Stack(
                            children: [
                              Image.file(images[i]),
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
                          if(data != null)setState(() {
                            images.add(data);
                          });
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          color: Colors.lightBlue,
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
                          print(images);
                          prv.nom = nom;
                          prv.adresse = adresse;
                          prv.code = code;
                          prv.tel = tel;
                          prv.competence = competence;
                          prv.experience = experience;
                          prv.uid = FirebaseAuth.instance.currentUser!.uid;
                          prv.images = [];
                          for (var i = 0; i < images.length; i++) {
                            String? urlImage =
                            await DBServices().uploadImage(images[i], path: "fournisseur");
                            if (urlImage != null) prv.images.add(urlImage);
                          }
                          if (images.length == prv.images.length) {
                            bool save = await DBServices().savefourni(prv);
                            if (save) {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            }
                          }
                        } else {
                          print("veillez remplir tous les champs");
                        }
                      },
                      child: Text("Enregistrer"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
