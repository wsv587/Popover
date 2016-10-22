//
//  VVSPopoverAnimationManager.h
//  VVSPopover
//
//  Created by sw on 16/10/22.
//  Copyright © 2016年 sw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, VVSTransitionAnimationStyle) {
    // push
    VVSTransitionAnimationStylePresentFromTop,
    VVSTransitionAnimationStylePresentFromLeft,
    VVSTransitionAnimationStylePresentFromRight,
    VVSTransitionAnimationStylePresentFromBottom,
    // stretch
    VVSTransitionAnimationStyleStretchFromTop,
    VVSTransitionAnimationStyleStretchFromLeft,
    VVSTransitionAnimationStyleStretchFromRight,
    VVSTransitionAnimationStyleStretchFromBottom,
    // scale
    VVSTransitionAnimationStyleScaleFromTopCenter,
    VVSTransitionAnimationStyleScaleFromLeftCenter,
    VVSTransitionAnimationStyleScaleFromRightCenter,
    VVSTransitionAnimationStyleScaleFromBottomCenter,
    
    VVSTransitionAnimationStyleScaleFromTopLeft,
    VVSTransitionAnimationStyleScaleFromTopRight,
    VVSTransitionAnimationStyleScaleFromBottomLeft,
    VVSTransitionAnimationStyleScaleFromBottomRight,
    
    // fade
    VVSTransitionAnimationStyleFade,

};

@interface VVSPopoverAnimationManager : NSObject<UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>

/**
 *  被展现的视图的frame
 */
@property(nonatomic,assign) CGRect presentedViewFrame;
/**
 *  点击蒙版是否响应事件
 */
@property(nonatomic,assign,getter=isConverViewResponse) BOOL coverViewResponse;

@end
