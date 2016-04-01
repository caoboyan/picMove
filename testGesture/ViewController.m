//
//  ViewController.m
//  testGesture
//
//  Created by Boyan Cao on 16/4/1.
//  Copyright © 2016年 2015-293. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGPoint pointStart;

@property (nonatomic, assign) CGPoint pointEnd;

@property (nonatomic, strong) NSMutableArray * viewArray;

@property (nonatomic, assign) CGRect originRect;

@property (nonatomic, assign) BOOL isFirstIn;

@property (nonatomic, assign) CGRect  beforeRect;

@property (nonatomic, assign) BOOL hasEverValued;


@end

@implementation ViewController


-(NSMutableArray *)viewArray{
    if (!_viewArray) {
        _viewArray = [[NSMutableArray alloc]init];
    }
    return _viewArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
}

- (void)setUpView{
    
    CGFloat left = 0;
    CGFloat top = 100;
    for (int i = 0; i<20; i++) {
        UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(left, top, [UIScreen mainScreen].bounds.size.width/4, [UIScreen mainScreen].bounds.size.width/4)];
        view1.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
        view1.userInteractionEnabled = YES;
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
        [view1 addGestureRecognizer:pan];
        pan.delegate = self;
        UILongPressGestureRecognizer * tap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        tap.minimumPressDuration = 0.1;
        [view1 addGestureRecognizer:tap];
        tap.delegate = self;
        [self.view addSubview:view1];
        view1.tag = i;
        left = left + [UIScreen mainScreen].bounds.size.width/4;
        if (left >= [UIScreen mainScreen].bounds.size.width) {
            left = 0;
            top = top + [UIScreen mainScreen].bounds.size.width/4;
        }
        [self.viewArray addObject:view1];
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)recongnizer{
     UIView * view = recongnizer.view;
    if (recongnizer.state == UIGestureRecognizerStateBegan) {
//        view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        [self.view bringSubviewToFront:view];
    }else if (recongnizer.state == UIGestureRecognizerStateEnded){
//        view.transform = CGAffineTransformIdentity;
    }
   
}

- (void)pan:(UIPanGestureRecognizer *)pan{

    
   
    
    UIView * view = pan.view;
    
    CGPoint point = [pan locationInView:self.view];
    
    if (!self.isFirstIn) {
        self.originRect = view.frame;
        self.isFirstIn = YES;
    }

    NSInteger xIndex = ceil( point.x/([UIScreen mainScreen].bounds.size.width/4));
    NSInteger yIndex = ceil( (point.y - 100)/([UIScreen mainScreen].bounds.size.width/4));
    NSInteger index = xIndex + ((yIndex-1) * 4);

    if (pan.state == UIGestureRecognizerStateBegan) {
        self.pointStart = [pan translationInView:self.view];
    }
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        self.pointEnd = [pan translationInView:self.view];
        CGFloat changeY = self.pointEnd.y - self.pointStart.y;
        CGFloat changeX = self.pointEnd.x - self.pointStart.x;
        CGRect rect = view.frame;
        rect.origin.x = self.originRect.origin.x + changeX;
        rect.origin.y = self.originRect.origin.y + changeY;
        view.frame = rect;
        
        if (view.tag != index - 1) {
            UIView * viewChange = [self.viewArray objectAtIndex:index -1];
            if (!self.hasEverValued) {
                self.beforeRect = viewChange.frame;
                self.hasEverValued = YES;
            }
            viewChange.frame = self.originRect;
            viewChange.transform = CGAffineTransformIdentity;
        }
        
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        view.frame = self.beforeRect;
        self.originRect = view.frame;
        self.isFirstIn = NO;
        self.hasEverValued = NO;
        
    }
    
}


//主要是为了实现一个控件上多种手势的实现
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

@end
