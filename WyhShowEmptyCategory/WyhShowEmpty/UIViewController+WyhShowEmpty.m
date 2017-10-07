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
                Handler:(void(^)())handleBlock{
    
    [self.view wyh_showEmptyMsg:msg dataCount:count customImgName:imageName imageOragionY:imageOragionY Handler:handleBlock];
    
}


-(void)wyh_showWithStyle:(WyhEmptyStyle *)style{
    
    [self.view wyh_showWithStyle:style];
}


#pragma mark - block

-(void)setTipHandler:(void (^)())tipHandler{
//    objc_setAssociatedObject(self, &wyh_blockKey, tipHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.view.tipHandler = tipHandler;
}
-(void (^)())tipHandler{
//    return objc_getAssociatedObject(self, &wyh_blockKey);
    return self.view.tipHandler;
}

#pragma mark - wyhStyle
-(void)setWyhEmptyStyle:(WyhEmptyStyle *)wyhEmptyStyle{
    objc_setAssociatedObject(self, &wyh_styleKey, wyhEmptyStyle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(WyhEmptyStyle *)wyhEmptyStyle{
    
    return objc_getAssociatedObject(self, &wyh_styleKey);
}

@end
