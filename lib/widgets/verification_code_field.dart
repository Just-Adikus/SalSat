import 'package:flutter/material.dart';

class VerificationCodeField extends StatefulWidget {
  final int length;
  final ValueChanged<String> onChanged;

  const VerificationCodeField({
    Key? key,
    required this.length,
    required this.onChanged,
  }) : super(key: key);

  @override
  _VerificationCodeFieldState createState() => _VerificationCodeFieldState();
}

class _VerificationCodeFieldState extends State<VerificationCodeField> {
  List<TextEditingController> controllers = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.length; i++) {
      TextEditingController controller = TextEditingController();
      controllers.add(controller);
      controller.addListener(() {
        updateCode();
      });
    }
  }

  void updateCode() {
    String code = '';
    for (TextEditingController controller in controllers) {
      code += controller.text;
    }
    widget.onChanged(code);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < widget.length; i++)
          Container(
            width: 50,
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: controllers[i],
              maxLength: 1,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                counterText: '',
                border: InputBorder.none,
              ),
                onSubmitted: (String value) {
                  if (i < widget.length - 1) {
                    FocusScope.of(context).nextFocus();
                  }
                },
            ),
          ),
      ],
    );
  }
}

