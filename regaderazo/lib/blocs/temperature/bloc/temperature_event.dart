part of 'temperature_bloc.dart';

@immutable
abstract class TemperatureEvent extends Equatable {
  const TemperatureEvent();

  @override
  List<Object> get props => [];
}

class TemperatureGetEvent extends TemperatureEvent {
  final String profile;

  TemperatureGetEvent({required this.profile});

  @override
  List<Object> get props => [profile];
}
