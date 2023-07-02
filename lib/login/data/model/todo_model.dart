

class TodoModel{
  String? userId;
  String? taskName;
  String? description;
  String? date;
  bool? isMark;
  String? todoId;

  TodoModel({this.userId, this.taskName, this.description, this.date, this.isMark,this.todoId});

  TodoModel.fromJson(Map<String, dynamic> json){
    taskName = json['taskName'];
    description = json['description'];
    userId = json['userId'];
    date = json['date'];
    isMark = json['isMark'];
    todoId = json['todoId'];
  }

  Map<String,dynamic> toJson() => {
    'taskName':taskName,
    'description':description,
    'userId':userId,
    'date':date,
    'isMark':isMark,
    'todoId':todoId,
  };
}