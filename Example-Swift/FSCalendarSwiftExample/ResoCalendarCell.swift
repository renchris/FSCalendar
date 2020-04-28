//
//  DIYCalendarCell.swift
//  FSCalendarSwiftExample
//
//  Created by dingwenchao on 06/11/2016.
//  Copyright © 2016 wenchao. All rights reserved.
//

import Foundation

import UIKit

enum ResoSelectionType : Int {
    case none
    case single
    case leftBorder
    case middle
    case rightBorder
}


class ResoCalendarCell: FSCalendarCell {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        let width: CGFloat = 640
        let height: CGFloat = 640
             
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = CGRect(x: 0, y: 0,
                                  width: width, height: height)
             
        let path = CGMutablePath()
             
        stride(from: 0, to: CGFloat.pi * 2, by: CGFloat.pi / 6).forEach {
            angle in
            var transform  = CGAffineTransform(rotationAngle: angle)
                .concatenating(CGAffineTransform(translationX: width / 2, y: height / 2))
            
            let petal = CGPath(ellipseIn: CGRect(x: -20, y: 0, width: 40, height: 100),
                               transform: &transform)
            
            path.addPath(petal)
        }
        
        if !(shapeLayer.path == path) {
            shapeLayer.path = path
        }

        let eventSize: CGFloat = shapeLayer.frame.size.height / 6.0
        eventIndicator.frame = CGRect(x: preferredEventOffset.x, y: shapeLayer.frame.maxY + eventSize * 0.17 + preferredEventOffset.y, width: width, height: eventSize * 0.83)

    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
