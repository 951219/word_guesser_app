class Word {
  final String word;
  List<String> meaning;
  List<String> example;
  final int wordId;

  Word({this.word, this.meaning, this.example, this.wordId});

  @override
  String toString() {
    return 'Word{word: $word, definition: $meaning, example: $example, id: $wordId}';
  }

  factory Word.fromJson(Map<String, dynamic> json) {
    List meaningList = (json['meaning'] as List<dynamic>).cast<String>();
    List exampleList = (json['example'] as List<dynamic>).cast<String>();

    return Word(
        word: json['word'],
        meaning: meaningList,
        example: exampleList,
        wordId: json['wordId']);
  }
}
