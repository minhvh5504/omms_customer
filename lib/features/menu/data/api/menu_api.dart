import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'menu_api.g.dart';

@RestApi()
abstract class MenuApi {
  factory MenuApi(Dio dio) = _MenuApi;

  @GET('menu/categories')
  Future<dynamic> getCategories();

  @GET('menu/dishes')
  Future<dynamic> getDishes(@Queries() Map<String, dynamic> queries);
}
