import 'package:domicile/services/auth.dart';
import 'package:domicile/ul/auth/login_screen.dart';
import 'package:domicile/utils/utils.dart';
import 'package:domicile/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  AuthServices auth = AuthServices();
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  late String emailController, passwordController, confpassw, pseudo;


  final  _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Créer'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.text,
                      onChanged:(e)=>pseudo=e,
                      decoration: const InputDecoration(
                          hintText: 'Pseudo',
                          prefixIcon: Icon(Icons.person)
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Enter pseudo';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20,),

                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      onChanged:(e)=>emailController=e,
                      decoration: const InputDecoration(
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.alternate_email)
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Enter email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20,),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      onChanged: (e)=>passwordController=e,
                      obscureText: true,
                      decoration: const InputDecoration(
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.lock_open)
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Enter password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20,),

                    TextFormField(
                      keyboardType: TextInputType.text,
                      onChanged: (e)=>confpassw=e,
                      obscureText: true,
                      decoration: const InputDecoration(
                          hintText: 'Confirmation Password',
                          prefixIcon: Icon(Icons.lock_open)
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Enter password';
                        }
                        return null;
                      },
                    ),
                  ],
                )
            ),
            const SizedBox(height: 50,),
            RoundButton(
              title: 'Enregistrer',
              onTap: () async {
                if(_formKey.currentState!.validate()){
                  print(emailController+"    "+passwordController);
                  bool register = await auth.signup(emailController, passwordController, pseudo);
                  if(register != null){
                    Navigator.of(context).pop();
                    if(register) Navigator.of(context).pop();
                  }
                }
              },
            ),
            const SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Vous avez déjà un compte?"),
                TextButton(onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>LoginScreen())
                  );
                },
                    child: Text('Connectez-vous'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
