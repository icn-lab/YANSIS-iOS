//
//  Token.h
//  YANSIS
//
//  Created by 長野雄 on 2014/12/15.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#ifndef YANSIS_Token_h
#define YANSIS_Token_h

#import<Foundation/Foundation.h>
#import"Node.h"
@interface Token : NSObject
-(id)init;
-(id)initWithNode:(Node *)n;
-(int)_start;
-(void)setStart:(int)s;
-(int)end;
-(int)length;
-(void)setLength:(int)l;
-(NSString *)getPos;
-(void)setPos:(NSString *)_pos;
-(NSString *)getBasicString;
-(void)setBasicString:(NSString *)_basic;
-(NSString *)getCform;
-(void)setCform:(NSString *)_cform;
-(NSString *)getReading;
-(void)setReading:(NSString *)_read;
-(NSString *)getPronunciation;
-(void)setPronunciation:(NSString *)_pronunciation;
-(NSString *)getSurface;
-(void)setSurface:(NSString *)_surface;
-(int)getCost;
-(void)setCost:(int)_cost;
-(NSString *)getAddInfo;
-(void)setAddInfo:(NSString *)_addInfo;
-(NSString *)getTermInfo;
-(void)setTermInfo:(NSString *)_termInfo;
-(NSString *)toString;
@end

#endif
