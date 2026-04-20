import 'dart:convert';

GetPusherBeamsPayloadModel getPusherPayloadModelFromJson(String str) =>
    GetPusherBeamsPayloadModel.fromJson(json.decode(str));
String getPusherPayloadModelToJson(GetPusherBeamsPayloadModel data) =>
    json.encode(data.toJson());

class GetPusherBeamsPayloadModel {
  GetPusherBeamsPayloadModel({
    String? channelName,
    Appointment? appointment,
    String? token,
  }) {
    _channelName = channelName;
    _appointment = appointment;
    _token = token;
  }

  GetPusherBeamsPayloadModel.fromJson(dynamic json) {
    _channelName = json['channel_name'];
    _appointment = json['appointment'] != null
        ? Appointment.fromJson(json['appointment'])
        : null;
    _token = json['token'];
  }
  String? _channelName;
  Appointment? _appointment;
  String? _token;
  GetPusherBeamsPayloadModel copyWith({
    String? channelName,
    Appointment? appointment,
    String? token,
  }) =>
      GetPusherBeamsPayloadModel(
        channelName: channelName ?? _channelName,
        appointment: appointment ?? _appointment,
        token: token ?? _token,
      );
  String? get channelName => _channelName;
  Appointment? get appointment => _appointment;
  String? get token => _token;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['channel_name'] = _channelName;
    if (_appointment != null) {
      map['appointment'] = _appointment?.toJson();
    }
    map['token'] = _token;
    return map;
  }
}

Appointment appointmentFromJson(String str) =>
    Appointment.fromJson(json.decode(str));
String appointmentToJson(Appointment data) => json.encode(data.toJson());

class Appointment {
  Appointment({
    String? date,
    String? appointmentTypeId,
    String? isScheduleRequired,
    String? teacherId,
    String? question,
    String? fee,
    String? appointmentStatusName,
    String? endTime,
    String? createdAt,
    String? appointmentTypeName,
    String? startTime,
    String? updatedAt,
    String? appointmentStatusCode,
    String? studentName,
    String? id,
    String? isPaid,
    String? studentId,
    String? teacherName,
  }) {
    _date = date;
    _appointmentTypeId = appointmentTypeId;
    _isScheduleRequired = isScheduleRequired;
    _teacherId = teacherId;
    _question = question;
    _fee = fee;
    _appointmentStatusName = appointmentStatusName;
    _endTime = endTime;
    _createdAt = createdAt;
    _appointmentTypeName = appointmentTypeName;
    _startTime = startTime;
    _updatedAt = updatedAt;
    _appointmentStatusCode = appointmentStatusCode;
    _studentName = studentName;
    _id = id;
    _isPaid = isPaid;
    _studentId = studentId;
    _teacherName = teacherName;
  }

  Appointment.fromJson(dynamic json) {
    _date = json['date'];
    _appointmentTypeId = json['appointment_type_id'];
    _isScheduleRequired = json['is_schedule_required'];
    _teacherId = json['teacher_id'];
    _question = json['question'];
    _fee = json['fee'];
    _appointmentStatusName = json['appointment_status_name'];
    _endTime = json['end_time'];
    _createdAt = json['created_at'];
    _appointmentTypeName = json['appointment_type_name'];
    _startTime = json['start_time'];
    _updatedAt = json['updated_at'];
    _appointmentStatusCode = json['appointment_status_code'];
    _studentName = json['student_name'];
    _id = json['id'];
    _isPaid = json['is_paid'];
    _studentId = json['student_id'];
    _teacherName = json['teacher_name'];
  }
  String? _date;
  String? _appointmentTypeId;
  String? _isScheduleRequired;
  String? _teacherId;
  String? _question;
  String? _fee;
  String? _appointmentStatusName;
  String? _endTime;
  String? _createdAt;
  String? _appointmentTypeName;
  String? _startTime;
  String? _updatedAt;
  String? _appointmentStatusCode;
  String? _studentName;
  String? _id;
  String? _isPaid;
  String? _studentId;
  String? _teacherName;
  Appointment copyWith({
    String? date,
    String? appointmentTypeId,
    String? isScheduleRequired,
    String? teacherId,
    String? question,
    String? fee,
    String? appointmentStatusName,
    String? endTime,
    String? createdAt,
    String? appointmentTypeName,
    String? startTime,
    String? updatedAt,
    String? appointmentStatusCode,
    String? studentName,
    String? id,
    String? isPaid,
    String? studentId,
    String? teacherName,
  }) =>
      Appointment(
        date: date ?? _date,
        appointmentTypeId: appointmentTypeId ?? _appointmentTypeId,
        isScheduleRequired: isScheduleRequired ?? _isScheduleRequired,
        teacherId: teacherId ?? _teacherId,
        question: question ?? _question,
        fee: fee ?? _fee,
        appointmentStatusName: appointmentStatusName ?? _appointmentStatusName,
        endTime: endTime ?? _endTime,
        createdAt: createdAt ?? _createdAt,
        appointmentTypeName: appointmentTypeName ?? _appointmentTypeName,
        startTime: startTime ?? _startTime,
        updatedAt: updatedAt ?? _updatedAt,
        appointmentStatusCode: appointmentStatusCode ?? _appointmentStatusCode,
        studentName: studentName ?? _studentName,
        id: id ?? _id,
        isPaid: isPaid ?? _isPaid,
        studentId: studentId ?? _studentId,
        teacherName: teacherName ?? _teacherName,
      );
  String? get date => _date;
  String? get appointmentTypeId => _appointmentTypeId;
  String? get isScheduleRequired => _isScheduleRequired;
  String? get teacherId => _teacherId;
  String? get question => _question;
  String? get fee => _fee;
  String? get appointmentStatusName => _appointmentStatusName;
  String? get endTime => _endTime;
  String? get createdAt => _createdAt;
  String? get appointmentTypeName => _appointmentTypeName;
  String? get startTime => _startTime;
  String? get updatedAt => _updatedAt;
  String? get appointmentStatusCode => _appointmentStatusCode;
  String? get studentName => _studentName;
  String? get id => _id;
  String? get isPaid => _isPaid;
  String? get studentId => _studentId;
  String? get teacherName => _teacherName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['date'] = _date;
    map['appointment_type_id'] = _appointmentTypeId;
    map['is_schedule_required'] = _isScheduleRequired;
    map['teacher_id'] = _teacherId;
    map['question'] = _question;
    map['fee'] = _fee;
    map['appointment_status_name'] = _appointmentStatusName;
    map['end_time'] = _endTime;
    map['created_at'] = _createdAt;
    map['appointment_type_name'] = _appointmentTypeName;
    map['start_time'] = _startTime;
    map['updated_at'] = _updatedAt;
    map['appointment_status_code'] = _appointmentStatusCode;
    map['student_name'] = _studentName;
    map['id'] = _id;
    map['is_paid'] = _isPaid;
    map['student_id'] = _studentId;
    map['teacher_name'] = _teacherName;
    return map;
  }
}
