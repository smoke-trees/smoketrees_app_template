import 'package:json_annotation/json_annotation.dart';

/// A Stac representation of Flutter's [SemanticsRole] enum.
///
/// Describes the accessibility role assigned to a semantics node. Roles are
/// translated into native accessibility roles on each platform (e.g. ARIA
/// roles on web).
///
/// ```json
/// { "type": "dialog", "semanticsRole": "alertDialog", "child": { ... } }
/// ```
///
/// See also:
///  * Flutter's [SemanticsRole documentation](https://api.flutter.dev/flutter/dart-ui/SemanticsRole.html)
@JsonEnum()
enum StSemanticsRole {
  /// Does not represent any role.
  none,

  /// A tab button.
  tab,

  /// Contains tab buttons.
  tabBar,

  /// The main display for a tab.
  tabPanel,

  /// A pop up dialog.
  dialog,

  /// An alert dialog.
  alertDialog,

  /// A table structure containing data arranged in rows and columns.
  table,

  /// A cell in a table that does not contain column or row header
  /// information.
  cell,

  /// A row of cells or columnHeaders in a table.
  row,

  /// A cell in a table that contains header information for a column.
  columnHeader,

  /// A control used for dragging across content, e.g. a reorderable list's
  /// drag handle.
  dragHandle,

  /// A control to cycle through content on tap, e.g. a date picker's
  /// next/previous month button.
  spinButton,

  /// An input field with a dropdown list box attached.
  comboBox,

  /// A presentation of [menu] that usually remains visible and is usually
  /// presented horizontally.
  menuBar,

  /// A permanently visible list of controls, or a widget that can be made
  /// to open and close.
  menu,

  /// An item in a dropdown created by [menu] or [menuBar].
  menuItem,

  /// An item with a checkbox in a dropdown created by [menu] or [menuBar].
  menuItemCheckbox,

  /// An item with a radio button in a dropdown created by [menu] or
  /// [menuBar].
  menuItemRadio,

  /// A container to display multiple [listItem]s in a vertical or
  /// horizontal layout.
  list,

  /// An item in a [list].
  listItem,

  /// An area that represents a form.
  form,

  /// A pop up displayed when hovering over a component to provide
  /// contextual explanation.
  tooltip,

  /// A graphic object that spins to indicate the application is busy.
  loadingSpinner,

  /// A graphic object that shows progress with a numeric number.
  progressBar,

  /// A keyboard shortcut field that allows the user to enter a combination
  /// or sequence of keystrokes.
  hotKey,

  /// A group of radio buttons.
  radioGroup,

  /// A component to provide advisory information that is not important
  /// enough to justify an [alert].
  status,

  /// A component to provide important and usually time-sensitive
  /// information.
  alert,

  /// A supporting section that relates to the main content, e.g. a sidebar
  /// or call-out box.
  complementary,

  /// A section for a footer, containing identifying information such as
  /// copyright, navigation links and privacy statements.
  contentInfo,

  /// The primary content of a document.
  main,

  /// A region of a page that contains navigation links.
  navigation,

  /// A section of content sufficiently important but not describable by
  /// one of the other landmark roles.
  region,
}
