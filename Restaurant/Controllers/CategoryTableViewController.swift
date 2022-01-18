//
//  CategoryTableViewController.swift
//  Restaurant
//
//  Created by Николай Никитин on 15.01.2022.
//

import UIKit

class CategoryTableViewController: UITableViewController {

  //MARK: - Properties
  let networkManager = NetworkManager()
  var categories = [String]()
  let cellManager = CellManager()

  //MARK: - UIViewController lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()
    networkManager.getCategories { categories, error in
      guard let categories = categories  else {
        if let error = error {
          print (#line, #function, "ERROR:", error.localizedDescription)
        } else {
          print (#line, #function, "ERROR: Can't load categories")
        }
        return
      }
      self.categories = categories
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }

  //MARK: - NAvigation methods
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == "MenuSegue" else { return }
    guard let categoryIndex = tableView.indexPathForSelectedRow else { return }
    let destination = segue.destination as! MenuTableViewController
    destination.category = categories[categoryIndex.row]
  }

//MARK: - TableViewDataSource
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories.count
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
    cellManager.configure(cell, witn: categories[indexPath.row])
    return cell
  }
}
