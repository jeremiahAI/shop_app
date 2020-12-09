import 'package:kiwi/kiwi.dart';
import 'package:repository/repository.dart';

abstract class Injector {
  @Register.singleton(AuthImpl)
  @Register.singleton(ReactiveProductsRepositoryImpl)
  void configure();
}
