import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Ui/statusService/gateService/device_cubit.dart';
import 'package:new_project/Ui/statusService/gateService/device_service.dart';
import 'package:new_project/Ui/statusService/gateService/device_state.dart';
import 'package:new_project/core/user_session/user_session.dart';
import 'package:new_project/design/AppColor.dart';
import 'package:new_project/design/AppImage.dart';
import 'package:new_project/l10n/app_localizations.dart';
import 'package:new_project/providers/ThemeProvider.dart';
import 'package:provider/provider.dart';

class Status extends StatefulWidget {
  const Status({super.key});

  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> {
  bool get gateOn   => UserSession.gateStatus.value;
  bool get cameraOn => UserSession.cameraStatus.value;

  @override
  void initState() {
    super.initState();
    // ✅ بنسمع التغييرات بشكل صحيح
    UserSession.gateStatus.addListener(_refresh);
    UserSession.cameraStatus.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) setState(() {}); // ✅ mounted check
  }

  @override
  void dispose() {
    UserSession.gateStatus.removeListener(_refresh);
    UserSession.cameraStatus.removeListener(_refresh);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ BlocProvider فوق Consumer
    return BlocProvider(
      create: (_) => DeviceCubit(
        DeviceService(
          baseUrl: 'https://smart-system-attendance-production-d4bd.up.railway.app',
          token: UserSession.token ?? '', // ✅ null safety
        ),
      ),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          final dark = themeProvider.isDarkMode;

          return BlocConsumer<DeviceCubit, DeviceState>(
            listener: (context, state) {
              if (state is DeviceCommandDone) {
                // ✅ بنقرأ من state.isOn مش من الـ getter
                final msg = state.type == 'gate'
                    ? (state.isOn
                    ? AppLocalizations.of(context)!.gate_open
                    : AppLocalizations.of(context)!.gate_close)
                    : (state.isOn
                    ? AppLocalizations.of(context)!.camera_open
                    : AppLocalizations.of(context)!.camera_close);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(msg),
                    backgroundColor: AppColor.green,
                  ),
                );
              } else if (state is DeviceError) {
                // ✅ Rollback — _refresh هتعمل setState أوتوماتيك
                if (state.type == 'gate') {
                  UserSession.gateStatus.value = !gateOn;
                } else {
                  UserSession.cameraStatus.value = !cameraOn;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('❌ ${state.message}'),
                    backgroundColor: AppColor.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              final isGateLoading =
                  state is DeviceGateLoading || state is DeviceGateCommandSent;
              final isCameraLoading =
                  state is DeviceCameraLoading || state is DeviceCameraCommandSent;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: _DeviceCardCompact(
                            dark: dark,
                            imagePath: AppImage.camiraDark,
                            title: AppLocalizations.of(context)!.control_of_camera,
                            deviceLabel: AppLocalizations.of(context)!.camera,
                            deviceValue: AppLocalizations.of(context)!.face_id,
                            statusLabel: AppLocalizations.of(context)!.status,
                            statusValue: cameraOn
                                ? AppLocalizations.of(context)!.open_camera
                                : AppLocalizations.of(context)!.close_camera,
                            isLoading: isCameraLoading,
                            isOn: cameraOn,
                            onToggle: () {
                              final newVal = !cameraOn;
                              UserSession.saveCameraStatus(newVal); // ✅ بدل .value = newVal
                              context.read<DeviceCubit>().sendCameraCommand(
                                newVal ? 'open_camera' : 'close_camera',
                                newValue: newVal,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _DeviceCardCompact(
                            dark: dark,
                            imagePath: AppImage.gateDark,
                            title: AppLocalizations.of(context)!.gate_control,
                            deviceLabel: AppLocalizations.of(context)!.gate,
                            deviceValue: AppLocalizations.of(context)!.d1,
                            statusLabel: AppLocalizations.of(context)!.status,
                            statusValue: gateOn
                                ? AppLocalizations.of(context)!.open_gate
                                : AppLocalizations.of(context)!.close_gate,
                            isLoading: isGateLoading,
                            isOn: gateOn,
                            onToggle: () {
                              final newVal = !gateOn;
                              UserSession.saveGateStatus(newVal); // ✅ بدل .value = newVal
                              context.read<DeviceCubit>().sendCommand(
                                newVal ? 'open_gate' : 'close_gate',
                                newValue: newVal,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
class _DeviceCardCompact extends StatelessWidget {
  final bool dark;
  final String imagePath;
  final String title;
  final String deviceLabel;
  final String deviceValue;
  final String statusLabel;
  final String statusValue;
  final bool isLoading;
  final bool isOn;
  final VoidCallback onToggle;

  const _DeviceCardCompact({
    required this.dark,
    required this.imagePath,
    required this.title,
    required this.deviceLabel,
    required this.deviceValue,
    required this.statusLabel,
    required this.statusValue,
    required this.isLoading,
    required this.isOn,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: dark ? AppColor.darkBackground : AppColor.white,
        borderRadius: BorderRadius.circular(20),
        border: dark
            ? Border.all(color: AppColor.movBlue.withValues(alpha: 0.8), width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: dark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(imagePath, width: 44, height: 44, fit: BoxFit.contain),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: dark ? AppColor.white : AppColor.black,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "$deviceLabel : $deviceValue",
            style: TextStyle(
              fontSize: 12,
              color: dark
                  ? AppColor.white.withValues(alpha: 0.6)
                  : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "$statusLabel : $statusValue",
            style: TextStyle(
              fontSize: 12,
              color: dark
                  ? AppColor.white.withValues(alpha: 0.6)
                  : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: isLoading ? null : onToggle,
            child: Opacity(
              opacity: isLoading ? 0.5 : 1.0,
              child: _CustomToggle(isOn: isOn, isLoading: isLoading),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomToggle extends StatelessWidget {
  final bool isOn;
  final bool isLoading;

  const _CustomToggle({required this.isOn, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 52,
      height: 28,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isOn ? AppColor.royalBlue : Colors.grey.shade300,
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.all(3),
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: isLoading
                  ? const Padding(
                padding: EdgeInsets.all(4),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColor.royalBlue,
                ),
              )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}