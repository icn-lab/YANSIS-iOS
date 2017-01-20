//
//  PostProcessor.h
//  YANSIS
//
//  Created by 長野雄 on 2014/12/16.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#ifndef YANSIS_PostProcessor_h
#define YANSIS_PostProcessor_h


#import<Foundation/Foundation.h>
#import"Token.h"

@interface PostProcessor : NSObject
-(NSArray *)process:(NSArray *)tokens postProcessInfo:(NSDictionary *)postProcessInfo;
@end
#endif
