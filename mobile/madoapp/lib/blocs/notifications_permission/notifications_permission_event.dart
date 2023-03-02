import 'package:equatable/equatable.dart';

abstract class NotificationsPermissionEvent extends Equatable {
  const NotificationsPermissionEvent();

  @override
  List<Object> get props => [];
}

class UpdateNotificationsPermission extends NotificationsPermissionEvent {}

class InitNotificationsPermission extends NotificationsPermissionEvent {}
