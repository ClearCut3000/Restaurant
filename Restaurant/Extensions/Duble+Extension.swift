//
//  Duble+Extension.swift
//  Restaurant
//
//  Created by Николай Никитин on 19.01.2022.
//

import Foundation
extension Double {
  var formattedHundreds: String {
    return String(format: "$%.2f", self)
  }
}
