//
//  CToken.m
//  YANSIS
//
//  Created by 長野雄 on 2014/12/09.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#import"CToken.h"

@implementation CToken
const long _SIZE = 16;
+(long)SIZE{
    return _SIZE;
}

-(id)init{
    if(self=[super init]){
        self.rcAttr2 = 0;
        self.rcAttr1 = 0;
        self.lcAttr  = 0;
        self.posid   = 0;
        self.length  = 0;
        self.cost    = 0;
        self.posID   = 0;
    }
    return self;
}
/*
-(void)read:(FileAccessor *)fa{
    self.rcAttr2 = [fa readShort];
    self.rcAttr1 = [fa readShort];
    self.lcAttr  = [fa readShort];
    self.posid   = [fa readShort];
    self.length  = [fa readShort];
    self.cost    = [fa readShort];
    self.posID   = [fa readInt];
}
*/
-(void)read:(DataAccessor *)fa{
    self.rcAttr2 = [fa readShort];
    self.rcAttr1 = [fa readShort];
    self.lcAttr  = [fa readShort];
    self.posid   = [fa readShort];
    self.length  = [fa readShort];
    self.cost    = [fa readShort];
    self.posID   = [fa readInt];
}

@end