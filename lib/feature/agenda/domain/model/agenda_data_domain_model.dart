import 'package:flutter/foundation.dart';
import 'package:registro_elettronico/feature/agenda/domain/model/agenda_event_domain_model.dart';
import 'package:registro_elettronico/feature/lessons/domain/model/lesson_domain_model.dart';

class AgendaDataDomainModel {
  Map<DateTime, List<AgendaEventDomainModel>> eventsMap;
  Map<String, List<LessonDomainModel>> lessonsMap;
  List<AgendaEventDomainModel> events;

  AgendaDataDomainModel({
    @required this.events,
    @required this.eventsMap,
    @required this.lessonsMap,
  });
}
