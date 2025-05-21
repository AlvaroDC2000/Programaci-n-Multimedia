import 'package:googleapis/tasks/v1.dart' as gt;
import 'package:http/http.dart' as http;

class GoogleTasksService {
  final gt.TasksApi _tasksApi;

  GoogleTasksService(http.Client client)
      : _tasksApi = gt.TasksApi(client);

  Future<gt.TaskList> crearLista(String titulo) async {
    final taskList = gt.TaskList(title: titulo);
    return await _tasksApi.tasklists.insert(taskList);
  }

  Future<void> eliminarLista(String taskListId) async {
    await _tasksApi.tasklists.delete(taskListId);
  }

  Future<gt.Task> crearTarea({
    required String taskListId,
    required String titulo,
    String? notas,
    DateTime? fechaHora,
  }) async {
    final task = gt.Task(
      title: titulo,
      notes: notas,
      due: fechaHora?.toUtc().toIso8601String(),
    );
    return await _tasksApi.tasks.insert(task, taskListId);
  }

  Future<void> eliminarTarea(String taskListId, String taskId) async {
    await _tasksApi.tasks.delete(taskListId, taskId);
  }

  Future<List<gt.TaskList>> obtenerListas() async {
    final result = await _tasksApi.tasklists.list();
    return result.items ?? [];
  }

  Future<List<gt.Task>> obtenerTareas(String taskListId, {required bool showCompleted}) async {
    final result = await _tasksApi.tasks.list(taskListId);
    return result.items ?? [];
  }

  Future<void> completarTarea(String taskListId, String taskId, gt.Task completedTask) async {
  await _tasksApi.tasks.patch(completedTask, taskListId, taskId);
}

  Future<gt.Task> actualizarTarea({
  required String taskListId,
  required String taskId,
  required String titulo,
  String? notas,
  DateTime? fechaHora,
}) async {
  final updatedTask = gt.Task(
    title: titulo,
    notes: notas,
    due: fechaHora?.toUtc().toIso8601String(),
  );

  return await _tasksApi.tasks.patch(updatedTask, taskListId, taskId);
}
}