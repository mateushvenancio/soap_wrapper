import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class SoapClient {
  static Future<http.Response> send(
    String url, {
    required XmlDocument body,
  }) async {
    final response = await http.post(
      Uri.parse(url),
      body: wrapBody(body).toXmlString(),
      headers: {
        'content-type': 'text/xml',
      },
    );

    return response;
  }

  static XmlDocument wrapBody(XmlDocument doc) {
    const soapBody = """
<soap:Envelope 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
    xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
  </soap:Body>
</soap:Envelope>""";

    final parsedSoapBody = XmlDocument.parse(soapBody);

    parsedSoapBody.children.first.children[1].children.add(doc.firstChild!.copy());

    return parsedSoapBody;
  }
}
