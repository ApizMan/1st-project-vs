import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/constant.dart';
import 'package:project/form_bloc/form_bloc.dart';
import 'package:project/models/models.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/theme.dart';
import 'package:project/widget/loading_dialog.dart';
import 'package:project/widget/primary_button.dart';
import 'package:table_calendar/table_calendar.dart';

class ParkingBodyScreen extends StatefulWidget {
  final UserModel userModel;
  final List<PlateNumberModel> carPlates;
  final List<PBTModel> pbtModel;
  final Map<String, dynamic> details;

  const ParkingBodyScreen({
    super.key,
    required this.userModel,
    required this.carPlates,
    required this.pbtModel,
    required this.details,
  });

  @override
  State<ParkingBodyScreen> createState() => _ParkingBodyScreenState();
}

class GlobalState {
  static String plate = '';
  static double amount = 0.0;
}

class _ParkingBodyScreenState extends State<ParkingBodyScreen> {
  double _value = 0.65;
  int _remainingTime = 3600;
  late DateTime _focusedDay;
  List<PlateNumberModel> carPlates = [];
  String? selectedCarPlate;
  StoreParkingFormBloc? formBloc;

  final List<String> imgName = [
    'Majlis Bandaraya Kuantan',
    'Majlis Bandaraya Kuala Terengganu',
    'Majlis Daerah Machang',
  ];

  final List<String> imgState = [
    'Pahang',
    'Terengganu',
    'Kelantan',
  ];

  @override
  void initState() {
    super.initState();

    _focusedDay = DateTime.now();

    // Find the car plate where isMain is true and set it as selected
    if (widget.carPlates.isNotEmpty) {
      PlateNumberModel mainCarPlate = widget.carPlates.firstWhere(
        (plate) => plate.isMain == true,
        orElse: () => widget.carPlates.first,
      );
      // Set the selectedCarPlate with both plateNumber and id to match the Dropdown value
      selectedCarPlate = '${mainCarPlate.plateNumber}-${mainCarPlate.id}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocProvider(
        create: (context) => StoreParkingFormBloc(
          platModel: widget.carPlates,
          pbtModel: widget.pbtModel,
          details: widget.details,
        ),
        child: Builder(builder: (context) {
          formBloc = BlocProvider.of<StoreParkingFormBloc>(context);
          return FormBlocListener<StoreParkingFormBloc, String, String>(
            onSubmitting: (context, state) {
              LoadingDialog.show(context);
            },
            onSubmissionFailed: (context, state) => LoadingDialog.hide(context),
            onSuccess: (context, state) {
              LoadingDialog.hide(context);
              Navigator.popAndPushNamed(
                context,
                AppRoute.homeScreen,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.successResponse!),
                ),
              );
            },
            onFailure: (context, state) {
              LoadingDialog.hide(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.failureResponse!),
                ),
              );
            },
            child: Column(
              children: [
                const SizedBox(height: 15),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_left_sharp),
                      onPressed: () {
                        setState(() {
                          _focusedDay =
                              _focusedDay.subtract(const Duration(days: 7));
                        });
                      },
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TableCalendar(
                            firstDay: DateTime.utc(2010, 10, 16),
                            lastDay: DateTime.utc(2030, 3, 14),
                            focusedDay: _focusedDay,
                            calendarFormat: CalendarFormat.week,
                            onFormatChanged: (format) {
                              setState(() {
                                // Update the calendar format if needed
                              });
                            },
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _focusedDay = focusedDay;
                              });
                            },
                            headerStyle: const HeaderStyle(
                              formatButtonVisible: false,
                              titleTextStyle: TextStyle(fontSize: 0),
                            ),
                            headerVisible: false,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_right_sharp),
                      onPressed: () {
                        setState(() {
                          _focusedDay =
                              _focusedDay.add(const Duration(days: 7));
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                if (widget.carPlates.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: DropdownFieldBlocBuilder<String?>(
                      showEmptyItem: false,
                      selectFieldBloc: formBloc!.carPlateNumber,
                      decoration: InputDecoration(
                        label: const Text('Plate Number'),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black12,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black12,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                      ),
                      itemBuilder: (context, value) {
                        // Find the matching car plate from widget.carPlates
                        final carPlate = widget.carPlates.firstWhere(
                          (plate) => plate.plateNumber == value,
                        );

                        return FieldItem(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(value!), // Display the car plate number
                                if (carPlate.isMain == true)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    decoration: BoxDecoration(
                                      color: kGrey,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      'Default',
                                      style:
                                          textStyleNormal(), // Apply your desired style here
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                if (widget.pbtModel.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: DropdownFieldBlocBuilder<String?>(
                      showEmptyItem: false,
                      selectFieldBloc: formBloc!.pbt, // Bind to PBT field bloc
                      decoration: InputDecoration(
                        label: const Text('PBT'),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black12,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black12,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                      ),
                      itemBuilder: (context, value) {
                        return FieldItem(
                          onTap: () {
                            if (value == imgName[0]) {
                              formBloc!.location
                                  .updateInitialValue(imgState[0]);
                            } else if (value == imgName[1]) {
                              formBloc!.location
                                  .updateInitialValue(imgState[1]);
                            } else {
                              formBloc!.location
                                  .updateInitialValue(imgState[2]);
                            }
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(value!),
                          ),
                        );
                      },
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: DropdownFieldBlocBuilder<String?>(
                    showEmptyItem: false,
                    selectFieldBloc:
                        formBloc!.location, // Bind to PBT field bloc
                    decoration: InputDecoration(
                      label: const Text('Location'),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black12,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black12,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                    ),
                    itemBuilder: (context, value) {
                      return FieldItem(
                        onTap: () {
                          if (value == imgState[0]) {
                            formBloc!.pbt.updateInitialValue(imgName[0]);
                          } else if (value == imgState[1]) {
                            formBloc!.pbt.updateInitialValue(imgName[1]);
                          } else {
                            formBloc!.pbt.updateInitialValue(imgName[2]);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(value!),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              const SizedBox(height: 35),
                              Text(
                                'Duration',
                                style: GoogleFonts.secularOne(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                _formatDuration(_remainingTime),
                                style: GoogleFonts.secularOne(
                                  fontSize: 30,
                                  color: const Color.fromARGB(255, 12, 59, 97),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                'A M O U N T',
                                style: GoogleFonts.secularOne(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'RM ${_value.toStringAsFixed(2)}',
                                style: GoogleFonts.secularOne(
                                  fontSize: 30,
                                  color: const Color.fromARGB(255, 19, 3, 108),
                                ),
                              ),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor:
                                      const Color.fromRGBO(2, 50, 114, 1),
                                  inactiveTickMarkColor:
                                      const Color.fromRGBO(217, 217, 217, 1.0),
                                  trackShape:
                                      const RoundedRectSliderTrackShape(),
                                  trackHeight: 10.0,
                                  overlayColor:
                                      const Color.fromRGBO(2, 50, 114, 1),
                                  overlayShape: const RoundSliderOverlayShape(
                                      overlayRadius: 28),
                                  valueIndicatorShape:
                                      const PaddleSliderValueIndicatorShape(),
                                  valueIndicatorColor:
                                      const Color.fromRGBO(2, 50, 114, 1),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Slider(
                                        min: 0.65,
                                        max: 4.8,
                                        divisions: 6,
                                        label:
                                            '${(((_value - 0.65) / (4.80 - 0.65) * 5) + 1).round()} hour',
                                        value: _value,
                                        onChanged: (double value) {
                                          setState(() {
                                            _value =
                                                (value / 0.65).round() * 0.65;
                                            _remainingTime = ((_value - 0.65) /
                                                            (4.80 - 0.65) *
                                                            5 +
                                                        1)
                                                    .round() *
                                                3600;
                                          });
                                        }),
                                  ],
                                ),
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
                spaceVertical(height: 20.0),
                PrimaryButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoute.parkingPaymentScreen,
                      arguments: {
                        'userModel': widget.userModel,
                        'selectedCarPlate': selectedCarPlate!,
                        'amount': _value,
                      },
                    );
                    GlobalState.amount = _value;
                    calculateRemainingTime();
                  },
                  label: Text(
                    'Confirm',
                    style: textStyleNormal(
                      color: kWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  buttonWidth: 0.8,
                  borderRadius: 10.0,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  void _showTimeEndingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Peringatan",
              style: GoogleFonts.poppins(
                color: Colors.red[800],
              ),
            ),
          ),
          content: Center(
            child: Text(
              "Your Duration of Parking will be terminated in 10 minute",
              style: GoogleFonts.poppins(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void startCountdown() {
    const oneSecond = Duration(seconds: 1);

    Timer.periodic(oneSecond, (Timer timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
          if (_remainingTime == 600) {
            // Jika sisa waktu 10 menit
            _showTimeEndingDialog(); // Tampilkan dialog peringatan
          }
        } else {
          timer.cancel();
        }
      });
    });
  }

  String _formatDuration(int totalSeconds) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");

    int hours = totalSeconds ~/ 3600;
    int remainingMinutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    String formattedHours = twoDigits(hours);
    String formattedMinutes = twoDigits(remainingMinutes);
    String formattedSeconds = twoDigits(seconds);

    return "$formattedHours:$formattedMinutes:$formattedSeconds";
  }

  void calculateRemainingTime() {
    // Calculate the remaining time in seconds
    int _remainingTime =
        (((_value - 0.65) / (4.80 - 0.65) * 5 + 1).round() * 3600);

    // Convert seconds to hours
    int hours = (_remainingTime / 3600).round();

    // Determine the correct singular or plural form
    String hourLabel = hours == 1 ? "hour" : "hours";

    // Create the formatted string
    GlobalDeclaration.globalDuration = "$hours $hourLabel";
  }

  void calculateGlobalAmount() {
    GlobalDeclaration.globalAmount = _value;
  }
}