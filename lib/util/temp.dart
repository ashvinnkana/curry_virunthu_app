import 'package:flutter/material.dart';

class Temp {
  static List<dynamic> dine_in_cart = [];

  static List<String> categoryLabels = [];

  static List<String> items = [];
  static Map<String, dynamic> itemDatas = {};

  static List<dynamic> curryList = [];

  static List<dynamic> availableTables = [];

  static bool selfOrderUnlock = false;

  // static String STRIPE_SECRET_KEY =
  //     "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";

  static String STRIPE_SECRET_KEY =
      "sk_test_51MpfIVG4FftqZs4OZM6hRCnC2m3weVQlgQ78A0fsOmRy1GFlm13oB2xhs2BM2c4bJwPc3YCGE3DU0u8HxImh8DZj00t4nqncB7";
}
