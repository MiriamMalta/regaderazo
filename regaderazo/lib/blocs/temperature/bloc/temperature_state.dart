part of 'temperature_bloc.dart';

@immutable
abstract class TemperatureState extends Equatable{
  const TemperatureState();

  @override
  List<Object> get props => [];
}

class TemperatureInitial extends TemperatureState {}

class TempErrorState extends TemperatureState {
  final String error;

  TempErrorState({required this.error});

  @override
  List<Object> get props => [error];
}

class TempLoadingState extends TemperatureState {
  final String temp;

  TempLoadingState({required this.temp});

  @override
  List<Object> get props => [temp];
}

class TempChartState extends TemperatureState {
  final List<dynamic> temp;

  TempChartState({required this.temp});

  @override
  List<Object> get props => [temp];
}
