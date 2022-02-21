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
