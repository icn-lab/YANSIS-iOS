//
//  CSVAnalyzer.h
//  YANSIS
//
//  Created by 長野雄 on 2014/12/09.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#ifndef YANSIS_CSVAnalyzer_h
#define YANSIS_CSVAnalyzer_h

#import <Foundation/Foundation.h>

@interface CSVAnalyzer : NSObject
-(id)init;
-(NSArray *)split:(NSString *)line flags:(Boolean)removeTrailingEmptyFields;
@end


#endif
