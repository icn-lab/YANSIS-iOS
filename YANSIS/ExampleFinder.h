//
//  ExampleFinder.h
//  YANSIS
//
//  Created by 長野雄 on 2014/12/24.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#ifndef YANSIS_ExampleFinder_h
#define YANSIS_ExampleFinder_h

#import<Foundation/Foundation.h>
#import"EJExample.h"
#import"CSVAnalyzer.h"
#import"StringAccessor.h"

@interface ExampleFinder : NSObject
@property(nonatomic) NSArray *examples;
-(id)initWithString:(NSString *)filename encode:(NSStringEncoding)encoding;
-(NSMutableArray *)grepNJ:(NSString *)key;
@end

#endif
