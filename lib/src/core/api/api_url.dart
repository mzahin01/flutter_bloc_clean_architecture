import 'package:cloud_firestore/cloud_firestore.dart';

class ApiUrl {
  const ApiUrl._();

  static const baseUrl = "https://....com/api/v1";

  // static const products = "/products";
  static CollectionReference get products => FirebaseFirestore.instance.collection("products");
  static CollectionReference get users => FirebaseFirestore.instance.collection("users");
}
