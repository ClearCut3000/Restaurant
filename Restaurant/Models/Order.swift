//
//  Order.swift
//  Restaurant
//
//  Created by Николай Никитин on 18.01.2022.
//

import Foundation

struct Order {
  var menuItems: [MenuItem]

  init(menuItems: [MenuItem] = []) {
    self.menuItems = menuItems
  }
}
