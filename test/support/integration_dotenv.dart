import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:path/path.dart' as p;

/// Loads `.env` from the package root even when the test runner cwd differs.
DotEnv loadIntegrationDotEnv() {
  final env = DotEnv(includePlatformEnvironment: true, quiet: true);
  final root = _findPackageRoot();
  if (root != null) {
    final dotEnvPath = p.join(root.path, '.env');
    if (File(dotEnvPath).existsSync()) {
      env.load([dotEnvPath]);
      return env;
    }
  }
  env.load();
  return env;
}

Directory? _findPackageRoot() {
  Directory? walk(Directory start) {
    var dir = start;
    for (var i = 0; i < 12; i++) {
      if (File(p.join(dir.path, 'pubspec.yaml')).existsSync()) {
        return dir;
      }
      final parent = dir.parent;
      if (parent.path == dir.path) {
        break;
      }
      dir = parent;
    }
    return null;
  }

  final fromCwd = walk(Directory.current);
  if (fromCwd != null) {
    return fromCwd;
  }

  try {
    final scriptPath = Platform.script.toFilePath();
    return walk(Directory(p.dirname(scriptPath)));
  } catch (_) {
    return null;
  }
}
