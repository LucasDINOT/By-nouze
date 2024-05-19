import 'package:mysql1/mysql1.dart';

class Mysql {
  static String host = 'mysql-bynouze.alwaysdata.net',
                user = 'bynouze',
                password = 'ByLesCop.1',
                db = 'bynouze_forum';
  static int port = 3306;

  Mysql();

  Future<MySqlConnection> getConnection() async {
    var settings = ConnectionSettings(
        host: host,
        port: port,
        user: user,
        password: password,
        db: db
    );
    print(host);
    print(user);
    print(password);
    print(db);
    print(port);
    try {
      return await MySqlConnection.connect(settings);
    } catch (e) {
      print('Failed to connect to MySQL: $e');
      rethrow;
    }
  }
}
