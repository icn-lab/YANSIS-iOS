//
//  MToken.h
//  YANSIS
//
//  Created by 長野雄 on 2017/01/20.
//  Copyright © 2017年 長野雄. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MToken : NSObject
-(id)init;
-(void)setFeature:(NSString *)feature;
-(NSString *)getPos;
-(NSString *)getPronunciation;
-(NSString *)getBasicString;
-(NSString *)getCform;
-(NSString *)getReading;
-(NSString *)getSurface;
-(NSString *)getTermInfo;
-(NSString *)getAddInfo;
-(NSString *)getField:(int)index;
-(NSString *)toString;
@end
