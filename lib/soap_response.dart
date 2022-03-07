class SoapResponse {
  late final String action;
  late final int statusCode;
  late final dynamic body;
  late final Map requestParams;

  SoapResponse({
    required this.action,
    required this.statusCode,
    required this.body,
    required this.requestParams,
  });
}
