import 'package:madoapp/models/user.dart';

abstract class UserState {
  const UserState();
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User userModel;
  const UserLoaded(this.userModel);
}

class UserError extends UserState {
  final String? message;
  const UserError(this.message);
}
