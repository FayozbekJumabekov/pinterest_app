import 'package:flutter/material.dart';

import '../models/pinterest_model.dart';

class DetailPage extends StatefulWidget {
  Pinterest post;

  DetailPage({required this.post, Key? key}) : super(key: key);
  static const String id = "detail_page";

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container());
  }
}
