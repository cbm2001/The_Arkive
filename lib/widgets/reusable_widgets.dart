import 'package:flutter/material.dart';

/*Image logoWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: 240,
    height: 240,
    color: Colors.white,
  );
}*/

TextField reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.black,
    style: TextStyle(color: Colors.black),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        //color: Colors.white70,
        color: Colors.black.withOpacity(0.5),
      ),
      labelText: text,
      //labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      labelStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white,
      border: OutlineInputBorder(
          //borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(
        width: 30.0,
        style: BorderStyle.solid,
        color: Colors.black87,
      )),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

Container firebaseUIButton(BuildContext context, String title, Function onTap) {
  return Container(
    //width: MediaQuery.of(context).size.width,
    //height: 50,
    //decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      child: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      style: ElevatedButton.styleFrom(
        /*backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.grey[400];
            }
            return Colors.black87;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),*/
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        fixedSize: Size(350, 30),
      ),
    ),
  );
}
