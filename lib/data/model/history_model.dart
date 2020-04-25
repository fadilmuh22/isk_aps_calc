import 'dart:convert';

class HistoryModel {
  int id, educationStage;
  String institute,
      studyProgram,
      educationStageName,
      currentAccreditation,
      result,
      userId,
      updateDateTime;
  Map request, response;
  Map variables;
  dynamic resultDetail;
  dynamic indicatorDetail;

  HistoryModel({
    this.id,
    this.userId,
    this.institute,
    this.studyProgram,
    this.educationStage,
    this.educationStageName,
    this.currentAccreditation,
    this.indicatorDetail,
    this.variables,
    this.result,
    this.resultDetail,
    this.updateDateTime,
  });

  HistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['history_id'];

    request = jsonDecode(json['history_request']);
    institute = request['institute'];
    educationStage = request['education_stage'];
    educationStageName = request['education_stage_name'];
    currentAccreditation = request['current_accreditation'];
    studyProgram = request['study_program'];
    variables = request['variables'];
    indicatorDetail = jsonDecode(request['request_detail']);

    response = jsonDecode(json['history_response']);
    result = response['result'];
    resultDetail = jsonDecode(response['result_detail']);

    userId = json['user_id'].toString();
    updateDateTime = json['update_dtm'];
  }

  Map<String, dynamic> toJson() {
    String historyRequest = jsonEncode({
      'institute': institute,
      'education_stage': educationStage,
      'education_stage_name': educationStageName,
      'current_accreditation': currentAccreditation,
      'study_program': studyProgram,
      'variables': variables,
      'request_detail': indicatorDetail,
    });
    String historyResponse = jsonEncode({
      'result': result,
      'result_detail': resultDetail,
    });
    return {
      'history_id': id,
      'history_request': historyRequest,
      'history_response': historyResponse,
      'user_id': userId,
      'update_dtm': updateDateTime,
    };
  }
}
