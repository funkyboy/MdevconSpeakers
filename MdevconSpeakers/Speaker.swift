//
//  Speaker.swift
//  MdevconSpeakers
//
//  Created by Cesare Rocchi on 28/02/15.
//  Copyright (c) 2015 Cesare Rocchi. All rights reserved.
//

import UIKit

class Speaker: NSObject {
  
  var name:String = ""
  var presentationTitle:String = ""
  
  init(dictionary: NSDictionary) {
    self.name = dictionary["name"] as String
    self.presentationTitle = dictionary["presentationTitle"] as String
    super.init()
  }
  
}
