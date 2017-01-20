//
//  StringTagger.m
//  YANSIS
//
//  Created by 長野雄 on 2014/12/17.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#import "StringTagger.h"

@implementation StringTagger{
    NSDictionary *hash;
    Viterbi *viterbi;
    NSString *DEFAULT_CONFIG;
    NSString *unknownPos;
    NSMutableArray *preProcessorList;
    NSMutableArray *postProcessorList;
    NSXMLParser *xmlParser;
    NSString *_qName, *_string;
    NSArray *xmlKey;
    NSMutableDictionary *xmlHash;
}

-(id)init{
    if(self = [super init]){
        hash = [[NSMutableDictionary alloc] init];
        viterbi = nil;
        self.token = nil;
        self.cnt   = 0;
        DEFAULT_CONFIG=@"conf/sen.xml";
        unknownPos = nil;
        
        preProcessorList = [[NSMutableArray alloc] init];
        postProcessorList = [[NSMutableArray alloc] init];
        
        self.tokenFile = nil;
        self.doubleArrayFile = nil;
        self.posInfoFile = nil;
        self.connectFile = nil;
        self.charset = 0;
        
        xmlKey = [NSArray arrayWithObjects:@"connection-cost", @"double-array-trie", @"token", @"pos-info", @"charset", @"unknown-pos", nil];
    }
    
    return self;
}

-(id)initWithConfig:(NSString *)config path:(NSString *)path{
    if(self=[self init]){
        NSLog(@"StringTagger init: config:%@ path:%@", config, path);
        [self readConfig:config path:path];
        Tokenizer *tokenizer = [[JapaneseTokenizer alloc] initWithFiles:self.tokenFile doubleArrayFile:self.doubleArrayFile posInfoFile:self.posInfoFile connectFile:self.connectFile charset:self.charset];
        
        viterbi = [[Viterbi alloc] initWithTokenizer:tokenizer];
    }
    
    return self;
}

-(NSArray *)analyze:(NSString *)input{
    NSMutableDictionary *postProcessInfo = [[NSMutableDictionary alloc] init];
    input = [self doPreProcess:input postProcessInfo:postProcessInfo];
    
    int len = 0;
    Node *node = [viterbi analyze:input].next;
    Node *iter = node;
    
    if(node == nil)
        return nil;
    
    while (iter.next != nil){
        len++;
        iter = iter.next;
    }
    
    NSMutableArray *token = [[NSMutableArray alloc] initWithCapacity:len];
    
    int i = 0;
    while(node.next != nil){
        token[i] = [[Token alloc] initWithNode:node];
        
        if([token[i] getPos] == nil){
            [token[i] setPos:unknownPos];
        }
        i++;
        node = node.next;
    }
    NSLog(@"node search done");
    self.cnt = 0;
    
    NSArray *tokens = [[NSArray alloc] initWithArray:token];
    self.token = [self doPostProcess:tokens postProcessInfo:postProcessInfo];
    
    return self.token;
}

-(Token *)next{
    if(self.token == nil && self.cnt == (int)[self.token count])
        return nil;
    
    return self.token[self.cnt++];
}

-(Boolean)hasNext{
    if(self.token == nil && self.cnt == (int)[self.token count])
        return false;
    
    return true;
}

-(void)readConfig:(NSString *)config path:(NSString *)path{
    NSString *_config = [NSString stringWithFormat:@"%@/%@", path, config];
    NSURL *url = [NSURL fileURLWithPath:_config];
    
    xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [xmlParser setDelegate:self];
    [xmlParser setShouldProcessNamespaces:YES];
    [xmlParser setShouldReportNamespacePrefixes:YES];
    [xmlParser setShouldResolveExternalEntities:YES];

    //xmlParser.delegate = self;
    xmlHash = [[NSMutableDictionary alloc] init];
        
    [xmlParser parse];
    
    self.tokenFile       = [NSString stringWithFormat:@"%@/%@", path,[xmlHash objectForKey:@"token"]];
    self.doubleArrayFile = [NSString stringWithFormat:@"%@/%@", path,[xmlHash objectForKey:@"double-array-trie"]];
    self.posInfoFile     = [NSString stringWithFormat:@"%@/%@", path,[xmlHash objectForKey:@"pos-info"]];
    self.connectFile     = [NSString stringWithFormat:@"%@/%@", path,[xmlHash objectForKey:@"connection-cost"]];
    
    NSLog(@"token:%@", self.tokenFile);
    NSLog(@"doubleArray:%@", self.doubleArrayFile);
    NSLog(@"posInfo:%@", self.posInfoFile);
    NSLog(@"connect:%@", self.connectFile);
    
    NSString *charsetStr =[xmlHash objectForKey:@"charset"];
    NSLog(@"charset:%@", charsetStr);
    
    if([charsetStr compare:@"euc-jp"] == NSOrderedSame || [charsetStr compare:@"EUC-JP"] == NSOrderedSame){
        self.charset = NSJapaneseEUCStringEncoding;
        NSLog(@"charset set to EUC-JP");
    }
    else{
        self.charset = NSUTF8StringEncoding;
    }

    unknownPos = [xmlHash objectForKey:@"unknown-pos"];
}

-(void)parserDidStartDocument:(NSXMLParser *)parser{
    NSLog(@"parse xml");
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSLog(@"Error occured");
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attribute{
    
    Boolean keyFound = false;
    for(NSString *str in xmlKey){
        if([qName compare:str] == NSOrderedSame){
            keyFound = true;
            break;
        }
    }
    if(keyFound){
        _qName = qName;
    }
    //NSLog(@"element=%@, namespace=%@, qualifiedName:%@, attributes:%@", elementName, namespaceURI, qName, attribute);
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    _qName = nil;
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if(_qName != nil){
        [xmlHash setObject:string forKey:_qName];
    }
}

-(void)parserDidEndDocument:(NSXMLParser *)parser{
    NSLog(@"parse finished");
}

-(void)addPostProcessor:(PostProcessor *)processor{
    [postProcessorList addObject:processor];
}

-(void)addPreProcessor:(PreProcessor *)processor{
    [preProcessorList addObject:processor];
}

-(NSString *)doPreProcess:(NSString *)input postProcessInfo:(NSDictionary *)postProcessInfo{
    NSString *inp = input;
    for(PreProcessor *p in preProcessorList){
        [p process:inp postProcessInfo:postProcessInfo];
    }
    return inp;
}

-(NSArray *)doPostProcess:(NSArray *)tokens postProcessInfo:(NSDictionary *)postProcessInfo{
    NSArray *newTokens = [[NSArray alloc] initWithArray:tokens];
    for(PostProcessor *p in postProcessorList){
        newTokens = [p process:newTokens postProcessInfo:postProcessInfo];
    }
    
    return newTokens;
}
@end
