import 'package:druvtech/screens/user_info_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import '../screens/documents/documents_screen.dart';
import '../res/custom_colors.dart';
import '../widgets/app_bar_title.dart';

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
    tabController = TabController(length: 4, vsync: this, initialIndex: 1);
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
            children: const [
              Center(
                child: Text("It's cloudy here"),
              ),
              DocumentScreen(),
              Center(
                child: Text("It's sunny here"),
              ),
              // Center(
              //   child: Text("It's funny here"),
              // ),
              UserInfoScreen(),
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
