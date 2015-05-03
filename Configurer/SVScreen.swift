//
//  SVScreen.swift
//  Configurer
//
//  Created by Sebastien Villar on 02/05/15.
//  Copyright (c) 2015 -. All rights reserved.
//

import Foundation
import AppKit

enum kSVScreenArea: String {
  case TopHalf = "TopHalf", TopLeftQuadran = "TopLeftQuadran", TopRightQuadran = "TopRightQuadran"
  case BottomHalf = "BottomHalf", BottomLeftQuadran = "BottomLeftQuadran", BottomRightQuadran = "BottomRightQuadran"
  case LeftHalf = "LeftHalf", RightHalf = "RightHalf"
  case Full = "Full"
  
  static let allValues = [TopHalf, TopLeftQuadran, TopRightQuadran, BottomHalf, BottomLeftQuadran, BottomRightQuadran, LeftHalf, RightHalf, Full]
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
    var topOffset = self.screen.frame.size.height - self.screen.visibleFrame.size.height - self.screen.visibleFrame.origin.y

    switch area {
    case .TopHalf:
      return CGRectMake(self.screen.visibleFrame.origin.x,
                        topOffset,
                        self.screen.visibleFrame.size.width,
                        self.screen.visibleFrame.size.height / 2)

    case .TopLeftQuadran:
      return CGRectMake(self.screen.visibleFrame.origin.x,
                        topOffset,
                        self.screen.visibleFrame.size.width / 2,
                        self.screen.visibleFrame.size.height / 2)

    case .TopRightQuadran:
      return CGRectMake(self.screen.visibleFrame.origin.x + self.screen.visibleFrame.size.width / 2,
                        topOffset,
                        self.screen.visibleFrame.size.width / 2,
                        self.screen.visibleFrame.size.height / 2)
      
    case .BottomHalf:
      return CGRectMake(self.screen.visibleFrame.origin.x,
                        topOffset + self.screen.visibleFrame.size.height / 2,
                        self.screen.visibleFrame.size.width,
                        self.screen.visibleFrame.size.height / 2)

    case .BottomLeftQuadran:
      return CGRectMake(self.screen.visibleFrame.origin.x,
                        topOffset + self.screen.visibleFrame.size.height / 2,
                        self.screen.visibleFrame.size.width / 2,
                        self.screen.visibleFrame.size.height / 2)

    case .BottomRightQuadran:
      return CGRectMake(self.screen.visibleFrame.origin.x + self.screen.visibleFrame.size.width / 2,
                        topOffset + self.screen.visibleFrame.size.height / 2,
                        self.screen.visibleFrame.size.width / 2,
                        self.screen.visibleFrame.size.height / 2)
      
    case .LeftHalf:
      return CGRectMake(self.screen.visibleFrame.origin.x,
                        topOffset,
                        self.screen.visibleFrame.size.width / 2,
                        self.screen.visibleFrame.size.height)

    case .RightHalf:
      return CGRectMake(self.screen.visibleFrame.origin.x + self.screen.visibleFrame.size.width / 2,
                        topOffset,
                        self.screen.visibleFrame.size.width / 2,
                        self.screen.visibleFrame.size.height)
      
    case .Full:
      return self.screen.visibleFrame

    default:
      return CGRectNull
      
    }
  }
}