import 'package:domicile/ul/posts/post_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../../widgets/round_button.dart';


class VerifyCodeScreen extends StatefulWidget {
  final String verficationId ;
  const VerifyCodeScreen({Key? key, required this.verficationId}) : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  bool loading = false;
  final verificationCodeController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 80,),
            TextFormField(
              controller: verificationCodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: 'Code verification'
              ),
            ),
            SizedBox(height: 80,),
            RoundButton(title: 'Verify',loading: loading, onTap: ()async{

              setState(() {
                loading = true;
              });
              final crendital = PhoneAuthProvider.credential(
                  verificationId: widget.verficationId,
                  smsCode: verificationCodeController.text.toString()
              );

              try{
                await auth.signInWithCredential(crendital);

                Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreen()));

              }catch(e){
                setState(() {
                  loading = false;
                });
                Utils().toastMessage(e.toString());
              }
            })
          ],
        ),
      ),
    );
  }
}
