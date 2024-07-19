import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sia/pages/LogIn/forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginPage({super.key,required this.showRegisterPage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signIn() async{
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(), 
      password: _passwordController.text.trim()
      );
  }

  
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left side (60% image)
          Expanded(
            flex: 3,
            child: Image.asset(
              'assets/images/background.jpg', // Replace with your image path
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
                    'Login',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 10),
                  
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context){
                        
                            return const ForgotPasswordPage();
                            }
                        )
                      );
          
                    },

                    
                    child: const Text('Forgot Password?'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: signIn,
                    child: const Text('Login'),
                  ),

                  const SizedBox(height: 10), // Add spacing between buttons

                  TextButton(
                    onPressed: widget.showRegisterPage,
                    child: const Text('Register'),
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
