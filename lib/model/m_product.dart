// ignore_for_file: public_member_api_docs, sort_constructors_first



import 'package:hive/hive.dart';


part 'm_product.g.dart';

@HiveType(typeId: 4)
class MProduct extends HiveObject {
  @HiveField(0)
  String? productname;
  @HiveField(1)
  List<String>? description;
  @HiveField(2)
  int? price;

  MProduct({
    this.productname,
    this.description,
    this.price,
  });

}
