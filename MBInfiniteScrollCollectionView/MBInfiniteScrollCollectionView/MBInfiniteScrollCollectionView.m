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
    }
    return self;
}


#pragma mark - override

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    MBInfiniteScrollCollectionViewLayout *layout = (MBInfiniteScrollCollectionViewLayout *)self.collectionViewLayout;
    CGPoint center = [self convertPoint:self.center fromView:self.superview];
    NSInteger index = [layout indexOfNearestCenter:center];
    
    [layout shiftCellsIfNecessaryWithIndex:index];
    [layout shiftCellsIfOutOfViewWithIndex:index center:center size:self.bounds.size];
    [layout recenterIfNecessaryWithContentOffset:self.contentOffset];
}

@end
