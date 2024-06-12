// ignore_for_file: non_constant_identifier_names, unused_element, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lendr/components/routes/tools/helper_functions.dart';
import 'package:lendr/components/routes/tools/input_photo.dart';
import 'package:lendr/components/routes/tools/loading_indicator.dart';
import 'package:lendr/components/routes/tools/my_button.dart';
import 'package:lendr/components/routes/tools/my_numberfield.dart';
import 'package:lendr/components/routes/tools/my_textfield.dart';
import 'package:lendr/components/routes/views/loan.dart';
import 'package:lendr/shared/prefe_users.dart';

class ExtraData extends StatefulWidget {
  static const String routname = '/extra_data';
  const ExtraData({super.key});

  @override
  State<ExtraData> createState() => _ExtraDataState();
}

class _ExtraDataState extends State<ExtraData> {
  final _pref = PreferencesUser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(_pref.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const AlertDialog(
              title: Text('Algo salio mal'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == null) {
            return const Text('No hay datos');
          }
          final user = snapshot.data!;

          final TextEditingController fotoPerfilController =
              TextEditingController(text: user['fperfil']);
          final TextEditingController addressController =
              TextEditingController(text: user['direccion']);
          final TextEditingController sexController =
              TextEditingController(text: user['sexo']);
          final TextEditingController phoneController =
              TextEditingController(text: user['celular']);
          final TextEditingController ageController =
              TextEditingController(text: user['fnacimiento']);
          final TextEditingController balanceController =
              TextEditingController(text: user['balance'].toString());

          void Guardar() async {
            LoadingScreen().show(context);

            if (addressController.text == '') {
              LoadingScreen().hide();
              displayMessageToUser('Debe colocar su direccion', context);
            } else if (sexController.text == '') {
              LoadingScreen().hide();
              displayMessageToUser('Debe colocar su sexo', context);
            } else if (phoneController.text == '') {
              LoadingScreen().hide();
              displayMessageToUser('Debe colocar su numero celular', context);
            } else if (ageController.text == '') {
              LoadingScreen().hide();
              displayMessageToUser(
                  'Debe colocar su fecha de nacimiento', context);
            } else {
              try {
                FirebaseFirestore.instance
                    .collection('Users')
                    .doc(_pref.uid)
                    .update({
                  'fnacimiento': ageController.text,
                  'celular': phoneController.text,
                  'fperfil': fotoPerfilController.text,
                  'sexo': sexController.text,
                  'direccion': addressController.text,
                  'balance': int.parse(balanceController.text),
                });
                FirebaseFirestore.instance
                    .collection('Prestamos+${_pref.uid}')
                    .doc('General')
                    .update({
                  'balance': int.parse(balanceController.text),
                });
                LoadingScreen().hide();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Loan()),
                );
              } on FirebaseAuthException catch (e) {
                LoadingScreen().hide();
                displayMessageToUser(e.code, context);
              }
            }
          }

          int edadf = 0;

          if (user['fnacimiento'] != '') {
            final DateFormat formatter = DateFormat('dd/MM/yyyy');
            final DateTime fechaNacimiento =
                formatter.parse(user['fnacimiento']);
            final DateTime now = DateTime.now();
            final int years = now.year - fechaNacimiento.year;
            int edad;
            if (now.month < fechaNacimiento.month ||
                (now.month == fechaNacimiento.month &&
                    now.day < fechaNacimiento.day)) {
              edad = years - 1;
            } else {
              edad = years;
            }
            edadf = edad;
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const InputFotoPerfil(),
                    const SizedBox(
                      height: 30,
                    ),
                    MyTextField(
                        labelText: 'Direccion de Residencia',
                        obscureText: false,
                        controller: addressController),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextField(
                        labelText: 'Sexo',
                        obscureText: false,
                        controller: sexController),
                    const SizedBox(
                      height: 10,
                    ),
                    MyNumberField(
                        labelText: 'Numero Celular',
                        obscureText: false,
                        controller: phoneController),
                    const SizedBox(
                      height: 10,
                    ),
                    MyNumberField(
                        labelText: 'Saldo',
                        obscureText: false,
                        controller: balanceController),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: ageController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        labelText: 'Fecha de Nacimiento',
                        floatingLabelStyle: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black
                                    : Colors.white),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onTap: () async {
                        DateTime? datetime = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                          cancelText: 'Cancelar',
                          confirmText: 'Confirmar',
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? ThemeData.light().copyWith(
                                      colorScheme: ColorScheme.light(
                                        surface: Colors.grey.shade300,
                                        primary: Colors.grey.shade500,
                                        secondary: Colors.grey.shade400,
                                        inversePrimary: Colors.grey.shade500,
                                      ),
                                    )
                                  : ThemeData.dark().copyWith(
                                      colorScheme: ColorScheme.dark(
                                        surface: Colors.grey.shade800,
                                        primary: Colors.grey.shade500,
                                        secondary: Colors.grey.shade400,
                                        inversePrimary: Colors.grey.shade500,
                                      ),
                                    ),
                              child: child!,
                            );
                          },
                        );
                        if (datetime != null) {
                          String formattedDate =
                              DateFormat('dd/MM/yyyy').format(datetime);
                          ageController.text = formattedDate;
                        }
                      },
                      obscureText: false,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MyButton(text: 'Guardar', onTap: () => Guardar()),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
