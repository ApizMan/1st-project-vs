import 'dart:async';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:project/component/generate_qr.dart';
import 'package:project/constant.dart';
import 'package:project/form_bloc/form_bloc.dart';
import 'package:project/models/models.dart';
import 'package:project/theme.dart';
import 'package:project/widget/primary_button.dart';

class ReloadPaymentScreen extends StatefulWidget {
  const ReloadPaymentScreen({super.key});

  @override
  State<ReloadPaymentScreen> createState() => _ReloadPaymentScreenState();
}

class _ReloadPaymentScreenState extends State<ReloadPaymentScreen> {
  String _currentDate = ''; // Initialize variable for date
  // ignore: unused_field
  String? _qrCodeUrl;
  String? shortcutLink;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => updateDateTime());
  }

  void updateDateTime() {
    setState(() {
      _currentDate =
          DateTime.now().toString().split(' ')[0]; // Get current date
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    Map<String, dynamic> details =
        arguments['locationDetail'] as Map<String, dynamic>;
    UserModel? userModel = arguments['userModel'] as UserModel?;
    ReloadFormBloc? formBloc = arguments['formBloc'] as ReloadFormBloc;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        toolbarHeight: 100,
        foregroundColor: details['color'] == 4294961979 ? kBlack : kWhite,
        backgroundColor: Color(details['color']),
        centerTitle: true,
        title: Text(
          'Payment',
          style: textStyleNormal(
            fontSize: 26,
            color: details['color'] == 4294961979 ? kBlack : kWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: PrimaryButton(
        borderRadius: 10.0,
        buttonWidth: 0.8,
        onPressed: () {
          formBloc.submit();
        },
        label: Text(
          'PAY',
          style: GoogleFonts.nunitoSans(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Name',
                    style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    child: Text(
                      '${userModel!.firstName} ${userModel.secondName}',
                      style: GoogleFonts.firaCode(),
                      textAlign: TextAlign.right, // Align text to the right
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Date',
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
                    'Email',
                    style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    child: Text(
                      userModel.email!,
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
                      'Token',
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
                      'RM ${double.parse(formBloc.amount.value).toStringAsFixed(2)}',
                      style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
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
              const SizedBox(height: 15),
              const Divider(
                color: Colors.black,
                thickness: 1.0,
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 150,
                child: RadioButtonGroupFieldBlocBuilder<String>(
                  padding: EdgeInsets.zero,
                  canTapItemTile: true,
                  groupStyle: const FlexGroupStyle(
                    direction: Axis.horizontal,
                  ),
                  selectFieldBloc: formBloc.paymentMethod,
                  decoration: InputDecoration(
                    labelText: 'Payment Method',
                    labelStyle: textStyleNormal(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  itemBuilder: (context, item) => FieldItem(
                    child: item == 'QR'
                        ? Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/duitnow.png'),
                                  fit: BoxFit.contain),
                            ),
                          )
                        : Container(
                            width: 120,
                            height: 80,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/fpx.png'),
                                  fit: BoxFit.contain),
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline, // Icon yang ingin Anda gunakan
                      color: Colors.red, // Warna ikon
                    ),
                    const SizedBox(height: 50),
                    const SizedBox(width: 5), // Jarak antara ikon dan teks
                    Flexible(
                      child: Text(
                        'You will be bring to 3rd Party website for Reload Token. Please ensure the detail above is accurate.',
                        style: GoogleFonts.firaCode(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}