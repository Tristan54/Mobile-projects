import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String tableParam = 'param';
final String columnId = '_id';
final String columnKey = 'key';
final String columnValue = 'value';

// classe paramètre
class Param {
  int id;
  String key;
  String value;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnKey: key,
      columnValue: value,
    };

    if (id != null) map[columnId] = id;

    return map;
  }

  Param({this.id, this.key, this.value});

  Param.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    key = map[columnKey];
    value = map[columnValue];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Param && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class ParamProvider {
  Database db;

  Future open() async {
    if (db == null || !db.isOpen) {
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'param.bd');

      db = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        await db.execute('''
create table $tableParam ( 
  $columnId integer primary key autoincrement, 
  $columnKey text not null,
  $columnValue text not null)
''');
      });
    }
  }

  Future<Param> insert(Param param) async {
    param.id = await db.insert(tableParam, param.toMap());
    return param;
  }

  Future<Param> getParam(int id) async {
    List<Map> maps = await db.query(tableParam,
        columns: [columnId, columnKey, columnValue],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Param.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableParam, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> drop() async {
    await db.execute('delete from $tableParam');
  }

  Future<int> update(Param param) async {
    return await db.update(tableParam, param.toMap(),
        where: '$columnId = ?', whereArgs: [param.id]);
  }

  Future close() async => db.close();
}
