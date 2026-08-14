#!/usr/bin/env bash
# Scaffold a custom Stac action parser (action model + parser + .g.dart).
#
# Usage:
#   ./create_stac_action.sh <Name> [category] [subdir...]
#
# Examples:
#   ./create_stac_action.sh SubmitOrder
#   ./create_stac_action.sh SubmitOrder checkout
#   ./create_stac_action.sh ShareOrder cart
#
# Creates (using "my_action" / "st_my_action" / "st_my_action" naming, mirroring
# lib/stac_runtime/actions/wildcard_page_nav/):
#   lib/stac_runtime/actions/<category>/<snake>/st_<snake>_action.dart        # StacAction model
#   lib/stac_runtime/actions/<category>/<snake>/st_<snake>_action_parser.dart # StacActionParser
#   lib/stac_runtime/actions/<category>/<snake>/st_<snake>_action.g.dart      # generated code
#
# Then:
#   - exports both files from lib/smoketrees_app_template.dart (the barrel),
#   - registers the parser in the actionParsers list of
#     lib/stac_runtime/stac_registry.dart,
#   - runs build_runner to (re)generate the .g.dart file.
#
# Requires a Linux/macOS shell with sed, and the project's Flutter toolchain
# (fvm) available.

set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 <Name> [category] [subdir...]"
  echo "Example: $0 SubmitOrder checkout"
  exit 1
fi

Name="$1"
shift

# --- name transforms -------------------------------------------------------
lowercase=$(echo "$Name" | tr '[:upper:]' '[:lower:]')
# SubmitOrder -> submit_order ; HTTPAction -> h_t_t_p_action (kept simple)
snakecase=$(echo "$Name" | sed -r 's/([a-z0-9])([A-Z])/\1_\L\2/g' | tr '[:upper:]' '[:lower:]')
kebabcase=$(echo "$Name" | sed -r 's/([a-z0-9])([A-Z])/\1-\L\2/g' | tr '[:upper:]' '[:lower:]')

# Action type key sent over JSON, e.g. "submit_order"
actionType="$snakecase"

# Class names: StSubmitOrderAction / StSubmitOrderActionParser
Action="St${Name}Action"
ActionParser="St${Name}ActionParser"

# --- destination ----------------------------------------------------------
BASE="lib/stac_runtime/actions"
CATEGORY="${1:-actions}"
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
PKG_REL="stac_runtime/actions/$SUBDIR/$snakecase/st_${snakecase}_action"

# --- action model: st_<snake>_action.dart --------------------------------
cat > "$DIR/st_${snakecase}_action.dart" <<EOF
import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'st_${snakecase}_action.g.dart';

/// Custom [StacAction] for the "$actionType" action type.
///
/// Add your action's fields here (e.g. an id, payload, or options), then
/// dispatch them from the parser's `onCall`.
///
/// ```json
/// { "actionType": "$actionType" }
/// ```
@JsonSerializable(explicitToJson: true)
class $Action extends StacAction {
  const $Action();

  @override
  String get actionType => '$actionType';

  factory $Action.fromJson(Map<String, dynamic> json) =>
      _\$${Action}FromJson(json);

  @override
  Map<String, dynamic> toJson() => _\$${Action}ToJson(this);
}
EOF

# --- action parser: st_<snake>_action_parser.dart -------------------------
cat > "$DIR/st_${snakecase}_action_parser.dart" <<EOF
import 'package:flutter/material.dart';
import 'package:stac/stac.dart';

import 'st_${snakecase}_action.dart';

/// Parses and dispatches [$Action].
///
/// Replace the placeholder body of `onCall` with your action's behaviour
/// (navigation, API calls, form submission, ...). Dispatch through
/// \`Stac.onCallFromJson\` (as the built-in actions do) to keep behaviour
/// identical whether triggered from JSON or imperative code.
class $ActionParser extends StacActionParser<$Action> {
  const $ActionParser();

  @override
  String get actionType => '$actionType';

  @override
  $Action getModel(Map<String, dynamic> json) => $Action.fromJson(json);

  @override
  Future<void> onCall(BuildContext context, $Action model) async {
    // TODO: implement your action behaviour here.
  }
}
EOF

# --- .g.dart placeholder (overwritten by build_runner) --------------------
cat > "$DIR/st_${snakecase}_action.g.dart" <<EOF
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'st_${snakecase}_action.dart';

// Run `fvm dart run build_runner build --delete-conflicting-outputs`
// to generate this file from the model's @JsonSerializable annotations.
EOF

# --- export from the barrel: lib/smoketrees_app_template.dart -------------
BARREL="lib/smoketrees_app_template.dart"
sed -i "/stac_runtime\/actions\/wildcard_page_nav\/st_wildcard_page_nav_parser.dart';/a\\
export '$PKG_REL.dart';\\
export '$PKG_REL\_parser.dart';" "$BARREL"

# --- register the parser in lib/stac_runtime/stac_registry.dart -----------
REG="lib/stac_runtime/stac_registry.dart"

# add the parser instance before the closing "];" of the actionParsers list
sed -i "/^    StWildcardPageNavActionParser(),/a\\
    ${ActionParser}()," "$REG"

echo "Created custom Stac action parser '$Name'"
echo "  Model:   $DIR/st_${snakecase}_action.dart"
echo "  Parser:  $DIR/st_${snakecase}_action_parser.dart"
echo "  .g.dart: $DIR/st_${snakecase}_action.g.dart"
echo "Exported from $BARREL"
echo "Registered ${ActionParser}() in $REG"

# --- regenerate .g.dart ---------------------------------------------------
if command -v fvm >/dev/null 2>&1; then
  fvm dart run build_runner build --delete-conflicting-outputs
else
  echo
  echo "fvm not found — run the generator manually:"
  echo "  fvm dart run build_runner build --delete-conflicting-outputs"
fi