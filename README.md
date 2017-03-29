# WyhShowEmpty

## 简单解决对于UIViewController/UITableViewController无网络、无内容时的展示,进来看一下动图秒懂


## 示例效果 Tip:如果gif太快看不了 请点击gif查看

![应用中示例.gif](http://upload-images.jianshu.io/upload_images/4097230-1fbdea155c82b3c2.gif?imageMogr2/auto-orient/strip)

![demo中示例.gif](http://upload-images.jianshu.io/upload_images/4097230-3fdbfc4e2c758564.gif?imageMogr2/auto-orient/strip)

![示例1](http://upload-images.jianshu.io/upload_images/4097230-e838e3a890a21264.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 代码示例: 

```
##示例1：一行代码搞定,若dataSource数组个数为0，则显示

    [self wyh_showEmptyMsg:@"暂无内容" dataCount:self.dataSource];

##示例2：同样可以自定义，丰富的API
    
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

    //自定义后还是一行代码
    [self wyh_showWithStyle:style];


##示例3：模拟在网络请求中的应用，以tableView为例
-(void)loadNetWork{

    [[AFHTTPSessionManager manager] POST:url parameters:body progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] isEqualToNumber:@0]) {

            dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            //成功回调里添加
            [self wyh_showEmptyMsg:@"很抱歉咱无更新" dataCount:self.dataSource];
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败回调里添加
        [self wyh_showEmptyMsg:@"网络不给力，点击刷新" dataCount:0 isHasBtn:YES Handler:^{
        [self loadNetWork];
      }];
    }];

}
```

**具体原理请看源码**

##如果你希望联系到我:

##   简书地址:http://www.jianshu.com/u/b76e3853ae0b
##github地址:https://github.com/XiaoWuTongZhi/WyhShowEmpty
##    qq邮箱: 609232770@qq.com 
