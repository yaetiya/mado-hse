import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetUser extends UserEvent {}

class AddDoneCourse extends UserEvent {
  final String courseId;
  const AddDoneCourse(this.courseId);
}

class TriggerWalletConnect extends UserEvent {}
