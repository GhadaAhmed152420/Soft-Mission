import 'package:eschool/utils/labelKeys.dart';
import 'package:flutter/material.dart';

class TabBarBackgroundContainer extends StatelessWidget {
  final BoxConstraints boxConstraints;

  const TabBarBackgroundContainer({Key? key, required this.boxConstraints})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).scaffoldBackgroundColor),
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.only(
        left: boxConstraints.maxWidth * (0.1),
        right: boxConstraints.maxWidth * (0.1),
        top: boxConstraints.maxHeight * (0.23),
      ),
      height: boxConstraints.maxHeight * (0.325),
      width: boxConstraints.maxWidth * (0.375),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}

class TabBarBackgroundContainer2 extends StatelessWidget {
  final BoxConstraints boxConstraints;
  final String titleKey;

  const TabBarBackgroundContainer2(
      {Key? key, required this.boxConstraints, required this.titleKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).scaffoldBackgroundColor),
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.only(
        left: boxConstraints.maxWidth * (0.01),
        right: boxConstraints.maxWidth * (0.01),
        top: boxConstraints.maxHeight * (0.23),
      ),
      height: boxConstraints.maxHeight * (0.325),
      width: titleKey != announcementKey
          ? boxConstraints.maxWidth * (0.3)
          : boxConstraints.maxWidth * (0.38),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
