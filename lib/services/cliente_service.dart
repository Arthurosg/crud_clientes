import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cliente.dart';

class ClienteService {
  static const String baseUrl = 'http://localhost:8000/api';

  static Future<List<Cliente>> getClientes() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/read'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Cliente.fromJson(json)).toList();
      } else {
        print('Erro HTTP: ${response.statusCode}');
        print('Resposta: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Erro ao buscar clientes: $e');
      return [];
    }
  }

  static Future<bool> createCliente(Cliente cliente) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(cliente.toJson()),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        return result['success'] ?? false;
      }
      return false;
    } catch (e) {
      print('Erro ao criar cliente: $e');
      return false;
    }
  }

  static Future<bool> updateCliente(Cliente cliente) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/update'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(cliente.toJson()),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        return result['success'] ?? false;
      }
      return false;
    } catch (e) {
      print('Erro ao atualizar cliente: $e');
      return false;
    }
  }

  static Future<bool> deleteCliente(int codigo) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/delete'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'codigo': codigo}),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        return result['success'] ?? false;
      }
      return false;
    } catch (e) {
      print('Erro ao deletar cliente: $e');
      return false;
    }
  }
}
