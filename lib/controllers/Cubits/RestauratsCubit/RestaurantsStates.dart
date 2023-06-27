abstract class RestuarantsStates {}

class SuperRestuarantsStates extends RestuarantsStates {}

class ClearRestaurantsSearchList extends SuperRestuarantsStates {}

class RestaurantsListLoading extends SuperRestuarantsStates {}

class RestaurantsListSuccess extends SuperRestuarantsStates {}

class RestaurantsListFail extends SuperRestuarantsStates {
  final String error;

  RestaurantsListFail(this.error);
}

class GetListOfProductsSuccefully extends SuperRestuarantsStates {}

class RestaurantsFounded extends SuperRestuarantsStates {}

class RestaurantIdFail extends SuperRestuarantsStates {
  final String error;
  RestaurantIdFail(this.error);
}

class SearhOnRestaurantSuccessfull extends SuperRestuarantsStates {}

class SearchOnRestaurantFail extends SuperRestuarantsStates {
  final String error;

  SearchOnRestaurantFail(this.error);
}

class ClearRestaurantId extends SuperRestuarantsStates {}

class GetListOfRestaurantsSuccefully extends SuperRestuarantsStates {}

class LoadingSearchingState extends SuperRestuarantsStates {}
