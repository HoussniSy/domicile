import 'package:domicile/ul/auth/verify_code.dart';
import 'package:domicile/utils/utils.dart';
import 'package:domicile/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({Key? key}) : super(key: key);

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {

  bool loading = false;
  final phoneNumberController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    phoneNumberController.text= "+222";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 80,),
            TextFormField(

              controller: phoneNumberController,

              decoration: InputDecoration(
                hintText: 'Enter votre numero de téléphone'
              ),
            ),
            SizedBox(height: 80,),
            RoundButton(title: 'Connectez-vous',loading: loading, onTap: (){

              setState(() {
                loading = true;
              });
              auth.verifyPhoneNumber(
                phoneNumber: phoneNumberController.text,
                  verificationCompleted: (_){
                    setState(() {
                      loading = false;
                    });
                  },
                  verificationFailed: (e){
                    setState(() {
                      loading = false;
                    });
                  Utils().toastMessage(e.toString());
                  },
                  codeSent: (String verficationId , int? token){
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) => VerifyCodeScreen(verficationId: verficationId,)));
                  setState(() {
                    loading = false;
                  });
                  },
                  codeAutoRetrievalTimeout: (e){
                  Utils().toastMessage(e.toString());
                  setState(() {
                    loading = false;
                  });
              });
            })
          ],
        ),
      ),
    );
  }
}
