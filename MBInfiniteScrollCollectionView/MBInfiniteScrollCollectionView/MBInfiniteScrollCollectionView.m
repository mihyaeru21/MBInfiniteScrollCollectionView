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
    BOOL _isInitialized;
}
@end

@implementation MBInfiniteScrollCollectionView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        _isInitialized = NO;
    }
    return self;
}


#pragma mark - override

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // ここでcontentOffsetを指定しないとCollectionViewControllerを使った時に初期座標がずれる
    // initだとダメ
    if (!_isInitialized) {
        MBInfiniteScrollCollectionViewLayout *layout = (MBInfiniteScrollCollectionViewLayout *)self.collectionViewLayout;
        [self setContentOffset:layout.scrollOrigin];
        _isInitialized = YES;
    }
    
    MBInfiniteScrollCollectionViewLayout *layout = (MBInfiniteScrollCollectionViewLayout *)self.collectionViewLayout;
    CGPoint center = [self contentOffset];
    center.x += self.bounds.size.width / 2;
    center.y += self.bounds.size.height / 2;
    NSInteger index = [layout indexOfNearestCenter:center];
    
    [layout shiftCellsIfNecessaryWithIndex:index];
    [layout shiftCellsIfOutOfViewWithIndex:index center:center size:self.bounds.size];
    [layout recenterIfNecessaryWithContentOffset:self.contentOffset];
}

@end
