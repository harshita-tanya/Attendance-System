import 'dart:convert';
import 'package:http/http.dart' as http;

Future sendEmail(String name, String email, String password) async {
  const String serviceId = "service_1zxblfm";
  const String templateId = "template_fir059e";
  const String userId = "ELrjh9ODttWahclLG";

  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

  try {
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json'
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'to_name': name,
          'to_mail': email,
          'password': password
        },
      }),
    );
    print(response.body);
  } catch (error) {
    print('email failed to send');
  }
}
