import 'dart:math';

String cidGenerator() {
  final charList = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  String id = '';

  for(int i=0; i<4; i++) {
    int randomNumber = Random().nextInt(52);
    id = id + charList.substring(randomNumber, randomNumber+1);
  }
  id = id + '-';
  for(int i=0; i<4; i++) {
    int randomNumber = Random().nextInt(52);
    id = id + charList.substring(randomNumber, randomNumber+1);
  }
  return id;
}