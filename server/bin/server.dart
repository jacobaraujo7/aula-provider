import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

final key = 's3cr3t';
final claimSet = JwtClaim(
    subject: 'provider',
    issuer: 'flutterando',
    otherClaims: <String, dynamic>{
      'typ': 'authnresponse',
      'pld': {'k': 'v'}
    },
    maxAge: const Duration(minutes: 5));

final _router = Router()
  ..post('/auth', _rootHandler)
  ..get('/echo/<message>', _echoHandler);

FutureOr<Response> _rootHandler(Request req) async {
  final map = (jsonDecode(await req.readAsString()) as Map);
  final token = issueJwtHS256(claimSet, key);
  if (map['email'] == 'jacob@flutterando.com.br' && map['password'] == "123") {
    return Response.ok(jsonEncode({
      'name': 'Jacob Moura',
      'email': 'jacob@flutterando.com.br',
      'token': token,
    }));
  }
  return Response.forbidden('Not allow');
}

Response _echoHandler(Request request) {
  final token = request.headers['Authorization']!.replaceFirst('Bearer ', '');

  final decClaimSet = verifyJwtHS256Signature(token, key);

  try {
    decClaimSet.validate();
    final message = params(request, 'message');
    return Response.ok('$message\n');
  } catch (e) {
    return Response.forbidden('Not allow');
  }
}

void main(List<String> args) async {
  final ip = InternetAddress.anyIPv4;
  final _handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(_handler, ip, port);
  print('Server listening on port ${server.port}');
}
