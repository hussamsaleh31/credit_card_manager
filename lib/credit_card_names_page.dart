import 'package:bank/circle_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'helpers/card_helpers.dart';
import 'models/card.dart';

class CreditCardNames extends StatefulWidget {
  @override
  _CreditCardNamesState createState() => _CreditCardNamesState();
}

class _CreditCardNamesState extends State<CreditCardNames> {
  List<CreditCard> cards;
  bool isLoading;

  @override
  void initState() {
    cards = [];
    isLoading = true;
    readCards().then((value) {
      if (mounted)
        setState(() {
          cards = value;
          isLoading = false;
        });
    });
    super.initState();
  }

  Widget buildBody() {
    if (isLoading)
      return Center(
        child: CircularProgressIndicator(),
      );
    if (cards.isEmpty)
      return Center(
        child: Text('No cards Added'),
      );
    return ListView.separated(
      scrollDirection: Axis.vertical,
      itemCount: cards.length,
      itemBuilder: (context, i) {
        return ListTile(
          title: Text(cards[i].cardName),
          subtitle: Text(cards[i].cardNumber.toString()),
          leading: CircleButton(color: cards[i].cardColor),
          dense: true,
          visualDensity: VisualDensity.compact,
          onTap: () {},
        );
      },
      separatorBuilder: (context, index) {
        return Divider(height: 1);
      },
    );
  }

  Widget buildAppBar() {
    return AppBar(
      title: Text('Names'),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }
}
