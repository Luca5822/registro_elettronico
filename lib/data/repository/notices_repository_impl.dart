import 'package:registro_elettronico/data/db/dao/notice_dao.dart';
import 'package:registro_elettronico/data/db/dao/profile_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/network/service/api/spaggiari_client.dart';
import 'package:registro_elettronico/data/repository/mapper/notice_mapper.dart';
import 'package:registro_elettronico/domain/repository/notices_repository.dart';

class NoticesRepositoryImpl implements NoticesRepository {
  NoticeDao noticeDao;
  ProfileDao profileDao;
  NoticeMapper noticeMapper;
  SpaggiariClient spaggiariClient;

  NoticesRepositoryImpl(
      this.noticeDao, this.profileDao, this.spaggiariClient, this.noticeMapper);

  @override
  Future updateNotices() async {
    final profile = await profileDao.getProfile();
    final response = await spaggiariClient.getNoticeBoard(profile.studentId);
    response.items.forEach((notice) {
      noticeDao
          .insertNotice(noticeMapper.convertNoticeEntityToInsertable(notice));
      notice.attachments.forEach((attachment) {
        noticeDao.insertAttachment(noticeMapper
            .convertAttachmentEntityToInsertable(notice.pubId, attachment));
      });
    });
  }

  @override
  Future deleteAllNotices() {
    return noticeDao.deleteAllNotices();
  }

  @override
  Future<List<Notice>> getAllNotices() {
    return noticeDao.getAllNotices();
  }

  @override
  Future<List<Attachment>> getAttachmentsForPubId(int pubId) {
    return noticeDao.getAttachmentsForPubId(pubId);
  }

  @override
  Future insertNotice(Notice notice) {
    return noticeDao.insertNotice(notice);
  }

  @override
  Future updateNotice(Notice notice) {
    return noticeDao.updateNotice(notice);
  }

  @override
  Future<List<int>> downloadFile(
      {String eventCode, int pubId, int attachNum}) async {
    print("REQUEST!!");
    final profile = await profileDao.getProfile();
    print("PROFIILE!!");

    final res = await spaggiariClient.readNotice(
        profile.studentId, eventCode, pubId.toString(), attachNum.toString());

    // final file = spaggiariClient.getNotice(
    //     profile.studentId, eventCode, pubId.toString(), attachNum.toString());
    print("FILE!!");
    return null;
  }
}
