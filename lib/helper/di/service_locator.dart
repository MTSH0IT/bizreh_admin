import 'package:bizreh_admin/services/products_sku_service.dart';
import 'package:bizreh_admin/helper/dioApiService/dio_client.dart';
import 'package:bizreh_admin/helper/dioApiService/dio_client_adapter.dart';
import 'package:bizreh_admin/helper/dioApiService/i_api_client.dart';
import 'package:bizreh_admin/helper/di/token_provider.dart';
import 'package:bizreh_admin/services/ads_service.dart';
import 'package:bizreh_admin/services/auth_service.dart';
import 'package:bizreh_admin/services/brands_service.dart';
import 'package:bizreh_admin/services/category_service.dart';
import 'package:bizreh_admin/services/cities_service.dart';
import 'package:bizreh_admin/services/collections_service.dart';
import 'package:bizreh_admin/services/color_servise.dart';
import 'package:bizreh_admin/services/discounts_service.dart';
import 'package:bizreh_admin/services/driver_service.dart';
import 'package:bizreh_admin/services/gifts_service.dart';
import 'package:bizreh_admin/services/notification_service.dart';
import 'package:bizreh_admin/services/offers_cart_service.dart';
import 'package:bizreh_admin/services/option_packaging_servise.dart';
import 'package:bizreh_admin/services/orders_service.dart';
import 'package:bizreh_admin/services/packaging_service.dart';
import 'package:bizreh_admin/services/payment_service.dart';
import 'package:bizreh_admin/services/points_service.dart';
import 'package:bizreh_admin/services/product_top_selling.dart';
import 'package:bizreh_admin/services/products_option_service.dart';
import 'package:bizreh_admin/services/products_service.dart';
import 'package:bizreh_admin/services/profile_service.dart';
import 'package:bizreh_admin/services/sub_category_service.dart';
import 'package:bizreh_admin/services/super_category_service.dart';
import 'package:bizreh_admin/services/suppliers_service.dart';
import 'package:bizreh_admin/services/user_gifts_service.dart';
import 'package:bizreh_admin/services/users_service.dart';
import 'package:bizreh_admin/utils/storageService/storage_service.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // 1. Register Storage and Token Provider first
  sl.registerLazySingleton<StorageService>(() => StorageService());
  sl.registerLazySingleton<ITokenProvider>(
    () => TokenProvider(storageService: sl<StorageService>()),
  );

  // 2. Register Core Dio Client
  sl.registerLazySingleton<DioClient>(
    () => DioClient(tokenProvider: sl<ITokenProvider>()),
  );

  // 3. Register IApiClient Adapter
  sl.registerLazySingleton<IApiClient>(() => DioClientAdapter(sl<DioClient>()));
  sl.registerLazySingleton<CategoryService>(
    () => CategoryService(apiClient: sl<IApiClient>()),
  );
  sl.registerLazySingleton<AuthService>(
    () => AuthService(apiClient: sl<IApiClient>()),
  );
  sl.registerLazySingleton<ProductsService>(
    () => ProductsService(apiClient: sl<IApiClient>()),
  );
  sl.registerLazySingleton<BrandsService>(
    () => BrandsService(apiClient: sl<IApiClient>()),
  );
  sl.registerLazySingleton<SubCategoryService>(
    () => SubCategoryService(apiClient: sl<IApiClient>()),
  );
  sl.registerLazySingleton<SuperCategoryService>(
    () => SuperCategoryService(apiClient: sl<IApiClient>()),
  );
  sl.registerLazySingleton<AdsService>(
    () => AdsService(apiClient: sl<IApiClient>()),
  );
  sl.registerLazySingleton<CitiesService>(
    () => CitiesService(apiClient: sl<IApiClient>()),
  );
  sl.registerLazySingleton<CollectionsService>(
    () => CollectionsService(apiClient: sl<IApiClient>()),
  );
  sl.registerLazySingleton<ColorService>(
    () => ColorService(apiClient: sl<IApiClient>()),
  );
  sl.registerLazySingleton<DiscountsService>(
    () => DiscountsService(apiClient: sl<IApiClient>()),
  );
  sl.registerLazySingleton<DriverService>(
    () => DriverService(apiClient: sl<IApiClient>()),
  );
  sl.registerLazySingleton<GiftsService>(
    () => GiftsService(apiClient: sl<IApiClient>()),
  );
  sl.registerLazySingleton<NotificationService>(
    () => NotificationService(apiClient: sl<IApiClient>()),
  );
  sl.registerLazySingleton<OffersCartService>(
    () => OffersCartService(apiClient: sl<IApiClient>()),
  );
  sl.registerLazySingleton<OptionPackagingService>(
    () => OptionPackagingService(apiClient: sl<IApiClient>()),
  );
  sl.registerLazySingleton<OrdersService>(
    () => OrdersService(apiClient: sl<IApiClient>()),
  );
  sl.registerLazySingleton<PackagingService>(
    () => PackagingService(apiClient: sl<IApiClient>()),
  );
  sl.registerLazySingleton<PaymentService>(
    () => PaymentService(apiClient: sl<IApiClient>()),
  );
  sl.registerLazySingleton<PointsService>(
    () => PointsService(apiClient: sl<IApiClient>()),
  );
  sl.registerLazySingleton<ProductTopSellingService>(
    () => ProductTopSellingService(apiClient: sl<IApiClient>()),
  );
  sl.registerLazySingleton<ProductsSkuService>(
    () => ProductsSkuService(apiClient: sl<IApiClient>()),
  );
  sl.registerLazySingleton<ProductsOptionService>(
    () => ProductsOptionService(apiClient: sl<IApiClient>()),
  );
  sl.registerLazySingleton<ProfileService>(
    () => ProfileService(apiClient: sl<IApiClient>()),
  );
  sl.registerLazySingleton<SuppliersService>(
    () => SuppliersService(apiClient: sl<IApiClient>()),
  );
  sl.registerLazySingleton<UserGiftsService>(
    () => UserGiftsService(apiClient: sl<IApiClient>()),
  );
  sl.registerLazySingleton<UsersService>(
    () => UsersService(apiClient: sl<IApiClient>()),
  );
}
