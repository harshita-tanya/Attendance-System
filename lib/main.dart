import 'package:erp_app/Screens/login_screen.dart';
import 'package:erp_app/blocs/auth/bloc/auth_bloc.dart';
import 'package:erp_app/blocs/filter/bloc/filter_bloc.dart';
import 'package:erp_app/blocs/session/bloc/session_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: ((context) => FilterBloc())),
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => SessionBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Attendance',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color(0xffe8eff9),
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
