import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kisanseva/screens/onboard_screen.dart';


import '../provider/auth_provider.dart';  // Ensure this path is correct

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    bool _validPhoneNumber = false;
    var _phoneNumberController = TextEditingController();

    void showBottomSheet(BuildContext context) {
      showModalBottomSheet(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, StateSetter myState) {
            return Container(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "LOGIN",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Enter your phone number to proceed",
                      style: TextStyle(fontSize: 12, color: Colors.green),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _phoneNumberController,
                      decoration: InputDecoration(
                        prefixText: "+91",
                        labelText: "10 digit mobile number",
                      ),
                      autofocus: true,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      onChanged: (value) {
                        if (value.length == 10) {
                          myState(() {
                            _validPhoneNumber = true;
                          });
                        } else {
                          myState(() {
                            _validPhoneNumber = false;
                          });
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: AbsorbPointer(
                            absorbing: !_validPhoneNumber,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _validPhoneNumber
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey,
                              ),
                              onPressed: () {
                                if (_validPhoneNumber) {
                                  String number =
                                      "+91${_phoneNumberController.text}";
                                  auth.verifyPhone(context, number);
                                }
                              },
                              child: Text(
                                _validPhoneNumber
                                    ? "CONTINUE"
                                    : "ENTER PHONE NUMBER",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            Positioned(
              right: 0.0,
              top: 3.0,
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  "SKIP",
                  style: TextStyle(color: Colors.deepOrangeAccent),
                ),
              ),
            ),
            Column(
              children: [
                Expanded(child: OnboardScreen()),
                Text(
                  "Ready to order from your nearest farmer?",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent, // Background color
                  ),
                  onPressed: () {},
                  child: Text(
                    "Set Delivery Location",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    showBottomSheet(context);
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Already a customer?",
                      style: TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: ' Login',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orangeAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
