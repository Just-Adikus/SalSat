import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sal_sat/views/shipping_screen.dart';
import 'package:sal_sat/widgets/paypal_payment_widget.dart';
import 'package:sal_sat/widgets/stripe_payment_widget.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _selectedPaymentMethod;

  Widget _getPaymentWidget() {
    switch (_selectedPaymentMethod) {
      case 'Stripe':
        return StripePaymentWidget();
      case 'PayPal':
        return PayPalPaymentWidget();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment_Methods'.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            DropdownButton<String>(
              value: _selectedPaymentMethod,
              hint: Text('Select_a_Payment_Method'.tr),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPaymentMethod = newValue;
                });
              },
              items: <String>['Stripe', 'PayPal']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            // Добавьте необходимые виджеты ввода для выбранного способа оплаты
            _getPaymentWidget(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Реализуйте логику обработки платежа здесь
                // Перейти к экрану ShippingScreen после успешной оплаты
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShippingScreen(),
                  ),
                );
              },
              child: Text('Continue_with_delivery'.tr),
            ),
          ],
        ),
      ),
    );
  }
}

