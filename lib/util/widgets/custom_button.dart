import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  final String buttonLabel;
  final Widget? nextPage;
  final Color? btnColor;
  final VoidCallback? submit;

  const CustomButton({
    required this.buttonLabel,
    this.nextPage,
    this.btnColor,
    this.submit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: TextButton(
          style: TextButton.styleFrom(backgroundColor: btnColor ?? Colors.red),
          onPressed: submit ??
              () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => nextPage!),
                  ),
          // onPressed: (){
          //   Navigator.push(context, MaterialPageRoute(builder: (context)=>   summit ?? Placeholder()));
          // },
          child: Text(
            buttonLabel,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
