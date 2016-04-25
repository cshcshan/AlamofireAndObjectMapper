//
//  WeatherResponse.swift
//  AlamofireAndObjectMapper
//
//  Created by Han Chen on 25/4/2016.
//  Copyright © 2016年 Han Chen. All rights reserved.
//

import Foundation
import ObjectMapper

class WeatherResponse: Mappable {
  var location: String?
  var threeDayForecast: [ForecastModel]?
  
  required init?(_ map: Map) {
    
  }
  
  func mapping(map: Map) {
    location <- map["location"]
    threeDayForecast <- map["three_day_forecast"]
  }
}