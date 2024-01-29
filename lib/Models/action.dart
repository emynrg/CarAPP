// lib/Models/action.dart

class Action {
  final String message;
// Liste des actionPerforms, nullable

  Action({
    required this.message,});

  factory Action.fromJson(Map<String, dynamic> json) {
    return Action(
      message : json['message'] as String,
     
    );
  }
}
