class QuestionListItem {
  final String id;
  final int questionNum;

  QuestionListItem(
      this.id,
      this.questionNum,
      );
  factory QuestionListItem.fromMap(Map<String, dynamic> json) {
    return QuestionListItem(json['_id'], json['questionNum']);
  }
  factory QuestionListItem.fromJson(Map<String, dynamic> json) {
    return QuestionListItem(json['id'], json['questionNum']);
  }
}