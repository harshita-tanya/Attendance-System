import 'dart:math';

class UtilityHelper{
  static String generatePassword(){
    final length = 8;
    final lettersLowercase = 'abcdefghijklmnopqrstuvwxyz';
    final lettersUppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final numbers = '0123456789';
    final special = '@#=+!\$%&?{}()';

    String chars = '';
    chars += '$lettersLowercase$lettersUppercase';
    chars += '$numbers';
    chars += '$special';

    return List.generate(length, (index){
       final randomIndex = Random.secure().nextInt(chars.length);
       return chars[randomIndex];
    }).join('');

  }
}