// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mission_leftoverlove_admin/core/theme/theme.dart';
import 'package:mission_leftoverlove_admin/utils/utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class StatsHeader extends ConsumerWidget {
  const StatsHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        StatComponent(
            statModel: StatModel(
                title: "Total trees Saved",
                count: "10k",
                image: "assets/tree.png")),
        Container(
          height: 6.h,
          width: 4,
          color: Colors.black.withOpacity(0.2),
        ),
        StatComponent(
            statModel: StatModel(
                title: "Total Co2 Saved",
                count: "10k",
                image: "assets/co2.png"))
      ],
    );
  }
}

class StatComponent extends ConsumerWidget {
  final StatModel statModel;
  const StatComponent({super.key, required this.statModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: primaryColor.withOpacity(0.5),
        ),
        child: Column(
          children: [
            // Image.asset(
            //   statModel.image,
            //   scale: 10,
            // ),
            sbh(4),
            Text(statModel.title),
            sbh(2),
            Text(
              statModel.count,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
            )
          ],
        ));
  }
}

class StatModel {
  final String title;
  final String count;
  final String image;
  StatModel({
    required this.title,
    required this.count,
    required this.image,
  });

  StatModel copyWith({
    String? title,
    String? count,
    String? image,
  }) {
    return StatModel(
      title: title ?? this.title,
      count: count ?? this.count,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'count': count,
      'image': image,
    };
  }

  factory StatModel.fromMap(Map<String, dynamic> map) {
    return StatModel(
      title: map['title'] as String,
      count: map['count'] as String,
      image: map['image'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory StatModel.fromJson(String source) =>
      StatModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'StatModel(title: $title, count: $count, image: $image)';

  @override
  bool operator ==(covariant StatModel other) {
    if (identical(this, other)) return true;

    return other.title == title && other.count == count && other.image == image;
  }

  @override
  int get hashCode => title.hashCode ^ count.hashCode ^ image.hashCode;
}
