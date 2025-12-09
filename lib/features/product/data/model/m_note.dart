import 'dart:convert';

List<MNote> mNoteFromJson(String str) => List<MNote>.from(json.decode(str).map((x) => MNote.fromJson(x)));

String mNoteToJson(List<MNote> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MNote {
    final int? userId;
    final int? id;
    final String? title;
    final String? body;

    MNote({
        this.userId,
        this.id,
        this.title,
        this.body,
    });

    factory MNote.fromJson(Map<String, dynamic> json) => MNote(
        userId: json["userId"],
        id: json["id"],
        title: json["title"],
        body: json["body"],
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "title": title,
        "body": body,
    };
}
