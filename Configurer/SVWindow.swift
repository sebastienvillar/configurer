//
//  SVWindow.swift
//  Configurer
//
//  Created by Sebastien Villar on 02/05/15.
//  Copyright (c) 2015 -. All rights reserved.
//

import Foundation

class SVWindow: NSObject {
  private let element : AXUIElementRef
  
  var rect: CGRect {
    get {
      var windowPositionValue: AXValueRef? = self.element.getAttribute(kAXPositionAttribute)
      var windowSizeValue: AXValueRef? = self.element.getAttribute(kAXSizeAttribute)

      var windowPosition: CGPoint? = windowPositionValue?.toStruct()
      var windowSize: CGSize? = windowSizeValue?.toStruct()

      if (windowPosition != nil && windowSize != nil) {
        return CGRectMake(windowPosition!.x, windowPosition!.y, windowSize!.width, windowSize!.height);
      }
      
      return CGRectNull
    }
    
    set {
      self.element.setAttribute(kAXPositionAttribute, value: AXValue.fromPoint(newValue.origin))
      self.element.setAttribute(kAXSizeAttribute, value: AXValue.fromSize(newValue.size))
    }
  }
    
  init(element: AXUIElementRef) {
    self.element = element;
    
    super.init()
  }
}