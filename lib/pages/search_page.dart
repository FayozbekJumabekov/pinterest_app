import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import '../models/pinterest_model.dart';
import '../services/http_service.dart';
import '../services/log_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);
  static const String id = "search_page";

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Pinterest> pinterests = [];
  bool isLoadMore = false;
  TextEditingController textEditingController = TextEditingController();

  /// Search Images by Category
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchWidget(context),
      body: (pinterests.isNotEmpty)
          ? Stack(
              children: [
                /// NotificationListener work when User reach last post

                NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (!isLoadMore &&
                        scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                      searchCategory(textEditingController.text);
                      // start loading data
                      setState(() {});
                    }
                    return true;
                  },
                  child: MasonryGridView.count(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
            )
          : null,
    );
  }

  /// Search Widget
  PreferredSize searchWidget(BuildContext context) {
    return PreferredSize(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
              setState(() {
                pinterests.clear();
                textEditingController.text = text.trim();
                searchCategory(text.trim().toString());
              });
            },
            decoration: InputDecoration(
                hintText: "Search for ideas",
                hintStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    decoration: TextDecoration.none),
                prefixIcon: Icon(
                  CupertinoIcons.search,
                  size: 30,
                  color: Theme.of(context).primaryColor,
                ),
                suffixIcon: Icon(
                  CupertinoIcons.camera_fill,
                  size: 30,
                  color: Theme.of(context).primaryColor,
                ),
                contentPadding: EdgeInsets.all(15),
                border: InputBorder.none),
          ),
        ),
        preferredSize: Size(double.infinity, 80));
  }

  Widget postItems(int index) {
    return Column(
      children: [
        /// Image

        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: pinterests[index].urls!.regular!,
            imageBuilder: (context, imageProvider) => Image(
                image: CachedNetworkImageProvider(
                    pinterests[index].urls!.regular!)),
            placeholder: (context, url) => Container(
                child: Image(
              image: AssetImage("assets/images/img.png"),
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
              IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz))
            ],
          ),
        )
      ],
    );
  }
}
