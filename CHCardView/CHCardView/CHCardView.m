//
//  CHCardView.m
//  CHCardView
//
//  Created by arnoldxiao on 09/11/2017.
//  Copyright © 2017 arnoldxiao. All rights reserved.
//

#import "CHCardView.h"
#import "CHCardCollectionViewCell.h"

#define CHCardViewLineSpacing 20
#define CHCardViewLeftRightInset 40
#define CHCardViewCardSize CGSizeMake(kScreenWidth - 2 * CHCardViewLeftRightInset, 150)
#define CHCardViewPageControlSize CGSizeMake(kScreenWidth, 10)

@interface CHCardView () <UICollectionViewDataSource, UICollectionViewDelegate> {
    CGFloat _beginDeceleratingOffsetX;
    NSInteger _currentPage;
}

@property (nonatomic, copy) NSArray<UIImage *> *(^dataSourceBlock)(void);

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation CHCardView

- (instancetype)initWithFrame:(CGRect)frame dataSources:(NSArray<UIImage *> *(^)(void))dataSourceBlock {
    if (self = [super initWithFrame:frame]) {
        _dataSourceBlock = [dataSourceBlock copy];
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    [self addSubview:self.collectionView];
    [self.collectionView registerClass:CHCardCollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(CHCardCollectionViewCell.class)];
    [self addSubview:self.pageControl];
}

- (void)layoutSubviews {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    self.pageControl.currentPage = 0;
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataSourceBlock) {
        return self.dataSourceBlock().count;
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CHCardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(CHCardCollectionViewCell.class)
                                                                               forIndexPath:indexPath];
    if (self.dataSourceBlock) {
        [cell refreshCardViewCellWithImage:self.dataSourceBlock()[indexPath.item]];
    }
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"scrollView-contentOffset.x: %f", scrollView.contentOffset.x);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _beginDeceleratingOffsetX = scrollView.contentOffset.x;
    _currentPage = (scrollView.contentOffset.x + kScreenWidth * 0.5) / CHCardViewCardSize.width;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (!self.dataSourceBlock) {
        return;
    }
    
    if (scrollView.contentOffset.x - _beginDeceleratingOffsetX > 50.0f) {
        //  right
        //  bu shi zui hou yi ye
        if (_currentPage < self.dataSourceBlock().count - 1) {
            _currentPage++;
        }
    } else if (scrollView.contentOffset.x - _beginDeceleratingOffsetX < -50.0f) {
        //  left
        //  bu shi di yi ye
        if (_currentPage > 0) {
            _currentPage--;
        }
    }
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    self.pageControl.currentPage = _currentPage;
}

#pragma mark - Lazy Loading
- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumLineSpacing = CHCardViewLineSpacing;
        _layout.itemSize = CHCardViewCardSize;
        _layout.sectionInset = UIEdgeInsetsMake(0, CHCardViewLeftRightInset, 0, CHCardViewLeftRightInset);
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - CHCardViewPageControlSize.height - 5, CHCardViewPageControlSize.width, CHCardViewPageControlSize.height)];
        _pageControl.numberOfPages = self.dataSourceBlock ? self.dataSourceBlock().count : 1;
        _pageControl.hidesForSinglePage = YES;
        _pageControl.highlighted = YES;
        _pageControl.pageIndicatorTintColor = UIColor.grayColor;
        _pageControl.currentPageIndicatorTintColor = UIColor.whiteColor;
    }
    return _pageControl;
}

@end
