//
//  UIView+WyhShowEmpty.m
//  WyhShowEmptyCategory
//
//  Created by wyh on 2017/4/6.
//  Copyright © 2017年 wyh. All rights reserved.
//

#import "UIView+WyhShowEmpty.h"
#import "WyhEmptyStyle.h"
#import <objc/runtime.h>
#import "UIView+WyhExtension.h"
#import "WyhShowEmptyConst.h"

@interface UIView ()

@property (nonatomic, strong) NSString *isShowed; /*是否正在展示,主要防止重复添加*/

@property (nonatomic, strong) UIView *superView;

@property (nonatomic, strong) UIButton *tipButton;

@property (nonatomic, strong) UIImageView *tipImageView;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UIView *coverView;

@end

@implementation UIView (WyhShowEmpty)
static CGFloat superViewWidth = 0.0;
static CGFloat superViewHeight = 0.0;
UITapGestureRecognizer *tempTapGes;

+(void)load {
    
#if DEBUG
    NSLog(@"\n\
          WyhShowEmpty 可进行自定义效果展示,只需要重写WyhEmptyStyle的属性\n\
          现已无需设置superView为tableView,默认加在tableView上\n\
          若需求不同,请自行到UIViewController+WyhShowEmpty.m进行修改\n\
          若当你希望调整WyhShowEmpty展示的位置\n\
          请自行调节起始y值位置:\n\
          self.wyhEmptyStyle.imageOragionY(imageOragionY为比例设置)\n\
          如果你在使用中仍然存在问题,请尝试联系我\n\
          简书:   http://www.jianshu.com/u/b76e3853ae0b \n\
          QQ邮箱: 609223770@qq.com \n\
          ");
    /**
     *  简书: http://www.jianshu.com/u/b76e3853ae0b
     *  QQ : 609223770@qq.com
     */
#endif
    
}

-(void)wyh_showEmptyMsg:(NSString *)msg dataCount:(NSUInteger)count {
    
    if (!self.wyhEmptyStyle) {
        WyhEmptyStyle *wyhStyle = [[WyhEmptyStyle alloc]init];
        wyhStyle.refreshStyle = noRefreshStyle;
        wyhStyle.superView = self;
        wyhStyle.isOnlyText = YES;
        wyhStyle.refreshStyle = noRefreshStyle;
        self.wyhEmptyStyle = wyhStyle;
    }
    
    self.wyhEmptyStyle.tipText = msg;
    self.wyhEmptyStyle.dataSourceCount = count;
    
    [self wyh_showWithStyle:self.wyhEmptyStyle];
}

-(void)wyh_showEmptyMsg:(NSString *)msg dataCount:(NSUInteger)count isHasBtn:(BOOL)hasBtn Handler:(void(^)())handleBlock {
    
    if (!self.wyhEmptyStyle) {
        WyhEmptyStyle *wyhStyle = [[WyhEmptyStyle alloc]init];
        wyhStyle.superView = self;
        self.wyhEmptyStyle = wyhStyle;
    }
    self.wyhEmptyStyle.refreshStyle = hasBtn?RefreshClickOnBtnStyle:RefreshClockOnFullScreenStyle;
    self.wyhEmptyStyle.tipText = msg;
    self.wyhEmptyStyle.dataSourceCount = count;
    self.tipHandler = handleBlock;
    
    [self wyh_showWithStyle:self.wyhEmptyStyle];
    
}

-(void)wyh_showEmptyMsg:(NSString *)msg dataCount:(NSUInteger)count customImgName:(NSString *)imageName {
    
    if (!self.wyhEmptyStyle) {
        
        WyhEmptyStyle *wyhStyle = [[WyhEmptyStyle alloc]init];
        wyhStyle.refreshStyle = noRefreshStyle;
        wyhStyle.isOnlyText = NO;
        if (imageName) {
            wyhStyle.imageConfig.type = ImgTypeName;
            wyhStyle.imageConfig.imageData = imageName;
        }
        wyhStyle.superView = self;
        self.wyhEmptyStyle = wyhStyle;
    }
    self.wyhEmptyStyle.tipText = msg;
    self.wyhEmptyStyle.dataSourceCount = count;
    
    [self wyh_showWithStyle:self.wyhEmptyStyle];
}

-(void)wyh_showEmptyMsg:(NSString *)msg
              dataCount:(NSUInteger)count
          customImgName:(NSString *)imageName
          imageOragionY:(CGFloat)imageOragionY
                Handler:(void(^)())handleBlock{
    
    WyhEmptyStyle *style = [[WyhEmptyStyle alloc]init];
    style.refreshStyle = RefreshClockOnFullScreenStyle;
    style.imageOragionY = imageOragionY;
    style.tipText = msg;
    style.imageConfig.imageData = imageName?:style.imageConfig.imageData;
    style.imageConfig.type = ImgTypeName;
    style.dataSourceCount = count;
    self.wyhEmptyStyle = style;
    self.tipHandler = handleBlock;
    
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

/**
 布局coverView
 
 @param style 自定义样式
 */
-(void)setupCoverViewPostionWithStyle:(WyhEmptyStyle *)style{
    
    CGFloat coverX = 0.0;
    CGFloat coverY = 0.0;
    __block UITableView *coverTable;
    /** 为了更方便用户调用,默认直接将coverView加在tableView上,若有不同需求可自行在此修改*/
    if (![style.superView isKindOfClass:[UITableView class]]) {
        [style.superView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UITableView class]]) {
                coverTable = (UITableView *)obj;
                style.superView = coverTable;
                *stop = YES;
            }
        }];
    }
    
    if ([style.superView isKindOfClass:[UITableView class]]) {
        __block UIView *tableViewWrapperView;
        
        [((UITableView *)style.superView).subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:NSClassFromString(@"UITableViewWrapperView")]) {
                tableViewWrapperView = obj;
                *stop = YES;
            }
        }];
        //        style.superView = tableViewWrapperView;
        
        if (tableViewWrapperView.wyh_y != style.superView.wyh_y) {
            coverY = -64.0; /* 因为当某些导航栏透明效果影响,tableView的wrapperView起点会偏移64 */
        }
    }
    superViewWidth = style.superView.wyh_w;
    superViewHeight = style.superView.wyh_h;
    
    UIView *coverView = [[UIView alloc]init];
    coverView.frame = CGRectMake(coverX, coverY, superViewWidth, superViewHeight);
    coverView.userInteractionEnabled = NO;
    coverView.backgroundColor = [UIColor clearColor];
    self.coverView = coverView;
    [self.wyhEmptyStyle.superView addSubview:self.coverView];
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
        
        if (self.tipHandler != nil) {
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
        
        [self setupButtonWithStyle:style]; /*必须写在setLabel的后面*/
        
    }
    
    if (style.refreshStyle == RefreshClockOnFullScreenStyle) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClickAction)];
        tempTapGes = tap;
        self.coverView.userInteractionEnabled = YES;
        [self.coverView addGestureRecognizer:tap]; /*建议superview自定义，避免用主控器的view直接添加手势*/
        
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
    tipLabel.text = !style.tipText ? wyh_defaultTipText : style.tipText;/* defaultTipText 为默认提示语*/
    tipLabel.textColor = style.tipTextColor;
    tipLabel.numberOfLines = 0;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.frame = CGRectMake(0, 0, superViewWidth - 40, 0);
    [tipLabel sizeToFit];
    NSAssert(superViewHeight>tipLabel.wyh_h, @"设置的文本太长，超出了父视图的高度！");
    
    [self.coverView addSubview:tipLabel];
    self.tipLabel = tipLabel;
    
    if (!style.isOnlyText) {
        
        NSAssert(self.tipImageView, @"setupTiplabel必须在setupImage之后，否则获取不到image的frame");
        
        CGFloat tipX = (superViewWidth - tipLabel.wyh_w) * 0.5;
        CGFloat tipY = self.tipImageView.wyh_bottom + 30;
        tipLabel.frame = CGRectMake(tipX, tipY, tipLabel.wyh_w, tipLabel.wyh_h);
        
    }else{
        
        tipLabel.frame = CGRectMake((superViewWidth - tipLabel.wyh_w)/2, (superViewHeight - tipLabel.wyh_h)/2, tipLabel.wyh_w, tipLabel.wyh_h);
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
        NSAssert(style.imageSize.width <= superViewWidth, @"");
        imgView.wyh_size = style.imageSize;
    }else{
        NSAssert(style.imageMaxWidth>0, @"图片允许的最大宽度不得小于0");
        CGFloat allowedMaxW = style.imageMaxWidth;
        CGFloat allowedMaxH = style.imageMaxWidth*imgView.wyh_h/imgView.wyh_w;
        imgView.wyh_w = imgView.wyh_w > allowedMaxW ? allowedMaxW :imgView.wyh_w;
        imgView.wyh_h = imgView.wyh_h > allowedMaxH ? allowedMaxH:imgView.wyh_h;
    }
    CGFloat imagVx = (superViewWidth - imgView.wyh_w) * 0.5;
    CGFloat imagVy = superViewHeight*style.imageOragionY;
    imgView.frame = CGRectMake(imagVx, imagVy, imgView.wyh_w, imgView.wyh_h);
    [self.coverView addSubview:imgView];
    self.tipImageView = imgView;
}

-(void)setupButtonWithStyle:(WyhEmptyStyle *)style{
    
    NSAssert(self.tipLabel != nil, @"setupBtn必须在setupLabel之后，否则获取不到label的frame");
    style.btnTipText = !style.btnTipText ? wyh_defaultBtnTipText : style.btnTipText;
    style.btnTitleColor = !style.btnTitleColor ? [UIColor redColor] : style.btnTitleColor;
    style.btnLayerBorderColor = !style.btnLayerBorderColor ? [UIColor lightGrayColor] : style.btnLayerBorderColor;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:style.btnTipText forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    if (style.btnImage) [btn setBackgroundImage:style.btnImage forState:(UIControlStateNormal)];
    [btn sizeToFit];
    [btn setTitleColor:style.btnTitleColor forState:UIControlStateNormal];
    btn.titleLabel.textColor = [UIColor lightGrayColor];
    CGFloat btnX = (superViewWidth - style.btnWidth) * .5f;
    CGFloat btnY = CGRectGetMaxY(self.tipLabel.frame) + 20;/*20是一个神奇数字*/
    btn.frame = CGRectMake(btnX, btnY, style.btnWidth, style.btnHeight);
    btn.layer.borderColor = style.btnLayerBorderColor.CGColor;
    btn.layer.borderWidth = style.btnLayerborderWidth;
    btn.layer.cornerRadius = style.btnLayerCornerRadius;
    btn.layer.masksToBounds = YES;
    self.tipButton = btn;
    [self.coverView addSubview:btn];
    self.coverView.userInteractionEnabled = YES;
    [btn addTarget:self action:@selector(btnClickAction) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - btnClickAction
-(void)btnClickAction{
    
    //    NSLog(@"点击了刷新");
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

#pragma mark - block
-(void)setTipHandler:(void (^)())tipHandler{
    objc_setAssociatedObject(self, &wyh_blockKey, tipHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(void (^)())tipHandler{
    return objc_getAssociatedObject(self, &wyh_blockKey);
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
