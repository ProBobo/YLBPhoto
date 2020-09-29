//
//  YLBPhotoPreviewViewController.m
//  Pods-YLBPhoto_Example
//
//  Created by yulibo on 2020/9/29.
//

#import "YLBPhotoPreviewViewController.h"
#import "YLBPhotoPreviewViewCell.h"
#import <YLBCommon/YLBCommon.h>
#import <YLBProUI/YLBNavigationBarView.h>

@interface YLBPhotoPreviewViewController ()<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>

@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (assign, nonatomic) BOOL orientationDidChange;

@property(nonatomic, strong) YLBNavigationBarView *ylbNavigationBarView;

@end

static NSString * const kYLBPhotoPreviewViewCell = @"kYLBPhotoPreviewViewCell";

@implementation YLBPhotoPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blackColor;
    [self setupSubviews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    YLBPhotoModel *model = self.modelArray[self.currentModelIndex];
    YLBPhotoPreviewViewCell *cell = (YLBPhotoPreviewViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
    [cell requestHDImage:model];
}

- (void)setupSubviews {
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.ylbNavigationBarView];
    
    self.orientationDidChange = YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!CGRectEqualToRect(self.view.frame, [UIScreen mainScreen].bounds)) {
        self.view.frame = [UIScreen mainScreen].bounds;
    }
    if (self.orientationDidChange) {
        self.orientationDidChange = NO;
        CGFloat itemMargin = 0;
        [self.collectionView setContentOffset:CGPointMake(self.currentModelIndex * (self.view.ylb_width + itemMargin), 0)];
    }
}

#pragma mark - 初始化
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

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
//        _flowLayout.sectionInset = UIEdgeInsetsMake(0.5, 0, 0.5, 0);
        _flowLayout.itemSize = CGSizeMake(self.view.ylb_width, self.view.ylb_height);
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat collectionY = 0;//self.ylbNavigationBarView.ylb_maxY;
        CGFloat collectionHeight = self.view.ylb_height;// - self.ylbNavigationBarView.ylb_maxY;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, collectionY, self.view.ylb_width, collectionHeight) collectionViewLayout:self.flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = UIColor.blackColor;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[YLBPhotoPreviewViewCell class] forCellWithReuseIdentifier:kYLBPhotoPreviewViewCell];
        _collectionView.pagingEnabled = YES;
        [_collectionView stopAdjustmentWithScrollView:_collectionView controller:self];
        
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YLBPhotoPreviewViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kYLBPhotoPreviewViewCell forIndexPath:indexPath];
    YLBPhotoModel *model = [self.modelArray objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.ylbNavigationBarView.hidden = !self.ylbNavigationBarView.hidden;
}

#pragma mark - click
- (void)leftButtonMethod:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
