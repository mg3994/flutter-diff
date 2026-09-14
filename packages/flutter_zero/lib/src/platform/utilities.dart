import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

export 'package:equatable/equatable.dart';

class ZeroUtils {
  static const Uuid _uuid = Uuid();

  static String generateUuid() {
    return _uuid.v4();
  }

  static String sha256Hash(String input) {
    final bytes = utf8.encode(input);
    return sha256.convert(bytes).toString();
  }
}

abstract class ZeroModel extends Equatable {
  const ZeroModel();
}
