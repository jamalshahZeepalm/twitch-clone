import 'dart:developer';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitch_clone/app/Models/live_stream.dart';
import 'package:twitch_clone/app/modules/home/controllers/user_controller.dart';
import 'package:twitch_clone/app/modules/home/views/DataBase%20Helper/helper.dart';
import 'package:uuid/uuid.dart';

import '../../../Models/comments.dart';
import 'package:file_picker/file_picker.dart';


class GoLiveController extends GetxController {
  DataBaseHelper dataBaseHelper = DataBaseHelper();
  FirebaseStorage storage = FirebaseStorage.instance;
  var userController = Get.find<UserController>();

  Future<String> startLiveStream(
    String title,
    Uint8List image,
  ) async {
    String channelId = '';

    try {
      if (title.isNotEmpty && image != null) {
        if (!((await dataBaseHelper.liveStremCollection
                .doc(userController.user.uid)
                .get())
            .exists)) {
          String thumbnailURL = await uploadThumbnail(
            childName: 'liveStream_thumbnail',
            file: image,
            uid: userController.user.uid,
          );
          String userName = userController.user.userName;
          log(userName);
          channelId = userController.user.uid;
          LiveStream liveStream = LiveStream(
              title: title,
              image: thumbnailURL,
              uid: userController.user.uid,
              username: userName,
              viewers: 0,
              channelId: channelId,
              startedAt: DateTime.now());

          await uploadToFireStore(liveStream: liveStream);
        } else {
          Get.snackbar(
              'Live Stream', 'Two Livestreams cannot start at the same time.');
        }
      } else {
        log(userController.user.uid);
        Get.snackbar('Upload Error', 'Please Fill The Feilds');
      }
    } catch (e) {
      log(e.toString());
    }

    return channelId;
  }

  Future<Uint8List?> pickImage(ImageSource source) async {
   
    try {
     FilePickerResult? pickedImage =
      await FilePicker.platform.pickFiles(type: FileType.image);
      if (pickedImage != null) {
        if (kIsWeb) {
          return pickedImage.files.single.bytes;
        } else {
          Get.snackbar('Upload File', 'Successfully Image Selected');
          return await File(pickedImage.files.single.path!).readAsBytes();
        }
      } else {
        Get.snackbar('No File', 'File not Selected');
        return null;
      }
    } on PlatformException catch (e) {
      log(e.toString());
      Get.snackbar('Error', e.toString());
    }
  }
  
  Future<String> uploadThumbnail(
      {required String childName, Uint8List? file, required String uid}) async {
    Reference ref = storage.ref().child(childName).child(uid);
    UploadTask uploadTask = ref.putData(
      file!,
      SettableMetadata(contentType: 'image/jpg'),
    );
    TaskSnapshot snapshot = await uploadTask;
    String getDownloadUrl = await snapshot.ref.getDownloadURL();
    return getDownloadUrl;
  }

  uploadToFireStore({required LiveStream liveStream}) async {
    await dataBaseHelper.liveStremCollection
        .doc(liveStream.uid)
        .set(liveStream.toMap());
  }

  Future<void> endLiveStream(String channelId) async {
    try {
      QuerySnapshot snap = await dataBaseHelper.liveStremCollection
          .doc(channelId)
          .collection('comments')
          .get();
      for (int i = 0; i < snap.docs.length; i++) {
        await dataBaseHelper.liveStremCollection
            .doc(channelId)
            .collection('comments')
            .doc(
              ((snap.docs[i].data()! as dynamic)['commentId']),
            )
            .delete();
        log(snap.toString());
      }
      log("Trying to delete ${dataBaseHelper.liveStremCollection.doc(channelId).path}");
      await dataBaseHelper.liveStremCollection.doc(channelId).delete();
      log(channelId);
      log('Collection Deleted');
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateViewCount(
      {required String id, required bool isIncrease}) async {
    try {
      await dataBaseHelper.liveStremCollection
          .doc(id)
          .update({'viewers': FieldValue.increment(isIncrease ? 1 : -1)});
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> chat({required String text, required String id}) async {
    try {
      String commentId = const Uuid().v1();
      CommentsModel comments = CommentsModel(
          commentId: commentId,
          createdAt: DateTime.now(),
          message: text,
          ownerId: userController.user.uid,
          username: userController.user.userName);
      await dataBaseHelper.liveStremCollection
          .doc(id)
          .collection('comments')
          .doc(commentId)
          .set(comments.toMap());
    } on FirebaseException catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Stream<List<CommentsModel>> getComment({required String channelId}) {
    return dataBaseHelper.liveStremCollection
        .doc(channelId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return CommentsModel.fromMap(doc.data());
      }).toList();
    });
  }

  Stream<List<LiveStream>> etLiveStream() {
    return dataBaseHelper.liveStremCollection.snapshots().map((event) {
      return event.docs.map((e) {
        return LiveStream.fromMap(e.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
