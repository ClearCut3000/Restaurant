//
//  URL+Extension.swift
//  Restaurant
//
//  Created by Николай Никитин on 16.01.2022.
//

import Foundation

extension URL {
  func withQueries (_ queries: [String: String]) -> URL? {
    var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
    components?.queryItems = queries.map {
      URLQueryItem(name: $0.key, value: $0.value)
    }
    return components?.url
  }
}
