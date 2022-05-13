import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  static const String id = "profile_page";

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin{
  ScrollController scrollController = ScrollController();

  bool showNameInAppBar = false;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    appBarInfo();
    // scrollController.addListener(() {
    //   if (scrollController.offset == 0.0) {
    //     setState(() {
    //     });
    //   } else {
    //     setState(() {
    //     });
    //   }
    // });
  }

  void appBarInfo() {
    return WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.addListener(() {
        setState(() {
          showNameInAppBar = true;
        });
        print('scrolling');
      });
      scrollController.position.isScrollingNotifier.addListener(() {
        if (!scrollController.position.isScrollingNotifier.value) {
          setState(() {
            showNameInAppBar = false;
          });
          print('scroll is stopped');
        } else {
          print('scroll is started');
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: (showNameInAppBar)
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.grey.shade300,
                  child: Text(
                    "F",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            : null,
        centerTitle: true,
        title: (showNameInAppBar)
            ? Text(
                "Fayozbek Jumabekov",
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600),
              )
            : null,
        elevation: (showNameInAppBar) ? 4 : 0,
        shadowColor: Colors.grey.shade300,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          (showNameInAppBar)
              ? SizedBox.shrink()
              : IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.share),
                  color: Theme.of(context).primaryColor,
                ),
          (showNameInAppBar)
              ? SizedBox.shrink()
              : IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.more_horiz),
                  color: Theme.of(context).primaryColor),
        ],
      ),
      body: NestedScrollView(
          controller: scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverList(
                  delegate: SliverChildListDelegate([profileDetails(context)]))
            ];
          },
          body: SingleChildScrollView(
            child: Column(
              children: [
                textFieldWidget(context),
              ],
            ),
          )),
    );
  }

  Widget textFieldWidget(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Container(
            margin: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
                color: Theme.of(context).bottomAppBarColor,
                borderRadius: BorderRadius.circular(20)),

            /// TextField Search
            child: TextField(
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText2!.color,
                  decoration: TextDecoration.none),
              cursorColor: Theme.of(context).textTheme.bodyText2!.color,
              controller: textEditingController,
              onSubmitted: (text) {
                setState(() {});
              },
              decoration: InputDecoration(
                  hintText: "Search your Pins",
                  hintStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                      decoration: TextDecoration.none),
                  prefixIcon: Icon(
                    CupertinoIcons.search,
                    size: 25,
                    color: Theme.of(context).primaryColor,
                  ),
                  contentPadding: EdgeInsets.all(15),
                  border: InputBorder.none),
            ),
          ),
        ),
        Expanded(
            child: IconButton(
                iconSize: 30,
                onPressed: () {},
                icon: Icon(CupertinoIcons.add))),
      ],
    );
  }

  Widget profileDetails(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: MediaQuery.of(context).size.width / 7,
          backgroundColor: Colors.grey.shade300,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image(
                image: AssetImage('assets/images/im_profile.jpeg')),
          ),
          foregroundColor: Theme.of(context).primaryColor,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Christopher Robin",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Text(
          "@christoph123",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '0 followers ',
              style: TextStyle(
                  fontSize: 14, color: Theme.of(context).primaryColor),
            ),
            Text(
              "• 0 following",
              style: TextStyle(
                  fontSize: 14, color: Theme.of(context).primaryColor),
            )
          ],
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
