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
    
    // stretch
    VVSTransitionAnimationStyleStretchFromTop, // ✅
    VVSTransitionAnimationStyleStretchFromLeft, // ✅
    VVSTransitionAnimationStyleStretchFromRight, // ✅
    VVSTransitionAnimationStyleStretchFromBottom, // ✅
    // present
    VVSTransitionAnimationStylePresentFromTop,
    VVSTransitionAnimationStylePresentFromLeft,
    VVSTransitionAnimationStylePresentFromRight,
    VVSTransitionAnimationStylePresentFromBottom,
    // scale
    VVSTransitionAnimationStyleScaleFromTopCenter, // ✅
    VVSTransitionAnimationStyleScaleFromLeftCenter, // ✅
    VVSTransitionAnimationStyleScaleFromRightCenter, // ✅
    VVSTransitionAnimationStyleScaleFromBottomCenter, // ✅
    
    VVSTransitionAnimationStyleScaleFromTopLeft, // ✅
    VVSTransitionAnimationStyleScaleFromTopRight, // ✅
    VVSTransitionAnimationStyleScaleFromBottomLeft, // ✅
    VVSTransitionAnimationStyleScaleFromBottomRight, // ✅
    
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
/**
 *  转场动画时间
 *  默认0.5秒
 */
@property(nonatomic,assign) NSTimeInterval transitionDuration;
/**
 *  转场是否动画
 *  默认有动画
 */
@property(nonatomic,assign,getter=isAnimatable) BOOL animatable;
/**
 *  转场样式
 *  默认值 VVSTransitionAnimationStyleStretchFromTop
 */
@property(nonatomic,assign) VVSTransitionAnimationStyle transitionAnimationStyle;
/**
 *  发起转场的源控制器的view
 */
@property(nonatomic,weak) UIView *sourceView;
@end
