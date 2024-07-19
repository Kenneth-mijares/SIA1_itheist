import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({super.key,required this.showLoginPage});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  //text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    super.dispose();
  }

  bool passwordConfirmed (){
      if (_passwordController.text.trim() == _confirmpasswordController.text.trim()) {
        return true;
      }
      else{
        return false;

      }
    }

  Future signUp() async{
    if (passwordConfirmed ()) {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim()
      );
    }

    

  }


//ui editing starts here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left side (60% image)
          Expanded(
            flex: 3,
            child: Image.asset(
              'assets/background.jpg', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),

          // Right side (40% login form)
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(82.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Register',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  //email textfield
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 10),
                  
                  //password textfield
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),

                  const SizedBox(height: 10),
                  
                  //confirm password textfield
                  TextField(
                    controller: _confirmpasswordController,
                    decoration: const InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                  ),
                  
                  
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: signUp,
                    child: const Text('SignUp'),
                  ),

                  const SizedBox(height: 10), // Add spacing between buttons

                  TextButton(
                    onPressed: widget.showLoginPage,
                    child: const Text('sign in'),
                  ),
                  
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}