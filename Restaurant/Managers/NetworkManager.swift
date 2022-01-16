//
//  NetworkManager.swift
//  Restaurant
//
//  Created by Николай Никитин on 15.01.2022.
//

import Foundation

class NetworkManager {
  //MARK: - Properties
  let baseURL = URL(string: "http://mda.getoutfit.co:8090")!


  //MARK: - Methods
  func getCategories(completion: @escaping ([String]?, Error?) -> Void) {
    let url = baseURL.appendingPathComponent("categories")
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      guard let data = data else {
        completion(nil, error)
        return
      }
      let decoder = JSONDecoder()
      do {
        let decodedData = try decoder.decode(Categories.self, from: data)
        completion(decodedData.categories, nil)
      } catch let error {
        completion(nil, error)
      }
    }
    task.resume()
  }

  func getMenuItems(for category: String, completion: @escaping ([MenuItems]?, Error?) -> Void) {
    let initialUrl = baseURL.appendingPathComponent("menu")
    guard let url = initialUrl.withQueries(["category" : category]) else {
      completion(nil, nil)
      return
    }
    let task = URLSession.shared.dataTask(with: url) {data, _, error in
      guard let data = data else {
        completion(nil, error)
        return
      }
      do {
        let decoder = JSONDecoder()
        let decodedData = try decoder.decode(MenuItems.self, from: data)
        completion(decodedData.items, nil)
      } catch let error {
        completion(nil, error)
      }
    }
    task.resume()
  }
}
