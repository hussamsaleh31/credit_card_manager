import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_colors.dart';
import 'circle_button.dart';
import 'credit_card_widget.dart';
import 'helpers/card_helpers.dart';
import 'models/card.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<List<Color>> _colors;
  bool checkBoxValue = false;
  List<CreditCard> _cards;
  bool isLoading;
  bool isAdding;

  final Color greyColor = Color(0xFFd4d8e2);

  TextEditingController cardNumberController;
  TextEditingController nameController;
  TextEditingController monthController;
  TextEditingController yearController;
  TextEditingController codeController;

  FocusNode cardNumberNode;
  FocusNode nameNode;
  FocusNode monthNode;
  FocusNode yearNode;
  FocusNode codeNode;

  int addedId;
  CreditCard newCard;
  var curDate = DateTime.now();
  int thisYear;

  @override
  void initState() {
    _colors = [
      AppColors.blackGradient,
      AppColors.blueGradient,
      AppColors.greenGradient,
      AppColors.orangeGradient,
      AppColors.redGradient,
      AppColors.purpleGradient,
    ];

    isLoading = true;
    isAdding = false;
    _cards = [];

    readCards().then((value) {
      if (mounted)
        setState(() {
          isLoading = false;
          _cards = value;
        });
    });

    newCard = CreditCard();

    thisYear = DateTime.now().year % 100;

    cardNumberNode = FocusNode();
    nameNode = FocusNode();
    monthNode = FocusNode();
    yearNode = FocusNode();
    codeNode = FocusNode();

    monthController = new TextEditingController();
    monthController.addListener(() {
      setState(() {
        newCard.cardMonth = int.tryParse(monthController.text);
      });
    });

    codeController = new TextEditingController();
    codeController.addListener(() {
      setState(() {
        newCard.cardCode = int.tryParse(codeController.text);
      });
    });

    yearController = new TextEditingController();
    yearController.addListener(() {
      setState(() {
        newCard.cardYear = int.tryParse(yearController.text);
      });
    });

    nameController = new TextEditingController();
    nameController.addListener(() {
      setState(() {
        newCard.cardName = nameController.text;
      });
    });

    cardNumberController = new TextEditingController();
    cardNumberController.addListener(() {
      setState(() {
        newCard.cardNumber = int.tryParse(cardNumberController.text);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    nameController.dispose();
    monthController.dispose();
    yearController.dispose();
    codeController.dispose();
    cardNumberNode?.dispose();
    nameNode?.dispose();
    monthNode?.dispose();
    yearNode?.dispose();
    codeNode?.dispose();
    super.dispose();
  }

  void deleteCard(int id) async {
    setState(() {
      _cards.removeWhere((element) => element.id == id);
    });
    List<Map> dataMap = _cards.map((e) => e.toJson()).toList();
    String dataStr = jsonEncode(dataMap);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('Credit_Cards', dataStr);
  }

  void addCard() async {
    FocusScope.of(context).unfocus();
    bool shouldInsert = true;
    CreditCard cardToAdd = newCard.copy();
    cardToAdd.id = DateTime.now().microsecondsSinceEpoch;

    for (int i = 0; i < _cards.length; i++) {
      if (cardToAdd.isSameNumber(_cards[i])) {
        if (cardToAdd.isEqual(_cards[i])) {
          // show error
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                height: 300,
                child: Center(
                    child: Text(
                  "card number already exists",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                  ),
                )),
              );
            },
            // child: Text("card number already exists"),
          );
          // break the function
          return;
        }
        // card exists but with different date
        shouldInsert = false;
        _cards[i].cardMonth = cardToAdd.cardMonth;
        _cards[i].cardYear = cardToAdd.cardYear;
        _cards[i].cardCode = cardToAdd.cardCode;
      }
    }
    setState(() {
      addedId = cardToAdd.id;
      isAdding = true;
      if (shouldInsert) _cards.insert(0, cardToAdd);
      newCard = CreditCard();
    });
    cardNumberController.clear(); // newCard.cardNumber = null;
    nameController.clear(); // newCard.name = null;
    monthController.clear(); // newCard.month = null;
    yearController.clear(); // newCard.year = null;
    codeController.clear();
    // Save the new list of cards to shared prefs
    List<Map> dataMap = _cards.map((e) => e.toJson()).toList();
    String dataStr = jsonEncode(dataMap);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('Credit_Cards', dataStr);

    if (mounted)
      setState(() {
        isAdding = false;
      });
  }

  bool get cardNameValid {
    return newCard.cardName != null && newCard.cardName.isNotEmpty;
  }

  bool get cardYearValid {
    return newCard.cardYear != null &&
        newCard.cardYear.toString().length == 2 &&
        newCard.cardYear >= thisYear;
  }

  bool get cardCodeValid {
    return newCard.cardCode != null && newCard.cardCode.toString().length <= 4;
  }

  bool get cardMonthValid {
    return newCard.cardMonth != null &&
        newCard.cardMonth <= 12 &&
        newCard.cardMonth > 0;
  }

  bool get isValid {
    return newCard.cardNumber != null &&
        newCard.cardNumber.toString().length == 16 &&
        cardNameValid &&
        cardMonthValid &&
        cardYearValid &&
        cardCodeValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Card'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: ImageIcon(
              AssetImage('assets/images/qr.png'),
              color: Color(0xFF5560b4),
              size: 35,
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
            padding: EdgeInsets.only(bottom: 100),
              children: [
                Container(
                  height: 255.0,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(20),
                    scrollDirection: Axis.horizontal,
                    itemCount: _cards.length + 1,
                    itemBuilder: (context, i) {
                      if (i == 0)
                        return CreditCardWidget(
                          card: newCard,
                          showButton: false,
                        );
                      return CreditCardWidget(
                        hasAnimation: _cards[i - 1].id == addedId,
                        key: Key(_cards[i - 1].id.toString()),
                        card: _cards[i - 1],
                        onDelete: () {
                          deleteCard(_cards[i - 1].id);
                        },
                        onAnimationComplete: () {
                          setState(() {
                            addedId = null;
                          });
                        },
                      );
                    },
                    separatorBuilder: (context, i) {
                      return SizedBox(width: 20);
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Pick Color',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 50,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    scrollDirection: Axis.horizontal,
                    itemCount: _colors.length,
                    itemBuilder: (_, i) {
                      /// 3 cases:
                      /// 1. No color is selected
                      /// 2. This color is slected
                      /// 3. Other color is selected

                      List<Color> displayColor;

                      if (newCard.cardColor == null)
                        displayColor = _colors[i];
                      else if (_colors[i] == newCard.cardColor)
                        displayColor = _colors[i];
                      else
                        displayColor =
                            _colors[i].map((e) => e.withOpacity(.5)).toList();

                      return CircleButton(
                        onTap: isAdding
                            ? null
                            : () {
                                setState(() {
                                  newCard.cardColor = _colors[i];
                                  newCard.textColor = Colors.white;
                                  newCard.borderColor = null;
                                });
                              },
                        color: displayColor,
                        diameter: 50,
                      );
                    },
                    separatorBuilder: (_, i) {
                      return SizedBox(width: 10);
                    },
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Divider(
                    thickness: 1,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Card Number',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    controller: cardNumberController,
                    focusNode: cardNumberNode,
                    maxLength: 16,
                    enabled: !isAdding,
                    buildCounter: (context,
                        {int currentLength, bool isFocused, int maxLength}) {
                      return SizedBox.shrink();
                    },
                    keyboardType: TextInputType.numberWithOptions(),
                    textInputAction: TextInputAction.next,
                    onSubmitted: (String value) {
                      FocusScope.of(context).requestFocus(nameNode);
                    },
                    onChanged: (String value) {
                      if (value.length == 16)
                        FocusScope.of(context).requestFocus(nameNode);
                    },
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      hintText: '0000 0000 000 0000',
                      hintStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: greyColor),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    'Full Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    textInputAction: TextInputAction.next,
                    onSubmitted: (String value) {
                      FocusScope.of(context).requestFocus(monthNode);
                    },
                    controller: nameController,
                    focusNode: nameNode,
                    enabled: !isAdding,
                    decoration: InputDecoration(
                      hintText: 'Name SURNAME',
                      hintStyle: TextStyle(color: greyColor),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Month',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            TextField(
                              maxLength: 2,
                              focusNode: monthNode,
                              enabled: !isAdding,
                              textInputAction: TextInputAction.next,
                              onSubmitted: (String value) {
                                FocusScope.of(context).requestFocus(yearNode);
                              },
                              buildCounter: (context,
                                  {int currentLength,
                                  bool isFocused,
                                  int maxLength}) {
                                return SizedBox.shrink();
                              },
                              controller: monthController,
                              keyboardType: TextInputType.numberWithOptions(),
                              inputFormatters: [
                                WhitelistingTextInputFormatter.digitsOnly,
                                TextInputFormatter.withFunction(
                                    (oldValue, newValue) {
                                  int newMonth = int.tryParse(newValue.text);
                                  if (newMonth == null) return newValue;
                                  if (newMonth > 12) return oldValue;
                                  return newValue;
                                }),
                              ],
                               onChanged: (String value) {
                                if ((value.length ==1 && int.tryParse(value)>1) || (value.length==2))
                                  FocusScope.of(context).requestFocus(yearNode);
                              },
                              decoration: InputDecoration(
                                hintText: '00',
                                hintStyle: TextStyle(color: greyColor),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Year',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            TextField(
                              maxLength: 2,
                              focusNode: yearNode,
                              textInputAction: TextInputAction.next,
                              onSubmitted: (String value) {
                                FocusScope.of(context).requestFocus(codeNode);
                              },
                              onChanged: (String value) {
                                if (value.length == 2)
                                  FocusScope.of(context).requestFocus(codeNode);
                              },
                              enabled: !isAdding,
                              controller: yearController,
                              buildCounter: (context,
                                  {int currentLength,
                                  bool isFocused,
                                  int maxLength}) {
                                return SizedBox.shrink();
                              },
                              keyboardType: TextInputType.numberWithOptions(),
                              inputFormatters: [
                                WhitelistingTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                hintText: '00',
                                hintStyle: TextStyle(color: greyColor),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    'CVV',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    focusNode: codeNode,
                    maxLength: 4,
                    enabled: !isAdding,
                    controller: codeController,
                    buildCounter: (context,
                        {int currentLength, bool isFocused, int maxLength}) {
                      return SizedBox.shrink();
                    },
                    keyboardType: TextInputType.numberWithOptions(),
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      hintText: '801',
                      hintStyle: TextStyle(color: greyColor),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  height: 50.0,
                  child: Material(
                    color: Colors.transparent,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      disabledColor: greyColor,
                      color: AppColors.primary,
                      onPressed: isAdding || !isValid ? null : addCard,
                      child: Center(
                        child: Text(
                          'Add card',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat'),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
    );
  }
}
