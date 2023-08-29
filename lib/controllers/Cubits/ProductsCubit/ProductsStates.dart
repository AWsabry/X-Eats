abstract class ProductsStates {}

class SuperProductsStates extends ProductsStates {}

class ProductsLoading extends SuperProductsStates {}

class MostSoldProductsStateSuccessfull extends SuperProductsStates {}

class NewProductsStateSuccessfull extends SuperProductsStates {}

class getPosterStateSuccessfull extends SuperProductsStates {}

class ProductsFail extends SuperProductsStates {
  final String error;

  ProductsFail(this.error);
}

class ProductSearchSuccess extends SuperProductsStates {}

class GetCurrentProductsSuccessful extends SuperProductsStates {}

class GetCategoryByIdSuccefull extends SuperProductsStates {}

class ProductIdSuccessful extends SuperProductsStates {}

class ProductSearchFail extends SuperProductsStates {
  final String error;

  ProductSearchFail(this.error);
}

class ClearProductId extends SuperProductsStates {}

class ChangePrivacytoPublic extends SuperProductsStates {}

class mostSoldProductsStateLoading extends SuperProductsStates {}

class newProductsStateLoading extends SuperProductsStates {}

class newProductsStateFailed extends SuperProductsStates {
  final String error;

  newProductsStateFailed(this.error);
}
