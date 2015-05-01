//
//  HomeViewController.h
//  HotVideo
//
//  Created by Vinh Nguyen on 3/28/15.
//  Copyright (c) 2015 Vinh Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collection;

@end
