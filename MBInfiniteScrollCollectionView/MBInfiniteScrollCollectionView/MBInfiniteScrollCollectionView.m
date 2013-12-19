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

- (void)setContentOffset:(CGPoint)contentOffset
{
    [super setContentOffset:contentOffset];
    [self shiftCellsIfNecessary];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self recenterIfNecessary];
}


#pragma mark -

- (void)shiftCellsIfNecessary
{
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:[self convertPoint:self.center fromView:self.superview]];
    
    if (!indexPath) return;
    if (indexPath.item == _prevCellIndex) return;
    
    _prevCellIndex = indexPath.item;
    MBInfiniteScrollCollectionViewLayout *layout = (MBInfiniteScrollCollectionViewLayout *)self.collectionViewLayout;
    [layout shiftCellsWithCenterCellIndex:indexPath.item];
    [layout invalidateLayout];
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

@end
