//
//  Line.m
//  B-Line
//
//  Created by Gabriel West on 4/18/13.
//  Copyright (c) 2013 Gabriel West. All rights reserved.
//

#import "Line.h"

@implementation Line
@synthesize title;

-(id)init{
    self = [super init];
    if (self){
        self.title = @"test";
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self){
        self.title = [aDecoder decodeObjectForKey:@"title"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:title forKey:@"title"];
}

@end
