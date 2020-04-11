class NewSimulationModel {
  String studyProgramName, educationStageName, currentAccreditation;
  List<dynamic> jumlahLulusan;

  NewSimulationModel({
    this.studyProgramName,
    this.educationStageName,
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
}
