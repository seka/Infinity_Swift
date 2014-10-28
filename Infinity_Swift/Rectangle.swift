//
//  Rectangle.swift
//  Infinity_Swift
//
//  Created by PxP_ss on 2014/10/27.
//  Copyright (c) 2014年 pxp_ss. All rights reserved.
//

import UIKit

class Rectangle: UIView {
    
    var color = UIColor()

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, color: UIColor) {
        
        super.init(frame: frame)
        
        self.backgroundColor = .clearColor()
        self.color           = color
    }
    
    override func drawRect(rect: CGRect) {
        var ctx = UIGraphicsGetCurrentContext()
        var width  = self.bounds.size.width
        var height = self.bounds.size.height
        
        self.color.setFill()
        
        CGContextFillRect(ctx, CGRectMake(0, 0, width, height))
    }
}
