//
//  Test2ViewController.m
//  WyhShowEmptyCategory
//
//  Created by wyh on 2017/2/9.
//  Copyright © 2017年 wyh. All rights reserved.
//

#import "Test2ViewController.h"

@interface Test2ViewController ()<UITableViewDataSource>

@property (nonatomic, strong) UITableView *table;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) BOOL isNoNet;

@end

@implementation Test2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.table];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"出现" style:(UIBarButtonItemStyleDone) target:self action:@selector(simNoNetWork)];
    self.navigationItem.rightBarButtonItem = right;
    
    [self loadNetWork];
    
}

-(void)simNoNetWork{
    self.isNoNet = YES;
    [self.dataSource removeAllObjects];
    [self loadNetWork];
}

-(NSMutableArray *)getData{
    
    return @[@"测试---1",
             @"测试---2",
             @"测试---3",
             @"测试---4",
             @"测试---5",
             @"测试---6",
             @"测试---7",
             @"测试---8",
             @"测试---9",
             ].mutableCopy;
}

/**
 模拟网络请求
 */
-(void)loadNetWork{
    
    if (!self.isNoNet) {
        self.dataSource = [self getData];
    }
    
    [self.table reloadData];
    
    
//    self.wyhEmptyStyle.superView = self.table;/* 现已不需要设置*/
    __weak typeof(self) weakself = self;
    [self.table wyh_showEmptyMsg:@"网络不给力" desc:@"点击刷新" dataCount:self.dataSource.count isHasBtn:YES Handler:^{
        weakself.isNoNet = NO;
        [weakself loadNetWork];
    }];
    
}

#define ScreenSize [UIScreen mainScreen].bounds.size

-(UITableView *)table{
    
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenSize.width, ScreenSize.height) style:(UITableViewStylePlain)];
        _table.dataSource = self;
//        _table.delegate = self;
    }
    return _table;
    
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
        _dataSource = [self getData];
    }
    return _dataSource;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
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
