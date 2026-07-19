class ApiEndpoint {
  static const String baseUrl =
      "https://phpstack-1546924-5983780.cloudwaysapps.com";

  // Auth
  static const String login = "/admin/profile/login";
  static const String forgetPassword = "/admin/profile/forget-password";

  // Brands
  static const String getBrands = "/admin/brand";
  static String getBrandProducts(int id) => "/admin/brand/$id/products";
  static const String createBrand = "/admin/brand";
  static String updateBrand(int id) => "/admin/brand/$id";
  static String deleteBrand(int id) => "/admin/brand/$id";

  // Super Categories
  static const String getSuperCategories = "/admin/category/super-categories";
  static const String createSuperCategory = "/admin/category/super-categories";
  static String updateSuperCategory(int id) =>
      "/admin/category/super-categories/$id";
  static String deleteSuperCategory(int id) =>
      "/admin/category/super-categories/$id";

  // Categories
  static String getCategories(int id) => "/admin/category/categories/$id";
  static const String getAllCategories = "/admin/category/categories";
  static const String createCategory = "/admin/category/categories";
  static String updateCategory(int id) => "/admin/category/categories/$id";
  static String deleteCategory(int id) => "/admin/category/categories/$id";

  // Sub Category
  static String getSubCategories(int id) =>
      "/admin/category/sub-categories/$id";
  static const String createSubCategory = "/admin/category/sub-categories";
  static String updateSubCategory(int id) =>
      "/admin/category/sub-categories/$id";
  static String deleteSubCategory(int id) =>
      "/admin/category/sub-categories/$id";
  static const String getAllSubCategory = "/admin/category/sub-categories";

  // Products
  static String getProducts = "/admin/product";
  static String createProducts = "/admin/product";
  static String deleteProducts(int id) => "/admin/product/$id";
  static String updateProducts(int id) => "/admin/product/$id";

  // Products option
  static String createProductOption = "/admin/product/option";
  static String updateProductOption(int id) => "/admin/product/option/$id";
  static String deleteProductOption(int id) => "/admin/product/option/$id";

  // Option-Packaging
  static const String getOptionPackagings = "/admin/product/option_packaging";
  static String createOptionPackaging = "/admin/product/option-packaging";
  static String updateOptionPackaging(int id) =>
      "/admin/product/option-packaging/$id";
  static String deleteOptionPackaging(int id) =>
      "/admin/product/option-packaging/$id";
  static String updateOptionPackagingSku(int id) =>
      "/admin/product/option-packaging/$id/sku";

  // Color Family
  static String getColorFamily = "/admin/product/color-family";
  static String createColerFamily = "/admin/product/color-family";
  static String updateColorFamily(int id) => "/admin/product/color-family/$id";
  static String deleteColerFamily(int id) => "/admin/product/color-family/$id";

  // Packagings
  static String getPackagings = "/admin/product/packagings";
  static String createPackaging = "/admin/product/packaging";
  static String updatePackaging(int id) => "/admin/product/packaging/$id";
  static String deletePackaging(int id) => "/admin/product/packaging/$id";

  // Product Top Selling
  static String getTopSellingProducts = "/admin/product/top-selling";
  static String createTopSellingProduct = "/admin/product/top-selling";
  static String deleteTopSellingProduct(int id) =>
      "/admin/product/top-selling/$id";

  // Driver
  static String getDrivers = "/admin/driver";
  static String createDriver = "/admin/driver";
  static String changeDriverStatus(int id) => "/admin/driver/$id/status";
  static String deleteDriver(int id) => "/admin/driver/$id";

  // Orders
  static const String getOrders = "/admin/order";
  static String assignOrderDriver(int id) => "/admin/order/$id/assign";
  static String changeOrderStatus(int id) => "/admin/order/$id/status";
  static String getOrder(int id) => "/admin/order/$id";

  //profile
  static String getProfile = "/admin/profile";
  static const String changePassword = "/admin/profile/change-password";

  // Address - Cities
  static const String getCities = "/admin/address/cities";
  static const String createCity = "/admin/address/city";
  static String updateCity(int id) => "/admin/address/city/$id";
  static String deleteCity(int id) => "/admin/address/city/$id";

  // Suppliers
  static const String getSuppliers = "/admin/supplier";
  static const String createSupplier = "/admin/supplier";
  static String updateSupplier(int id) => "/admin/supplier/$id";
  static String deleteSupplier(int id) => "/admin/supplier/$id";

  // Users
  static const String getUsers = "/admin/user";
  static const String createUser = "/admin/user";
  static String updateUser(int id) => "/admin/user/$id";
  static String deleteUser(int id) => "/admin/user/$id";
  static String changeUserStatus(int id) => "/admin/user/$id/status";

  // Notifications
  static const String sendNotification = "/admin/notifications/send";
  static const String sendNotificationAll = "/admin/notifications/sendAll";

  // Discounts
  static const String getDiscounts = "/admin/discount";
  static const String createDiscount = "/admin/discount";
  static String updateDiscount(int id) => "/admin/discount/$id";
  static String deleteDiscount(int id) => "/admin/discount/$id";

  // Points Offers
  static const String getPointsOffers = "/admin/points";
  static const String createPointsOffer = "/admin/points";
  static String updatePointsOffer(int id) => "/admin/points/$id";
  static String deletePointsOffer(int id) => "/admin/points/$id";
  static String getUserPointsHistory(int userId) =>
      "/admin/points/$userId/history";

  // Gifts
  static const String getGifts = "/admin/gift/gifts";
  static const String createGift = "/admin/gift";
  static String updateGift(int id) => "/admin/gift/$id";
  static String deleteGift(int id) => "/admin/gift/$id";

  // User Gifts
  static const String getUserGifts = "/admin/gift/user-gifts";
  static String changeUserGiftStatus(int id) =>
      "/admin/gift/user-gifts/$id/status";

  // Ads
  static const String getAds = "/admin/ads";
  static const String createAd = "/admin/ads";
  static String updateAd(int id) => "/admin/ads/$id";
  static String deleteAd(int id) => "/admin/ads/$id";
  static String changeAdStatus(int id) => "/admin/ads/$id/status";

  // Offers Cart
  static const String getOffersCart = "/admin/offers-cart";
  static const String createOffersCart = "/admin/offers-cart";
  static String updateOffersCart(int id) => "/admin/offers-cart/$id";
  static String deleteOffersCart(int id) => "/admin/offers-cart/$id";
  static String toggleOffersCart(int id) => "/admin/offers-cart/$id/toggle";

  // Collections
  static const String getCollections = "/admin/collection";
  static const String createCollection = "/admin/collection";
  static const String createParentCollection = "/admin/collection/parent";
  static String updateParentCollection(int id) => "/admin/collection/$id";
  static String updateProductsCollection(int id) =>
      "/admin/collection/products/$id";
  static String deleteCollection(int id) => "/admin/collection/$id";

  // Payments
  static const String getPayments = "/admin/payment";
  static const String createPayment = "/admin/payment";
  static String updatePayment(int id) => "/admin/payment/$id";
  static String deletePayment(int id) => "/admin/payment/$id";
  static String getUserReportByYear(int year) =>
      "/admin/payment/user-report/$year";
  static String getPaymentsByUserId(int userId) => "/admin/payment/$userId";
  static String getPaymentsAndOrdersByUserId(int userId) =>
      "/admin/payment/customer-orders/$userId";

  // ... rest of the code remains the same ...
}
