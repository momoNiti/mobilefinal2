import 'dart:async';
import 'package:sqflite/sqflite.dart';

final String tableAccount = 'account';
final String columnId = 'id';
final String columnUserName = 'userName';
final String columnName = 'name';
final String columnAge = 'age';
final String columnPassword = 'password';

class Account {
  int id;
  String userName;
  String name;
  int age;
  String password;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnUserName: this.userName,
      columnName: this.name,
      columnAge: this.age,
      columnPassword: this.password,
    };
    if (this.id != null) {
      map[columnId] = this.id;
    }
    return map;
  }

  Account({int id, String userName, String name, int age, String password}){
    this.id = id;
    this.userName = userName;
    this.name = name;
    this.age = age;
    this.password = password;
  }

  Account.fromMap(Map<String, dynamic> map) {
    this.id = map[columnId];
    this.userName = map[columnUserName];
    this.name = map[columnName];
    this.age = map[columnAge];
    this.password = map[columnPassword];
  }
}

class AccountProvider {
  Database db;

  Future open(String path) async {
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $tableAccount (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnUserName TEXT NOT NULL,
            $columnName TEXT NOT NULL,
            $columnAge INTEGER NOT NULL,
            $columnPassword TEXT NOT NULL
          );
        ''');
      },
    );
  }

  Future<Account> insert(Account account) async {
    account.id = await db.insert(
          tableAccount,
          account.toMap(),
        );

    return account;
  }

  Future<Account> getAccount(int id) async {
    List<Map> maps = await db.query(
          tableAccount,
          columns: [
            columnId,
            columnUserName,
            columnName,
            columnAge,
            columnPassword
          ],
          where: '$columnId = ?',
          whereArgs: [id],
        );

    if (maps.length > 0) {
      return Account.fromMap(maps.first);
    }

    return null;
  }

  Future<Account> getAccountByUserId(String userId) async {
    List<Map> maps = await db.query(
          tableAccount,
          columns: [
            columnId,
            columnUserName,
            columnName,
            columnAge,
            columnPassword
          ],
          where: '$columnUserName = ?',
          whereArgs: [userId],
        );

    if (maps.length > 0) {
      return Account.fromMap(maps.first);
    }

    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(
      tableAccount,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteByUserId(String userId) async {
    return await db.delete(
      tableAccount,
      where: '$columnId = ?',
      whereArgs: [userId],
    );
  }

  Future<void> update(Account account) async {
    await db.update(
      tableAccount,
      account.toMap(),
      where: '$columnId = ?',
      whereArgs: [account.id],
    );
  }

  Future close() async {
    db.close();
  }
}
