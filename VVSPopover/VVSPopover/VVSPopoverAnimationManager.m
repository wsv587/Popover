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
    presentation.presentedViewFrame = CGRectMake(100.f, 56.f, 200.f, 200.f);
    presentation.coverViewResponse = self.isConverViewResponse;
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
    
    // 被展现的视图如何展现
    VVSTransitionAnimationStyle style = self.transitionAnimationStyle;
    CGAffineTransform toTransfrom;
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
        toView.layer.anchorPoint = CGPointMake(1.f, 0.5); // y 无所谓
        toView.transform = CGAffineTransformMakeScale(1.f, 0.5);
        toTransfrom = CGAffineTransformMakeScale(1, 1);
    } else if (style == VVSTransitionAnimationStyleStretchFromBottom) {
//        toView.layer.anchorPoint = CGPointMake(0.5, 1.f); // x无所谓
        toView.transform = CGAffineTransformMakeScale(0.5, 1.f);
        toTransfrom = CGAffineTransformMakeScale(0.5, 0.f);
    
    } else if (style == VVSTransitionAnimationStylePresentFromLeft) {
        
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
        fromTransform = CGAffineTransformMakeScale(1.f, 0.5);
    } else if (style == VVSTransitionAnimationStyleStretchFromBottom) {
    
    } else if (style == VVSTransitionAnimationStylePresentFromLeft) {
        
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
