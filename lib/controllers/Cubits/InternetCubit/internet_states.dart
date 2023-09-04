abstract class InternetStates {}

class SuperInternetState extends InternetStates {}

class ConnectedState extends SuperInternetState {}

class NotConnectedState extends SuperInternetState {
  final String message;
  NotConnectedState(this.message);
}
