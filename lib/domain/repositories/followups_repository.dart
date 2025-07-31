abstract class FollowupsRepository {
  Future<bool> addFollowUp({
    required String followupsType,
    required String followupsDate,
    required String followupsTime,
    required String note,
    int? status,
    int? leadId,
  });

  // changing followup status
  Future<bool> changeFollowupStatus({
    required int id,
    required int status,
    required String remarks,
  });
}
