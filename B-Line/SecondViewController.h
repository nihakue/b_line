//
//  SecondViewController.h
//  B-Line
//
//  Created by Gabriel West on 4/15/13.
//  Copyright (c) 2013 Gabriel West. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Line.h"
#import "BLRunDetailViewController.h"
#define SHAREDSTORE [BLDataStore sharedStore]

@interface SecondViewController : UIViewController<UITableViewDelegate>{
    
    IBOutlet UIButton *loadLineB;
    IBOutlet UITableView *linesTV;
    
    Line* selectedLine;
}

@end
