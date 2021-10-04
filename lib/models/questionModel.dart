class Question {
  final String id;
  final String algoName;
  final bool preemption;
  final String questionText;
  final String questionImg;
  final int questionNum;
  final List<QuestionOption> questionOptions;
  final List<AnswerOption> answer;

  Question(
      {required this.id,
      required this.algoName,
      required this.preemption,
      required this.questionText,
      required this.questionImg,
      required this.questionOptions,
      required this.answer,
      required this.questionNum});

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['_id'] = this.sId;
  //   data['algoName'] = this.algoName;
  //   data['preemption'] = this.preemption;
  //   data['questionText'] = this.questionText;
  //   data['questionImg'] = this.questionImg;
  //   data['questionNum'] = this.questionNum;
  //   return data;
  // }

  factory Question.fromJson(Map<String, dynamic> json) {
    var questionOptsList = json['questionOptions'] as List;
    print(questionOptsList.runtimeType); //returns List<dynamic>
    List<QuestionOption> qOptList =
        questionOptsList.map((i) => QuestionOption.fromJson(i)).toList();
    print(qOptList);

    var ansOptsList = json['answer'] as List;
    print(ansOptsList.runtimeType); //returns List<dynamic>
    List<AnswerOption> answerOptions =
        ansOptsList.map((i) => AnswerOption.fromJson(i)).toList();
    print(answerOptions);

    return Question(
      id: json['_id'],
      algoName: json['algoName'],
      preemption: json['preemption'],
      questionText: json['questionText'],
      questionImg: json['questionImg'],
      questionNum: json['questionNum'],
      questionOptions: qOptList,
      answer: answerOptions,
    );
  }
}

class AnswerOption {
  final String id;
  final QuestionOption qRef;
  final int startTime;
  final int endTime;

  AnswerOption(
      {required this.id,
      required this.qRef,
      required this.startTime,
      required this.endTime});

  factory AnswerOption.fromJson(Map<String, dynamic> json) {
    return AnswerOption(
        id: json['_id'],
        startTime: json['startTime'],
        endTime: json['endTime'],
        qRef: QuestionOption.fromJson(json['qRef']));
  }
}

class QuestionOption {
  final String id;
  final String name;
  final int arrivalTime;
  final int burstTime;
  final String optionImage;
  int startTime = 0;
  int endTime = 0;

  QuestionOption({
    required this.id,
    required this.name,
    required this.arrivalTime,
    required this.burstTime,
    required this.optionImage,
  });

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
        id: json['_id'],
        name: json['name'],
        arrivalTime: json['arrivalTime'],
        optionImage: json['optionImage'],
        burstTime: json['burstTime']);
  }
}
