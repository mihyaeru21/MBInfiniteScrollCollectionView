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
        self.showsHorizontalScrollIndicator = YES;
        self.showsVerticalScrollIndicator = YES;
        MBInfiniteScrollCollectionViewLayout *layout = (MBInfiniteScrollCollectionViewLayout *)self.collectionViewLayout;
        [self setContentOffset:layout.scrollOrigin];
        _prevCellIndex = 0;
    }
    return self;
}

- (void)setContentOffset:(CGPoint)contentOffset
{
    [super setContentOffset:contentOffset];
    NSIndexPath *ip = [self indexPathForItemAtPoint:[self convertPoint:self.center fromView:self.superview]];
    
    if (!ip) return;
    if (ip.item == _prevCellIndex) return;
    
    NSLog(@"center: %@", NSStringFromCGPoint(self.center));
    NSLog(@"indexPath: %@", ip);

    _prevCellIndex = ip.item;
    [(MBInfiniteScrollCollectionViewLayout *)self.collectionViewLayout shiftCellsWithCenterCellIndex:ip.item];
    [self.collectionViewLayout invalidateLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // セルをずらしてスクロールをさせる
}

@end
