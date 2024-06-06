// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lendr/components/routes/log/login.dart';
import 'package:lendr/components/routes/tools/helper_functions.dart';
import 'package:lendr/components/routes/tools/loading_indicator.dart';
import 'package:lendr/components/routes/tools/my_button.dart';
import 'package:lendr/components/routes/tools/my_textfield.dart';
import 'package:lendr/components/routes/views/guard/extra_data.dart';
import 'package:lendr/shared/prefe_users.dart';

class Register extends StatefulWidget {
  static const String routname = '/register';
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  void Registro() async {
    var pref = PreferencesUser();
    LoadingScreen().show(context);

    if (passwordController.text != confirmPassController.text) {
      LoadingScreen().hide();
      displayMessageToUser('Las contraseñas no son iguales', context);
    } else if (passwordController.text.length < 8) {
      LoadingScreen().hide();
      displayMessageToUser(
          'La contraseña debe tener al menos 8 caracteres', context);
    } else if (!passwordController.text.contains(RegExp(r'[A-Z]'))) {
      LoadingScreen().hide();
      displayMessageToUser(
          'La contraseña debe contener al menos una letra mayúscula', context);
    } else if (!passwordController.text.contains(RegExp(r'[a-z]'))) {
      LoadingScreen().hide();
      displayMessageToUser(
          'La contraseña debe contener al menos una letra minúscula', context);
    } else if (!passwordController.text.contains(RegExp(r'[0-9]'))) {
      LoadingScreen().hide();
      displayMessageToUser(
          'La contraseña debe contener al menos un dígito', context);
    } else if (!passwordController.text
        .contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      LoadingScreen().hide();
      displayMessageToUser(
          'La contraseña debe contener al menos un símbolo', context);
    } else {
      try {
        UserCredential? userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);

        var uid = userCredential.user?.uid;
        pref.uid = uid!;
        FirebaseFirestore.instance.collection('Users').doc(uid).set({
          'uid': uid,
          'nombres': firstnameController.text,
          'apellidos': lastnameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'fnacimiento': '',
          'celular': '',
          'fperfil': '',
          'sexo': '',
          'direccion': '',
        });
        FirebaseFirestore.instance
            .collection('Prestamos+$uid')
            .doc('General')
            .set({
          'loans': 0,
          'collectAmount': 0,
          'earnings': 0,
          'loanAmounts': 0
        });
        LoadingScreen().hide();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ExtraData()),
        );
      } on FirebaseAuthException catch (e) {
        LoadingScreen().hide();
        if (e.code == 'invalid-email') {
          displayMessageToUser('Email Invalido', context);
        } else if (e.code == 'weak-password') {
          displayMessageToUser('Contraseña Corta', context);
        } else if (e.code == 'email-already-in-use') {
          displayMessageToUser('Email en Uso', context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.asset(
                      Theme.of(context).brightness == Brightness.light
                          ? 'assets/logo2.png'
                          : 'assets/logo1.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                MyTextField(
                    labelText: 'Nombres',
                    obscureText: false,
                    controller: firstnameController),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                    labelText: 'Apellidos',
                    obscureText: false,
                    controller: lastnameController),
                const SizedBox(
                  height: 10,
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
                MyTextField(
                    labelText: 'Confirmar Contraseña',
                    obscureText: true,
                    controller: confirmPassController),
                const SizedBox(
                  height: 10,
                ),
                MyButton(text: 'Registrar', onTap: () => Registro()),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('¿Tienes una cuenta?',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()),
                        );
                      },
                      child: const Text('Ingresa aqui',
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
