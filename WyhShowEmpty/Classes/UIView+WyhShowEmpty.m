//
//  UIView+WyhShowEmpty.m
//  WyhShowEmptyCategory
//
//  Created by wyh on 2017/4/6.
//  Copyright © 2017年 wyh. All rights reserved.
//

#import "UIView+WyhShowEmpty.h"

#import <Masonry.h>
#import <objc/runtime.h>

#import "WyhEmptyStyle.h"
#import "WyhShowEmptyConst.h"


@interface UIView ()

@property (nonatomic, strong) NSString *isShowed; /*是否正在展示,主要防止重复添加*/

@property (nonatomic, strong) UIView *superView;

@property (nonatomic, strong) UIButton *tipButton;

@property (nonatomic, strong) UIImageView *tipImageView;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UIView *coverView;

@end

@implementation UIView (WyhShowEmpty)

static UITapGestureRecognizer *tempTapGes;

+(void)load {
    
    
}

-(void)wyh_showEmptyMsg:(NSString *)msg desc:(NSString *)desc dataCount:(NSUInteger)count {
    
    
    WyhEmptyStyle *wyhStyle = [[WyhEmptyStyle alloc]init];
    wyhStyle.refreshStyle = noRefreshStyle;
    wyhStyle.superView = self;
    wyhStyle.isOnlyText = YES;
    wyhStyle.refreshStyle = noRefreshStyle;
    wyhStyle.tipText = msg;
    wyhStyle.descText = desc;
    wyhStyle.dataSourceCount = count;
    
    [self wyh_showWithStyle:wyhStyle];
}

-(void)wyh_showEmptyMsg:(NSString *)msg desc:(NSString *)desc dataCount:(NSUInteger)count isHasBtn:(BOOL)hasBtn Handler:(void(^)(void))handleBlock {
    
    
    WyhEmptyStyle *wyhStyle = [[WyhEmptyStyle alloc]init];
    wyhStyle.superView = self;
    wyhStyle.refreshStyle = hasBtn?RefreshClickOnBtnStyle:RefreshClockOnFullScreenStyle;
    wyhStyle.tipText = msg;
    wyhStyle.descText = desc;
    wyhStyle.dataSourceCount = count;
    wyhStyle.btnClickClosure = handleBlock;
    
    [self wyh_showWithStyle:wyhStyle];
    
}

-(void)wyh_showEmptyMsg:(NSString *)msg desc:(NSString *)desc dataCount:(NSUInteger)count customImgName:(NSString *)imageName {
    
    WyhEmptyStyle *wyhStyle = [[WyhEmptyStyle alloc]init];
    wyhStyle.refreshStyle = noRefreshStyle;
    wyhStyle.isOnlyText = NO;
    if (imageName) {
        wyhStyle.imageConfig.type = ImgTypeName;
        wyhStyle.imageConfig.imageData = imageName;
    }
    wyhStyle.superView = self;
    
    wyhStyle.tipText = msg;
    wyhStyle.descText = desc;
    wyhStyle.dataSourceCount = count;
    
    [self wyh_showWithStyle:wyhStyle];
}

-(void)wyh_showEmptyMsg:(NSString *)msg
                   desc:(NSString *)desc
              dataCount:(NSUInteger)count
          customImgName:(NSString *)imageName
          imageOragionY:(CGFloat)imageOragionY
               isHasBtn:(BOOL)hasBtn
                Handler:(void(^)(void))handleBlock{
    
    WyhEmptyStyle *style = [[WyhEmptyStyle alloc]init];
    style.superView = self;
    style.refreshStyle = RefreshClockOnFullScreenStyle;
    style.imageOragionY = imageOragionY;
    style.tipText = msg;
    style.descText = desc;
    style.imageConfig.imageData = imageName?:style.imageConfig.imageData;
    style.imageConfig.type = ImgTypeName;
    style.dataSourceCount = count;
    
    if (!handleBlock) {
        style.refreshStyle = noRefreshStyle;
    }else {
        style.btnClickClosure = handleBlock;
        style.refreshStyle = hasBtn?RefreshClickOnBtnStyle:RefreshClockOnFullScreenStyle;
    }
    [self wyh_showWithStyle:style];
    
}

/**
 自定义展示方法
 
 @param style 自定义样式
 */
-(void)wyh_showWithStyle:(WyhEmptyStyle *)style {
    
    if (style.dataSourceCount == 0) {
        
        if (YES==[self.isShowed boolValue]) return;
        
        [self removeSubViews];
        
        if (!style.superView) style.superView = self;
        
        self.isShowed = @"1";
        
        self.wyhEmptyStyle = style;
        
        [self setupCoverViewPostionWithStyle:style];
        
        [self setupSubViewsPositionWithStyle:style];
        
    }else{
        
        [self removeSubViews];
    }
}

#pragma mark -

/**
 布局coverView
 
 @param style 自定义样式
 */
-(void)setupCoverViewPostionWithStyle:(WyhEmptyStyle *)style{
    
    //    CGFloat coverX = 0.0;
    //    CGFloat coverY = 0.0;
    //    __block UITableView *coverTable;
    //    /** 为了更方便用户调用,默认直接将coverView加在tableView上,若有不同需求可自行在此修改*/
    //    if (![style.superView isKindOfClass:[UITableView class]]) {
    //        [style.superView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //            if ([obj isKindOfClass:[UITableView class]]) {
    //                coverTable = (UITableView *)obj;
    //                style.superView = coverTable;
    //                *stop = YES;
    //            }
    //        }];
    //    }
    //    
    //
    //    if ([style.superView isKindOfClass:[UITableView class]]) {
    //        __block UIView *tableViewWrapperView;
    //        
    //        [((UITableView *)style.superView).subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //            if ([obj isKindOfClass:NSClassFromString(@"UITableViewWrapperView")]) {
    //                tableViewWrapperView = obj;
    //                *stop = YES;
    //            }
    //        }];
    //        if (tableViewWrapperView) {
    //            style.superView = tableViewWrapperView;
    //        }
    ////        if (tableViewWrapperView.wyh_y != style.superView.wyh_y) {
    ////            coverY = -64.0; // 因为当某些导航栏透明效果影响,tableView的wrapperView起点会偏移64
    ////        }
    //    }
    
    self.coverView = ({
        UIView *coverView = [[UIView alloc]init];
        coverView.userInteractionEnabled = NO;
        coverView.backgroundColor = [UIColor clearColor];
        coverView;
    });
    [style.superView addSubview:self.coverView];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(style.superView.mas_top);
        make.left.equalTo(style.superView.mas_left);
        make.right.equalTo(style.superView.mas_right);
        make.bottom.equalTo(style.superView.mas_bottom);
    }];
}

static UITableViewCellSeparatorStyle superViewSeparatorStyle;/*不能使用const修饰*/

/**
 根据style进行布局视图
 
 @param style 自定义样式
 */
-(void)setupSubViewsPositionWithStyle:(WyhEmptyStyle *)style {
    
    NSAssert(style, @"style样式不能为空，请检查");
    NSAssert(style.superView, @"必须需要设置父视图，请不要误删style.superView");
    
    if (style.isOnlyText) {
        self.tipImageView = nil;
        self.tipButton = nil;
        
        [self setupTipLabelWithStyle:style];
        [self setupDescriptionLabelWithStyle:style];
        
        if (style.btnClickClosure != nil) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClickAction)];
            tempTapGes = tap;
            self.coverView.userInteractionEnabled = YES;
            [self.coverView addGestureRecognizer:tap]; /*建议superview自定义，避免用主控器的view直接添加手势*/
        }
        
        return;
    }
    
    if (style.refreshStyle == RefreshClickOnBtnStyle) {
        
        [self setupImageViewWithStyle:style];
        
        [self setupTipLabelWithStyle:style];
        [self setupDescriptionLabelWithStyle:style];
        
        [self setupButtonWithStyle:style]; /*必须写在setLabel的后面*/
        
    }
    
    if (style.refreshStyle == RefreshClockOnFullScreenStyle) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClickAction)];
        tempTapGes = tap;
        self.coverView.userInteractionEnabled = YES;
        [self.coverView addGestureRecognizer:tap]; /*建议superview自定义，避免用主控器的view直接添加手势*/
        
        [self setupImageViewWithStyle:style];
        
        [self setupTipLabelWithStyle:style];
        [self setupDescriptionLabelWithStyle:style];
    }
    
    if (style.refreshStyle == noRefreshStyle) {
        
        [self setupImageViewWithStyle:style];
        
        [self setupTipLabelWithStyle:style];
        [self setupDescriptionLabelWithStyle:style];
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
    tipLabel.text = !style.tipText ? wyh_defaultTipText : style.tipText;/* defaultTipText 为默认提示语*/
    tipLabel.textColor = style.tipTextColor;
    tipLabel.font = style.tipFont;
    tipLabel.numberOfLines = 0;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.coverView addSubview:tipLabel];
    self.tipLabel = tipLabel;
    
    if (!style.isOnlyText) {
        
        NSAssert(self.tipImageView, @"setupTiplabel必须在setupImage之后，否则获取不到image的frame");
        
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tipImageView.mas_bottom).offset(10.f);
            make.left.greaterThanOrEqualTo(self.coverView.mas_left).offset(20.f);
            make.right.lessThanOrEqualTo(self.coverView.mas_right).offset(-20.f);
            make.centerX.equalTo(self.coverView.mas_centerX);
        }];
        
    }else{
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.greaterThanOrEqualTo(self.coverView.mas_left).offset(20.f);
            make.right.lessThanOrEqualTo(self.coverView.mas_right).offset(-20.f);
            make.centerY.equalTo(self.coverView.mas_centerY);
            make.centerX.equalTo(self.coverView.mas_centerX);
        }];
    }
}

-(void)setupDescriptionLabelWithStyle:(WyhEmptyStyle *)style {
    
    UILabel *descLabel = [[UILabel alloc]init];
    descLabel.text = !style.descText ? @"" : style.descText;
    descLabel.textColor = style.descTextColor;
    descLabel.font = style.descFont;
    descLabel.numberOfLines = 0;
    descLabel.textAlignment = NSTextAlignmentCenter;
    self.descLabel = descLabel;
    [self.coverView addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLabel.mas_bottom).offset(10);
        make.left.greaterThanOrEqualTo(self.coverView.mas_left).offset(10.f);
        make.right.lessThanOrEqualTo(self.coverView.mas_right).offset(-10.f);
        make.centerX.equalTo(self.coverView.mas_centerX);
    }];
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
    [self.coverView setNeedsLayout];
    [self.coverView layoutIfNeeded];
    
    [imgView sizeToFit];
    CGFloat delta = CGRectGetHeight(imgView.bounds) / CGRectGetWidth(imgView.bounds);
    CGFloat maxWidth = CGRectGetWidth(imgView.bounds);
    if (maxWidth > CGRectGetWidth(UIScreen.mainScreen.bounds)*2.f/3.f) {
        maxWidth = CGRectGetWidth(UIScreen.mainScreen.bounds)*2.f/3.f;
    }
    
    [self.coverView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.coverView.mas_centerX);
        make.top.equalTo(self.coverView.mas_top).offset(CGRectGetHeight(self.coverView.bounds) * style.imageOragionY);
        make.width.offset(maxWidth);
        make.height.equalTo(imgView.mas_width).multipliedBy(delta);
    }];
    self.tipImageView = imgView;
}

-(void)setupButtonWithStyle:(WyhEmptyStyle *)style{
    
    NSAssert(self.tipLabel != nil, @"setupBtn必须在setupLabel之后，否则获取不到label的frame");
    style.btnTipText = !style.btnTipText ? wyh_defaultBtnTipText : style.btnTipText;
    style.btnTitleColor = !style.btnTitleColor ? [UIColor redColor] : style.btnTitleColor;
    style.btnLayerBorderColor = !style.btnLayerBorderColor ? [UIColor lightGrayColor] : style.btnLayerBorderColor;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:style.btnTipText forState:UIControlStateNormal];
    btn.titleLabel.font = style.btnFont?:[UIFont systemFontOfSize:15.f];
    if (style.btnImage) [btn setBackgroundImage:style.btnImage forState:(UIControlStateNormal)];
    [btn setTitleColor:style.btnTitleColor forState:UIControlStateNormal];
    btn.titleLabel.textColor = [UIColor lightGrayColor];
    btn.frame = CGRectZero;
    [btn sizeToFit];
    CGFloat btnW = CGRectGetWidth(btn.bounds)>style.btnWidth?(CGRectGetWidth(btn.bounds)+10):style.btnWidth;
    CGFloat btnH = CGRectGetHeight(btn.bounds)>style.btnHeight?CGRectGetWidth(btn.bounds):style.btnHeight;
    btn.layer.borderColor = style.btnLayerBorderColor.CGColor;
    btn.layer.borderWidth = style.btnLayerborderWidth;
    btn.layer.cornerRadius = style.btnLayerCornerRadius;
    btn.layer.masksToBounds = YES;
    self.tipButton = btn;
    [btn addTarget:self action:@selector(btnClickAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.coverView.userInteractionEnabled = YES;
    [self.coverView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLabel.mas_bottom).offset(20.f);
        make.centerX.equalTo(self.coverView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
}

#pragma mark - btnClickAction
-(void)btnClickAction{
    
    //    NSLog(@"点击了刷新");
    [self removeSubViews]; /*remove一定要放在回调block之前*/
    
    if (self.wyhEmptyStyle.btnClickClosure) {
        self.wyhEmptyStyle.btnClickClosure();
    }
    
}

-(void)removeSubViews{
    self.isShowed = @"0";
    if ([self.wyhEmptyStyle.superView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self.wyhEmptyStyle.superView;
        tableView.separatorStyle = superViewSeparatorStyle;/*恢复分割线样式*/
    }
    if (tempTapGes!=nil) {
        [self.coverView removeGestureRecognizer:tempTapGes];
    }
    [self.tipLabel removeFromSuperview];
    [self.tipButton removeFromSuperview];
    [self.tipImageView removeFromSuperview];
    [self.coverView removeFromSuperview];
    
}

#pragma mark - setter and getter

#pragma mark - label
-(void)setTipLabel:(UILabel *)tipLabel{
    objc_setAssociatedObject(self, &wyh_labelKey, tipLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UILabel *)tipLabel{
    return objc_getAssociatedObject(self, &wyh_labelKey);
}

-(void)setDescLabel:(UILabel *)descLabel {
    objc_setAssociatedObject(self, @selector(descLabel), descLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)descLabel {
    return objc_getAssociatedObject(self, _cmd);
}

#pragma mark - button
-(void)setTipButton:(UIButton *)tipButton{
    objc_setAssociatedObject(self, &wyh_btnKey, tipButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIButton *)tipButton{
    return objc_getAssociatedObject(self, &wyh_btnKey);
}

#pragma mark - imageView
-(void)setTipImageView:(UIImageView *)tipImageView{
    objc_setAssociatedObject(self, &wyh_imageKey, tipImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIImageView *)tipImageView{
    return objc_getAssociatedObject(self, &wyh_imageKey);
}

#pragma mark - wyhStyle
-(void)setWyhEmptyStyle:(WyhEmptyStyle *)wyhEmptyStyle{
    objc_setAssociatedObject(self, &wyh_styleKey, wyhEmptyStyle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(WyhEmptyStyle *)wyhEmptyStyle{
    
    return objc_getAssociatedObject(self, &wyh_styleKey);
}

#pragma mark - isShowed
-(void)setIsShowed:(NSString *)isShowed{
    objc_setAssociatedObject(self, &wyh_isShowedKey, isShowed, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSString *)isShowed{
    return objc_getAssociatedObject(self, &wyh_isShowedKey);
}

#pragma mark - coverView
-(void)setCoverView:(UIView *)coverView{
    objc_setAssociatedObject(self, &wyh_coverViewKey, coverView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIView *)coverView{
    return objc_getAssociatedObject(self, &wyh_coverViewKey);
}
@end
