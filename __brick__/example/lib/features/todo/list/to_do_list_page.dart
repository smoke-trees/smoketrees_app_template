import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:{{project_name}}/shared/snackbars/snackbar.dart';
import 'package:{{project_name}}/theme/colors.dart';
import 'package:{{project_name}}/utils/console_logger.dart';
import 'package:stac/stac.dart';

import '../../../core/controllers/st_data_refresh_controller.dart';
import '../../../core/services/global_service.dart';
import '../../../shared/buttons/main_button.dart';
import '../../../shared/fields/custom_text_field.dart';
import '../../../utils/utils.dart';
import '../../auth/user_controller.dart';
import '../tile/to_do_tile.dart';
import '../to_do.dart';
import '../to_do_controller.dart';
import 'stac/to_do_list_model.dart';

enum ToDoFilter { all, completed, incomplete }

/// GetX controller owning all reactive state for [ToDoListPage].
/// Put in `initState` and deleted in `dispose` so it's scoped to the page.
class ToDoListController extends GetxController {
  static ToDoListController get to => Get.find();
  final ToDoController _toDoController = Get.isRegistered<ToDoController>()
      ? ToDoController.to
      : Get.put(ToDoController(), permanent: true);

  final ScrollController scrollController = ScrollController();

  final Rx<ToDoFilter> filter = ToDoFilter.all.obs;

  /// Extra query params sent to the endpoint for the current filter.
  /// Adjust the key/values to match what your `/to-do` endpoint expects.
  Map<String, dynamic> get queryParams {
    switch (filter.value) {
      case ToDoFilter.completed:
        return {'completed': true};
      case ToDoFilter.incomplete:
        return {'completed': false};
      case ToDoFilter.all:
        return {};
    }
  }

  void setFilter(ToDoFilter value) {
    if (filter.value == value) return;
    filter.value = value;
  }

  final RxList<ToDo> todos = <ToDo>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isInitialLoading = true.obs;
  final RxBool hasMore = true.obs;

  int _page = 1;
  static const int _pageSize = 20;

  String get userId => UserController.to.user?.id ?? '';

  List<ToDo> get sortedToDos {
    final list = [...todos];
    list.sort((a, b) {
      final aNum = a.serialNumber ?? 0;
      final bNum = b.serialNumber ?? 0;
      return aNum.compareTo(bNum);
    });
    return list;
  }

  List<ToDo> get displayedToDos {
    final sorted = sortedToDos;
    switch (filter.value) {
      case ToDoFilter.all:
        return sorted;
      case ToDoFilter.completed:
        return sorted.where((todo) => todo.completed == true).toList();
      case ToDoFilter.incomplete:
        return sorted.where((todo) => todo.completed != true).toList();
    }
  }

  int get completedCount =>
      todos.where((todo) => todo.completed == true).length;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    loadToDos(reset: true);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 100) {
      loadToDos();
    }
  }

  /// Fetches to-dos from the server.
  /// [reset] restarts from page 1. [silent] skips the full-screen loader,
  /// useful for refreshing in the background (e.g. after a reorder).
  Future<void> loadToDos({bool reset = false, bool silent = false}) async {
    if (isLoading.value) return;
    if (!reset && !hasMore.value) return;

    if (reset) {
      if (!silent) isInitialLoading.value = true;
      _page = 1;
      hasMore.value = true;
    } else {
      isLoading.value = true;
    }

    final result = await _toDoController.fetchToDos(
      page: _page,
      count: _pageSize,
    );
    ConsoleLogger.info('Fetched ${result.length} To Dos');

    if (reset) {
      todos.assignAll(result);
    } else {
      todos.addAll(result);
    }
    ConsoleLogger.info(
      'Loaded ${result.length} To Dos, total: ${todos.length}',
    );
    hasMore.value = result.length == _pageSize;
    _page += 1;
    isInitialLoading.value = false;
    isLoading.value = false;
  }

  void onFilterChanged(ToDoFilter newFilter) {
    if (filter.value == newFilter) return;
    filter.value = newFilter;
    if (scrollController.hasClients) {
      scrollController.jumpTo(0);
    }
  }

  /// Reorders locally for a smooth drag animation, tells the server about
  /// the new position, then always refetches so the list reflects the
  /// server's authoritative ordering.
  Future<void> onReorder(int oldIndex, int newIndex) async {
    final items = sortedToDos;
    final moved = items.removeAt(oldIndex);
    items.insert(newIndex, moved);
    todos.assignAll(items);

    final newSerialNumber = newIndex + 1;
    final response = await _toDoController.reshuffleToDos(
      moved.id ?? '',
      newSerialNumber,
      userId,
    );

    if (response == null || response.status.error) {
      Get.snackbar(
        'Couldn\'t reorder',
        'Please check your connection and try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    await loadToDos(reset: true, silent: true);
  }

  Future<void> onToggleComplete(ToDo todo) async {
    final index = todos.indexWhere((t) => t.id == todo.id);
    if (index == -1) return;

    final previous = todo.completed == true;
    todo.completed = !previous;
    todos[index] = todo;

    final result = await _toDoController.updateToDo(
      id: todo.id ?? '',
      userId: userId,
      completed: todo.completed,
    );

    if (result == null || result.status.error) {
      todo.completed = previous;
      todos[index] = todo;

      AppSnackBars.customSnackBar(
        context: Get.context!,
        message: 'Couldn\'t update to-do',
      );
      return;
    }
    StDataRefreshController.to.notifyItemUpdated(todo.id, {
      'completed': todo.completed,
    });
  }

  Future<void> onDeleteToDo(ToDo todo) async {
    final index = todos.indexWhere((t) => t.id == todo.id);
    if (index == -1) return;

    final removed = todos.removeAt(index);

    final result = await _toDoController.deleteToDo(removed.id ?? '');

    if (result == null || result.status.error) {
      todos.insert(index, removed);
      AppSnackBars.customSnackBar(
        context: Get.context!,
        message: 'Couldn\'t delete to-do',
      );
      return;
    }
    StDataRefreshController.to.notifyItemDeleted(removed.id);
  }

  Future<void> createToDo({
    required String title,
    required String description,
  }) async {
    final id = await _toDoController.createToDo(
      userId: userId,
      title: title,
      description: description,
    );

    if (id == null) {
      Get.snackbar(
        'Couldn\'t add to-do',
        'Please check your connection and try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    await loadToDos(reset: true);
  }
}

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({
    super.key,
    required this.appBarTitle,
    required this.toDoTileModel,
  });

  final String appBarTitle;
  final ToDoTileModel toDoTileModel;

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  late final ToDoListController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ToDoListController());
  }

  @override
  void dispose() {
    Get.delete<ToDoListController>();
    super.dispose();
  }

  Future<void> _openAddToDoDialog() async {
    // ConsoleLogger.debug(
    //   StacScaffold(
    //     body: StacCenter(
    //       child: StacText(data: 'Search', style: StacTextStyle(fontSize: 24)),
    //     ),
    //   ).toJson().toString(),
    // );

    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        insetPadding: 20.hp,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: 20.p,
          child: Column(
            spacing: 20,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add a new to-do',
                style: GlobalService.to.textTheme(context).headlineMedium,
              ),
              CustomTextField(
                controller: titleController,
                labelText: 'Title',
                hintText: 'Enter a title',
                validator: (p0) {
                  if (p0?.isEmpty ?? true) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              CustomTextField(
                controller: descriptionController,
                labelText: 'Description',
                hintText: 'Enter a description',
                maxLines: 5,
                validator: (p0) {
                  if (p0?.isEmpty ?? true) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              MainButton(
                onTap: () async {
                  await controller.createToDo(
                    title: titleController.text,
                    description: descriptionController.text,
                  );
                  await Stac.onCallFromJson(
                    StacNavigator.pop().toJson(),
                    context,
                  );
                },
                showLoader: true,
                title: 'Create',
              ),
              MainButton(
                onTap: () {
                  Stac.onCallFromJson(StacNavigator.pop().toJson(), context);
                },
                textColor: Colors.black,
                color: Colors.white,
                borderSide: BorderSide(color: Colors.black),
                title: 'Cancel',
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey2.withOpacity(0.08),
      appBar: AppBar(
        title: Text(
          widget.appBarTitle,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: Obx(
        () => Column(
          children: [
            if (!controller.isInitialLoading.value &&
                controller.todos.isNotEmpty)
              _buildProgressHeader(),
            _buildFilterBar(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                child: _buildBody(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddToDoDialog(),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.textWhite,
        elevation: 2,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Add To Do',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildProgressHeader() {
    final total = controller.todos.length;
    final completed = controller.completedCount;
    final progress = total == 0 ? 0.0 : completed / total;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$completed of $total completed',
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: AppColors.grey2.withOpacity(0.4),
                    valueColor: AlwaysStoppedAnimation(AppColors.primaryColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Text(
              '${(progress * 100).round()}%',
              style: Get.textTheme.labelSmall?.copyWith(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          _buildFilterChip(ToDoFilter.all, 'All'),
          const SizedBox(width: 8),
          _buildFilterChip(ToDoFilter.completed, 'Completed'),
          const SizedBox(width: 8),
          _buildFilterChip(ToDoFilter.incomplete, 'Incomplete'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(ToDoFilter filterValue, String label) {
    final isSelected = controller.filter.value == filterValue;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => controller.onFilterChanged(filterValue),
      selectedColor: AppColors.primaryColor,
      backgroundColor: Colors.white,
      labelStyle: Get.textTheme.labelLarge?.copyWith(
        color: isSelected ? AppColors.textWhite : AppColors.grey1,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? AppColors.primaryColor : AppColors.grey2,
        ),
      ),
      showCheckmark: false,
      elevation: 0,
      pressElevation: 0,
    );
  }

  Widget _buildBody() {
    if (controller.isInitialLoading.value) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.primaryColor),
      );
    }
    if (controller.todos.isEmpty) {
      return _buildEmptyState();
    }
    if (controller.displayedToDos.isEmpty) {
      return _buildFilteredEmptyState();
    }
    return _buildList();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.checklist_rounded,
              size: 44,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No To Dos yet',
            style: Get.textTheme.titleMedium?.copyWith(
              color: AppColors.textDark,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Create your first to-do to get started.',
            textAlign: TextAlign.center,
            style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.grey1),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 200,
            child: FilledButton.icon(
              onPressed: () => _openAddToDoDialog(),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: AppColors.textWhite,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.add_rounded),
              label: const Text(
                'Add To Do',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilteredEmptyState() {
    final message = controller.filter.value == ToDoFilter.completed
        ? 'No completed to-dos'
        : 'No incomplete to-dos';
    final subtitle = controller.filter.value == ToDoFilter.completed
        ? 'Finished items will show up here.'
        : 'You\'re all caught up!';
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: AppColors.grey2.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.filter_alt_off_rounded,
              size: 40,
              color: AppColors.grey1,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            message,
            style: Get.textTheme.titleMedium?.copyWith(
              color: AppColors.textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.grey1),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    final items = controller.displayedToDos;

    if (controller.filter.value == ToDoFilter.all) {
      return RefreshIndicator(
        color: AppColors.primaryColor,
        onRefresh: () => controller.loadToDos(reset: true),
        child: ReorderableListView.builder(
          key: ValueKey(controller.filter.value),
          scrollController: controller.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 96, top: 4),
          itemCount: items.length,
          onReorderItem: controller.onReorder,

          itemBuilder: (context, index) {
            final todo = items[index];
            return Padding(
              key: ValueKey(todo.id ?? '$index'),
              padding: const EdgeInsets.only(bottom: 10),
              child: ToDoTile(
                todo: todo,
                serialNumberMarkWidth:
                    widget.toDoTileModel.serialNumberMarkWidth,
                serialNumberMarkHeight:
                    widget.toDoTileModel.serialNumberMarkHeight,
                onToggleComplete: () => controller.onToggleComplete(todo),
                onDelete: () => controller.onDeleteToDo(todo),
              ),
            );
          },
          footer: controller.isLoading.value
              ? Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                      strokeWidth: 2.5,
                    ),
                  ),
                )
              : null,
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primaryColor,
      onRefresh: () => controller.loadToDos(reset: true),
      child: ListView.separated(
        key: ValueKey(controller.filter.value),
        controller: controller.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 4, bottom: 96),
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemCount: items.length + (controller.isLoading.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= items.length) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                  strokeWidth: 2.5,
                ),
              ),
            );
          }
          final todo = items[index];
          return ToDoTile(
            key: ValueKey(todo.id ?? '$index'),
            todo: todo,
            onToggleComplete: () => controller.onToggleComplete(todo),
            onDelete: () => controller.onDeleteToDo(todo),
          );
        },
      ),
    );
  }
}
