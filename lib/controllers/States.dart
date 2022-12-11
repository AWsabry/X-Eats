abstract class XeatsStates {}

class SuperXeats extends XeatsStates {}

class SuperXeatsOff extends SuperXeats {
  final bool isPassword;

  SuperXeatsOff(this.isPassword);
}

class ChangeSuccefully extends SuperXeats {}

class ShoowLabel extends SuperXeats {}

class ProductsLoading extends SuperXeats {}

class ProductsSuccess extends SuperXeats {}

class ProductsFail extends SuperXeats {
  final String error;

  ProductsFail(this.error);
}

class AddQuantity extends SuperXeats {}

class RemoveQuantity extends SuperXeats {}

class LoadedCartItems extends SuperXeats {}

class SetTiming extends SuperXeats {}
