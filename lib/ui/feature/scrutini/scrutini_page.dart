import 'package:dio/dio.dart';
import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/network/service/web/web_spaggiari_client.dart';
import 'package:registro_elettronico/data/network/service/web/web_spaggiari_client_impl.dart';
import 'package:registro_elettronico/domain/repository/scrutini_repository.dart';
import 'package:registro_elettronico/ui/bloc/documents/bloc.dart';
import 'package:registro_elettronico/ui/feature/scrutini/web/spaggiari_web_view.dart';
import 'package:registro_elettronico/ui/feature/widgets/app_drawer.dart';
import 'package:registro_elettronico/ui/feature/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/ui/feature/widgets/custom_app_bar.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/drawer_constants.dart';

class ScrutiniPage extends StatefulWidget {
  const ScrutiniPage({Key key}) : super(key: key);

  @override
  _ScrutiniPageState createState() => _ScrutiniPageState();
}

class _ScrutiniPageState extends State<ScrutiniPage> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<DocumentsBloc>(context).add(GetDocuments());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      appBar: CustomAppBar(
        scaffoldKey: _drawerKey,
        title: Text(AppLocalizations.of(context).translate('scrutini')),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              BlocProvider.of<DocumentsBloc>(context).add(UpdateDocuments());
              BlocProvider.of<DocumentsBloc>(context).add(GetDocuments());
            },
          )
        ],
      ),
      drawer: AppDrawer(
        position: DrawerConstants.SCRUTINI,
      ),
      body: BlocBuilder<DocumentsBloc, DocumentsState>(
        builder: (context, state) {
          if (state is DocumentsLoadSuccess) {
            return _buildDocumentsList(
              documents: state.documents,
              schoolReports: state.schoolReports,
            );
          }

          if (state is DocumentsUpdateLoadError ||
              state is DocumentsLoadError) {
            return CustomPlaceHolder(
              icon: Icons.error,
              text: AppLocalizations.of(context).translate('unexcepted_error'),
              showUpdate: true,
              onTap: () {
                BlocProvider.of<DocumentsBloc>(context).add(UpdateDocuments());
              },
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _buildDocumentsList({
    @required List<SchoolReport> schoolReports,
    @required List<Document> documents,
  }) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            'School reports',
            style: TextStyle(color: Colors.red),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: schoolReports.length,
          itemBuilder: (context, index) {
            final report = schoolReports[index];
            return ListTile(
              title: Text(report.description),
              onTap: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SpaggiariWebView(
                      phpSessid: '26ftcn9ih43loas936h21ilpl2l520mh',
                      url: report.viewLink,
                      appBarTitle: report.viewLink,
                    ),
                  ),
                );
                // final tokenResponse =
                //     await RepositoryProvider.of<ScrutiniRepository>(context)
                //         .getLoginToken();
                // tokenResponse.fold(
                //     (error) => {
                //           Scaffold.of(context).showSnackBar(
                //             SnackBar(
                //               content: Text('Retry'),
                //             ),
                //           )
                //         }, (token) {
                //   Navigator.of(context).push(
                //     MaterialPageRoute(
                //       builder: (context) => SpaggiariWebView(
                //         phpSessid: token,
                //         url: report.viewLink,
                //         appBarTitle: report.description,
                //       ),
                //     ),
                //   );
                // });
              },
            );
          },
        ),
        ListTile(
          title: Text(
            'Documents',
            style: TextStyle(color: Colors.red),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: documents.length,
          itemBuilder: (context, index) {
            final document = documents[index];
            return ListTile(
              title: Text(document.description),
              onTap: () {
                //TODO: open a web view with the pagella
              },
            );
          },
        )
      ],
    );
  }
}
