//
//  Label.h
//  YANSIS
//
//  Created by 長野雄 on 2017/01/19.
//  Copyright © 2017年 長野雄. All rights reserved.
//

#ifndef YANSIS_Label_h
#define YANSIS_Label_h

#import <Foundation/Foundation.h>
#import "LabelItem.h"

@interface Label : NSObject
-(id)init;
-(void)fromLabel:(NSArray *)label;
-(NSString *)toString;
-(NSString *)toLabelString:(LabelItem *)pre cur:(LabelItem *)cur succ:(LabelItem *)succ;
-(NSString *)phonemeLabel:(NSString *)pre cur:(NSString *)cur succ:(NSString *)succ;
-(NSString *)f0Label:(NSString *)pre cur:(NSString *)cur succ:(NSString *)succ;
-(int)getMoraRate;
-(int)getMoraCount;
-(int)getTotalMoraDuration;
-(int)getTotalDuration;
-(int)getTotalNonMoraDuration;
@end

#endif
