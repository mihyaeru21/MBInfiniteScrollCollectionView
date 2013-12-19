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

@property (strong, nonatomic) NSMutableArray *attributesArray;

@end


@implementation MBInfiniteScrollCollectionViewLayout

#pragma mark - override

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _cellSpace = 10.0f;
        _cellSize  = CGSizeMake(150, 150);
        _xnum = 7;
        _ynum = 7;
        _attributesArray = [[NSMutableArray alloc] init];
        
        _scrollOrigin = CGPointMake(5000, 5000);
        for (NSUInteger y = 0; y < self.ynum; y++) {
            NSMutableArray *row = [[NSMutableArray alloc] init];
            for (NSUInteger x = 0; x < self.xnum; x++) {
                CGPoint origin = CGPointMake((self.cellSpace + self.cellSize.width) * x, (self.cellSpace + self.cellSize.height) * y);
                origin.x += self.scrollOrigin.x;
                origin.y += self.scrollOrigin.y;
                CGRect frame = CGRectMake(origin.x, origin.y, self.cellSize.width, self.cellSize.height);
                MBInfiniteScrollCollectionViewLayoutAttributes *attributes = [MBInfiniteScrollCollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:y*self.xnum+x  inSection:0]];
                attributes.frame = frame;
                attributes.mbiscvX = x;
                attributes.mbiscvY = y;
                [self.attributesArray addObject:attributes];
                [row addObject:attributes];
            }
        }
        [self shiftCellsWithCenterCellIndex:0];
    }
    return self;
}

- (void)prepareLayout
{
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.scrollOrigin.x * 2, self.scrollOrigin.y * 2);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *retAttributesArray = [[NSMutableArray alloc] init];
    
    for (MBInfiniteScrollCollectionViewLayoutAttributes *attributes in self.attributesArray) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            [retAttributesArray addObject:attributes];
        }
    }
    
    return [NSArray arrayWithArray:retAttributesArray];
}


#pragma mark -

- (void)_shiftCellsWithDirection:(NSInteger)direction isx:(BOOL)isx
{
    NSInteger lastIndex = isx ? self.xnum - 1 : self.ynum - 1;
    NSInteger sourceIndex = (direction > 0) ? lastIndex : 0;
    NSInteger targetIndex = (direction > 0) ? 0 : lastIndex;
    
    for (MBInfiniteScrollCollectionViewLayoutAttributes *attributes in self.attributesArray) {
        NSInteger newX, newY;
        if ((isx ? attributes.mbiscvX : attributes.mbiscvY) == sourceIndex) {
            CGPoint offset;
            offset.x = isx ? -direction * self.xnum * (self.cellSpace + self.cellSize.width) : 0;
            offset.y = isx ? 0 : -direction * self.ynum * (self.cellSpace + self.cellSize.height);
            [attributes shiftOrigin:offset];
            newX = isx ? targetIndex : attributes.mbiscvX;
            newY = isx ? attributes.mbiscvY : targetIndex;
        } else {
            newX = isx ? direction + attributes.mbiscvX : attributes.mbiscvX;
            newY = isx ? attributes.mbiscvY : direction + attributes.mbiscvY;
        }
        attributes.mbiscvX = newX;
        attributes.mbiscvY = newY;
    }
}

- (void)shiftCellsWithCenterCellIndex:(NSInteger)centerIndex
{
    MBInfiniteScrollCollectionViewLayoutAttributes *attributes = self.attributesArray[centerIndex];
    NSInteger offsetX = self.xnum / 2 - attributes.mbiscvX;
    NSInteger offsetY = self.ynum / 2 - attributes.mbiscvY;
    
    for (NSInteger i = 0; i < abs(offsetX); i++) {
        [self _shiftCellsWithDirection:offsetX/abs(offsetX) isx:YES];
    }
    for (NSInteger i = 0; i < abs(offsetY); i++) {
        [self _shiftCellsWithDirection:offsetY/abs(offsetY) isx:NO];
    }
}

@end
