//
//  CellManager.swift
//  Restaurant
//
//  Created by Николай Никитин on 16.01.2022.
//

import Foundation
import UIKit

class CellManager {
  func configure(_ cell: UITableViewCell, witn category: String) {
    cell.textLabel?.text = category.localizedCapitalized
  }
}
