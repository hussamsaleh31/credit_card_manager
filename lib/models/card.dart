import 'package:bank/app_colors.dart';
import 'package:flutter/material.dart';

class CreditCard {
  int id;
  int cardNumber;
  String cardName;
  int cardMonth;
  int cardYear;
  int cardCode;
  List<Color> cardColor;
  Color textColor;
  Color borderColor;

  CreditCard({
    this.id,
    this.cardNumber,
    this.cardMonth,
    this.cardYear,
    this.cardName,
    this.cardColor,
    this.cardCode,
    this.textColor = AppColors.primary,
    this.borderColor = AppColors.primary,
  });

  Map<String, dynamic> toJson() {
    return {
      'card_id': this.id,
      'card_number': this.cardNumber,
      'expiry_month': this.cardMonth,
      'expiry_year': this.cardYear,
      'name': this.cardName,
      'card_color': this.cardColor?.map((e) => e.value)?.toList(),
      'card_code': this.cardCode,
      'text_color': this.textColor?.value,
      'border_color': this.borderColor?.value,
    };
  }

  static CreditCard fromJson(Map<String, dynamic> json) {
    return CreditCard(
      id: json['card_id'],
      cardNumber: json['card_number'],
      cardMonth: json['expiry_month'],
      cardYear: json['expiry_year'],
      cardName: json['name'],
      cardColor: json['card_color'] != null
          ? (json['card_color'] as List).map((e) => Color(e)).toList()
          : null,
      cardCode:json['card_code'],    
      textColor: json['text_color'] != null ? Color(json['text_color']) : null,
      borderColor:
          json['border_color'] != null ? Color(json['border_color']) : null,
    );
  }

  CreditCard copy() {
    return CreditCard.fromJson(this.toJson());
  }

  bool isSameNumber(CreditCard a) {
    return a.cardNumber == this.cardNumber;
  }

  bool isEqual(CreditCard a) {
    return a.cardNumber == this.cardNumber &&
        a.cardMonth == this.cardMonth &&
        a.cardYear == this.cardYear;
  }
}
