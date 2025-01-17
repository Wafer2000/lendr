// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lendr/components/routes/log/login.dart';
import 'package:lendr/tools/helper_functions.dart';
import 'package:lendr/tools/loading_indicator.dart';
import 'package:lendr/tools/my_button.dart';
import 'package:lendr/tools/my_textfield.dart';
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
  final TextEditingController middlenameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController secondlastnameController =
      TextEditingController();
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
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailController.text)) {
      displayMessageToUser(
          'Error: El email ingresado no es válido. Debe contener un arroba (@) y un dominio válido.',
          context);
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
        await FirebaseFirestore.instance.collection('Users').doc(uid).set({
          'uid': uid,
          'firstname': firstnameController.text,
          'middlename': middlenameController.text,
          'lastname': lastnameController.text,
          'secondlastname': secondlastnameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'balance': '',
          'fnacimiento': '',
          'cedula': '',
          'celular': '',
          'fperfil': '',
          'sexo': '',
          'direccion': '',
        });
      await FirebaseFirestore.instance
            .collection('Prestamos')
            .doc('General$uid')
            .set({
          'balance': 0,
          'loans': 0,
          'collectAmount': 0,
          'earnings': 0,
          'loanAmounts': 0,
          'unpaid': 0,
          'paid': 0,
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
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: MyTextField(
                        labelText: 'Primer Nombre',
                        obscureText: false,
                        controller: firstnameController,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      flex: 1,
                      child: MyTextField(
                        labelText: 'Segundo Nombre',
                        obscureText: false,
                        controller: middlenameController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: MyTextField(
                        labelText: 'Primer Apellido',
                        obscureText: false,
                        controller: lastnameController,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      flex: 1,
                      child: MyTextField(
                        labelText: 'Segundo Apellido',
                        obscureText: false,
                        controller: secondlastnameController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                MyTextField(
                    labelText: 'Correo',
                    obscureText: false,
                    controller: emailController),
                const SizedBox(
                  height: 5,
                ),
                MyTextField(
                    labelText: 'Contraseña',
                    obscureText: true,
                    controller: passwordController),
                const SizedBox(
                  height: 5,
                ),
                MyTextField(
                    labelText: 'Confirmar Contraseña',
                    obscureText: true,
                    controller: confirmPassController),
                const SizedBox(
                  height: 5,
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
