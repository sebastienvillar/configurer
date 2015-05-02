//
//  SVAXUIElementExtension.swift
//  Configurer
//
//  Created by Sebastien Villar on 02/05/15.
//  Copyright (c) 2015 -. All rights reserved.
//

import Foundation

extension AXUIElement {
  func getAttribute<T>(attribute: String) -> T? {
    var pointer: Unmanaged<AnyObject>?
    var success = AXUIElementCopyAttributeValue(self, attribute, &pointer)
    
    if success == AXError(kAXErrorSuccess) {
      return pointer?.takeUnretainedValue() as? T
    }
    
    return nil
  }
  
  func setAttribute<T: AnyObject>(attribute: String, value: T) -> Bool {
    return AXUIElementSetAttributeValue(self, attribute, value) == AXError(kAXErrorSuccess)
  }
}