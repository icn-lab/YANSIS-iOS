//
//  CSVParser.m
//  YANSIS
//
//  Created by 長野雄 on 2014/12/10.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#import "CSVParser.h"

#define BUFSIZE 1024

@implementation CSVParser{
    StringAccessor *sa;
    NSString *lineString;
    unichar QUOTE;
    unichar COMMA;
    int pos;
}

-(id)initWithString:(NSString *)string{
    if(self = [super init]){
        QUOTE=L'\"';
        COMMA=L',';
        pos = 0;
        sa = [[StringAccessor alloc] initWithString:string];
    }
    return self;
}

-(Boolean)nextRow{
    lineString = [sa readLine];
    //NSLog(@"lineString:%@", lineString);
    if(lineString != nil)
        return true;
    else
        return false;
}

-(NSString *)nextToken{
    int start;
    Boolean quote  = false;
    // Boolean escape = false;
    
    if(lineString == nil || pos >= [lineString length]){
        return nil;
    }
    
    if([lineString characterAtIndex:pos] == QUOTE){
        quote = true;
        pos++;
    }
    start = pos;
    
    while(pos < [lineString length]){
    @autoreleasepool {
        if([lineString characterAtIndex:pos] == COMMA && !quote){
            NSString *substr = [lineString substringWithRange:NSMakeRange(start, pos-start)];
            pos++;
            return substr;
        }
        else if([lineString characterAtIndex:pos] == QUOTE && quote){
            if(pos+1 < [lineString length] && [lineString characterAtIndex:pos+1] == QUOTE){
                pos += 2;
                continue;
            }
            NSString *retstr = [lineString substringWithRange:NSMakeRange(start, pos-start)];
            [retstr stringByReplacingOccurrencesOfString:@"\"\"" withString:@"\""];
            pos += 2;
            return retstr;
        }
        pos++;
    }
    }
    NSString *retstr = [lineString substringWithRange:NSMakeRange(start, pos-start)];
    
    return retstr;
}

-(NSArray *)nextTokens{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    NSString *input;
    
    if([self nextRow] == false){
        return nil;
    }
    
    while((input = [self nextToken]) != nil){
        [list addObject:input];
    }

    return [NSArray arrayWithArray:list];
}
@end
