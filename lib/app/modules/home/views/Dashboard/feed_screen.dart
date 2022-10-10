import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:twitch_clone/app/Models/live_stream.dart';
import 'package:twitch_clone/app/modules/home/controllers/authcontroller.dart';
import 'package:twitch_clone/app/modules/home/controllers/golive_controller.dart';
import 'package:twitch_clone/app/modules/home/views/Dashboard/broadcast_screen.dart';
import 'package:twitch_clone/app/modules/home/views/Widgets/custom_button.dart';
import 'package:timeago/timeago.dart' as timeago;

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  GoLiveController goLiveController = Get.find<GoLiveController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w).copyWith(top: 6.h),
        child: Column(
          children: [
            Text(
              'Live Stream',
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            Expanded(
              child: GetBuilder<GoLiveController>(
                init: GoLiveController(),
                builder: (controller) {
                  return StreamBuilder<dynamic>(
                    stream: goLiveController.getLiveStream(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      List<LiveStream>? listOfStream = snapshot.data;
                      if (listOfStream!.isEmpty) {
                        return const Center(
                          child: Text("No Stream Found yet!"),
                        );
                      }
                      return ListView.builder(
                        itemCount: listOfStream.length,
                        itemBuilder: (context, index) {
                          LiveStream liveStream = listOfStream[index];
                          return InkWell(
                            onTap: () async {
                              await goLiveController.updateViewCount(
                                  id: liveStream.channelId, isIncrease: true);
                              Get.to(
                                () => BroadCastScreen(
                                    isBroadCasting: false,
                                    channelId: liveStream.channelId),
                              );
                            },
                            child: Container(
                              height: 90.h,
                              child: Row(children: [
                                AspectRatio(
                                  aspectRatio:
                                      size.width > 600 ? 14 / 9 : 13 / 9,
                                  child: Image.network(liveStream.image),
                                ),
                                SizedBox(
                                  height: 10.h,
                                  width: 10.w,
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      liveStream.username,
                                      style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      liveStream.title,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text('${liveStream.viewers} Watching'),
                                    Text('Started ${timeago.format(
                                      liveStream.startedAt.toDate(),
                                    )}'),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.more_vert),
                                ),
                              ]),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
