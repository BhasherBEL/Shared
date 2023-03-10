import 'package:shared/db/shared_database.dart';
import 'package:shared/model/item.dart';

const String tableProjects = 'projects';

class ProjectFields {
  static const values = [
    id,
    name,
  ];

  static const String id = '_id';
  static const String name = 'name';
}

class Project {
  const Project({
    required this.id,
    required this.name,
  });

  static List<Project> projects = [];
  static Project? current;

  final int id;
  final String name;

  Map<String, Object?> toJson() => {
        ProjectFields.id: id,
        ProjectFields.name: name,
      };

  static Project fromJson(Map<String, Object?> json) {
    return Project(
      id: json[ProjectFields.id] as int,
      name: json[ProjectFields.name] as String,
    );
  }

  static Future<Project> fromValues(String name) async {
    final db = await SharedDatabase.instance.database;
    final id = await db.insert(tableProjects, {ProjectFields.name: name});
    Project project = Project(id: id, name: name);
    projects.add(project);
    return project;
  }

  static Future<Project?> fromId(int id) async {
    final db = await SharedDatabase.instance.database;
    final projects = await db.query(
      tableProjects,
      columns: ProjectFields.values,
      where: '${ProjectFields.id} = ?',
      whereArgs: [id],
    );

    if (projects.isNotEmpty) return Project.fromJson(projects.first);
    return null;
  }

  static Future<List<Project>> getAllProjects() async {
    final db = await SharedDatabase.instance.database;
    final projects = await db.query(
      tableProjects,
      columns: ProjectFields.values,
    );

    return projects.map((e) => Project.fromJson(e)).toList();
  }

  Future<bool> delete() async {
    final db = await SharedDatabase.instance.database;
    bool res = await db.delete(
          tableProjects,
          where: '${ProjectFields.id} = ?',
          whereArgs: [id],
        ) >
        0;
    if (res) projects.remove(this);
    return res;
  }

  Future<List<Item>> getItems() async {
    final db = await SharedDatabase.instance.database;
    final rawItems = await db.query(
      tableItems,
      where: '${ItemFields.project} = ?',
      whereArgs: [id],
    );

    return rawItems.map((e) => Item.fromJson(e)).toList();
  }

  // Future<List<Map<String, Object?>>> getItemsForList() async {
  //   final db = await SharedDatabase.instance.database;
  //   return await db.rawQuery(
  //     '''SELECT
  //         i.id,
  //         i.title,
  //         pai.pseudo AS emitter,
  //         SUM(ip.amount) AS amount,
  //         SUM(CASE WHEN ip.participant = 1 THEN ip.amount ELSE 0 END) AS participant_amount,
  //         GROUP_CONCAT(pa.pseudo, ', ') AS participants
  //     FROM items i
  //     JOIN participants pai on pai.id = i.emitter
  //     JOIN itemsParts ip on i.id = ip.item
  //     JOIN participants pa on pa.id = ip.participant
  //     WHERE i.project = ?
  //     GROUP BY i.id; ''',
  //     [id],
  //   );
  // }
}
