//
//  ViewController.swift
//  AlamofireAndObjectMapper
//
//  Created by Han Chen on 25/4/2016.
//  Copyright © 2016年 Han Chen. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
//    getRequest()
//    postRequest()
//    contentTypeRequest()
//    headerRequest()
//    
//    uploadFile()
//    uploadWithProgress()
//    uploadMultipartFormData()
//    downloadFile()
//    downloadDefaultDestination()
//    downloadFileWithProgress()
//    resumeDataForFailedDownload()
//    
//    httpBasicAuthentication()
//    httpBasicAuthenticationWithHeader()
//    authenticationWithNSURLCredential()
//    
//    validation()
//    automaticValidation()
//    
//    timeline()
//    
//    alamofireAndObjectMapper()
//    alamofireAndObjectMapperWithKeyPath()
//    alamofireAndObjectMapperViaArray()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK:- Request
  // MARK: GET
  func getRequest() {
    // https://httpbin.org/get?foo=bar
    let urlString = "https://httpbin.org/get"
    let parameters: [String: AnyObject]? = ["foo": "bar"]
    Alamofire.request(.GET, urlString, parameters: parameters).responseJSON { response in
      print("\n\n[Response Handling]===== ===== ===== ===== =====\n\n")
      print("request: \(response.request)")    // original URL request
      print("response: \(response.response)")  // URL response
      print("data: \(response.data)")          // server data
      print("result: \(response.result)")       // result of response serialization
      
      if let JSON = response.result.value {
        print("JSON: \(JSON)")
      }
    }
    
    // https://httpbin.org/get
    Alamofire.request(.GET, urlString).response { (request, response, data, error) in
      print("\n\n[Response Handler]===== ===== ===== ===== =====\n\n")
      print("request: \(request)")
      print("response: \(response)")
      print("data: \(data)")
      print("error: \(error)")
    }
    
    Alamofire.request(.GET, urlString).responseData { response in
      print("\n\n[Response Data Handler]===== ===== ===== ===== =====\n\n")
      print("request: \(response.request)")
      print("response: \(response.response)")
      print("result: \(response.result)")
    }
    
    Alamofire.request(.GET, urlString).responseString { response in
      print("\n\n[Response String Handler]===== ===== ===== ===== =====\n\n")
      print("Success: \(response.result.isSuccess)")
      print("Response String: \(response.result.value)")
    }
    
    Alamofire.request(.GET, urlString).responseJSON { response in
      print("\n\n[Response JSON Handler]===== ===== ===== ===== =====\n\n")
      debugPrint(response)
    }
    
    Alamofire.request(.GET, urlString).responseString { response in
      print("\n\n[Chained Response Handlers]===== ===== ===== ===== =====\n\n")
      print("Response String: \(response.result.value)")
      }.responseJSON { response in
        print("\n\n[Chained Response Handlers]===== ===== ===== ===== =====\n\n")
        print("Response JSON: \(response.result.value)")
    }
  }
  
  // MARK: POST
  func postRequest() {
    let urlString = "https://httpbin.org/post"
    let parameters = ["foo": "bar",
                      "baz": ["a", 1],
                      "quz": ["x": 1,
                        "y": 2,
                        "z": 3]]
    // 預設的 "Content-Type" = "application/x-www-form-urlencoded; charset=utf-8";
    Alamofire.request(.POST, urlString, parameters: parameters).responseJSON { response in
      print("\n\n[default encoding]===== ===== ===== ===== =====\n\n")
      print("JSON: \(response.result.value)")
    }
  }
  
  // MARK: ContentType
  func contentTypeRequest() {
    let urlString = "https://httpbin.org/post"
    let parameters = ["foo": [1, 2, 3],
                      "bar": ["baz": "qux"]]
    // 預設的 "Content-Type" = "application/x-www-form-urlencoded; charset=utf-8";
    //   改變 "Content-Type" = "application/json";
    Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON).responseJSON { response in
      print("\n\n[JSON encoding]===== ===== ===== ===== =====\n\n")
      print("JSON: \(response.result.value)")
    }
  }
  
  // MARK: Headers
  func headerRequest() {
    let urlString = "https:/httpbin.org/get"
    let headers = ["Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
                   "Content-Type": "application/x-www-form-urlencoded"]
    Alamofire.request(.GET, urlString, headers: headers).responseJSON { response in
      print("\n\n[Headers]===== ===== ===== ===== =====\n\n")
      debugPrint(response)
    }
  }
  
  // MARK:- Upload File: File、Data、Stream、MultipartFormData
  func uploadFile() {
    let urlString = "https://httpbin.org/post"
    let fileUrl = NSBundle.mainBundle().URLForResource("phone", withExtension: "png")
    print(fileUrl)
    Alamofire.upload(.POST, urlString, file: fileUrl!).response { request, response, data, error in
      print(request)
      print(response)
    }
  }
  
  func uploadWithProgress() {
    let urlString = "https://httpbin.org/post"
    let fileUrl = NSBundle.mainBundle().URLForResource("phone", withExtension: "png")
    Alamofire.upload(.POST, urlString, file: fileUrl!).progress { bytesWritten, totalBytesWritten, totalBytesExpectedTpWrite in
      // This closure is NOT called on the main queue for performance respons.
      print(totalBytesWritten)
      dispatch_async(dispatch_get_main_queue()) {
        print("Total bytes writtes on main queue: \(totalBytesWritten)")
      }
      }.responseJSON { response in
        debugPrint(response)
    }
  }
  
  func uploadMultipartFormData() {
    let urlString = "https://httpbin.org/post"
    let phoneUrl = NSBundle.mainBundle().URLForResource("phone", withExtension: "png")
    let rainbowUrl = NSBundle.mainBundle().URLForResource("rainbow", withExtension: "png")
    Alamofire.upload(.POST, urlString, multipartFormData: { multipartFormData in
      multipartFormData.appendBodyPart(fileURL: phoneUrl!, name: "phone")
      multipartFormData.appendBodyPart(fileURL: rainbowUrl!, name: "rainbow")
      }, encodingCompletion: { encodingResult in
        switch encodingResult {
        case .Success(let upload, _, _):
          upload.responseJSON { response in
            debugPrint(response)
          }
        case .Failure(let encodingError):
          print(encodingError)
        }
      }
    )
  }
  
  // MARK:- Download: Request、Resume Data
  func downloadFile() {
    let urlString = "https://httpbin.org/stream/100"
    Alamofire.download(.GET, urlString) { temporaryURL, response in
      let fileManager = NSFileManager.defaultManager()
      let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
      let pathComponent = response.suggestedFilename
      // 檔案存放在 App 的位置
      return directoryURL.URLByAppendingPathComponent(pathComponent!)
    }
  }
  
  func downloadDefaultDestination() {
    let urlString = "https://httpbin.org/stream/100"
    let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
    print(destination)
    Alamofire.download(.GET, urlString, destination: destination)
  }
  
  func downloadFileWithProgress() {
    let urlString = "https://httpbin.org/stream/100"
    let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
    Alamofire.download(.GET, urlString, destination: destination).progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
      print(totalBytesRead)
      dispatch_async(dispatch_get_main_queue()) {
        print("Total bytes read on main queue: \(totalBytesRead)")
      }
      }.response { _, _, _, error in
        if let error = error {
          print("Failed with error: \(error)")
        } else {
          print("Download file successfully")
        }
    }
  }
  
  func resumeDataForFailedDownload() {
    let urlString = "https://httpbin.org/stream/100"
    let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
    Alamofire.download(.GET, urlString, destination: destination).response { _, _, data, _ in
      if let data = data, resumeDataString = NSString(data: data, encoding: NSUTF8StringEncoding) {
        print("[First Type] Resume Data: \(resumeDataString)")
      } else {
        print("[First Type] Resume Data was empty")
      }
    }
    
    let download = Alamofire.download(.GET, urlString, destination: destination)
    download.response { _, _, _, _ in
      if let resumeData = download.resumeData, resumeDataString = NSString(data: resumeData, encoding: NSUTF8StringEncoding) {
        print("[Second Type] Resume Data: \(resumeDataString)")
      } else {
        print("[Second Type] Resume Data was empty")
      }
    }
  }
  
  // MARK:- Authentication: HTTP Basic、HTTP Digest、Kerberos、NTLM
  // NSURLCredential、NSURLAuthenticationChallenge
  // MARK: HTTP Basic Authentication
  func httpBasicAuthentication() {
    let user = "user"
    let password = "password"
    let urlString = "https://httpbin.org/basic-auth/\(user)/\(password)"
    Alamofire.request(.GET, urlString).authenticate(user: user, password: password).responseJSON { response in
      debugPrint(response)
    }
  }
  
  func httpBasicAuthenticationWithHeader() {
    let urlString = "https://httpbin.org/basic-auth/user/password"
    let user = "user"
    let password = "password"
    let credentialData = "\(user):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
    print("Credential Data: \(credentialData)")
    let base64Credentials = credentialData.base64EncodedStringWithOptions([])
    print("Base 64 Credentials: \(base64Credentials)")
    let headers = ["Authorization": "Basic \(base64Credentials)"]
    Alamofire.request(.GET, urlString, headers: headers).responseJSON { response in
      debugPrint(response)
    }
  }
  
  func authenticationWithNSURLCredential() {
    let user = "user"
    let password = "password"
    let urlString = "https://httpbin.org/basic-auth/\(user)/\(password)"
    let credential = NSURLCredential(user: user, password: password, persistence: .ForSession)
    Alamofire.request(.GET, urlString).authenticate(usingCredential: credential).responseJSON { response in
      debugPrint(response)
      
    }
  }
  
  // MARK:- Validation
  func validation() {
    let urlString = "https://httpbin.org/get"
    let parameters = ["foo": "bar"]
    Alamofire.request(.GET, urlString, parameters: parameters).validate(statusCode: 200..<300).validate(contentType: ["application/json"]).response { response in
      print(response)
    }
  }
  
  func automaticValidation() {
    // Automatically validates 的 status code 介於 200 到 299 之間，且 Response 的 Content-Type Header 必須符合 request 的 Accept Header
    let urlString = "https://httpbin.org/get"
    let parameters = ["foo": "bar"]
    Alamofire.request(.GET, urlString, parameters: parameters).validate().responseJSON { response in
      switch response.result {
      case .Success:
        print("Validation Successful")
      case .Failure(let error):
        print(error)
      }
    }
  }
  
  // MARK:- Timeline
  func timeline() {
    let urlString = "https://httpbin.org/get"
    let parameters = ["foo": "bar"]
    Alamofire.request(.GET, urlString, parameters: parameters).validate().responseJSON { response in
      print(response.timeline)
    }
  }
  
  // MARK:- Alamofire and ObjectManager
  func alamofireAndObjectMapper() {
    let urlString = "https://raw.githubusercontent.com/tristanhimmelman/AlamofireObjectMapper/d8bb95982be8a11a2308e779bb9a9707ebe42ede/sample_json"
    /*
     
     {
     "location": "Toronto, Canada",
     "three_day_forecast": [
     {
     "conditions": "Partly cloudy",
     "day" : "Monday",
     "temperature": 20
     },
     {
     "conditions": "Showers",
     "day" : "Tuesday",
     "temperature": 22
     },
     {
     "conditions": "Sunny",
     "day" : "Wednesday",
     "temperature": 28
     }
     ]
     }
     */
    
    // responseObject 是 AlamofireObjectMapper class 的 func
    Alamofire.request(.GET, urlString).responseObject { (response: Response<WeatherResponse, NSError>) in
      print("response: \(response)")
      let weatherResponse = response.result.value
      print("location: \(weatherResponse?.location)")
      if let threeDayForecast = weatherResponse?.threeDayForecast {
        for forecast in threeDayForecast {
          print("===== ===== ===== ===== =====\nforecast: \(forecast)")
          print("conditions: \(forecast.conditions)")
          print("day: \(forecast.day)")
          print("temperature: \(forecast.temperature)")
        }
      }
    }
  }
  
  func alamofireAndObjectMapperWithKeyPath() {
    let urlString = "https://raw.githubusercontent.com/tristanhimmelman/AlamofireObjectMapper/2ee8f34d21e8febfdefb2b3a403f18a43818d70a/sample_keypath_json"
    /*
     
     {
       "data": {
         "location": "Toronto, Canada",
         "three_day_forecast": [
         {
           "conditions": "Partly cloudy",
           "day" : "Monday",
           "temperature": 20
         },
         {
           "conditions": "Showers",
           "day" : "Tuesday",
           "temperature": 22
         },
         {
           "conditions": "Sunny",
           "day" : "Wednesday",
           "temperature": 28
         }
       ]
     }
     }
     */
    
    Alamofire.request(.GET, urlString).responseObject(keyPath: "data") { (response: Response<WeatherResponse, NSError>) in
      let weatherResponse = response.result.value
      print(weatherResponse?.location)
      
      if let threeDayForecast = weatherResponse?.threeDayForecast {
        for forecast in threeDayForecast {
          print("===== ===== ===== ===== =====\nforecast keyPath: \(forecast)")
          print("conditions: \(forecast.conditions)")
          print("day: \(forecast.day)")
          print("temperature: \(forecast.temperature)")
        }
      }
    }
  }
  
  func alamofireAndObjectMapperViaArray() {
    let urlString = "https://raw.githubusercontent.com/tristanhimmelman/AlamofireObjectMapper/f583be1121dbc5e9b0381b3017718a70c31054f7/sample_array_json"
    /*
     [
       {
         "conditions": "Partly cloudy",
         "day" : "Monday",
         "temperature": 20
       },
       {
         "conditions": "Showers",
         "day" : "Tuesday",
         "temperature": 22
       },
       {
         "conditions": "Sunny",
         "day" : "Wednesday",
         "temperature": 28
       }
     ]
     */
    
    // responseArray 是 AlamofireObjectMapper class 的 func
    Alamofire.request(.GET, urlString).responseArray { (response: Response<[ForecastModel], NSError>) in
      let forecastArray = response.result.value
      
      if let forecastArray = forecastArray {
        for forecast in forecastArray {
          print("===== ===== ===== ===== =====\nforecast array: \(forecast)")
          print("conditions: \(forecast.conditions)")
          print("day: \(forecast.day)")
          print("temperature: \(forecast.temperature)")
        }
      }
    }
  }
}

