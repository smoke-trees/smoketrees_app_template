#!/usr/bin/env bash
# Scaffold a custom Stac widget parser (model + parser + .g.dart).
#
# Usage:
#   ./create_stac_parser.sh <Name> [category] [subdir...]
#
# Examples:
#   ./create_stac_parser.sh MyWidget
#   ./create_stac_parser.sh MyWidget layout
#   ./create_stac_parser.sh MyWidget layout/custom
#
# Creates (using "my_widget" / "st_my_widget" / "my_widget" naming, mirroring
# lib/stac_runtime/widgets/layout/material/):
#   lib/stac_runtime/widgets/<category>/<snake>/st_<snake>.dart        # StacWidget model
#   lib/stac_runtime/widgets/<category>/<snake>/st_<snake>_parser.dart # StacParser
#   lib/stac_runtime/widgets/<category>/<snake>/st_<snake>.g.dart      # generated code
#
# Then:
#   - exports both files from lib/smoketrees_app_template.dart (the barrel),
#   - registers the parser in lib/stac_runtime/stac_registry.dart,
#   - runs build_runner to (re)generate the .g.dart file.
#
# Requires a Linux/macOS shell with sed, and the project's Flutter toolchain
# (fvm) available.

set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 <Name> [category] [subdir...]"
  echo "Example: $0 Material layout"
  exit 1
fi

Name="$1"
shift

# --- name transforms -------------------------------------------------------
lowercase=$(echo "$Name" | tr '[:upper:]' '[:lower:]')
# MyWidget -> my_widget ; HTTPWidget -> h_t_t_p_widget (kept simple, matches Material)
snakecase=$(echo "$Name" | sed -E 's/([a-z0-9])([A-Z])/\1_\2/g' | tr '[:upper:]' '[:lower:]')
kebabcase=$(echo "$Name" | sed -E 's/([a-z0-9])([A-Z])/\1-\2/g' | tr '[:upper:]' '[:lower:]')

# Widget type key sent over JSON, e.g. "st_my_widget"
type="st_${snakecase}"

# --- destination ----------------------------------------------------------
BASE="lib/stac_runtime/widgets"
CATEGORY="${1:-layout}"
[ $# -ge 1 ] && shift
SUBDIR="$*"
if [ -n "$SUBDIR" ]; then
  SUBDIR="$CATEGORY/$SUBDIR"
else
  SUBDIR="$CATEGORY"
fi

DIR="$BASE/$SUBDIR/$snakecase"
mkdir -p "$DIR"

# Package-relative path used in the barrel export
PKG_REL="stac_runtime/widgets/$SUBDIR/$snakecase/st_${snakecase}"

# --- model: st_<snake>.dart ----------------------------------------------
cat > "$DIR/st_${snakecase}.dart" <<EOF
import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'st_${snakecase}.g.dart';

/// Data model for the "$type" Stac widget type.
///
/// Uses the same Stac-native types (StacColor, StacWidget, ...) as built-in
/// DSL widgets so it serializes/deserializes and themes identically. Add your
/// widget's own fields here, then run the parser to render them.
@JsonSerializable(explicitToJson: true)
class $Name extends StacWidget {
  const $Name({
    this.child,
  });

  /// Maps to the widget's child, resolved recursively by Stac.
  final StacWidget? child;

  @override
  String get type => '$type';

  factory $Name.fromJson(Map<String, dynamic> json) => _\$${Name}FromJson(json);

  @override
  Map<String, dynamic> toJson() => _\$${Name}ToJson(this);
}
EOF

# --- parser: st_<snake>_parser.dart --------------------------------------
cat > "$DIR/st_${snakecase}_parser.dart" <<EOF
import 'package:flutter/material.dart';
import 'package:stac/stac.dart';

import 'st_${snakecase}.dart';

/// Registers the "$type" type with Stac so JSON payloads can render
/// [$Name]. Replace the placeholder \`SizedBox\` body with your widget and
/// any helper methods (e.g. enum mapping), then add fields to the model.
///
/// Registered via the barrel export in
/// `lib/stac_runtime/stac_registry.dart` (done by the scaffold script):
/// \`\`\`dart
/// await Stac.initialize(
///   parsers: const [
///     ${Name}Parser(),
///   ],
/// );
/// \`\`\`
class ${Name}Parser extends StacParser<$Name> {
  @override
  String get type => '$type';

  @override
  $Name getModel(Map<String, dynamic> json) => $Name.fromJson(json);

  @override
  Widget parse(BuildContext context, $Name model) {
    final Widget? child = model.child?.parse(context);
    return SizedBox(
      child: child,
    );
  }
}
EOF

# --- export from the barrel: lib/smoketrees_app_template.dart -------------
BARREL="lib/smoketrees_app_template.dart"
sed -i '' "/stac_runtime\/widgets\/layout\/wildcard_page\/wildcard_page_parser.dart';/a\\
export '$PKG_REL.dart';\\
export '$PKG_REL\_parser.dart';" "$BARREL"

# --- register the parser in lib/stac_runtime/stac_registry.dart -----------
REG="lib/stac_runtime/stac_registry.dart"

# add the parser instance before the closing "];" of the parsers list
sed -i '' "/^    WildcardPageParser(),/a\\
    ${Name}Parser()," "$REG"

echo "Created custom Stac parser '$Name'"
echo "  Model:   $DIR/st_${snakecase}.dart"
echo "  Parser:  $DIR/st_${snakecase}_parser.dart"
echo "  .g.dart: $DIR/st_${snakecase}.g.dart"
echo "Exported from $BARREL"
echo "Registered ${Name}Parser() in $REG"

# --- regenerate .g.dart ---------------------------------------------------
if command -v fvm >/dev/null 2>&1; then
  # Don't pre-write the .g.dart: an existing placeholder makes build_runner
  # treat the output as up-to-date and skip generation.
  rm -f "$DIR/st_${snakecase}.g.dart"
  fvm dart run build_runner build --delete-conflicting-outputs
else
  # Fallback placeholder so the file still exists for manual generation.
  cat > "$DIR/st_${snakecase}.g.dart" <<EOF
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'st_${snakecase}.dart';

// Run \`fvm dart run build_runner build --delete-conflicting-outputs\`
// to generate this file from the model's @JsonSerializable annotations.
EOF
  echo
  echo "fvm not found — run the generator manually:"
  echo "  fvm dart run build_runner build --delete-conflicting-outputs"
fi