class Word {
  final String word;
  List<String> meaning;
  List<String> example;
  final String tries; // is a number if fetched
  final String index;
  final String id;

  Word(
      {this.word, this.meaning, this.example, this.tries, this.index, this.id});

  @override
  String toString() {
    return 'Word{word: $word, definition: $meaning, example: $example, tries: $tries, index: $index, id: $id}';
  }

  factory Word.fromJson(Map<String, dynamic> json) {
    List meaningList = (json['meaning'] as List<dynamic>).cast<String>();
    List exampleList = (json['example'] as List<dynamic>).cast<String>();

    return Word(
        word: json['word'],
        meaning: meaningList,
        example: exampleList,
        tries: json['tries']
            .toString(), //db is returning an int, app wants a string
        index: json['index'],
        id: json['_id']);
  }
}
