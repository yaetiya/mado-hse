import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madoapp/components/html_render.dart';
import 'package:madoapp/components/image_loader.dart';
import 'package:madoapp/configs/theme_config.dart';
import 'package:madoapp/models/course.dart';
import 'package:madoapp/pages/CoursePage/components/active_course.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:madoapp/services/scren_size_service.dart';

class StartCourse extends StatelessWidget {
  final Course course;
  final void Function() onStartButtonClick;
  const StartCourse(
      {Key? key, required this.course, required this.onStartButtonClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isBigScreen = ScreenSizeService.isBigScreen(context);
    final width = MediaQuery.of(context).size.width;
    final bigScreenImageSize = width / 3;
    final bigScreenPadding = 20;
    double imgWidth = !isBigScreen ? width : bigScreenImageSize;

    return SizedBox(
      width: double.infinity,
      child: CupertinoScrollbar(
        isAlwaysShown: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: paddingX),
          child: Stack(fit: StackFit.expand, children: [
            isBigScreen
                ? Positioned(
                    left: imgWidth + bigScreenPadding,
                    top: 0,
                    width: width - bigScreenPadding - bigScreenImageSize,
                    child: StartCourseContent(imgWidth, false),
                  )
                : Positioned.fill(
                    child: StartCourseContent(imgWidth, true),
                  ),
            if (isBigScreen)
              Positioned(
                left: 0,
                top: 30,
                height: imgWidth,
                width: imgWidth,
                child: ImageLoader(
                  url: course.preview,
                  imgSize: imgWidth,
                ),
              ),
            Positioned(
                bottom: 10.0,
                right: 0.0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black87.withOpacity(0.15),
                        spreadRadius: 4,
                        blurRadius: 15,
                        offset:
                            const Offset(0, 0), // changes position of shadow
                      ),
                    ],
                  ),
                  child: CupertinoButton(
                    borderRadius: BorderRadius.circular(30.0),
                    disabledColor: const Color(0xDDCCCCCC),
                    color: ThemeConfig.kPrimary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 34, vertical: 16),
                    onPressed: course.isNotReady ? null : onStartButtonClick,
                    child: Text(AppLocalizations.of(context)!.start,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                )),
          ]),
        ),
      ),
    );
  }

  ListView StartCourseContent(double imgWidth, bool isWithImage) {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: [
        const SizedBox(
          height: 10,
        ),
        if (isWithImage)
          SizedBox(
            height: imgWidth,
            width: imgWidth,
            child: ImageLoader(
              url: course.preview,
              imgSize: imgWidth,
            ),
          ),
        const SizedBox(
          height: 30,
        ),
        Text(
          course.name,
          style: const TextStyle(
              color: Colors.black87, fontSize: 32, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 10,
        ),
        if (course.isNotReady)
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(40)),
                width: 60,
                height: 25,
                child: const Center(
                  child: Text(
                    "Soon",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        const SizedBox(
          height: 10,
        ),
        HtmlRender(html: course.description),
        const SizedBox(
          height: 100,
        ),
      ],
    );
  }
}
