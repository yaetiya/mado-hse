import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madoapp/components/bouncing.dart';
import 'package:madoapp/components/image_loader.dart';
import 'package:madoapp/components/section_name.dart';
import 'package:madoapp/configs/theme_config.dart';
import 'package:madoapp/models/course.dart';
import 'package:madoapp/pages/CoursePage/course_page.dart';
import 'package:madoapp/routes/models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecommendedCourse extends StatefulWidget {
  final Course? course;
  const RecommendedCourse({Key? key, Course? this.course}) : super(key: key);

  @override
  State<RecommendedCourse> createState() => _RecommendedCourseState();
}

class _RecommendedCourseState extends State<RecommendedCourse> {
  @override
  Widget build(BuildContext context) {
    Course? course = widget.course;

    const double imageSize = 150;
    double textWidth =
        MediaQuery.of(context).size.width - 16 * 2 - imageSize - 40;
    if (course == null) {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ThemeConfig.kLoadingGrey),
        width: double.infinity,
        height: imageSize,
      );
    }
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: [
        SectionName(name: AppLocalizations.of(context)!.recommendedCourseTitle),
        Bouncing(
          onPress: () {
            Navigator.of(context, rootNavigator: true).pushNamed(
              CoursePage.routeName,
              arguments: ScreenArguments(
                course.uid,
              ),
            );
          },
          child: Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageLoader(
                  url: course.preview,
                  imgSize: imageSize,
                ),
                const SizedBox(
                  width: 12,
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: textWidth,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                course.name,
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        width: textWidth,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                course.shortDescription,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black54),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ])
              ],
            ),
          ),
        ),
      ],
    );
  }
}
