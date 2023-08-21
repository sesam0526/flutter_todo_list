class Task {
  int id;
  String work;
  bool isComplete;

  Task(
      {required this.id,
      required this.work,
      required this.isComplete}); // 반드시 id, work, isComplete가 필요함

  Map<String, dynamic> toJson() => {
        'id': id,
        'work': work,
        'isComplete': isComplete
      }; // json : 중괄호로 싸여진 데이터, key를 통해 value 호출 가능 ex) { key:value }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
        id: json['id'], work: json['work'], isComplete: json['isComplete']);
  }
}
