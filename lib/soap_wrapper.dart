library soap_wrapper;

import 'dart:convert';

import 'package:soap_wrapper/soap_client.dart';
import 'package:soap_wrapper/soap_response.dart';
import 'package:xml/xml.dart';

enum ReturnType { raw, json, xml }

class SoapWrapper {
  late final String url;

  SoapWrapper({required this.url});

  Future<SoapResponse> sendRequest({
    required String action,
    Map params = const {},
  }) async {
    final builder = XmlBuilder();

    builder.element(
      action,
      attributes: {'xmlns': 'http://tempuri.org/'},
      nest: () {
        for (final prop in params.entries) {
          builder.element(prop.key, nest: () {
            builder.text(prop.value);
          });
        }
      },
    );

    final res = await SoapClient.send(
      url,
      body: builder.buildDocument()..toXmlString(),
    );

    return SoapResponse(
      action: action,
      statusCode: res.statusCode,
      body: res.body,
      requestParams: params,
    );
  }

  decodeResponse(
    SoapResponse response, {
    ReturnType returnType = ReturnType.raw,
  }) {
    assert(response.statusCode == 200, "[STATUS CODE] ${response.statusCode}");

    if (returnType == ReturnType.json) {
      final xml = XmlDocument.parse(response.body);

      final itens = xml.findAllElements("${response.action}Result");

      if (itens.isEmpty) {
        throw Exception("Error while decodeResponse of ${response.action}");
      }

      return jsonDecode(itens.first.innerText);
    }

    if (returnType == ReturnType.xml) {
      return XmlDocument.parse(response.body);
    }

    return response.body;
  }
}
