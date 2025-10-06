class AnswerOption {
  late final int? id;
  late final String? option;
  late final String? optionImage;

  AnswerOption({this.id, this.option, this.optionImage});

  AnswerOption.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    option = json['option'];
    optionImage = json['option_image'];
  }
}
