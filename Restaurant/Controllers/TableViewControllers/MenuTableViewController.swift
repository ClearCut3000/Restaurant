//
//  MenuTableViewController.swift
//  Restaurant
//
//  Created by Николай Никитин on 16.01.2022.
//

import UIKit

class MenuTableViewController: UITableViewController {
  
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
  
  //MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == "ItemSegue" else { return }
    guard let indexPath = tableView.indexPathForSelectedRow else { return }
    let destination = segue.destination as! ItemViewController
    destination.menuItem = menuItems[indexPath.row]
  }
}

//MARK: - UITableViewDataSource Protocol
extension MenuTableViewController {
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

//MARK: - UITableViewDelegate Protocol
extension MenuTableViewController {
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.transform = CGAffineTransform(translationX: 0, y: cell.frame.height / 2)
    cell.alpha = 0
    UIView.animate(
      withDuration: 1.5,
      delay: 0.05 * Double(indexPath.row),
      options: [.curveEaseInOut],
      animations: {
        cell.transform = CGAffineTransform(translationX: 0, y: 0)
        cell.alpha = 1
      })
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let cell = tableView.cellForRow(at: indexPath) {
      cell.transform = CGAffineTransform(rotationAngle: 360)
      UIView.animate(
        withDuration: 1.5,
        delay: 0.5,
        animations: {
          cell.transform = CGAffineTransform(rotationAngle: 0.0)
        })
    }
  }
}
