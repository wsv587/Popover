//
//  VVSPopoverAnimationManager.m
//  VVSPopover
//
//  Created by sw on 16/10/22.
//  Copyright © 2016年 sw. All rights reserved.
//

#import "VVSPopoverAnimationManager.h"
#import "VVSPresentationController.h"
#import "UIView+VVSFrame.h"

@interface VVSPopoverAnimationManager ()<UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>
{
    BOOL isPresented;
    UIViewController *sourceViewController;
}

@end

@implementation VVSPopoverAnimationManager
- (instancetype)init {
    if (self = [super init]) {
        // init 和 dealloc方法中尽量不要使用getter/setter
        _transitionDuration = 0.5;
        _coverViewResponse = YES;
        _animatable = YES;
    }
    return self;
}

#pragma mark - UIViewControllerTransitioningDelegate
/**
 该方法用于返回负责转场的对象
 */
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    VVSPresentationController *presentation = [[VVSPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
     presentation.presentedViewFrame = self.presentedViewFrame;
    presentation.coverViewResponse = self.isConverViewResponse;
    NSLog(@"source == %@",source);
    sourceViewController = source;
    return presentation;
}

/**
 告诉系统谁来负责转场如何出现
 */
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    isPresented = YES;
    return self;
}
/**
 告诉系统谁来负责转场如何消失
 */

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    isPresented = NO;
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (!self.isAnimatable) {
        return 0.f;
    }
    return self.transitionDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (isPresented) {
            [self vvs_presentWithAnimateTransition:transitionContext style:self.transitionAnimationStyle];
        
        } else {
            [self vvs_dismissWithAnimateTransition:transitionContext style:self.transitionAnimationStyle];
    }
}

#pragma mark - private
- (void)vvs_presentWithAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext style:(VVSTransitionAnimationStyle)transitionAnimationStyle {
    // 动画时间
    NSTimeInterval duration = [self transitionDuration:transitionContext];

    // 被展现的视图
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    [[transitionContext containerView] addSubview:toView];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    // 被展现的视图如何展现
    VVSTransitionAnimationStyle style = self.transitionAnimationStyle;
    CGAffineTransform toTransfrom;
    // strentch
    if (style == VVSTransitionAnimationStyleStretchFromTop) {
        /**
         *  单一方向动画时候，只要保证另一个方向的值是固定的即可，无所谓大小
         *  如果x是1.那么其他地方也要是1;如果x是0.5，那么其他地方也要是0.5
         */
        // x方向不变，y方向从0~1
        toView.layer.anchorPoint = CGPointMake(0.5, 0.f); // x无所谓
        toView.transform = CGAffineTransformMakeScale(1.0, 0.f);
        //  toView.transform = CGAffineTransformIdentity;
        toTransfrom = CGAffineTransformMakeScale(1.0, 1.0);
        
    } else if (style == VVSTransitionAnimationStyleStretchFromLeft) {
        // y方向不变，x方向从0~1
        toView.layer.anchorPoint = CGPointMake(0.f, 0.5); // y 无所谓
        toView.transform = CGAffineTransformMakeScale(0.f, 0.5);
        toTransfrom = CGAffineTransformMakeScale(1.f, 0.5);
    } else if (style == VVSTransitionAnimationStyleStretchFromRight) {
        // 从右边向左边伸展，锚点此时应该固定在右边，所以X方向为0，可以理解为水平方向上距离锚点的距离为0
        // 锚点X为1.f代表从右边开始展开
        toView.layer.anchorPoint = CGPointMake(1.f, 0.5); // y 无所谓
        //(0.f, 1.f)而不是(0.f, 0.5)，因为高度上不需要缩放，1.f代表高度不缩放，如果为0.5代表高度从0.5开始缩放
        // X值为0.f代表宽度从0开始变化
        // Y值为1.f代表高度始终不变
        toView.transform = CGAffineTransformMakeScale(0.f, 1.f);
        toTransfrom = CGAffineTransformIdentity;

    } else if (style == VVSTransitionAnimationStyleStretchFromBottom) {
        // 从底部向上伸展，锚点此时应该固定在底部，所以Y方向为0，可以理解为垂直方向上距离锚点的距离为0
        // 错误
        toView.layer.anchorPoint = CGPointMake(0.5, 1.f); // x无所谓
        toView.transform = CGAffineTransformMakeScale(0.5, 1.f);
        toTransfrom = CGAffineTransformMakeScale(0.5, 0.f);
        toTransfrom = CGAffineTransformIdentity;
        // 正确
        // 锚点的Y值为1.f代表从底部开始展开
        toView.layer.anchorPoint = CGPointMake(0.5, 1.f); // x 无所谓
        // X值为1.f代表宽度始终不变
        // Y值为0.0001代表高度从0.0001开始变化
        toView.transform = CGAffineTransformMakeScale(1.f, 0.0001);
        //        toTransfrom = CGAffineTransformMakeScale(1, 1);
        toTransfrom = CGAffineTransformIdentity;

    }
    // scale
    if (style == VVSTransitionAnimationStyleScaleFromTopCenter) {
        toView.layer.anchorPoint = CGPointMake(0.5, 0.f);
        toView.transform = CGAffineTransformMakeScale(0.f, 0.f);
        toTransfrom = CGAffineTransformIdentity;
    } else if (style == VVSTransitionAnimationStyleScaleFromLeftCenter) {
        toView.layer.anchorPoint = CGPointMake(0.f, 0.5f);
        toView.transform = CGAffineTransformMakeScale(0.f, 0.f);
        toTransfrom = CGAffineTransformIdentity;
    } else if (style == VVSTransitionAnimationStyleScaleFromRightCenter) {
        // 含义
        // anchorPoint.x = 1.f 代表水平方向从右边开始
        // anchorPoint.y = 0.5 代表垂直方向从中心点开始
        // scale.x = 0.f 代表水平方向距离锚点距离为0
        // scale.y = 0.f 代表垂直方向距离锚点距离为0
        
        // 便于理解的解释
        // anchorPoint.x - scale.x = 1.f 代表水平方向缩放1倍的宽度
        // anchorPoint.y - scale.y = 0.5 代表垂直方向上缩放0.5倍的高度
        // 正确解释
        // anchorPoint.x - scale.x = 1.f 代表水平方向从右边开始缩放
        // anchorPoint.y - scale.y = 0.5 代表垂直方向从中心点开始缩放
        toView.layer.anchorPoint = CGPointMake(1.f, 0.5);
        toView.transform = CGAffineTransformMakeScale(0.f, 0.f);
        toTransfrom = CGAffineTransformIdentity;
    } else if (style == VVSTransitionAnimationStyleScaleFromBottomCenter) {
        // 含义
        // anchorPoint.x = 0.5 代表水平方向从中心点开始
        // anchorPoint.y = 1.f 代表垂直方向从底部开始
        // scale.x = 0.f 代表水平方向距离锚点距离为0
        // scale.y = 0.f 代表垂直方向距离锚点距离为0
        
        // 便于理解的解释
        // anchorPoint.x - scale.x = 0.5 代表水平方向缩放0.5倍的宽度
        // anchorPoint.y - scale.y = 1.f 代表垂直方向上缩放1倍的高度
        // 正确解释
        // anchorPoint.x - scale.x = 0.5 代表水平方向从中心点开始缩放
        // anchorPoint.y - scale.y = 1.f 代表垂直方向从底部开始缩放
        toView.layer.anchorPoint = CGPointMake(0.5, 1.f);
        toView.transform = CGAffineTransformMakeScale(0.f, 0.f);
        toTransfrom = CGAffineTransformIdentity;
    } else if (style == VVSTransitionAnimationStyleScaleFromTopLeft) {
        toView.layer.anchorPoint = CGPointMake(0.f, 0.f);
        toView.transform = CGAffineTransformMakeScale(0.f, 0.f);
        toTransfrom = CGAffineTransformIdentity;
    } else if (style == VVSTransitionAnimationStyleScaleFromTopRight) {
        toView.layer.anchorPoint = CGPointMake(1.f, 0.f);
        toView.transform = CGAffineTransformMakeScale(0.f, 0.f);
        toTransfrom = CGAffineTransformIdentity;
    } else if (style == VVSTransitionAnimationStyleScaleFromBottomLeft) {
        toView.layer.anchorPoint = CGPointMake(0.f, 1.f);
        toView.transform = CGAffineTransformMakeScale(0.f, 0.f);
        toTransfrom = CGAffineTransformIdentity;
    } else if (style == VVSTransitionAnimationStyleScaleFromBottomRight) {
        toView.layer.anchorPoint = CGPointMake(1.f, 1.f);
        toView.transform = CGAffineTransformMakeScale(0.f, 0.f);
        toTransfrom = CGAffineTransformIdentity;
    }
    
    
    ////////////////////////////////////////////////////////////////
    // present
    if (style == VVSTransitionAnimationStylePresentFromLeft) {
        // toView.frame = _presentedViewFrame;

        UIView *sourceView = sourceViewController.view;
        CGRect frameOfSourceViewInWindow = [sourceView convertRect:sourceView.bounds toView:[UIApplication sharedApplication].windows.firstObject];
        toView.x = frameOfSourceViewInWindow.origin.x - toView.width;

        [UIView animateWithDuration:duration animations:^{
            toView.x = frameOfSourceViewInWindow.origin.x;

        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    
    [UIView animateWithDuration:duration animations:^{
        toView.transform = toTransfrom;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

- (void)vvs_dismissWithAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext style:(VVSTransitionAnimationStyle)transitionAnimationStyle {
    // 动画时间
    NSTimeInterval duration = [self transitionDuration:transitionContext];

    // 消失的视图
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    // 被展现的动画如何消失
    VVSTransitionAnimationStyle style = self.transitionAnimationStyle;
    CGAffineTransform fromTransform;
    if (style == VVSTransitionAnimationStyleStretchFromTop) {
        fromTransform = CGAffineTransformMakeScale(1.0, 0.0001);
        
    } else if (style == VVSTransitionAnimationStyleStretchFromLeft) {
        fromTransform = CGAffineTransformMakeScale(0.0001, 0.5);

    } else if (style == VVSTransitionAnimationStyleStretchFromRight) {
        //(0.0001, 1.f)而不是(0.0001, 0.5)，为1.f代表高度恢复为初始值，为0.5代表高度变为初始值的一半
        fromTransform = CGAffineTransformMakeScale(0.0001, 1.f);
    } else if (style == VVSTransitionAnimationStyleStretchFromBottom) {
        fromTransform = CGAffineTransformMakeScale(1.f, 0.0001);
    } else if (style == VVSTransitionAnimationStylePresentFromLeft) {
        
    }
    // scale
    if (style == VVSTransitionAnimationStyleScaleFromTopCenter) {
        // scale(0.0001,0.0001) 代表距离锚点的距离,以下同理
        fromTransform = CGAffineTransformMakeScale(0.0001, 0.0001);
    } else if (style == VVSTransitionAnimationStyleScaleFromLeftCenter) {
        fromTransform = CGAffineTransformMakeScale(0.0001, 0.0001);
    } else if (style == VVSTransitionAnimationStyleScaleFromRightCenter) {
        fromTransform = CGAffineTransformMakeScale(0.0001, 0.0001);
    } else if (style == VVSTransitionAnimationStyleScaleFromBottomCenter) {
        fromTransform = CGAffineTransformMakeScale(0.0001, 0.0001);
    } else if (style == VVSTransitionAnimationStyleScaleFromTopLeft) {
        fromTransform = CGAffineTransformMakeScale(0.0001, 0.0001);
    } else if (style == VVSTransitionAnimationStyleScaleFromTopRight) {
        fromTransform = CGAffineTransformMakeScale(0.0001, 0.0001);
    } else if (style == VVSTransitionAnimationStyleScaleFromBottomLeft) {
        fromTransform = CGAffineTransformMakeScale(0.0001, 0.0001);
    } else if (style == VVSTransitionAnimationStyleScaleFromBottomRight) {
        fromTransform = CGAffineTransformMakeScale(0.0001, 0.0001);
    }



    
    [UIView animateWithDuration:duration animations:^{
        fromView.transform = fromTransform;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

#pragma mark - setter
- (void)setTransitionAnimationStyle:(VVSTransitionAnimationStyle)transitionAnimationStyle {
    _transitionAnimationStyle = transitionAnimationStyle;
    // 异常断言
    if (transitionAnimationStyle > 16) {
        NSAssert(nil, @"您所指定的transitionAnimationStyle不存在");
    }
}
@end
