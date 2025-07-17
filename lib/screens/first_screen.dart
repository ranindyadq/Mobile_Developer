import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:application/providers/app_state_provider.dart';
import 'package:application/providers/palindrome_provider.dart';
import 'package:application/screens/second_screen.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController sentenceController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    sentenceController.dispose();
    super.dispose();
  }

  void _showPalindromeDialog(bool isPalindrome) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Palindrome Check Results"),
          content: Text(isPalindrome ? "isPalindrome" : "not palindrome"),
          backgroundColor: Colors.white,
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final palindromeProvider = Provider.of<PalindromeProvider>(
      context,
      listen: false,
    );

    const Color buttonColor = Color(0xFF2A637B);
    const Color borderColor = Color(0xFFE2E3E4);
    const Color placeholderColor = Color(0x5B686777);

    const TextStyle poppinsMediumStyle = TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background1.png"),
            fit: BoxFit.cover,
          ),
        ),

        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 186),
              Center(
                child: Image.asset(
                  'assets/images/btn_add_photo.png',
                  width: 116,
                  height: 116,
                ),
              ),

              const SizedBox(height: 51),

              Container(
                height: 47,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 255, 255, 0.9),
                  border: Border.all(color: borderColor, width: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Name',
                    hintStyle: poppinsMediumStyle.copyWith(
                      fontSize: 16,
                      color: placeholderColor,
                    ),
                    border: InputBorder.none,
                    isDense: true,

                    contentPadding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  ),
                  style: poppinsMediumStyle.copyWith(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Container(
                height: 47,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 255, 255, 0.9),
                  border: Border.all(color: borderColor, width: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: sentenceController,
                  decoration: InputDecoration(
                    hintText: 'Palindrome',
                    hintStyle: poppinsMediumStyle.copyWith(
                      fontSize: 16,
                      color: placeholderColor,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  ),
                  style: poppinsMediumStyle.copyWith(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 45),

              ElevatedButton(
                onPressed: () {
                  final sentence = sentenceController.text;
                  if (sentence.isNotEmpty) {
                    palindromeProvider.checkPalindrome(sentence);
                    _showPalindromeDialog(palindromeProvider.isPalindrome);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Enter a sentence to check!'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'CHECK',
                  style: poppinsMediumStyle.copyWith(
                    fontSize: 16,
                    color: Colors.white,
                    height: 21 / 14,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () {
                  Provider.of<AppStateProvider>(
                    context,
                    listen: false,
                  ).setUserName(nameController.text);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SecondScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'NEXT',
                  style: poppinsMediumStyle.copyWith(
                    fontSize: 16,
                    color: Colors.white,
                    height: 21 / 14,
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
