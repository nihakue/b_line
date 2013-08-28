//
//  BLineLoadingView.m
//  B-Line
//
//  Created by Gabriel West on 4/23/13.
//  Copyright (c) 2013 Gabriel West. All rights reserved.
//

#import "BLineLoadingView.h"

@implementation BLineLoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:.2 green:.3 blue:.4 alpha:.7];
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.center.y, self.frame.size.width, 30)];
        label.backgroundColor =[UIColor colorWithWhite:.1 alpha:0];
        label.text = @"Waiting for GPS...";
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        spinner.frame = CGRectMake(self.center.x, 200, 50, 50);
        [self addSubview:spinner];
        [self addSubview:label];
        [spinner startAnimating];
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
