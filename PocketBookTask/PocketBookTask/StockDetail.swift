//
//  StockDetail.swift
//  PocketBookTask
//
//  Created by JINGLUO on 25/6/17.
//  Copyright © 2017 JINGLUO. All rights reserved.
//

import UIKit
import SwiftyJSON

struct StockDetail {
  var symbol: String
  var bookValue: String?
  var change: String?
  var yearLow: String?
  var yearHigh: String?
}

extension StockDetail {
  
  init?(_ json: JSON) {
    guard let symbol = json["Symbol"].string else {
        return nil
    }
    
    self.symbol = symbol
    self.bookValue = json["BookValue"].string
    self.change = json["Change"].string
    self.yearLow = json["YearLow"].string
    self.yearHigh = json["YearHigh"].string
  }
}
