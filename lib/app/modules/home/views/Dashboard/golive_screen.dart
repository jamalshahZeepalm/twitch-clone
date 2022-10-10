import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitch_clone/Responsive/responsive.dart';
import 'package:twitch_clone/app/data/colors.dart';
import 'package:twitch_clone/app/modules/home/controllers/golive_controller.dart';
import 'package:twitch_clone/app/modules/home/views/Dashboard/broadcast_screen.dart';
import 'package:twitch_clone/app/modules/home/views/Widgets/custom_button.dart';
import 'package:twitch_clone/app/modules/home/views/Widgets/custom_text_feild.dart';

class GoLiveScreen extends StatefulWidget {
  const GoLiveScreen({super.key});

  @override
  State<GoLiveScreen> createState() => _GoLiveScreenState();
}

class _GoLiveScreenState extends State<GoLiveScreen> {
  final TextEditingController _titleController = TextEditingController();
  Uint8List? image;
  GoLiveController goLiveController = Get.find<GoLiveController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomResponsiveScreen(
        mychild: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        Uint8List? pickedImage = await goLiveController
                            .pickImage(ImageSource.gallery);
                        if (pickedImage != null) {
                          setState(() {
                            image = pickedImage;
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22.0,
                          vertical: 20.0,
                        ),
                        child: image != null
                            ? SizedBox(
                                height: 300,
                                child: Image.memory(image!),
                              )
                            : DottedBorder(
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(10),
                                dashPattern: const [10, 4],
                                strokeCap: StrokeCap.round,
                                color: CustomColors.buttonColor,
                                child: Container(
                                  width: double.infinity,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: CustomColors.buttonColor
                                        .withOpacity(.05),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.folder_open,
                                        color: CustomColors.buttonColor,
                                        size: 40,
                                      ),
                                      SizedBox(height: 15.h),
                                      Text(
                                        'Select your thumbnail',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey.shade400,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Title',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: CustomTextFormFeild(
                            textInputType: TextInputType.text,
                            validator: (v) {
                              return null;
                            },
                            onChange: (onChange) {},
                            textEditingController: _titleController,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 150.h,
                  ),
                  child: CustomButton(
                      myChild: Text('Go Live'),
                      onPressed: () {
                        uploadStream();
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  uploadStream() async {
    String channelId =
        await goLiveController.startLiveStream(_titleController.text, image!);
    if (channelId.isNotEmpty) {
      Get.snackbar(
          'Congrst', 'YouSuccessfully starting live Stream right now!');
      Get.to(
        () => BroadCastScreen(
          isBroadCasting: true,
          channelId: channelId,
        ),
      );
    } else {}
  }
}
