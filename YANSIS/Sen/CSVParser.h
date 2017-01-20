//
//  CSVParser.h
//  YANSIS
//
//  Created by 長野雄 on 2014/12/10.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#ifndef YANSIS_CSVParser_h
#define YANSIS_CSVParser_h

#import<Foundation/Foundation.h>
#import"StringAccessor.h"

@interface CSVParser : NSObject
-(id)initWithString:(NSString *)string;
-(Boolean)nextRow;
-(NSString *)nextToken;
-(NSArray *)nextTokens;
@end

#endif


