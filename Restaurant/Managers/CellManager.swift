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
    cell.textLabel?.text = menuItem.name
    cell.detailTextLabel?.text = String(format: "$%.2f", menuItem.price)
    guard cell.imageView?.image == nil else { return }
    networkManager.getImage(menuItem.imageURL) { image, error in
      if let error = error {
        print (#line, #function, "ERROR", error.localizedDescription)
      }
      DispatchQueue.main.async {
        cell.imageView?.image = image
        tableView?.reloadRows(at: [indexPath], with: .automatic)
      }
    }
  }
}
