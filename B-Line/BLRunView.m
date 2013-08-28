//
//  BLRunView.m
//  B-Line
//
//  Created by Gabriel West on 4/25/13.
//  Copyright (c) 2013 Gabriel West. All rights reserved.
//

#import "BLRunView.h"

@implementation BLRunView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Default"]];
        
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame andLineRun:(LineRun *)lineRun
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Default"]];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, frame.size.width)];
        title.text = lineRun.runnerName;
        [self addSubview:title];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
