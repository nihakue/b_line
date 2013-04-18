//
//  Line.h
//  B-Line
//
//  Created by Gabriel West on 4/18/13.
//  Copyright (c) 2013 Gabriel West. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Line : NSObject <NSCoding>


-(void)encodeWithCoder:(NSCoder *)aCoder;

@property (strong, nonatomic) NSString * title;
@end
