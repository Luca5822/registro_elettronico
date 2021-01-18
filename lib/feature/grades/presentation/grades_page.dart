import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/feature/grades/presentation/states/grades_failure.dart';
import 'package:registro_elettronico/feature/grades/presentation/states/grades_loaded.dart';
import 'package:registro_elettronico/feature/grades/presentation/states/grades_loading.dart';
import 'package:registro_elettronico/feature/grades/presentation/updater/grades_updater_bloc.dart';
import 'package:registro_elettronico/feature/grades/presentation/watcher/grades_watcher_bloc.dart';

class GradesPage extends StatefulWidget {
  GradesPage({Key key}) : super(key: key);

  @override
  _GradesPageState createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).translate('grades'),
          ),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Theme.of(context).accentColor,
            labelColor: Theme.of(context).primaryTextTheme.headline5.color,
            tabs: [
              Container(
                width: 140,
                child: Tab(
                  child: Text(AppLocalizations.of(context)
                      .translate('last_grades')
                      .toUpperCase()),
                ),
              ),
              Container(
                width: 140,
                child: Tab(
                  child: Text(
                      "1° ${AppLocalizations.of(context).translate('term').toUpperCase()}"),
                ),
              ),
              Container(
                width: 140,
                child: Tab(
                  child: Text(
                      "2° ${AppLocalizations.of(context).translate('term').toUpperCase()}"),
                ),
              ),
              Container(
                width: 140,
                child: Tab(
                  child: Text(
                    AppLocalizations.of(context)
                        .translate('overall')
                        .toUpperCase(),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                BlocProvider.of<GradesUpdaterBloc>(context).add(UpdateGrades());
              },
            )
          ],
        ),
        body: BlocBuilder<GradesWatcherBloc, GradesWatcherState>(
          builder: (context, state) {
            if (state is GradesWatcherLoadSuccess) {
              return GradesLoaded(gradesPagesDomainModel: state.gradesSections);
            } else if (state is GradesWatcherFailure) {
              return GradesFailure(failure: state.failure);
            }

            return GradesLoading();
          },
        ),
      ),
    );
  }
}
