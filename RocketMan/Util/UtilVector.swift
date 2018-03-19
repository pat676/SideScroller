//
//  UtilVector.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 14.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import SpriteKit

//MARK: 2D Vector

func +(point1: CGPoint, point2: CGPoint) -> CGPoint{
    var point = CGPoint.zero;
    point.x = point1.x+point2.x;
    point.y = point1.y+point2.y;
    return point;
}

func +=(point1: inout CGPoint, point2: CGPoint){
    point1 = point1+point2;
}

func -(point1: CGPoint, point2: CGPoint) -> CGPoint{
    var point = CGPoint.zero;
    point.x = point1.x-point2.x;
    point.y = point1.y-point2.y;
    return point;
}

func -=(point1: inout CGPoint, point2: CGPoint){
    point1 = point1-point2;
}

func /(vector: CGPoint, scalar: CGFloat) -> CGPoint{
    var newVector = CGPoint.zero;
    newVector.x = vector.x/scalar;
    newVector.y = vector.y/scalar;
    return newVector;
}

func /=(vector: inout CGPoint, scalar: CGFloat){
    vector = vector/scalar;
}

func *(vector: CGPoint, scalar: CGFloat) -> CGPoint{
    var newVector = CGPoint.zero;
    newVector.x = vector.x*scalar;
    newVector.y = vector.y*scalar;
    return newVector;
}

func *=(vector: inout CGPoint, scalar: CGFloat){
    vector = vector*scalar;
}


let π = CGFloat(Double.pi)
func shortestAngleBetween(_ angle1: CGFloat,
                          angle2: CGFloat) -> CGFloat {
    let twoπ = π * 2.0
    var angle = (angle2 - angle1).truncatingRemainder(dividingBy: twoπ)
    if (angle >= π) {
        angle = angle - twoπ
    }
    if (angle <= -π) {
        angle = angle + twoπ
    }
    return angle
}

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    func normalized() -> CGPoint {
        return self / length()
    }
    var angle: CGFloat {
        return atan2(y, x)
    }
}
