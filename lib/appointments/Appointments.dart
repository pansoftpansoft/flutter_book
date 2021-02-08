import 'package:flutter/material.dart';
import 'AppointmentsDBWorker.dart';
import 'AppointmentsModel.dart' show AppointmentsModel, appointmentsModel;

class Appointments extends StatelessWidget {
  Appointments() {
    appointmentsModel.loadData("appointments", AppointmentsDBWorker.db);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container();
    throw UnimplementedError();
  }
}
