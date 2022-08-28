import 'package:erp_app/blocs/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) : _formKey = formKey, _emailController = emailController, _passwordController = passwordController, super(key: key);

  final GlobalKey<FormState> _formKey;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Column(
                children: [
                  Text(
                    "Welcome Back!",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Text(
                    "Sign in to your account!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 60.0,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, left: 18.0, right: 18.0, bottom: 10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
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
                    const SizedBox(
                      height: 15.0,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
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
                    onPressed: () {
                      final isValidForm =
                          _formKey.currentState!.validate();
                      final email = _emailController.text.trim();
                      final password =
                          _passwordController.text.trim();
                      if (isValidForm) {
                        BlocProvider.of<AuthBloc>(context).add(
                          LoginRequested(
                              email, password, isValidForm),
                        );
                      }

                      // } else {
                      //   Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => UserTable(
                      //           userId: credential.user!.uid,
                      //           userData: data,
                      //           loginTime: DateTime.now()),
                      //     ),
                      //   );
                      // }
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}