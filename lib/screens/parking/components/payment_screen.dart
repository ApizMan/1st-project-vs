import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/component/receipt_screen.dart';
import 'package:project/constant.dart';
import 'package:project/models/models.dart';
import 'package:project/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    super.key,
  });

  @override
  State<PaymentScreen> createState() => _PaymentsppkScreenState();
}

class _PaymentsppkScreenState extends State<PaymentScreen> {
  //final double _value = 40.0;
  String _currentDate = '';
  String _currentTime = '';

  Future<void> paymentParking() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    var url = Uri.parse("http://192.168.0.119:3000/payment/parking");

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "amount": GlobalDeclaration.globalAmount.toString(),
      }),
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Payment Parking Succesful!');
      }
    } else {
      if (kDebugMode) {
        print('Payment Parking failed: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('Response: ${response.body}');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => updateDateTime());
  }

  void updateDateTime() {
    setState(() {
      _currentDate =
          DateTime.now().toString().split(' ')[0]; // Get current date
      _currentTime = DateFormat('h:mm:ss a').format(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    UserModel? userModel = arguments['userModel'] as UserModel?;
    List<PlateNumberModel>? plateNumbers =
        arguments['plateNumbers'] as List<PlateNumberModel>?;
    String? parkingCar = arguments['selectedCarPlate'] as String?;
    double amount = arguments['amount'] as double;

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          foregroundColor: kWhite,
          backgroundColor: kPrimaryColor,
          centerTitle: true,
          title: Text(
            'Payment',
            style: textStyleNormal(
              fontSize: 26,
              color: kWhite,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "Date",
                      style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 50),
                    Expanded(
                      child: Text(
                        _currentDate,
                        style: GoogleFonts.firaCode(),
                        textAlign: TextAlign.right, // Align text to the right
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Time',
                      style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 50),
                    Expanded(
                      child: Text(
                        _currentTime,
                        style: GoogleFonts.firaCode(),
                        textAlign: TextAlign.right, // Align text to the right
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Location',
                      style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 50),
                    Expanded(
                      child: Text(
                        'Majlis Bandaraya Kuantan',
                        style: GoogleFonts.firaCode(),
                        textAlign: TextAlign.right, // Align text to the right
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Number Plate',
                      style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 50),
                    Expanded(
                      child: Text(
                        parkingCar!.split('-')[0],
                        style: GoogleFonts.firaCode(),
                        textAlign: TextAlign.right, // Align text to the right
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Duration',
                      style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 50),
                    Expanded(
                      child: Text(
                        GlobalDeclaration.globalDuration,
                        style: GoogleFonts.firaCode(),
                        textAlign: TextAlign.right, // Align text to the right
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Description',
                      style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 50),
                    Expanded(
                      child: Text(
                        'Parking',
                        style: GoogleFonts.firaCode(),
                        textAlign: TextAlign.right, // Align text to the right
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Total',
                      style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 50),
                    Expanded(
                      child: Text(
                        'RM ${amount.toString()}',
                        style:
                            GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right, // Align text to the right
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Center(
                  child: Text(
                    'Please Pay and Park Responsibly',
                    style: GoogleFonts.firaCode(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 100),
                Center(
                  child: SizedBox(
                    width: 100,
                    height: 25,
                    child: ElevatedButton(
                      onPressed: () {
                        paymentParking();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                ReceiptScreen(userProfile: userModel),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 55, 26, 200),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(5)) // Background color
                          ),
                      child: Text(
                        'PAY',
                        style: GoogleFonts.nunitoSans(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
