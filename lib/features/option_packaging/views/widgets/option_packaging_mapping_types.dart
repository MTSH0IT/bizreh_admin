import 'package:bizreh_admin/features/packaging/models/package_model.dart';
import 'package:bizreh_admin/features/products/models/product_model/option.dart';

typedef OptionPackagingMapping = ({
  int? id,
  num? price,
  // int? stock,
  int? colorId,
  String? colorDegree,
  String? optionSku,
});

typedef OptionPackagingTapArgs = ({
  Option option,
  PackageModel packaging,
  OptionPackagingMapping? mapping,
});

typedef OptionPackagingTapCallback = void Function(OptionPackagingTapArgs args);
