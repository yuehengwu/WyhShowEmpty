//
//  UIViewController+WyhShowEmpty.m
//  WyhShowEmptyCategory
//
//  Created by 吴岳恒 on 2017/2/8.
//  Copyright © 2017年 wyh. All rights reserved.
//

#import "UIViewController+WyhShowEmpty.h"
#import "WyhEmptyStyle.h"
#import <objc/runtime.h>
#import "UIView+WyhExtension.h"
#import "WyhShowEmptyConst.h"



@interface UIViewController()

@property (nonatomic, strong) NSString *isShowed; /*是否正在展示,主要防止重复添加*/

@property (nonatomic, strong) UIView *superView;

@property (nonatomic, strong) UIButton *tipButton;

@property (nonatomic, strong) UIImageView *tipImageView;

@property (nonatomic, strong) UILabel *tipLabel;

@end


@implementation UIViewController (WyhShowEmpty)


-(void)wyh_showEmptyMsg:(NSString *)msg dataCount:(NSUInteger)count{
    
    if (!self.wyhEmptyStyle) {
        WyhEmptyStyle *wyhStyle = [[WyhEmptyStyle alloc]init];
        wyhStyle.isOnlyText = YES;
        wyhStyle.refreshStyle = noRefreshStyle;
        wyhStyle.tipText = msg;
        wyhStyle.superView = self.view;
        self.wyhEmptyStyle = wyhStyle;
    }
    self.wyhEmptyStyle.dataSourceCount = count;
    
    [self setupShowedFromDataCount];
}

-(void)wyh_showEmptyMsg:(NSString *)msg dataCount:(NSUInteger)count isHasBtn:(BOOL)hasBtn Handler:(void(^)())handleBlock{
    
    if (!self.wyhEmptyStyle) {
        WyhEmptyStyle *wyhStyle = [[WyhEmptyStyle alloc]init];
        wyhStyle.refreshStyle = hasBtn?RefreshClickOnBtnStyle:RefreshClockOnFullScreenStyle;
        wyhStyle.tipText = msg;
        wyhStyle.superView = self.view;
        self.wyhEmptyStyle = wyhStyle;
    }
    self.wyhEmptyStyle.dataSourceCount = count;
    
    [self setupShowedFromDataCount];
    
    self.tipHandler = handleBlock;
}

-(void)wyh_showEmptyMsg:(NSString *)msg dataCount:(NSUInteger)count customImgName:(NSString *)imageName{
    
    if (!self.wyhEmptyStyle) {
        
        WyhEmptyStyle *wyhStyle = [[WyhEmptyStyle alloc]init];
        wyhStyle.refreshStyle = noRefreshStyle;
        wyhStyle.isOnlyText = NO;
        if (imageName) {
            wyhStyle.imageConfig.type = ImgTypeName;
            wyhStyle.imageConfig.imageData = imageName;
        }
        wyhStyle.tipText = msg;
        wyhStyle.superView = self.view;
        self.wyhEmptyStyle = wyhStyle;
    }
    self.wyhEmptyStyle.dataSourceCount = count;
    
    [self setupShowedFromDataCount];
}

/**
 设置展示视图是否展示中
 */
-(void)setupShowedFromDataCount{
    
    if(0==self.wyhEmptyStyle.dataSourceCount){
        if (YES==[self.isShowed boolValue]) return;
        [self wyh_showWithStyle:self.wyhEmptyStyle];
    }else{
        [self removeSubViews];
        
    };
}

/**
 自定义展示方法

 @param style 自定义样式
 */
-(void)wyh_showWithStyle:(WyhEmptyStyle *)style{
    
    if (!style.superView) style.superView = self.view;
    
    self.isShowed = @"1";
    
    [self setupSubViewsPositionWithStyle:style];
    
}

static UITableViewCellSeparatorStyle superViewSeparatorStyle;/*不能使用const修饰*/

/**
 根据style进行布局视图

 @param style 自定义样式
 */
-(void)setupSubViewsPositionWithStyle:(WyhEmptyStyle *)style{
    
    NSAssert(style, @"style样式不能为空，请检查");
    NSAssert(style.superView, @"必须需要设置父视图，请不要误删style.superView");
    
    if (style.isOnlyText) {
        self.tipImageView = nil;
        self.tipButton = nil;
        
        [self setupTipLabelWithStyle:style];
        
        return;
    }
    
    if (style.refreshStyle == RefreshClickOnBtnStyle) {
        
        [self setupImageViewWithStyle:style];
        
        [self setupTipLabelWithStyle:style];
        
        [self setupButtonWithStyle:style]; /*必须写在setLabel的后面*/

    }
    
    if (style.refreshStyle == RefreshClockOnFullScreenStyle) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClickAction)];
        [style.superView addGestureRecognizer:tap]; /*建议superview自定义，避免用主控器的view直接添加手势*/
        
        [self setupImageViewWithStyle:style];
        
        [self setupTipLabelWithStyle:style];
    }
    
    if (style.refreshStyle == noRefreshStyle) {
        
        [self setupImageViewWithStyle:style];
        
        [self setupTipLabelWithStyle:style];
    }
    
    //父视图若为tableView则应去除分割线
    if ([style.superView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)style.superView;
        if (tableView.separatorStyle != UITableViewCellSeparatorStyleNone) {
            superViewSeparatorStyle = tableView.separatorStyle;/*全局变量superViewSeparatorStyle存储原分割线样式*/
        }
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
}

-(void)setupTipLabelWithStyle:(WyhEmptyStyle *)style{
    
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.text = !style.tipText ? defaultTipText : style.tipText;/* defaultTipText 为默认提示语*/
    tipLabel.textColor = style.tipTextColor;
    tipLabel.numberOfLines = 0;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    CGSize maxSize = CGSizeMake(ScreenSize.width - 40, MAXFLOAT);
    CGSize finalSize = [tipLabel sizeThatFits:maxSize];
    
    NSAssert(ScreenSize.height>finalSize.height, @"设置的文本太长，超出了屏幕的高度！");
    
    tipLabel.frame = CGRectMake(20, (ScreenSize.height - finalSize.height)/2, ScreenSize.width - 40, finalSize.height);
    [style.superView addSubview:tipLabel];
    self.tipLabel = tipLabel;
    
    if (!style.isOnlyText) {
        
        NSAssert(self.tipImageView, @"setupTiplabel必须在setupImage之后，否则获取不到image的frame");
        
        CGFloat tipX = (ScreenSize.width - tipLabel.wyh_w) * 0.5;
        CGFloat tipY = self.tipImageView.wyh_bottom + 30;
        tipLabel.frame = CGRectMake(tipX, tipY, tipLabel.wyh_w, tipLabel.wyh_h);
        
    }else{
        
        tipLabel.center = style.superView.center;
    }
    
}

-(void)setupImageViewWithStyle:(WyhEmptyStyle *)style{
    
    NSAssert(style.imageConfig.imageData, @"图片数据不能为空");
    
    UIImageView *imgView = [[UIImageView alloc] init];
    
    
    switch (style.imageConfig.type) {
        case ImgTypeName: { imgView.image = [UIImage imageNamed:style.imageConfig.imageData]; } break;
            
        case ImgTypeLocalUrl:
        {
            NSString * filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:style.imageConfig.imageData];
            imgView.image = [UIImage imageWithContentsOfFile:filePath];
        }
            break;
            
        case ImgTypeUrl:
        {
            __block NSData *imgData;
            //此处暂时必须同步处理,若出现明显卡顿可用SDWebImage进行加载
            imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:style.imageConfig.imageData]];
            imgView.image = [[UIImage alloc]initWithData:imgData];
            
        }
            break;
        case GifImgLocalUrl:
        {
            imgView.animationImages = style.imageConfig.gifArray;
            imgView.animationDuration = 1;
            imgView.animationRepeatCount = MAXFLOAT;
            [imgView startAnimating];
        }
            break;
        default:
            break;
    }
    [imgView sizeToFit];
    if (style.imageSize.width != 0) {
        NSAssert(style.imageSize.width <= ScreenSize.width, @"");
        imgView.wyh_size = style.imageSize;
    }else{
        NSAssert(style.imageMaxWidth>0, @"图片允许的最大宽度不得小于0");
        CGFloat allowedMaxW = style.imageMaxWidth;
        CGFloat allowedMaxH = style.imageMaxWidth*imgView.wyh_h/imgView.wyh_w;
        imgView.wyh_w = imgView.wyh_w > allowedMaxW ? allowedMaxW :imgView.wyh_w;
        imgView.wyh_h = imgView.wyh_h > allowedMaxH ? allowedMaxH:imgView.wyh_h;
    }
    CGFloat imagVx = (ScreenSize.width - imgView.wyh_w) * 0.5;
    CGFloat imagVy = style.imageOragionY;
    imgView.frame = CGRectMake(imagVx, imagVy, imgView.wyh_w, imgView.wyh_h);
    [style.superView addSubview:imgView];
    self.tipImageView = imgView;
}

-(void)setupButtonWithStyle:(WyhEmptyStyle *)style{
    
    NSAssert(self.tipLabel != nil, @"setupBtn必须在setupLabel之后，否则获取不到label的frame");
    style.btnTipText = !style.btnTipText ? defaultBtnTipText : style.btnTipText;
    style.btnTitleColor = !style.btnTitleColor ? [UIColor redColor] : style.btnTitleColor;
    style.btnLayerBorderColor = !style.btnLayerBorderColor ? [UIColor lightGrayColor] : style.btnLayerBorderColor;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:style.btnTipText forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    if (style.btnImage) [btn setBackgroundImage:style.btnImage forState:(UIControlStateNormal)];
    [btn sizeToFit];
    [btn setTitleColor:style.btnTitleColor forState:UIControlStateNormal];
    btn.titleLabel.textColor = [UIColor lightGrayColor];
    CGFloat btnX = (ScreenSize.width - style.btnWidth) * .5f;
    CGFloat btnY = CGRectGetMaxY(self.tipLabel.frame) + 20;/*20是一个神奇数字*/
    btn.frame = CGRectMake(btnX, btnY, style.btnWidth, style.btnHeight);
    btn.layer.borderColor = style.btnLayerBorderColor.CGColor;
    btn.layer.borderWidth = style.btnLayerborderWidth;
    btn.layer.cornerRadius = style.btnLayerCornerRadius;
    btn.layer.masksToBounds = YES;
    self.tipButton = btn;
    [style.superView addSubview:btn];
    [btn addTarget:self action:@selector(btnClickAction) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - btnClickAction
-(void)btnClickAction{
    
    NSLog(@"点击了刷新");
    [self removeSubViews]; /*remove一定要放在回调block之前*/
    
    if (self.tipHandler) {
        self.tipHandler();
    }
    
}

-(void)removeSubViews{
    self.isShowed = @"0";
    if ([self.wyhEmptyStyle.superView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self.wyhEmptyStyle.superView;
        tableView.separatorStyle = superViewSeparatorStyle;/*恢复分割线样式*/
    }
    [self.tipLabel removeFromSuperview];
    [self.tipButton removeFromSuperview];
    [self.tipImageView removeFromSuperview];
    
}

#pragma mark - setter and getter

#pragma mark - label
-(void)setTipLabel:(UILabel *)tipLabel{
    objc_setAssociatedObject(self, &labelKey, tipLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UILabel *)tipLabel{
    
    return objc_getAssociatedObject(self, &labelKey);
}

#pragma mark - button
-(void)setTipButton:(UIButton *)tipButton{
    objc_setAssociatedObject(self, &btnKey, tipButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIButton *)tipButton{
    return objc_getAssociatedObject(self, &btnKey);
}

#pragma mark - imageView
-(void)setTipImageView:(UIImageView *)tipImageView{
    objc_setAssociatedObject(self, &imageKey, tipImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIImageView *)tipImageView{
    return objc_getAssociatedObject(self, &imageKey);
}

#pragma mark - block
-(void)setTipHandler:(void (^)())tipHandler{
    objc_setAssociatedObject(self, &blockKey, tipHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(void (^)())tipHandler{
    return objc_getAssociatedObject(self, &blockKey);
}

#pragma mark - wyhStyle
-(void)setWyhEmptyStyle:(WyhEmptyStyle *)wyhEmptyStyle{
    objc_setAssociatedObject(self, &styleKey, wyhEmptyStyle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(WyhEmptyStyle *)wyhEmptyStyle{
    return objc_getAssociatedObject(self, &styleKey);
}

#pragma mark - isShowed
-(void)setIsShowed:(NSString *)isShowed{
    objc_setAssociatedObject(self, &isShowedKey, isShowed, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSString *)isShowed{
    return objc_getAssociatedObject(self, &isShowedKey);
}
    



@end
