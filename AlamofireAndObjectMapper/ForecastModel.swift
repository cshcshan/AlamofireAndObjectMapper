//
//  ForecastModel.swift
//  AlamofireAndObjectMapper
//
//  Created by Han Chen on 25/4/2016.
//  Copyright © 2016年 Han Chen. All rights reserved.
//

import Foundation
import ObjectMapper

class ForecastModel: Mappable {
  var day: String?
  var temperature: String?
  var conditions: String?
  
  required init?(_ map: Map) {
    
  }
  
  func mapping(map: Map) {
    day <- map["day"]
    temperature <- map["temperature"]
    conditions <- map["conditions"]
  }
}