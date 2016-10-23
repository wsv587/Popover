//
//  ViewController.m
//  VVSPopover
//
//  Created by sw on 16/10/21.
//  Copyright © 2016年 sw. All rights reserved.
//

#import "ViewController.h"
#import "PopoverController.h"
#import "VVSPopoverViewController.h"
#import "VVSPopoverAnimationManager.h"

#define k_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define K_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define K_SCREEN_X [UIScreen mainScreen].bounds.origin.x
#define K_SCREEN_Y [UIScreen mainScreen].bounds.origin.y

@interface ViewController ()

@property(nonatomic,strong) VVSPopoverAnimationManager *manager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *titleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    [titleButton setTitle:@"标题" forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [titleButton addTarget:self action:@selector(didClickTitle) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleButton;
    NSLog(@"self == %@",self);

}

- (void)didClickTitle {
    // 1.创建被展示的视图
    VVSPopoverViewController *popover = [[VVSPopoverViewController alloc] initWithNibName:NSStringFromClass([VVSPopoverViewController class]) bundle:nil];
//    PopoverController *popover = [[PopoverController alloc] init];
    // 2.设置负责自定义转场delegate
    popover.transitioningDelegate = self.manager;
    // 3.设置转场的样式
    popover.modalPresentationStyle = UIModalPresentationCustom;
    // 4.弹出被展示的视图
    [self presentViewController:popover animated:YES completion:nil];
}

#pragma mark - lazy
- (VVSPopoverAnimationManager *)manager {
    if (!_manager) {
        _manager = [[VVSPopoverAnimationManager alloc] init];
//         _manager.presentedViewFrame = CGRectMake(100.f, 56.f, 200.f, 200.f);
        _manager.presentedViewFrame = CGRectMake(0.0001f, 0.0001f, 0.7 * k_SCREEN_WIDTH, K_SCREEN_HEIGHT);
        // _manager.coverViewResponse = NO;
        // _manager.animatable = NO;
        //_manager.transitionAnimationStyle = 17;
        _manager.transitionDuration = 0.5;
        _manager.transitionAnimationStyle = VVSTransitionAnimationStyleScaleFromCenter;
        _manager.sourceView = self.view;
        _manager.alphaAnimatable = YES;
    }
    return _manager;
}

@end
