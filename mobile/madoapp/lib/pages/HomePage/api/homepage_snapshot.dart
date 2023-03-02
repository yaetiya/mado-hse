import 'package:flutter/cupertino.dart';
import 'package:madoapp/api/course_api.dart';
import 'package:madoapp/blocs/user/user_bloc.dart';
import 'package:madoapp/blocs/user/user_state.dart';
import 'package:madoapp/models/course.dart';

class HomePageSnapshot {
  late final List<Course> allCourses;
  HomePageSnapshot(this.allCourses);
}

class HomepageSnapshotApi {
  static Future<HomePageSnapshot> getHomepageSnapshot() async {
    late List<Course> coursesList;
    try {
      coursesList = await CourseApi.getRoadmap();
      await CourseApi.saveCourseIds(coursesList.map((e) => e.uid).toList());
    } catch (e) {
      return HomepageSnapshotApi.getHomepageLocalSnapshot();
    }

    return HomePageSnapshot(
      coursesList,
    );
  }

  static Future<HomePageSnapshot> getHomepageLocalSnapshot() async {
    late List<Course> coursesList;

    final localSavedIds = await CourseApi.getCourseIds();
    List<Course?> lc = (await Future.wait(
            localSavedIds.map((e) => CourseApi.getSavedCourseById(e))))
        .toList();
    coursesList = lc.where((c) => c != null).map((c) => c as Course).toList();

    return HomePageSnapshot(
      coursesList,
    );
  }
}
