import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madoapp/api/course_api.dart';
import 'package:madoapp/blocs/user/user_bloc.dart';
import 'package:madoapp/blocs/user/user_event.dart';
import 'package:madoapp/blocs/user/user_state.dart';
import 'package:madoapp/components/connect_wallet.dart';
import 'package:madoapp/components/show_paper.dart';
import 'package:madoapp/components/subs_alert.dart';
import 'package:madoapp/configs/content_config.dart';
import 'package:madoapp/models/course.dart';
import 'package:madoapp/pages/CoursePage/components/active_course.dart';
import 'package:madoapp/pages/CoursePage/components/start_course.dart';

import 'package:madoapp/routes/models.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({Key? key}) : super(key: key);
  static const routeName = '/course';

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  bool boolIsCourseStarted = false;
  void Function() onStartButtonClick(Course course) {
    void onClick() {
      // TODO: check sub
      // if (!course.isTestnet) {
      //   ShowPaper.showActionSheet(context, const SubsAlert());
      //   return;
      // }
      setState(() {
        boolIsCourseStarted = true;
      });
    }

    return onClick;
  }

  Future<Course?>? loadingCourse;

  Future<Course?> loadCourse(uid) async {
    try {
      final fetchedCourse = await CourseApi.getCourseById(uid);
      CourseApi.saveCourse(fetchedCourse);
      return fetchedCourse;
    } catch (_) {
      final savedCourse = CourseApi.getSavedCourseById(uid);
      return savedCourse;
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    loadingCourse ??= loadCourse(args.uid);

    void onCourseCompleted() async {
      userBloc.add(AddDoneCourse(args.uid));
      Navigator.pop(
        context,
      );
      final user = (userBloc.state as UserLoaded).userModel;
      if ((user.isUnlocked ?? false) &&
          args.uid == ContentConfig.getWalletCourseUid() &&
          user.address == null) {
        ShowPaper.showActionSheet(context, const ConnectWallet());
      }
    }

    if (loadingCourse == null) return const SizedBox();
    return FutureBuilder<Course?>(
      future: loadingCourse,
      builder: (context, AsyncSnapshot<Course?> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        Course? course = snapshot.data;
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text(
              course?.name ?? "",
              overflow: TextOverflow.ellipsis,
            ),
            // trailing: // icon button (refill),
          ),
          child: course == null
              ? Center(
                  child: snapshot.hasError
                      ? const Text("Loading course error")
                      : const CupertinoActivityIndicator(),
                )
              : SafeArea(
                  child: boolIsCourseStarted
                      ? ActiveCourse(
                          course: course,
                          onCourseCompleted: onCourseCompleted,
                          backToCourseDescription: () {
                            setState(() {
                              boolIsCourseStarted = false;
                            });
                          },
                        )
                      : StartCourse(
                          course: course,
                          onStartButtonClick: onStartButtonClick(course)),
                ),
        );
      },
    );
  }
}
