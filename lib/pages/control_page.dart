import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinterest_app/models/pinterest_model.dart';
import 'package:pinterest_app/pages/chat_page.dart';
import 'package:pinterest_app/pages/home_page.dart';
import 'package:pinterest_app/pages/profile_page.dart';
import 'package:pinterest_app/pages/search_page.dart';

class ControlPage extends StatefulWidget {

  const ControlPage({Key? key}) : super(key: key);
  static const String id = "control_page";

  @override
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  int selectedPage = 0;
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        body: PageView(
          controller: pageController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            HomePage(),
            SearchPage(),
            ChatPage(),
            ProfilePage()
          ],
        ),
        floatingActionButton: bottomNavigation(),
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
