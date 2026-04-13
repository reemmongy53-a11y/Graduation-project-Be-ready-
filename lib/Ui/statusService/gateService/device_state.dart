import 'package:equatable/equatable.dart';
import 'package:new_project/Ui/statusService/gateService/device_command.dart';
abstract class DeviceState extends Equatable {
  const DeviceState();
  @override
  List<Object?> get props => [];
}

class DeviceInitial extends DeviceState {}

class DeviceGateLoading extends DeviceState {}
class DeviceGateCommandSent extends DeviceState {
  final DeviceCommand command;
  const DeviceGateCommandSent(this.command);
  @override
  List<Object?> get props => [command];
}

class DeviceCameraLoading extends DeviceState {}
class DeviceCameraCommandSent extends DeviceState {
  final DeviceCommand command;
  const DeviceCameraCommandSent(this.command);
  @override
  List<Object?> get props => [command];
}

class DeviceCommandDone extends DeviceState {
  final String type;
  final bool isOn; // ✅ ضيفنا الحقل ده
  const DeviceCommandDone({required this.type, required this.isOn});
  @override
  List<Object?> get props => [type, isOn];
}

class DeviceError extends DeviceState {
  final String message;
  final String type;
  const DeviceError(this.message, {required this.type});
  @override
  List<Object?> get props => [message, type];
}