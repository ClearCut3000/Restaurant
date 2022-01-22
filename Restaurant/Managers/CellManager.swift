//
//  CellManager.swift
//  Restaurant
//
//  Created by Николай Никитин on 16.01.2022.
//

import Foundation
import UIKit

class CellManager {
  //MARK: - Properties
  let networkManager = NetworkManager()

  //MARK: - Methods
  func configure(_ cell: UITableViewCell, witn category: String) {
    cell.textLabel?.text = category.localizedCapitalized
  }
  
  func configure(_ cell: UITableViewCell, witn menuItem: MenuItem, for tableView: UITableView? = nil, indexPath: IndexPath) {
    let items = Dictionary( OrderManager.shared.order.menuItems.map {($0.name, 1)}, uniquingKeysWith: + )
    cell.textLabel?.text = menuItem.name
    let count = items[menuItem.name]
    if count != nil {
      cell.detailTextLabel?.text = "\(count!) by " + menuItem.price.formattedHundreds
    } else {
      cell.detailTextLabel?.text = menuItem.price.formattedHundreds
    }
    if let image = menuItem.image {
      cell.imageView?.image = image
    } else {
      networkManager.getImage(menuItem.imageURL) { image, error in
        if let error = error {
          print (#line, #function, "ERROR", error.localizedDescription)
        }
        if let image = image {
          menuItem.image = image
          DispatchQueue.main.async {
            tableView?.reloadRows(at: [indexPath], with: .automatic)
          }
        }
      }
    }
  }
} 
