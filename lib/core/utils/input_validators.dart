class InputValidators {
  const InputValidators._();

  static String? email(String value) {
    if (value.trim().isEmpty) {
      return 'Email is required.';
    }

    final isValid = RegExp(
      r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(value.trim());

    if (!isValid) {
      return 'Enter a valid email.';
    }

    return null;
  }

  static String? password(String value) {
    if (value.trim().isEmpty) {
      return 'Password is required.';
    }

    if (value.trim().length < 6) {
      return 'Use at least 6 characters.';
    }

    return null;
  }

  static String? taskTitle(String value) {
    if (value.trim().isEmpty) {
      return 'Task title is required.';
    }

    return null;
  }
}
