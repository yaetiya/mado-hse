import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:madoapp/blocs/user/user_bloc.dart';
import 'package:madoapp/blocs/user/user_state.dart';
import 'package:madoapp/configs/api_config.dart';
import 'package:madoapp/models/course.dart';
import 'package:madoapp/models/runtime_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseApi {
  static Future<List<Course>> getRoadmap() async {
    var url = ApiConfig.urlBuilder('course/roadmap');

    final response =
        await http.get(url, headers: {'locale': RuntimeConfig.region});
    if (response.statusCode == 200) {
      List<dynamic> courseMap = jsonDecode(response.body);
      return courseMap.map((e) => Course.fromJsonWithoutParts(e)).toList();
    } else {
      throw Exception("Failed to load courses");
    }
  }

  static Future<bool> onCourseCompleted(String uid) async {
    var url = ApiConfig.urlBuilder('course/on-completed');

    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${(userBloc.state as UserLoaded).userModel.accessToken}',
          'locale': RuntimeConfig.region
        },
        body: jsonEncode({
          'id': uid,
        }));
    return response.statusCode == 200;
  }

  static Future<Course> getCourseById(String uid) async {
    var url = ApiConfig.urlBuilder('course/get-by-id', {'id': uid});

    final response =
        await http.get(url, headers: {'locale': RuntimeConfig.region});
    if (response.statusCode == 200) {
      Map<String, dynamic> courseMap = jsonDecode(response.body);
      return Course.fromJson(courseMap);
    } else {
      throw Exception("Failed to load courses");
    }
  }

  static Future<Course?> getSavedCourseById(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final courseStr = prefs.getString('course-$uid');
    if (courseStr == null) return null;
    final courseMap = jsonDecode(courseStr);
    return Course.fromJson(courseMap);
  }

  static Future<void> saveCourse(Course course) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('course-${course.uid}', jsonEncode(course.toJson()));
  }

  static Future<void> saveCourseIds(List<String> courseIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('roadmap-ids', jsonEncode(courseIds));
  }

  static Future<List<String>> getCourseIds() async {
    final prefs = await SharedPreferences.getInstance();
    final val = prefs.getString('roadmap-ids');
    if (val == null) return [];
    return (jsonDecode(val) as List).map((x) => x as String).toList();
  }
}
