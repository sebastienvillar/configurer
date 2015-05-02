//
//  SVAXValueExtension.swift
//  Configurer
//
//  Created by Sebastien Villar on 02/05/15.
//  Copyright (c) 2015 -. All rights reserved.
//

import Foundation

extension AXValue {
  static func fromPoint(var point: CGPoint) -> AXValue {
    return AXValueCreate(kAXValueCGPointType, &point).takeUnretainedValue()
  }
  
  static func fromSize(var size: CGSize) -> AXValue {
    return AXValueCreate(kAXValueCGSizeType, &size).takeUnretainedValue()
  }
  
  func toStruct<T>() -> T? {
    let pointer = UnsafeMutablePointer<T>.alloc(1)
    let error = AXValueGetValue(self, AXValueGetType(self), pointer)
    let value = pointer.memory
    
    if error != 0 {
      return value
    }
    
    return nil
  }
}