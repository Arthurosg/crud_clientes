import 'dart:convert';
import 'dart:io';
import 'package:mysql1/mysql1.dart';

void main() async {
  final conn = await MySqlConnection.connect(
    ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'root',
      password: '123456',
      db: 'crud_clientes',
    ),
  );

  final server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
  print('✅ Servidor rodando em http://localhost:8080');

  await for (HttpRequest request in server) {
    request.response.headers.add("Access-Control-Allow-Origin", "*");

    if (request.method == 'OPTIONS') {
      request.response.headers.add(
        "Access-Control-Allow-Methods",
        "POST, GET, DELETE, PUT, OPTIONS",
      );
      request.response.headers.add("Access-Control-Allow-Headers", "*");
      request.response.close();
      continue;
    }

    final path = request.uri.path;

    if (request.method == 'GET' && path == '/clientes') {
      final results = await conn.query('SELECT * FROM clientes');
      final clientes = results
          .map(
            (row) => {
              'codigo': row[0],
              'nome': row[1],
              'endereco': row[2],
              'telefone': row[3],
            },
          )
          .toList();
      request.response.write(jsonEncode(clientes));
    } else if (request.method == 'POST' && path == '/clientes') {
      final data = await utf8.decoder.bind(request).join();
      final jsonData = jsonDecode(data);
      await conn.query(
        'INSERT INTO clientes (nome, endereco, telefone) VALUES (?, ?, ?)',
        [jsonData['nome'], jsonData['endereco'], jsonData['telefone']],
      );
      request.response.write('Cliente criado com sucesso.');
    } else if (request.method == 'DELETE' && path.startsWith('/clientes/')) {
      final id = int.tryParse(path.split('/').last);
      if (id != null) {
        await conn.query('DELETE FROM clientes WHERE codigo = ?', [id]);
        request.response.write('Cliente excluído com sucesso.');
      } else {
        request.response.statusCode = HttpStatus.badRequest;
      }
    } else if (request.method == 'PUT' && path.startsWith('/clientes/')) {
      final id = int.tryParse(path.split('/').last);
      final data = await utf8.decoder.bind(request).join();
      final jsonData = jsonDecode(data);
      if (id != null) {
        await conn.query(
          'UPDATE clientes SET nome = ?, endereco = ?, telefone = ? WHERE codigo = ?',
          [jsonData['nome'], jsonData['endereco'], jsonData['telefone'], id],
        );
        request.response.write('Cliente atualizado com sucesso.');
      } else {
        request.response.statusCode = HttpStatus.badRequest;
      }
    } else {
      request.response.statusCode = HttpStatus.notFound;
      request.response.write('Endpoint não encontrado');
    }

    await request.response.close();
  }
}
