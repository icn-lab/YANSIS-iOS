//
//  CSVAnalyzer.m
//  YANSIS
//
//  Created by 長野雄 on 2014/12/09.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#import "CSVAnalyzer.h"

static const int AFTER_COMMA = 0;
static const int IN_RAW_ITEM = 1;
static const int IN_QUOTED_ITEM = 2;

@implementation CSVAnalyzer{
    int status;
    NSMutableArray *res;
    NSMutableString *buf;
}

- (id)init{
    if(self = [super init]){
        status = AFTER_COMMA;
        res = nil;
        buf = nil;
    }

    return self;
}

- (NSArray *)split:(NSString *)line flags:(Boolean)removeTrailingEmptyFields{
    unichar COMMA = L',';
    unichar QUOTE = L'\"';
    int len = (int)[line length];

    if(res == nil){
        res = [[NSMutableArray alloc] init];
    }
    if(buf == NULL){
        buf = [[NSMutableString alloc] init];
    }
    
    for(int i=0;i < len;i++){
        unichar c = [line characterAtIndex:i];
        switch (status) {
            case IN_RAW_ITEM:
                if(c == COMMA){
                    [res addObject:[[NSString alloc] initWithString:buf]];
                    [buf setString:@""];
                    status = AFTER_COMMA;
                }
                else{
                    NSString *cStr = [[NSString alloc] initWithCharacters:&c length:1];
                    [buf appendString: cStr];
                }
                break;
            case IN_QUOTED_ITEM:
                if(c == QUOTE){
                    if(i == len-1){
                        status = IN_RAW_ITEM;
                    }
                    else{
                        unichar cc = [line characterAtIndex:i+1];
                        if(cc == COMMA){
                            status = IN_RAW_ITEM;
                        }
                        else if(cc == QUOTE){
                            i++;
                            NSString *cStr = [[NSString alloc] initWithCharacters:&c length:1];
                            [buf appendString: cStr];
                        }
                        else{
                            NSLog(@"Ill-formatted CSV:%@", line);
                            exit(1);
                        }
                    }
                }
                else{
                    NSString *cStr = [[NSString alloc] initWithCharacters:&c length:1];
                    [buf appendString: cStr];
                }
                break;
            case AFTER_COMMA:
                if(c == QUOTE){
                    status = IN_QUOTED_ITEM;
                }
                else if (c == COMMA){
                    [res addObject:@""];
                }
                else{
                    status = IN_RAW_ITEM;
                    NSString *cStr = [[NSString alloc] initWithCharacters:&c length:1];
                    [buf appendString: cStr];
                }
                break;
        }
    }
    
    if(status == IN_QUOTED_ITEM){
        [NSException raise:@"ContinuationException" format:@"In Quoted Item"];
    }
    [res addObject:[[NSString alloc] initWithString:buf]];
    buf = nil;
    
    NSUInteger arraySize = [res count];
    if(arraySize == 0){
        return [[NSMutableArray alloc] init];
    }
    if(removeTrailingEmptyFields){
        while(arraySize > 0 && [res[arraySize-1] length] == 0){
            arraySize--;
        }
        if(arraySize == 0){
            return [[NSMutableArray alloc] init];
        }
    }
    
    NSArray *returnArray = [NSArray arrayWithArray:res];
    [res removeAllObjects];
    status = AFTER_COMMA;

    return returnArray;
}

@end