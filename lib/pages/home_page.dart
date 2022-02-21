import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import 'package:pinterest_app/services/log_service.dart';
import '../models/pinterest_model.dart';
import '../services/http_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String id = "home_page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  int selectedCategory = 0;
  String searchedCategory = 'All';
  bool isLoadMore = false;
  List<Pinterest> pinterests = [];
  List<String> categories = [
    "All",
    "Football",
    "Education",
    "Nature",
    "Meals",
    "Technology",
    "Animals",
  ];

  /// Get Initial Data
  void getPhotos() {
    Network.GET(Network.API_LIST, Network.paramsEmpty()).then((value) => {
          pinterests = List.from(Network.parseUnSplashList(value!)),

          /// Switch off Loading lottie after Get data from Server
          isLoading = false,
          setState(() {}),
        });
  }

  /// Get Category Data
  void searchCategory(String category) {
    setState(() {
      isLoadMore = true;
    });
    Network.GET(Network.API_SEARCH_PHOTOS,
            Network.paramsSearch((pinterests.length ~/ 10) + 1, category))
        .then((value) => {
              pinterests
                  .addAll(List.from(Network.parseUnSplashSearchList(value!))),
              Log.w(pinterests.length.toString()),
              setState(() {
                isLoadMore = false;
              }),
            });
  }

  @override
  void initState() {
    super.initState();
    getPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: categoriesWidget(),
        body: (isLoading)
            ? Center(
                child: Lottie.asset('assets/anims/loading.json', width: 100))
            : Stack(
                children: [
                  /// NotificationListener work when User reach last post
                  NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (!isLoadMore &&
                          scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent) {
                        searchCategory(searchedCategory);
                        // start loading data
                        setState(() {});
                      }
                      return true;
                    },
                    child: MasonryGridView.count(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      itemCount: pinterests.length,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      itemBuilder: (context, index) {
                        return postItems(index);
                      },
                    ),
                  ),

                  /// Lottie_Loading appear when User reach last post and start Load More
                  isLoadMore
                      ? AnimatedContainer(
                          curve: Curves.easeIn,
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(color: Colors.white54),
                          duration: const Duration(milliseconds: 4),

                          /// Lottie_Loading appear when User reach last post and start Load More
                          child: Center(
                              child: Lottie.asset('assets/anims/loading.json',
                                  width: 100)),
                        )
                      : SizedBox.shrink(),
                ],
              ),
      ),
    );
  }

  /// BottomSheet
  Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    /// Cancel button
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            CupertinoIcons.clear,
                            size: 25,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          style: TextButton.styleFrom(),
                          onPressed: () {},
                          child: Text(
                            "Share to",
                            style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ],
                    ),

                    /// Send Via Social Networks and othes
                    SizedBox(
                      height: 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Column(
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  iconSize: 60,
                                  icon: Image(
                                    fit: BoxFit.cover,
                                    image: AssetImage('assets/icons/send.png'),
                                  )),
                              Text("Send",style: TextStyle(fontSize: 12),)
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  iconSize: 60,
                                  icon: Image(
                                    fit: BoxFit.cover,
                                    image: AssetImage('assets/icons/message.png'),
                                  )),
                              Text("Message",style: TextStyle(fontSize: 12),)

                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  iconSize: 60,
                                  icon: Image(
                                    fit: BoxFit.cover,
                                    image: AssetImage('assets/icons/gmail.png'),
                                  )),
                              Text("Gmail",style: TextStyle(fontSize: 12),)

                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  iconSize: 60,
                                  icon: Image(
                                    fit: BoxFit.cover,
                                    image: AssetImage('assets/icons/facebook.png'),
                                  )),
                              Text("Facebook",style: TextStyle(fontSize: 12),)

                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  iconSize: 60,
                                  icon: Image(
                                    fit: BoxFit.cover,
                                    image: AssetImage('assets/icons/whatsapp.png'),
                                  )),
                              Text("Twitter",style: TextStyle(fontSize: 12),)

                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  iconSize: 60,
                                  icon: Image(
                                    fit: BoxFit.cover,
                                    image: AssetImage('assets/icons/copy_link.png'),
                                  )),
                              Text("Links",style: TextStyle(fontSize: 12),)

                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  iconSize: 60,
                                  icon: Image(
                                    fit: BoxFit.cover,
                                    image: AssetImage('assets/icons/more.png'),
                                  )),
                              Text("More",style: TextStyle(fontSize: 12),)

                            ],
                          ),
                        ],
                      ),
                    ),
                    /// Buttons
                    TextButton(
                        onPressed: () {},
                        child: Text("Download image",
                            style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).primaryColor))),
                    TextButton(
                        onPressed: () {},
                        child: Text("Hide Pin",
                            style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).primaryColor))),
                    TextButton(
                        onPressed: () {},
                        child: Text("Report Pin",
                            style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).primaryColor))),

                  ]),
            ),
          );
        });
  }

  // Future<dynamic> buildShowModalBottomSheet(BuildContext context,int index) {
  //   return showModalBottomSheet<void>(
  //     context: context,
  //     backgroundColor: Colors.transparent,
  //     barrierColor: Colors.transparent,
  //     builder: (context) {
  //       return ClipRRect(
  //         borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
  //         child: BackdropFilter(
  //           filter: ImageFilter.blur(
  //             sigmaX: 20.0,
  //             sigmaY: 20.0,
  //           ),
  //           child: Container(
  //             decoration: BoxDecoration(
  //               color: Colors.white12,
  //               borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
  //               border: Border.all(
  //                 color: Colors.black26,
  //                 width: 0.5,
  //               ),
  //             ),
  //             child: Column(
  //               children: [
  //                 FractionallySizedBox(
  //                   widthFactor: 0.25,
  //                   child: Container(
  //                     margin: const EdgeInsets.symmetric(
  //                       vertical: 8,
  //                     ),
  //                     height: 4,
  //                     decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       borderRadius: BorderRadius.circular(2),
  //                       border: Border.all(
  //                         color: Colors.black12,
  //                         width: 0.5,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 Expanded(
  //                   child: ClipRRect(
  //                     borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
  //
  //                     child: CachedNetworkImage(
  //                       imageUrl: pinterests[index].urls!.full!,
  //                       placeholder: (context, url) => Container(
  //                           child: Image(
  //                             image: AssetImage("assets/images/img.png"),
  //                           )),
  //                       errorWidget: (context, url, error) => Icon(Icons.error),
  //                     ),
  //                   ),
  //                 ),
  //                 // (pinterests[index].altDescription != null)
  //                 //     ? Expanded(
  //                 //       child: Flexible(
  //                 //   child: Text(
  //                 //       pinterests[index].altDescription!,
  //                 //       overflow: TextOverflow.ellipsis,
  //                 //   ),
  //                 // ),
  //                 //     ):SizedBox.shrink(),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },);
  // }

  /// Picture Posts
  Widget postItems(int index) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),

          /// Image
          child: CachedNetworkImage(
            imageUrl: pinterests[index].urls!.regular!,
            placeholder: (context, url) => AspectRatio(
                aspectRatio:
                    pinterests[index].width! / pinterests[index].height!,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      image: DecorationImage(
                          image: AssetImage('assets/images/img.png'))),
                )),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),

        /// Description or Profile Image
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (pinterests[index].altDescription != null)
                  ? Flexible(
                      child: Text(
                        pinterests[index].altDescription!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        imageUrl: pinterests[index].user!.profileImage!.small!,
                      ),
                    ),
              IconButton(
                  onPressed: () {
                    buildShowModalBottomSheet(context);
                  },
                  icon: Icon(Icons.more_horiz))
            ],
          ),
        )
      ],
    );
  }

  /// App Bar Categories
  PreferredSize categoriesWidget() {
    return PreferredSize(
        child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              /// TextBUtton
              return TextButton(
                onPressed: () {
                  setState(() {
                    pinterests.clear();
                    searchedCategory = categories[index];
                    searchCategory(categories[index]);
                    selectedCategory = index;
                  });
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(15),
                  shape: StadiumBorder(),
                  backgroundColor: (selectedCategory == index)
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Text(
                  categories[index],
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: (selectedCategory == index)
                        ? Theme.of(context).scaffoldBackgroundColor
                        : Theme.of(context).primaryColor,
                  ),
                ),
              );
            }),
        preferredSize: Size(double.infinity, 70));
  }
}
