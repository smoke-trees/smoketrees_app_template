import 'package:mason/mason.dart';

void run(HookContext context) {
  // Pre-generation hook - can be used for validation or setup
  context.logger.info('Pre-generation hook running...');
}
