class ApiEndpoint {
  static const String baseUrl =
      "https://phpstack-1546924-5983780.cloudwaysapps.com";

  // Auth
  static const String login = "/admin/profile/login";

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

  // Driver
  static String getDrivers = "/admin/driver";
  static String createDriver = "/admin/driver";
  static String changeDriverStatus(int id) => "/admin/driver/$id/status";
  static String deleteDriver(int id) => "/admin/driver/$id";

  //profile
  static String getProfile = "/admin/profile";
}
