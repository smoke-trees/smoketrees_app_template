import 'package:smoketrees_app_template/stac_runtime/widgets/collections/dismissible/st_dismissible.dart';
import 'package:smoketrees_app_template/stac_runtime/widgets/collections/reorderable_list_view_builder/st_reorderable_list_view_builder.dart';
import 'package:smoketrees_app_template/stac_runtime/widgets/controls/animated_icon_toggle/st_animated_icon_toggle.dart';
import 'package:smoketrees_app_template/stac_runtime/widgets/controls/dialog/st_dialog.dart';
import 'package:smoketrees_app_template/stac_runtime/widgets/controls/main_button/st_main_button.dart';
import 'package:smoketrees_app_template/stac_runtime/widgets/layout/animated_container/st_animated_container.dart';
import 'package:smoketrees_app_template/stac_runtime/widgets/layout/conditional/st_conditional_widget.dart';
import 'package:smoketrees_app_template/stac_runtime/widgets/layout/conditional_container/st_conditional_container.dart';
import 'package:smoketrees_app_template/stac_runtime/widgets/layout/material/st_material.dart';
import 'package:smoketrees_app_template/theme/st_app_colors.dart';
import 'package:stac/stac_core.dart';

import '../../../lib/stac_runtime/actions/to_do/create_to_do/st_create_to_do_action.dart';
import '../../../lib/stac_runtime/actions/to_do/delete_to_do/st_delete_to_do_action.dart';
import '../../../lib/stac_runtime/actions/to_do/reorder_to_do/stac_reorder_to_do_action.dart';
import '../../../lib/stac_runtime/actions/to_do/toggle_to_do/st_toggle_to_do_action.dart';

StacWidget stToDoListView() {
  return StacScaffold(
    backgroundColor: StacColors.white,
    appBar: StacAppBar(
      title: StacText(
        data: 'To Do List',
        style: StacThemeData.textTheme.displaySmall,
      ),
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: StacColors.white,
      surfaceTintColor: StacColors.white,
    ),
    body: StacColumn(
      children: [
        StacExpanded(
          child: StacPadding(
            padding: StacEdgeInsets.only(
              left: 16,
              top: 4,
              right: 16,
              bottom: 4,
            ),
            child: StacCenter(
              child: StReorderableListViewBuilder(
                count: 8,
                spacing: 12,
                scrollDirection: StacAxis.vertical.toString(),
                itemTemplate: StDismissible(
                  keyValue: 'dismiss-{{id}}',
                  direction: 'horizontal',
                  background: StacContainer(
                    margin: const StacEdgeInsets.symmetric(vertical: 2),
                    padding: const StacEdgeInsets.symmetric(horizontal: 20),
                    alignment: StacAlignment.centerLeft,
                    decoration: StacBoxDecoration(
                      color: StAppColors
                          .primaryColor, // completeColor ?? AppColors.primaryColor
                      borderRadius: StacBorderRadius.circular(18),
                    ),
                    child: StacRow(
                      mainAxisSize: StacMainAxisSize.min,
                      children: [
                        StConditionalWidget(
                          when: '{{completed}}',
                          whenTrue: const StacIcon(
                            icon: StacIcons.replay_rounded,
                            color: StacColors.white,
                          ),
                          whenFalse: const StacIcon(
                            icon: StacIcons.check_circle_rounded,
                            color: StacColors.white,
                          ),
                        ),
                        const StacSizedBox(width: 8),
                        StConditionalWidget(
                          when: '{{completed}}',
                          whenTrue: StacText(
                            data: 'Undo',
                            style: StacTextStyle(
                              color: StacColors.white,
                              fontWeight: StacFontWeight.w700,
                            ),
                          ),
                          whenFalse: StacText(
                            data: 'Complete',
                            style: StacTextStyle(
                              color: StacColors.white,
                              fontWeight: StacFontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  secondaryBackground: StacContainer(
                    margin: const StacEdgeInsets.symmetric(vertical: 2),
                    padding: const StacEdgeInsets.symmetric(horizontal: 20),
                    alignment: StacAlignment.centerRight,
                    decoration: StacBoxDecoration(
                      color: StacColors
                          .redAccent, // deleteColor ?? Colors.redAccent
                      borderRadius: StacBorderRadius.circular(18),
                    ),
                    child: StacRow(
                      mainAxisSize: StacMainAxisSize.min,
                      children: [
                        StacText(
                          data: 'Delete',
                          style: StacTextStyle(
                            color: StacColors.white,
                            fontWeight: StacFontWeight.w700,
                          ),
                        ),
                        StacSizedBox(width: 8),
                        StacIcon(
                          icon: StacIcons.delete_rounded,
                          color: StacColors.white,
                        ),
                      ],
                    ),
                  ),
                  confirmDialog: const StDismissibleConfirmDialog(
                    title: 'Delete this to-do?',
                    message:
                        '{{title}} will be removed.', // falls back to generic text if title is empty server-side
                    cancelLabel: 'Cancel',
                    confirmLabel: 'Delete',
                    confirmColor: StacColors.redAccent,
                  ),
                  onStartToEnd: StacToggleToDoAction(id: '{{id}}'),
                  onEndToStart: StacDeleteToDoAction(id: '{{id}}'),
                  child: StAnimatedContainer(
                    durationMs: 200,
                    // see note below
                    decorationWhen: '{{completed}}',
                    // margin: StacEdgeInsets.only(bottom: 12),
                    decorationWhenTrue: StacBoxDecoration(
                      color: StAppColors.grey2.withOpacity(0.15),
                      borderRadius: StacBorderRadius.circular(18),
                      border: StacBorder.all(
                        color: StAppColors.grey2.withOpacity(0.6),
                      ),
                    ),
                    decorationWhenFalse: StacBoxDecoration(
                      color: StacColors.white,
                      borderRadius: StacBorderRadius.circular(18),
                      border: StacBorder.all(
                        color: StAppColors.grey2.withOpacity(0.8),
                      ),
                      boxShadow: [
                        StacBoxShadow(
                          color: StacColors.black.withOpacity(0.05),
                          blurRadius: 16,
                          offset: const StacOffset(dx: 0, dy: 6),
                        ),
                      ],
                    ),

                    child: StMaterial(
                      color: StacColors.transparent,
                      surfaceTintColor: StacColors.transparent,
                      borderRadius: StacBorderRadius.circular(18),
                      child: StacGestureDetector(
                        behavior: StacHitTestBehavior.opaque,
                        onTap: StacToggleToDoAction(id: '{{id}}'),
                        child: StacPadding(
                          padding: const StacEdgeInsets.all(16),
                          child: StacColumn(
                            crossAxisAlignment: StacCrossAxisAlignment.start,
                            children: [
                              StacRow(
                                crossAxisAlignment:
                                    StacCrossAxisAlignment.start,
                                children: [
                                  StConditionalContainer(
                                    width: 44, // serialNumberMarkWidth
                                    height: 44,
                                    when: '{{completed}}',
                                    decorationWhenTrue: StacBoxDecoration(
                                      shape: StacBoxShape.circle,
                                      color: StAppColors.grey1.withOpacity(0.4),
                                    ),
                                    decorationWhenFalse: StacBoxDecoration(
                                      shape: StacBoxShape.circle,
                                      gradient: StacGradient.linear(
                                        colors: [
                                          StAppColors.primaryColor,
                                          StAppColors.primaryColor.withOpacity(
                                            0.75,
                                          ),
                                        ],
                                        begin: StacAlignment.topLeft,
                                        end: StacAlignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        StacBoxShadow(
                                          color: StAppColors.primaryColor
                                              .withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const StacOffset(
                                            dx: 0,
                                            dy: 3,
                                          ),
                                        ),
                                      ],
                                    ),
                                    child: StacCenter(
                                      child: StacText(
                                        data: '{{serialNumber}}',
                                        style: StacTextStyle(
                                          color: StacColors.white,
                                          fontWeight: StacFontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const StacSizedBox(width: 16),
                                  StacExpanded(
                                    child: StacColumn(
                                      crossAxisAlignment:
                                          StacCrossAxisAlignment.start,
                                      children: [
                                        StConditionalWidget(
                                          when: '{{completed}}',
                                          whenTrue: StacText(
                                            data: '{{title}}',
                                            maxLines: 2,
                                            overflow: StacTextOverflow.ellipsis,
                                            style: StacTextStyle(
                                              color: StAppColors.grey1,
                                              fontWeight: StacFontWeight.w700,
                                              decoration: StacTextDecorationLine
                                                  .lineThrough,
                                              decorationColor:
                                                  StAppColors.grey1,
                                            ),
                                          ),
                                          whenFalse: StacText(
                                            data: '{{title}}',
                                            maxLines: 2,
                                            overflow: StacTextOverflow.ellipsis,
                                            style: StacTextStyle(
                                              color: StAppColors.textDark,
                                              fontWeight: StacFontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        const StacSizedBox(height: 6),
                                        StConditionalWidget(
                                          when: '{{completed}}',
                                          whenTrue: StacContainer(
                                            padding:
                                                const StacEdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 3,
                                                ),
                                            decoration: StacBoxDecoration(
                                              color: StAppColors.primaryColor
                                                  .withOpacity(0.12),
                                              borderRadius:
                                                  StacBorderRadius.circular(6),
                                            ),
                                            child: StacText(
                                              data: 'Completed',
                                              style: StacTextStyle(
                                                fontSize: 11,
                                                fontWeight: StacFontWeight.w700,
                                                color: StAppColors.primaryColor,
                                              ),
                                            ),
                                          ),
                                          whenFalse: StacContainer(
                                            padding:
                                                const StacEdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 3,
                                                ),
                                            decoration: StacBoxDecoration(
                                              color: StacColors.orange
                                                  .withOpacity(0.12),
                                              borderRadius:
                                                  StacBorderRadius.circular(6),
                                            ),
                                            child: StacText(
                                              data: 'In progress',
                                              style: StacTextStyle(
                                                fontSize: 11,
                                                fontWeight: StacFontWeight.w700,
                                                color: '#FFE65100',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const StacSizedBox(width: 8),
                                  StAnimatedIconToggle(
                                    when: '{{completed}}',
                                    trueIcon: 'check_circle_rounded',
                                    falseIcon: 'radio_button_unchecked_rounded',
                                    trueColor: StAppColors.primaryColor,
                                    falseColor: StAppColors.grey1,
                                    size: 30,
                                    onTap: StacToggleToDoAction(id: '{{id}}'),
                                  ),
                                ],
                              ),
                              // hasDescription check: only meaningful when description is guaranteed non-empty
                              // server-side, since Stac has no {{description}}.isNotEmpty check. See note below.
                              const StacSizedBox(height: 12),
                              StConditionalContainer(
                                padding: const StacEdgeInsets.all(12),
                                when: '{{completed}}',
                                decorationWhenTrue: StacBoxDecoration(
                                  color: StAppColors.grey2.withOpacity(0.2),
                                  borderRadius: StacBorderRadius.circular(12),
                                ),
                                decorationWhenFalse: StacBoxDecoration(
                                  color: StAppColors.grey2.withOpacity(0.3),
                                  borderRadius: StacBorderRadius.circular(12),
                                ),

                                child: StConditionalWidget(
                                  when: '{{completed}}',
                                  whenTrue: StacText(
                                    data: '{{description}}',
                                    maxLines: 3,
                                    overflow: StacTextOverflow.ellipsis,
                                    style: StacTextStyle(
                                      color: StAppColors.grey1.withOpacity(0.7),
                                      height: 1.4,
                                      decoration:
                                          StacTextDecorationLine.lineThrough,
                                      decorationColor: StAppColors.grey1
                                          .withOpacity(0.5),
                                    ),
                                  ),
                                  whenFalse: StacText(
                                    data: '{{description}}',
                                    maxLines: 3,
                                    overflow: StacTextOverflow.ellipsis,
                                    style: StacTextStyle(
                                      color: StAppColors.grey1,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                enablePagination: true,
                endpoint: '/to-do',
                orderBy: 'serialNumber',
                order: 'ASC',
                onReorder: StacReorderToDoAction(
                  id: '{{id}}',
                  toIndex: '{{newIndex}}',
                ),
              ),
            ),
          ),
        ),
      ],
    ),
    floatingActionButton: StacFloatingActionButton(
      backgroundColor: '#169AB4',
      foregroundColor: '#FFFFFF',
      elevation: 2,
      icon: const StacIcon(icon: StacIcons.add_rounded),
      buttonType: StacFloatingActionButtonType.extended,
      onPressed: StacDialogAction(
        widget: StDialog(
          backgroundColor: StacColors.white,
          insetPadding: StacEdgeInsets.symmetric(horizontal: 20),
          shape: StacRoundedRectangleBorder(
            borderRadius: StacBorderRadius.circular(16),
          ),
          child: StacContainer(
            padding: StacEdgeInsets.all(20),
            child: StacForm(
              autovalidateMode: StacAutovalidateMode.onUserInteraction,
              child: StacColumn(
                spacing: 20,
                mainAxisSize: StacMainAxisSize.min,
                children: [
                  StacText(
                    data: 'Add a new to-do',
                    style: StacThemeData.textTheme.displaySmall,
                  ),
                  StacTextFormField(
                    id: 'title',
                    decoration: StacInputDecoration(
                      labelText: 'Title',
                      enabledBorder: StacInputBorder(
                        borderRadius: StacBorderRadius.circular(10),
                        color: StacColors.grey,
                        type: StacInputBorderType.outlineInputBorder,
                      ),
                    ),
                    validatorRules: [
                      StacFormFieldValidator(
                        rule: 'isLength',
                        options: {'min': 1},
                        message: 'Title is required',
                      ),
                      StacFormFieldValidator(
                        rule: 'isLength',
                        options: {'max': 100},
                        message: 'Title must be under 100 characters',
                      ),
                    ],
                  ),
                  StacTextFormField(
                    id: 'description',
                    decoration: StacInputDecoration(
                      labelText: 'Description',
                      enabledBorder: StacInputBorder(
                        borderRadius: StacBorderRadius.circular(10),
                        color: StacColors.grey,
                        type: StacInputBorderType.outlineInputBorder,
                      ),
                    ),
                    maxLines: 3,
                    validatorRules: [
                      StacFormFieldValidator(
                        rule: 'isLength',
                        options: {'min': 1},
                        message: 'Please enter a description',
                      ),
                      StacFormFieldValidator(
                        rule: 'isLength',
                        options: {'max': 500},
                        message: 'Description must be under 500 characters',
                      ),
                    ], // no min — description stays optional
                  ),
                  StMainButton(
                    onPressed: const StCreateToDoAction(),
                    showLoader: true,
                    title: 'Create',
                  ),
                  StMainButton(
                    onPressed: StacNavigator.pop(),
                    textColor: StacColors.black,
                    color: StacColors.white,
                    borderSide: StacBorderSide(color: StacColors.black),
                    title: 'Cancel',
                  ),
                ],
              ),
            ),
          ),
        ).toJson(),
      ),
      child: StacText(
        data: 'Add To Do',
        style: StacTextStyle(fontWeight: StacFontWeight.w600),
      ),
    ),
  );
}
