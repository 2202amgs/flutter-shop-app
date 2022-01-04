import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';

// text input
TextFormField customTextField({
  required String label,
  required Icon prefix,
  required TextEditingController controller,
  required TextInputType type,
  required FormFieldValidator<String>? validator,
  ValueChanged<String>? onSubmit,
  bool isPassword = false,
  IconButton? suffix,
}) {
  return TextFormField(
    keyboardType: type,
    controller: controller,
    validator: validator,
    obscureText: isPassword,
    decoration: InputDecoration(
      label: Text(label),
      border: const OutlineInputBorder(),
      prefixIcon: prefix,
      suffixIcon: suffix,
    ),
    onFieldSubmitted: onSubmit,
  );
}

// button
Container customButton(
  context, {
  required String text,
  required var action,
  Color color = Colors.white,
  double height = 50,
  Color? bgColor,
}) {
  return Container(
    width: double.infinity,
    height: height,
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(3.0)),
      color: bgColor ?? Theme.of(context).primaryColor,
    ),
    child: MaterialButton(
      onPressed: action,
      child: Text(
        text,
        style: TextStyle(
          color: color,
        ),
      ),
    ),
  );
}

//navigation
void navigateAndReplace(BuildContext context, Widget widget) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => widget),
    (route) => false,
  );
}

void navigate(BuildContext context, Widget widget) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => widget),
  );
}

// flutter toast
dynamic toast(
  BuildContext context,
  String messge, {
  Color color = Colors.green,
}) {
  return FlutterToastr.show(
    messge,
    context,
    duration: FlutterToastr.lengthLong,
    position: FlutterToastr.bottom,
    backgroundColor: color,
  );
}
