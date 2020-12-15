/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

protocol Translator {
  static func translate(_ build: String) -> String
}

public struct XcodeBuildTranslator: Translator {
  static let xcodeBuildTranslation = 
    ["9A235":"9.0",
     "9A1004":"9.0.1",
     "9B55":"9.1",
     "9C40b":"9.2",
     "9E145":"9.3",
     "9E501":"9.3.1",
     "9F1027a":"9.4",
     "9F2000":"9.4.1",
     "10A255":"10.0",
     "10B61":"10.1",
     "10E125":"10.2",
     "10E1001":"10.2.1",
     "10G8":"10.3",
     "11A420a":"11.0",
     "11A1027":"11.1",
     "11B52":"11.2",
     "11B500":"11.2.1",
     "11C29":"11.3",
     "11C504":"11.3.1",
     "11C505":"11.3.1",
     "11E146":"11.4",
     "11E503a":"11.4.1",
     "11E608c":"11.5",
     "11E708":"11.6",
     "11E801a":"11.7",
     "12A7209":"12.0",
     "12A7300":"12.0.1",
     "12A7403":"12.1",
     "12B45b":"12.2",
     "12C33":"12.3"
    ]

  static func translate(_ build: String) -> String {
    return xcodeBuildTranslation[build] ?? build
  }
}

public struct MacOSBuildTranslator: Translator {
  static let macOSBuildTranslation = 
    ["20B29":"Big Sur 11.0.1",
     "20B50":"Big Sur 11.0.1",
     "20C69":"Big Sur 11.1 RC",
     "19A583":"Catalina 10.15",
     "19A602":"Catalina 10.15",
     "19A603":"Catalina 10.15",
     "19B88":"Catalina 10.15.1",
     "19C57":"Catalina 10.15.2",
     "19D76":"Catalina 10.15.3",
     "19E266":"Catalina 10.15.4",
     "19E287":"Catalina 10.15.4",
     "19F96":"Catalina 10.15.5",
     "19F101":"Catalina 10.15.5",
     "19G73":"Catalina 10.15.6",
     "19G2021":"Catalina 10.15.6",
     "19H2":"Catalina 10.15.6",
     "18A391":"Mojave 10.14",
     "18B75":"Mojave 10.14.1",
     "18B2107":"Mojave 10.14.1",
     "18B3094":"Mojave 10.14.1",
     "18C54":"Mojave 10.14.2",
     "18D42":"Mojave 10.14.3",
     "18D43":"Mojave 10.14.3",
     "18D109":"Mojave 10.14.3",
     "18E226":"Mojave 10.14.4",
     "18E227":"Mojave 10.14.4",
     "18F132":"Mojave 10.14.5",
     "18G84":"Mojave 10.14.6",
     "18G87":"Mojave 10.14.6",
     "18G95":"Mojave 10.14.6",
     "18G103":"Mojave 10.14.6",
     "18G1012":"Mojave 10.14.6",
     "18G2022":"Mojave 10.14.6",
     "18G3020":"Mojave 10.14.6",
     "18G4032":"Mojave 10.14.6",
     "18G5033":"Mojave 10.14.6",
     "18G6020":"Mojave 10.14.6",
     "18G6032":"Mojave 10.14.6",
     "17A365":"High Sierra 10.13",
     "17A405":"High Sierra 10.13",
     "17B48":"High Sierra 10.13.1",
     "17B1002":"High Sierra 10.13.1",
     "17B1003":"High Sierra 10.13.1",
     "17C88":"High Sierra 10.13.2",
     "17C89":"High Sierra 10.13.2",
     "17C205":"High Sierra 10.13.2",
     "17C2205":"High Sierra 10.13.2",
     "17D47":"High Sierra 10.13.3",
     "17D2047":"High Sierra 10.13.3",
     "17D102":"High Sierra 10.13.3",
     "17D2102":"High Sierra 10.13.3",
     "17E199":"High Sierra 10.13.4",
     "17E202":"High Sierra 10.13.4",
     "17F77":"High Sierra 10.13.5",
     "17G66":"High Sierra 10.13.6",
     "17G2208":"High Sierra 10.13.6",
     "17G3025":"High Sierra 10.13.6",
     "17G4015":"High Sierra 10.13.6",
     "17G5019":"High Sierra 10.13.6",
     "17G6029":"High Sierra 10.13.6",
     "17G6030":"High Sierra 10.13.6",
     "17G7024":"High Sierra 10.13.6",
     "17G8029":"High Sierra 10.13.6",
     "17G8030":"High Sierra 10.13.6",
     "17G8037":"High Sierra 10.13.6",
     "17G9016":"High Sierra 10.13.6",
     "17G10021":"High Sierra 10.13.6",
     "17G11023":"High Sierra 10.13.6",
     "17G12034":"High Sierra 10.13.6",
     "17G13033":"High Sierra 10.13.6",
     "17G13035":"High Sierra 10.13.6",
     "17G14019":"High Sierra 10.13.6",
     "17G14033":"High Sierra 10.13.6",
    ]

  static func translate(_ build: String) -> String {
    return macOSBuildTranslation[build] ?? build
  }
}