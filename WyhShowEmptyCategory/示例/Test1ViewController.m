//
//  Test1ViewController.m
//  WyhShowEmptyCategory
//
//  Created by wyh on 2017/2/9.
//  Copyright © 2017年 wyh. All rights reserved.
//

#import "Test1ViewController.h"

@interface Test1ViewController ()

@end

@implementation Test1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.view wyh_showEmptyMsg:@"童年，那一味苦涩的年香 流水时光，星移斗转，一眨眼，就又到了年边，过年的喜悦情不自禁地爬上了眉梢，厚那厚的年俗里所有的年事就放手做开了。 \
     如今物质丰富，商店里的年货琳琅满目、应有尽有，很多年事再也不用自己劳累了，只要口袋里揣上钱高高兴兴地买回家，一家人就可以欢天喜地过年了。 \
     童年时过年的虽然没有现在的丰盛，但大人小孩并没有因此而缺少过年的那份热情，幸福和快乐时刻洋溢在脸上。" dataCount:0];
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
