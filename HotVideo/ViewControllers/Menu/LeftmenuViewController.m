//
//  LeftmenuViewController.m
//  HightLearning
//
//  Created by VinhNguyen on 7/15/14.
//  Copyright (c) 2014 Synova. All rights reserved.
//

#import "LeftmenuViewController.h"
#import "NavigationViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface LeftmenuViewController ()

@end

@implementation LeftmenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   
    
    arrMenu =[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Chercher un test",@"title", @"Search.png", @"icon", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"Mes statistiques",@"title", @"Search.png", @"icon", nil],              [NSDictionary dictionaryWithObjectsAndKeys:@"Inscription",@"title", @"Search.png", @"icon", nil],
        [NSDictionary dictionaryWithObjectsAndKeys:@"Le projet High Learning",@"title", @"Search.png", @"icon", nil],
              [NSDictionary dictionaryWithObjectsAndKeys:@"Contact",@"title", @"Search.png", @"icon", nil],
              [NSDictionary dictionaryWithObjectsAndKeys:@"Mentions légales",@"title", @"Search.png", @"icon", nil],
              [NSDictionary dictionaryWithObjectsAndKeys:@"Partager ser facebook",@"title", @"Search.png", @"icon", nil],
              nil];
    
    tblMenu =[[UITableView alloc] initWithFrame:CGRectMake(10, 0, 260, 350)];
    tblMenu.delegate=self;
    tblMenu.dataSource=self;
    tblMenu.backgroundColor =[UIColor clearColor];
    tblMenu.separatorStyle=UITableViewCellSelectionStyleNone;
    tblMenu.scrollEnabled=NO;
    [self.view addSubview:tblMenu];
    
    /*
    if ([tblMenu respondsToSelector:@selector(setSeparatorInset:)]) {
        [tblMenu setSeparatorInset:UIEdgeInsetsZero];
    }
     */

}

#pragma UITableView Delegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if(addiOS7>0 && kScreenHigh > 500)
    //        return 90;
    return 50;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrMenu count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
       return 60;
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    UIImageView *imgView =[[UIImageView alloc] initWithFrame:[headerView bounds]];
    imgView.image =[UIImage imageNamed:@"MenuHeader.png"];
    [headerView addSubview:imgView];
    
    return headerView;
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     static  NSString *MyIdentifier = @"MenuViewIdentifier" ;
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    UIView *vCell = nil;
    UILabel *lblTopTitle;
    UIImageView *ivIcon;
    
    NSDictionary *menuItem =[arrMenu objectAtIndex:indexPath.row];
    
    if(cell==nil)
    {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        UIView *vCell=[[UIView alloc] initWithFrame:CGRectMake(0, 4, 250, 50)];
        cell.backgroundColor=[UIColor clearColor];
        
        vCell.tag = 1;
        if(indexPath.row==0)
        {
           // [vCell setBackgroundColor:colorBackground_highlight];
        }
        else
        {
            [vCell setBackgroundColor:[UIColor clearColor]];
        }
        [cell.contentView addSubview:vCell];
        vCell.layer.cornerRadius=2.0f;
        
        ivIcon =[[UIImageView alloc] initWithFrame:CGRectMake(10, 6, 22, 22)];
        ivIcon.tag=15;
        [vCell addSubview:ivIcon];
        
         //[SynUtility addLabel:vCell andRect:CGRectMake(40, 6, 200, 25) andTitle:[menuItem objectForKey:@"title"] andFont:font_hel_reg(25) andColor:[UIColor whiteColor] andTag:11];
        
    }
    else
    {
        vCell = [cell.contentView viewWithTag:1];
         [vCell setBackgroundColor:[UIColor clearColor]];
    }
    
    if (!vCell) {
        vCell = [cell.contentView viewWithTag:1];
        
        ivIcon =(UIImageView*)[vCell viewWithTag:15];
        
        lblTopTitle =(UILabel*)[vCell viewWithTag:11];
       
    }
    
    ivIcon.image =[UIImage imageNamed:[menuItem objectForKey:@"icon"]];
    lblTopTitle.text =[menuItem objectForKey:@"title"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIView *vcell=[[tblMenu cellForRowAtIndexPath:indexPath] viewWithTag:1];
    [UIView
     transitionWithView:[kApplicationDelegate window]
     duration:0.2
     options:UIViewAnimationOptionTransitionCrossDissolve
     animations:^(void) {
         BOOL oldState = [UIView areAnimationsEnabled];
         [UIView setAnimationsEnabled:NO];
         //[vcell setBackgroundColor:colorBackground_highlight];
         [UIView setAnimationsEnabled:oldState];
     }
     completion:nil];
    
    return YES;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tblMenu reloadData];
    
    
    [self.frostedViewController hideMenuViewController];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
