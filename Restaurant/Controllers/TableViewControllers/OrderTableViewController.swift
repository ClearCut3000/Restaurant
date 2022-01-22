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
  var itemsInOrder = [MenuItem]()

  //MARK: - UIViewController Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
    isEditAviliable()
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
    if !itemsInOrder.isEmpty {
      itemsInOrder = [MenuItem]()
      tableView.reloadData()
    }
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

  func isEditAviliable() {
    self.navigationItem.leftBarButtonItem?.isEnabled = OrderManager.shared.order.menuItems.isEmpty ? false : true
    self.tableView.isEditing = false
  }

  @objc func editTapped(_ sender: UIBarButtonItem) {
    self.tableView.isEditing = (self.tableView.isEditing == false) ? true : false
  }

  //MARK: - Actions
  @IBAction func submitButton(_ sender: UIBarButtonItem) {
    let totalOrder = OrderManager.shared.order.menuItems.reduce(0) { $0 + $1.price }
    if totalOrder != 0 {
      let alert = UIAlertController(title: "Comfirm Order?", message: "TOTAL: \(totalOrder.formattedHundreds)", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Submit", style: .default) { _ in
        self.uploadOrder()
      })
      alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
      present(alert, animated: true)
    } else {
      let alert = UIAlertController(title: "Your order is empty!", message: "We recommend you to try our branded Spaghetti and Meatballs! They are really amazing!", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "I'll make a choice!", style: .cancel))
      present(alert, animated: true)
    }
  }
}

//MARK: - UITableViewDelegate Protocol
extension OrderTableViewController {
  override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .delete
  }

  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.transform = CGAffineTransform(translationX: 0, y: cell.frame.height / 2)
    UIView.animate(
      withDuration: 1.0,
      delay: 0.05 * Double(indexPath.row),
      usingSpringWithDamping: 0.4,
      initialSpringVelocity: 0.1,
      options: [.curveEaseInOut],
      animations: {
        cell.transform = CGAffineTransform(translationX: 0, y: 0)
      })
  }
}

//MARK: - UITableDataSource Protocol
extension OrderTableViewController {

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    isEditAviliable()
    for item in OrderManager.shared.order.menuItems {
      guard !itemsInOrder.contains(where: {$0.name == item.name}) else { continue }
      itemsInOrder.append(item)
    }
    return itemsInOrder.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath)
    let menuItem = itemsInOrder[indexPath.row]
    cellManager.configure(cell, witn: menuItem, for: tableView, indexPath: indexPath)
    return cell
  }

  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    switch editingStyle {
    case .delete:
      if let index = OrderManager.shared.order.menuItems.firstIndex(where: { $0.name == itemsInOrder[indexPath.row].name }) {
        let deletingItem = OrderManager.shared.order.menuItems.remove(at: index)
        if !OrderManager.shared.order.menuItems.contains(where: {$0.name == deletingItem.name}) {
          itemsInOrder.remove(at: indexPath.row)
          tableView.deleteRows(at: [indexPath], with: .fade)
        }
      } else {
        itemsInOrder.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
      }
    case .insert:
      break
    case .none:
      break
    @unknown default:
      break
    }
  }

}
