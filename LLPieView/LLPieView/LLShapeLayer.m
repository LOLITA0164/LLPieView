//
//  LLShapeLayer.m
//  LLPieView
//
//  Created by LOLITA on 2017/11/21.
//  Copyright © 2017年 LOLITA0164. All rights reserved.
//

#import "LLShapeLayer.h"

@implementation LLShapeLayer

-(void)creatShape{
    
    // 绘制路径
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.centerPoint radius:self.minRadius startAngle:self.startAngle endAngle:self.endAngle clockwise:YES]; // 绘制内弧度
    path = [path bezierPathByReversingPath];    // 反转路径
    [path addArcWithCenter:self.centerPoint radius:self.maxRadius startAngle:self.startAngle endAngle:self.endAngle clockwise:YES]; // 绘制外弧度
    [path closePath];   // 封闭路径
    self.path = path.CGPath;
    self.fillColor = [self.fullColor colorWithAlphaComponent:0.5].CGColor;  // 设置shapeLayer的填充色
    self.lineWidth = 0.5;   //
    self.strokeColor = [UIColor whiteColor].CGColor;    // 设置shapeLayer的描边色
    
    // 为了获取不规则图形中心点而创建的临时路径
    UIBezierPath *pathTmp = [UIBezierPath bezierPathWithArcCenter:self.centerPoint radius:(self.minRadius+self.maxRadius)/2.0 startAngle:self.startAngle endAngle:(self.startAngle+self.endAngle)/2.0 clockwise:YES];
    
    // 绘制文字
    if (self.text) {
        // 获取中心点
        CGSize sizeNew = [self.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.fontSize]}];
        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.frame = CGRectMake(pathTmp.currentPoint.x-sizeNew.width/2.0, pathTmp.currentPoint.y-sizeNew.height/2.0, sizeNew.width, sizeNew.height);
        textLayer.string = self.text;
        textLayer.fontSize = self.fontSize;
        textLayer.contentsScale = 3;
        textLayer.alignmentMode = kCAAlignmentCenter;
        textLayer.foregroundColor = [UIColor whiteColor].CGColor;
        [self addSublayer:textLayer];
    }
    // 绘制图像
    if (self.image) {
        CALayer *layer = [CALayer new];
        layer.position = pathTmp.currentPoint;
        layer.bounds = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
        layer.contents = (id)self.image.CGImage;
        [self addSublayer:layer];
    }
    
    // 设置阴影
    self.shadowColor = self.fullColor.CGColor;//shadowColor阴影颜色
    self.shadowOffset = CGSizeMake(2,2);//shadowOffset阴影偏移
    self.shadowOpacity = 1;//阴影透明度，默认0
}

-(void)selectedState{
    self.fillColor = [self.fullColor colorWithAlphaComponent:1].CGColor;
}

-(void)unSelectedState{
    self.fillColor = [self.fullColor colorWithAlphaComponent:0.5].CGColor;
}



@end
