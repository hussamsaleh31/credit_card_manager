import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'models/card.dart';

class CardDetails extends StatefulWidget {
  final CreditCard card;

  const CardDetails({Key key, this.card}) : super(key: key);

  @override
  _CardDetailsState createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {
  String initials;
  String firstName;
  String lastName;
  List space;
  @override
  void initState() {
    space = widget.card.cardName.split(" ");
    firstName = space[0];
    lastName = space[1];
    initials = firstName[0].toUpperCase() + lastName[0].toUpperCase();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Card Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image(image: AssetImage('assets/images/creditCard5.png')),
            SizedBox(height: 20),
            getRow(
              'Card Holder',
              (widget.card.cardName.toUpperCase()),
              text1Style: TextStyle(fontSize: 18, fontFamily: 'hussam'),
            ),
            getRow('Card Number', widget.card.cardNumber.toString()),
            getRow('Expiry Date', getDate()),
            getRow('Card Code', widget.card.cardCode.toString()),
          ],
        ),
      ),
    );
  }

  String getDate() {
    final String paddedMonth =
        widget.card.cardMonth?.toString()?.padLeft(2, '0') ?? '00';
    final String paddedYear =
        widget.card.cardYear?.toString()?.padLeft(2, '0') ?? '00';
    return paddedMonth + '/' + paddedYear;
  }

  Widget getRow(String text, String text1, {TextStyle text1Style}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text1,
              style: text1Style != null
                  ? text1Style
                  : TextStyle(
                      fontFamily: 'hussam',
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
