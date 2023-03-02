abstract class NotificationsPermissionState {
  const NotificationsPermissionState();
}

class NotificationsPermissionInitial extends NotificationsPermissionState {
  const NotificationsPermissionInitial();
}

class NotificationsPermissionLoaded extends NotificationsPermissionState {
  final bool isAllowed;
  const NotificationsPermissionLoaded(this.isAllowed);
}
