import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomSheetWidget extends StatefulWidget {
  const BottomSheetWidget({Key? key}) : super(key: key);

  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
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
                            onPressed: () {},
                            iconSize: 60,
                            icon: const Image(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/icons/send.png'),
                            )),
                        const Text(
                          "Send",
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
                            onPressed: () {},
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
                            onPressed: () {},
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
                            onPressed: () {},
                            iconSize: 60,
                            icon: const Image(
                              fit: BoxFit.cover,
                              image:
                              AssetImage('assets/icons/whatsapp.png'),
                            )),
                        const Text(
                          "Twitter",
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
                  onPressed: () {},
                  child: Text("Download image",
                      style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).primaryColor))),
              TextButton(
                  onPressed: () {

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
  }
}
