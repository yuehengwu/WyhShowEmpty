//
//  UIViewController+WyhShowEmpty.m
//  WyhShowEmptyCategory
//
//  Created by wyh on 2017/2/8.
//  Copyright © 2017年 wyh. All rights reserved.
//

#import "UIViewController+WyhShowEmpty.h"
#import "UIView+WyhShowEmpty.h"
#import "WyhEmptyStyle.h"
#import "WyhShowEmptyConst.h"
#import <objc/runtime.h>

@implementation UIViewController (WyhShowEmpty)

-(void)wyh_showEmptyMsg:(NSString *)msg dataCount:(NSUInteger)count{
    
    self.view.wyhEmptyStyle = self.wyhEmptyStyle;
    [self.view wyh_showEmptyMsg:msg dataCount:count];
}

-(void)wyh_showEmptyMsg:(NSString *)msg dataCount:(NSUInteger)count isHasBtn:(BOOL)hasBtn Handler:(void(^)())handleBlock{
    
    self.view.wyhEmptyStyle = self.wyhEmptyStyle;
    [self.view wyh_showEmptyMsg:msg dataCount:count isHasBtn:hasBtn Handler:handleBlock];
}

-(void)wyh_showEmptyMsg:(NSString *)msg dataCount:(NSUInteger)count customImgName:(NSString *)imageName{
    
    self.view.wyhEmptyStyle = self.wyhEmptyStyle;
    [self.view wyh_showEmptyMsg:msg dataCount:count customImgName:imageName];
}

-(void)wyh_showEmptyMsg:(NSString *)msg
              dataCount:(NSUInteger)count
          customImgName:(NSString *)imageName
          imageOragionY:(CGFloat)imageOragionY
               isHasBtn:(BOOL)hasBtn
                Handler:(void(^)())handleBlock{
    
    [self.view wyh_showEmptyMsg:msg dataCount:count customImgName:imageName imageOragionY:imageOragionY isHasBtn:hasBtn Handler:handleBlock];
    
}


-(void)wyh_showWithStyle:(WyhEmptyStyle *)style{
    
    [self.view wyh_showWithStyle:style];
}


#pragma mark - block

-(void)setTipHandler:(void (^)())tipHandler{
    self.view.tipHandler = tipHandler;
}
-(void (^)())tipHandler{
    return self.view.tipHandler;
}

#pragma mark - wyhStyle
-(void)setWyhEmptyStyle:(WyhEmptyStyle *)wyhEmptyStyle{
    self.view.wyhEmptyStyle = wyhEmptyStyle;
}
-(WyhEmptyStyle *)wyhEmptyStyle{
    return self.view.wyhEmptyStyle;
}

@end
