import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import 'package:pinterest_app/services/log_service.dart';
import 'package:pinterest_app/utils/bottom_sheet_widget.dart';
import '../models/pinterest_model.dart';
import '../services/http_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String id = "home_page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime? currentBackPressTime;
  bool isLoading = true;
  int selectedCategory = 0;
  int selectedPost = 0;
  String searchedCategory = 'All';
  bool isLoadMore = false;
  bool showDraggableSheet = false;
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
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          appBar: (showDraggableSheet) ? null : categoriesWidget(),
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

                    /// DraggableScrollSheet
                    (showDraggableSheet)
                        ? draggableScrollableSheet(pinterests[selectedPost])
                        : SizedBox.shrink(),

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
      ),
    );
  }

  /// BottomSheet
  Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return BottomSheetWidget();
        });
  }

  /// DraggableSheet
  DraggableScrollableSheet draggableScrollableSheet(Pinterest post) {
    return DraggableScrollableSheet(
        initialChildSize: 1,
        maxChildSize: 1,
        minChildSize: 1,
        builder: (context, scrollController) {
          return Container(
            color: Colors.black,
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                /// Full view
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        /// ClipRect (Image,user info)
                        Container(
                          padding: EdgeInsets.only(bottom: 5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: Column(
                                children: [
                                  /// Image full
                                  Stack(
                                    children: [
                                      /// Image Full
                                      CachedNetworkImage(
                                        imageUrl: post.urls!.full!,
                                        placeholder: (context, url) => AspectRatio(
                                            aspectRatio: post.width! / post.height!,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey.shade300,
                                                  image: const DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/img.png'))),
                                            )),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                      /// Button more horiz
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                              onPressed: () {},
                                              iconSize: 30,
                                              color: Colors.white,
                                              icon: Icon(CupertinoIcons.ellipsis)),
                                        ],
                                      ),
                                    ],
                                  ),

                                  /// ListTile => Name, followers count,
                                  Container(
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                    child: ListTile(
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: SizedBox(
                                          height: 50,
                                          width: 50,
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                post.user!.profileImage!.medium!,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        (post.user!.totalLikes != null)
                                            ? post.user!.name!
                                            : "",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: Text(
                                          "${(post.user!.totalLikes != null) ? post.user!.totalLikes! : 0} followers"),
                                      trailing: ClipRRect(
                                          borderRadius: BorderRadius.circular(30),
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 25, vertical: 15),
                                              color: Theme.of(context).primaryColor,
                                              child: Text(
                                                "Follow",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .scaffoldBackgroundColor),
                                              ))),
                                    ),
                                  ),

                                  /// Image Description
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 20),
                                    width: MediaQuery.of(context).size.width,
                                    alignment: AlignmentDirectional.center,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                    child: Text(
                                      (post.description != null)
                                          ? post.description!
                                          : "",
                                      style: TextStyle(fontSize: 18),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),

                                  /// Save and view button
                                  Container(
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        /// Message button
                                        IconButton(
                                            onPressed: () {},
                                            iconSize: 30,
                                            icon: Icon(
                                                CupertinoIcons.chat_bubble_fill)),

                                        /// View Button
                                        Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(30),
                                              color: Theme.of(context).primaryColor,
                                            ),
                                            margin: EdgeInsets.only(left: 40),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 25, vertical: 20),
                                            child: Text(
                                              "View",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .scaffoldBackgroundColor),
                                            )),

                                        /// Save Button
                                        Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(30),
                                              color: Colors.red.shade800,
                                            ),
                                            margin: EdgeInsets.only(right: 40),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 25, vertical: 20),
                                            child: Text(
                                              "Save",
                                              style: TextStyle(color: Colors.white),
                                            )),

                                        /// Share Button
                                        IconButton(
                                            onPressed: () {},
                                            iconSize: 30,
                                            icon: Icon(
                                              Icons.share,
                                            ))
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 20,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        /// Feedback
                        Container(
                          height: 200,
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Text(
                                "Share your feedback",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                               TextField(
                                style: TextStyle(
                                    color: Theme.of(context).textTheme.bodyText2!.color,
                                    decoration: TextDecoration.none),
                                cursorColor: Theme.of(context).textTheme.bodyText2!.color,
                                onSubmitted: (text) {
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                    hintText: "Add a comment",
                                    hintStyle: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        decoration: TextDecoration.none),
                                    prefixIcon: Container(
                                      height: 20,
                                      width: 20,
                                      padding: EdgeInsets.all(5),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: CachedNetworkImage(imageUrl: post.user!.profileImage!.medium!),
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.all(15),
                                    border: InputBorder.none),
                              ),

                            ],
                          ),
                        ),
                        /// More like this /// Posts
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: Column(
                                children: [
                                  Text("More like this",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),),
                                  MasonryGridView.count(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    itemCount: pinterests.length,
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    itemBuilder: (context, index) {
                                      return postItems(index);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        showDraggableSheet = false;
                      });
                    },
                    iconSize: 30,
                    color: Colors.white,
                    icon: Icon(CupertinoIcons.back)),

              ],
            ),
          );
        });
  }

  /// Picture Posts
  Widget postItems(int index) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),

          /// Image
          child: GestureDetector(
            onTap: () {
              setState(() {
                showDraggableSheet = true;
                selectedPost = index;
              });
            },
            child: CachedNetworkImage(
              imageUrl: pinterests[index].urls!.regular!,
              placeholder: (context, url) => AspectRatio(
                  aspectRatio:
                      pinterests[index].width! / pinterests[index].height!,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        image: const DecorationImage(
                            image: AssetImage('assets/images/img.png'))),
                  )),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
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
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                    fontSize: 16,
                    color: (selectedCategory == index)
                        ? Theme.of(context).scaffoldBackgroundColor
                        : Theme.of(context).primaryColor,
                  ),
                ),
              );
            }),
        preferredSize: Size(double.infinity, 60));
  }


  /// Will pop
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      setState(() {
        currentBackPressTime = now;
        showDraggableSheet = false;
      });

      return Future.value(false);
    }
    return Future.value(true);
  }
}
