//
//  BLRunDetailViewController.m
//  B-Line
//
//  Created by Gabriel West on 4/26/13.
//  Copyright (c) 2013 Gabriel West. All rights reserved.
//

#import "BLRunDetailViewController.h"

@interface BLRunDetailViewController ()

@end

@implementation BLRunDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithLine:(Line *)lineToLoad{
    self = [super initWithNibName:nil bundle:nil];
    if (self){
        UINavigationBar * navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        navBar.delegate = self;
        navBar.translucent = YES;
        UINavigationItem * back = [[UINavigationItem alloc]initWithTitle:@"Runs"];
        [back setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(goBack)]];
        [navBar pushNavigationItem:back animated:NO];
        
        
        
        [self.view addSubview:navBar];
        loadedLine = lineToLoad;
        loadedRuns = [[NSMutableArray alloc]init];
        for (LineRun* run in SHAREDSTORE.lineRuns) {
            if (run.line.baseLength == loadedLine.baseLength) {
                [loadedRuns addObject:run];
            }
        }

    }
    return self;
}
-(void)goBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate/Datasource implementation

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *unused = @"UNUSED";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:unused];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:unused];
    }
    cell.textLabel.text = ((LineRun*)[loadedRuns objectAtIndex:indexPath.row]).runnerName;
    cell.accessoryType = UITableViewCellSelectionStyleBlue;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [loadedRuns count];
    }
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"accesorytapaptpt");
}
-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    LineRun* run = [loadedRuns objectAtIndex:indexPath.row];
    NSDateFormatter  *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM:DD:hh:mm"];
    finishedL.text = @"No";
    endTimeL.text = [formatter stringFromDate:run.endTime];
    startTimeL.text = [formatter stringFromDate:run.startTime];
    scoreL.text = [NSString stringWithFormat:@"%.2f", run.score];
    double runTime = [run getRunTimeInSeconds];
    durationL.text = [NSString stringWithFormat:@"%.2f", runTime];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    LineRun* run = [loadedRuns objectAtIndex:indexPath.row];
    NSDateFormatter  *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM:DD:hh:mm"];
    finishedL.text = @"No";
    endTimeL.text = [formatter stringFromDate:run.endTime];
    startTimeL.text = [formatter stringFromDate:run.startTime];
    scoreL.text = [NSString stringWithFormat:@"%.2f", run.score];
    double runTime = [run getRunTimeInSeconds];
    durationL.text = [NSString stringWithFormat:@"%.2f", runTime];
}
@end
