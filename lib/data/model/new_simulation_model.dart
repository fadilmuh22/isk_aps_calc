class NewSimulationModel {
  int educationStage;
  String studyProgramName,
      educationStageName,
      currentAccreditation,
      academicYear;
  List<dynamic> jumlahLulusan;

  NewSimulationModel({
    this.educationStage,
    this.educationStageName,
    this.studyProgramName,
    this.currentAccreditation,
    this.academicYear,
  });

  NewSimulationModel.fromJson(Map<String, dynamic> json) {
    studyProgramName = json['study_program_name'];
    currentAccreditation = json['current_accreditation'];
    educationStageName = json['education_stage_name'];
    academicYear = json['academic_year'];
  }

  Map<String, dynamic> toJson() => {
        'study_program_name': studyProgramName,
        'current_accreditation': currentAccreditation,
        'education_stage_name': educationStageName,
        'academic_year': academicYear,
      };
}
