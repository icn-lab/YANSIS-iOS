//
//  StringTagger.h
//  YANSIS
//
//  Created by 長野雄 on 2014/12/17.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#ifndef YANSIS_StringTagger_h
#define YANSIS_StringTagger_h

#import<Foundation/Foundation.h>
#import"PostProcessor.h"
#import"PreProcessor.h"
#import"Viterbi.h"
#import"JapaneseTokenizer.h"
#import"EJConfig.h"

@interface StringTagger : NSObject<NSXMLParserDelegate>
@property(nonatomic) NSArray *token;
@property(nonatomic) int cnt;
@property(nonatomic) NSString *tokenFile;
@property(nonatomic) NSString *doubleArrayFile;
@property(nonatomic) NSString *posInfoFile;
@property(nonatomic) NSString *connectFile;
@property(nonatomic) NSStringEncoding charset;
-(id)init;
-(id)initWithConfig:(NSString *)config path:(NSString *)path;
-(NSArray *)analyze:(NSString *)input;
-(Token *)next;
-(Boolean)hasNext;
-(void)readConfig:(NSString *)config path:(NSString *)path;
// for NSXMLParser
-(void)parserDidStartDocument:(NSXMLParser *)parser;
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError;
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;
-(void)parserDidEndDocument:(NSXMLParser *)parser;
//
-(void)addPostProcessor:(PostProcessor *)processor;
-(void)addPreProcessor:(PreProcessor *)processor;
-(NSString *)doPreProcess:(NSString *)input postProcessInfo:(NSDictionary *)postProcessInfo;
-(NSArray *)doPostProcess:(NSArray *)tokens postProcessInfo:(NSDictionary *)postProcessInfo;
@end
#endif
