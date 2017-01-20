//
//  POS.m
//  YANSIS
//
//  Created by 長野雄 on 2014/12/09.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#import "POS.h"

@implementation POS{
    NSArray *posClass;
}

-(id)initWithString:(NSString *)str{
    if(self=[super init]){
        posClass = [str componentsSeparatedByString:@"-"];
    }
    
    return self;
}

-(Boolean)match:(POS *)pos{
    NSUInteger posLength = [posClass count];
    for(NSUInteger i=0;i < posLength;i++){
        NSString *posStrAt_i = posClass[i];
        NSString *pos_posStrAt_i = pos->posClass[i];
        if([posStrAt_i compare:@"*"] == NSOrderedSame ||
           [pos_posStrAt_i compare:@"*"] == NSOrderedSame){
            continue;
        }
        if([posStrAt_i compare:pos_posStrAt_i] != NSOrderedSame){
            return false;
        }
    }
    
    return true;
}

-(NSString *)toString{
    NSMutableString *str = [NSMutableString stringWithString:posClass[0]];
    NSUInteger posLength = [posClass count];
    for(NSUInteger i=1;i < posLength;i++){
        [str appendFormat:@"-%@", posClass[i]];
    }
    
    return str;
}
@end
