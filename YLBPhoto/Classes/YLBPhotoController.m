//
//  YLBPhotoController.m
//  YLBPhoto_Example
//
//  Created by yulibo on 2020/9/25.
//  Copyright © 2020 ProBobo. All rights reserved.
//

#import "YLBPhotoController.h"
#import <YLBProUI/YLBNavigationBarView.h>
#import "YLBPhotoTools.h"
#import <YLBCommon/YLBCommon.h>
#import "YLBPhotoViewCell.h"

@interface YLBPhotoController ()<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>
@property(nonatomic, strong) YLBNavigationBarView *ylbNavigationBarView;
@property (strong, nonatomic) NSMutableArray *dateArray;
@property (strong, nonatomic) NSMutableArray *allArray;
@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) UICollectionView *collectionView;
@end

static NSString * const kYLBPhotoViewCell = @"kYLBPhotoViewCell";

@implementation YLBPhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.ylbNavigationBarView];
    [self setupSubviews];
}

- (void)setupSubviews {
    /*
     1、 首次调用相册权限的为难：仅会获取相应的权限提示 而不会响应方法
         //每次访问相册都会调用这个handler  检查改app的授权情况
         //PHPhotoLibrary
         [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
             if (status == PHAuthorizationStatusAuthorized) {
               //code
             }
         }];
     2、获取所有图片（注意不能在胶卷中获取图片，因为胶卷中的图片包含了video的显示图）
         [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];//这样获取
         也可以使用PHFetchOptions中的谓词过滤获取
         PHFetchOptions *fetchResoultOption = [[PHFetchOptions alloc] init];
         fetchResoultOption.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:false]];
         fetchResoultOption.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];
     3、使用PHImageManager请求时的回调同步or异步时、block回调次数的问题
     4、回调得出的图片size的问题: 由3个参数决定
          在ShowAlbumViewController 中观察
          在PHImageContentModeAspectFill 下  图片size 有一个分水岭  {125,125}   {126,126}
          当imageOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
          时: 设置size 小于{125,125}时，你得到的图片size 将会是设置的1/2
          而在PHImageContentModeAspectFit 分水岭  {120,120}   {121,121}
     5、回调中info字典key消失的问题:
           简单地说，就是你如果是自定义的size，且返回的图片的size小于源图片的size 那么你将会得不到图片的相对路径等部分key
     6、显示的相册名字不是中文：在info.plist 中设置
           Localized resources can be mixed   YES
           本地资源的适配
     7、This app has crashed because it attempted to access privacy-sensitive data
         without a usage description.
         The app's Info.plist must contain an NSPhotoLibraryUsageDescription key
         with a string value explaining to the user how the app uses this data.
         本app因未得到使用说明就直接企图访问私人数据而导致崩溃。
         app想要访问这些私人数据就得在info.plist增加一个以NSPhotoLibraryUsageDescription为键，以字符串为值的键值对。＝
     */
    
    //1、判断权限
    __weak __typeof(self)weakSelf = self;
    [YLBPhotoTools requestAuthorization:self handler:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            YLBDLog(@"有权限");
            [weakSelf goPhotoViewController];
        }else {
            YLBDLog(@"没有权限");
        }
    }];
}
#pragma mark - 初始化
- (NSMutableArray *)allArray {
    if (!_allArray) {
        _allArray = [NSMutableArray array];
    }
    return _allArray;
}

- (NSMutableArray *)dateArray {
    if (!_dateArray) {
        _dateArray = [NSMutableArray array];
    }
    return _dateArray;
}

- (YLBNavigationBarView *)ylbNavigationBarView {
    if (!_ylbNavigationBarView) {
        _ylbNavigationBarView = [YLBNavigationBarView createView];
        _ylbNavigationBarView.titleLabel.text = @"图片&视频";
        [_ylbNavigationBarView.leftButton setTitle:@"返回" forState:UIControlStateNormal];
        [_ylbNavigationBarView.leftButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [_ylbNavigationBarView.leftButton addTarget:self action:@selector(leftButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ylbNavigationBarView;
}

- (YLBPhotoManager *)manager {
    if (!_manager) {
        _manager = [[YLBPhotoManager alloc] init];
    }
    return _manager;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 1;
        _flowLayout.minimumInteritemSpacing = 1;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0.5, 0, 0.5, 0);
        CGFloat itemWidth = (self.view.ylb_width-2) / 2;
        _flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat collectionHeight = self.view.ylb_height - self.ylbNavigationBarView.ylb_maxY;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.ylbNavigationBarView.ylb_maxY, self.view.ylb_width, collectionHeight) collectionViewLayout:self.flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[YLBPhotoViewCell class] forCellWithReuseIdentifier:kYLBPhotoViewCell];
        [_collectionView stopAdjustmentWithScrollView:_collectionView controller:self];
        
    }
    return _collectionView;
}

#pragma mark - 状态栏字体颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

#pragma mark - click
- (void)leftButtonMethod:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - push
- (void)pushPhotoListViewControllerWithAlbumModel:(YLBAlbumModel *)albumModel animated:(BOOL) animated {
    YLBPhotoController *vc = [[YLBPhotoController alloc] init];//展示相册的类
    vc.manager = self.manager;
    vc.title = albumModel.albumName;
    vc.albumModel = albumModel;
    [self.navigationController pushViewController:vc animated:animated];
}

- (void)goPhotoViewController {
    [self.manager preloadData];
    [self startGetAllPhotoModel];
}

#pragma mark - < public >

- (void)startGetAllPhotoModel {
    __weak __typeof(self)weakSelf = self;
    
    self.manager.photoListBlock = ^(NSArray * _Nonnull allList) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.allArray = [NSMutableArray arrayWithArray:allList];
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.collectionView reloadData];
        });
        
    };
    
    dispatch_async(self.manager.loadAssetQueue, ^{
        //这个方法会触发回调photoListBlock
        [self.manager getPhotoListWithAlbumModel:self.manager.cameraRollAlbumModel complete:nil];//获取相册
    });
    
}

#pragma mark - UICollectionViewDelegate
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YLBPhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kYLBPhotoViewCell forIndexPath:indexPath];
    YLBPhotoModel *model = [self.allArray objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allArray.count;
}

@end
