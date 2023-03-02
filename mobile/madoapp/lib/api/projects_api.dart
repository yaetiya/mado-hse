import 'dart:io';

import 'package:madoapp/blocs/user/user_bloc.dart';
import 'package:madoapp/blocs/user/user_state.dart';
import 'package:madoapp/configs/api_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:madoapp/models/project.dart';
import 'package:madoapp/models/runtime_config.dart';

class ProjectsApi {
  static Future<List<Project>> getProjects() async {
    var url = ApiConfig.urlBuilder('project/get');

    final response = await http.get(url, headers: {
      'Authorization':
          'Bearer ${(userBloc.state as UserLoaded).userModel.accessToken}',
      'locale': RuntimeConfig.region,
      'platform': RuntimeConfig.platform
    });
    if (response.statusCode == 200) {
      List<dynamic> projectsMap = jsonDecode(response.body);
      return projectsMap.map((e) => Project.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load projects");
    }
  }
}
