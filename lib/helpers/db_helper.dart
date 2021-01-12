import 'dart:io';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';
import 'package:udemy_native_device_feature/models/place.dart'; //이거 없으면, ConflictAlgorithm 에러남

class DBHelper {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'places.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT)');
    }, version: 1);
    //그냥 dbPath가 아닌 path.join(dbPath, 'places.db').
    //dbpath는 폴더 경로일 뿐이고, join으로 DB파일을 만들어줘야한다!
    //JOIN 반환값String이 있는거 보니까, 파일이 없으면 만든 후에 해당 파일경로를 반환하나보네~
    // ㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴ 아님, 파일이 없으면 만드는건 그 다음 onCreate!!!!!!!!!!!!!!!!!!!!!
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //그냥 dbPath가 아닌 path.join(dbPath, 'places.db').
  //dbpath는 폴더 경로일 뿐이고, join으로 DB파일을 만들어줘야한다!
  //JOIN 반환값String이 있는거 보니까, 파일이 없으면 만든 후에 해당 파일경로를 반환하나보네~
  // ㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴ 아님, 파일이 없으면 만드는건 그 다음 onCreate!!!!!!!!!!!!!!!!!!!!!

  //강의와는 다르게, Map -> Place 변환을 요기서 했음.
  static Future<List<Place>> getData(String table) async {
    final db = await DBHelper.database();
    final result = await db.query(table);
    return result
        .map(
          (item) => Place(
            id: item['id'],
            title: item['title'],
            image: File(item['image']),
            location: null,
          ),
        )
        .toList();
  }
}
