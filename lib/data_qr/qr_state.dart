import 'qr_model.dart';

abstract class QrState {}

class QrInitialState extends QrState {}

class QrLoadingState extends QrState {}

class QrSuccessState extends QrState {
  final QrModel qrModel;
  QrSuccessState({required this.qrModel});
}

class QrErrorState extends QrState {
  final String message;
  QrErrorState({required this.message});
}
