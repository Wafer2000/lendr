// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lendr/components/routes/tools/helper_functions.dart';
import 'package:lendr/components/routes/tools/loading_indicator.dart';
import 'package:lendr/components/routes/tools/my_drawer.dart';
import 'package:lendr/components/routes/tools/my_textfield.dart';
import 'package:lendr/components/routes/views/customer_debts.dart';
import 'package:lendr/firebase/firestore.dart';
import 'package:lendr/shared/prefe_users.dart';
import 'package:lendr/style/global_colors.dart';

class Customers extends StatefulWidget {
  static const String routname = '/customers';
  const Customers({super.key});

  @override
  State<Customers> createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController middlenameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController secondlastnameController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dniController = TextEditingController();
  final TextEditingController workController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController regionController = TextEditingController();
  final _pref = PreferencesUser();

  @override
  void dispose() {
    super.dispose();
  }

  void KeepClient() async {
    LoadingScreen().show(context);

    final now = DateTime.now();
    final hcreate = DateFormat('HH:mm:ss').format(now);
    final fcreate = DateFormat('yyyy-MM-dd').format(now);

    List<String> names = firstnameController.text.split(" ");
    String firstname = names[0];
    String middlename = names[1];

    List<String> lastnames = lastnameController.text.split(" ");
    String lastname = lastnames[0];
    String secondlastname = lastnames[1];

    final doc = await FirebaseFirestore.instance
        .collection('Clientes+${_pref.uid}')
        .doc(dniController.text)
        .get();

    if (firstnameController.text == '') {
      LoadingScreen().hide();
      displayMessageToUser('Debe colocar uno o los dos nombres', context);
    } else if (lastnameController.text == '') {
      LoadingScreen().hide();
      displayMessageToUser('Debe colocar los dos apellidos', context);
    } else if (emailController.text == '') {
      LoadingScreen().hide();
      displayMessageToUser('Debe colocar el email', context);
    } else if (phoneController.text == '') {
      LoadingScreen().hide();
      displayMessageToUser('Debe colocar el celular', context);
    } else if (dniController.text == '') {
      LoadingScreen().hide();
      displayMessageToUser('Debe colocar la cedula', context);
    } else if (workController.text == '') {
      LoadingScreen().hide();
      displayMessageToUser('Debe colocar el tipo de trabajo', context);
    } else if (addressController.text == '') {
      LoadingScreen().hide();
      displayMessageToUser('Debe colocar la direccion', context);
    } else if (cityController.text == '') {
      LoadingScreen().hide();
      displayMessageToUser('Debe colocar la ciudad de residencia', context);
    } else if (regionController.text == '') {
      LoadingScreen().hide();
      displayMessageToUser(
          'Debe colocar el departamento de residencia', context);
    } else if (doc.exists) {
      LoadingScreen().hide();
      displayMessageToUser(
          'Este Cliente ya existe en la Base de Datos', context);
    } else {
      FirebaseFirestore.instance
          .collection('Clientes+${_pref.uid}')
          .doc(dniController.text)
          .set({
        'firstname': firstname,
        'middlename': middlename,
        'lastname': lastname,
        'secondlastname': secondlastname,
        'email': emailController.text,
        'phone': int.parse(phoneController.text),
        'dni': int.parse(dniController.text),
        'work': workController.text,
        'address': addressController.text,
        'city': cityController.text,
        'region': regionController.text,
        'hcreate': hcreate,
        'fcreate': fcreate,
        'lendr': _pref.uid,
        'collect': 0,
        'amount': 0,
        'debts': 0
      });
      displayMessageToUser('Cliente guardado', context);
      LoadingScreen().hide();
    }
  }

  void new_client() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Llene todos los campos'),
          icon: const Icon(Icons.group),
          shadowColor: Theme.of(context).primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MyTextField(
                    labelText: 'Nombres',
                    obscureText: false,
                    controller: firstnameController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MyTextField(
                    labelText: 'Apellidos',
                    obscureText: false,
                    controller: lastnameController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MyTextField(
                    labelText: 'Email',
                    obscureText: false,
                    controller: emailController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MyTextField(
                    labelText: 'Celular',
                    obscureText: false,
                    controller: phoneController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MyTextField(
                    labelText: 'Cedula',
                    obscureText: false,
                    controller: dniController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MyTextField(
                    labelText: 'Trabajo',
                    obscureText: false,
                    controller: workController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MyTextField(
                    labelText: 'Direccion',
                    obscureText: false,
                    controller: addressController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MyTextField(
                    labelText: 'Ciudad',
                    obscureText: false,
                    controller: cityController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MyTextField(
                    labelText: 'Region',
                    obscureText: false,
                    controller: regionController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light
                        ? MyColor.manatee().color
                        : MyColor.abbey().color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton(
                    onPressed: () {
                      firstnameController.clear();
                      lastnameController.clear();
                      emailController.clear();
                      phoneController.clear();
                      dniController.clear();
                      workController.clear();
                      addressController.clear();
                      cityController.clear();
                      regionController.clear();
                      Navigator.pop(context);
                    },
                    child: const Text('Cancelar',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light
                        ? MyColor.shark().color
                        : MyColor.iron().color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      KeepClient();
                      Navigator.pop(context);
                    },
                    child: Text('Guardar',
                        style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? MyColor.white().color
                                    : MyColor.black().color)),
                  ),
                ),
              ],
            ),
          ],
        );
      },
      barrierDismissible: false,
    );
  }

  void edit_client(id) {
    showDialog(
      context: context,
      builder: (context) {
        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('Clientes+${_pref.uid}')
                .doc(id)
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

              final client = snapshot.data!;

              final TextEditingController firstnameController =
                  TextEditingController(text: client['firstname']);
              final TextEditingController middlenameController =
                  TextEditingController(text: client['middlename']);
              final TextEditingController lastnameController =
                  TextEditingController(text: client['lastname']);
              final TextEditingController secondlastnameController =
                  TextEditingController(text: client['secondlastname']);
              final TextEditingController emailController =
                  TextEditingController(text: client['email']);
              final TextEditingController phoneController =
                  TextEditingController(text: client['phone'].toString());
              final TextEditingController dniController =
                  TextEditingController(text: client['dni'].toString());
              final TextEditingController workController =
                  TextEditingController(text: client['work']);
              final TextEditingController addressController =
                  TextEditingController(text: client['address']);
              final TextEditingController cityController =
                  TextEditingController(text: client['city']);
              final TextEditingController regionController =
                  TextEditingController(text: client['region']);
              return AlertDialog(
                title: const Text('Llene todos los campos'),
                icon: const Icon(Icons.group),
                shadowColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                content: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MyTextField(
                          labelText: 'Primer Nombre',
                          obscureText: false,
                          controller: firstnameController,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        MyTextField(
                          labelText: 'Segundo Nombre',
                          obscureText: false,
                          controller: middlenameController,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        MyTextField(
                          labelText: 'Primer Apellido',
                          obscureText: false,
                          controller: lastnameController,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        MyTextField(
                          labelText: 'Segundo Apellido',
                          obscureText: false,
                          controller: secondlastnameController,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        MyTextField(
                          labelText: 'Email',
                          obscureText: false,
                          controller: emailController,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        MyTextField(
                          labelText: 'Celular',
                          obscureText: false,
                          controller: phoneController,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        MyTextField(
                          labelText: 'Cedula',
                          obscureText: false,
                          controller: dniController,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        MyTextField(
                          labelText: 'Trabajo',
                          obscureText: false,
                          controller: workController,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        MyTextField(
                          labelText: 'Direccion',
                          obscureText: false,
                          controller: addressController,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        MyTextField(
                          labelText: 'Ciudad',
                          obscureText: false,
                          controller: cityController,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        MyTextField(
                          labelText: 'Region',
                          obscureText: false,
                          controller: regionController,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 50,
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? MyColor.manatee().color
                                  : MyColor.abbey().color,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextButton(
                          onPressed: () {
                            firstnameController.clear();
                            middlenameController.clear();
                            lastnameController.clear();
                            secondlastnameController.clear();
                            emailController.clear();
                            phoneController.clear();
                            dniController.clear();
                            workController.clear();
                            addressController.clear();
                            cityController.clear();
                            regionController.clear();
                            Navigator.pop(context);
                          },
                          child: const Text('Cancelar',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 50,
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? MyColor.shark().color
                                  : MyColor.iron().color,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextButton(
                          onPressed: () async {
                            if (firstnameController.text == '') {
                              LoadingScreen().hide();
                              displayMessageToUser(
                                  'Debe colocar uno o los dos nombres',
                                  context);
                            } else if (lastnameController.text == '') {
                              LoadingScreen().hide();
                              displayMessageToUser(
                                  'Debe colocar los dos apellidos', context);
                            } else if (emailController.text == '') {
                              LoadingScreen().hide();
                              displayMessageToUser(
                                  'Debe colocar el email', context);
                            } else if (phoneController.text == '') {
                              LoadingScreen().hide();
                              displayMessageToUser(
                                  'Debe colocar el celular', context);
                            } else if (dniController.text == '') {
                              LoadingScreen().hide();
                              displayMessageToUser(
                                  'Debe colocar la cedula', context);
                            } else if (workController.text == '') {
                              LoadingScreen().hide();
                              displayMessageToUser(
                                  'Debe colocar el tipo de trabajo', context);
                            } else if (addressController.text == '') {
                              LoadingScreen().hide();
                              displayMessageToUser(
                                  'Debe colocar la direccion', context);
                            } else if (cityController.text == '') {
                              LoadingScreen().hide();
                              displayMessageToUser(
                                  'Debe colocar la ciudad de residencia',
                                  context);
                            } else if (regionController.text == '') {
                              LoadingScreen().hide();
                              displayMessageToUser(
                                  'Debe colocar el departamento de residencia',
                                  context);
                            } else {
                              FirebaseFirestore.instance
                                  .collection('Clientes+${_pref.uid}')
                                  .doc(id)
                                  .update({
                                'firstname': firstnameController.text,
                                'middlename': middlenameController.text,
                                'lastname': lastnameController.text,
                                'secondlastname': secondlastnameController.text,
                                'email': emailController.text,
                                'phone': int.parse(phoneController.text),
                                'dni': int.parse(dniController.text),
                                'work': workController.text,
                                'address': addressController.text,
                                'city': cityController.text,
                                'region': regionController.text,
                                'lendr': _pref.uid
                              });
                              Navigator.pop(context);
                              displayMessageToUser('Cliente editado', context);
                              LoadingScreen().hide();
                            }
                          },
                          child: Text('Guardar',
                              style: TextStyle(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? MyColor.white().color
                                      : MyColor.black().color)),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            });
      },
      barrierDismissible: false,
    );
  }

  void EliminateClient(id) async {
    LoadingScreen().show(context);

    FirebaseFirestore.instance
        .collection('Clientes+${_pref.uid}')
        .doc(id)
        .delete();
    displayMessageToUser('Cliente Eliminado', context);
    LoadingScreen().hide();
    Navigator.pop(context);
  }

  void delete_client(id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('¿Deseas eliminar este Cliente?'),
          icon: const Icon(Icons.delete),
          shadowColor: Theme.of(context).primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            'Se borara todo dato relacionado con el cliente.',
                            style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? MyColor.black().color
                                  : MyColor.iron().color,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light
                        ? MyColor.manatee().color
                        : MyColor.abbey().color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancelar',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light
                        ? MyColor.shark().color
                        : MyColor.iron().color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      EliminateClient(id);
                      Navigator.pop(context);
                    },
                    child: Text('Eliminar',
                        style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? MyColor.white().color
                                    : MyColor.black().color)),
                  ),
                ),
              ],
            ),
          ],
        );
      },
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final collections = GetCollectionsLoan();

    return StreamBuilder<QuerySnapshot>(
        stream: collections.getCollections(_pref.uid),
        builder: (context, snapshot) {
          final service = snapshot.data?.docs;

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          }
          if (snapshot.data == null) {
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                title: const Center(child: Text('C l i e n t e s')),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      new_client();
                    },
                    tooltip: 'Add',
                    alignment: Alignment.center,
                  ),
                ],
                backgroundColor:
                    Theme.of(context).brightness == Brightness.light
                        ? MyColor.grannySmith().color
                        : MyColor.capeCod().color,
              ),
              drawer: const MyDrawer(),
              backgroundColor: Theme.of(context).colorScheme.background,
              body: const Stack(
                children: [
                  Positioned.fill(
                    child: Center(
                      child: Text(
                        'No hay Datos',
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: const Center(child: Text('C l i e n t e s')),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    new_client();
                  },
                  tooltip: 'Add',
                  alignment: Alignment.center,
                ),
              ],
              backgroundColor: Theme.of(context).brightness == Brightness.light
                  ? MyColor.grannySmith().color
                  : MyColor.capeCod().color,
            ),
            drawer: const MyDrawer(),
            backgroundColor: Theme.of(context).colorScheme.background,
            body: ListView.builder(
              itemCount: service?.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = service![index];
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String docID = document.id;

                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                  child: Container(
                    width: MediaQuery.of(context).size.height * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).brightness == Brightness.light
                          ? MyColor.manatee().color
                          : MyColor.abbey().color,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: Column(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: Text(
                                        '${data['firstname']} ${data['lastname']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 27,
                                          color: Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? MyColor.black().color
                                              : MyColor.iron().color,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                height: 10,
                                thickness: 1,
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? MyColor.black().color
                                    : MyColor.iron().color,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Deudas: ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.light
                                                      ? MyColor.black().color
                                                      : MyColor.iron().color,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                              Text(
                                                NumberFormat.currency(
                                                        locale: 'es',
                                                        symbol: '\$')
                                                    .format(data['debts']),
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.light
                                                      ? MyColor.black().color
                                                      : MyColor.iron().color,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Dinero Pedido: ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.light
                                                      ? MyColor.black().color
                                                      : MyColor.iron().color,
                                                ),
                                              ),
                                              Text(
                                                NumberFormat.currency(
                                                        locale: 'es',
                                                        symbol: '\$')
                                                    .format(data['amount']),
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.light
                                                      ? MyColor.black().color
                                                      : MyColor.iron().color,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Dinero por pagar: ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.light
                                                      ? MyColor.black().color
                                                      : MyColor.iron().color,
                                                ),
                                              ),
                                              Text(
                                                NumberFormat.currency(
                                                        locale: 'es',
                                                        symbol: '\$')
                                                    .format(data['collect']),
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.light
                                                      ? MyColor.black().color
                                                      : MyColor.iron().color,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                height: 10,
                                thickness: 1,
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? MyColor.black().color
                                    : MyColor.iron().color,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.account_balance),
                                    onPressed: () {
                                      _pref.loanId = docID;
                                      Navigator.pushNamed(
                                          context, CustomerDebts.routname);
                                    },
                                    iconSize: 35,
                                    tooltip: 'Deudas',
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? MyColor.black().color
                                        : MyColor.iron().color,
                                    alignment: Alignment.center,
                                  ),
                                  VerticalDivider(
                                    width: 10,
                                    thickness: 1,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? MyColor.black().color
                                        : MyColor.iron().color,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      edit_client(docID);
                                    },
                                    iconSize: 35,
                                    tooltip: 'Editar',
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? MyColor.black().color
                                        : MyColor.iron().color,
                                    alignment: Alignment.center,
                                  ),
                                  VerticalDivider(
                                    width: 10,
                                    thickness: 1,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? MyColor.black().color
                                        : MyColor.iron().color,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      delete_client(docID);
                                    },
                                    iconSize: 35,
                                    tooltip: 'Editar',
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? MyColor.black().color
                                        : MyColor.iron().color,
                                    alignment: Alignment.center,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        });
  }
}
