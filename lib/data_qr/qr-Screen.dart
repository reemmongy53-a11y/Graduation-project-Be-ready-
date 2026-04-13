import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/core/di/di.dart';
import 'package:new_project/data_qr/qr_cubit.dart';
import 'package:new_project/data_qr/qr_state.dart';
import 'package:new_project/design/AppColor.dart';
import 'package:new_project/l10n/app_localizations.dart';

class Qr extends StatelessWidget {
  const Qr({Key? key}) : super(key: key);

  String _formatExpiry(DateTime dt) {
    final local = dt.toLocal();
    return '${local.day}/${local.month}/${local.year}  ${local.hour}:${local.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<QrCubit>()..getMyQr(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Center(
                child: Text(
                  AppLocalizations.of(context)!.qr_code,
                  style: TextStyle(
                    color: AppColor.royalBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            body: BlocBuilder<QrCubit, QrState>(
              builder: (context, state) {
                if (state is QrLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColor.royalBlue),
                  );
                }

                if (state is QrErrorState) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.wifi_off_rounded,
                            color: AppColor.royalBlue,
                            size: 64,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.message,
                            style: const TextStyle(
                              color: AppColor.gray,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () => context.read<QrCubit>().getMyQr(),
                            child: Text(AppLocalizations.of(context)!.try_again),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state is QrSuccessState) {
                  final qr = state.qrModel;
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16),
                        Text(
                         AppLocalizations.of(context)!.scan_qr,
                          style: TextStyle(
                            color: AppColor.gray,
                            fontSize: 14,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 24),


                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColor.softBlue, AppColor.royalBlue],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: AppColor.royalBlue.withOpacity(0.3),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColor.royalBlue.withOpacity(0.2),
                                blurRadius: 40,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(28),
                          child: Column(
                            children: [

                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColor.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Image.memory(
                                  base64Decode(qr.pureBase64),
                                  width: 220,
                                  height: 220,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 24),


                              Text(
                                '${AppLocalizations.of(context)!.code} ${qr.qrCode}',
                                style: const TextStyle(
                                  color: AppColor.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 4,
                                ),
                              ),
                              const SizedBox(height: 12),


                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: qr.isExpired
                                      ? AppColor.red.withOpacity(0.15)
                                      : AppColor.green.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: qr.isExpired
                                        ? AppColor.red.withOpacity(0.4)
                                        : AppColor.green.withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      qr.isExpired
                                          ? Icons.cancel_outlined
                                          : Icons.check_circle_outline,
                                      color: qr.isExpired
                                          ? AppColor.red
                                          : AppColor.green,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      qr.isExpired
                                          ? AppLocalizations.of(context)!.expired
                                          : '${AppLocalizations.of(context)!.valid_until} ${_formatExpiry(qr.expiresAt)}',
                                      style: TextStyle(
                                        color: qr.isExpired
                                            ? AppColor.red
                                            : AppColor.green,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),


                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => context.read<QrCubit>().getMyQr(),
                            icon: const Icon(Icons.refresh_rounded, color: AppColor.white),
                            label:  Text(
                             AppLocalizations.of(context)!.refresh_qr_code,
                              style: TextStyle(
                                color: AppColor.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          );
        },
      ),
    );
  }
}