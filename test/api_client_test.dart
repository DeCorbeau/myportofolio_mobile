import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/config.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

const _baseUrl = 'http://test';
const _experienceId = '11111111-1111-4111-8111-111111111111';

/// A JSON object shaped like the DRF ExperienceSerializer output.
Map<String, dynamic> _experienceJson({String? endedAt}) => {
  'id': _experienceId,
  'title': 'Event Intern',
  'organization': 'RISTEK',
  'description': 'Line one\nLine two',
  'category': 'internship',
  'category_display': 'Internship',
  'thumbnail': null,
  'thumbnail_image': null,
  'thumbnail_url': '/media/experience_thumbnails/a.png',
  'started_at': '2026-05-01',
  'ended_at': endedAt,
  'is_ongoing': endedAt == null,
  'date_range_display': 'May 2026 - Present',
  'description_points': ['Line one', 'Line two'],
  'like_count': 2,
  'is_liked': false,
  'liked_by_names': 'a, b',
};

http.Response _json(Object body, int status) => http.Response(
  jsonEncode(body),
  status,
  headers: {'content-type': 'application/json; charset=utf-8'},
);

ApiClient _clientWith(Future<http.Response> Function(http.Request) handler) {
  return ApiClient(client: MockClient(handler), baseUrl: _baseUrl);
}

Matcher _apiException(int statusCode) => throwsA(
  isA<ApiException>().having((e) => e.statusCode, 'statusCode', statusCode),
);

void main() {
  group('getExperiences', () {
    test('maps snake_case JSON to the model', () async {
      late http.Request captured;
      final api = _clientWith((request) async {
        captured = request;
        return _json([_experienceJson()], 200);
      });

      final experiences = await api.getExperiences();

      expect(captured.method, 'GET');
      expect(captured.url.path, '/api/v1/experiences/');
      expect(captured.headers.containsKey('Authorization'), isFalse);
      expect(experiences, hasLength(1));
      final experience = experiences.single;
      expect(experience.id, _experienceId);
      expect(experience.startedAt, '2026-05-01');
      expect(experience.isOngoing, isTrue);
      expect(experience.descriptionPoints, ['Line one', 'Line two']);
      // Relative media paths are resolved against the configured base URL.
      expect(
        experience.thumbnailAbsoluteUrl,
        '$apiBaseUrl/media/experience_thumbnails/a.png',
      );
    });

    test('throws ApiException on a non-2xx response', () async {
      final api = _clientWith((request) async => _json({'detail': 'x'}, 500));

      await expectLater(api.getExperiences(), _apiException(500));
    });
  });

  group('createExperience', () {
    const draft = Experience(
      title: 'Event Intern',
      description: 'Line one',
      category: 'internship',
      startedAt: '2026-05-01',
    );

    test('sends the token and omits server-set and null fields', () async {
      late http.Request captured;
      final api = _clientWith((request) async {
        captured = request;
        return _json(_experienceJson(), 201);
      });

      final created = await api.createExperience(draft, token: 'abc123');

      expect(captured.method, 'POST');
      expect(captured.url.path, '/api/v1/experiences/');
      expect(captured.headers['Authorization'], 'Token abc123');
      final body = jsonDecode(captured.body) as Map<String, dynamic>;
      expect(body['title'], 'Event Intern');
      expect(body['started_at'], '2026-05-01');
      for (final serverField in [
        'id',
        'category_display',
        'is_ongoing',
        'thumbnail_url',
        'thumbnail_image',
        'ended_at',
        'thumbnail',
      ]) {
        expect(body.containsKey(serverField), isFalse, reason: serverField);
      }
      expect(created.id, _experienceId);
    });

    test('throws ApiException with the status code on 401', () async {
      final api = _clientWith(
        (request) async => _json({'detail': 'Invalid token.'}, 401),
      );

      await expectLater(
        api.createExperience(draft, token: 'bad'),
        _apiException(401),
      );
    });

    test('throws ApiException with the status code on 403', () async {
      final api = _clientWith(
        (request) async => _json({'detail': 'Forbidden.'}, 403),
      );

      await expectLater(
        api.createExperience(draft, token: 'abc'),
        _apiException(403),
      );
    });
  });

  group('deleteExperience', () {
    test('sends DELETE with the token', () async {
      late http.Request captured;
      final api = _clientWith((request) async {
        captured = request;
        return http.Response('', 204);
      });

      await api.deleteExperience(_experienceId, token: 'abc123');

      expect(captured.method, 'DELETE');
      expect(captured.url.path, '/api/v1/experiences/$_experienceId/');
      expect(captured.headers['Authorization'], 'Token abc123');
    });

    test('throws ApiException on 403', () async {
      final api = _clientWith(
        (request) async => _json({'detail': 'Forbidden.'}, 403),
      );

      await expectLater(
        api.deleteExperience(_experienceId, token: 'abc'),
        _apiException(403),
      );
    });
  });

  group('authentication', () {
    test('obtainToken returns the token from the response', () async {
      late http.Request captured;
      final api = _clientWith((request) async {
        captured = request;
        return _json({'token': 'abc123'}, 200);
      });

      final token = await api.obtainToken('root', 'secret');

      expect(token, 'abc123');
      expect(captured.method, 'POST');
      expect(captured.url.path, '/api/v1/auth/token/');
      expect(jsonDecode(captured.body), {
        'username': 'root',
        'password': 'secret',
      });
    });

    test('obtainToken throws ApiException on bad credentials', () async {
      final api = _clientWith(
        (request) async => _json({
          'non_field_errors': ['x'],
        }, 400),
      );

      await expectLater(api.obtainToken('root', 'wrong'), _apiException(400));
    });

    test('logout sends the token', () async {
      late http.Request captured;
      final api = _clientWith((request) async {
        captured = request;
        return http.Response('', 204);
      });

      await api.logout(token: 'abc123');

      expect(captured.method, 'POST');
      expect(captured.url.path, '/api/v1/auth/logout/');
      expect(captured.headers['Authorization'], 'Token abc123');
    });
  });
}
