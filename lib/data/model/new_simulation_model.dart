class NewSimulationModel {
  int educationStage;
  String studyProgramName, educationStageName, currentAccreditation;
  List<dynamic> jumlahLulusan;

  NewSimulationModel({
    this.educationStage,
    this.educationStageName,
    this.studyProgramName,
    this.currentAccreditation,
  });

  NewSimulationModel.fromJson(Map<String, dynamic> json) {
    studyProgramName = json['study_program_name'];
    currentAccreditation = json['current_accreditation'];
    educationStageName = json['education_stage_name'];
  }

  Map<String, dynamic> toJson() => {
        'study_program_name': studyProgramName,
        'current_accreditation': currentAccreditation,
        'education_stage_name': educationStageName,
      };
}
