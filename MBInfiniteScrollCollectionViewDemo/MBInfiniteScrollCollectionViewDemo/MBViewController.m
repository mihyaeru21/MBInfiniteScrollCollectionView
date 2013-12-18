//
//  MBViewController.m
//  MBInfiniteScrollCollectionViewDemo
//
//  Created by Mihyaeru on 2013/12/18.
//  Copyright (c) 2013年 Mihyaeru. All rights reserved.
//

#import "MBViewController.h"

@interface MBViewController ()
@property (strong, nonatomic) NSArray *colors;
@end

@implementation MBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // 適当にサンプルセルを用意する
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    srand(2);
    for (NSInteger i = 0; i < 36; i++) {
//    for (NSInteger i = 0; i < 9; i++) {
        [colors addObject:[UIColor colorWithRed:rand()%256/255.0f green:rand()%256/255.0f blue:rand()%256/255.0f alpha:1]];
    }
    self.colors = colors;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - collection view

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.colors.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = self.colors[indexPath.item];
    
    return cell;
}


@end
