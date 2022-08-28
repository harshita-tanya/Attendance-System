import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erp_app/Data/authentication.dart';
import 'package:flutter/material.dart';

class EditDetails extends StatefulWidget {
  const EditDetails({Key? key}) : super(key: key);

  @override
  State<EditDetails> createState() => _EditDetailsState();
}

class _EditDetailsState extends State<EditDetails> {
  String? name = "";
  List<Map<String, dynamic>>? users = [];
  List<Map<String, dynamic>>? sessionList = [];

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController lastNameController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Employee data",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(11.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: "Search",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                  ),
                ),
                onChanged: (val) {
                  setState(() {
                    name = val;
                  });
                },
              ),
            ),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .snapshots()
                    .map((snapshot) => snapshot.docs
                        .map(
                          (doc) => doc.data(),
                        )
                        .toList()),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    users = snapshot.data!;
                    if (users!.isNotEmpty) {
                      users = users!.where((element) {
                        return element['name']
                            .toString()
                            .toLowerCase()
                            .startsWith(name!.toLowerCase());
                      }).toList();
                    }
                    return ListView.builder(
                      itemCount: users!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(10.0)),
                            child: ListTile(
                              title: Text(
                                '${users![index]['name'].toString().toUpperCase()} ${users![index]['last_name'].toString().toUpperCase()}',
                              ),
                              subtitle: Text(
                                users![index]['email_id'].toString(),
                              ),
                              trailing: SizedBox(
                                width: 96.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        nameController = TextEditingController(
                                            text: users![index]['name']
                                                .toString());
                                        lastNameController =
                                            TextEditingController(
                                                text: users![index]['last_name']
                                                    .toString());
                                        emailController = TextEditingController(
                                            text: users![index]['email_id']
                                                .toString());

                                        showModalBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              return SizedBox(
                                                height: 350.0,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: TextFormField(
                                                          controller:
                                                              nameController,
                                                          decoration:
                                                              const InputDecoration(
                                                            labelText:
                                                                'Employee First Name',
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    12.0),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: TextFormField(
                                                          controller:
                                                              lastNameController,
                                                          decoration:
                                                              const InputDecoration(
                                                            labelText:
                                                                'Employee Last Name',
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    12.0),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: TextFormField(
                                                          controller:
                                                              emailController,
                                                          decoration:
                                                              const InputDecoration(
                                                            labelText:
                                                                'Email Id',
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    12.0),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 30.0,
                                                      ),
                                                      SizedBox(
                                                        height: 56.0,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            40,
                                                        child: TextButton(
                                                          onPressed: () async {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'users')
                                                                .doc(users![
                                                                        index]
                                                                    ['userId'])
                                                                .update({
                                                              'name':
                                                                  nameController
                                                                      .text,
                                                              'last_name':
                                                                  lastNameController
                                                                      .text,
                                                              'email_id':
                                                                  emailController
                                                                      .text,
                                                            }).then(
                                                              (value) =>
                                                                  Navigator.pop(
                                                                      context),
                                                            );
                                                          },
                                                          style: TextButton
                                                              .styleFrom(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0),
                                                            ),
                                                            backgroundColor:
                                                                Colors.black,
                                                          ),
                                                          child: const Text(
                                                            "Save Changes",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          showAlertDialog(
                                              context, index, users);
                                        },
                                        icon: const Icon(Icons.delete))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return const Center(child: Text("Something went wrong"));
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

showAlertDialog(
    BuildContext context, int index, List<Map<String, dynamic>>? users) {
  Widget cancelButton = TextButton(
    onPressed: () {
      Navigator.pop(context);
    },
    child: const Text("Cancel"),
  );

  Widget continueButton = TextButton(
    onPressed: () {
      AuthRepository.deleteRequest(users![index]['email_id'].toString());
      Navigator.pop(context);
    },
    child: const Text("Continue"),
  );

  AlertDialog alert = AlertDialog(
    title: const Text("Delete Profile"),
    content: const Text("Are you sure you want to remove this profile ?"),
    actions: [cancelButton, continueButton],
  );

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
}
