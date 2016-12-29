# LiveThumbView
今年的App行业，应该就是直播软件最火了。但凡是一个社交App，直播功能似乎已经是最基础的功能了。
这个只是一个点赞的小功能，并不是全部的直播

#爱心图形
```objc
-(void)drawHeartInRect:(CGRect)rect{
    [self.strokeColor setStroke];
    [self.fillColor setFill];
    
    CGFloat drawingPadding = 4.0;
    CGFloat curveRadius = floor((CGRectGetWidth(rect) - 2*drawingPadding) / 4.0);
    
    //贝赛尔曲线
    UIBezierPath *heartPath = [UIBezierPath bezierPath];
    //爱心的最底部的定点
    CGPoint tipLocation =  CGPointMake(floor(CGRectGetWidth(rect) / 2.0), CGRectGetHeight(rect) - drawingPadding);
    //曲线的起点
    [heartPath moveToPoint:tipLocation];
    
    //Move to top left start of curve
    CGPoint topLeftCurveStart = CGPointMake(drawingPadding, floor(CGRectGetHeight(rect) / 2.4));
    
    [heartPath addQuadCurveToPoint:topLeftCurveStart controlPoint:CGPointMake(topLeftCurveStart.x, topLeftCurveStart.y + curveRadius)];
    
    //Create top left curve
    [heartPath addArcWithCenter:CGPointMake(topLeftCurveStart.x + curveRadius, topLeftCurveStart.y) radius:curveRadius startAngle:M_PI endAngle:0 clockwise:YES];
    
    //Create top right curve
    CGPoint topRightCurveStart = CGPointMake(topLeftCurveStart.x + 2*curveRadius, topLeftCurveStart.y);
    [heartPath addArcWithCenter:CGPointMake(topRightCurveStart.x + curveRadius, topRightCurveStart.y) radius:curveRadius startAngle:M_PI endAngle:0 clockwise:YES];
    
    //Final curve to bottom heart tip
    CGPoint topRightCurveEnd = CGPointMake(topLeftCurveStart.x + 4*curveRadius, topRightCurveStart.y);
    [heartPath addQuadCurveToPoint:tipLocation controlPoint:CGPointMake(topRightCurveEnd.x, topRightCurveEnd.y + curveRadius)];
    
    [heartPath fill];
    
    heartPath.lineWidth = 1;
    heartPath.lineCapStyle = kCGLineCapRound;
    heartPath.lineJoinStyle = kCGLineCapRound;
    [heartPath stroke];
}

```
点赞的爱心图形不是图片，而是通过贝塞尔曲线画的。

#动画效果
```objc
//动画时间持续6秒
    NSTimeInterval totalAinmationDuration = 6;
    
    CGFloat heartSize = CGRectGetWidth(self.bounds);
    CGFloat heartCenterX = self.center.x;
    CGFloat viewHeight = CGRectGetHeight(view.bounds);
    
    //动画开始前的准备,设置透明度为0，仅通过设置缩放比例就可实现视图扑面而来和缩进频幕的效果。
    self.transform = CGAffineTransformMakeScale(0, 0);
    self.alpha = 0;
    
    //动画开始
    
    [UIView animateWithDuration:0.5      //动画时长
                          delay:0.0      //延迟时间
         usingSpringWithDamping:0.6      //dampingRatio （阻尼系数）范围 0~1 当它设置为1时，动画是平滑的没有振动的达到静止状态，越接近0 振动越大
          initialSpringVelocity:0.8      //velocity （弹性速率）
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         //每次变换前都要置位，不然你变换用的坐标系统不是屏幕坐标系统（即绝对坐标系统），而是上一次变换后的坐标系统
                         self.transform = CGAffineTransformIdentity;
                         self.alpha = 0.9;
    }
                     completion:NULL];
    //rotationDirection的赋值只会是1 or -1
    NSInteger i = arc4random_uniform(2);
    NSInteger rotationDirection = 1 - (2*i);
    NSInteger rotationFraction = arc4random_uniform(10);
    
    [UIView animateWithDuration:totalAinmationDuration animations:^{
        //CGAffineTransformMakeRotation(CGFloat angle)（旋转:设置旋转角度)
        self.transform = CGAffineTransformMakeRotation(rotationDirection * M_PI/(16 + rotationFraction*0.2));
    }completion:NULL];
    
    //贝赛尔曲线
    UIBezierPath *heartTravelPath = [UIBezierPath bezierPath];
    //设置起始位置
    [heartTravelPath moveToPoint:self.center];
    //设置结束的位置的点
    CGPoint endPoint = CGPointMake(heartCenterX + (rotationDirection) * arc4random_uniform(2*heartSize), viewHeight/6.0 + arc4random_uniform(viewHeight/4.0));
    //travelDirection = 1 or -1
    NSInteger j = arc4random_uniform(2);
    NSInteger travelDirection = 1- (2*j);
    
    CGFloat xDelta = (heartSize/2.0 + arc4random_uniform(2*heartSize)) * travelDirection;
    CGFloat yDelta = MAX(endPoint.y ,MAX(arc4random_uniform(8*heartSize), heartSize));
    CGPoint controlPoint1 = CGPointMake(heartCenterX + xDelta, viewHeight - yDelta);
    CGPoint controlPoint2 = CGPointMake(heartCenterX - 2*xDelta, yDelta);
    
    //绘制一个s形状的贝赛尔曲线，
    [heartTravelPath addCurveToPoint:endPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
    
    
    //关键帧动画
    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyFrameAnimation.path = heartTravelPath.CGPath;
    //动画的一种方式
    keyFrameAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    //动画时长
    keyFrameAnimation.duration = totalAinmationDuration + endPoint.y/viewHeight;
    //添加动画
    [self.layer addAnimation:keyFrameAnimation forKey:@"positionOnPath"];
    
    [UIView animateWithDuration:totalAinmationDuration animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
```
#创建方式
```objc
    ThumbView* heart = [[ThumbView alloc]initWithFrame:CGRectMake(0, 0, 36, 36)];
    [self.view addSubview:heart];
    CGPoint fountainSource = CGPointMake(36 + 36/2.0, self.view.bounds.size.height - 36/2.0 - 10);
    heart.center = fountainSource;
    [heart thumbINView:self.view];
```

#效果
![ThumbView.gif](http://upload-images.jianshu.io/upload_images/2368708-2c107a85ef2c4619.gif?imageMogr2/auto-orient/strip)
