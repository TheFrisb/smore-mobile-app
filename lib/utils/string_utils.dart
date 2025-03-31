class StringUtils {
  static String capitalize(String str) {
    if (str.isEmpty) return str;
    return str[0].toUpperCase() + str.substring(1).toLowerCase();
  }

  static String toCamelCase(String str) {
    return str.split(' ').map((word) => capitalize(word)).join('');
  }

  static String toSnakeCase(String str) {
    return str.replaceAll(' ', '_').toLowerCase();
  }

  static String toKebabCase(String str) {
    return str.replaceAll(' ', '-').toLowerCase();
  }
}
