//
//  DCBaseNanigationController.m
//  DCWKWebViewDemo
//
//  Created by chy on 17/1/22.
//  Copyright © 2017年 Chy. All rights reserved.
//

#import "DCBaseNanigationController.h"

@interface DCBaseNanigationController ()

@end

@implementation DCBaseNanigationController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self.navigationBar setTranslucent:NO];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}

@end
