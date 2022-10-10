import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:twitch_clone/app/modules/home/controllers/golive_controller.dart';
import 'package:twitch_clone/app/modules/home/views/Widgets/custom_text_feild.dart';

import '../../../../Models/comments.dart';
import '../../../../Models/user_model.dart';
import '../../controllers/user_controller.dart';

class CustomChatWidget extends StatefulWidget {
  final String channelId;
  const CustomChatWidget({
    Key? key,
    required this.channelId,
  }) : super(key: key);

  @override
  State<CustomChatWidget> createState() => _CustomChatWidgetState();
}

class _CustomChatWidgetState extends State<CustomChatWidget> {
  final TextEditingController _chatController = TextEditingController();

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = Get.find<UserController>().user;
    var goLiveStreamContriller = Get.find<GoLiveController>();
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width > 600 ? size.width * 0.25 : double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: StreamBuilder<dynamic>(
              stream: goLiveStreamContriller.getComment(
                  channelId: widget.channelId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                }
                List<CommentsModel>? commentList = snapshot.data;
                return ListView.builder(
                  itemCount: commentList?.length ?? 0,
                  itemBuilder: (context, index) => Container(
                    height: 50.h,
                    child: ListTile(
                      title: Text(
                        commentList?[index].username ?? '',
                        style: TextStyle(
                          color: commentList?[index].ownerId == user.uid
                              ? Colors.blue
                              : Colors.green,
                        ),
                      ),
                      subtitle: Text(
                        commentList?[index].message ?? '',
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          CustomTextFormFeild(
            textEditingController: _chatController,
            oTab: (val) {
              goLiveStreamContriller.chat(
                  id: widget.channelId, text: _chatController.text);
              setState(() {
                _chatController.text = "";
              });
            },
            textInputType: TextInputType.text,
            isPass: false,
            onChange: (val) {},
            validator: (val) {
              return null;
            },
          )
        ],
      ),
    );
  }
}
