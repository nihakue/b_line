//
//  BLRunDetailViewController.h
//  B-Line
//
//  Created by Gabriel West on 4/26/13.
//  Copyright (c) 2013 Gabriel West. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Line.h"
#define SHAREDSTORE [BLDataStore sharedStore]

@interface BLRunDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationBarDelegate>{
    
    IBOutlet UITableView *lineRunsTV;
    Line* loadedLine;
    NSMutableArray * loadedRuns;
    IBOutlet UILabel *finishedL;
    IBOutlet UILabel *startTimeL;
    IBOutlet UILabel *endTimeL;
    IBOutlet UILabel *scoreL;
    IBOutlet UILabel *durationL;
}

-(id)initWithLine:(Line*)lineToLoad;

@end
