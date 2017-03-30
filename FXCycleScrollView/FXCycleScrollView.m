//
//  FXCycleScrollView.m
//  FXCycleScrollView
//
//  Created by 冯笑 on 17/3/20.
//  Copyright © 2017年 冯笑. All rights reserved.
//

#import "FXCycleScrollView.h"
#import "FXCycleScrollViewCell.h"
#import "UIImageView+WebCache.h"



@interface FXCycleScrollView ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic,strong) UIPageControl *pageControl;

@property (nonatomic,strong) NSMutableArray *totalItemGroup;

@property (nonatomic,strong) NSTimer *timer;

@end

@implementation FXCycleScrollView


#pragma mark - system

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)fx_initialize
{
    self.autoScrollTimeInterval = 2.0f;
    self.cycle = YES;
    self.autoCycle = YES;
}



-(void)fx_addSubviews
{
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
}


#pragma mark - init

+(instancetype)fxCycleScrollViewWithFrame:(CGRect)frame imagePathGroup:(NSMutableArray *)imagePathGroup{
    FXCycleScrollView *cycleScrollView = [[self alloc] initWithFrame:frame];
    cycleScrollView.imagePathGroup = imagePathGroup;
    return cycleScrollView;
}

#pragma mark - set

-(void)setCycle:(BOOL)cycle
{
    _cycle = cycle;
    if (self.imagePathGroup.count !=0)
    {
        self.imagePathGroup = self.imagePathGroup;
    }
}


-(void)setAutoCycle:(BOOL)autoCycle
{
    _autoCycle = autoCycle;
    [self invalidateTimer];
    if (_autoCycle) {
        [self setupTimer];
    }
}

-(void)setImagePathGroup:(NSMutableArray *)imagePathGroup
{
    _imagePathGroup = imagePathGroup;
    
    if (self.imagePathGroup.count>1) {
        if (self.cycle) {
            [self.totalItemGroup addObject:_imagePathGroup.lastObject];
            [self.totalItemGroup addObjectsFromArray:_imagePathGroup];
            [self.totalItemGroup addObject:_imagePathGroup.firstObject];
            [self scrollToIndex:1 animated:false];
        }
        else
        {
            self.totalItemGroup = _imagePathGroup;
        }
        [self setAutoCycle:self.autoCycle];
    }
    else
    {
        [self invalidateTimer];
        self.totalItemGroup = _imagePathGroup;
    }
   
    [self setupPageControl];
    [self.collectionView reloadData];
}

#pragma mark - get



-(NSMutableArray *)totalItemGroup
{
    if (!_totalItemGroup) {
        _totalItemGroup = [NSMutableArray new];
    }
    return _totalItemGroup;
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        [_collectionView registerClass:[FXCycleScrollViewCell class] forCellWithReuseIdentifier:@"cell"];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

-(UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.itemSize = self.frame.size;
        _flowLayout.minimumLineSpacing = 0;
    }
    return _flowLayout;
}

#pragma mark - actions

-(void)setupPageControl{
    if (_pageControl)  [_pageControl removeFromSuperview];
    
    CGFloat width = self.imagePathGroup.count*10*1.5;
    CGFloat height = 10.0f;
    CGFloat x = (self.bounds.size.width-width)*0.5;
    CGFloat y = self.bounds.size.height - 10 - 10;
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(x, y, width, height)];
    self.pageControl.numberOfPages = self.imagePathGroup.count;
    self.pageControl.currentPage = [self currentIndex]-1;
    [self addSubview:self.pageControl];
}

-(void)setupTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)autoScroll{
//    [self scrollViewDidEndDecelerating:self.collectionView];
    [self scrollToIndex:([self currentIndex]+1) animated:YES];
}

- (void)scrollToIndex:(long)Index animated:(BOOL)animated
{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:Index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:animated];
}


-(int)currentIndex{
    int index = 0;
    index = (self.collectionView.contentOffset.x+self.flowLayout.itemSize.width*0.5)/self.flowLayout.itemSize.width;
    return index;
}


#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.totalItemGroup.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FXCycleScrollViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if ([self.totalItemGroup[indexPath.row] hasPrefix:@"http"])
    {
        [cell.adImageView sd_setImageWithURL:[NSURL URLWithString:self.totalItemGroup[indexPath.row]] placeholderImage:self.placehoderImage];
    }
    else
    {
        cell.adImageView.image = [UIImage imageNamed:self.totalItemGroup[indexPath.row]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(fxCycleScrollView:didSelectItemAtIndexPath:)])
    {
        [self.delegate fxCycleScrollView:self didSelectItemAtIndexPath:[self currentIndex]];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.imagePathGroup.count) return;
    if (self.cycle) {
        if (self.collectionView.contentOffset.x/self.flowLayout.itemSize.width==0) {
            [self scrollToIndex:(self.totalItemGroup.count-2) animated:false];
        }
        else if (self.collectionView.contentOffset.x/self.flowLayout.itemSize.width==self.totalItemGroup.count-1)
        {
            [self scrollToIndex:1 animated:false];
        }
    }
    self.pageControl.currentPage = [self currentIndex]-1;

}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.autoCycle)
    {
        [self invalidateTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.autoCycle) {
        [self setupTimer];
    }
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.cycle) {
        if (self.collectionView.contentOffset.x/self.flowLayout.itemSize.width==0) {
            [self scrollToIndex:(self.totalItemGroup.count-2) animated:false];
        }
        else if (self.collectionView.contentOffset.x/self.flowLayout.itemSize.width==self.totalItemGroup.count-1)
        {
            [self scrollToIndex:1 animated:false];
        }
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
