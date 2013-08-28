//
//  FirstViewController.m
//  B-Line
//
//  Created by Gabriel West on 4/15/13.
//  Copyright (c) 2013 Gabriel West. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
        
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    destinationTF.delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    titleLabel.font = [UIFont fontWithName:@"Pacifico" size:50];
    titleLabel.textColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Default"]];
    
	// Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - keyBoard stuff

-(void)keyboardWillShow:(NSNotification*)notification{
    
    NSValue *keyboardEndFrameValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardEndFrame = [keyboardEndFrameValue CGRectValue];
    
    // When we move the textField up, we want to match the animation duration and curve that
    // the keyboard displays. So we get those values out now
    
    NSNumber *animationDurationNumber = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = [animationDurationNumber doubleValue];
    
    NSNumber *animationCurveNumber = [[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = [animationCurveNumber intValue];
    
    // UIView's block-based animation methods anticipate not a UIVieAnimationCurve but a UIViewAnimationOptions.
    // We shift it according to the docs to get this curve.
    
    UIViewAnimationOptions animationOptions = animationCurve << 16;
    
    
    // Now we set up our animation block.
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:animationOptions
                     animations:^{
                         // Now we just animate the text field up an amount according to the keyboard's height,
                         // as we mentioned above.
                         CGRect textFieldFrame = destinationTF.frame;
                         CGRect titleLabellFrame = titleLabel.frame;
                         textFieldFrame.origin.y = keyboardEndFrame.origin.y - textFieldFrame.size.height - 30;
                         titleLabellFrame.origin.y = textFieldFrame.origin.y - titleLabellFrame.size.height;
                         destinationTF.frame = textFieldFrame;
                         titleLabel.frame = titleLabellFrame;
                     }
                     completion:^(BOOL finished) {}];
}

-(void)keyboardWillHide:(NSNotification*)notification{
    NSNumber *animationDurationNumber = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = [animationDurationNumber doubleValue];
    
    NSNumber *animationCurveNumber = [[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = [animationCurveNumber intValue];
    UIViewAnimationOptions animationOptions = animationCurve << 16;
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:animationOptions
                     animations:^{
                         destinationTF.frame = CGRectMake(12, 263, 296, 30);
                         titleLabel.frame = CGRectMake(111, 165, 165, 90);
                     }
                     completion:^(BOOL finished) {}];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


-(IBAction)startGame:(id)sender{
    GameViewController *gameViewController = [[GameViewController alloc]initWithDestination:destinationTF.text];
    self.view.window.rootViewController = gameViewController;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
