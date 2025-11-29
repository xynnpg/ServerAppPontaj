import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/professor.dart';
import 'auth_service.dart';
import 'error_service.dart';

class AdminService {
  Future<AdminListResponse> getProfessors(String token) async {
    final uri = Uri.parse('${AuthService.baseUrl}/admin/profesori');

    try {
      final response = await http.get(
        uri,
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        ErrorService().showError(
          'GET /admin/profesori - Success',
          input: 'GET /admin/profesori',
          output: 'Status: ${response.statusCode}, Count: ${data['count']}',
        );
        return AdminListResponse.fromJson(data);
      } else {
        ErrorService().showError(
          'GET /admin/profesori - Failed',
          input: 'GET /admin/profesori',
          output: 'Status: ${response.statusCode}, Body: ${response.body}',
        );
        throw Exception(
          'Failed to load professors: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      if (!e.toString().contains('401')) {
        ErrorService().showError('Error fetching professors: $e');
      }
      throw Exception('Error fetching professors: $e');
    }
  }

  Future<Professor> addProfessor(
    String token,
    String name,
    String email,
    String password,
  ) async {
    final uri = Uri.parse('${AuthService.baseUrl}/admin/profesori');
    try {
      final response = await http.post(
        uri,
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'nume': name, 'email': email, 'password': password}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Professor.fromJson(data);
      } else {
        throw Exception(
          'Failed to add professor: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      ErrorService().showError('Error adding professor: $e');
      throw Exception('Error adding professor: $e');
    }
  }

  Future<void> deleteProfessor(String token, int id) async {
    final uri = Uri.parse('${AuthService.baseUrl}/admin/profesori/$id');
    try {
      final response = await http.delete(
        uri,
        headers: {'accept': '*/*', 'Authorization': 'Bearer $token'},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return;
      } else {
        throw Exception(
          'Failed to delete professor: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      ErrorService().showError('Error deleting professor: $e');
      throw Exception('Error deleting professor: $e');
    }
  }

  Future<void> updateProfessor(
    String token,
    int id,
    String name,
    String email,
    String password,
  ) async {
    final uri = Uri.parse('${AuthService.baseUrl}/admin/profesori/$id');
    try {
      final Map<String, dynamic> body = {'nume': name, 'email': email};

      if (password.isNotEmpty) {
        body['password'] = password;
      }

      final response = await http.put(
        uri,
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return;
      } else {
        try {
          final Map<String, dynamic> errorData = jsonDecode(response.body);
          if (errorData.containsKey('detail')) {
            throw Exception(
              'Validation error: ${jsonEncode(errorData['detail'])}',
            );
          }
        } catch (_) {}
        throw Exception(
          'Failed to update professor: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      ErrorService().showError('Error updating professor: $e');
      throw Exception('$e');
    }
  }
}
