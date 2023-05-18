import 'package:druvtech/screens/user_info_screen.dart';
import 'package:druvtech/providers/firebase_auth_methods.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import '../res/custom_colors.dart';
import '../widgets/app_bar_title.dart';
import 'abha/create_abha_screen.dart';
import 'package:provider/provider.dart';
import 'documents/documents_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late int currentPage;
  late TabController tabController;

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

  @override
  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthMethods>().user;

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
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  height: MediaQuery.of(context).size.height / 2,
                  //   width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Hey,${user.displayName!}",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Comfortaa",
                          fontSize: 26,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Handle the onTap event for the first SizedBox
                              print('First SizedBox tapped');
                            },
                            child: Container(
                              height: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: Colors.green,
                              ),
                              child: SizedBox(
                                width: 170.0,
                                height: 130.0,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Blood Glucose',
                                      style: TextStyle(
                                        fontFamily: 'Comfortaa',
                                        color: Colors.black,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '120',
                                          style: TextStyle(
                                            fontSize: 30.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                            width: 4.0), //adding space
                                        Text(
                                          'mg/dl',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Handle the onTap event for the second SizedBox
                              print('Second SizedBox tapped');
                            },
                            child: Container(
                              height: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: Colors.blue,
                              ),
                              child: SizedBox(
                                width: 170.0,
                                height: 130.0,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Hba1c',
                                      style: TextStyle(
                                        fontFamily: 'Comfortaa',
                                        color: Colors.black,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '120',
                                          style: TextStyle(
                                            fontSize: 30.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                            width: 4.0), //adding space
                                        Text(
                                          'mg/dl',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Handle the onTap event for the third SizedBox
                              print('Third SizedBox tapped');
                            },
                            child: Container(
                              height: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: Colors.yellow,
                              ),
                              child: SizedBox(
                                width: 170.0,
                                height: 130.0,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Blood Pressure',
                                      style: TextStyle(
                                        fontFamily: 'Comfortaa',
                                        color: Colors.black,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '120',
                                          style: TextStyle(
                                            fontSize: 30.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                            width: 4.0), //adding space
                                        Text(
                                          'mg/dl',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Handle the onTap event for the fourth SizedBox
                              print('Fourth SizedBox tapped');
                            },
                            child: Container(
                              height: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: Colors.orange,
                              ),
                              child: SizedBox(
                                width: 170.0,
                                height: 130.0,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Heart Rate',
                                      style: TextStyle(
                                        fontFamily: 'Comfortaa',
                                        color: Colors.black,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '120',
                                          style: TextStyle(
                                            fontSize: 30.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                            width: 4.0), //adding space
                                        Text(
                                          'mg/dl',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const DocumentScreen(),
              const CreateABHA(),
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
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: -25,
                child: FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: Colors.blue[300],
                  child: const Icon(Icons.add),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
