import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madoapp/api/course_api.dart';
import 'package:madoapp/api/user_api.dart';
import 'package:madoapp/blocs/balance/balance_bloc.dart';
import 'package:madoapp/blocs/balance/balance_event.dart';
import 'package:madoapp/blocs/user/user_event.dart';
import 'package:madoapp/blocs/user/user_state.dart';
import 'package:madoapp/models/user.dart';
import 'package:madoapp/models/wallet_connect_service.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<GetUser>((event, emit) async {
      try {
        emit(UserLoading());
        late User loadedUser;
        final activeSession = await UserApi.getUserLocally();

        if (activeSession == null) {
          loadedUser = await UserApi.createUser();
        } else {
          loadedUser = activeSession;
        }
        final connectedAddress =
            await WalletConnectService.checkWalletConnect();
        loadedUser.address ??= connectedAddress;
        try {
          final serverUserVersion =
              await UserApi.getUserByJWT(loadedUser.accessToken);
          for (var c in loadedUser.doneCourses) {
            if (!serverUserVersion.doneCourses.contains(c)) {
              CourseApi.onCourseCompleted(c);
            }
          }
          loadedUser.isUnlocked = serverUserVersion.isUnlocked;
          for (var c in serverUserVersion.doneCourses) {
            if (!loadedUser.doneCourses.contains(c)) {
              loadedUser.doneCourses.add(c);
            }
          }
          if (serverUserVersion.address == null && loadedUser.address != null) {
            UserApi.addAddress(loadedUser.address!, loadedUser.accessToken);
          } else if (serverUserVersion.address != null) {
            loadedUser.address = serverUserVersion.address;
          }
        } catch (e) {
          debugPrint(e.toString());
          debugPrint("update error");
        }
        if (loadedUser.address != null) {
          balanceBloc.add(GetBalance());
        }
        UserApi.saveUserLocally(loadedUser);
        emit(UserLoaded(loadedUser));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
    on<AddDoneCourse>((event, emit) async {
      CourseApi.onCourseCompleted(event.courseId);
      final loadedUser = userBloc.state as UserLoaded;
      UserApi.saveUserLocally((userBloc.state as UserLoaded).userModel);
      emit(UserLoaded(User.withParams(
          loadedUser.userModel.accessToken,
          loadedUser.userModel.address,
          loadedUser.userModel.doneCourses..add(event.courseId))));
    });
    on<TriggerWalletConnect>((event, emit) async {
      try {
        final loadedUser = userBloc.state as UserLoaded;
        if (loadedUser.userModel.address != null) return;
        final address = await AuthService.initWalletConnect().catchError((e) {
          emit(UserError(e.toString()));
        });

        final newUser = User.withParams(loadedUser.userModel.accessToken,
            address, loadedUser.userModel.doneCourses);
        if (address == null) {
          newUser.isWalletConnectError = true;
        } else {
          UserApi.addAddress(address, newUser.accessToken);
        }
        emit(UserLoaded(newUser));
        UserApi.saveUserLocally(newUser);
      } catch (e) {
        emit(const UserError("Failed to connect to wallet"));
      }
    });
  }
}

final userBloc = UserBloc();
