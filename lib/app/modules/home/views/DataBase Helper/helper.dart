 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataBaseHelper 
 {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference get userCollection => firestore.collection('Users');
   CollectionReference get liveStremCollection => firestore.collection('LiveStream');
 }