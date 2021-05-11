// Ensure that the build script itself is not opted in to null safety,
// instead of taking the language version from the current package.
//
// @dart=2.9
//
// ignore_for_file: directives_ordering

import 'package:build_runner_core/build_runner_core.dart' as _i1;
import 'package:moor_generator/integrations/build.dart' as _i2;
import 'package:source_gen/builder.dart' as _i3;
import 'dart:isolate' as _i4;
import 'package:build_runner/build_runner.dart' as _i5;
import 'dart:io' as _i6;

final _builders = <_i1.BuilderApplication>[
  _i1.apply(r'moor_generator:preparing_builder', [_i2.preparingBuilder],
      _i1.toDependentsOf(r'moor_generator'),
      hideOutput: true,
      appliesBuilders: const [r'moor_generator:moor_cleanup']),
  _i1.apply(r'moor_generator:moor_generator', [_i2.moorBuilder],
      _i1.toDependentsOf(r'moor_generator'),
      hideOutput: true,
      appliesBuilders: const [r'source_gen:combining_builder']),
  _i1.apply(r'moor_generator:moor_generator_not_shared',
      [_i2.moorBuilderNotShared], _i1.toNoneByDefault(),
      hideOutput: false),
  _i1.apply(r'source_gen:combining_builder', [_i3.combiningBuilder],
      _i1.toNoneByDefault(),
      hideOutput: false, appliesBuilders: const [r'source_gen:part_cleanup']),
  _i1.applyPostProcess(r'source_gen:part_cleanup', _i3.partCleanup),
  _i1.applyPostProcess(r'moor_generator:moor_cleanup', _i2.moorCleanup)
];
void main(List<String> args, [_i4.SendPort sendPort]) async {
  var result = await _i5.run(args, _builders);
  sendPort?.send(result);
  _i6.exitCode = result;
}
