//
//  HorizontalScrollCell.m
//  MoviePicker
//
//  Created by Muratcan Celayir on 28.01.2015.
//  Copyright (c) 2015 Muratcan Celayir. All rights reserved.
//

#import "HorizontalScrollCell.h"
#import "UIImageView+AFNetworking.h"

#define kCaroselWidth   120
#define kCaroselHeight  90
@implementation HorizontalScrollCell

- (void)awakeFromNib {
    // Initialization code
 
}

-(void)setUpCellWithArray:(NSArray *)array
{
    CGFloat xbase = 10;
    CGFloat width = 120;
    int line = 0;
    
    [self.scroll setScrollEnabled:YES];
    [self.scroll setShowsHorizontalScrollIndicator:NO];
    
    int halfN = (int)[array count]/2;
    for(int i = 0; i < halfN; i++)
    {
        NSString *image = [array objectAtIndex:i];
        UIView *custom = [self createCustomViewWithImage: image andLine:line];
        [self.scroll addSubview:custom];
        [custom setFrame:CGRectMake(xbase, 7, kCaroselWidth, kCaroselHeight)];
        xbase += 10 + width;
    }
    
    xbase = 10;
    line = 1;
    
    for(int i = halfN; i < [array count]; i++)
    {
        NSString *image = [array objectAtIndex:i];
        UIView *custom = [self createCustomViewWithImage: image andLine:1];
        [self.scroll addSubview:custom];
        [custom setFrame:CGRectMake(xbase, line*kCaroselHeight + 15, kCaroselWidth, kCaroselHeight)];
        xbase += 10 + width;
    }

    [self.scroll setContentSize:CGSizeMake(xbase, self.scroll.frame.size.height)];
    
    self.scroll.delegate = self;
}

-(UIView *)createCustomViewWithImage:(NSString *)image andLine:(int) line
{
    UIView *custom = [[UIView alloc]initWithFrame:CGRectMake(0, line*kCaroselHeight, kCaroselWidth, kCaroselHeight)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kCaroselWidth, kCaroselHeight)];
    //[imageView setImage:image];
    [imageView setImageWithURL:[NSURL URLWithString:image]];
    
    [custom addSubview:imageView];
    [custom setBackgroundColor:[UIColor whiteColor]];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [custom addGestureRecognizer:singleFingerTap];
    
    return custom;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate

{
    [self containingScrollViewDidEndDragging:scrollView];
    
}

- (void)containingScrollViewDidEndDragging:(UIScrollView *)containingScrollView
{
    CGFloat minOffsetToTriggerRefresh = 25.0f;
    
    NSLog(@"%.2f",containingScrollView.contentOffset.x);
    
    NSLog(@"%.2f",self.scroll.contentSize.width);
    
    if (containingScrollView.contentOffset.x <= -50)
    {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(-50 , 7, kCaroselWidth, kCaroselHeight)];
        
        UIActivityIndicatorView *acc = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        acc.hidesWhenStopped = YES;
        [view addSubview:acc];
        
        [acc setFrame:CGRectMake(view.center.x - 25, view.center.y - 25, 50, 50)];
        
        [view setBackgroundColor:[UIColor clearColor]];
        
        [self.scroll addSubview:view];
        
        [acc startAnimating];
        
        [UIView animateWithDuration: 0.3
         
                              delay: 0.0
         
                            options: UIViewAnimationOptionCurveEaseOut
         
                         animations:^{
                             
                             [containingScrollView setContentInset:UIEdgeInsetsMake(0, kCaroselWidth, 0, 0)];
                             
                         }
                         completion:nil];
        //[containingScrollView setContentInset:UIEdgeInsetsMake(0, 100, 0, 0)];
        
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"Started");
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                //Do whatever you want.
                
                NSLog(@"Refreshing");
                
               [NSThread sleepForTimeInterval:3.0];
                
                NSLog(@"refresh end");
                
                [UIView animateWithDuration: 0.3
                
                                      delay: 0.0
                
                                    options: UIViewAnimationOptionCurveEaseIn
                
                                 animations:^{
                
                                     [containingScrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
                
                                 }
                                                completion:nil];
            });
            
        });
        
    }
}

//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
   // NSLog(@"clicked");
    
   // UIView *selectedView = (UIView *)recognizer.view;
    
    if([_cellDelegate respondsToSelector:@selector(cellSelected)])
        [_cellDelegate cellSelected];
    
    //Do stuff here...
}

@end
