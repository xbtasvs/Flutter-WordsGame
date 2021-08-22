class WordModel {
  final String fact;
  final String letter;

  WordModel({
    required this.fact,
    required this.letter,
  });

  Map<String, dynamic> toMap() {
    return {
      'facts': fact,
      'letters': letter,
    };
  }

  // Implement toString to make it easier to see information about
  // each user when using the print statement.
  @override
  String toString() => 'word{fact: $fact, letter: $letter}';
}
