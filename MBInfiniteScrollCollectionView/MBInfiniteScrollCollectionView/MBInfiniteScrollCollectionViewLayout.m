//
//  MBInfiniteScrollCollectionViewLayout.m
//  MBInfiniteScrollCollectionView
//
//  Created by Mihyaeru on 2013/12/18.
//  Copyright (c) 2013年 Mihyaeru. All rights reserved.
//

#import "MBInfiniteScrollCollectionViewLayout.h"


#pragma mark - attribute

@interface MBInfiniteScrollCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes
@property (nonatomic) NSUInteger mbiscvX;
@property (nonatomic) NSUInteger mbiscvY;
- (void)shiftOrigin:(CGPoint)offset;
@end

@implementation MBInfiniteScrollCollectionViewLayoutAttributes
- (void)shiftOrigin:(CGPoint)offset
{
    CGRect frame = self.frame;
    frame.origin.x += offset.x;
    frame.origin.y += offset.y;
    self.frame = frame;
}
@end


#pragma mark -

@interface MBInfiniteScrollCollectionViewLayout()
{
    CGPoint _scrollOrigin;
}

@property (strong, nonatomic) NSMutableArray *attributes_array;

@end


@implementation MBInfiniteScrollCollectionViewLayout

#pragma mark - override

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _cellSpace = 10.0f;
        _cellSize  = CGSizeMake(100, 100);
        _xnum = 7;
        _ynum = 7;
        _attributes_array = [[NSMutableArray alloc] init];
        
        _scrollOrigin = CGPointMake(2500, 2500);
        for (NSUInteger y = 0; y < self.ynum; y++) {
            NSMutableArray *row = [[NSMutableArray alloc] init];
            for (NSUInteger x = 0; x < self.xnum; x++) {
                CGPoint origin = CGPointMake((self.cellSpace + self.cellSize.width) * x, (self.cellSpace + self.cellSize.height) * y);
                origin.x += _scrollOrigin.x;
                origin.y += _scrollOrigin.y;
                CGRect frame = CGRectMake(origin.x, origin.y, self.cellSize.width, self.cellSize.height);
                MBInfiniteScrollCollectionViewLayoutAttributes *attributes = [MBInfiniteScrollCollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:y*self.xnum+x  inSection:0]];
                attributes.frame = frame;
                attributes.mbiscvX = x;
                attributes.mbiscvY = y;
                [self.attributes_array addObject:attributes];
                [row addObject:attributes];
            }
        }
        [self.collectionView setContentOffset:_scrollOrigin];
        [self shiftUp];
        [self shiftUp];
        [self shiftUp];
        [self shiftDown];
        [self shiftDown];
        [self shiftDown];
        [self shiftLeft];
        [self shiftLeft];
        [self shiftLeft];
        [self shiftRight];
        [self shiftRight];
        [self shiftRight];
    }
    return self;
}

- (void)prepareLayout
{
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(_scrollOrigin.x * 2, _scrollOrigin.y * 2);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSLog(@"layout:k%@", NSStringFromCGRect(rect));
    NSMutableArray *ret_attributes_array = [[NSMutableArray alloc] init];
    
    for (MBInfiniteScrollCollectionViewLayoutAttributes *attributes in self.attributes_array) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            [ret_attributes_array addObject:attributes];
        }
    }
    
    return [NSArray arrayWithArray:ret_attributes_array];
}


#pragma mark -

- (void)shiftLeft
{
    for (MBInfiniteScrollCollectionViewLayoutAttributes *attributes in self.attributes_array) {
        if (attributes.mbiscvX == self.xnum - 1) {
            [attributes shiftOrigin:CGPointMake(-1 * (self.cellSpace + self.cellSize.width) * (self.xnum - 1), 0)];
            attributes.mbiscvX = 0;
        } else {
            [attributes shiftOrigin:CGPointMake(self.cellSpace + self.cellSize.width, 0)];
            attributes.mbiscvX += 1;
        }
    }
}

- (void)shiftRight
{
    for (MBInfiniteScrollCollectionViewLayoutAttributes *attributes in self.attributes_array) {
        if (attributes.mbiscvX == 0) {
            [attributes shiftOrigin:CGPointMake((self.cellSpace + self.cellSize.width) * (self.xnum - 1), 0)];
            attributes.mbiscvX = self.xnum - 1;
        } else {
            [attributes shiftOrigin:CGPointMake(-1 * (self.cellSpace + self.cellSize.width), 0)];
            attributes.mbiscvX += -1;
        }
    }
}

- (void)shiftUp
{
    for (MBInfiniteScrollCollectionViewLayoutAttributes *attributes in self.attributes_array) {
        if (attributes.mbiscvY == self.ynum - 1) {
            [attributes shiftOrigin:CGPointMake(0, -1 * (self.cellSpace + self.cellSize.height) * (self.ynum - 1))];
            attributes.mbiscvY = 0;
        } else {
            [attributes shiftOrigin:CGPointMake(0, self.cellSpace + self.cellSize.height)];
            attributes.mbiscvY += 1;
        }
    }
}

- (void)shiftDown
{
    for (MBInfiniteScrollCollectionViewLayoutAttributes *attributes in self.attributes_array) {
        if (attributes.mbiscvY == 0) {
            [attributes shiftOrigin:CGPointMake(0, (self.cellSpace + self.cellSize.height) * (self.ynum - 1))];
            attributes.mbiscvY = self.ynum - 1;
        } else {
            [attributes shiftOrigin:CGPointMake(0, -1 * (self.cellSpace + self.cellSize.height))];
            attributes.mbiscvY += -1;
        }
    }
}

@end
