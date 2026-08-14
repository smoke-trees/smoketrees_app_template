// Single source for compiling the Stac CLI into a native binary.
//
// Works on Windows, macOS, and Linux — the output name is chosen per OS:
//   - Windows  -> stac.exe
//   - macOS    -> stac        (mach-o executable)
//   - Linux    -> stac        (ELF executable)
//
// Usage:
//   dart run build_stac.dart "https://your-backend.com/api"
//
// The backend URL is baked in at compile time.

import 'dart:io';

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    stderr.writeln('Usage: dart run build_stac.dart "https://your-backend.com/api"');
    exit(1);
  }

  final url = args.first;
  final binary = Platform.isWindows ? 'stac-app.exe' : 'stac-app';

  final result = await Process.run('dart', [
    'compile',
    'exe',
    'stac_cli/bin/stac_cli.dart',
    '-D',
    'STAC_BASE_API_URL=$url',
    '-o',
    binary,
  ]);

  stdout.write(result.stdout);
  stderr.write(result.stderr);

  if (result.exitCode != 0) {
    exit(result.exitCode);
  }

  stdout.writeln('Built $binary with STAC_BASE_API_URL=$url');
}