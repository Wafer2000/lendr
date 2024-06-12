// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lendr/components/routes/log/register.dart';
import 'package:lendr/components/routes/tools/helper_functions.dart';
import 'package:lendr/components/routes/tools/loading_indicator.dart';
import 'package:lendr/components/routes/tools/my_button.dart';
import 'package:lendr/components/routes/tools/my_textfield.dart';
import 'package:lendr/components/routes/views/loan.dart';
import 'package:lendr/shared/prefe_users.dart';

class Login extends StatefulWidget {
  static const String routname = 'login';
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void Ingreso() async {
    var pref = PreferencesUser();
    LoadingScreen().show(context);

    try {
      UserCredential? userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      if (context.mounted) {
        var uid = userCredential.user?.uid;
        pref.uid = uid!;
        LoadingScreen().hide();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Loan()),
        );
      }
    } on FirebaseAuthException catch (e) {
      LoadingScreen().hide();
      displayMessageToUser(e.code, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Image.asset(
                    Theme.of(context).brightness == Brightness.light
                        ? 'assets/logo2.png'
                        : 'assets/logo1.png',
                    fit: BoxFit.contain, // Contain en lugar de cover
                    width: 310.7, // Tamaño máximo de ancho
                    height: 310.7, // Tamaño máximo de alto
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                MyTextField(
                    labelText: 'Correo',
                    obscureText: false,
                    controller: emailController),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                    labelText: 'Contraseña',
                    obscureText: true,
                    controller: passwordController),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('¿Se le olvido la contraseña?',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary)),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                MyButton(text: 'Ingresar', onTap: () => Ingreso()),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('¿No tienes una cuenta?  ',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Register()),
                        );
                      },
                      child: const Text('Registrate aqui',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
