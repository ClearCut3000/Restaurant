//
//  OrderTableViewController.swift
//  Restaurant
//
//  Created by Николай Никитин on 18.01.2022.
//

import UIKit

class OrderTableViewController: UITableViewController {

  //MARK: - Properties
  let cellManager = CellManager()

  //MARK: - UIViewController Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver( tableView!, selector: #selector(UITableView.reloadData), name: OrderManager.orderUpdatedNotification, object: nil)
  }

  // MARK: - TableViewDataSource
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return OrderManager.shared.order.menuItems.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath)
    let menuItem = OrderManager.shared.order.menuItems[indexPath.row]
    cellManager.configure(cell, witn: menuItem, for: tableView, indexPath: indexPath)
    return cell
  }
}
