import 'dart:math';

class UtilityHelper{
  static String generatePassword(){
    const length = 8;
    const lettersLowercase = 'abcdefghijklmnopqrstuvwxyz';
    const lettersUppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    const special = '@#=+!\$%&?{}()';

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