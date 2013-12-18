//
//  MBViewController.h
//  MBInfiniteScrollCollectionViewDemo
//
//  Created by Mihyaeru on 2013/12/18.
//  Copyright (c) 2013年 Mihyaeru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBInfiniteScrollCollectionView.h>

@interface MBViewController : UIViewController
<UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet MBInfiniteScrollCollectionView *collectionView;

@end
