import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:druvtech/screens/user_info_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../res/custom_colors.dart';
import '../res/variables.dart';
import '../utils/apis/config.dart';
import '../widgets/app_bar_title.dart';
import 'abha/create_abha_screen.dart';
import 'abha_health_id_screen.dart';
import 'documents/documents_screen.dart';
import 'healthDataScreen.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late int currentPage;
  late TabController tabController;

  late String _healthId = "";
  void checkIfHealthIdCreated() async {
    final prefs = await SharedPreferences.getInstance();
    final String? healthId = prefs.getString('healthId');
    // const isFormFilled = false;
    setState(() => {
          if (healthId != null) {_healthId = healthId}
        });
  }

  @override
  void initState() {
    currentPage = 0;
    tabController = TabController(length: 4, vsync: this);
    tabController.animation?.addListener(
      () {
        final value = tabController.animation!.value.round();
        if (value != currentPage && mounted) {
          changePage(value);
        }
      },
    );
    super.initState();
    checkIfHealthIdCreated();
  }

  void changePage(int newPage) {
    setState(() {
      currentPage = newPage;
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      backgroundColor: Colors.blue[300],
      foregroundColor: Colors.white,
      overlayOpacity: 0.4,
      overlayColor: Colors.black,
      elevation: 8.0,
      shape: const CircleBorder(),
      children: [
        SpeedDialChild(
          child: Icon(Icons.water),
          label: 'Add Glucose',
          onTap: addGlucose,
        ),
        SpeedDialChild(
          child: Icon(Icons.favorite),
          label: 'Add Heart Rate',
          onTap: addHeartRate,
        ),
        SpeedDialChild(
          child: Icon(Icons.trending_up),
          label: 'Add Blood Pressure',
          onTap: addBloodPressure,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColors.firebaseNavy,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: CustomColors.firebaseNavy,
          title: const AppBarTitle(),
        ),
        body: BottomBar(
          clip: Clip.none,
          fit: StackFit.expand,
          icon: (width, height) => Center(
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: null,
              icon: Icon(
                Icons.arrow_upward_rounded,
                color: Colors.blue,
                size: width,
              ),
            ),
          ),
          borderRadius: BorderRadius.circular(500),
          duration: const Duration(milliseconds: 500),
          curve: Curves.decelerate,
          showIcon: true,
          width: MediaQuery.of(context).size.width * 0.8,
          barColor: Colors.white,
          start: 2,
          end: 0,
          bottom: 10,
          alignment: Alignment.bottomCenter,
          iconHeight: 30,
          iconWidth: 30,
          reverse: false,
          hideOnScroll: true,
          scrollOpposite: false,
          onBottomBarHidden: () {},
          onBottomBarShown: () {},
          body: (context, controller) => TabBarView(
            controller: tabController,
            dragStartBehavior: DragStartBehavior.down,
            physics: const BouncingScrollPhysics(),
            children: [
              const HealthDataScreen(),
              const DocumentScreen(),
              _healthId == ""
                  ? const CreateABHA()
                  : ABHAHealthIDScreen(
                      healthID: _healthId,
                    ),
              const UserInfoScreen(),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              TabBar(
                indicatorPadding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                controller: tabController,
                indicator: const UnderlineTabIndicator(
                    borderSide: BorderSide(
                      color: Colors.lightBlueAccent,
                      width: 4,
                    ),
                    insets: EdgeInsets.fromLTRB(16, 0, 16, 8)),
                tabs: const [
                  SizedBox(
                    height: 55,
                    width: 40,
                    child: Center(
                      child: Icon(
                        Icons.home,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 55,
                    width: 40,
                    child: Center(
                      child: Icon(
                        Icons.assignment,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 55,
                    width: 40,
                    child: Center(
                      child: Icon(
                        Icons.medical_services_outlined,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 55,
                    width: 40,
                    child: Center(
                      child: Icon(
                        Icons.account_circle_sharp,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                  ),
                ],
              ),
              // Positioned(
              //   top: -25,
              //   child: FloatingActionButton(
              //     onPressed: () {},
              //     backgroundColor: Colors.blue[300],
              //     child: const Icon(Icons.add),
              //   ),
              // ),
              Positioned(
                top: -25,
                child: buildSpeedDial(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addGlucose() {
    double glucoseLevel = 0.0;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Glucose'),
        content: TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Glucose Level',
          ),
          onChanged: (value) {
            glucoseLevel = double.parse(value);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              saveGlucoseLevel(glucoseLevel);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> saveGlucoseLevel(double glucoseLevel) async {
    final url = "http://${Config.apiURL}${Config.postGlucose}";
    ;

    final body = jsonEncode({
      'glucoseValue': glucoseLevel,
    });

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );
    String message = "";
    if (response.statusCode == 200) {
      message = 'Glucose level saved successfully';
      print("success");
      setState(() {});
    } else {
      message = 'Failed to save glucose level';
      print("failed");
    }
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void addBloodPressure() {
    int systolicPressure = 0;
    int diastolicPressure = 0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Blood Pressure'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Systolic Pressure',
              ),
              onChanged: (value) {
                systolicPressure = int.parse(value);
              },
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Diastolic Pressure',
              ),
              onChanged: (value) {
                diastolicPressure = int.parse(value);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              saveBloodPressure(systolicPressure, diastolicPressure);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> saveBloodPressure(
      int systolicPressure, int diastolicPressure) async {
    final url = "http://${Config.apiURL}${Config.postBloodPressure}";

    final body = jsonEncode({
      'systolic': systolicPressure,
      'diastolic': diastolicPressure,
    });

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );
    String message = "";
    if (response.statusCode == 200) {
      message = 'Blood pressure saved successfully';
      setState(() {});
      print('Success');
    } else {
      message = 'Failed to save blood pressure';
      print('Failed');
    }
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void addHeartRate() {
    int heartRate = 0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Heart Rate'),
        content: TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Heart Rate',
          ),
          onChanged: (value) {
            heartRate = int.parse(value);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              saveHeartRate(heartRate);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> saveHeartRate(int heartRate) async {
    final url = "http://${Config.apiURL}${Config.postHeartRate}";

    final body = jsonEncode({
      'heartRate': heartRate,
    });

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );
    String message = "";
    if (response.statusCode == 200) {
      message = 'Heart rate saved successfully';
      setState(() {});
      print('Success');
    } else {
      message = 'Failed to save heart rate';
      print('Failed');
    }
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.black87,
    textColor: Colors.white,
  );
}
