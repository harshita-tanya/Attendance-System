import 'package:erp_app/Data/authentication.dart';
import 'package:erp_app/Models/user.dart';
import 'package:erp_app/constants.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _authService = AuthService();
  bool value = false;
  final _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        title: const Text("Create Account", style: TextStyle(color: Colors.black),),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 20.0, left: 18.0, right: 18.0, bottom: 10.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                          ),
                        ),
                        validator: (name) =>
                            name == null ? "Please enter first name" : null,
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      TextFormField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                          ),
                        ),
                        validator: (name) =>
                            name == null ? "Please enter last name" : null,
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email ID',
                          suffixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                          ),
                        ),
                        validator: (email) => email != null &&
                                !RegExp(r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$')
                                    .hasMatch(email)
                            ? 'Enter a valid email id'
                            : null,
                        autofillHints: const [AutofillHints.email],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 40.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 56,
                    child: TextButton(
                      onPressed: () async {
                        final isValidForm = _formKey.currentState!.validate();

                        final Employee employee = Employee(
                          firstName: _firstNameController.text.trim(),
                          lastName: _lastNameController.text.trim(),
                          emailId: _emailController.text.trim(),
                        );

                        if (isValidForm) {
                          //var userId = credential.user!.uid;
                          //DataService().postData(userId, employee);

                          AuthRepository.acceptUserRequest(
                              employee.emailId!, context, employee);
                          
                        }
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        backgroundColor: Colors.black,
                      ),
                      child: const Text(
                        "Register",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
