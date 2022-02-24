import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pinterest_app/services/log_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/pinterest_model.dart';
import '../services/http_service.dart';
import 'package:http/http.dart' as http;

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
  double downloadPercent = 0;
  bool showDownloadIndicator = false;
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

  /// Get Category Data
  void searchCategory(String category) {
    setState(() {
      isLoadMore = true;
    });
    Network.GET(Network.API_SEARCH_PHOTOS,
            Network.paramsSearch((pinterests.length ~/ 10) + 1, category))
        .then((value) => {
              pinterests.addAll(List.from(Network.parseUnSplashSearchList(value!))),
              Log.w(pinterests.length.toString()),
              setState(() {
                /// Switch off Loading lottie after Get data from Server
                isLoading = false;
                isLoadMore = false;
              }),
            });
  }


  void downloadFile(String url,String filename) async {
    var permission = await _getPermission(Permission.storage);
    try{
      if(permission != false){

        var httpClient = http.Client();
        var request = http.Request('GET', Uri.parse(url));
        var res = httpClient.send(request);
        final response = await get(Uri.parse(url));
        Directory generalDownloadDir = Directory('/storage/emulated/0/Download');
        List<List<int>> chunks = [];
        int downloaded = 0;

        res.asStream().listen((http.StreamedResponse r) {
          r.stream.listen((List<int> chunk) {
            // Display percentage of completion

            setState(() {
              chunks.add(chunk);
              downloaded += chunk.length;
              showDownloadIndicator = true;
              downloadPercent = downloaded / r.contentLength!;
              debugPrint(downloadPercent.toString());

            });
          }, onDone: () async {
            // Display percentage of completion
            debugPrint('downloadPercentage: ${downloaded / r.contentLength! * 100}');

            setState(() {
              downloadPercent = 0;
              showDownloadIndicator = false;
              showToast();
            });
            // Save the file
            File imageFile = File("${generalDownloadDir.path}/$filename.jpg");
            Log.w(generalDownloadDir.path);
            await imageFile.writeAsBytes(response.bodyBytes);
            return;
          });
        });
      }
      else {
        Log.i("Permission Denied");
      }
    }
    catch(e){
      Log.e(e.toString());
    }
  }


  Future<bool> _getPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();

      if (result == PermissionStatus.granted) {
        return true;
      } else {
        Log.w(result.toString());
        return false;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    searchCategory(searchedCategory);
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
  Future<dynamic> buildShowModalBottomSheet(BuildContext context,int index) {
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
                    const SizedBox(
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
                                  onPressed: () async{
                                    HapticFeedback.vibrate();
                                    await launch("sms:?body=${Uri.encodeComponent(pinterests[index].urls!.full!)}");
                                  },
                                  iconSize: 60,
                                  icon: const Image(
                                    fit: BoxFit.cover,
                                    image:
                                    AssetImage('assets/icons/message.png'),
                                  )),
                              const Text(
                                "Message",
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                  onPressed: () async{
                                    await launch("mailto:?subject=Flutter&body=${Uri.encodeComponent(pinterests[index].urls!.full!)}");
                                  },
                                  iconSize: 60,
                                  icon: const Image(
                                    fit: BoxFit.cover,
                                    image: AssetImage('assets/icons/gmail.png'),
                                  )),
                              const Text(
                                "Gmail",
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    launch('https://facebook.com');
                                  },
                                  iconSize: 60,
                                  icon: const Image(
                                    fit: BoxFit.cover,
                                    image:
                                    AssetImage('assets/icons/facebook.png'),
                                  )),
                              const Text(
                                "Facebook",
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                  onPressed: () async{
                                    await launch("https://telegram.me/share/url?url=${Uri.encodeComponent(pinterests[index].urls!.full!)}");
                                  },
                                  iconSize: 60,
                                  icon: const Image(
                                    fit: BoxFit.cover,
                                    image:
                                    AssetImage('assets/icons/telegram.png'),
                                  )),
                              const Text(
                                "Telegram",
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                  onPressed: () async{
                                    await launch("https://api.whatsapp.com/send?text=${Uri.encodeComponent(pinterests[index].urls!.full!)}");
                                  },
                                  iconSize: 60,
                                  icon: const Image(
                                    fit: BoxFit.cover,
                                    image:
                                    AssetImage('assets/icons/whatsapp.png'),
                                  )),
                              const Text(
                                "Whatsapp",
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                  onPressed: () async{
                                   await Clipboard.setData(ClipboardData(text: pinterests[index].urls!.full!));
                                   showToast(pinterests[index].urls!.full!);
                                  },
                                  iconSize: 60,
                                  icon: const Image(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        'assets/icons/copy_link.png'),
                                  )),
                              const Text(
                                "Links",
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  iconSize: 60,
                                  icon: const Image(
                                    fit: BoxFit.cover,
                                    image: AssetImage('assets/icons/more.png'),
                                  )),
                              const Text(
                                "More",
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),

                    /// Buttons
                    TextButton(
                        onPressed: () {
                          downloadFile(pinterests[index].links!.download!,"${pinterests[index].user!.name}${Random().nextInt(10)}");
                          Navigator.pop(context);
                          },
                        child: Text("Download image",
                            style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).primaryColor))),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            pinterests.removeAt(index);
                            Navigator.pop(context);
                          });
                        },
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
                  /// full image
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
                                                      fit: BoxFit.cover,
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
                                            onPressed: () {
                                            },
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
                                        GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              downloadFile(post.links!.download!,"${post.user!.name}${Random().nextInt(10)}");
                                            });
                                          },
                                          child: Container(
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
                                        ),

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
                (showDownloadIndicator) ? Align(
                  alignment: Alignment.topCenter,
                  child: CircularPercentIndicator(
                    animateFromLastPercent: true,
                    progressColor: Colors.green,
                    backgroundColor: Colors.grey.shade200,
                    percent: downloadPercent,
                    radius: 30.0,
                    lineWidth: 8.0,
                    circularStrokeCap: CircularStrokeCap.round,
                    center: Text(
                      "${(downloadPercent * 100).toInt()} %",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0,color: Colors.white),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ) : const SizedBox.shrink(),



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
                  child: ColoredBox(color: Color(int.parse(pinterests[index].color!.replaceFirst("#","0xFF"))),),),
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
                    buildShowModalBottomSheet(context,index);
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

  void showToast([String? clipboard]) {
    Fluttertoast.showToast(
        fontSize: 16,
        msg: (clipboard != null) ? clipboard : 'Downloaded successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.white,
        textColor: Colors.black
    );
  }

}
