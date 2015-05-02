//
//  SVScreen.swift
//  Configurer
//
//  Created by Sebastien Villar on 02/05/15.
//  Copyright (c) 2015 -. All rights reserved.
//

import Foundation
import AppKit

enum kSVScreenArea {
  case TopHalf, TopLeftQuadran, TopRightQuadran
  case BottomHalf, BottomLeftQuadran, BottomRightQuadran
  case LeftHalf, RightHalf
  case Full
}

class SVScreen: NSObject {
  let screen: NSScreen
  var isMainScreen: Bool {
    get {
      return CGPointEqualToPoint(self.screen.frame.origin, CGPointZero)
    }
  }
  
  init(screen: NSScreen) {
    self.screen = screen
    
    super.init()
  }
  
  func rectForArea(area: kSVScreenArea) -> CGRect {
    switch area {
    case .TopHalf:
      return CGRectMake(self.screen.frame.origin.x,
                        self.screen.frame.origin.y,
                        self.screen.frame.size.width,
                        self.screen.frame.size.height / 2)

    case .TopLeftQuadran:
      return CGRectMake(self.screen.frame.origin.x,
                        self.screen.frame.origin.y,
                        self.screen.frame.size.width / 2,
                        self.screen.frame.size.height / 2)

    case .TopRightQuadran:
      return CGRectMake(self.screen.frame.origin.x + self.screen.frame.size.width / 2,
                        self.screen.frame.origin.y,
                        self.screen.frame.size.width / 2,
                        self.screen.frame.size.height / 2)
      
    case .BottomHalf:
      return CGRectMake(self.screen.frame.origin.x,
                        self.screen.frame.origin.y + self.screen.frame.size.height / 2,
                        self.screen.frame.size.width,
                        self.screen.frame.size.height / 2)

    case .BottomLeftQuadran:
      return CGRectMake(self.screen.frame.origin.x,
                        self.screen.frame.origin.y + self.screen.frame.size.height / 2,
                        self.screen.frame.size.width / 2,
                        self.screen.frame.size.height / 2)

    case .BottomRightQuadran:
      return CGRectMake(self.screen.frame.origin.x + self.screen.frame.size.width / 2,
                        self.screen.frame.origin.y + self.screen.frame.size.height / 2,
                        self.screen.frame.size.width / 2,
                        self.screen.frame.size.height / 2)
      
    case .LeftHalf:
      return CGRectMake(self.screen.frame.origin.x,
                        self.screen.frame.origin.y,
                        self.screen.frame.size.width / 2,
                        self.screen.frame.size.height)

    case .RightHalf:
      return CGRectMake(self.screen.frame.origin.x + self.screen.frame.size.width / 2,
                        self.screen.frame.origin.y,
                        self.screen.frame.size.width / 2,
                        self.screen.frame.size.height)
      
    case .Full:
      return self.screen.frame

    default:
      return CGRectNull
      
    }
  }
}