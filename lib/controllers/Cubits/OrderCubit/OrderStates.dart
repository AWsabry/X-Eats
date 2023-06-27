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

class getRestuarantsOfSlugStates extends SuperOrderStates {}

class pressedState extends SuperOrderStates {}
