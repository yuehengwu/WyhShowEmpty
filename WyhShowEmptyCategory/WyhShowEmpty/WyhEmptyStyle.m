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



-(void)setType:(imageType)type{
    if (_type != type) {
        _type = type;
        if (type == GifImgLocalUrl) { /* 注意若要自定imageData请再setType之后设置 */
            self.imageData = @"WyhEmpty.bundle/转圈圈.gif";
            self.gifArray = [self wyh_imagesWithGif:self.imageData].mutableCopy;
        }
    }
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
        self.isOnlyText = NO;
        self.refreshStyle = noRefreshStyle;
        self.imageConfig = [[imageExtConfig alloc]init];
        self.imageMaxWidth = 300;
        self.imageConfig.type = ImgTypeLocalUrl;
        self.imageConfig.imageData = @"WyhEmpty.bundle/nonetwork";
        self.btnTipText = @"重试";
        self.btnImage = nil;
        self.btnTitleColor = [UIColor redColor];
        self.btnLayerBorderColor = UIColorFromRGB(0xf4f5f6);
        self.btnLayerCornerRadius = 2;
        self.btnLayerborderWidth = 1;
        self.btnWidth = 100;
        self.btnHeight = 35;
        self.tipTextColor = [UIColor lightGrayColor];
        self.imageOragionY = ScreenSize.height * .2f;/*默认起点位置在屏幕高的20%位置上*/
        
    }
    return self;
}



@end
