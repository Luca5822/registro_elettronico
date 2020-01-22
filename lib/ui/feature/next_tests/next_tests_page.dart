import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/ui/bloc/agenda/bloc.dart';

import 'package:registro_elettronico/data/db/moor_database.dart' as db;
import 'package:registro_elettronico/ui/feature/next_tests/components/next_tests_chart.dart';
import 'package:registro_elettronico/ui/feature/widgets/app_drawer.dart';
import 'package:registro_elettronico/ui/feature/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/ui/feature/widgets/custom_app_bar.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/drawer_constants.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:registro_elettronico/utils/string_utils.dart';

class NextTestsPage extends StatefulWidget {
  NextTestsPage({Key key}) : super(key: key);

  @override
  _NextTestsPageState createState() => _NextTestsPageState();
}

class _NextTestsPageState extends State<NextTestsPage> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  void initState() {
    // BlocProvider.of<AgendaBloc>(context)
    //     .add(GetNextEvents(dateTime: DateTime.now()));

    BlocProvider.of<AgendaBloc>(context).add(GetNextEvents(dateTime: DateTime.now()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: AppDrawer(
        position: DrawerConstants.NEXT_TESTS,
      ),
      appBar: CustomAppBar(
        title: Text(AppLocalizations.of(context).translate('next_tests')),
        scaffoldKey: _drawerKey,
      ),
      body: BlocBuilder<AgendaBloc, AgendaState>(
        builder: (context, state) {
          if (state is AgendaUpdateLoadInProgress) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is AgendaLoadSuccess) {
            final events = state.events
                .toSet()
                //.where((e) => GlobalUtils.isVerificaOrInterrogazione(e.notes))
                .toList();
            return NextTestsChart(events: events);
            return Column(
              children: <Widget>[
                NextTestsChart(events: events),
                _buildEventsList(events),
              ],
            );
          } else if (state is AgendaLoadError) {
            return CustomPlaceHolder(
              text: AppLocalizations.of(context)
                  .translate('unexcepted_error_single'),
              showUpdate: true,
              icon: Icons.error,
              onTap: () {
                BlocProvider.of<AgendaBloc>(context).add(UpdateAllAgenda());
                BlocProvider.of<AgendaBloc>(context)
                    .add(GetNextEvents(dateTime: DateTime.now()));
              },
            );
          }

          return Container();
        },
      ),
    );
  }

  Widget _buildEventsList(List<db.AgendaEvent> events) {
    if (events.length == 0) {
      return Text('Nessun evento');
    } else {
      return ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: events.length,
        itemBuilder: (BuildContext context, int index) {
          final event = events[index];
          return Card(
            child: ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(AppLocalizations.of(context)
                      .translate('hour')
                      .toLowerCase()),
                  Text(
                      '${event.begin.hour.toString()} - ${event.end.hour.toString()}')
                ],
              ),
              title: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                child: Text(
                  '${StringUtils.titleCase(event.authorName)}',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                child: Text(
                  '${event.notes} ${event.isFullDay ? " - (Tutto il giorno)" : ""}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },
      );
    }
  }
}
