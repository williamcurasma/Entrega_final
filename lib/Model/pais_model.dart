class PaisModel {
  String nombre;
  String nombreOficial;
  String capital;
  String region;
  String subregion;
  int poblacion;
  String moneda;
  String idioma;
  double area;
  String bandera;

  PaisModel({
    required this.nombre,
    required this.nombreOficial,
    required this.capital,
    required this.region,
    required this.subregion,
    required this.poblacion,
    required this.moneda,
    required this.idioma,
    required this.area,
    required this.bandera,
  });

  factory PaisModel.fromJson(Map<String, dynamic> json) {
    return PaisModel(
      nombre: json['name']?['common'] ?? 'Sin nombre',
      nombreOficial: json['name']?['official'] ?? 'Sin nombre oficial',
      capital: json['capital'] != null ? json['capital'][0] : 'Sin capital',
      region: json['region'] ?? 'Sin región',
      subregion: json['subregion'] ?? 'Sin subregión',
      poblacion: json['population'] ?? 0,
      moneda: _obtenerMoneda(json['currencies']),
      idioma: _obtenerIdioma(json['languages']),
      area: (json['area'] ?? 0.0).toDouble(),
      bandera: json['flags']?['png'] ?? '',
    );
  }

  static String _obtenerMoneda(Map<String, dynamic>? currencies) {
    if (currencies == null) return 'Sin moneda';
    return currencies.keys.first;
  }

  static String _obtenerIdioma(Map<String, dynamic>? languages) {
    if (languages == null) return 'Sin idioma';
    return languages.values.first ?? 'Sin idioma';
  }
}