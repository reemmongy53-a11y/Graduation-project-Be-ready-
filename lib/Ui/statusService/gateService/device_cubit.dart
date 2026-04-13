import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Ui/statusService/gateService/device_service.dart';
import 'device_state.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Ui/statusService/gateService/device_service.dart';
import 'device_state.dart';

class DeviceCubit extends Cubit<DeviceState> {
  final DeviceService _deviceService;
  Timer? _gatePollingTimer;
  Timer? _cameraPollingTimer;

  // ✅ بنحفظ القيمة الجديدة عشان نبعتها مع DeviceCommandDone
  bool _pendingGateValue = false;
  bool _pendingCameraValue = false;

  DeviceCubit(this._deviceService) : super(DeviceInitial());

  Future<void> sendCommand(String command, {required bool newValue}) async {
    _pendingGateValue = newValue; // ✅
    emit(DeviceGateLoading());
    try {
      final sentCommand = await _deviceService.sendCommand(command);
      emit(DeviceGateCommandSent(sentCommand));
      _startGatePolling();
    } catch (e) {
      emit(DeviceError(e.toString(), type: 'gate'));
    }
  }

  Future<void> sendCameraCommand(String command, {required bool newValue}) async {
    _pendingCameraValue = newValue; // ✅
    emit(DeviceCameraLoading());
    try {
      final sentCommand = await _deviceService.sendCommand(command); // ✅ نفس الدالة
      emit(DeviceCameraCommandSent(sentCommand));
      _startCameraPolling();
    } catch (e) {
      emit(DeviceError(e.toString(), type: 'camera'));
    }
  }

  void _startGatePolling() {
    _gatePollingTimer?.cancel();
    _gatePollingTimer = Timer.periodic(
      const Duration(seconds: 2),
          (_) => _checkGateStatus(),
    );
  }

  void _startCameraPolling() {
    _cameraPollingTimer?.cancel();
    _cameraPollingTimer = Timer.periodic(
      const Duration(seconds: 2),
          (_) => _checkCameraStatus(),
    );
  }

  Future<void> _checkGateStatus() async {
    try {
      final isDone = await _deviceService.isCommandDone(); // ✅ نفس الدالة
      if (isDone) {
        _gatePollingTimer?.cancel();
        emit(DeviceCommandDone(type: 'gate', isOn: _pendingGateValue)); // ✅
      }
    } catch (e) {
      _gatePollingTimer?.cancel();
      emit(DeviceError(e.toString(), type: 'gate'));
    }
  }

  Future<void> _checkCameraStatus() async {
    try {
      final isDone = await _deviceService.isCommandDone(); // ✅ نفس الدالة
      if (isDone) {
        _cameraPollingTimer?.cancel();
        emit(DeviceCommandDone(type: 'camera', isOn: _pendingCameraValue)); // ✅
      }
    } catch (e) {
      _cameraPollingTimer?.cancel();
      emit(DeviceError(e.toString(), type: 'camera'));
    }
  }

  void reset() {
    _gatePollingTimer?.cancel();
    _cameraPollingTimer?.cancel();
    emit(DeviceInitial());
  }

  @override
  Future<void> close() {
    _gatePollingTimer?.cancel();
    _cameraPollingTimer?.cancel();
    return super.close();
  }
}