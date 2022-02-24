import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:pinterest_app/pages/chat_page.dart';
import 'package:pinterest_app/pages/home_page.dart';
import 'package:pinterest_app/pages/profile_page.dart';
import 'package:pinterest_app/pages/search_page.dart';
import '../services/log_service.dart';

class ControlPage extends StatefulWidget {

  const ControlPage({Key? key}) : super(key: key);
  static const String id = "control_page";

  @override
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  bool isOffline = false;
  int selectedPage = 0;
  PageController pageController = PageController();
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  // / Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      Log.e(
        'Couldn\'t check connectivity status',
      );
      return;
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
    if(_connectionStatus == ConnectivityResult.none){
      setState(() {
        isOffline = true;
      });
    }

    else {
      setState(() {
        isOffline = false;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
    _connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        body: (isOffline) ? Center(
          child: Lottie.asset('assets/anims/no_internet.json',
            width: 180,),
        ) : PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            HomePage(key: PageStorageKey("home"),),
            SearchPage(key: PageStorageKey("search"),),
            ChatPage(key: PageStorageKey('chat'),),
            ProfilePage(key: PageStorageKey("profile"),)
          ],
        ),
        floatingActionButton:(isOffline) ? null: bottomNavigation(),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterFloat,
      ),
    );
  }

  /// Bottom Navigation Bar
  Widget bottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            color: Colors.grey.shade300,
          ),
        ],
          borderRadius: BorderRadius.circular(30),
          color: Theme.of(context).scaffoldBackgroundColor),
      margin: EdgeInsets.only(left: 50, right: 50),
      child: BottomNavigationBar(
        currentIndex: selectedPage,
        onTap: (index) {
          setState(() {
            selectedPage = index;
            pageController.jumpToPage(index);
          });
        },
        items: <BottomNavigationBarItem>[
           BottomNavigationBarItem(
            icon: Image(
              color : (selectedPage ==0) ? Theme.of(context).primaryColor : null,
                width: 25,
                height: 25,
                image: AssetImage('assets/icons/ic_home.png')),
            label: "",
          ),
           BottomNavigationBarItem(
            icon: Image(
                color : (selectedPage ==1) ? Theme.of(context).primaryColor : null,

                width: 25,
                height: 25,
                image: AssetImage('assets/icons/ic_search.png')),
            label: "",
          ),
           BottomNavigationBarItem(
            icon: Image(
                color : (selectedPage ==2) ? Theme.of(context).primaryColor : null,

                width: 25,
                height: 25,
                image: AssetImage('assets/icons/ic_exclude.png')),
            label: "",
          ),

          /// Profile image
          /// Local image added because of not connected to /user api
          BottomNavigationBarItem(
            icon: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedNetworkImage(
                imageUrl: "",
                errorWidget: (context, url,dy) => Image(
                  width: 30,
                  height: 30,
                  image: AssetImage("assets/images/im_profile.jpeg"),
                ),
              ),
            ),
            label: "",
          ),
        ],
      ),
    );
  }
}
