import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:new_project/core/errors/failure.dart';
import 'package:new_project/parking%20report/ParkingDataSource.dart';
import 'package:new_project/parking%20report/ParkingModel.dart';
import 'package:new_project/parking%20report/ParkingRepository.dart';

@Injectable(as: ParkingRepository)
class ParkingRepositoryImpl implements ParkingRepository {
  final ParkingDataSource _dataSource;
  ParkingRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, ParkingModel>> getParkingReport() async {
    try {
      final result = await _dataSource.getParkingReport();
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.response?.data['message'] ?? 'Something went wrong'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}