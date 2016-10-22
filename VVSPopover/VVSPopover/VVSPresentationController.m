//
//  VVSPresentationController.m
//  VVSPopover
//
//  Created by sw on 16/10/21.
//  Copyright © 2016年 sw. All rights reserved.
//

#import "VVSPresentationController.h"

@interface VVSPresentationController ()
@property(nonatomic,strong) UIButton *cover;
@end

@implementation VVSPresentationController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    if (self) {
        // 在这赋值会被manager覆盖掉
        // _coverViewResponse = YES;
    }
    return self;
}

- (void)containerViewWillLayoutSubviews {
    [super containerViewWillLayoutSubviews];
    // 1.添加蒙版
    [self.containerView insertSubview:self.cover atIndex:0];
    // 2.设置蒙版frame
    self.cover.frame = self.containerView.bounds;
    // 3.调整被展现视图的大小
    self.presentedView.frame = self.presentedViewFrame;
}


#pragma mark - private
- (void)dismiss {
    if (self.isConverViewResponse) {
        [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }
//    else {
//        [self.presentedViewController dismissViewControllerAnimated:NO completion:nil];
//    }

}
#pragma mark - lazy 
- (UIButton *)cover {
    if (!_cover) {
        _cover = [[UIButton alloc] init];
        _cover.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
        [_cover addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cover;
}
@end
