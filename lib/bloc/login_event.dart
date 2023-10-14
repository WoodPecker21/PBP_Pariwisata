abstract class LoginEvent {}

class IsPasswordVisibleChanged extends LoginEvent {}

class FormSubmitted extends LoginEvent {
  String username;
  String password;

  FormSubmitted({required this.username, required this.password});
}

class NavigateToRegistration extends LoginEvent {}


//event utk simpan data/parameter dari Ui, 
//kalau state hanya utk panggil ke UI (?)