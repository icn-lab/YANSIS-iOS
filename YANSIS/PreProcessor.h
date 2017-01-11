//
//  PreProcessor.h
//  YANSIS
//
//  Created by 長野雄 on 2014/12/17.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#ifndef YANSIS_PreProcessor_h
#define YANSIS_PreProcessor_h

#import<Foundation/Foundation.h>

@interface PreProcessor : NSObject
-(NSString *)process:(NSString *)input postProcessInfo:(NSDictionary *)postProcessInfo;
@end
#endif
