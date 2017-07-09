//
//  VVSPresentationController.h
//  VVSPopover
//
//  Created by sw on 16/10/21.
//  Copyright © 2016年 sw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VVSPresentationController : UIPresentationController
/**
 *  被展现的视图的frame
 */
@property(nonatomic,assign) CGRect presentedViewFrame;
/**
 *  点击蒙版是否响应事件
 *  默认响应
 */
@property(nonatomic,assign,getter=isConverViewResponse) BOOL coverViewResponse;

/**
 *  是否有蒙版
 *  默认有
 */
@property(nonatomic,assign,getter=isHasCoverView) BOOL hasConverView;
@end
