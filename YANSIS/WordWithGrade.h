//
//  WordWithGrade.h
//  YANSIS
//
//  Created by 長野雄 on 2014/12/16.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#ifndef YANSIS_WordWithGrade_h
#define YANSIS_WordWithGrade_h

#import <Foundation/Foundation.h>
#import "Token.h"

@interface WordWithGrade : NSObject
@property(nonatomic) WordWithGrade *EOS;
@property(nonatomic) NSString *word;
@property(nonatomic) NSString *basicString;
@property(nonatomic) int grade;
@property(nonatomic) NSString *pos;
@property(nonatomic) NSString *reading;
@property(nonatomic) NSString *pronunciation;
@property(nonatomic) NSString *cform;
-(id)init;
-(id)initWithParameters:(NSString *)word basicString:(NSString *)basicString reading:(NSString *)reading pronunciation:(NSString *)pronunciation pos:(NSString *)pos cform:(NSString *)cform grade:(int)grade;
-(id)initWithToken:(Token *)tok grade:(int)grade;
@end
#endif
