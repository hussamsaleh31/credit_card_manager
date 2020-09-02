import 'dart:ui';

import 'package:bank/models/card.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

class CreditCardWidget extends StatefulWidget {
  final CreditCard card;
  final bool showButton;
  final VoidCallback onDelete;
  final bool hasAnimation;
  final VoidCallback onAnimationComplete;

  /// A widget that displays a credit card

  const CreditCardWidget({
    Key key,
    this.onDelete,
    this.card,
    this.showButton = true,
    this.hasAnimation = false,
    this.onAnimationComplete,
  }) : super(key: key);

  @override
  _CreditCardWidgetState createState() => _CreditCardWidgetState();
}

class _CreditCardWidgetState extends State<CreditCardWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  void initState() {
    _animationController = AnimationController(
      value: widget.hasAnimation ? 0 : 1,
      vsync: this,
      duration: Duration(milliseconds: 250),
    );

    _animationController.addListener(() {
      setState(() {});
    });
    if (widget.hasAnimation) {
      _animationController
          .forward()
          .then((value) => widget.onAnimationComplete());
    }
    super.initState();
  }

  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String getFormattedNumber() {
    // convert cardNumber to string of 4-digit numbers divided by spaces
    final String paddedNumber =
        widget.card.cardNumber.toString().padRight(16, '0');
    return paddedNumber.substring(0, 4) +
        ' ' +
        paddedNumber.substring(4, 8) +
        ' ' +
        paddedNumber.substring(8, 12) +
        ' ' +
        paddedNumber.substring(12, 16);
  }

  String getDate() {
    final String paddedMonth =
        widget.card.cardMonth?.toString()?.padLeft(2, '0') ?? '00';
    final String paddedYear =
        widget.card.cardYear?.toString()?.padLeft(2, '0') ?? '00';
    return paddedMonth + '/' + paddedYear;
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle creditStyle = TextStyle(
      fontFamily: 'hussam',
      color: widget.card.textColor,
      fontSize: 10,
    );

    BoxBorder border;

    if (widget.card.borderColor != null) {
      border = Border.all(
        color: widget.card.borderColor,
      );
    }

    return FlipCard(
      front: FadeTransition(
        opacity: _animationController,
        child: SlideTransition(
          position: Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
              .animate(CurvedAnimation(
                  parent: _animationController, curve: Curves.easeOut)),
          child: Container(
            width: 340,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                )
              ],
              border: border,
              borderRadius: BorderRadius.circular(20),
              gradient: widget.card.cardColor != null
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: widget.card.cardColor,
                    )
                  : null,
            ),
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/mastercard.png',
                      color: widget.card.textColor,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      width: 28,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'mastercard',
                      style: TextStyle(
                        color: widget.card.textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(child: Container()),
                    Opacity(
                      opacity: (widget.showButton ?? false) ? 1 : 0,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        tooltip: 'delete',
                        onPressed: (widget.showButton ?? false)
                            ? () {
                                _animationController
                                    .reverse()
                                    .then((value) => widget.onDelete());
                              }
                            : null,
                        icon: ImageIcon(
                          AssetImage('assets/images/delete-2.png'),
                          color: widget.card.textColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/card_chip-512.png',
                      color: widget.card.textColor,
                      fit: BoxFit.fill,
                      alignment: Alignment.centerLeft,
                      width: 50,
                    ),
                    ImageIcon(
                      AssetImage('assets/images/nfc.png'),
                      color: widget.card.textColor,
                      size: 50,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  widget.card.cardNumber == null
                      ? '0000 0000 0000 0000'
                      : getFormattedNumber(),
                  style: creditStyle.copyWith(fontSize: 14),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.card.cardName == null ||
                              widget.card.cardName.isEmpty
                          ? 'Name  SURNAME'
                          : widget.card.cardName,
                      style: TextStyle(
                        color: widget.card.textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      getDate(),
                      style: creditStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      back: Container(
        width: 340,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
            )
          ],
          border: border,
          borderRadius: BorderRadius.circular(20),
          gradient: widget.card.cardColor != null
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: widget.card.cardColor,
                )
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Container(
              height: 40,
              color: Colors.black,
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Padding(padding: const EdgeInsets.all(15)),
                Container(
                  padding: EdgeInsets.all(10),
                  height: 35,
                  color: Colors.blue,
                  child: Text(
                    widget.card.cardName == null
                        ? 'Name  SURNAME'
                        : widget.card.cardName,
                    style: TextStyle(
                      fontSize: 15,
                      color: widget.card.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 50),
                Container(
                  height: 40.0,
                  width: 60.0,
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    border: new Border.all(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  child: new TextField(
                    textAlign: TextAlign.center,
                    decoration: new InputDecoration(
                      hintText: '1',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 250),
              child: Image.asset(
                'assets/images/mastercard.png',
                color: widget.card.textColor,
                fit: BoxFit.cover,
                alignment: Alignment.center,
                width: 35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}