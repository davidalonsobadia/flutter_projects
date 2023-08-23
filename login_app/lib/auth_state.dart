import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {}

class InitialState extends AuthState {
  @override
  List<Object> get props => [];
}

class LoadingState extends AuthState {
  @override
  List<Object> get props => [];
}

class SuccessState extends AuthState {
  @override
  List<Object> get props => [];
}

class ErrorState extends AuthState {
  ErrorState(this.exception);

  final Exception exception;
  @override
  List<Object> get props => [exception];
}
