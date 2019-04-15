//
//  WyhEmptyStyle.m
//  WyhShowEmptyCategory
//
//  Created by 吴岳恒 on 2017/2/8.
//  Copyright © 2017年 wyh. All rights reserved.
//

#import "WyhEmptyStyle.h"
#import "WyhShowEmptyConst.h"
#import <ImageIO/ImageIO.h>
@implementation imageExtConfig


- (NSMutableArray *)gifArray {
    if (_imageData && _type == GifImgLocalUrl) {
        _gifArray = [self wyh_imagesWithGif:_imageData].mutableCopy;
    }
    return _gifArray;
}

-(NSArray *)wyh_imagesWithGif:(NSString *)gifNameInBoundle {
    
    NSAssert(gifNameInBoundle, @"gif路径不得为空");
    
    NSString *dataPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:gifNameInBoundle];
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:dataPath], NULL);
    size_t gifCount = CGImageSourceGetCount(gifSource);
    NSMutableArray *imageArr = [[NSMutableArray alloc]init];
    for (size_t i = 0; i< gifCount; i++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        [imageArr addObject:image];
        CGImageRelease(imageRef);
    }
    return imageArr;
}

@end

@implementation WyhEmptyStyle

-(instancetype)init{
    
    if (self = [super init]) {
        _isOnlyText = NO;
        _refreshStyle = noRefreshStyle;
        _imageConfig = [[imageExtConfig alloc]init];
        _imageMaxWidth = 300;
        _imageConfig.type = ImgTypeLocalUrl;
        _imageConfig.imageData = @"WyhEmpty.bundle/nonetwork";
        _btnTipText = @"重试";
        _btnFont = [UIFont systemFontOfSize:15];
        _btnImage = nil;
        _btnTitleColor = [UIColor redColor];
        _btnLayerBorderColor = WYHColorFromRGB(0xf4f5f6);
        _btnLayerCornerRadius = 2;
        _btnLayerborderWidth = 1;
        _btnWidth = 100;
        _btnHeight = 35;
        
        _tipTextColor = [UIColor grayColor];
        _tipFont = [UIFont systemFontOfSize:17.0f];
        
        _descTextColor = [UIColor lightGrayColor];
        _descFont = [UIFont systemFontOfSize:15.f];
        
        _imageOragionY = 0.2f;/*默认起点位置在屏幕高的20%位置上*/
        _btnClickClosure = nil;
    }
    return self;
}



@end
