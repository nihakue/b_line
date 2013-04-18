//
//  LineGame.m
//  B-Line
//
//  Created by Gabriel West on 4/18/13.
//  Copyright (c) 2013 Gabriel West. All rights reserved.
//

#import "LineGame.h"


@implementation LineGame
@synthesize activeLine;

-(id)init{
    self = [super init];
    if (self){
        activeLine = [[Line alloc] init];
    }
    return self;
}

-(id)initWithLine:(Line *)line{
    self = [super init];
    if (self){
        
    }
    return self;
}

-(NSString *)lineArchivePath{
    NSArray * documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString * documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingFormat:@"%@.lineFile", activeLine.title];
}

-(BOOL)saveLine{
    NSString *path = [self lineArchivePath];
    return [NSKeyedArchiver archiveRootObject:activeLine toFile:path];
}

@end

