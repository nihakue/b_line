//
//  LineGame.h
//  B-Line
//
//  Created by Gabriel West on 4/18/13.
//  Copyright (c) 2013 Gabriel West. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Line.h"

@interface LineGame : NSObject

-(id)initWithLine:(Line *)line;

-(NSString*)lineArchivePath;
-(BOOL)saveLine;


@property(strong, nonatomic) Line *activeLine;
@end
