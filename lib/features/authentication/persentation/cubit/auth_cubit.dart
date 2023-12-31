import 'package:dartz/dartz.dart';
import 'package:dexef_task/config/routes/routes.dart';
import 'package:dexef_task/core/error/failures.dart';
import 'package:dexef_task/core/utils/app_colors.dart';
import 'package:dexef_task/core/utils/app_strings.dart';
import 'package:dexef_task/features/authentication/domain/entities/user_data.dart';
import 'package:dexef_task/features/authentication/domain/usecases/get_user_data.dart';
import 'package:dexef_task/features/authentication/persentation/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthCubit extends Cubit<AuthState> {
  final GetUserData getUserDataUseCase;
  AuthCubit({required this.getUserDataUseCase}) : super(AuthInitial());

  final ipController = TextEditingController();
  final dataBaseController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  Future<void> login({required BuildContext context}) async {
    if (formKey.currentState!.validate()) {
      if (passwordController.text == 1.toString() &&
          ipController.text == "185.44.64.217,1437" &&
          dataBaseController.text == "DEMO" &&
          userNameController.text == "mahmoud") {
        emit(LoginIsLoading());
        Either<Failure, UserData> response = await getUserDataUseCase({
          "ip": ipController.text,
          "user_name": userNameController.text,
          "dataBase": dataBaseController.text,
          "lang": "ar",
        });
        emit(
          response.fold(
            (failure) => LoginError(msg: _mapFailureToMsg(failure)),
            (userData) {
              Navigator.pushNamed(context, Routes.homeRoute);
              return LoginLoaded(userData: userData);
            },
          ),
        );
      } else {
        Fluttertoast.showToast(
            msg: AppStrings.invalidData,
            backgroundColor: AppColors.red,
            gravity: ToastGravity.BOTTOM);
      }
    }
  }

  String _mapFailureToMsg(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return AppStrings.serverFailure;
      case CacheFailure:
        return AppStrings.cacheFailure;

      default:
        return AppStrings.unexpectedError;
    }
  }
}
