//
//  ViewController.m
//  LLPieView
//
//  Created by LOLITA on 2017/11/21.
//  Copyright © 2017年 LOLITA0164. All rights reserved.
//

#import "ViewController.h"
#import "LLPieView.h"

#define Alert(title,msg) [[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show]

@interface ViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong)LLPieView *pieView;
@property (nonatomic, strong) CABasicAnimation *animation;
@end

@implementation ViewController
{
    CGSize pieViewSize;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    pieViewSize = CGSizeMake([UIScreen mainScreen].bounds.size.width/2.0, [UIScreen mainScreen].bounds.size.width/2.0);
    [self.view addSubview:self.pieView];
}



-(LLPieView *)pieView{
    if (_pieView==nil) {
        _pieView = [[LLPieView alloc] initWithFrame:CGRectMake(0, 0, pieViewSize.width, pieViewSize.height) andClickBlock:^(NSInteger index) {
            NSString *tip = [NSString stringWithFormat:@"点击了第%ld个",index+1];
            if (index==-1) {
                tip = @"点击了空白处";
            }
            Alert(@"提示", tip);
        }];
        _pieView.style = LLPieViewSpring;   // 动画风格
//        _pieView.animation = self.animation;  // 如果自定义了动画，则style不会生效
        _pieView.dataArray = @[@"LOLITA",[UIImage imageNamed:@"ss"],@"LOLITA",[UIImage imageNamed:@"ss"],@"LOLITA",[UIImage imageNamed:@"ss"],@"LOLITA",[UIImage imageNamed:@"ss"]];
        _pieView.fontSize = 10;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [_pieView addGestureRecognizer:pan];
    }
    return _pieView;
}


-(CABasicAnimation *)animation{
    if (_animation==nil) {
        _animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        _animation.fromValue = @(0);
        _animation.toValue = @(1);
        _animation.duration = 0.75;
        _animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];  // 速度
    }
    return _animation;
}


-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.pieView show];
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    CGPoint newCenter = touchPoint;
    if (newCenter.x+self.pieView.bounds.size.width/2.0>[UIScreen mainScreen].bounds.size.width) {
        newCenter.x = [UIScreen mainScreen].bounds.size.width-self.pieView.bounds.size.width/2.0;
    }
    if (newCenter.x<self.pieView.bounds.size.width/2.0) {
        newCenter.x = self.pieView.bounds.size.width/2.0;
    }
    if (newCenter.y+self.pieView.bounds.size.height/2.0>[UIScreen mainScreen].bounds.size.height) {
        newCenter.y = [UIScreen mainScreen].bounds.size.height-self.pieView.bounds.size.height/2.0;
    }
    if (newCenter.y<self.pieView.bounds.size.height/2.0) {
        newCenter.y = self.pieView.bounds.size.height/2.0;
    }
    self.pieView.center = newCenter;
}

// !!!: 拖拽手势
-(void)panAction:(UIPanGestureRecognizer *)pan{
    //获取手势位置
    CGPoint translation = [pan translationInView:self.pieView];
    CGPoint newCenter = CGPointMake(pan.view.center.x+ translation.x,pan.view.center.y + translation.y);
    if (newCenter.x+pan.view.bounds.size.width/2.0>[UIScreen mainScreen].bounds.size.width) {
        newCenter.x = [UIScreen mainScreen].bounds.size.width-pan.view.bounds.size.width/2.0;
    }
    if (newCenter.x<pan.view.bounds.size.width/2.0) {
        newCenter.x = pan.view.bounds.size.width/2.0;
    }
    if (newCenter.y+pan.view.bounds.size.height/2.0>[UIScreen mainScreen].bounds.size.height) {
        newCenter.y = [UIScreen mainScreen].bounds.size.height-pan.view.bounds.size.height/2.0;
    }
    if (newCenter.y<pan.view.bounds.size.height/2.0) {
        newCenter.y = pan.view.bounds.size.height/2.0;
    }
    pan.view.center = newCenter;
    [pan setTranslation:CGPointZero inView:self.pieView];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
