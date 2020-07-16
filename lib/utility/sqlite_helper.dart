import 'package:onerc/models/sqlite_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteHelper {
  final String nameDatabase = 'onerc.db';
  final String nameTable = 'orderTable';
  int version = 1;
  final String column_id = 'id';
  final String column_idShop = 'idShop';
  final String column_nameShop = 'nameShop';
  final String column_idProduct = 'idProduct';
  final String column_nameProduct = 'nameProduct';
  final String column_price = 'price';
  final String column_amountString = 'amountString';
  final String column_sumString = 'sumString';

  SQLiteHelper() {
    initDatabase();
  }

  Future<Null> initDatabase() async {
    await openDatabase(
      join(await getDatabasesPath(), nameDatabase),
      onCreate: (db, version) => db.execute(
          'CREATE TABLE $nameTable ($column_id INTEGER PRIMARY KEY, $column_idShop TEXT, $column_nameShop TEXT, $column_idProduct TEXT, $column_nameProduct TEXT, $column_price TEXT, $column_amountString TEXT, $column_sumString TEXT)'),
      version: version,
    );
  }

  Future<Database> connectedDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), nameDatabase));
  }

  Future<Null> insertDataToSQLite(SqliteModel sqliteModel) async {
    Database database = await connectedDatabase();
    try {
      database
          .insert(
        nameTable,
        sqliteModel.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace, // แบบเขียนทับได้
      )
          .then((value) {
        print('insert success');
      });
    } catch (e) {
      print('e insert data = ${e.toString()}');
    }
  }

  Future<List<SqliteModel>> readDataFromSQLite() async {
    Database database = await connectedDatabase();
    List<SqliteModel> sqliteModels = List();
    List<Map<String, dynamic>> listMaps = await database.query(nameTable);
    for (var map in listMaps) {
      SqliteModel model = SqliteModel.fromJson(map);
      sqliteModels.add(model);
    }
    return sqliteModels;
  }

  Future<Null> deleteDataWhereId(int idProduct) async {
    Database database = await connectedDatabase();
    try {
      await database.delete(nameTable, where: '$column_id = $idProduct');
    } catch (e) {
      print('e delete = ${e.toString()}');
    }
  }

  Future<Null> clearData() async {
    Database database = await connectedDatabase();
    try {
      await database.delete(nameTable);
    } catch (e) {
      print('e clear = ${e.toString()}');
    }
  }
}
