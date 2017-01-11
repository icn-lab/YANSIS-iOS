//
//  EJExample.h
//  YANSIS
//
//  Created by 長野雄 on 2014/12/24.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#ifndef YANSIS_EJExample_h
#define YANSIS_EJExample_h

#import <Foundation/Foundation.h>

@interface EJExample : NSObject
@property(nonatomic) NSString *nj;
@property(nonatomic) NSString *ej;
-(id)initWithString:(NSString *)nj ej:(NSString *)ej;
-(Boolean)containsNJ:(NSString *)key;
-(Boolean)containsEJ:(NSString *)key;
-(NSString *)NJ;
-(NSString *)EJ;
@end
#endif
