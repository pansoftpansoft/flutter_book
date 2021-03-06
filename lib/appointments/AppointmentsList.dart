import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'Appointment.dart';
import 'AppointmentsDBWorker.dart';
import 'AppointmentsModel.dart';

class AppointmentsList extends StatelessWidget {
  Widget build(BuildContext inContext) {
    EventList<Event> _markedDateMap = EventList();
    for (int i = 0; i < appointmentsModel.entityList.length; i++) {
      Appointment appointment = appointmentsModel.entityList[i];
      List dateParts = appointment.appointmentDate.split(",");
      DateTime appointmentDate = DateTime(int.parse(dateParts[0]),
          int.parse(dateParts[1]), int.parse(dateParts[2]));
      _markedDateMap.add(
          appointmentDate,
          Event(
              date: appointmentDate,
              icon: Container(
                decoration: BoxDecoration(color: Colors.blue),
              )));
    }
    return ScopedModel<AppointmentsModel>(
      model: appointmentsModel,
      child: ScopedModelDescendant<AppointmentsModel>(
          builder: (inContext, inChild, inModel) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add, color: Colors.white),
            onPressed: () async {
              appointmentsModel.entityBeingEdited = Appointment();
              DateTime now = DateTime.now();
              appointmentsModel.entityBeingEdited.appointmentDate=
                  "${now.year},${now.month}, ${now.day}";
              appointmentsModel.setChosenDate(
                  DateFormat.yMMMMd("en_US").format(now.toLocal()));
              appointmentsModel.setAppointmentTime(null);
              appointmentsModel.setStackIndex(1);
            },
          ),
          body: Column(
            children: [
              Expanded(
                  child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: CalendarCarousel<Event>(
                        thisMonthDayBorderColor: Colors.grey,
                        daysHaveCircularBorder: false,
                        markedDatesMap: _markedDateMap,
                        onDayPressed: (DateTime inDate, List<Event> inEvents) {
                          _showAppointments(inDate, inContext);
                        },
                      )))
            ],
          ),
        );
      }),
    );
  }

  void _showAppointments(DateTime inDate, BuildContext inContext) async {
    print(
        "## AppointmentsList._showAppointments(): inDate = $inDate (${inDate.year},${inDate.month},${inDate.day})"
    );
    showModalBottomSheet(
        context: inContext,
        builder: (BuildContext inContext) {
          return ScopedModel<AppointmentsModel>(
            model: appointmentsModel,
            child: ScopedModelDescendant<AppointmentsModel>(builder:
                (BuildContext inContext, Widget inChild,
                    AppointmentsModel inModel) {
              return Scaffold(
                body: Container(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: GestureDetector(
                      child: Column(
                        children: [
                          Text(
                            DateFormat.yMMMMd("en_US").format(inDate.toLocal()),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(inContext).accentColor,
                                fontSize: 24),
                          ),
                          Divider(),
                          Expanded(
                            child: ListView.builder(
                              itemCount: appointmentsModel.entityList.length,
                              itemBuilder:
                                  (BuildContext inBuildContext, int inIndex) {
                                Appointment appointment =
                                    appointmentsModel.entityList[inIndex];
                                if (appointment.appointmentDate !=
                                    "${inDate.year},${inDate.month},${inDate.day}") {
                                  return Container(height: 0);
                                }
                                String appointmentTime = "";
                                if (appointment.appointmentTime != null) {
                                  List timeParts =
                                      appointment.appointmentTime.split(",");
                                  TimeOfDay at = TimeOfDay(
                                      hour: int.parse(timeParts[0]),
                                      minute: int.parse(timeParts[1]));
                                  appointmentTime = "(${at.format(inContext)})";
                                }
                                return Slidable(
                                  actionPane: SlidableBehindActionPane(),
                                  actionExtentRatio: .25,
                                  child: Container(
                                    color: Colors.grey.shade300,
                                    child: ListTile(
                                      title: Text(
                                          "${appointment.title}$appointmentTime"),
                                      subtitle: appointment.description == null
                                          ? null
                                          : Text("${appointment.description}"),
                                      onTap: () async {
                                        _editAppointment(
                                            inContext, appointment);
                                      },
                                    ),
                                  ),
                                  secondaryActions: [
                                    IconSlideAction(
                                        caption: "Delete",
                                        color: Colors.red,
                                        icon: Icons.delete,
                                        onTap: () => _deleteAppointment(
                                            inBuildContext, appointment))
                                  ],
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        });
  }

  void _editAppointment(BuildContext inContext, Appointment inAppointment) async {

    print("## AppointmentsList._editAppointment(): inAppointment = $inAppointment");

    // Get the data from the database and send to the edit view.
    appointmentsModel.entityBeingEdited = await AppointmentsDBWorker.db.get(inAppointment.id);
    // Parse out the apptDate and apptTime, if any, and set them in the model
    // for display.
    if (appointmentsModel.entityBeingEdited.appointmentDate == null) {
      appointmentsModel.setChosenDate(null);
    } else {
      List dateParts = appointmentsModel.entityBeingEdited.appointmentDate.split(",");
      DateTime appointmentDate = DateTime(
          int.parse(dateParts[0]), int.parse(dateParts[1]), int.parse(dateParts[2])
      );
      appointmentsModel.setChosenDate(
          DateFormat.yMMMMd("en_US").format(appointmentDate.toLocal())
      );
    }
    if (appointmentsModel.entityBeingEdited.appointmentTime == null) {
      appointmentsModel.setAppointmentTime(null);
    } else {
      List timeParts = appointmentsModel.entityBeingEdited.appointmentTime.split(",");
      TimeOfDay appointmentTime = TimeOfDay(
          hour : int.parse(timeParts[0]), minute : int.parse(timeParts[1])
      );
      appointmentsModel.setAppointmentTime(appointmentTime.format(inContext));
    }
    appointmentsModel.setStackIndex(1);
    Navigator.pop(inContext);

  } /* End _editAppointment. */

  Future _deleteAppointment(BuildContext inContext, Appointment inAppointment) async {

    print("## AppointmentsList._deleteAppointment(): inAppointment = $inAppointment");

    return showDialog(
        context : inContext,
        barrierDismissible : false,
        builder : (BuildContext inAlertContext) {
          return AlertDialog(
              title : Text("Delete Appointment"),
              content : Text("Are you sure you want to delete ${inAppointment.title}?"),
              actions : [
                FlatButton(child : Text("Cancel"),
                    onPressed: () {
                      // Just hide dialog.
                      Navigator.of(inAlertContext).pop();
                    }
                ),
                FlatButton(child : Text("Delete"),
                    onPressed : () async {
                      // Delete from database, then hide dialog, show SnackBar, then re-load data for the list.
                      await AppointmentsDBWorker.db.delete(inAppointment.id);
                      Navigator.of(inAlertContext).pop();
                      Scaffold.of(inContext).showSnackBar(
                          SnackBar(
                              backgroundColor : Colors.red,
                              duration : Duration(seconds : 2),
                              content : Text("Appointment deleted")
                          )
                      );
                      // Reload data from database to update list.
                      appointmentsModel.loadData("appointments", AppointmentsDBWorker.db);
                    }
                )
              ]
          );
        }
    );

  } /* End _deleteAppointment(). */

}
