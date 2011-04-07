//
//  YamlObjCSDKTests.m
//  YamlObjCSDKTests
//
//  Created by Satoshi Konno on 11/03/24.
//  Copyright 2011 Satoshi Konno. All rights reserved.
//

#import "YamlObjCSDKTests.h"
#import "CGYAML.h"

@implementation YamlObjCSDKTests(CyberGarage)

#define CG_YAMLOBJC_TEST_IREPOEDITOR_CSYNTAX \
@"name: C\n" \
@"version: 1.0\n" \
@"extentions:\n" \
@"- c\n" \
@"comments:\n" \
@"- /\\*.*\\*/\n" \
@"- (//.*)$\n" \
@"keywords:\n" \
@"# C89\n" \
@"   - (?:^|[\\t ]+)(void|char|short|int|long|float|double|auto|static|const|signed|unsigned|extern|volatile|register|return|goto|if|else|switch|case|default|break|for|while|do|continue|typedef|struct|enum|union|sizeof)(?:[\\t ]+|$)\n" \
@"# C99\n" \
@"   - (?:^|[\\t ]+)(inline|restrict|_Bool|_Complex|_Imaginary)(?:[\\t ]+|$)\n" 

- (void) testRepoEditorCSyntax 
{
    CGYAML *yaml;
	NSDictionary *yamlMapNode;
	NSArray *yamlSeqNode;
	
    yaml = [[CGYAML alloc] initWithString:CG_YAMLOBJC_TEST_IREPOEDITOR_CSYNTAX];
    NSLog(@"\n%@", yaml);
    
    STAssertTrue([yaml numDocuments] == 1, @"");
    yamlMapNode = [yaml documentRootNodeAtIndex:0];
    
    STAssertTrue([[yamlMapNode objectForKey:@"name"] isEqualToString:@"C"], @"");
    STAssertTrue([[yamlMapNode objectForKey:@"version"] isEqualToString:@"1.0"], @"");
    
    yamlSeqNode = [yamlMapNode objectForKey:@"extentions"];
    STAssertTrue([yamlSeqNode count] == 1, @"");
    STAssertTrue([[yamlSeqNode objectAtIndex:0] isEqualToString:@"c"], @"");

    yamlSeqNode = [yamlMapNode objectForKey:@"comments"];
    STAssertTrue([yamlSeqNode count] == 2, @"");
    STAssertTrue([[yamlSeqNode objectAtIndex:0] isEqualToString:@"/\\*.*\\*/"], @"");
    STAssertTrue([[yamlSeqNode objectAtIndex:1] isEqualToString:@"(//.*)$"], @"");

    yamlSeqNode = [yamlMapNode objectForKey:@"keywords"];
    STAssertTrue([yamlSeqNode count] == 2, @"");
    STAssertTrue([[yamlSeqNode objectAtIndex:0] isEqualToString:@"(?:^|[\\t ]+)(void|char|short|int|long|float|double|auto|static|const|signed|unsigned|extern|volatile|register|return|goto|if|else|switch|case|default|break|for|while|do|continue|typedef|struct|enum|union|sizeof)(?:[\\t ]+|$)"], @"");
    STAssertTrue([[yamlSeqNode objectAtIndex:1] isEqualToString:@"(?:^|[\\t ]+)(inline|restrict|_Bool|_Complex|_Imaginary)(?:[\\t ]+|$)"], @"");

    [yaml release];
}

@end
