
import 'dart:convert';
import 'package:bank/models/card.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<CreditCard>> readCards() async {
  final prefs = await SharedPreferences.getInstance();
  // Read stored string from shared prefs
  String data = prefs.getString('Credit_Cards');
  if (data == null || data == "") return [];
  // Convert the string to json
  List dataMaps = jsonDecode(data);
  // Convert the list of json objects to a list of cards
  List<CreditCard> dataCards = dataMaps.map((map) {
    return CreditCard.fromJson(map);
  }).toList();
  await Future.delayed(Duration(milliseconds: 600));
  return dataCards;
}
