class HistoryModel {
  int id;
  String request, response;

  HistoryModel({
    this.id,
    this.request,
    this.response,
  });

  HistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['history_id'];
    request = json['history_request'];
    response = json['history_response'];
  }

  Map<String, dynamic> toJson() => {
        'history_id': id,
        'history_request': request,
        'history_response': response,
      };
}
