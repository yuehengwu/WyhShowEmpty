# WyhShowEmpty

## Quick show placholder or empty UI in any view, easy to support refresh UI when service Api responsed.

![example](http://upload-images.jianshu.io/upload_images/4097230-4431fc807b524141.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


### Gif : http://www.jianshu.com/p/34ffaa883806

## CocoaPods:

 `pod search WyhShowEmpty`

## Code:

### 1. Show empty UI when data source was nil.

```objc
    [self wyh_showEmptyMsg:@"No data" dataCount:self.dataSource];
```

### 2. Custom style to show different UI.

```objc
    WyhEmptyStyle *style = [[WyhEmptyStyle alloc]init];
    style.tipText = @"Service down!";
    style.tipTextColor = [UIColor brownColor];
    style.btnTipText = @"Disappear";
    style.imageConfig.type = GifImgLocalUrl;
    style.refreshStyle = RefreshClickOnBtnStyle;
    style.btnWidth = 100;
    style.btnHeight = 100;
    style.btnLayerCornerRadius = 50;
    style.btnLayerBorderColor = [UIColor redColor];

    [self wyh_showWithStyle:style];
```

### 3. Show empty UI in every service request, and refresh UI in every response . So it will show empty view if resp data was nil.

```objc
-(void)loadNetWork{

    [[AFHTTPSessionManager manager] POST:url parameters:body progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] isEqualToNumber:@0]) {

            dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            // suc resp:
            [self wyh_showEmptyMsg:@"No new data." dataCount:self.dataSource];
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // failure resp:
        [self wyh_showEmptyMsg:@"Service disabled!" dataCount:0 isHasBtn:YES Handler:^{
        [self loadNetWork];
      }];
    }];

}
```


## Contact Me:

####   JianShu : http://www.jianshu.com/u/b76e3853ae0b
####   GitHub   : https://github.com/XiaoWuTongZhi/WyhShowEmpty
####   QQ e-mail   : 609232770@qq.com


