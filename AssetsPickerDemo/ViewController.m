//
//  ViewController.m
//  AssetsPickerDemo
//
//  Created by 刘隆昌 on 15-1-1.
//  Copyright (c) 2015年 刘隆昌. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,ZLPickerViewControllerDelegate,ZLPickerBrowserViewControllerDataSource,ZLPickerBrowserViewControllerDelegate>


{
    
    NSMutableArray * _tCell;
}

- (void)selectPhotos;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *assets;

@property (nonatomic , strong) ZLPickerBrowserViewController *pickerBrowser;
//@property (nonatomic , assign) CGRect tempFrame;
@property (nonatomic , strong) NSMutableDictionary *params;
@property (strong,nonatomic)   ZLCameraViewController *cameraVc;

@end

@implementation ViewController

#pragma mark -getter
- (NSMutableArray *)assets{
    if (!_assets) {
        // 测试数据
        NSArray *testAssets = @[
                                @"http://cocoimg.365rili.com/schedule_pics/default/bd625d59-5e98-4719-8220-f1e56902f3c1.jpg!thumb320",
                                @"http://e.hiphotos.baidu.com/zhidao/pic/item/574e9258d109b3de40f319c6cebf6c81810a4cd4.jpg",
                                @"http://image.tianjimedia.com/uploadImages/2013/165/P9KJTQBA119S.jpg",
                                @"http://image.tianjimedia.com/uploadImages/2012/013/0C4PQ1XX78O3.jpg"
                                ];
        self.assets = [NSMutableArray arrayWithArray:testAssets];
        
        _tCell = [NSMutableArray array];
       [testAssets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
           [_tCell addObject:[[CustTabViewCell alloc] init]];
       }];
    
        
        
        
        
    }
    return _assets;
}
//
- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.dataSource = self;
        tableView.delegate = self;
        [self.view addSubview:tableView];
        self.tableView = tableView;
        
        tableView.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSString *vfl = @"V:|-topPadding-[tableView]-padding-|";
        NSDictionary *views = NSDictionaryOfVariableBindings(tableView);
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl options:0 metrics:self.params views:views]];
        NSString *vfl2 = @"H:|-padding-[tableView]-padding-|";
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl2 options:0 metrics:self.params views:views]];
    }
    return _tableView;
}
//
- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置AutoLayout参数
    [self setAutoLayoutParams];
    
    [self tableView];
    [self.tableView reloadData];
    [self setupButtons];

    //[self performSelector:@selector(loadDatar) withObject:nil afterDelay:0.1];
}


-(void)loadDatar{
    [self.tableView reloadData];
}


#pragma mark -setter
#pragma mark 设置AutoLayout参数
- (void) setAutoLayoutParams{
    self.params = [NSMutableDictionary dictionary];
    self.params[@"padding"] = @"20";
    self.params[@"topPadding"] = @"0";
}
- (void) setupButtons{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"选择照片" style:UIBarButtonItemStyleDone target:self action:@selector(selectPhotos)];
}


- (void)selectPhotos {
    
   // [self.tableView reloadData];
    
    ZLCameraViewController *cameraVc = [[ZLCameraViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    [cameraVc startCameraOrPhotoFileWithViewController:self complate:^(id object) {
        [object enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                [weakSelf.assets addObjectsFromArray:[obj allValues]];
                
                [_tCell addObject:[[CustTabViewCell alloc] init]];
                
            }else{
                [weakSelf.assets addObject:obj];
                [_tCell addObject:[[CustTabViewCell alloc] init]];
                
            }
        }];
        [weakSelf.tableView reloadData];
    }];
    self.cameraVc = cameraVc;
    
    // 可以用下面来创建ZLPickerViewController, 就没有拍照的选项了
    /*
     // 创建控制器
     ZLPickerViewController *pickerVc = [[ZLPickerViewController alloc] init];
     // 默认显示相册里面的内容SavePhotos
     pickerVc.status = PickerViewShowStatusCameraRoll;
     // 选择图片的最大数
     // pickerVc.maxCount = 4;
     pickerVc.delegate = self;
     [pickerVc show];
     */
    
    /**
     *
     传值可以用代理，或者用block来接收，以下是block的传值
     __weak typeof(self) weakSelf = self;
     pickerVc.callBack = ^(NSArray *assets){
     weakSelf.assets = assets;
     [weakSelf.tableView reloadData];
     };
     */
    
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.assets.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
   
    
    CustTabViewCell * cell = [_tCell objectAtIndex:indexPath.row];
    
    return cell.rowHeight+20;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CustTabViewCell *cell = (CustTabViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    [self setupPhotoBrowser:cell];
}


- (void) setupPhotoBrowser:(CustTabViewCell *) cell{
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    // 图片游览器
    ZLPickerBrowserViewController *pickerBrowser = [[ZLPickerBrowserViewController alloc] init];
    // 传入点击图片View的话，会有微信朋友圈照片的风格
    pickerBrowser.toView = cell.imaView;
    // 数据源/delegate
    pickerBrowser.delegate = self;
    pickerBrowser.dataSource = self;
    // 是否可以删除照片
    pickerBrowser.editing = YES;
    // 当前选中的值
    pickerBrowser.currentPage = indexPath.row;
    // 展示控制器
    [pickerBrowser show];
    self.pickerBrowser = pickerBrowser;
}

//#pragma mark <ZLPickerBrowserViewControllerDataSource>
- (NSInteger) numberOfPhotosInPickerBrowser:(ZLPickerBrowserViewController *)pickerBrowser{
    return self.assets.count;
}

- (ZLPickerBrowserPhoto *) photoBrowser:(ZLPickerBrowserViewController *)pickerBrowser photoAtIndex:(NSUInteger)index{
    
    id imageObj = [self.assets objectAtIndex:index];
    ZLPickerBrowserPhoto *photo = [ZLPickerBrowserPhoto photoAnyImageObjWith:imageObj];
    CustTabViewCell *cell = (CustTabViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    photo.thumbImage = cell.imaView.image;
    
    return photo;
}

#pragma mark <ZLPickerBrowserViewControllerDelegate>
- (void)photoBrowser:(ZLPickerBrowserViewController *)photoBrowser removePhotoAtIndex:(NSUInteger)index{
    if (index > self.assets.count) return;
    [self.assets removeObjectAtIndex:index];
    [self.tableView reloadData];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"cell";
    
    CustTabViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[CustTabViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    ALAsset *asset = self.assets[indexPath.row];
    if ([asset isKindOfClass:[ALAsset class]]) {
        
        cell.imaView.image = [UIImage imageWithCGImage:[asset thumbnail]];
        
    }else if ([asset isKindOfClass:[NSString class]]){
        
        [cell configUI:(NSString*)asset];
        
    
        
    }else if([asset isKindOfClass:[UIImage class]]){
        
        cell.imaView.image = (UIImage *)asset;
        
    }
    
    return cell;
    
}

// 代理回调方法
- (void)pickerViewControllerDoneAsstes:(NSArray *)assets{
    [self.assets addObjectsFromArray:assets];
    [self.tableView reloadData];
}

#pragma mark - 自定义动画
// 你也可以自定义动画
// 参考BaseAnimationView
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UIView *boxView = [[UIView alloc] init];
    boxView.backgroundColor = [UIColor redColor];
    
    NSDictionary *options = @{
                              UIViewAnimationInView:self.view,
                              UIViewAnimationToView:boxView,
                              };
    
    
    [ZLAnimationBaseView animationViewWithOptions:options animations:^{
        // TODO .. 执行动画时
    } completion:^(ZLAnimationBaseView *baseView) {
        // TODO .. 动画执行完时
    }];
    
}

@end
