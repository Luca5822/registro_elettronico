import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/grades/subject_grades/bloc.dart';
import 'package:registro_elettronico/ui/feature/widgets/custom_refresher.dart';
import 'package:registro_elettronico/ui/feature/widgets/grade_card.dart';

/// Page of the [last grades]
class LastGradesPage extends StatefulWidget {
  final List<Grade> grades;

  const LastGradesPage({
    Key key,
    @required this.grades,
  }) : super(key: key);

  @override
  _LastGradesPageState createState() => _LastGradesPageState();
}

class _LastGradesPageState extends State<LastGradesPage> {
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();

    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: CustomRefresher(
        onRefresh: () {
          BlocProvider.of<SubjectsGradesBloc>(context)
              .add(UpdateSubjectGrades());
          BlocProvider.of<SubjectsGradesBloc>(context)
              .add(GetGradesAndSubjects());
          return _refreshCompleter.future;
        },
        child: ListView.builder(
          itemCount: widget.grades.length,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: GradeCard(
                  grade: widget.grades[index],
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: GradeCard(
                grade: widget.grades[index],
              ),
            );
          },
        ),
      ),
    );
  }
}
