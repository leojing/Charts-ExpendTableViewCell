//
//  NetworkManager.swift
//  PocketBookTask
//
//  Created by JINGLUO on 24/6/17.
//  Copyright © 2017 JINGLUO. All rights reserved.
//

import Foundation
import AFNetworking
import SwiftyJSON

class NetworkManager: NSObject {
  let baseURLString: String = "https://query.yahooapis.com/v1/public/yql?q=select * from yahoo.finance.quotes where symbol in (\"%@\")&format=json&env=store://datatables.org/alltableswithkeys&callback="
  
  func getDataWithStockId(_ stockId: String, index: Int, completionHandler:@escaping (_ data: JSON?, _ error: Error?, _ index: Int) -> Void) {
    let requestURL = String(format: baseURLString, stockId)
    if let encodeURL = requestURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
      AFHTTPSessionManager().get(encodeURL, parameters: nil, progress: nil, success: { (task, responseObject) in
          guard let json = responseObject else {
            return
          }
          let data = JSON(json)
          completionHandler(data["query"]["results"]["quote"], nil, index)
      }, failure: { (task, error) in
          completionHandler(nil, error, index)
      })
    }
  }

}

