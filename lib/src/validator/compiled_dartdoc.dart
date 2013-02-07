// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library compiled_dartdoc_validator;

import 'dart:async';

import '../../../pkg/path/lib/path.dart' as path;

import '../entrypoint.dart';
import '../io.dart';
import '../utils.dart';
import '../validator.dart';

/// Validates that a package doesn't contain compiled Dartdoc
/// output.
class CompiledDartdocValidator extends Validator {
  CompiledDartdocValidator(Entrypoint entrypoint)
    : super(entrypoint);

  Future validate() {
    return listDir(entrypoint.root.dir, recursive: true).then((entries) {
      for (var entry in entries) {
        if (basename(entry) != "nav.json") return false;
        var dir = dirname(entry);

        // Look for tell-tale Dartdoc output files all in the same directory.
        var files = [
          entry,
          join(dir, "index.html"),
          join(dir, "styles.css"),
          join(dir, "dart-logo-small.png"),
          join(dir, "client-live-nav.js")
        ];

        if (files.every((val) => fileExists(val))) {
          warnings.add("Avoid putting generated documentation in "
                  "${path.relative(dir)}.\n"
              "Generated documentation bloats the package with redundant "
                  "data.");
        }
      }
    });
  }
}