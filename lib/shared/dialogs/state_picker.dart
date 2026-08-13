import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smoketrees_app_template/core/models/states.dart';
import 'package:smoketrees_app_template/theme/colors.dart';
import 'package:smoketrees_app_template/theme/decorations.dart';

import '../../../utils/utils.dart';

Future<bool?> showStatePicker({
  required BuildContext context,
  ValueChanged<States>? onSelect,
}) async {
  return await showDialog(
    context: context,
    barrierDismissible: true,
    useRootNavigator: false,
    builder: (_) => StatePicker(onSelect: onSelect),
  );
}

class StatePicker extends StatefulWidget {
  const StatePicker({super.key, this.onSelect});

  final ValueChanged<States>? onSelect;

  @override
  State<StatePicker> createState() => _StatePickerState();
}

class _StatePickerState extends State<StatePicker> {
  ScrollController scrollController = ScrollController();
  List<States> stateList = getStates();
  List<States> filterStateList = getStates();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          20.h,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: TextField(
              style: Get.textTheme.bodyMedium?.copyWith(color: Colors.black),
              cursorColor: AppColors.dark,
              decoration: InputDecoration(
                labelText: "Search",
                hintStyle: Get.textTheme.bodyMedium?.copyWith(
                  color: AppColors.dark.withValues(alpha: 0.5),
                ),
                hintText: "Search",
                labelStyle: Get.textTheme.bodyMedium?.copyWith(
                  color: AppColors.dark.withValues(alpha: 0.5),
                ),
                prefixIcon: const Icon(Icons.search, color: AppColors.dark),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                border: AppDecorations.filledInputDecoration,
                enabledBorder: AppDecorations.filledInputDecoration,
                focusedBorder: AppDecorations.filledInputDecoration,
              ),
              onChanged: (val) {
                if (val.isEmpty) {
                  filterStateList = stateList;
                  setState(() {});
                  return;
                }
                filterStateList = stateList
                    .where(
                      (element) => element.name!.toLowerCase().contains(
                        val.toLowerCase(),
                      ),
                    )
                    .toList();

                setState(() {});
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: filterStateList.length,
              itemBuilder: (context, index) {
                States states = filterStateList[index];
                return InkWell(
                  onTap: () {
                    widget.onSelect!(states);
                    Get.back();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            "${states.code}",
                            style: Get.textTheme.bodyMedium?.copyWith(),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Text(
                            states.name!,
                            style: Get.textTheme.bodyMedium?.copyWith(
                              color: AppColors.dark.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
