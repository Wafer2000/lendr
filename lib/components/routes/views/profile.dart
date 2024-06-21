// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lendr/tools/my_drawer.dart';
import 'package:lendr/components/routes/views/guard/extra_data.dart';
import 'package:lendr/shared/prefe_users.dart';
import 'package:lendr/style/global_colors.dart';

class Profile extends StatefulWidget {
  static const String routname = '/profile';
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _pref = PreferencesUser();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Center(child: Text('P e r f i l')),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, ExtraData.routname);
                },
                icon: const Icon(Icons.edit))
          ],
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? MyColor.grannySmith().color
              : MyColor.capeCod().color,
        ),
        drawer: const MyDrawer(),
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
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              );
            }
            if (snapshot.data == null) {
              return const Text('No hay datos');
            }
            final user = snapshot.data!;

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: user['fperfil'] == ''
                            ? Image.asset(
                                'assets/user.png',
                                width: 250,
                                height: 250,
                                errorBuilder: (context, error, stackTrace) {
                                  return IconButton(
                                    highlightColor: Colors.transparent,
                                    onPressed: () {},
                                    icon: Image.asset(
                                      'assets/user.png',
                                      width: 250,
                                      height: 250,
                                    ),
                                  );
                                },
                              )
                            : Image.network(
                                user['fperfil'],
                                width: 250,
                                height: 250,
                                errorBuilder: (context, error, stackTrace) {
                                  return IconButton(
                                    highlightColor: Colors.transparent,
                                    onPressed: () {},
                                    icon: Image.asset(
                                      'assets/user.png',
                                      width: 250,
                                      height: 250,
                                    ),
                                  );
                                },
                              ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        '${user['firstname']} ${user['lastname']}',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        user['email'],
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Direccion: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text(
                            '${user['direccion']}',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Celular: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text(
                            '${user['celular'].toString()}',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Edad: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text(
                            edadf == 0
                                ? 'Dato vacio'
                                : '${edadf.toString()} Años',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Sexo: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text(
                            '${user['sexo']}',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ));
  }
}
