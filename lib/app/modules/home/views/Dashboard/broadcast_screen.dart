// ignore_for_file: library_prefixes

import 'dart:convert';
import 'dart:developer';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:twitch_clone/app/modules/home/controllers/golive_controller.dart';
import 'package:twitch_clone/app/modules/home/controllers/user_controller.dart';
import 'package:twitch_clone/confgs/agora.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:http/http.dart' as http;
import '../Widgets/chat.dart';

class BroadCastScreen extends StatefulWidget {
  final bool isBroadCasting;
  final String channelId;

  const BroadCastScreen(
      {super.key, required this.isBroadCasting, required this.channelId});

  @override
  State<BroadCastScreen> createState() => _BroadCastScreenState();
}

class _BroadCastScreenState extends State<BroadCastScreen> {
  List<int> remoteUid = [];
  bool isMuted = false;
  late RtcEngine rtcEngine;
  bool switchCamera = true;

  @override
  void initState() {
    super.initState();
    _initRtcEngine();
  }

  var user = Get.find<UserController>().user;

  GoLiveController goLiveController = Get.find<GoLiveController>();

  String baseURL = 'https://twitch-app-demo.herokuapp.com';
  String? token;

  Future<void> getToken() async {
    final res = await http.get(Uri.parse(
      baseURL +
          '/rtc/' +
          widget.channelId +
          '/publisher/userAccount/' +
          user.uid +
          '/',
    ));
    if (res.statusCode == 200) {
      setState(() {
        token = res.body;
        token = jsonDecode(token!)['rtcToken'];
        log('token generated: $token');
      });
    } else {
      log('faield to fatch the token');
      log('token generated: $token');
      log('token generated: ${user.uid}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _leaveChannel();
        return Future.value(true);
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(8.h),
            child: Column(
              children: [
                _renderVideo(),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: _switchCamera,
                  child: Text('Switching Camera'),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: onToogleMute,
                  child: Text(
                    isMuted ? 'UnMute' : 'Mute',
                  ),
                ),
                Expanded(child: CustomChatWidget(channelId: widget.channelId))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _initRtcEngine() async {
    rtcEngine = await RtcEngine.createWithContext(RtcEngineContext(appId));
    _addListners();
    await rtcEngine.enableVideo();
    await rtcEngine.startPreview();
    await rtcEngine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    if (widget.isBroadCasting) {
      rtcEngine.setClientRole(ClientRole.Broadcaster);
    } else {
      rtcEngine.setClientRole(ClientRole.Audience);
    }
    _joinCannel();
  }

  void _addListners() async {
    rtcEngine.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (channel, uid, elapsed) {
        log(' joinChannelSuccess:  $channel  $uid  $elapsed');
      },
      userJoined: (uid, elapsed) {
        log('userJoined: $uid  $elapsed');
        setState(() {
          remoteUid.add(uid);
        });
      },
      userOffline: (uid, reason) {
        log('userOffline: $uid  $reason');
        remoteUid.removeWhere((element) => element == uid);
      },
      leaveChannel: (stats) {
        log('leaveChannel: $stats');
        remoteUid.clear();
      },
      tokenPrivilegeWillExpire: (token) async {
        await getToken();
        await rtcEngine.renewToken(token);
      },
    ));
  }

  void _joinCannel() async {
    await getToken();
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
    }
    await rtcEngine.joinChannelWithUserAccount(
      token,
      widget.channelId,
      user.uid,
    );
  }

  _renderVideo() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: user.uid == widget.channelId
          ? RtcLocalView.SurfaceView(
              zOrderOnTop: true,
              zOrderMediaOverlay: true,
            )
          : remoteUid.isNotEmpty
              ? kIsWeb
                  ? RtcRemoteView.SurfaceView(
                      uid: remoteUid[0],
                      channelId: widget.channelId,
                    )
                  : RtcRemoteView.TextureView(
                      uid: remoteUid[0],
                      channelId: widget.channelId,
                    )
              : Container(
                  child: Center(child: Text('Loading')),
                  width: 300,
                  height: 300,
                  color: Colors.grey.shade50,
                ),
    );
  }

  void _switchCamera() {
    rtcEngine.switchCamera().then((value) {
      setState(() {
        switchCamera = !switchCamera;
      });
    }).catchError((error) {
      print(error);
    });
  }

  _leaveChannel() async {
    log('Channel id is KpDp5gj1p7aeCmF8ECXKQKDNeeu2hamal = ${widget.channelId}');
    await rtcEngine.leaveChannel();
    if (user.uid == widget.channelId) {
      log('channel id ${widget.channelId}');
      await goLiveController.endLiveStream(widget.channelId);
    } else {
      await goLiveController.updateViewCount(
          id: widget.channelId, isIncrease: false);
    }
    Get.back();
  }

  void onToogleMute() async {
    setState(() {
      isMuted = !isMuted;
    });
    await rtcEngine.muteLocalAudioStream(isMuted);
  }
}
