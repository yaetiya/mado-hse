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
import 'package:madoapp/services/scren_size_service.dart';

class AllCourses extends StatefulWidget {
  final List<Course>? courses;
  final List<String> doneUids;
  const AllCourses({Key? key, this.courses, required this.doneUids})
      : super(key: key);

  @override
  State<AllCourses> createState() => _AllCoursesState();
}

const double gridCoursesPadding = 10;

class _AllCoursesState extends State<AllCourses> {
  @override
  Widget build(BuildContext context) {
    List<Course>? courses = widget.courses;
    if (courses == null || courses.isEmpty) return Container();
    final width = MediaQuery.of(context).size.width;
    final isBigScreen = ScreenSizeService.isBigScreen(context);
    double fullWidthWithoutPadding = width - 2 * 26;
    double imgSize = (fullWidthWithoutPadding - 2 * gridCoursesPadding) /
        (isBigScreen ? 5 : 3);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          SectionName(name: AppLocalizations.of(context)!.allCoursesTitle),
          GridView(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 0.68,
                crossAxisCount: (isBigScreen ? 5 : 3),
                crossAxisSpacing: gridCoursesPadding,
                mainAxisSpacing: gridCoursesPadding),
            children: courses
                .map((e) => CourseSmallPreview(
                      course: e,
                      imgSize: imgSize,
                      isDone: widget.doneUids.contains(e.uid),
                    ))
                .toList(),
          )
        ],
      ),
    );
  }
}

class CourseSmallPreview extends StatelessWidget {
  const CourseSmallPreview({
    Key? key,
    required this.course,
    required this.isDone,
    required this.imgSize,
  }) : super(key: key);

  final Course course;
  final double imgSize;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    return Bouncing(
      // isDisabled: course.isNotReady,
      onPress: () {
        Navigator.of(context, rootNavigator: true).pushNamed(
          CoursePage.routeName,
          arguments: ScreenArguments(
            course.uid,
          ),
        );
      },
      child: Stack(
        children: [
          ListView(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              ImageLoader(
                url: course.preview,
                imgSize: imgSize,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                course.name,
                style: const TextStyle(fontSize: 12),
              )
            ],
          ),
          Positioned(
              top: 5,
              right: 5,
              child: Wrap(
                alignment: WrapAlignment.end,
                spacing: 5,
                children: [
                  if (isDone)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                          color: ThemeConfig.kSuccess,
                          borderRadius: BorderRadius.circular(40)),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.doneLabel,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 10),
                        ),
                      ),
                    ),
                  if (course.isNotReady)
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(40)),
                      width: 40,
                      height: 20,
                      child: const Center(
                        child: Text(
                          "Soon",
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    )
                ],
              )),
        ],
      ),
    );
  }
}
