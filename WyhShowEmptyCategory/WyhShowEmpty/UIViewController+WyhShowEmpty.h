//
//  UIViewController+WyhShowEmpty.h
//  WyhShowEmptyCategory
//
//  Created by 吴岳恒 on 2017/2/8.
//  Copyright © 2017年 wyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WyhEmptyStyle;

@interface UIViewController (WyhShowEmpty)

/**
 若自定义style，有点击方法时，给外界做处理,若没自定义建议使用
 wyh_showEmptyMsg:(NSString *)msg dataCount:(NSUInteger)count Handler:(void(^)())handleBlock
 */
@property (nonatomic, copy) void(^tipHandler)();

/**
 自定义style
 */
@property (nonatomic, strong) WyhEmptyStyle *wyhEmptyStyle;


/**
 根据数据源个数展示纯文本视图

 @param msg 提示语
 @param count 数据源个数
 */
-(void)wyh_showEmptyMsg:(NSString *)msg dataCount:(NSUInteger)count;



/**
 展示带点击刷新的提示视图

 @param msg 提示语
 @param count 数据源个数 若不想通过数据源判断一直传0即可
 @param hasBtn 是否含有Btn 带btn->YES 点击屏幕->NO
 @param handleBlock 刷新方法回调
 */
-(void)wyh_showEmptyMsg:(NSString *)msg dataCount:(NSUInteger)count isHasBtn:(BOOL)hasBtn Handler:(void(^)())handleBlock;

/**
 根据数据源个数展示自定义图片的提示视图

 @param msg 提示语
 @param count 数据源个数
 @param imageName 图片名称,传nil使用默认图
 */
-(void)wyh_showEmptyMsg:(NSString *)msg dataCount:(NSUInteger)count customImgName:(NSString *)imageName;


/**
 根据自定义style展示视图
 
 @param style 自定义样式
 */
-(void)wyh_showWithStyle:(WyhEmptyStyle *)style;
@end
