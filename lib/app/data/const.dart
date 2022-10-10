
import 'package:flutter/material.dart';

import '../modules/home/views/Dashboard/feed_screen.dart';
import '../modules/home/views/Dashboard/golive_screen.dart';

List<Widget> pages = [
  const FeedScreen(),
  const GoLiveScreen(),
  const Center(
    child: Text('Browser'),
  ),
];


