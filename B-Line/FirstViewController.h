//
//  FirstViewController.h
//  B-Line
//
//  Created by Gabriel West on 4/15/13.
//  Copyright (c) 2013 Gabriel West. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameViewController.h"


@interface FirstViewController : UIViewController <UITextFieldDelegate>{
    
    IBOutlet UILabel *titleLabel;
    IBOutlet UIButton *startGameButton;
    IBOutlet UITextField *destinationTF;
}

-(IBAction)startGame:(id)sender;

@end
