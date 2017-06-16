//
//  SlideMenuController.m
//  BestTime
//
//  Created by iPhone8s on 2017/5/17.
//  Copyright © 2017年 iPhone8s. All rights reserved.
//

#import "SlideMenuController.h"
#import "UtilsMacro.h"
#import <Masonry.h>
@interface SlideMenuController ()

@property (nonatomic, weak) IBOutlet UIView *menuContainer;
@property (nonatomic, weak) IBOutlet UIView *contentContainer;


@property (nonatomic, strong) UIButton *maskButton;
@property (nonatomic, assign) BOOL folded;
@property (nonatomic, assign) CGPoint originalPoint;
@property (nonatomic, assign) CGFloat scaleFactor;
@property (nonatomic, assign) CGFloat offsetX;
@property (nonatomic, assign) CGFloat originalX;
@property (nonatomic, assign) CGFloat deltascaleFactor;
@property (nonatomic, assign) CGFloat deltaAlphaFactor;
@property (nonatomic, assign) CGFloat miniumOffsetX;


@end

@implementation SlideMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initParams];
}

// 视图切换效果
- (void)switchController {
    // 取反，点击按钮时进行视图切换
    _folded = !_folded;
    if (_folded) {
        [self showContentViewController];
    } else {
        [self showMenuViewController];
    }
}

// 滑动手势
- (IBAction)panned:(UIPanGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self.view];
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            _originalPoint = point;
            [self setShadowVisible:YES];
            break;
        case UIGestureRecognizerStateChanged: {
            //
            CGFloat tx = point.x - self.originalPoint.x + self.originalX;
            tx = tx < 0 ? 0 : tx;
            
            CGFloat s = 1 - tx * self.deltascaleFactor;
            s = s < 0 ? 0 : s;
            
            // 设置变幻矩阵
            CGAffineTransform transform = CGAffineTransformMakeTranslation(tx, 0);
            transform = CGAffineTransformScale(transform, s, s);
            _contentContainer.transform = transform;
            
            //
            CGFloat alpha = tx * self.deltaAlphaFactor;
            alpha = alpha > 1 ? 1 : alpha;
            _menuContainer.alpha = alpha;
        } break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            CGAffineTransform transform = _contentContainer.transform;
            if (transform.tx >= self.miniumOffsetX) {
                self.folded = NO;
                [self showMenuViewController];
            } else {
                self.folded = YES;
                [self showContentViewController];
            }
        } break;
        default:
            NSLog(@"Other state of pan gesture...");
    }
}

- (CGFloat)originalX {
    return (_folded ? 0 : _offsetX);
}
#pragma mark - Private

-(void)initParams {
    // 视图呈折叠状态
    _folded = YES;
    // 最终缩放状态的大小
    _scaleFactor = 0.95;
    // 视图相对左边的偏移量
    _offsetX = self.view.frame.size.width / 2 + 30;
    // 单位距离透明度的变化量
    _deltaAlphaFactor = 1 / _offsetX;
    // 最小滑动的偏移量
    _miniumOffsetX = _offsetX / 2;
    // 单位距离的缩放量
    _deltascaleFactor = (1 - _scaleFactor) / _offsetX;
}

- (void)showMenuViewController {
    //
    [self setShadowVisible:YES];
    
    // 构造矩阵  平移变化
    CGAffineTransform transform = CGAffineTransformMakeTranslation(_offsetX, 0);
    // 缩放
    transform = CGAffineTransformScale(transform, _scaleFactor, _scaleFactor);
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.menuContainer.alpha = 1;
        self.contentContainer.transform = transform;
    } completion:^(BOOL finished) {
        // 添加透明按钮
        [self setMaskButtonVisible:YES];
    }];
}

- (void)showContentViewController {
    //
    [self setShadowVisible:NO];
    
    //
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.menuContainer.alpha = 0;
        self.contentContainer.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self setMaskButtonVisible:NO]; 
    }];
}

// 设置阴影效果
- (void)setShadowVisible:(BOOL)visible {
    if (visible) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:_contentContainer.layer.bounds];
        _contentContainer.layer.shadowPath = path.CGPath;
        _contentContainer.layer.shadowColor = [UIColor blackColor].CGColor;
        _contentContainer.layer.shadowOffset = CGSizeZero;
        _contentContainer.layer.shadowOpacity = 0.4;
        _contentContainer.layer.shadowRadius = 4.5;
    } else {
        _contentContainer.layer.shadowRadius = 0;
    }
}

// 添加透明按钮
- (void)setMaskButtonVisible:(BOOL)visible {
    if (_maskButton == nil) {
        //
        self.maskButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_maskButton addTarget:self action:@selector(maskButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        //
        [_contentContainer addSubview:_maskButton];
        [_maskButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_contentContainer).insets(UIEdgeInsetsZero);
        }];
    }
    
    _maskButton.hidden = !visible;
}

// 按钮点击事件
- (void)maskButtonPressed {
    // 取反
    _folded = !_folded;
    [self showContentViewController];
}

@end
