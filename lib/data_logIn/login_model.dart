import 'package:new_project/Ui/auth_Screen/domain/enites/auth_result.dart';
import 'package:new_project/Ui/auth_Screen/domain/enites/user_entity.dart';

class LoginModel {
  String? message;
  String? token;
  LoginEmployee? employee;



  LoginModel({this.message, this.token, this.employee,});

  LoginModel.fromJson(dynamic json) {
    message = json['message'];
    token = json['token'];
    employee = json['employee'] != null
        ? LoginEmployee.fromJson(json['employee'])
        : null;

  }

  AuthResult toEntity() {
    return AuthResult(
      message: message ?? '',
      token: token ?? '',
      user: employee!.toEntity(),

    );
  }
}

class LoginEmployee {
  String? id;
  String? name;
  String? email;
  String? role;
  bool? isBanned;
  dynamic qrCode;
  dynamic qrExpires;
  String? employeeNumber;

  LoginEmployee.fromJson(dynamic json) {
    print('=== LoginEmployee JSON ===');
    print('name: ${json['name']}');
    print('email: ${json['email']}');
    print('role: ${json['role']}');
    print('employeeNumber: ${json['employeeNumber']}');
    print('qr_code: ${json['qr_code']}');

    id = json['_id'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
    isBanned = json['isBanned'];
    qrCode = json['qr_code'];
    qrExpires = json['qr_expires'];
    employeeNumber = json['employeeNumber'];
  }
  UserEntity toEntity() {
    return UserEntity(
      name: name ?? '',
      email: email ?? '',
      password: '',
      role: role ?? '',
      qrCode: qrCode?.toString() ?? '',
      qrExpires: qrExpires?.toString() ?? '',
      employeeNumber: employeeNumber ?? '',
      id: id ?? '',
    );
  }
}