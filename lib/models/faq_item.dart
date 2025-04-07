class FrequentlyAskedQuestion {
  final int id;
  final String question;
  final String answer;

  const FrequentlyAskedQuestion({
    required this.id,
    required this.question,
    required this.answer,
  });

  @override
  String toString() {
    return 'FaqItem{id: $id, question: $question, answer: $answer}';
  }

  factory FrequentlyAskedQuestion.fromJson(Map<String, dynamic> json) {
    return FrequentlyAskedQuestion(
      id: json['id'] as int,
      question: json['question'] as String,
      answer: json['answer'] as String,
    );
  }
}
