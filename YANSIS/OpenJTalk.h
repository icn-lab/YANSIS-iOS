//
//  OpenJTalk.h
//  YANSIS
//
//  Created by 長野雄 on 2017/01/18.
//  Copyright © 2017年 長野雄. All rights reserved.
//

#ifndef YANSIS_OpenJTalk_h
#define YANSIS_OpenJTalk_h

#import <Foundation/Foundation.h>
#import "HTSEngine.h"
#import "Label.h"

#import "mecab.h"
#import "jpcommon.h"
#import "njd.h"
#import "text2mecab.h"
#import "mecab2njd.h"
#import "njd_set_pronunciation.h"
#import "njd_set_digit.h"
#import "njd_set_accent_phrase.h"
#import "njd_set_accent_type.h"
#import "njd_set_unvoiced_vowel.h"
#import "njd_set_long_vowel.h"
#import "njd2jpcommon.h"

@interface OpenJTalk : NSObject
-(id)init;
-(void)loadHTSVoice:(NSString *)filename;
-(void)loadMecabDictionary:(NSString *)directory;
-(void)setMecab:(Mecab *)m;
-(void)setSpeed:(double)ratio;
-(void)enableAudio;
-(void)disableAudio;
-(NSArray *)textAnalysis:(NSString *)text;
-(void)feature2NJD:(NSArray *)array;
-(NSArray *)njd2Label;
-(int)synthesizeFromText:(NSString *)text;
-(int)synthesizeFromLabel:(NSArray *)label;
-(int)synthesizeFromFeature:(NSArray *)feature;
-(int)synthesizeFromTextWithRate:(NSString *)text moraRate:(int)speed;
-(int)synthesizeFromFeatureWithRate:(NSArray *)feature moraRate:(int)speed;
-(NSArray *)getLabelFromText:(NSString *)text;
-(NSArray *)getLabelFromFeature:(NSArray *)text;
-(NSArray *)getLabelWithTimeFromText:(NSString *)text;
-(NSArray *)getLabelWithTimeFromFeature:(NSArray *)feature;
@end

#endif
