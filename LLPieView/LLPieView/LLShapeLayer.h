//
//  LLShapeLayer.h
//  LLPieView
//
//  Created by LOLITA on 2017/11/21.
//  Copyright © 2017年 LOLITA0164. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface LLShapeLayer : CAShapeLayer
/**
 起始半径
 */
@property (nonatomic, assign) CGFloat minRadius, maxRadius;
/**
 起始角度
 */
@property (nonatomic, assign) CGFloat startAngle, endAngle;
/**
 中心
 */
@property (nonatomic, assign) CGPoint centerPoint;
/**
 填充的颜色
 */
@property (nonatomic, strong) UIColor *fullColor;
/**
 文字
 */
@property (nonatomic, copy) NSString *text;
/**
 图像
 */
@property (nonatomic, copy) UIImage *image;
/**
 tag
 */
@property (nonatomic, assign) NSInteger tag;
/**
 文字大小
 */
@property (nonatomic, assign) CGFloat fontSize;

-(void)creatShape;

-(void)selectedState;

-(void)unSelectedState;

@end
