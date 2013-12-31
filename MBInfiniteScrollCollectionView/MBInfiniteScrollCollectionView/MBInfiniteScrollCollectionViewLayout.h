//
//  MBInfiniteScrollCollectionViewLayout.h
//  MBInfiniteScrollCollectionView
//
//  Created by Mihyaeru on 2013/12/18.
//  Copyright (c) 2013年 Mihyaeru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBInfiniteScrollCollectionViewLayout : UICollectionViewLayout

@property (nonatomic) CGFloat cellSpace;
@property (nonatomic) CGSize cellSize;
@property (nonatomic) NSInteger xnum;
@property (nonatomic) NSInteger ynum;
@property (nonatomic, readonly) CGPoint scrollOrigin;

- (void)shiftCellsWithCenterCellIndex:(NSInteger)centerIndex;
- (void)shiftAllCellsOffset:(CGPoint)offset;
- (void)shiftCellsIfOutOfViewWithIndex:(NSInteger)index center:(CGPoint)center size:(CGSize)viewSize;

@end
