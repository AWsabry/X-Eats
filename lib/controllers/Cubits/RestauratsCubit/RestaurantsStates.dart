abstract class RestuarantsStates {}

class SuperRestuarantsStates extends RestuarantsStates {}

class ClearRestaurantsIdState extends SuperRestuarantsStates {}

class RestaurantsListLoading extends SuperRestuarantsStates {}

class RestaurantsListSuccess extends SuperRestuarantsStates {}

class RestaurantsListFail extends SuperRestuarantsStates {
  final String error;

  RestaurantsListFail(this.error);
}

class GetListOfProductsSuccefully extends SuperRestuarantsStates {}

class RestaurantIdSuccefull extends SuperRestuarantsStates {}

class SearhOnRestaurantSuccessfull extends SuperRestuarantsStates {}

class SearchOnRestaurantFail extends SuperRestuarantsStates {
  final String error;

  SearchOnRestaurantFail(this.error);
}

class ClearRestaurantId extends SuperRestuarantsStates {}

class GetListOfRestaurantsSuccefully extends SuperRestuarantsStates {}
