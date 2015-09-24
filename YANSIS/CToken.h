//
//  CToken.h
//  YANSIS
//
//  Created by 長野雄 on 2014/12/09.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#ifndef YANSIS_CToken_h
#define YANSIS_CToken_h

#import <Foundation/Foundation.h>
#import "DataAccessor.h"
#import "FileAccessor.h"

@interface CToken : NSObject
extern const long _SIZE;
@property(nonatomic) short rcAttr2;
@property(nonatomic) short rcAttr1;
@property(nonatomic) short lcAttr;
@property(nonatomic) short posid;
@property(nonatomic) short length;
@property(nonatomic) short cost;
@property(nonatomic) int   posID;
+(long)SIZE;
//-(void)read:(FileAccessor *)fa;
-(void)read:(DataAccessor *)fa;
@end

#endif
