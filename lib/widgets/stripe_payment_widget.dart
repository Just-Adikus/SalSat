import 'package:flutter/material.dart';

class StripePaymentWidget extends StatelessWidget {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _cardNumberController,
          decoration: InputDecoration(
            labelText: 'Card Number',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10),
        TextField(
          controller: _expiryDateController,
          decoration: InputDecoration(
            labelText: 'Expiry Date (MM/YY)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.datetime,
        ),
        SizedBox(height: 10),
        TextField(
          controller: _cvcController,
          decoration: InputDecoration(
            labelText: 'CVC',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}
