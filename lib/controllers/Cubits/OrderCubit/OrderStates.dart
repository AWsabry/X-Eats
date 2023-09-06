abstract class OrderStates {}

class SuperOrderStates extends OrderStates {}

class ButtonPressedLoading extends SuperOrderStates {}

class GetDeliveryFeesState extends SuperOrderStates {}

class AddQuantity extends SuperOrderStates {}

class RemoveQuantity extends SuperOrderStates {}

class LoadedCartItems extends SuperOrderStates {}

class SuccessGetCartID extends SuperOrderStates {}

class FailedGetCartID extends SuperOrderStates {}

class GetLocationsStatesLoading extends SuperOrderStates {}

class GetLocationsStatesSuccessfuly extends SuperOrderStates {}

class GetLocationNamesStatesSuccefully extends SuperOrderStates {}

class ChangeLocationStatesSuccefullty extends SuperOrderStates {}

class getRestuarantSlugStateLoading extends SuperOrderStates {}

class getTimeStateLoading extends SuperOrderStates {}

class getTimeStateSuccess extends SuperOrderStates {}

class getDeliveryFeesLoadingState extends SuperOrderStates {}

class getDeliveryFeesState extends SuperOrderStates {}

class getDeliveryFeesStateError extends SuperOrderStates {
  final String error;

  getDeliveryFeesStateError(this.error);
}

class getTimePublicStateSuccess extends SuperOrderStates {}

class confirmOrderPressedState extends SuperOrderStates {}

class getTimeStateFailier extends SuperOrderStates {
  final String error;
  getTimeStateFailier(this.error);
}

class getRestuarantsOfSlugStates extends SuperOrderStates {}

class pressedState extends SuperOrderStates {}

class confirmOrderAfter20MinutesState extends SuperOrderStates {}

class confirmOrderBefore20MinutesState extends SuperOrderStates {}

class ClickableState extends SuperOrderStates {}

class cancelOrderSuccefull extends SuperOrderStates {}

class cancelOrderError extends SuperOrderStates {
  final String error;

  cancelOrderError(this.error);
}

class timeStartedState extends SuperOrderStates {}

class timeFinishedState extends SuperOrderStates {}

class InitialcheckOrderExistance extends SuperOrderStates {}

class checkOrderExistanceSuccessfuly extends SuperOrderStates {}

class checkOrderExistanceFailed extends SuperOrderStates {
  final String Error;

  checkOrderExistanceFailed(this.Error);
}

class InitialcheckTimeExistence extends SuperOrderStates {}

class OrderExistanceTrue extends SuperOrderStates {}

class OrderExistanceFalse extends SuperOrderStates {}

class RunningBackgroundState extends SuperOrderStates {}

class CompletedBackgroundState extends SuperOrderStates {}
