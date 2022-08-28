import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erp_app/Data/authentication.dart';
import 'package:erp_app/Screens/employee_table_screen.dart';
import 'package:erp_app/Screens/issues_screen.dart';
import 'package:erp_app/Screens/login_screen.dart';
import 'package:erp_app/Screens/projects_screen.dart';
import 'package:erp_app/Screens/register_screen.dart';
import 'package:erp_app/blocs/filter/bloc/filter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  bool isChoice1Selected = false, isChoice2Selected = false;
  bool dateFilter = false;
  //late String password;
  late TextEditingController nameController;
  late TextEditingController idController;
  late TextEditingController emailController;
  DateTime? date;
  TextEditingController newPasswordController = TextEditingController();
  List<Employee> employeeList = [];
  List<Employee?>? dummyList = [];
  List<Employee> allUsers = [];

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
        backgroundColor: const Color(0xffe8eff9),
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
              ListTile(
                leading: const Icon(Icons.workspaces_filled),
                title: const Text(
                  "Projects",
                  style: TextStyle(fontSize: 18.0),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProjectScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.workspaces_filled),
                title: const Text(
                  "Issues",
                  style: TextStyle(fontSize: 18.0),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const IssueScreen(),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 9.0, left: 5.0, bottom: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
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
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                              return SizedBox(
                                height: 350.0,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: const [
                                          Padding(
                                            padding: EdgeInsets.only(top: 10.0),
                                            child: Align(
                                              alignment: Alignment.topCenter,
                                              child: Text(
                                                "Filters",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
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
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.indigo,
                                            // side: BorderSide(color: Colors.yellow, width: 5),
                                            textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontStyle: FontStyle.normal),
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                          ),
                                          onPressed: () async {
                                            date = await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2040),
                                            );
                                            setState(() {});
                                          },
                                          child: const Text(
                                            'Choose a Date',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          "Work Hour: ",
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            ChoiceChip(
                                              label: Text(
                                                "Less than 8 hours",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: isChoice1Selected
                                                        ? Colors.white
                                                        : Colors.black),
                                              ),
                                              selected: isChoice1Selected,
                                              selectedColor:
                                                  Colors.green.shade900,
                                              disabledColor: Colors.white,
                                              side: const BorderSide(
                                                  color: Colors.grey),
                                              onSelected: (value) {
                                                setState(() {
                                                  isChoice1Selected = value;
                                                  if (isChoice2Selected) {
                                                    isChoice2Selected = !value;
                                                  }
                                                });
                                              },
                                            ),
                                            const SizedBox(
                                              width: 10.0,
                                            ),
                                            ChoiceChip(
                                              label: Text(
                                                "More than 8 hours",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: isChoice2Selected
                                                        ? Colors.white
                                                        : Colors.black),
                                              ),
                                              selected: isChoice2Selected,
                                              selectedColor:
                                                  Colors.green.shade900,
                                              disabledColor: Colors.white,
                                              side: const BorderSide(
                                                  color: Colors.grey),
                                              onSelected: (value) {
                                                setState(() {
                                                  isChoice2Selected = value;
                                                  if (isChoice1Selected) {
                                                    isChoice1Selected = !value;
                                                  }
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0),
                                        child: SizedBox(
                                          height: 56.0,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              40,
                                          child: TextButton(
                                            onPressed: () {
                                              BlocProvider.of<FilterBloc>(
                                                      context)
                                                  .add(
                                                FilterClickedEvent(
                                                    dateTime: date,
                                                    workHour: isChoice1Selected
                                                        ? "Less"
                                                        : "More"),
                                              );
                                              Navigator.pop(context);
                                            },
                                            style: TextButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                              backgroundColor:
                                                  isChoice1Selected ||
                                                          isChoice2Selected
                                                      ? Colors.black
                                                      : Colors.grey,
                                            ),
                                            child: const Text(
                                              "Apply",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, right: 15.0),
                                        child: SizedBox(
                                          height: 56.0,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              40,
                                          child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                isChoice1Selected =
                                                    isChoice2Selected = false;
                                              });
                                              BlocProvider.of<FilterBloc>(
                                                      context)
                                                  .add(ClearFilterEvent());
                                              Navigator.pop(context);
                                            },
                                            style: TextButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                              backgroundColor:
                                                  isChoice1Selected ||
                                                          isChoice2Selected
                                                      ? Colors.black
                                                      : Colors.grey,
                                            ),
                                            child: const Text(
                                              "Clear",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),
                              );
                            });
                          });
                    },
                    icon: const Icon(Icons.filter_list),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocConsumer<FilterBloc, FilterState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is Loading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.orange,
                      ),
                    );
                  }

                  if (state is FilterInitial) {
                    return StreamBuilder<List<Employee>>(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .snapshots()
                          .map((snapshot) => snapshot.docs
                              .map(
                                (doc) => Employee.fromJson(doc.data()),
                              )
                              .toList()),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Employee?> employee = snapshot.data!.toList();

                          if (employee.isNotEmpty) {
                            employee = employee.where((element) {
                              return element!.firstName
                                  .toString()
                                  .toLowerCase()
                                  .startsWith(name!.toLowerCase());
                            }).toList();
                          }

                          return ListView.builder(
                            itemCount: employee.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
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
                                        userData: employee[index],
                                      ), //EmployeeScreen(userData: users[index],),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return const Center(
                              child: Text("Something went wrong"));
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    );
                  }
                  if (state is ShowFilterState) {
                    return ListView.builder(
                      itemCount: state.filteredEmployees.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ListTile(
                                title: Text(
                                  "${state.filteredEmployees[index]!.firstName.toString().toUpperCase()} ${state.filteredEmployees[index]!.lastName.toString().toUpperCase()}",
                                ),
                                subtitle: Text(
                                  state.filteredEmployees[index]!.emailId!,
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
                                  userData: state.filteredEmployees[index],
                                ), //EmployeeScreen(userData: users[index],),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                  return const Text("No Data Available");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
