
import 'qr_model.dart';

abstract class QrDataSource {
  Future<QrModel> getMyQr();
}
