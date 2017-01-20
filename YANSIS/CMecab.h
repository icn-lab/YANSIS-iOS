//
//  CMecab.h
//  YANSIS
//
//  Created by 長野雄 on 2017/01/20.
//  Copyright © 2017年 長野雄. All rights reserved.
//
#ifndef YANSIS_CMecab_h
#define YANSIS_CMecab_h

#import <Foundation/Foundation.h>
#import "mecab.h"
#import "text2mecab.h"

@interface CMecab : NSObject
-(id)init;
-(void)loadDictionary:(NSString *)directory;
-(NSArray *)textAnalysis:(NSString *)text;
@end
#endif
