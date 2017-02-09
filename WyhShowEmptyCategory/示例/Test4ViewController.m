//
//  Test4ViewController.m
//  WyhShowEmptyCategory
//
//  Created by wyh on 2017/2/9.
//  Copyright © 2017年 wyh. All rights reserved.
//

#import "Test4ViewController.h"

@interface Test4ViewController ()

@end

@implementation Test4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"出现" style:(UIBarButtonItemStyleDone) target:self action:@selector(tryAgain)];
    self.navigationItem.rightBarButtonItem = right;
    
    
    [self tryAgain];
}


-(void)tryAgain{
    /*自定义视图设置*/
    WyhEmptyStyle *style = [[WyhEmptyStyle alloc]init];
    style.tipText = @"转了一圈又一圈";
    style.tipTextColor = [UIColor brownColor];
    style.btnTipText = @"消失";
    style.imageConfig.type = GifImgLocalUrl;
    style.refreshStyle = RefreshClickOnBtnStyle;
    style.btnWidth = 100;
    style.btnHeight = 100;
    style.btnLayerCornerRadius = 50;
    style.btnLayerBorderColor = [UIColor redColor];
    self.wyhEmptyStyle = style;
    
    [self wyh_showWithStyle:style];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
