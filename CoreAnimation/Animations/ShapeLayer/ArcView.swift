//
//  ArcView.swift
//  CoreAnimation
//
//  Created by zhoufei on 2018/10/17.
//  Copyright © 2018年 ChenDao. All rights reserved.
//
// 在使用图层mask时，若要做出镂空的效果，需要在要镂空的区域时偶数层描绘。
// 比如：0层时，在一个矩形中，上部分和下部分都被一个封闭的路径包裹着，则中间没有被描绘覆盖的间隙就时镂空的图形
// 比如：2层时，在一个矩形中，先对整个举行描绘，描绘的一个封闭的矩形。然后再在矩形中描绘一个封闭的圆，那么这个圆就是镂空图形

import UIKit

class ArcView: UIView {
    
    lazy var arcState:Bool = {
        self.drawCircularArc()
        return true
    }()

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _ = arcState
    }
    
    func drawCircularArc() {
        //第一种方式，0层路径描绘
        let path =  UIBezierPath()//UIBezierPath(rect: self.bounds)
        path.lineCapStyle = .round
        path.move(to: CGPoint(x: 0, y: self.bounds.size.height))
        path.addArc(withCenter: CGPoint(x: self.bounds.size.width*0.5, y: self.bounds.size.height), radius: self.bounds.size.width*0.5, startAngle: CGFloat(M_PI), endAngle: 0, clockwise: true)
        path.addLine(to: CGPoint(x: self.bounds.size.width, y: 0))
        path.addLine(to: CGPoint(x:0, y: 0))
        path.close()
        
        let path0 =  UIBezierPath()
        path0.lineCapStyle = .round
        path0.move(to: CGPoint(x: self.bounds.size.width - 5, y: self.bounds.size.height))
        path0.addArc(withCenter: CGPoint(x: self.bounds.size.width*0.5, y: self.bounds.size.height), radius: self.bounds.size.width*0.5 - 5, startAngle: 0, endAngle: CGFloat(M_PI), clockwise: false)
        path0.close()
        
        let path1 = UIBezierPath() //UIBezierPath(rect: self.bounds)
        path1.append(path0)
        path1.append(path)
        
        
        //第二种方式，2层路径描绘
        let bigArc:CGFloat = self.bounds.size.width*0.5
        let smallArc:CGFloat = 2.5
        let arcCenter = CGPoint(x: self.bounds.size.width*0.5, y: self.bounds.size.height-smallArc)
        
        let bez2 = UIBezierPath(rect: self.bounds)
        let bez = UIBezierPath(arcCenter: arcCenter, radius: bigArc, startAngle: 0, endAngle: CGFloat(M_PI), clockwise: false)
        bez.addArc(withCenter: CGPoint(x: smallArc, y: self.bounds.size.height-smallArc), radius: smallArc, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_PI*2), clockwise: false)
        bez.addArc(withCenter: arcCenter, radius: self.bounds.size.width*0.5 - 5, startAngle: CGFloat(M_PI), endAngle: 0, clockwise: true)
        bez.addArc(withCenter: CGPoint(x: self.bounds.size.width - smallArc, y: self.bounds.size.height-smallArc), radius: smallArc, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_PI*2), clockwise: false)
        
        bez2.append(bez)
        
        let shape = CAShapeLayer()
        shape.path = bez2.cgPath
        shape.frame = self.bounds
        
        self.layer.mask = shape
    }

}
