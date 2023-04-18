abstract class OrderStates {}

class SuperOrderStates extends OrderStates {}

class ButtonPressedLoading extends SuperOrderStates {}

class GetDeliveryFeesState extends SuperOrderStates {}

class AddQuantity extends SuperOrderStates {}

class RemoveQuantity extends SuperOrderStates {}

class LoadedCartItems extends SuperOrderStates {}

class SuccessGetCartID extends SuperOrderStates {}

class FailedGetCartID extends SuperOrderStates {}
