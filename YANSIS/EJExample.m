//
//  EJExample.m
//  YANSIS
//
//  Created by 長野雄 on 2014/12/24.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#import "EJExample.h"

@implementation EJExample
-(id)initWithString:(id)nj ej:(id)ej{
    if(self=[super init]){
        self.nj = nj;
        self.ej = ej;
    }
    return self;
}

-(Boolean)containsNJ:(NSString *)key{
    return [self.nj containsString:key];
}

-(Boolean)containsEJ:(NSString *)key{
    return [self.ej containsString:key];
}

-(NSString *)NJ{
    return self.nj;
}

-(NSString *)EJ{
    return self.ej;
}

@end
