import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../models/collections_model.dart';

class UpdatePage extends StatelessWidget {
  Collections collection;

  UpdatePage({Key? key, required this.collection}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.circle,
                color: Colors.orange,
                size: 10,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                collection.title!.substring(0, 1).toUpperCase() +
                    collection.title!.substring(1).toLowerCase(),
                style: const TextStyle(fontSize: 18),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 180,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: GridView.custom(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverQuiltedGridDelegate(
                  crossAxisCount: 4,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  pattern: [
                    const QuiltedGridTile(2, 2),
                    const QuiltedGridTile(1, 1),
                    const QuiltedGridTile(1, 1),
                    const QuiltedGridTile(1, 2),
                  ],
                ),
                childrenDelegate: SliverChildBuilderDelegate(
                    (context, index) => CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl:
                            collection.previewPhotos![index].urls!.regular!,
                        placeholder: (context, url) => Container(
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image:
                                          AssetImage("assets/images/img.png"),
                                      fit: BoxFit.cover)),
                            )),
                    childCount: 4),
              ),
            ),
          ),
          const SizedBox(height: 10),
          collection.coverPhoto!.description != null
              ? Text(
                  collection.coverPhoto!.description!,
                  style: const TextStyle(fontSize: 16),
                )
              : const SizedBox.shrink(),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
