//
//  YamlObjCSDKTests.m
//  YamlObjCSDKTests
//
//  Created by Satoshi Konno on 11/03/24.
//  Copyright 2011 Satoshi Konno. All rights reserved.
//

#import "YamlObjCSDKTests.h"
#import "CGYAML.h"
/*
@implementation YamlObjCSDKTests(Wikipedia)

#define CG_YAMLOBJC_TEST_DATA_LIST_001_BLOCK \
@"---\n" \
@"- Casablanca\n" \
@"- Spellbound\n" \
@"- Notorious"

#define CG_YAMLOBJC_TEST_DATA_LIST_001_INLINE @"[Casablanca, Spellbound, Notorious]"

- (void) testList {
    
    CGYAML *yaml;
	NSArray *yamlList;
	
	NSArray *testDataArray = [NSMutableArray arrayWithObjects:
							  CG_YAMLOBJC_TEST_DATA_LIST_001_BLOCK,
							  CG_YAMLOBJC_TEST_DATA_LIST_001_INLINE,
							  nil];
	for (NSString *testData in testDataArray) {
		yaml = [[CGYAML alloc] initWithString:testData];
		yamlList = [yaml nodes];
		STAssertTrue([yamlList count] == 3, testData);
        NSString *value = [yamlList objectAtIndex:0];
		STAssertTrue([[yamlList objectAtIndex:0] isEqualToString:@"Casablanca"], testData);
		STAssertTrue([[yamlList objectAtIndex:1] isEqualToString:@"Spellbound"], testData);
		STAssertTrue([[yamlList objectAtIndex:2] isEqualToString:@"Notorious"], testData);
		NSLog(@"\n%@", yaml);
		[yaml release];
	}
}

#define CG_YAMLOBJC_TEST_DATA_HASH_001_BLOCK \
@"---\n" \
@"name: John Smith\n" \
@"age: 33\n"

#define CG_YAMLOBJC_TEST_DATA_HASH_001_INLINE @"{name: John Smith, age: 33}"

- (void) testHash {
    
    CGYAML *yaml;
	NSDictionary *yamlHash;
	
	NSArray *testDataArray = [NSMutableArray arrayWithObjects:
							  CG_YAMLOBJC_TEST_DATA_HASH_001_BLOCK,
							  CG_YAMLOBJC_TEST_DATA_HASH_001_INLINE,
							  nil];
    
	for (NSString *testData in testDataArray) {
		yaml = [[CGYAML alloc] initWithString:testData];
		STAssertTrue([yamlMapNode count] == 1, testData);
		//STAssertTrue([[yamlMapNode objectAtIndex:0] isKindOfClass:[NSMutableDictionary class]], testData);
		yamlHash = [yamlMapNode objectAtIndex:0];
		STAssertTrue([[yamlHash allKeys] count] == 2, testData);
		STAssertTrue([[yamlHash objectForKey:@"name"] isEqualToString:@"John Smith"], testData);
		STAssertTrue([[yamlHash objectForKey:@"age"] isEqualToString:@"33"], testData);
		NSLog(@"\n%@", yaml);
		[yaml release];
	}
}

#define CG_YAMLOBJC_TEST_DATA_HASHLIST_001_BLOCK \
@"---\n" \
@"foods:\n" \
@"  - milk\n" \
@"  - bread\n" \
@"  - eggs"

#define CG_YAMLOBJC_TEST_DATA_HASHLIST_001_INLINE \
@"---\n" \
@"foods: [milk, bread, eggs]\n"

- (void) testHashList {
    
    CGYAML *yaml;
	NSDictionary *yamlHash;
	NSArray *yamlList;
	
	NSArray *testDataArray = [NSMutableArray arrayWithObjects:
							  CG_YAMLOBJC_TEST_DATA_HASHLIST_001_BLOCK,
							  CG_YAMLOBJC_TEST_DATA_HASHLIST_001_INLINE,
							  nil];
	
	for (NSString *testData in testDataArray) {
		yaml = [[CGYAML alloc] initWithString:CG_YAMLOBJC_TEST_DATA_HASHLIST_001_BLOCK];
		STAssertTrue([yamlMapNode count] == 1, testData);
		yamlHash = [yamlMapNode objectAtIndex:0];
		STAssertTrue([[yamlHash allKeys] count] == 1, testData);
		yamlList = [yamlHash objectForKey:@"foods"];
		STAssertTrue([yamlList count] == 3, testData);
		STAssertTrue([[yamlList objectAtIndex:0] isEqualToString:@"milk"], testData);
		STAssertTrue([[yamlList objectAtIndex:1] isEqualToString:@"bread"], testData);
		STAssertTrue([[yamlList objectAtIndex:2] isEqualToString:@"eggs"], testData);
		NSLog(@"\n%@", yaml);
		[yaml release];
	}
}

#define CG_YAMLOBJC_TEST_DATA_LISTHASH_001_BLOCK \
@"---\n" \
@"- part_no: A4786\n" \
@"  descrip: Water Bucket (Filled)\n" \
@"  price: 1.47\n" \
@"  quantity: 4\n"


#define CG_YAMLOBJC_TEST_DATA_LISTHASH_001_INLINE \
@"---\n" \
@"- {part_no: A4786, descrip: Water Bucket (Filled), price: 1.47, quantity:4}\n"

- (void) testListHash {
	
    CGYAML *yaml;
	NSDictionary *yamlHash;
	NSArray *yamlList;
    
	NSArray *testDataArray = [NSMutableArray arrayWithObjects:
                              CG_YAMLOBJC_TEST_DATA_LISTHASH_001_BLOCK,
                              //CG_YAMLOBJC_TEST_DATA_LISTHASH_001_INLINE,
                              nil];
	
	for (NSString *testData in testDataArray) {
		yaml = [[CGYAML alloc] initWithString:testData];
		yamlList = [yamlMapNode objectAtIndex:0];
		STAssertTrue([[yamlList objectAtIndex:0] isKindOfClass:[NSMutableDictionary class]], testData);
		yamlHash = [yamlList objectAtIndex:0];
		STAssertTrue([[yamlHash allKeys] count] == 4, testData);
		STAssertTrue([[yamlHash objectForKey:@"part_no"] isEqualToString:@"A4786"], testData);
		STAssertTrue([[yamlHash objectForKey:@"descrip"] isEqualToString:@"Water Bucket (Filled)"], testData);
		STAssertTrue([[yamlHash objectForKey:@"price"] isEqualToString:@"1.47"], testData);
		STAssertTrue([[yamlHash objectForKey:@"quantity"] isEqualToString:@"4"], testData);
		NSLog(@"\n%@", yaml);
		[yaml release];
	}
}

@end
*/
