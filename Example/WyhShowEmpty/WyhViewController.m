//
//  WyhViewController.m
//  WyhShowEmpty
//
//  Created by Michael Wu on 04/15/2019.
//  Copyright (c) 2019 Michael Wu. All rights reserved.
//

#import "WyhViewController.h"

#import <Masonry.h>
#import <WyhShowEmpty.h>

#import "Test1ViewController.h"
#import "Test2ViewController.h"
#import "Test3ViewController.h"
#import "Test4ViewController.h"

@interface WyhViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation WyhViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.title = @"WyhShowEmpty Demo";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    [self performSelector:@selector(initialize) withObject:nil afterDelay:0.1f];
    
    __weak typeof(self) weakSelf = self;
    
    [self.tableView wyh_showEmptyMsg:@"WyhShowEmptyDemo" desc:@"点击屏幕进入demo" dataCount:0 customImgName:nil imageOragionY:0.2 isHasBtn:NO Handler:^{
        [weakSelf.view addSubview:weakSelf.tableView];
        [weakSelf.tableView reloadData];
    }];
}

- (void)initialize {
    
    _dataSource = @[@"纯文本展示",
                    @"带图片带重试按钮展示",
                    @"缩小tableView的无内容展示",
                    @"自定义style，带动图展示"].mutableCopy;
    
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
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

@end
