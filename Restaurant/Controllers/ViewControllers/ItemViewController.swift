//
//  ItemViewController.swift
//  Restaurant
//
//  Created by Николай Никитин on 18.01.2022.
//

import UIKit

class ItemViewController: UIViewController {
  
  //MARK: - Properties
  var menuItem: MenuItem!
  
  //MARK: - Outlets
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var priceLabel: UILabel!
  @IBOutlet var detailTextLabel: UILabel!
  @IBOutlet var orderButton: UIButton!
  
  //MARK: - UIViewController methods
  override func viewDidLoad() {
    super.viewDidLoad()
    orderButton.layer.cornerRadius = 5
    updateUI()
  }
  
  func updateUI() {
    navigationItem.title = menuItem.name
    imageView.image = menuItem.image
    priceLabel.text = menuItem.price.formattedHundreds
    detailTextLabel.text = menuItem.detailText
  }
  
  //MARK: - Actions
  @IBAction func orderButtonPressed(_ sender: UIButton) {
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
      self.orderButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
      self.orderButton.transform = CGAffineTransform.identity
    })
    OrderManager.shared.order.menuItems.append(menuItem)
  }
  
}
