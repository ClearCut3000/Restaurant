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
  let networkManager = NetworkManager()
  var minutes = 0

  //MARK: - UIViewController Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.leftBarButtonItem = editButtonItem
    NotificationCenter.default.addObserver( tableView!, selector: #selector(UITableView.reloadData), name: OrderManager.orderUpdatedNotification, object: nil)
  }

  //MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == "OrderConfirmationSegue" else { return }
    let destination = segue.destination as! OrderConfirmationViewController
    destination.minutes = minutes
  }

  @IBAction func unwind(_ segue: UIStoryboardSegue) {
    OrderManager.shared.order = Order()
  }

  // MARK: - UITableViewDataSource
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return OrderManager.shared.order.menuItems.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath)
    let menuItem = OrderManager.shared.order.menuItems[indexPath.row]
    cellManager.configure(cell, witn: menuItem, for: tableView, indexPath: indexPath)
    return cell
  }

  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    switch editingStyle {
    case .delete:
      OrderManager.shared.order.menuItems.remove(at: indexPath.row)
    case .insert:
      break
    case .none:
      break
    @unknown default:
      break
    }
  }

  //MARK: - UITableViewDelegate
  override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .delete
  }

  //MARK: - Custom Methods
  func uploadOrder() {
    let menuIds = OrderManager.shared.order.menuItems.map { $0.id }
    networkManager.submitOrder(forMenuIds: menuIds) { minutes, error in
      if let error = error {
        print (#line, #function, "ERROR: \(error.localizedDescription)")
      } else {
        guard let minutes = minutes else {
          print (#line, #function, "ERROR: didn't get minutes from server")
          return
        }
        self.minutes = minutes
        DispatchQueue.main.async {
          self.performSegue(withIdentifier: "OrderConfirmationSegue", sender: nil)
        }
      }
    }
  }

  //MARK: - Actions
  @IBAction func submitButton(_ sender: UIBarButtonItem) {
    let totalOrder = OrderManager.shared.order.menuItems.reduce(0) { $0 + $1.price }
    print(totalOrder)
    if totalOrder > 0 {
    let alert = UIAlertController(title: "Comfirm Order?", message: "TOTAL: \(totalOrder.formattedHundreds)", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Submit", style: .default) { _ in
      self.uploadOrder()
    })
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    present(alert, animated: true)
    } else {
      let alert = UIAlertController(title: "Your order is empty!", message: "You can't send an empty order.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "I'll make a choice!", style: .cancel))
      present(alert, animated: true)
    }
  }
}
