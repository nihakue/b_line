//
//  BDView.h
//  finWithBlocks
//
//  Created by Gabriel West on 4/17/13.
//  Copyright (c) 2013 Gabriel West. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^drawingblock_t) (CGContextRef, CGRect);

@interface BDView : UIView
- (void)drawWithBlock:(drawingblock_t)blk;

@end
