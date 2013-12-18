//
//  MBInfiniteScrollCollectionViewLayout.m
//  MBInfiniteScrollCollectionView
//
//  Created by Mihyaeru on 2013/12/18.
//  Copyright (c) 2013年 Mihyaeru. All rights reserved.
//

#import "MBInfiniteScrollCollectionViewLayout.h"

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
        _cellSize  = CGSizeMake(150, 150);
        _xnum = 6;
        _ynum = 6;
        _attributes_array = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)prepareLayout
{
    for (NSUInteger y = 0; y < self.ynum; y++) {
        for (NSUInteger x = 0; x < self.xnum; x++) {
            CGPoint origin = CGPointMake((self.cellSpace + self.cellSize.width) * x, (self.cellSpace + self.cellSize.height) * y);
            CGRect frame = CGRectMake(origin.x, origin.y, self.cellSize.width, self.cellSize.height);
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:y*self.xnum+x  inSection:0]];
            attributes.frame = frame;
            [self.attributes_array addObject:attributes];
            
        }
    }
}

- (CGSize)collectionViewContentSize
{
    UICollectionViewLayoutAttributes *lastAttributes = self.attributes_array.lastObject;
    CGRect frame = lastAttributes.frame;
    CGSize size = CGSizeMake(frame.origin.x + frame.size.width, frame.origin.y + frame.size.height);
    NSLog(@"content size:%@", NSStringFromCGSize(size));
    return size;
//    return CGSizeMake(5000, 5000);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSLog(@"layout:k%@", NSStringFromCGRect(rect));
    NSMutableArray *ret_attributes_array = [[NSMutableArray alloc] init];
    
    for (UICollectionViewLayoutAttributes *attributes in self.attributes_array) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            [ret_attributes_array addObject:attributes];
        }
    }
    
    return [NSArray arrayWithArray:ret_attributes_array];
}


#pragma mark -

@end
