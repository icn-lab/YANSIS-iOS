//
//  RemarkPostProcessor.h
//  YANSIS
//
//  Created by 長野雄 on 2014/12/17.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#ifndef YANSIS_RemarkPostProcessor_h
#define YANSIS_RemarkPostProcessor_h

#import <Foundation/Foundation.h>
#import "PostProcessor.h"
#import "Token.h"

@interface RemarkPostProcessor : PostProcessor
-(NSArray *)process:(NSArray *)tokens postProcessInfo:(NSDictionary *)postProcessInfo;
@end
#endif
