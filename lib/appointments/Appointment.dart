class Appointment {
  /// The fields this entity type contains.
int id;
String title;
String description;
String appointmentDate;
String appointmentTime;

String toString() {
    return "{ id=$id, title=$title, description=$description, appointmentDate=$appointmentDate, appointmentTime=$appointmentTime }";
  }
}
