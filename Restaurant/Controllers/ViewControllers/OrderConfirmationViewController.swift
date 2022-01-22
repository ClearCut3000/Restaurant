//
//  OrderConfirmationViewController.swift
//  Restaurant
//
//  Created by Николай Никитин on 19.01.2022.
//

import UIKit

class OrderConfirmationViewController: UIViewController {
  
  //MARK: - Outlets
  @IBOutlet var timeRemainigLabel: UILabel!
  
  //MARK: - Properties
  var minutes: Int!
  
  //MARK: - Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    timeRemainigLabel.text = "Thank you for ordering! Your waiting time is approximately \(String(describing: minutes!)) minutes."
  }
}
