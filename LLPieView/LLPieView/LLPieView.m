//
//  LLPieView.m
//  LLPieView
//
//  Created by LOLITA on 2017/11/21.
//  Copyright © 2017年 LOLITA0164. All rights reserved.
//

#import "LLPieView.h"
@interface LLPieView ()
@property (nonatomic, strong) ClickBlock clickBlock;
@property (nonatomic, copy) NSMutableArray *shapeLayerArray;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) NSInteger clickIndex;
@property (nonatomic, assign) BOOL isLoaded;
@end
@implementation LLPieView

#pragma mark - <************************** 初始化 **************************>
-(NSMutableArray *)shapeLayerArray{
    if (_shapeLayerArray==nil) {
        _shapeLayerArray = [NSMutableArray array];
    }
    return _shapeLayerArray;
}

-(UIColor *)fillColor{
    if (_fillColor==nil) {
        _fillColor = [[UIColor purpleColor] colorWithAlphaComponent:0.5];
    }
    return _fillColor;
}

-(CGFloat)fontSize{
    if (_fontSize<=0) {
        _fontSize = 13.0;
    }
    return _fontSize;
}

-(CAAnimation *)animation{
    if (_animation==nil) {
        if (self.style==LLPieViewNone) {
        }
        else if (self.style==LLPieViewSpring){
            CASpringAnimation *anim = [CASpringAnimation animationWithKeyPath:@"transform.scale"];
            anim.damping = 5;                 // 阻尼系数
            anim.stiffness = 100;             // 刚度系数
            anim.mass = 1;                    // 质量
            anim.initialVelocity = 0;         // 初始速率
            anim.duration = anim.settlingDuration;  //结束时间
            anim.fromValue = @(0.85);
            anim.toValue = @(1);
            _animation = anim;
        }
        else{
            CABasicAnimation *basicAni;
            if (self.style==LLPieViewRoate_X) {
                basicAni = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
                basicAni.toValue = @(M_PI * 2);
            }else if (self.style==LLPieViewRoate_Y){
                basicAni = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
                basicAni.toValue = @(M_PI * 2);
            }else if (self.style==LLPieViewRoate_Z){
                basicAni = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                basicAni.toValue = @(M_PI * 2);
            }else if (self.style==LLPieViewScale){
                basicAni = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                basicAni.fromValue = @(0);
                basicAni.toValue = @(1);
            }else if (self.style==LLPieViewOpacity){
                basicAni = [CABasicAnimation animationWithKeyPath:@"opacity"];
                basicAni.fromValue = @(0);
                basicAni.toValue = @(1);
            }
            basicAni.duration = 0.75;
            basicAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];  // 速度
            _animation = basicAni;
        }
    }
    return _animation;
}

-(instancetype)initWithFrame:(CGRect)frame andClickBlock:(ClickBlock)clickBlock{
    self = [super initWithFrame:frame];
    if (self) {
        self.clickBlock = clickBlock;
        self.hidden = YES;
        self.maxRadius = CGRectGetWidth(self.frame)/2.0;
        self.minRadius = self.maxRadius/2.0;
    }
    return self;
}

// !!!: 数据数组处理方法
-(void)handleDatas:(NSArray*)datas{
    CGFloat percentAngle = M_PI*2.0/datas.count;
    CGFloat startAngle = 0.0;
    CGFloat endAngle = 0.0;
    for (int i=0; i<datas.count; i++) {
        startAngle = endAngle;
        endAngle = startAngle + percentAngle;
        LLShapeLayer *shapeLayer = [LLShapeLayer layer];
        shapeLayer.startAngle = startAngle;
        shapeLayer.endAngle = endAngle;
        self.maxRadius = MAX(self.maxRadius, self.minRadius);
        self.maxRadius = MIN(self.maxRadius, self.bounds.size.width/2.0);   // 最大半径最好不要超过父视图，否则超过部分触摸事件不被响应(重写响应链)
        self.minRadius = MIN(self.maxRadius, self.minRadius);
        shapeLayer.maxRadius = self.maxRadius;
        shapeLayer.minRadius = self.minRadius;
        shapeLayer.centerPoint = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
        shapeLayer.tag = i;
        shapeLayer.fullColor = self.fillColor;
        shapeLayer.fontSize = self.fontSize;
        id content = datas[i];
        if ([content isKindOfClass:[NSString class]]) {
            shapeLayer.text = content;
        }
        else if ([content isKindOfClass:[UIImage class]]){
            shapeLayer.image = content;
        }
        [shapeLayer creatShape];
        [self.layer addSublayer:shapeLayer];
        [self.shapeLayerArray addObject:shapeLayer];
    }
}


#pragma mark - <************************** 显示 **************************>
-(void)show{
    self.hidden = NO;
    [self.layer addAnimation:self.animation forKey:@"animation"];
    if (self.isLoaded==NO) {
        [self handleDatas:self.dataArray];
        self.isLoaded = YES;
    }
}

#pragma mark - <************************** 视图的触摸事件 **************************>
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    for (LLShapeLayer *shaperLayer in self.shapeLayerArray) {
        if (CGPathContainsPoint(shaperLayer.path, 0, touchPoint, YES)&&self.clickBlock) {   // 寻找触摸的形状
            [shaperLayer selectedState];    // 设置为选中状态
            self.isSelected = YES;  //
            self.clickIndex = shaperLayer.tag;  // 记录下选择的索引tag
        }
    }
}

// 触摸结束时回调
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for (LLShapeLayer *shaperLayer in self.shapeLayerArray) {
        [shaperLayer unSelectedState];  // 恢复为正常状态
    }
    if (self.isSelected&&self.clickBlock) {
        self.clickBlock(self.clickIndex);   // 回调
    }else{
        self.clickBlock(-1);    // 非区域的触摸
    }
    self.isSelected = NO;
}

// 触摸取消时，考虑到手势问题
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for (LLShapeLayer *shaperLayer in self.shapeLayerArray) {
        [shaperLayer unSelectedState];  // 恢复为正常状态
    }
    self.isSelected = NO;
}


@end
