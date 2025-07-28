import 'package:smore_mobile_app/models/sport/prediction.dart';
import 'package:smore_mobile_app/models/sport/ticket.dart';

enum ObjectType {
  prediction,
  ticket,
}

class PredictionResponse {
  final Prediction? prediction;
  final Ticket? ticket;
  final ObjectType objectType;
  final DateTime datetime;

  PredictionResponse({
    required this.objectType,
    required this.datetime,
    this.prediction,
    this.ticket,
  });

  factory PredictionResponse.fromJson(Map<String, dynamic> json) {
    final type = json['object_type'] as String;
    final datetime = DateTime.parse(json['datetime'] as String);

    // print the type and datetime
    print('type: $type');
    print('datetime: $datetime');

    if (type == 'prediction') {
      return PredictionResponse(
        objectType: ObjectType.prediction,
        datetime: datetime,
        prediction: Prediction.fromJson(json),
        ticket: null,
      );
    } else if (type == 'ticket') {
      return PredictionResponse(
        objectType: ObjectType.ticket,
        datetime: datetime,
        prediction: null,
        ticket: Ticket.fromJson(json),
      );
    } else {
      throw Exception('Unknown type: $type');
    }
  }

  @override
  String toString() {
    return 'PredictionResponse(objectType: $objectType, datetime: $datetime, prediction: $prediction, ticket: $ticket)';
  }
}
