import "package:flutter/foundation.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../core/error.dart";
import "../../domain/user.dart";
import "../../repository/user_repository.dart";
import "state_status.dart";

class UserCubit extends Cubit<UserState> {
  UserCubit(super.initialState, this._repo);
  UserCubit.init(this._repo) : super(UserState(status: StateStatus.initial));

  final UserRepository _repo;
  DateTime lastFetch = DateTime(1970);

  Future<void> fetchAll() async {
    if (isClosed) return;

    emit(state.copyWith(status: StateStatus.loading));
    try {
      lastFetch = DateTime.now();
      final users = await _repo.fetchAll();
      emit(state.copyWith(status: StateStatus.loaded, users: users));
    } catch (e, st) {
      final failure = Failure(e, st);
      if (kDebugMode) debugPrint(failure.toString());
      emit(state.copyWith(status: StateStatus.error, error: failure));
    }
  }

  bool get isReadyToFetch =>
      DateTime.now().isAfter(lastFetch.add(const Duration(minutes: 5)));
}

class UserState {
  UserState({
    required this.status,
    this.users = const [],
    this.error,
  });

  final StateStatus status;
  final List<User> users;
  final Failure? error;

  UserState copyWith({
    StateStatus? status,
    List<User>? users,
    Failure? error,
  }) {
    return UserState(
      status: status ?? this.status,
      users: users ?? this.users,
      error: error ?? this.error,
    );
  }
}