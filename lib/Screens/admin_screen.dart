import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erp_app/Data/authentication.dart';
import 'package:erp_app/Data/data_service.dart';
import 'package:erp_app/Screens/employee_table_screen.dart';
import 'package:erp_app/Screens/login_screen.dart';
import 'package:erp_app/Screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Models/session.dart';
import '../Models/user.dart';
import 'edit_details_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List<Map<String, dynamic>>? users = [];
  List<Map<String, dynamic>>? sessionsList = [];
  String? name = "";
  bool _isFilterSelected = false;
  bool isChoice1Selected = false, isChoice2Selected = false;
  bool dateFilter = false;
  //late String password;
  late TextEditingController nameController;
  late TextEditingController idController;
  late TextEditingController emailController;
  late DateTime? date;
  TextEditingController newPasswordController = TextEditingController();
  List<Employee> employeeList = [];
  List<Employee?>? dummyList = [];

  filterLists(DateTime date) {
    dummyList = employeeList.map((emp) {
      List<Session> session = emp.sessions!.where((element) {
        return (DateFormat("yyyy-MM-dd")
                    .format(DateTime.parse(element.date!)) ==
                DateFormat("yyyy-MM-dd").format(date)) ==
            (element.sessionTime! > 2);
      }).toList();

      if (session.isNotEmpty) {
        return emp;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                },
                child: const ListTile(
                  leading: Icon(Icons.arrow_back),
                  title: Text(
                    "Sign Out",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SizedBox(
                          height: 250.0,
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Enter your new password",
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: newPasswordController,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    hintText: 'Password',
                                    suffixIcon: Icon(Icons.lock),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12.0),
                                      ),
                                    ),
                                  ),
                                  validator: (password) => password!.length < 8
                                      ? "Password length must be atleast 8 characters"
                                      : null,
                                ),
                              ),
                              const SizedBox(
                                height: 30.0,
                              ),
                              SizedBox(
                                height: 56.0,
                                width: MediaQuery.of(context).size.width - 40,
                                child: TextButton(
                                  onPressed: () {
                                    String newPassword =
                                        newPasswordController.text;
                                    AuthRepository.changePassword(newPassword);
                                    newPasswordController.clear();
                                  },
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    backgroundColor: Colors.black,
                                  ),
                                  child: const Text(
                                    "Sign In",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      });
                },
                child: const ListTile(
                  leading: Icon(Icons.lock_clock),
                  title: Text(
                    "Change Password",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person_add_alt),
                title: const Text(
                  "Register an Employee",
                  style: TextStyle(fontSize: 18.0),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text(
                  "Edit Employee Details",
                  style: TextStyle(fontSize: 18.0),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditDetails(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
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
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: Row(
                children: [
                  FilterChip(
                    onSelected: (value) async {
                      dateFilter = value;
                      date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2040),
                      );
                      setState(() {});
                    },
                    selected: dateFilter,
                    label: Row(
                      children: [
                        Text(
                          "Date",
                          style: TextStyle(
                              color: dateFilter ? Colors.white : Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: _isFilterSelected ? Colors.white : Colors.grey,
                        ),
                      ],
                    ),
                    side: const BorderSide(color: Colors.grey),
                    backgroundColor: Colors.white,
                    selectedColor: Colors.green.shade900,
                    checkmarkColor: Colors.white,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  FilterChip(
                    onSelected: (value) {
                      setState(
                        () {
                          _isFilterSelected = value;

                          if (_isFilterSelected == true) {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return SizedBox(
                                      height: 220.0,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Column(
                                            children: const [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 10.0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: Text(
                                                    "Work Hour",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Divider(
                                                color: Colors.black,
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Wrap(
                                                children: [
                                                  ChoiceChip(
                                                    label: Text(
                                                      "Less than 8 hours work",
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .bold,
                                                          color:
                                                              isChoice1Selected
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black),
                                                    ),
                                                    selected: isChoice1Selected,
                                                    selectedColor:
                                                        Colors.green.shade900,
                                                    disabledColor: Colors.white,
                                                    side: const BorderSide(
                                                        color: Colors.grey),
                                                    onSelected: (value) {
                                                      setState(() {
                                                        isChoice1Selected =
                                                            value;
                                                        if (isChoice2Selected) {
                                                          isChoice2Selected =
                                                              !value;
                                                        }
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    width: 8.0,
                                                  ),
                                                  ChoiceChip(
                                                    label: Text(
                                                      "More than 8 hours work",
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .bold,
                                                          color:
                                                              isChoice2Selected
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black),
                                                    ),
                                                    selected: isChoice2Selected,
                                                    selectedColor:
                                                        Colors.green.shade900,
                                                    disabledColor: Colors.white,
                                                    side: const BorderSide(
                                                        color: Colors.grey),
                                                    onSelected: (value) {
                                                      setState(() {
                                                        isChoice2Selected =
                                                            value;
                                                        if (isChoice1Selected) {
                                                          isChoice1Selected =
                                                              !value;
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 50.0,
                                              ),
                                              SizedBox(
                                                height: 56.0,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    40,
                                                child: TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  style: TextButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                    backgroundColor:
                                                        Colors.black,
                                                  ),
                                                  child: const Text(
                                                    "Show Result",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          }
                        },
                      );
                    },
                    selected: _isFilterSelected,
                    label: Row(
                      children: [
                        Text(
                          "Work Hour",
                          style: TextStyle(
                              color: _isFilterSelected
                                  ? Colors.white
                                  : Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: _isFilterSelected ? Colors.white : Colors.grey,
                        ),
                      ],
                    ),
                    side: const BorderSide(color: Colors.grey),
                    backgroundColor: Colors.white,
                    selectedColor: Colors.green.shade900,
                    checkmarkColor: Colors.white,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
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
                    DataRepository dataRepository = DataRepository();
                    dataRepository.initialiseList(users!);
                    List<Employee?> employee = [];

                    if (isChoice1Selected || isChoice2Selected) {
                      employee = dataRepository.filterOnWorkHour(
                          isChoice1Selected, isChoice2Selected, date);
                    }

                    if ((isChoice1Selected || isChoice2Selected) &&
                        date != null) {
                      employee = dataRepository.filterOnWorkHour(
                          isChoice1Selected, isChoice2Selected, date);
                    }

                    if (_isFilterSelected == false && dateFilter == false) {
                      employee = dataRepository.getEmployeeList();
                    }

                    if (employee.isNotEmpty) {
                      employee = employee.where((element) {
                        return element!.firstName
                            .toString()
                            .toLowerCase()
                            .startsWith(name!.toLowerCase());
                      }).toList();
                    }

                    //dummyList!.removeWhere((element) => element == null);
                    return ListView.builder(
                      itemCount: employee.length, //users!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: ListTile(
                                title: Text(
                                  "${employee[index]!.firstName.toString().toUpperCase()} ${employee[index]!.lastName.toString().toUpperCase()}",
                                ),
                                subtitle: Text(
                                  employee[index]!.emailId!,
                                ),
                              ),
                            ),
                          ),
                          onTap: () {
                            //log(users![index].toString());
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EmployeeTable(
                                  userData: users![index],
                                ), //EmployeeScreen(userData: users[index],),
                              ),
                            );
                          },
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
