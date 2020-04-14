class NewSimulationModel {
  int educationStage;
  String studyProgramName, educationStageName, currentAccreditation;
  List<dynamic> jumlahLulusan;

  NewSimulationModel({
    this.educationStage,
    this.educationStageName,
    this.studyProgramName,
    this.jumlahLulusan,
  });

  NewSimulationModel.fromJson(Map<String, dynamic> json) {
    studyProgramName = json['study_program_name'];
    currentAccreditation = json['current_accreditation'];
    educationStageName = json['education_stage_name'];
    jumlahLulusan = json['jumlah_lulusan'];
  }

  Map<String, dynamic> toJson() => {
        'study_program_name': studyProgramName,
        'current_accreditaion': currentAccreditation,
        'education_stage_name': educationStageName,
        'jumlah_lulusan': jumlahLulusan,
      };

  Map<String, dynamic> getJumlahLulusan() {
    Map<String, int> map = {};

    for (var i = 0; i < jumlahLulusan.length; i++) {
      if (jumlahLulusan[i].value != null && jumlahLulusan[i].value.isNotEmpty) {
        int sum = jumlahLulusan[i].value.reduce((a, b) {
          if (a != null && b != null) {
            return a + b;
          }
        });
        map[jumlahLulusan[i].variable] = sum;
      }
    }
    return map;
  }
}
