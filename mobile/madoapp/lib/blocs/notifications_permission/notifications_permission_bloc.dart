import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notifications_permission_event.dart';
import 'notifications_permission_state.dart';

class NotificationsPermissionBloc
    extends Bloc<NotificationsPermissionEvent, NotificationsPermissionState> {
  NotificationsPermissionBloc()
      : super(const NotificationsPermissionInitial()) {
    on<UpdateNotificationsPermission>((event, emit) async {
      final bool isAllowed = await Permission.notification.status.isGranted;
      emit(NotificationsPermissionLoaded(isAllowed));
    });
    on<InitNotificationsPermission>((event, emit) async {
      notificationsPermissionBloc.add(UpdateNotificationsPermission());
    });
  }
}

final notificationsPermissionBloc = NotificationsPermissionBloc();
