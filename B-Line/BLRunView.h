//
//  BLRunView.h
//  B-Line
//
//  Created by Gabriel West on 4/25/13.
//  Copyright (c) 2013 Gabriel West. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineRun.h"
@class LineRun;
@interface BLRunView : UIView

-(id)initWithFrame:(CGRect)frame andLineRun:(LineRun*)lineRun;

@end
