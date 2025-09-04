class server {
  final String host = 'https://adminmarket.tubinnews.com/api/';
}

class Link {
  //login----------------------------------------------------------------------
  final Uri POST_login = Uri.parse(server().host + 'auth/login');
  final Uri POST_register = Uri.parse(server().host + 'auth/register');

  GET_User(id) {
    return Uri.parse(server().host + 'user/detail?id=$id');
  }

  final Uri GET_province = Uri.parse(server().host + 'region/province');

  Uri GET_regency(int province) {
    return Uri.parse(server().host + 'region/regency/$province');
  }

  Uri GET_district(int province, int regency) {
    return Uri.parse(server().host + 'region/district/$province/$regency');
  }

  final Uri GET_productsAPI = Uri.parse(server().host + 'employee/products');
}
