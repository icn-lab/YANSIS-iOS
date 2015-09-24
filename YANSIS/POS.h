//
//  POS.h
//  YANSIS
//
//  Created by 長野雄 on 2014/12/09.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#ifndef YANSIS_POS_h
#define YANSIS_POS_h

#import <Foundation/Foundation.h>

@interface POS : NSObject
-(id)initWithString:(NSString *)str;
-(Boolean)match:(POS *)pos;
-(NSString *)toString;
@end


#endif
