//
//  BDView.m
//  finWithBlocks
//
//  Created by Gabriel West on 4/17/13.
//  Copyright (c) 2013 Gabriel West. All rights reserved.
//

#import "BDView.h"
@interface BDView ()
@property (nonatomic, copy) drawingblock_t drawingBlock;
@end

@implementation BDView


-(void) drawWithBlock:(drawingblock_t)blk{
    self.drawingBlock = blk;
    [self setNeedsDisplay];
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (self.drawingBlock){
        self.drawingBlock(UIGraphicsGetCurrentContext(), rect);
    }
}
@end
