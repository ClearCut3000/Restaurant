//
//  ItemTableViewController.swift
//  Restaurant
//
//  Created by Николай Никитин on 16.01.2022.
//

import UIKit

class ItemTableViewController: UITableViewController {

  //MARK: - Properties
  let cellManager = CellManager()
  let networkManager = NetworkManager()
  var category: String!
  var menuItems = [MenuItem]()

  //MARK: - UIViewController methods
  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.title = category.localizedCapitalized

    networkManager.getMenuItems(for: category) { menuItems, error in
      guard let menuItems = menuItems else {
        print (#line, #function,"ERROR", terminator: "")
        if let error = error {
          print (error)
        } else {
          print ("Can't get menu items for category \(String(describing: self.category))")
        }
        return
      }
      self.menuItems = menuItems
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }

  //MARK: - UITableViewControllerDelegate
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return menuItems.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
    let menuItem = menuItems[indexPath.row]
    cellManager.configure(cell, witn: menuItem, for: tableView, indexPath: indexPath)
    return cell
  }
}
