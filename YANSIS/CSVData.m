//
//  CSVData.m
//  YANSIS
//
//  Created by 長野雄 on 2014/12/10.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#import "CSVData.h"

@implementation CSVData {
    NSMutableArray *elements;
}

-(id)init{
    if(self = [super init]){
        elements = [[NSMutableArray alloc] init];
    }

    return self;
}

-(void)append:(NSString *)element{
    [elements addObject:element];
}

-(void)insert:(int)index element:(NSString *)element{
    [elements insertObject:element atIndex:index];
}

-(void)remove:(int)index{
    [elements removeObjectAtIndex:index];
}

-(void)set:(int)index element:(NSString *)element{
    [elements replaceObjectAtIndex:index withObject:element];
}

-(void)clear{
    [elements removeAllObjects];
}

-(NSString *)toString{
    NSMutableString *buf = [[NSMutableString alloc] init];
    
    NSEnumerator *enumerator = [elements objectEnumerator];
    NSString *object;
    
    Boolean isFirst = true;
    while(object = [enumerator nextObject]){
        NSString *element = [self enquote:object];
        if(isFirst){
            isFirst = false;
        }
        else{
            [buf appendString:@","];
        }
        [buf appendString:element];
    }
    
    return [NSString stringWithString:buf];
}

-(NSString *)enquote:(NSString *)element{
    int length = (int)[element length];
    if(length == 0){
        return element;
    }
    if([element rangeOfString:@"\""].location == NSNotFound && [element rangeOfString:@","].location == NSNotFound){
        return element;
    }
    
    NSMutableString *buf = [[NSMutableString alloc] init];
    [buf appendString:@"\""];
    for(int i=0;i < length;i++){
        unichar ch = [element characterAtIndex:i];
        if(ch == L'\"'){
            [buf appendString:@"\""];
        }
        NSString *chStr = [[NSString alloc] initWithCharacters:&ch length:1];
        [buf appendString:chStr];
    }
    [buf appendString:@"\""];
    
    return [NSString stringWithString:buf];
}

@end