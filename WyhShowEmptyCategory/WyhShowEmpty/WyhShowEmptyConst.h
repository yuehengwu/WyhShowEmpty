//
//  WyhShowEmptyConst.h
//  WyhShowEmptyCategory
//
//  Created by 吴岳恒 on 2017/2/8.
//  Copyright © 2017年 wyh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface WyhShowEmptyConst : NSObject



//16进制颜色
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//屏幕尺寸
#define ScreenSize [UIScreen mainScreen].bounds.size

//异步线程
#define WYH_GlobalQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

//主线程
#define WYH_MainQueue dispatch_get_main_queue()

UIKIT_EXTERN NSString *const defaultTipText;
UIKIT_EXTERN NSString *const defaultBtnTipText;
UIKIT_EXTERN NSString *const isShowedKey;
UIKIT_EXTERN NSString *const labelKey;
UIKIT_EXTERN NSString *const blockKey;
UIKIT_EXTERN NSString *const imageKey;
UIKIT_EXTERN NSString *const styleKey;
UIKIT_EXTERN NSString *const btnKey;

@end
