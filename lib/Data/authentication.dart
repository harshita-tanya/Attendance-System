import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erp_app/Models/session.dart';
import 'package:erp_app/Models/user.dart';
import 'package:erp_app/Screens/admin_screen.dart';
import 'package:erp_app/Screens/login_screen.dart';
import 'package:erp_app/constants.dart';
import 'package:erp_app/mailer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<UserCredential?> register(
      String? email, String? password, BuildContext context) async {
    try {
      UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email!, password: password!);
      if (credential.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Employee Registered Successfully"),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AdminDashboard(),
          ),
        );
      }
      return credential;
    } on FirebaseAuthException catch (exception) {
      if (exception.code == "email-already-in-use") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Email Id already exists"),
          ),
        );
      }
      log(exception.toString());
    }
    return null;
  }

  Future<String?> login({String? email, String? password}) async {
    try {
      UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email!, password: password!);
      return credential.user!.uid;
    } on FirebaseAuthException catch (exception) {
      log(exception.toString());
      if (exception.code == "user-not-found") {
        return "No User Found";
      } else if (exception.code == "wrong-password") {
        return "Invalid Password !";
      }
    }
    return null;
  }

  void signOutUser(Session session, String userID) async{
    FirebaseAuth.instance.signOut().then((value) => session.addSession(session, userID));
  }
}

class DataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Employee> getData(String? userId) async {
    Employee employee = await _firestore
        .collection("users")
        .doc(userId)
        .get()
        .then((value) => Employee.fromJson(value.data()!));
    return employee;
  }

  void postData(String? userId, Employee? employee) async {
    await _firestore.collection("users").doc(userId).set({
      "name": employee!.firstName,
      "last_name": employee.lastName,
      "userId": userId,
      "email_id": employee.emailId,
      "isAdmin": false,
      "sessions": []
    });
  }

  Future<List<Map<String, dynamic>>> fetchEmployeeList() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('users').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  void updateData(
      String? userId, String? attributeToUpdate, String? updatedValue) async {
    await _firestore.collection("users").doc(userId).update({
      attributeToUpdate!: updatedValue,
    });
  }

  void deleteData(String? userId) async {
    await _firestore.collection("users").doc(userId).delete();
  }

  void addEmployeeRequest(Employee employee) async {
    await _firestore.collection('users').doc().set({
      "first_name": employee.firstName,
      "last_name": employee.lastName,
      "email_id": employee.emailId,
      "isAdmin": false,
      "isApproved": false,
      "sessions": [],
    });
  }
}

class AuthRepository {
  static void storeUserData(String? email, String? password,
      BuildContext context, Employee? employee) async {
    UserCredential? credential =
        await AuthService().register(email, password, context);

    if (credential?.user != null) {
      DataService().postData(credential!.user!.uid, employee);
    }
  }



  static void acceptUserRequest(
      String email, BuildContext context, Employee employee) async {
//     if permitted:
//   autogenerate password
//   register with email id and autogenerated password
//   store data in firestore
//   delete document from requests collection
//   send approval email
    String password = UtilityHelper.generatePassword();
    UserCredential? credential =
        await AuthService().register(email, password, context);
    DataService().postData(credential!.user!.uid, employee);
    sendEmail(employee.firstName!, email, password);
  }

  static void deleteRequest(String email) async {
    QuerySnapshot<Map<String, dynamic>> userDocument = await FirebaseFirestore
        .instance
        .collection('users')
        .where("email_id", isEqualTo: email)
        .get();
    userDocument.docs.first.reference.delete();
  }

  static void changePassword(String password) async {
    final User? user = FirebaseAuth.instance.currentUser;
    user!.updatePassword(password).then((value) => FirebaseAuth.instance.signOut());
    FirebaseAuth.instance.signOut();
  }
}

moveBackToLoginScreen(BuildContext context){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
}

class UserDataService {
  List<Employee> employees = [];
  List<Employee> get getUsersList => employees;
  Future<List<Employee>> getAllUsers() async {
    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((snapshot) => snapshot.docs.forEach((doc) {
              Employee employee = Employee.fromJson(doc.data());
              employees.add(employee);
            }));
    return employees;
  }
}
