//
//  PreparationTime.swift
//  Restaurant
//
//  Created by Николай Никитин on 19.01.2022.
//

import Foundation
struct PreparationTime: Codable {
  let prepTime: Int
  
  enum CodingKeys: String, CodingKey {
    case prepTime = "preparation_time"
  }
}
