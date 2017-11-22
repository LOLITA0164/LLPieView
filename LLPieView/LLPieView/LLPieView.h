//
//  LLPieView.h
//  LLPieView
//
//  Created by LOLITA on 2017/11/21.
//  Copyright © 2017年 LOLITA0164. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLShapeLayer.h"

typedef void(^ClickBlock)(NSInteger index);

typedef NS_ENUM(NSInteger , LLPieViewShowStyle) {
    LLPieViewNone,
    LLPieViewRoate_X,
    LLPieViewRoate_Y,
    LLPieViewRoate_Z,
    LLPieViewScale,
    LLPieViewOpacity,
    LLPieViewSpring
};

@interface LLPieView : UIView
/**
 数据数组，文字或者图片
 */
@property (nonatomic, copy) NSArray *dataArray;
/**
 填充色，默认为Alpha0.5的紫色
 */
@property (nonatomic, strong) UIColor *fillColor;
/**
 半径，最小半径默认为最大半径的一半，最大默认为父视图宽度的一半，当minRadius为0时，样式为圆盘
 */
@property (nonatomic, assign) CGFloat minRadius, maxRadius;
/**
 文字大小，默认为13.0
 */
@property (nonatomic, assign) CGFloat fontSize;
/**
 出现动画，如果设置了该属性，style则不会生效
 */
@property (nonatomic, strong) CAAnimation *animation;
/**
 动画风格
 */
@property (nonatomic, assign) LLPieViewShowStyle style;

/**
 初始化，点击回调，-1表示点击了非环形区域
 */
-(instancetype)initWithFrame:(CGRect)frame andClickBlock:(ClickBlock)clickBlock;

-(void)show;

@end
