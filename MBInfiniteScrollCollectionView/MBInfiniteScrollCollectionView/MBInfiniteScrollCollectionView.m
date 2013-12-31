//
//  MBInfiniteScrollCollectionView.m
//  MBInfiniteScrollCollectionView
//
//  Created by Mihyaeru on 2013/12/18.
//  Copyright (c) 2013年 Mihyaeru. All rights reserved.
//

#import "MBInfiniteScrollCollectionView.h"
#import "MBInfiniteScrollCollectionViewLayout.h"

@interface MBInfiniteScrollCollectionView ()
{
    NSInteger _prevCellIndex;
}

@end

@implementation MBInfiniteScrollCollectionView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        MBInfiniteScrollCollectionViewLayout *layout = (MBInfiniteScrollCollectionViewLayout *)self.collectionViewLayout;
        [self setContentOffset:layout.scrollOrigin];
        _prevCellIndex = 0;
    }
    return self;
}


#pragma mark - override

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self shiftCellsIfNecessary];
    [self recenterIfNecessary];
}


#pragma mark -

- (void)shiftCellsIfNecessary
{
    NSInteger index = [self indexOfNearestCenter];
    MBInfiniteScrollCollectionViewLayout *layout = (MBInfiniteScrollCollectionViewLayout *)self.collectionViewLayout;
    
    if (index != _prevCellIndex) {
        _prevCellIndex = index;
        [layout shiftCellsWithCenterCellIndex:index];
        [layout invalidateLayout];
    }
    
    
    CGPoint center = [self convertPoint:self.center fromView:self.superview];
    [layout shiftCellsIfOutOfViewWithIndex:index center:center size:self.bounds.size];
}

- (void)recenterIfNecessary
{
    MBInfiniteScrollCollectionViewLayout *layout = (MBInfiniteScrollCollectionViewLayout *)self.collectionViewLayout;
    CGPoint scrollOrigin = layout.scrollOrigin;
    CGPoint scrollOffset;
    scrollOffset.x = scrollOrigin.x - self.contentOffset.x;
    scrollOffset.y = scrollOrigin.y - self.contentOffset.y;
    
    if (fabs(scrollOffset.x) < scrollOrigin.x / 2 && fabs(scrollOffset.y) < scrollOrigin.y / 2)
        return;
        
    [self setContentOffset:scrollOrigin];
    [layout shiftAllCellsOffset:scrollOffset];
    [layout invalidateLayout];
}

// viewの中央に最も近いcellのindexを得る
- (NSInteger)indexOfNearestCenter
{
    CGPoint center = [self convertPoint:self.center fromView:self.superview];
    NSInteger nearestIndex;
    CGFloat minDistance = CGFLOAT_MAX;
    for (NSInteger index = 0; index < [self numberOfItemsInSection:0]; index++) {
        UICollectionViewCell *cell = [self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        CGPoint cellOrigin = cell.center;
        CGFloat distance = sqrt((cellOrigin.x - center.x) * (cellOrigin.x - center.x) + (cellOrigin.y - center.y) * (cellOrigin.y - center.y));
        if (distance < minDistance) {
            minDistance = distance;
            nearestIndex = index;
        }
    }
    return nearestIndex;
}

@end
