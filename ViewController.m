//
//  ViewController.m
//  LiveThumbView
//
//  Created by cAibDe on 16/9/12.
//  Copyright © 2016年 cAibDe. All rights reserved.
//

#import "ViewController.h"
#import "ThumbView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton * heartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    heartBtn.backgroundColor = [UIColor redColor];
    heartBtn.frame = CGRectMake(36, [UIScreen mainScreen].bounds.size.height - 36 - 10, 36, 36);
//    [heartBtn setImage:[UIImage imageNamed:@"点赞"] forState:UIControlStateNormal];
    [heartBtn addTarget:self action:@selector(showTheLove:) forControlEvents:UIControlEventTouchUpInside];
    heartBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    heartBtn.layer.shadowOffset = CGSizeMake(0, 0);
    heartBtn.layer.shadowOpacity = 0.5;
    heartBtn.layer.shadowRadius = 1;
    heartBtn.adjustsImageWhenHighlighted = NO;
    [self.view addSubview:heartBtn];
   
}
// 点赞
-(void)showTheLove:(UIButton *)sender{
    
    ThumbView* heart = [[ThumbView alloc]initWithFrame:CGRectMake(0, 0, 36, 36)];
    [self.view addSubview:heart];
    CGPoint fountainSource = CGPointMake(36 + 36/2.0, self.view.bounds.size.height - 36/2.0 - 10);
    heart.center = fountainSource;
    [heart thumbINView:self.view];
    
    // button点击动画
    CAKeyframeAnimation *btnAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    btnAnimation.values = @[@(1.0),@(0.7),@(0.5),@(0.3),@(0.5),@(0.7),@(1.0), @(1.2), @(1.4), @(1.2), @(1.0)];
    btnAnimation.keyTimes = @[@(0.0),@(0.1),@(0.2),@(0.3),@(0.4),@(0.5),@(0.6),@(0.7),@(0.8),@(0.9),@(1.0)];
    btnAnimation.calculationMode = kCAAnimationLinear;
    btnAnimation.duration = 0.3;
    [sender.layer addAnimation:btnAnimation forKey:@"SHOW"];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
