import 'package:get/get.dart';
import 'package:bizreh_admin/helper/di/service_locator.dart';
import 'package:bizreh_admin/helper/di/token_provider.dart';
import 'package:bizreh_admin/utils/storageService/storage_service.dart';
import 'package:bizreh_admin/services/auth_service.dart';
import 'package:bizreh_admin/services/products_service.dart';
import 'package:bizreh_admin/services/brands_service.dart';
import 'package:bizreh_admin/services/sub_category_service.dart';
import 'package:bizreh_admin/services/category_service.dart';
import 'package:bizreh_admin/services/super_category_service.dart';
import 'package:bizreh_admin/services/users_service.dart';
import 'package:bizreh_admin/services/notification_service.dart';
import 'package:bizreh_admin/services/profile_service.dart';
import 'package:bizreh_admin/services/cities_service.dart';
import 'package:bizreh_admin/services/collections_service.dart';
import 'package:bizreh_admin/services/orders_service.dart';
import 'package:bizreh_admin/services/driver_service.dart';
import 'package:bizreh_admin/services/suppliers_service.dart';
import 'package:bizreh_admin/services/payment_service.dart';
import 'package:bizreh_admin/services/discounts_service.dart';
import 'package:bizreh_admin/services/gifts_service.dart';
import 'package:bizreh_admin/services/user_gifts_service.dart';
import 'package:bizreh_admin/services/ads_service.dart';
import 'package:bizreh_admin/services/offers_cart_service.dart';
import 'package:bizreh_admin/services/option_packaging_servise.dart';
import 'package:bizreh_admin/services/points_service.dart';
import 'package:bizreh_admin/services/packaging_service.dart';
import 'package:bizreh_admin/services/color_servise.dart';
import 'package:bizreh_admin/services/product_top_selling.dart';

// Auth
import 'package:bizreh_admin/features/auth/controllers/auth_controller.dart';

// Main View
import 'package:bizreh_admin/features/main_view/controllers/main_nav_controller.dart';

// Products & Categories
import 'package:bizreh_admin/features/products/controllers/products_controller.dart';
import 'package:bizreh_admin/features/category/controllers/category_controller.dart';
import 'package:bizreh_admin/features/category/controllers/all_category_crud_controller.dart';
import 'package:bizreh_admin/features/sub_category/controllers/all_sub_category_crud_controller.dart';
import 'package:bizreh_admin/features/super_category/controllers/super_category_controller.dart';

// Brands
import 'package:bizreh_admin/features/Brands/controllers/brands_controler.dart';

// Orders & Payments
import 'package:bizreh_admin/features/orders/controllers/orders_controller.dart';
import 'package:bizreh_admin/features/payment/controllers/payment_controller.dart';
import 'package:bizreh_admin/features/payment/controllers/user_payments_and_orders_controller.dart';
import 'package:bizreh_admin/features/payment/controllers/user_reports_controller.dart';

// Users & Profile
import 'package:bizreh_admin/features/users/controllers/users_controller.dart';
import 'package:bizreh_admin/features/profile/controllers/profile_controller.dart';

// Cities & Collections
import 'package:bizreh_admin/features/cities/controllers/cities_controller.dart';
import 'package:bizreh_admin/features/collections/controllers/collections_controller.dart';

// Colors & Packaging
import 'package:bizreh_admin/features/color_family/controllers/color_family_controller.dart';
import 'package:bizreh_admin/features/packaging/controllers/packaging_controller.dart';
import 'package:bizreh_admin/features/option_packaging/controllers/option_packaging_controller.dart';

// Discounts & Gifts
import 'package:bizreh_admin/features/discounts/controllers/discounts_controller.dart';
import 'package:bizreh_admin/features/gifts/controllers/gifts_controller.dart';
import 'package:bizreh_admin/features/gifts/controllers/user_gifts_controller.dart';

// Points & Ads
import 'package:bizreh_admin/features/points/controllers/points_controller.dart';
import 'package:bizreh_admin/features/ads/controllers/ads_controller.dart';

// Other Features
import 'package:bizreh_admin/features/Driver/controllers/drivers_controller.dart';
import 'package:bizreh_admin/features/offers_cart/controllers/offers_cart_controller.dart';
import 'package:bizreh_admin/features/product_top_silling/controllers/product_top_selling_controller.dart';
import 'package:bizreh_admin/features/suppliers/controllers/suppliers_controller.dart';
import 'package:bizreh_admin/features/sub_category/controllers/sub_category_controler.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Core Services
    Get.lazyPut<ITokenProvider>(() => sl<ITokenProvider>(), fenix: true);
    Get.lazyPut<StorageService>(() => sl<StorageService>(), fenix: true);

    // Auth Controllers
    Get.lazyPut<AuthController>(
      () => AuthController(
        authService: sl<AuthService>(),
        storageService: sl<StorageService>(),
        tokenProvider: sl<ITokenProvider>(),
      ),
      fenix: true,
    );

    // Main View Controllers
    Get.lazyPut<MainNavController>(() => MainNavController(), fenix: true);

    // Product & Category Controllers
    Get.lazyPut<ProductsController>(
      () => ProductsController(
        productsService: sl<ProductsService>(),
        brandsService: sl<BrandsService>(),
        subCategoryService: sl<SubCategoryService>(),
      ),
      fenix: true,
    );

    Get.lazyPut<CategoryController>(
      () => CategoryController(categoryService: sl<CategoryService>()),
      fenix: true,
    );

    Get.lazyPut<AllCategoryCrudController>(
      () => AllCategoryCrudController(
        categoryService: sl<CategoryService>(),
        superCategoryService: sl<SuperCategoryService>(),
      ),
      fenix: true,
    );

    Get.lazyPut<AllSubCategoryCrudController>(
      () => AllSubCategoryCrudController(
        subCategoryService: sl<SubCategoryService>(),
        categoryService: sl<CategoryService>(),
      ),
      fenix: true,
    );

    Get.lazyPut<SuperCategoryController>(
      () => SuperCategoryController(
        superCategoryService: sl<SuperCategoryService>(),
      ),
      fenix: true,
    );

    Get.lazyPut<SubCategoryController>(
      () => SubCategoryController(subCategoryService: sl<SubCategoryService>()),
      fenix: true,
    );

    // Brand Controllers
    Get.lazyPut<BrandsController>(
      () => BrandsController(brandsService: sl<BrandsService>()),
      fenix: true,
    );

    // Order & Payment Controllers
    Get.lazyPut<OrdersController>(
      () => OrdersController(
        ordersService: sl<OrdersService>(),
        driverService: sl<DriverService>(),
      ),
      fenix: true,
    );

    Get.lazyPut<PaymentController>(
      () => PaymentController(service: sl<PaymentService>()),
      fenix: true,
    );

    Get.lazyPut<UserPaymentsAndOrdersController>(
      () => UserPaymentsAndOrdersController(
        paymentService: sl<PaymentService>(),
        ordersService: sl<OrdersService>(),
      ),
      fenix: true,
    );

    Get.lazyPut<UserReportsController>(
      () => UserReportsController(service: sl<PaymentService>()),
      fenix: true,
    );

    // User & Profile Controllers
    Get.lazyPut<UsersController>(
      () => UsersController(
        usersService: sl<UsersService>(),
        notificationService: sl<NotificationService>(),
      ),
      fenix: true,
    );

    Get.lazyPut<ProfileController>(
      () => ProfileController(profileService: sl<ProfileService>()),
      fenix: true,
    );

    // City & Collection Controllers
    Get.lazyPut<CitiesController>(
      () => CitiesController(service: sl<CitiesService>()),
      fenix: true,
    );

    Get.lazyPut<CollectionsController>(
      () => CollectionsController(
        collectionsService: sl<CollectionsService>(),
        productsService: sl<ProductsService>(),
        brandsService: sl<BrandsService>(),
        subCategoryService: sl<SubCategoryService>(),
      ),
      fenix: true,
    );

    // Color & Packaging Controllers
    Get.lazyPut<ColorFamilyController>(
      () => ColorFamilyController(service: sl<ColorService>()),
      fenix: true,
    );

    Get.lazyPut<PackagingController>(
      () => PackagingController(service: sl<PackagingService>()),
      fenix: true,
    );

    Get.lazyPut<OptionPackagingController>(
      () => OptionPackagingController(
        optionPackagingService: sl<OptionPackagingService>(),
        colorService: sl<ColorService>(),
      ),
      fenix: true,
    );

    // Discount & Gift Controllers
    Get.lazyPut<DiscountsController>(
      () => DiscountsController(
        discountsService: sl<DiscountsService>(),
        productsService: sl<ProductsService>(),
        brandsService: sl<BrandsService>(),
        categoryService: sl<CategoryService>(),
        subCategoryService: sl<SubCategoryService>(),
      ),
      fenix: true,
    );

    Get.lazyPut<GiftsController>(
      () => GiftsController(service: sl<GiftsService>()),
      fenix: true,
    );

    Get.lazyPut<UserGiftsController>(
      () => UserGiftsController(service: sl<UserGiftsService>()),
      fenix: true,
    );

    // Points & Ads Controllers
    Get.lazyPut<PointsController>(
      () => PointsController(
        pointsService: sl<PointsService>(),
        brandsService: sl<BrandsService>(),
        packagingService: sl<PackagingService>(),
      ),
      fenix: true,
    );

    Get.lazyPut<AdsController>(
      () => AdsController(
        adsService: sl<AdsService>(),
        productsService: sl<ProductsService>(),
      ),
      fenix: true,
    );

    // Other Feature Controllers
    Get.lazyPut<DriversController>(
      () => DriversController(
        driverService: sl<DriverService>(),
        suppliersService: sl<SuppliersService>(),
      ),
      fenix: true,
    );

    Get.lazyPut<OffersCartController>(
      () => OffersCartController(
        offersCartService: sl<OffersCartService>(),
        productsService: sl<ProductsService>(),
      ),
      fenix: true,
    );

    Get.lazyPut<ProductTopSellingController>(
      () =>
          ProductTopSellingController(service: sl<ProductTopSellingService>()),
      fenix: true,
    );

    Get.lazyPut<SuppliersController>(
      () => SuppliersController(
        suppliersService: sl<SuppliersService>(),
        citiesService: sl<CitiesService>(),
      ),
      fenix: true,
    );
  }
}
