//
//  VVSPopoverAnimationManager.m
//  VVSPopover
//
//  Created by sw on 16/10/22.
//  Copyright © 2016年 sw. All rights reserved.
//

#import "VVSPopoverAnimationManager.h"
#import "VVSPresentationController.h"

@interface VVSPopoverAnimationManager ()<UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>
{
    BOOL isPresented;
}
@end

@implementation VVSPopoverAnimationManager
#pragma mark - UIViewControllerTransitioningDelegate
/**
 该方法用于返回负责转场的对象
 */
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    VVSPresentationController *presentation = [[VVSPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    presentation.presentedViewFrame = CGRectMake(100.f, 56.f, 200.f, 200.f);
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
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    if (isPresented) {
        // 被展现的视图
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        [[transitionContext containerView] addSubview:toView];
        // 被展现的视图如何展现
        toView.layer.anchorPoint = CGPointMake(0.5, 0.f);
        toView.transform = CGAffineTransformMakeScale(1.0, 0.0);
        //        toView.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:duration animations:^{
            toView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    } else {
        // 消失的视图
        UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        [UIView animateWithDuration:duration animations:^{
            fromView.transform = CGAffineTransformMakeScale(1.0, 0.0001);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

@end
