//
//  VVSPopoverAnimationManager.h
//  VVSPopover
//
//  Created by sw on 16/10/22.
//  Copyright © 2016年 sw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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
