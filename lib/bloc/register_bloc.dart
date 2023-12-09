import 'package:flutter_bloc/flutter_bloc.dart';
import 'register_event.dart';
import 'package:ugd1/repository/register_repository.dart';
import 'package:ugd1/bloc/register_state.dart';
import 'package:ugd1/bloc/form_submission_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterRepository registerRepository = RegisterRepository();

  RegisterBloc() : super(RegisterState()) {
    on<IsPasswordVisibleChanged>(
        (event, emit) => _onIsPasswordVisibleChanged(event, emit));
    on<RegisterButtonPressed>((event, emit) => _onFormSubmitted(event, emit));
  }

  void _onIsPasswordVisibleChanged(
      IsPasswordVisibleChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(
      isPasswordVisible: !state.isPasswordVisible,
      formSubmissionState: const InitialFormState(),
    ));
  }

  void _onFormSubmitted(
      RegisterButtonPressed event, Emitter<RegisterState> emit) async {
    emit(state.copyWith(formSubmissionState: FormSubmitting()));
    try {
      await registerRepository.register(
          event.username,
          event.email,
          event.password,
          event.phoneNumber,
          event
              .birthDate); //-------------------------------ganti dengan register_repo dan methodnya
      emit(state.copyWith(formSubmissionState: SubmissionSuccess()));
    } on FailedRegister catch (e) {
      emit(state.copyWith(
          formSubmissionState: SubmissionFailed(e.errorMessage())));
    } on String catch (e) {
      emit(state.copyWith(formSubmissionState: SubmissionFailed(e.toString())));
    }
  }
}
