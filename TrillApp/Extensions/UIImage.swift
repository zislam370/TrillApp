//
//  UIImage.swift
//  TrillDemo
//
//  Created by Zahidul Islam on 2022/08/09.
//

import Foundation
import UIKit

extension UIImage {
  convenience init?(url: URL?) {
    guard let url = url else { return nil }
            
    do {
      self.init(data: try Data(contentsOf: url))
    } catch {
      print("Cannot load image from url: \(url) with error: \(error)")
      return nil
    }
  }
}




