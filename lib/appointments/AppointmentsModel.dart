import 'package:flutter_book/BaseModel.dart';
import '../BaseModel.dart';



class AppointmentsModel extends BaseModel {

  String appointmentTime;

  void setAppointmentTime(String inAppointmentTime) {
    appointmentTime = inAppointmentTime;
    notifyListeners();
  }
}

AppointmentsModel appointmentsModel = AppointmentsModel();
