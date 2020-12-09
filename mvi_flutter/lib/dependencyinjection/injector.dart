import 'package:kiwi/kiwi.dart';
import 'package:repository/repository.dart';
import 'package:shop_repository_core/shop_repository_core.dart';

part 'injector.g.dart';

abstract class Injector {
  @Register.singleton(Auth, from: AuthImpl)
  @Register.singleton(ReactiveProductsRepositoryImpl)
  void configure();

  static void setup() {
    var injector = _$Injector();
    injector.configure();
  }
}
