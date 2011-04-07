//
//  CGYAML.h
//  YamlEditor
//
//  Created by Satoshi Konno on 11/02/02.
//  Copyright 2009 Satoshi Konno. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CGYAML : NSObject {

}
- (id)init;
- (id)initWithString:(NSString *)yamlString;
- (id)initWithPath:(NSString *)yamlPath;
- (id)initWithData:(NSData *)yamlData;
- (id)initWithURL:(NSURL *)yamlURL;

- (BOOL)parseWithString:(NSString *)yamlString error:(NSError **)error;
- (BOOL)parseWithPath:(NSString *)yamlPath  error:(NSError **)error;
- (BOOL)parseWithData:(NSData *)yamlData  error:(NSError **)error;
- (BOOL)parseWithURL:(NSURL *)yamlURL  error:(NSError **)error;

- (NSError *)error;

- (NSUInteger)numDocuments;
- (NSArray *)documents;
- (id)documentRootNodeAtIndex:(NSUInteger)index;
- (id)objectForYPath:(NSString *)yPath;
- (NSString *)valueForYPath:(NSString *)yPath;
@end

@interface NSObject(CGYAML)
- (BOOL) isYAMLSequenceNode;
- (BOOL) isYAMLScalarNode;
- (BOOL) isYAMLMappingNode;
@end
