//
//  ViewController.h
//  DCWKWebViewDemo
//
//  Created by chy on 17/1/22.
//  Copyright © 2017年 Chy. All rights reserved.
//

#define kScreenWidth [UIScreen mainScreen ].bounds.size.width
#define kScreenHeight [UIScreen mainScreen ].bounds.size.height
#define DC_LOG(format, ...)   NSLog((@"%-20.20s[%4d]%40.40s 🌱 " format),      \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], \
__LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__);

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


@end

