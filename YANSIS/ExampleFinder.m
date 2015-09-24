//
//  ExampleFinder.m
//  YANSIS
//
//  Created by 長野雄 on 2014/12/24.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#import "ExampleFinder.h"
#define BUFSIZE 1024

@implementation ExampleFinder
-(id)initWithString:(NSString *)filename encode:(NSStringEncoding)encode{
    if(self = [super init]){
        NSLog(@"ExampleFinder: %@", filename);
        NSMutableArray *__examples = [[NSMutableArray alloc] init];
        StringAccessor *sfa = [[StringAccessor alloc] initWithFile:filename encoding:encode];
        CSVAnalyzer *sp = [[CSVAnalyzer alloc] init];
        
        while([sfa hasMoreData]){
            @autoreleasepool {
                NSString *lineStr = [sfa readLine];
                //NSLog(@"line:%@", lineStr);
                NSArray *x;
                @try{
                    x = [sp split:lineStr flags:true];
                }@catch(NSException *e){
                    if([e.name compare:@"ContinuationException"] == NSOrderedSame)
                        continue;
                }
                if([x count] < 2){
                    NSLog(@"CSVAnalyzer split error");
                    exit(1);
                }
                //NSLog(@"0:%@, 1:%@", x[0], x[1]);
                EJExample *eje = [[EJExample alloc] initWithString:x[0] ej:x[1]];
                [__examples addObject:eje];
            }
        }
        self.examples = [[NSArray alloc] initWithArray:__examples];
    }
    return self;
}

-(NSMutableArray *)grepNJ:(NSString *)key{
    NSMutableArray *res = [[NSMutableArray alloc]init];
    for(EJExample *eje in self.examples)
        if([eje containsNJ:key])
            [res addObject:eje];
    return res;
}
@end