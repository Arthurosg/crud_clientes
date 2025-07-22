import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:mysql1/mysql1.dart';

class ClienteServer {
  late MySqlConnection connection;

  Future<void> init() async {
    // Conectar ao MariaDB
    final settings = ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'root',
      password: '123456',
      db: 'crud_flutter',
    );

    try {
      connection = await MySqlConnection.connect(settings);
      print('✅ Conectado ao MariaDB!');
    } catch (e) {
      print('❌ Erro ao conectar: $e');
      exit(1);
    }
  }

  Router get router {
    final router = Router();

    // READ - Listar clientes
    router.get('/api/read', (Request request) async {
      try {
        final results = await connection.query(
          'SELECT codigo, nome, endereco, telefone FROM clientes ORDER BY codigo',
        );

        final clientes = results
            .map(
              (row) => {
                'codigo': row['codigo'],
                'nome': row['nome'],
                'endereco': row['endereco'],
                'telefone': row['telefone'],
              },
            )
            .toList();

        return Response.ok(
          json.encode(clientes),
          headers: {'Content-Type': 'application/json'},
        );
      } catch (e) {
        return Response.internalServerError(
          body: json.encode({'error': e.toString()}),
        );
      }
    });

    // CREATE - Criar cliente
    router.post('/api/create', (Request request) async {
      try {
        final body = await request.readAsString();
        print('📝 Dados recebidos: $body'); // Debug
        final data = json.decode(body);

        if (data['nome'] == null ||
            data['endereco'] == null ||
            data['telefone'] == null) {
          return Response.badRequest(
            body: json.encode({'success': false, 'error': 'Dados incompletos'}),
          );
        }

        print('🔄 Inserindo no banco...'); // Debug
        final result = await connection.query(
          'INSERT INTO clientes (nome, endereco, telefone) VALUES (?, ?, ?)',
          [data['nome'], data['endereco'], data['telefone']],
        );

        print('✅ Cliente criado com ID: ${result.insertId}'); // Debug
        return Response.ok(
          json.encode({
            'success': true,
            'codigo': result.insertId,
            'message': 'Cliente criado com sucesso',
          }),
        );
      } catch (e) {
        print('❌ Erro detalhado: $e'); // Debug melhorado
        return Response.internalServerError(
          body: json.encode({'success': false, 'error': e.toString()}),
        );
      }
    });

    // UPDATE - Atualizar cliente
    router.post('/api/update', (Request request) async {
      try {
        final body = await request.readAsString();
        final data = json.decode(body);

        if (data['codigo'] == null ||
            data['nome'] == null ||
            data['endereco'] == null ||
            data['telefone'] == null) {
          return Response.badRequest(
            body: json.encode({'success': false, 'error': 'Dados incompletos'}),
          );
        }

        await connection.query(
          'UPDATE clientes SET nome=?, endereco=?, telefone=? WHERE codigo=?',
          [data['nome'], data['endereco'], data['telefone'], data['codigo']],
        );

        return Response.ok(
          json.encode({
            'success': true,
            'message': 'Cliente atualizado com sucesso',
          }),
        );
      } catch (e) {
        return Response.internalServerError(
          body: json.encode({'success': false, 'error': e.toString()}),
        );
      }
    });

    // DELETE - Deletar cliente
    router.post('/api/delete', (Request request) async {
      try {
        final body = await request.readAsString();
        final data = json.decode(body);

        if (data['codigo'] == null) {
          return Response.badRequest(
            body: json.encode({
              'success': false,
              'error': 'Código não informado',
            }),
          );
        }

        await connection.query('DELETE FROM clientes WHERE codigo=?', [
          data['codigo'],
        ]);

        return Response.ok(
          json.encode({
            'success': true,
            'message': 'Cliente deletado com sucesso',
          }),
        );
      } catch (e) {
        return Response.internalServerError(
          body: json.encode({'success': false, 'error': e.toString()}),
        );
      }
    });

    return router;
  }
}

void main() async {
  final server = ClienteServer();
  await server.init();

  final handler = Pipeline()
      .addMiddleware(corsHeaders())
      .addMiddleware(logRequests())
      .addHandler(server.router.call);

  final httpServer = await serve(handler, 'localhost', 8000);
  print('🚀 Servidor Dart rodando em http://localhost:8000');
}
