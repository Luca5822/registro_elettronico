// ignore_for_file: always_declare_return_types

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:registro_elettronico/feature/absences/domain/model/absences_response.dart';
import 'package:registro_elettronico/feature/didactics/data/model/didactics_remote_models.dart';
import 'package:registro_elettronico/feature/login/data/model/login_request_model.dart';
import 'package:registro_elettronico/feature/login/data/model/login_response_remote_model.dart';
import 'package:registro_elettronico/feature/login/data/model/parent_response_remote_model.dart';
import 'package:registro_elettronico/feature/notes/data/model/remote/note_remote_model.dart';
import 'package:registro_elettronico/feature/notes/data/model/remote/notes_read_remote_model.dart';
import 'package:registro_elettronico/feature/scrutini/data/model/document_remote_model.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

// part 'spaggiari_client.g.dart';

// This is written 'strangely' beacuse I used Retrofit to generate the calls but then
// for feature reasons I had to manually write the http calls
abstract class SpaggiariClient {
  factory SpaggiariClient(Dio dio) = _SpaggiariClient;

  /// Log in path
  @POST("/auth/login")
  Future<Either<LoginResponse, ParentsLoginResponse>> loginUser(
      @Body() LoginRequest loginRequest);

  // // Subjects
  // @GET("/students/{studentId}/subjects")
  // Future<SubjectsResponse> getSubjects(@Path() String studentId);

  // Subjects
  // @GET("/students/{studentId}/grades")
  // Future<GradesResponse> getGrades(@Path() String studentId);

  // Absences
  @GET("/students/{studentId}/absences/details")
  Future<AbsencesRemoteModel> getAbsences(@Path() String studentId);

  // Absences
  // @GET("/students/{studentId}/periods")
  // Future<PeriodsResponse> getPeriods(@Path() String studentId);

  @GET("/students/{studentId}/notes/all/")
  Future<NotesResponse> getNotes(@Path() String studentId);

  @POST("/students/{studentId}/notes/{type}/read/{layout_note}")
  Future<NotesReadResponse> markNote(
    @Path('studentId') String studentId,
    @Path("type") String type,
    @Path("layout_note") int note,
    @Body() String body,
  );

  @GET("/students/{studentId}/didactics")
  Future<DidacticsResponse> getDidactics(@Path() String studentId);

  @GET("/students/{studentId}/didactics/item/{fileId}")
  Future<DownloadAttachmentURLResponse> getAttachmentUrl(
      @Path() String studentId, @Path("fileId") int fileId);

  @GET("/students/{studentId}/didactics/item/{fileId}")
  Future<DownloadAttachmentTextResponse> getAttachmentText(
      @Path() String studentId, @Path("fileId") int fileId);

  @POST('/students/{studentId}/documents')
  Future<DocumentsResponse> getDocuments(@Path() String studentId);

  @POST('/students/{studentId}/documents/check/{documentHash}')
  Future<bool> checkDocumentAvailability(
    @Path() String studentId,
    @Path() String documentHash,
  );

  @POST('/students/{studentId}/documents/check/{documentHash}')
  Future<Tuple2<List<int>, String>> readDocument(
    @Path() String studentId,
    @Path() String documentHash,
  );
}

class _SpaggiariClient implements SpaggiariClient {
  _SpaggiariClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    this.baseUrl ??= 'https://web.spaggiari.eu/rest/v1';
  }

  final Dio _dio;

  String baseUrl;

  @override
  loginUser(loginRequest) async {
    ArgumentError.checkNotNull(loginRequest, 'loginRequest');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(loginRequest.toJson() ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/auth/login',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);

    if (_result.statusCode == 200 &&
        _result.data.containsKey('requestedAction')) {
      return Right(ParentsLoginResponse.fromJson(_result.data));
    }

    return Left(LoginResponse.fromJson(_result.data));

    //return Future.value(value);
  }

  @override
  getAbsences(studentId) async {
    ArgumentError.checkNotNull(studentId, 'studentId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/students/$studentId/absences/details',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = AbsencesRemoteModel.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getNotes(studentId) async {
    ArgumentError.checkNotNull(studentId, 'studentId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/students/$studentId/notes/all/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = NotesResponse.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  markNote(studentId, type, note, body) async {
    ArgumentError.checkNotNull(studentId, 'studentId');
    ArgumentError.checkNotNull(type, 'type');
    ArgumentError.checkNotNull(note, 'note');
    ArgumentError.checkNotNull(body, 'body');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = body;
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/students/$studentId/notes/$type/read/$note',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = NotesReadResponse.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getDidactics(studentId) async {
    ArgumentError.checkNotNull(studentId, 'studentId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/students/$studentId/didactics',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = DidacticsResponse.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getAttachmentUrl(studentId, fileId) async {
    ArgumentError.checkNotNull(studentId, 'studentId');
    ArgumentError.checkNotNull(fileId, 'fileId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/students/$studentId/didactics/item/$fileId',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);

    print(_result);
    final value = DownloadAttachmentURLResponse.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getAttachmentText(studentId, fileId) async {
    ArgumentError.checkNotNull(studentId, 'studentId');
    ArgumentError.checkNotNull(fileId, 'fileId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/students/$studentId/didactics/item/$fileId',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = DownloadAttachmentTextResponse.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  Future<DocumentsResponse> getDocuments(String studentId) async {
    ArgumentError.checkNotNull(studentId, 'studentId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = '';
    final Response<Map<String, dynamic>> _result = await _dio.request(
      '/students/$studentId/documents',
      queryParameters: queryParameters,
      options: RequestOptions(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
          baseUrl: baseUrl),
      data: _data,
    );
    final value = DocumentsResponse.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  Future<bool> checkDocumentAvailability(
      String studentId, String documentHash) async {
    ArgumentError.checkNotNull(studentId, 'studentId');
    ArgumentError.checkNotNull(documentHash, 'documentHash');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = '';
    final Response<Map<String, dynamic>> _result = await _dio.request(
      '/students/$studentId/documents/check/$documentHash',
      queryParameters: queryParameters,
      options: RequestOptions(
        method: 'POST',
        headers: <String, dynamic>{},
        extra: _extra,
        baseUrl: baseUrl,
      ),
      data: _data,
    );

    final bool avaliable = _result.data['document']['available'];
    return Future.value(avaliable);
  }

  @override
  Future<Tuple2<List<int>, String>> readDocument(
    String studentId,
    String documentHash,
  ) async {
    ArgumentError.checkNotNull(studentId, 'studentId');
    ArgumentError.checkNotNull(documentHash, 'documentHash');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = '';
    final Response<List<dynamic>> _result = await _dio.request(
      '/students/$studentId/documents/read/$documentHash',
      queryParameters: queryParameters,
      options: RequestOptions(
        method: 'POST',
        headers: <String, dynamic>{},
        extra: _extra,
        baseUrl: baseUrl,
        responseType: ResponseType.bytes,
      ),
      data: _data,
    );
    final bytes = _result.data.cast<int>();

    String filename = _result.headers.value('content-disposition');

    return Tuple2(bytes, filename);
  }
}
