import 'dart:io';

import 'package:stac_cli/src/models/stac_dsl_artifact.dart';
import 'package:stac_cli/src/services/build_service.dart';
import 'package:stac_cli/watch/build_target_resolver.dart';
import 'package:stac_cli/watch/manifest.dart';
import 'package:stac_cli/watch/watch_command.dart';

Future<void> main(List<String> args) async {
  final projectRoot = Directory.current.path;

  final buildService = BuildService();

  final resolver = BuildTargetResolver(
    stacEntryDir: '$projectRoot/stac',
    libDir: '$projectRoot/lib',
    dependencyDirs: ['$projectRoot/lib'],

    // A file is a screen/theme entry if it carries the annotation — mirrors
    // what BuildService.build() already scans for.
    isEntryFile: (path, content) =>
        content.contains('@StacScreen') || content.contains('@StacThemeRef'),

    // Read the annotation's actual argument, not the filename:
    // `@StacScreen(screenName: "sign_in")` in st_sign_in_page.dart must
    // produce name "sign_in", and `@StacThemeRef(name: 'main_theme')` in
    // st_theme.dart must produce name "main_theme".
    buildTargetFor: (path, content) {
      final artifacts = buildService.analyzeFileSource(content);
      if (artifacts.isEmpty) {
        throw StateError('no artifact found in $path');
      }
      final artifact = artifacts.first;
      return BuildTarget(
        name: artifact.artifactName,
        type: artifact.type == StacDslArtifactType.screen
            ? ArtifactType.screen
            : ArtifactType.theme,
        sourceFile: path,
        callableName: artifact.callableName,
        isGetter: artifact.isGetter,
      );
    },
  );

  final watchCmd = WatchCommand(
    projectRoot: projectRoot,
    resolver: resolver,
    port: int.tryParse(_argValue(args, '--port') ?? '') ?? 8090,
    host:
        _argValue(args, '--host') ??
        '192.168.1.17', // LAN IP for physical devices
    spawnApp: !args.contains('--no-app'),
    deviceId: _argValue(args, '--device'),

    // Drive the real single-artifact build. Same output `stac build` writes
    // for this screen/theme, scoped to exactly one target. Failures throw,
    // which WatchCommand catches and skips (last good build stays live).
    buildOne: (target) => buildService.buildArtifact(
      projectDir: projectRoot,
      sourceFilePath: target.sourceFile,
      artifact: StacDslArtifact(
        type: target.type == ArtifactType.screen
            ? StacDslArtifactType.screen
            : StacDslArtifactType.theme,
        callableName: target.callableName!,
        artifactName: target.name,
        isGetter: target.isGetter,
      ),
    ),
    isDevelopment: !args.contains('--no-dev'),
    buildDirName: 'stac/.dev-build',
    appTarget: 'lib/main.dart',
  );

  ProcessSignal.sigint.watch().listen((_) async {
    print('\nshutting down…');
    await watchCmd.dispose();
    exit(0);
  });

  // Returns once the user presses `q`; dispose() already ran inside run().
  await watchCmd.run();
  print('shutting down…');
  exit(0);
}

String? _argValue(List<String> args, String flag) {
  final i = args.indexOf(flag);
  if (i == -1 || i + 1 >= args.length) return null;
  return args[i + 1];
}
