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
}
