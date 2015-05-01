//
//  HomeViewController.m
//  HotVideo
//
//  Created by Vinh Nguyen on 3/28/15.
//  Copyright (c) 2015 Vinh Nguyen. All rights reserved.
//

#import "HomeViewController.h"
#import "HeaderCollectionReusableView.h"
#import "HorizontalScrollCell.h"
#import "AFNetworking.h"
#import "PlayerViewController.h"
#import "HeaderView.h"

@interface HomeViewController ()<HorizontalScrollCellDelegate>{
    NSArray *images;
    NSArray *_arrItems;
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //[self prepareImages];
    
    [self setUpCollection];
    
    [self.collection registerClass:[HeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderCollectionReusableView"];

    [self loadAPI];
    
    [self addHeaderView];
    
}

- (void) addHeaderView{
    HeaderView *headerView = [HeaderView new];
    [self.view addSubview:headerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareImages
{
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    for(int i = 0; i < _arrItems.count; i++)
    {
        //[tmp addObject:[UIImage imageNamed:[NSString stringWithFormat:@"img%i.jpg", i]]];
        NSString *imageURL = [[[[[_arrItems objectAtIndex:i] objectForKey:@"snippet"] objectForKey:@"thumbnails"] objectForKey:@"default"] objectForKey:@"url"];// [[_arrItems objectAtIndex:i]  valueForKeyPath:@"snippet.thumbnails.thumbnails"];
        if(imageURL){
            [tmp addObject:imageURL];
        }
    }
    
    images = [[NSArray alloc]initWithArray:tmp];
}

-(void)setUpCollection
{
    self.collection.delegate = self;
    self.collection.dataSource = self;
    
    UINib *hsCellNib = [UINib nibWithNibName:@"HorizontalScrollCell" bundle:nil];
    [self.collection registerNib:hsCellNib forCellWithReuseIdentifier:@"cvcHsc"];
    
    [self.collection reloadData];
}

#pragma mark - API

- (void) loadAPI{
    
//    "nextPageToken": "CJYBEAA",
//    "prevPageToken": "CGQQAQ",
    
    NSString *sURL = [NSString stringWithFormat:@"%@search?part=snippet&maxResults=%i&key=%@", kBaseURL, kNumberItemCarousel, kAPIKey];
    
    DLog(@"sURL = %@", sURL);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:sURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        if([responseObject objectForKey:@"items"]){
            _arrItems = [responseObject objectForKey:@"items"];
            [self prepareImages];
            [self.collection reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}

#pragma mark - UICollectionView Delegate & Datasource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(collectionView.frame.size.width, 150);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {

        HeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderCollectionReusableView" forIndexPath:indexPath];
        
        headerView.backgroundColor = [UIColor clearColor];
        
        UIImageView *imgBanner = [[UIImageView alloc] initWithFrame:CGRectMake(0, -20, kScreenSize.width, headerView.frame.size.height)];
        imgBanner.image = [UIImage imageNamed:@"youtubevevo.jpg"];
        
        [headerView addSubview:imgBanner];
        
        reusableview = headerView;
    }
    
    return reusableview;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HorizontalScrollCell *hsc =[collectionView dequeueReusableCellWithReuseIdentifier:@"cvcHsc"
                                                                         forIndexPath:indexPath];
    
    //[hsc setBackgroundColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.5f]];
    [hsc setUpCellWithArray:images];
    
    [hsc.scroll setFrame:CGRectMake(hsc.scroll.frame.origin.x, hsc.scroll.frame.origin.y, hsc.frame.size.width, 200)];
    
    hsc.cellDelegate = self;
    
    return hsc;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize retval = CGSizeMake(self.view.frame.size.width, 240);
    
    return retval;
}

-(void)cellSelected
{
    NSLog(@"Selected !!");
    //PlayerViewController *player = [[PlayerViewController alloc] initWithNibName:@"PlayerViewController" bundle:nil];
    //[self.navigationController pushViewController:player animated:YES];
    
    [[kApplicationDelegate navigationController] addPlayer];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
