import 'package:erp_app/Data/Jira/jira_data_source.dart';
import 'package:erp_app/Screens/admin_screen.dart';
import 'package:erp_app/Screens/user_table.dart';
import 'package:erp_app/Widgets/login_form.dart';
import 'package:erp_app/blocs/empTable/bloc/emp_table_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async{
   await JiraDataSource().fetchProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
          BlocProvider<EmpTableBloc>(create: (context) => EmpTableBloc()),
        ],
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccessState) {
              if (state.isAdmin! && state.isValidForm!) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AdminDashboard()));
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserTable(
                      loginTime: DateTime.now(),
                      userId: state.uid,
                      employee: state.employee,
                    ),
                  ),
                );
              }
            }

            if (state is AuthFailureState) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
          },
          builder: (context, state) {
            if (state is LoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is AuthInitial) {
              return LoginForm(formKey: _formKey, emailController: _emailController, passwordController: _passwordController);
            }
            return Container();
          },
        ),
      ),
    );
  }
}


