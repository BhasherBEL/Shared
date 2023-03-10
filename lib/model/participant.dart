import 'package:shared/model/project.dart';

import '../db/shared_database.dart';

const String tableParticipants = 'participants';

class ParticipantFields {
  static const values = [
    id,
    pseudo,
    lastname,
    firstname,
  ];

  static const String id = '_id';
  static const String pseudo = 'pseudo';
  static const String lastname = 'lastname';
  static const String firstname = 'firstname';
}

class Participant {
  const Participant({
    this.id,
    required this.pseudo,
    this.lastname,
    this.firstname,
  });

  final int? id;
  final String pseudo;
  final String? lastname;
  final String? firstname;

  static Future<Participant> fromValues(
    String pseudo,
    String? lastname,
    String? firstname,
  ) async {
    final db = await SharedDatabase.instance.database;
    final id = await db.insert(tableParticipants, {
      ParticipantFields.pseudo: pseudo,
      ParticipantFields.lastname: lastname,
      ParticipantFields.firstname: firstname,
    });
    Participant participant =
        Participant(id: id, pseudo: pseudo, lastname: lastname);
    return participant;
  }

  Map<String, Object?> toJson() => {
        ParticipantFields.id: id,
        ParticipantFields.pseudo: pseudo,
        ParticipantFields.lastname: lastname,
        ParticipantFields.firstname: firstname,
      };

  static Participant fromJson(Map<String, Object?> json) {
    return Participant(
      id: json[ParticipantFields.id] as int?,
      pseudo: json[ParticipantFields.pseudo] as String,
      lastname: json[ParticipantFields.lastname] as String?,
      firstname: json[ParticipantFields.firstname] as String?,
    );
  }
}
