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
@property (nonatomic) NSInteger mbiscvX;
@property (nonatomic) NSInteger mbiscvY;
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
    [self _shiftCellsWithDirection:-1 isx:YES];
}

- (void)shiftRight
{
    [self _shiftCellsWithDirection:1 isx:YES];
}

- (void)shiftUp
{
    [self _shiftCellsWithDirection:1 isx:NO];
}

- (void)shiftDown
{
    [self _shiftCellsWithDirection:-1 isx:NO];
}

- (void)_shiftCellsWithDirection:(NSInteger)direction isx:(BOOL)isx
{
    NSInteger lastIndex = isx ? self.xnum - 1 : self.ynum - 1;
    NSInteger sourceIndex = (direction > 0) ? lastIndex : 0;
    NSInteger targetIndex = (direction > 0) ? 0 : lastIndex;
    
    for (MBInfiniteScrollCollectionViewLayoutAttributes *attributes in self.attributes_array) {
        CGPoint offset;
        NSInteger newX, newY;
        if ((isx ? attributes.mbiscvX : attributes.mbiscvY) == sourceIndex) {
            offset.x = isx ? -direction * lastIndex * (self.cellSpace + self.cellSize.width) : 0;
            offset.y = isx ? 0 : -direction * lastIndex * (self.cellSpace + self.cellSize.height);
            newX = isx ? targetIndex : attributes.mbiscvX;
            newY = isx ? attributes.mbiscvX : targetIndex;
        } else {
            offset.x = isx ? direction * (self.cellSpace + self.cellSize.width) : 0;
            offset.y = isx ? 0 : direction * (self.cellSpace + self.cellSize.height);
            attributes.mbiscvY += direction;
            newX = isx ? direction + attributes.mbiscvX : attributes.mbiscvX;
            newY = isx ? attributes.mbiscvX : direction + attributes.mbiscvY;
        }
        [attributes shiftOrigin:offset];
        attributes.mbiscvX = newX;
        attributes.mbiscvY = newY;
    }
}

@end
