// https://pub.dev/packages/xml

import 'package:xml/xml.dart';
//implement a class woth a fromXML() constructor and toXML() 

class Example{
    int varA;
    int varB;
    String varC;
    List<int>varD;
    double varE;
    Example({                                                  //alternatively T? or late
        required this.varA,
        required this.varB,
        required this.varC,
        required this.varD,
        required this.varE
    });

    factory Example.fromXml(String xmlString){                      //or static function
        final document = XmlDocument.parse(xmlString);
        final root = document.rootElement;

        return Example(
            varA: int.parse(root.findElements('varA').single.innerText),
            varB: int.parse(root.findElements('varB').single.innerText),
            varC: root.findElements('varC').single.innerText,
            varD: root.findElements('varD').single
        .children
        .whereType<XmlElement>()
        .map((node) => int.parse(node.innerText))
            .toList(),

            varE:double.parse(root.findElements('varE').single.innerText),
        );
    }

    
    Example.fromXmlNamedCt(String xmlString)
      : varA = int.parse(XmlDocument.parse(xmlString).rootElement.findElements('varA').single.innerText),
        varB = int.parse(XmlDocument.parse(xmlString).rootElement.findElements('varB').single.innerText),
        varC = XmlDocument.parse(xmlString).rootElement.findElements('varC').single.innerText,
        varD = XmlDocument.parse(xmlString)
            .rootElement
            .findElements('varD')
            .single
            .children
            .where((node) => node is XmlElement)
            .map((node) => int.parse(node.innerText))
            .toList(),
        varE = double.parse(XmlDocument.parse(xmlString).rootElement.findElements('varE').single.innerText);

    String toXml(){
        final builder = XmlBuilder();
        builder.processing('xml', 'version="1.0"');
        builder.element('Example', nest: () {
            builder.element('varA', nest: varA.toString());
            builder.element('varB', nest: varB.toString());
            builder.element('varC', nest: varC);
            builder.element('varD', nest: () {
                for (var item in varD) {
                builder.element('item', nest: item.toString());
                }
            });
        builder.element('varE', nest: varE.toString());
        });

        final xmlString = builder.buildDocument().toXmlString(pretty: true);
        return xmlString;   
    }
}

void main(){
  // Example XML string
  final xmlData = '''<Example>
      <varA>10</varA>
      <varB>20</varB>
      <varC>Dart is cringe</varC>
      <varD>
        <item>1</item>
        <item>2</item>
        <item>3</item>
      </varD>
      <varE>5.5</varE>
    </Example>''';


  Example example = Example.fromXml(xmlData);
  print('varA: ${example.varA}');
  print('varB: ${example.varB}');
  print('varC: ${example.varC}');
  print('varD: ${example.varD}');
  print('varE: ${example.varE}');


  String xmlOutput = example.toXml();
  print('\nTo XML:');
  print(xmlOutput);
}