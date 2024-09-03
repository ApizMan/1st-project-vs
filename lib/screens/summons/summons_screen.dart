import 'package:flutter/material.dart';
import 'package:project/constant.dart';
import 'package:project/theme.dart';

class SummonsScreen extends StatefulWidget {
  const SummonsScreen({super.key});

  @override
  State<SummonsScreen> createState() => _SummonsScreenState();
}

class _SummonsScreenState extends State<SummonsScreen> {
  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    Map<String, dynamic> details =
        arguments['locationDetail'] as Map<String, dynamic>;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        toolbarHeight: 100,
        foregroundColor: details['color'] == 4294961979 ? kBlack : kWhite,
        backgroundColor: Color(details['color']),
        centerTitle: true,
        title: Text(
          'Summons',
          style: textStyleNormal(
            fontSize: 26,
            color: details['color'] == 4294961979 ? kBlack : kWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [],
      ),
    );
  }
}