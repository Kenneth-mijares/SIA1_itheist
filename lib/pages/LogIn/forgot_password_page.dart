import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset () async{
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());

      showDialog(
        // ignore: use_build_context_synchronously
        context: context, 
        builder: (context){
          return const AlertDialog(
            content: Text('Password reset link sent! Check your email'),
          );
        }
      );

    } on FirebaseAuthException catch (e) {

      // ignore: avoid_print
      print(e);
      
      //can edit this show dialog
      showDialog(
        // ignore: use_build_context_synchronously
        context: context, 
        builder: (context){
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        }
      );

    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text (
            'Enter your Email and we will send you a password reset link',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
            ),
          
          const SizedBox(height: 20),


          Padding(
            padding: const EdgeInsets.symmetric(horizontal:325.0),
            child: TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              
              ),
          ),

          const SizedBox(height: 20),

          MaterialButton(
            onPressed: passwordReset,
            color: Colors.amber,
            child: const Text('Reset Password'),
          
          )
                  
                      
        ],
      ),
    );
  }
}