//
//  CGYAML.m
//  YamlEditor
//
//  Created by Satoshi Konno on 11/02/02.
//  Copyright 2009 Satoshi Konno. All rights reserved.
//

#import "CGYAML.h"
#include <yaml.h>

#define CGYAML_ERROR_DOMAIN @"CGYAML"
#define CGYAML_ERROR_LINE_KEY @"line"
#define CGYAML_ERROR_MESSAGE_KEY @"message"
#define CGYAML_ERROR_CONTEXT_KEY @"context"

@interface CGStack : NSObject {
    
}
+ (id)stack;
- (id)init;
- (BOOL)isEmpty;
- (id)peekObject;
- (id)popObject;
- (void)pushObject:(id)object;
@end

@interface CGYAML ()
- (BOOL)parse:(NSError **)error;
- (NSArray *)documentNodesAtIndex:(NSUInteger)index;
@property(retain) NSMutableArray *yamlDocuments;
@property(retain) NSError *error;
@property(assign) yaml_parser_t libyamlParser;
@property(assign) yaml_emitter_t libyamlEmitter;
@property(assign) CGStack *parserStack;
@end

@implementation CGYAML

@synthesize yamlDocuments;
@synthesize error;
@synthesize libyamlParser;
@synthesize libyamlEmitter;
@synthesize parserStack;

- (id)init
{
	if ((self = [super init])) {
		yaml_parser_initialize(&libyamlParser);
		yaml_emitter_initialize(&libyamlEmitter);
	}
	return self;
}

-(void)dealloc
{
	[super dealloc];
	
	yaml_parser_delete(&libyamlParser);
	yaml_emitter_delete(&libyamlEmitter);
}

- (id)initWithString:(NSString *)yamlString;
{
	if ((self = [self init])) {
		[self parseWithString:yamlString error:nil];
	}
	return self;
}

- (id)initWithPath:(NSString *)yamlPath;
{
	if ((self = [self init])) {
		[self parseWithPath:yamlPath error:nil];
	}
	return self;
}

- (id)initWithData:(NSData *)yamlData
{
	if ((self = [self init])) {
        [self parseWithData:yamlData error:nil];
	}
	return self;
}

- (id)initWithURL:(NSURL *)yamlURL;
{
	if ((self = [self init])) {
        [self parseWithURL:yamlURL error:nil];
	}
	return self;
}

- (BOOL)parseWithString:(NSString *)yamlString error:(NSError **)errorRet
{
	if (yamlString == nil || [yamlString length] <= 0)
		return NO;
	
	const char *aUTF8String = [yamlString UTF8String];
	yaml_parser_set_input_string(&libyamlParser, (const unsigned char *)aUTF8String, strlen((char *)aUTF8String));
	
	return [self parse:errorRet];
}

- (BOOL)parseWithPath:(NSString *)yamlPath  error:(NSError **)errorRet
{
	FILE *fp = fopen([yamlPath UTF8String], "rb");
	if (!fp)
		return NO;
	
	yaml_parser_set_input_file(&libyamlParser, fp);
	
	return [self parse:errorRet];
}

- (BOOL)parseWithData:(NSData *)yamlData  error:(NSError **)errorRet
{
    NSString *yamlString = [[[NSString alloc] initWithData:yamlData encoding:NSUTF8StringEncoding] autorelease];
    return [self parseWithString:yamlString error:errorRet];
}

- (BOOL)parseWithURL:(NSURL *)yamlURL  error:(NSError **)errorRet
{
    NSData *urlData = [NSData dataWithContentsOfURL:yamlURL];
    if (urlData == nil) {
        NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"Invalid URL", CGYAML_ERROR_MESSAGE_KEY, 
                                   nil];
        [self setError:[NSError errorWithDomain:CGYAML_ERROR_DOMAIN code:YAML_READER_ERROR userInfo:errorDict]];
        if (errorRet != nil)
            *errorRet = [self error];
        return NO;
    }
    NSString *yamlString= [[[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding] autorelease];
    return [self parseWithString:yamlString error:errorRet];
}

- (BOOL)parse:(NSError **)errorRet
{
	BOOL isLibyamlStreamEndEvent = NO;
	
	[self setYamlDocuments:[NSMutableArray array]];
	[self setParserStack:[CGStack stack]];
	[self setError:nil];
	
	while (!isLibyamlStreamEndEvent) {
		
		yaml_event_t libyamlEvent;
		if (!yaml_parser_parse(&libyamlParser, &libyamlEvent)) {
			[self setYamlDocuments:nil];
            NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [NSString stringWithFormat:@"%d", libyamlParser.problem_mark.line], CGYAML_ERROR_LINE_KEY, 
                                       ((libyamlParser.problem) ? [NSString stringWithUTF8String:libyamlParser.problem] : @""), CGYAML_ERROR_MESSAGE_KEY, 
                                       ((libyamlParser.context) ? [NSString stringWithUTF8String:libyamlParser.context] : @""), CGYAML_ERROR_CONTEXT_KEY, 
                                       nil];
            [self setError:[NSError errorWithDomain:CGYAML_ERROR_DOMAIN code:libyamlParser.error userInfo:errorDict]];
			yaml_event_delete(&libyamlEvent);
			break;
		}
        
		switch (libyamlEvent.type) {
		case YAML_NO_EVENT: /* An empty event */
			{
				//NSLog(@"YAML_NO_EVENT");
			}
			break;
		case YAML_STREAM_START_EVENT: /* A STREAM-START event */
			{
				//NSLog(@"YAML_STREAM_START_EVENT");
			}
			break;
		case YAML_STREAM_END_EVENT: /* A STREAM-END event */
			{
				//NSLog(@"YAML_STREAM_END_EVENT");
				isLibyamlStreamEndEvent = YES;
			}
			break;
		case YAML_DOCUMENT_START_EVENT: /* A DOCUMENT-START event */
			{
				//NSLog(@"YAML_DOCUMENT_START_EVENT");
				NSMutableArray *document = [NSMutableArray array];
				[[self yamlDocuments] addObject:document];
				[[self parserStack] pushObject:document];
			}
			break;
		case YAML_DOCUMENT_END_EVENT: /* A DOCUMENT-END event */
			{
				//NSLog(@"YAML_DOCUMENT_END_EVENT");
				[[self parserStack] popObject];
			}
			break;
		case YAML_ALIAS_EVENT: /* An ALIAS event */
			{
				//NSLog(@"YAML_ALIAS_EVENT");
			}
			break;
		case YAML_SCALAR_EVENT: /* A SCALAR event */
			{
				NSString *scalarValue = [NSString stringWithUTF8String:(const char *)libyamlEvent.data.scalar.value];
				//NSLog(@"YAML_SCALAR_EVENT : %@", scalarValue);
				id lastParserObject = [[self parserStack] peekObject];
				if ([lastParserObject isKindOfClass:[NSMutableArray class]]) {
					NSMutableArray *document = [[self parserStack] peekObject];
					NSString *listValue = scalarValue;
					[document addObject:listValue];
				} else if ([lastParserObject isKindOfClass:[NSMutableDictionary class]]) { /* Key name */
					NSString *keyName = scalarValue;
					[[self parserStack] pushObject:keyName];
				} else if ([lastParserObject isKindOfClass:[NSString class]]) { /* Key value */
					NSString *keyName = [[self parserStack] popObject];
					NSString *keyValue = scalarValue;
					NSMutableDictionary *dictionary = [[self parserStack] peekObject];
					[dictionary setObject:keyValue forKey:keyName];
				}
			}
			break;
		case YAML_SEQUENCE_START_EVENT: /* A SEQUENCE-START event */
			{
				//NSLog(@"YAML_SEQUENCE_START_EVENT");
				NSMutableArray *newSequence = [NSMutableArray array];
				id lastParserObject = [[self parserStack] peekObject];
				if ([lastParserObject isKindOfClass:[NSMutableArray class]]) {
					[lastParserObject addObject:newSequence];
				} else if ([lastParserObject isKindOfClass:[NSString class]]) {
					NSString *keyName = [[self parserStack] popObject];
					NSMutableDictionary *dictionary = [[self parserStack] peekObject];
					[dictionary setObject:newSequence forKey:keyName];
				}
				[[self parserStack] pushObject:newSequence];
			}
			break;
		case YAML_SEQUENCE_END_EVENT: /* A SEQUENCE-END event */
			{
				//NSLog(@"YAML_SEQUENCE_END_EVENT");
				[[self parserStack] popObject];
			}
			break;
		case YAML_MAPPING_START_EVENT: /* A MAPPING-START event */
			{
				//NSLog(@"YAML_MAPPING_START_EVENT");
				NSMutableDictionary *newDictionary = [NSMutableDictionary dictionary];
				id lastParserObject = [[self parserStack] peekObject];
				if ([lastParserObject isKindOfClass:[NSMutableArray class]]) {
					[lastParserObject addObject:newDictionary];
				} else if ([lastParserObject isKindOfClass:[NSString class]]) { /* Key value */
					NSString *keyName = [[self parserStack] popObject];
					NSMutableDictionary *dictionary = [[self parserStack] peekObject];
					[dictionary setObject:newDictionary forKey:keyName];
				}
				[[self parserStack] pushObject:newDictionary];
			}
			break;
		case YAML_MAPPING_END_EVENT: /*  A MAPPING-END event */
			{
				//NSLog(@"YAML_MAPPING_END_EVENT");
				[[self parserStack] popObject];
			}
			break;
		default:
			{
			}
			break;
		}
		
		yaml_event_delete(&libyamlEvent);
		
	}
	
	[self setParserStack:nil];
    
    if (errorRet != nil)
        *errorRet = [self error];
    
	return ([self error] == nil) ? YES : NO;
}

- (void)writeWithString:(NSString *)yamlString
{
	/*
	FILE *output = fopen("...", "wb");
	
	yaml_emitter_set_output_file(&emitter, output);
	
	void *ext = ...;
	int write_handler(void *ext, char *buffer, int size) {
		return error ? 0 : 1;
	}
	
	yaml_emitter_set_output(&emitter, write_handler, ext);
	
	yaml_stream_start_event_initialize(&event, YAML_UTF8_ENCODING);
	if (!yaml_emitter_emit(&emitter, &event))
		goto error;
	
	yaml_stream_end_event_initialize(&event);
	if (!yaml_emitter_emit(&emitter, &event))
		goto error;
	
	yaml_emitter_delete(&emitter);
	
	return 1;
	 */
}

- (NSString *)indentString:(int)indent
{
	NSMutableString *indentString = [NSMutableString string];
	for (int n=0; n<indent; n++)
		[indentString appendString:@"    "];
	return indentString;
}

- (void)description:(id)anObject indent:(int)indent buffer:(NSMutableString *)buffer
{
	if ([anObject isYAMLScalarNode]) {
		[buffer appendFormat:@"%@%@", [self indentString:indent], anObject];
		return;
	}

	if ([anObject isYAMLSequenceNode]) {
		for (id object in anObject) {
            [buffer appendFormat:@"%@- ", [self indentString:indent]];
            if ([object isYAMLScalarNode]) {
                [buffer appendFormat:@"%@\n", object];
                continue;
            }
            [buffer appendString:@"\n"];
            [self description:object indent:(indent +1) buffer:buffer];
        }
		return;
	}
	
	if ([anObject isYAMLMappingNode]) {
		for (id key in [[anObject allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]) {
			id value = [anObject objectForKey:key];
            if ([value isYAMLScalarNode]) {
                [buffer appendFormat:@"%@%@: %@\n", [self indentString:indent], key, value];
				continue;
			}
            [buffer appendFormat:@"%@%@:\n", [self indentString:indent], key];
			[self description:value indent:(indent+1) buffer:buffer];
		}				
		return;
	}
}

- (NSString *)description
{
    NSMutableString *descrBuffer = [NSMutableString string];
	for (id rootNode in [self documents]) {
        [descrBuffer appendString:@"---\n"];
        [self description:rootNode indent:0 buffer:descrBuffer];
        if ([[self documents] count] == 1)
        	break;
        [descrBuffer appendString:@"...\n"];
	}
    return descrBuffer;
}

- (NSUInteger)numDocuments
{
    return [[self yamlDocuments] count];
}

- (NSArray *)documentNodesAtIndex:(NSUInteger)aIndex;
{
    if (([[self yamlDocuments] count] - 1) < aIndex)
        return [NSArray array];
    return [[self yamlDocuments] objectAtIndex:aIndex];
}

- (NSArray *)documents;
{
    NSMutableArray *rootNodes = [NSMutableArray array];
    for (int n=0; n<[self numDocuments]; n++)
        [rootNodes addObject:[self documentRootNodeAtIndex:n]];
    return rootNodes;
}

- (id)documentRootNodeAtIndex:(NSUInteger)index
{
    NSArray *documentNodes =[self documentNodesAtIndex:index];
    if ([documentNodes count] <= 0)
        return nil;
    return [documentNodes objectAtIndex:0];
}

static inline BOOL IsSequenceComponent(NSString *str)
{
	//return NSEqualRanges([str rangeOfString:@"\[([0-9]+)\]" options:NSRegularExpressionSearch], NSMakeRange(0, [str length]));
	return ([str hasPrefix:@"["] && [str hasSuffix:@"]"]);
}

static inline NSInteger GetSequenceNumber(NSString *str)
{
	return [[str substringWithRange:NSMakeRange(1,([str length]-2))] integerValue];
}

- (id)objectForYPath:(NSString *)ypath
{
	if (ypath == nil || [ypath length] <= 0)
		return nil;
	
	NSMutableArray *ypathComponets = [NSMutableArray array];
    for (NSString *ypathComponent in [ypath componentsSeparatedByString:@"/"]) {
        if ([ypathComponent length] <= 0)
            continue;
        [ypathComponets addObject:ypathComponent];
    }
    
    NSInteger documentIndex = 0;
    if ([ypath hasPrefix:@"/"] == NO) {
        NSString *documentIndexString = [ypathComponets objectAtIndex:0];
        if (IsSequenceComponent(documentIndexString) == NO)
            return nil;
        documentIndex = GetSequenceNumber(documentIndexString);
        [ypathComponets removeObjectAtIndex:0];
    }
        
    id ypathObject = [self documentRootNodeAtIndex:documentIndex];
    for (NSString *ypathComponent in ypathComponets) {
        if (IsSequenceComponent(ypathComponent)) {
            if ([ypathObject isYAMLSequenceNode] == NO)
                return nil;
            NSInteger componentIndex = GetSequenceNumber(ypathComponent);
            if (([ypathObject count]-1) < componentIndex)
                return nil;
            ypathObject = [ypathObject objectAtIndex:componentIndex];
        }
        else {
            if ([ypathObject isYAMLMappingNode] == NO)
                return nil;
            ypathObject = [ypathObject objectForKey:ypathComponent];
        }
    }
    
    return ypathObject;
}

- (NSString *)valueForYPath:(NSString *)ypath
{
    id ypathObj = [self objectForYPath:ypath];
    if ([ypathObj isKindOfClass:[NSString class]] == NO)
        return nil;
    return ypathObj;
}

- (BOOL)writeToFile:(NSString *)path
{
	NSString *descString = [self description];
	NSData *descData = [descString dataUsingEncoding:NSUTF8StringEncoding];
    if (descData == nil)
    	return NO;
    return [descData writeToFile:path atomically:YES];
}

@end

@implementation NSObject(CGYAML)

- (BOOL) isYAMLSequenceNode;
{
	return [self isKindOfClass:[NSMutableArray class]];
}

- (BOOL) isYAMLScalarNode
{
	return [self isKindOfClass:[NSString class]];
}

- (BOOL) isYAMLMappingNode
{
	return [self isKindOfClass:[NSMutableDictionary class]];
}

@end

@interface CGStack()
@property(retain) NSMutableArray *objects;
@end

@implementation CGStack
@synthesize objects;

+ (id)stack
{
	return [[[CGStack alloc] init] autorelease];
}

- (id)init
{
	if ((self = [super init])) {
		[self setObjects:[NSMutableArray array]];
	}
	return self;
}

- (BOOL)isEmpty
{
	NSUInteger objectsCount = 0;
	@synchronized([self objects]) {
		objectsCount = [[self objects] count];
	}
	return (objectsCount <= 0) ? YES : NO;
}

- (id)peekObject
{
	id lastObject = nil;
	@synchronized([self objects]) {
		lastObject = [[self objects] objectAtIndex:0];
	}
	return [[lastObject retain] autorelease];
}

- (id)popObject
{
	id lastObject = nil;
	@synchronized([self objects]) {
		lastObject = [[self objects] objectAtIndex:0];
		[[self objects] removeObjectAtIndex:0];
	}
	return [[lastObject retain] autorelease];
}

- (void)pushObject:(id)object
{
	@synchronized([self objects]) {
		[[self objects] insertObject:object atIndex:0];
	}
}

@end
