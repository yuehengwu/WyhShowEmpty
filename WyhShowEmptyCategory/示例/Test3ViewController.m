//
//  Test3ViewController.m
//  WyhShowEmptyCategory
//
//  Created by wyh on 2017/2/9.
//  Copyright © 2017年 wyh. All rights reserved.
//

#import "Test3ViewController.h"

@interface Test3ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) BOOL isNoNet; /*模拟无网络情况*/

@end

@implementation Test3ViewController



-(NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        
        _dataSource = [self getData];
    }
    return _dataSource;
}

-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenSize.width, ScreenSize.height) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
             @"测试---4"].mutableCopy;
}

/**
 模拟网络请求
 */
-(void)loadNetWork{
    
    if (!self.isNoNet) {
        self.dataSource = [self getData];
    }
    
    [self.tableView reloadData];
    
    self.wyhEmptyStyle.superView = self.tableView;
    
    //在success回调方法里加入
    [self wyh_showEmptyMsg:@"当前暂无内容，点击屏幕刷新" dataCount:self.dataSource.count isHasBtn:NO Handler:^{
        self.isNoNet = NO;
        [self loadNetWork];
    }];
    
    //在fail回调方法里加入
    /*
    [self wyh_showEmptyMsg:@"网络差，刷新试试" dataCount:self. dataSource.count isHasBtn:NO Handler:^{
        self.isNoNet = NO;
        [self loadNetWork];
    }];
     */
    
}

#pragma mark - tableView delegate

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
