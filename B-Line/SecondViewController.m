//
//  SecondViewController.m
//  B-Line
//
//  Created by Gabriel West on 4/15/13.
//  Copyright (c) 2013 Gabriel West. All rights reserved.
//

#import "SecondViewController.h"
#import "BLDataStore.h"
#import "GameViewController.h"


@interface SecondViewController ()

@end

@implementation SecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Default"]];
        linesTV.delegate = self;
        linesTV.dataSource = SHAREDSTORE;
        linesTV.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (IBAction)loadLinePressed:(id)sender {
    if (selectedLine) {
        GameViewController *gameViewController = [[GameViewController alloc]initWithLine:selectedLine];
        self.view.window.rootViewController = gameViewController;
    }
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate Implementation

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
    BLRunDetailViewController * detail = [[BLRunDetailViewController alloc]initWithLine:((Line*)[SHAREDSTORE.lines objectAtIndex:indexPath.row])];
    [self presentViewController:detail animated:YES completion:nil];

}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedLine = nil;
    loadLineB.enabled = NO;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    loadLineB.enabled = YES;
    selectedLine = [SHAREDSTORE.lines objectAtIndex:indexPath.row];
}
@end
