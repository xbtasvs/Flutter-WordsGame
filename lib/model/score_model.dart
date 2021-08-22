class ScoreModel {
  final int userId;
  final String userName;
  final int score;

  ScoreModel({
    required this.userId,
    required this.userName,
    required this.score,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'score': score,
    };
  }

  // Implement toString to make it easier to see information about
  // each user when using the print statement.
  @override
  String toString() => 'Score{id: $userId, userName: $userName, name: $score}';
}
