//
//  WordPropertyFactory.h
//  YANSIS
//
//  Created by 長野雄 on 2014/12/22.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#ifndef YANSIS_WordPropertyFactory_h
#define YANSIS_WordPropertyFactory_h

#import <Foundation/Foundation.h>
#import "StringTagger.h"
#import "VocabAnalyzer.h"
#import "WordProperty.h"
#import "EJConfig.h"

@interface WordPropertyFactory : NSObject
-(id)initWithConfig:(EJConfig *)conf;
-(NSArray *)analyzeText:(NSString *)text;
@end
#endif
