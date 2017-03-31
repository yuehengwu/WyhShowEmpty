//
//  ViewController.m
//  WyhShowEmptyCategory
//
//  Created by 吴岳恒 on 2017/2/8.
//  Copyright © 2017年 wyh. All rights reserved.
//

#import "ViewController.h"

#import "WyhShowEmpty.h"

#import "Test1ViewController.h"
#import "Test2ViewController.h"
#import "Test3ViewController.h"
#import "Test4ViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

#define ScreenSize [UIScreen mainScreen].bounds.size

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.title = @"WyhShowEmpty Demo";
    
    [self dataSource];
    
    [self tableView];
    
}

-(NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        
        _dataSource = @[@"纯文本展示",
                        @"带图片带重试按钮展示",
                        @"缩小tableView的无内容展示",
                        @"自定义style，带动图展示"].mutableCopy;
    }
    return _dataSource;
}

-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenSize.width, ScreenSize.height) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    cell.textLabel.text = _dataSource[indexPath.row];
    cell.selectionStyle = 0;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *VC = nil;
    switch (indexPath.row) {
        case 0:
        {
            Test1ViewController *test1 = [[Test1ViewController alloc]init];
            VC = test1;
        }
            break;
        case 1:
        {
            Test2ViewController *test2 = [[Test2ViewController alloc]init];
            VC = test2;
        }
            break;
        case 2:
        {
            Test3ViewController *test3 = [[Test3ViewController alloc]init];
            VC = test3;
        }
            break;
        case 3:
        {
            Test4ViewController *test4 = [[Test4ViewController alloc]init];
            VC = test4;
        }
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:VC animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
