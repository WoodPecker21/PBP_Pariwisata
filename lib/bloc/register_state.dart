import 'package:ugd1/bloc/form_submission_state.dart';

class RegisterState {
  final bool isPasswordVisible;
  final FormSubmissionState formSubmissionState;

  RegisterState({
    this.isPasswordVisible = false,
    this.formSubmissionState = const InitialFormState(),
  });

  RegisterState copyWith({
    bool? isPasswordVisible,
    FormSubmissionState? formSubmissionState,
  }) {
    return RegisterState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      formSubmissionState: formSubmissionState ?? this.formSubmissionState,
    );
  }
}
