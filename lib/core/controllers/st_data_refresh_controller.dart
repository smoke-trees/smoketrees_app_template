import 'dart:async';

import 'package:get/get.dart';

/// A local, typed change to a row rendered by a server-driven list.
///
/// Emitted by app actions (toggle/delete/...) so listening widgets can update
/// just the affected item locally â€” no full-list re-fetch or page jump.
sealed class StDataChange {
  const StDataChange();
}

/// One row's fields changed. [fields] is merged into the matched item.
class StDataItemUpdated extends StDataChange {
  const StDataItemUpdated(this.key, this.fields);

  final dynamic key;
  final Map<String, dynamic> fields;
}

/// A row was deleted from the server.
class StDataItemDeleted extends StDataChange {
  const StDataItemDeleted(this.key);

  final dynamic key;
}

/// The whole collection changed (create on a different screen, etc.) and
/// lists should re-fetch. Kept as a fallback for non-local edits.
class StDataListReset extends StDataChange {
  const StDataListReset();
}

/// App-wide bus that notifies server-driven lists of local item-level edits.
class StDataRefreshController extends GetxController {
  static StDataRefreshController get to => Get.find();

  final StreamController<StDataChange> _changes = StreamController.broadcast();

  /// Emits every local [StDataChange] produced anywhere in the app.
  Stream<StDataChange> get changes => _changes.stream;

  void notifyItemUpdated(dynamic key, Map<String, dynamic> fields) =>
      _changes.add(StDataItemUpdated(key, fields));

  void notifyItemDeleted(dynamic key) =>
      _changes.add(StDataItemDeleted(key));

  void notifyListChanged() => _changes.add(const StDataListReset());
}