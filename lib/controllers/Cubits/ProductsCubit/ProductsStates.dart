abstract class ProductsStates {}

class SuperProductsStates extends ProductsStates {}

class ProductsLoading extends SuperProductsStates {}

class ProductsSuccess extends SuperProductsStates {}

class ProductsFail extends SuperProductsStates {
  final String error;

  ProductsFail(this.error);
}

class SearhOnProductSuccessfull extends SuperProductsStates {}

class ProductIdSuccefull extends SuperProductsStates {}

class SearhOnProductFail extends SuperProductsStates {
  final String error;

  SearhOnProductFail(this.error);
}

class ClearProductId extends SuperProductsStates {}

class ChangePrivacytoPublic extends SuperProductsStates {}
