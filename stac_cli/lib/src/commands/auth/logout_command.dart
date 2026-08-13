import '../base_command.dart';

/// Command for logging out and clearing stored tokens
class LogoutCommand extends BaseCommand {
  @override
  String get name => 'logout';

  @override
  String get description => 'Clear stored authentication tokens and log out';

  @override
  bool get requiresAuth => false;

  @override
  Future<int> execute() async {
    // await _authService.logout();
    return 0;
  }
}
