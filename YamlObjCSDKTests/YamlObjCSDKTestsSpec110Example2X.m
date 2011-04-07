//
//  YamlObjCSDKTests.m
//  YamlObjCSDKTests
//
//  Created by Satoshi Konno on 11/03/24.
//  Copyright 2011 Satoshi Konno. All rights reserved.
//

#import "YamlObjCSDKTests.h"
#import "CGYAML.h"

@implementation YamlObjCSDKTests(Spec110Example2X)

/*
 * YAML 1.1 (2nd Edition): http://yaml.org/spec/[1].1/
 */

#define CG_YAMLOBJC_TEST_SPEC110_EXAMPLE_21 \
@"- Mark McGwire\n" \
@"- Sammy Sosa\n" \
@"- Ken Griffey"

- (void) testExample21 
{
    CGYAML *yaml;
	NSArray *yamlSeqNode;
	
    yaml = [[CGYAML alloc] initWithString:CG_YAMLOBJC_TEST_SPEC110_EXAMPLE_21];
    NSLog(@"\n%@", yaml);
    
    STAssertTrue([yaml numDocuments] == 1, @"");
    
    /**** APIs ****/
    
    yamlSeqNode = [yaml documentRootNodeAtIndex:0];    
    STAssertTrue([yamlSeqNode isYAMLSequenceNode], @"");
    STAssertTrue([yamlSeqNode count] == 3, @"");
    STAssertTrue([[yamlSeqNode objectAtIndex:0] isEqualToString:@"Mark McGwire"], @"");
    STAssertTrue([[yamlSeqNode objectAtIndex:1] isEqualToString:@"Sammy Sosa"], @"");
    STAssertTrue([[yamlSeqNode objectAtIndex:2] isEqualToString:@"Ken Griffey"], @"");
    
    /**** YPath ****/
    
    STAssertTrue([[yaml objectForYPath:@"/"] isYAMLSequenceNode], @"");
    STAssertTrue([[yaml objectForYPath:@"/"] count] == 3, @"");
    
    STAssertTrue([[yaml valueForYPath:@"/[0]"] isEqualToString:@"Mark McGwire"], @"");
    STAssertTrue([[yaml valueForYPath:@"/[1]"] isEqualToString:@"Sammy Sosa"], @"");
    STAssertTrue([[yaml valueForYPath:@"/[2]"] isEqualToString:@"Ken Griffey"], @"");
    
    STAssertNil([yaml valueForYPath:@"/[3]"], @"");
    STAssertNil([yaml valueForYPath:@"/hr"], @"");
    
    [yaml release];
}

#define CG_YAMLOBJC_TEST_SPEC110_EXAMPLE_22 \
@"hr:  65    # Home runs\n" \
@"avg: 0.278 # Batting average\n" \
@"rbi: 147   # Runs Batted In\n"

- (void) testExample22
{
    CGYAML *yaml;
	NSDictionary *yamlMapNode;
    
    yaml = [[CGYAML alloc] initWithString:CG_YAMLOBJC_TEST_SPEC110_EXAMPLE_22];
    NSLog(@"\n%@", yaml);
    
    STAssertTrue([yaml numDocuments] == 1, @"");
    
    /**** APIs ****/
    
    yamlMapNode = [yaml documentRootNodeAtIndex:0];
    STAssertTrue([yamlMapNode isYAMLMappingNode], @"");
    STAssertTrue([[yamlMapNode allKeys] count] == 3, @"");
    STAssertTrue([[yamlMapNode objectForKey:@"hr"] isEqualToString:@"65"], @"");
    STAssertTrue([[yamlMapNode objectForKey:@"avg"] isEqualToString:@"0.278"], @"");
    STAssertTrue([[yamlMapNode objectForKey:@"rbi"] isEqualToString:@"147"], @"");
    
    /**** YPath ****/
    
    STAssertTrue([[yaml objectForYPath:@"/"] isYAMLMappingNode], @"");
    STAssertTrue([[[yaml objectForYPath:@"/"] allKeys] count] == 3, @"");
    
    STAssertTrue([[yaml valueForYPath:@"/hr"] isEqualToString:@"65"], @"");
    STAssertTrue([[yaml valueForYPath:@"/avg"] isEqualToString:@"0.278"], @"");
    STAssertTrue([[yaml valueForYPath:@"/rbi"] isEqualToString:@"147"], @"");
    
    STAssertNil([yaml valueForYPath:@"/[0]"], @"");
    STAssertNil([yaml valueForYPath:@"/none"], @"");
    
   [yaml release];
}

#define CG_YAMLOBJC_TEST_SPEC110_EXAMPLE_23 \
@"american:\n" \
@"- Boston Red Sox\n" \
@"- Detroit Tigers\n" \
@"- New York Yankees\n" \
@"national:\n" \
@"- New York Mets\n" \
@"- Chicago Cubs\n" \
@"- Atlanta Braves\n"

- (void) testExample23
{
    CGYAML *yaml;
	NSDictionary *yamlMapNode;
	NSArray *yamlSeqNode;
    
    yaml = [[CGYAML alloc] initWithString:CG_YAMLOBJC_TEST_SPEC110_EXAMPLE_23];
    NSLog(@"\n%@", yaml);
    
    STAssertTrue([yaml numDocuments] == 1, @"");
    
    /**** APIs ****/
    
    yamlMapNode = [yaml documentRootNodeAtIndex:0];
    STAssertTrue([yamlMapNode isYAMLMappingNode], @"");
    
    yamlSeqNode = [yamlMapNode objectForKey:@"american"];
    STAssertTrue([yamlSeqNode isYAMLSequenceNode], @"");
    STAssertTrue([yamlSeqNode count] == 3, @"");
    STAssertTrue([[yamlSeqNode objectAtIndex:0] isEqualToString:@"Boston Red Sox"], @"");
    STAssertTrue([[yamlSeqNode objectAtIndex:1] isEqualToString:@"Detroit Tigers"], @"");
    STAssertTrue([[yamlSeqNode objectAtIndex:2] isEqualToString:@"New York Yankees"], @"");
    yamlSeqNode = [yamlMapNode objectForKey:@"national"];
    STAssertTrue([yamlSeqNode isYAMLSequenceNode], @"");
    STAssertTrue([yamlSeqNode count] == 3, @"");
    STAssertTrue([[yamlSeqNode objectAtIndex:0] isEqualToString:@"New York Mets"], @"");
    STAssertTrue([[yamlSeqNode objectAtIndex:1] isEqualToString:@"Chicago Cubs"], @"");
    STAssertTrue([[yamlSeqNode objectAtIndex:2] isEqualToString:@"Atlanta Braves"], @"");
    
    /**** YPath ****/
    
    STAssertTrue([[yaml objectForYPath:@"/"] isYAMLMappingNode], @"");
    STAssertTrue([[[yaml objectForYPath:@"/"] allKeys] count] == 2, @"");
    STAssertTrue([[yaml objectForYPath:@"/american"] isYAMLSequenceNode], @"");
    STAssertTrue([[yaml objectForYPath:@"/american"] count] == 3, @"");
    STAssertTrue([[yaml objectForYPath:@"/american/"] isYAMLSequenceNode], @"");
    STAssertTrue([[yaml objectForYPath:@"/american/"] count] == 3, @"");
    STAssertTrue([[yaml objectForYPath:@"/national"] isYAMLSequenceNode], @"");
    STAssertTrue([[yaml objectForYPath:@"/national"] count] == 3, @"");
    
    STAssertTrue([[yaml valueForYPath:@"/american/[0]"] isEqualToString:@"Boston Red Sox"], @"");
    STAssertTrue([[yaml valueForYPath:@"/american/[1]"] isEqualToString:@"Detroit Tigers"], @"");
    STAssertTrue([[yaml valueForYPath:@"/american/[2]"] isEqualToString:@"New York Yankees"], @"");
    STAssertTrue([[yaml valueForYPath:@"/national/[0]"] isEqualToString:@"New York Mets"], @"");
    STAssertTrue([[yaml valueForYPath:@"/national/[1]"] isEqualToString:@"Chicago Cubs"], @"");
    STAssertTrue([[yaml valueForYPath:@"/national/[2]"] isEqualToString:@"Atlanta Braves"], @"");
    
   [yaml release];
}

#define CG_YAMLOBJC_TEST_SPEC110_EXAMPLE_24 \
@"-\n" \
@" name: Mark McGwire\n" \
@" hr:   65\n" \
@" avg:  0.278\n" \
@"-\n" \
@" name: Sammy Sosa\n" \
@" hr:   63\n" \
@" avg:  0.288\n" 

- (void) testExample24
{
    CGYAML *yaml;
	NSDictionary *yamlMapNode;
	NSArray *yamlSeqNode;
    
    yaml = [[CGYAML alloc] initWithString:CG_YAMLOBJC_TEST_SPEC110_EXAMPLE_24];
    NSLog(@"\n%@", yaml);
    
    STAssertTrue([yaml numDocuments] == 1, @"");
    
    /**** APIs ****/
    
    yamlSeqNode = [yaml documentRootNodeAtIndex:0];
    STAssertTrue([yamlSeqNode isYAMLSequenceNode], @"");
    
    yamlMapNode = [yamlSeqNode objectAtIndex:0];
    STAssertTrue([yamlMapNode isYAMLMappingNode], @"");
    STAssertTrue([[yamlMapNode allKeys] count] == 3, @"");
    STAssertTrue([[yamlMapNode objectForKey:@"name"] isEqualToString:@"Mark McGwire"], @"");
    STAssertTrue([[yamlMapNode objectForKey:@"hr"] isEqualToString:@"65"], @"");
    STAssertTrue([[yamlMapNode objectForKey:@"avg"] isEqualToString:@"0.278"], @"");
    yamlMapNode = [yamlSeqNode objectAtIndex:1];
    STAssertTrue([yamlMapNode isYAMLMappingNode], @"");
    STAssertTrue([[yamlMapNode allKeys] count] == 3, @"");
    STAssertTrue([[yamlMapNode objectForKey:@"name"] isEqualToString:@"Sammy Sosa"], @"");
    STAssertTrue([[yamlMapNode objectForKey:@"hr"] isEqualToString:@"63"], @"");
    STAssertTrue([[yamlMapNode objectForKey:@"avg"] isEqualToString:@"0.288"], @"");

    /**** YPath ****/

    STAssertTrue([[yaml objectForYPath:@"/"] isYAMLSequenceNode], @"");
    STAssertTrue([[yaml objectForYPath:@"/"] count] == 2, @"");
    STAssertTrue([[yaml objectForYPath:@"/[0]"] isYAMLMappingNode], @"");
    STAssertTrue([[[yaml objectForYPath:@"/[0]"] allKeys] count] == 3, @"");
    STAssertTrue([[yaml objectForYPath:@"/[1]"] isYAMLMappingNode], @"");
    STAssertTrue([[[yaml objectForYPath:@"/[1]"] allKeys] count] == 3, @"");
    
    STAssertTrue([[yaml valueForYPath:@"/[0]/name"] isEqualToString:@"Mark McGwire"], @"");
    STAssertTrue([[yaml valueForYPath:@"/[0]/hr"] isEqualToString:@"65"], @"");
    STAssertTrue([[yaml valueForYPath:@"/[0]/avg"] isEqualToString:@"0.278"], @"");
    STAssertTrue([[yaml valueForYPath:@"/[1]/name"] isEqualToString:@"Sammy Sosa"], @"");
    STAssertTrue([[yaml valueForYPath:@"/[1]/hr"] isEqualToString:@"63"], @"");
    STAssertTrue([[yaml valueForYPath:@"/[1]/avg"] isEqualToString:@"0.288"], @"");
    
    STAssertNil([yaml valueForYPath:@"/[0]/none"], @"");
    STAssertNil([yaml valueForYPath:@"/[1]/none"], @"");
    
    [yaml release];
}

#define CG_YAMLOBJC_TEST_SPEC110_EXAMPLE_25 \
@"- [name        , hr, avg  ]\n" \
@"- [Mark McGwire, 65, 0.278]\n" \
@"- [Sammy Sosa  , 63, 0.288]\n" 

- (void) testExample25
{
    CGYAML *yaml;
	NSArray *yamlSeqNode;
	NSArray *yamlChildSeqNode;
    
    yaml = [[CGYAML alloc] initWithString:CG_YAMLOBJC_TEST_SPEC110_EXAMPLE_25];
    NSLog(@"\n%@", yaml);
    
    STAssertTrue([yaml numDocuments] == 1, @"");
    
    /**** APIs ****/
    
    yamlSeqNode = [yaml documentRootNodeAtIndex:0];
    STAssertTrue([yamlSeqNode isYAMLSequenceNode], @"");
    
    STAssertTrue([yamlSeqNode count] == 3, @"");
    yamlChildSeqNode = [yamlSeqNode objectAtIndex:0];
    STAssertTrue([yamlChildSeqNode isYAMLSequenceNode], @"");
    STAssertTrue([yamlChildSeqNode count] == 3, @"");
    STAssertTrue([[yamlChildSeqNode objectAtIndex:0] isEqualToString:@"name"], @"");
    STAssertTrue([[yamlChildSeqNode objectAtIndex:1] isEqualToString:@"hr"], @"");
    STAssertTrue([[yamlChildSeqNode objectAtIndex:2] isEqualToString:@"avg"], @"");
    yamlChildSeqNode = [yamlSeqNode objectAtIndex:1];
    STAssertTrue([yamlChildSeqNode isYAMLSequenceNode], @"");
    STAssertTrue([yamlChildSeqNode count] == 3, @"");
    STAssertTrue([[yamlChildSeqNode objectAtIndex:0] isEqualToString:@"Mark McGwire"], @"");
    STAssertTrue([[yamlChildSeqNode objectAtIndex:1] isEqualToString:@"65"], @"");
    STAssertTrue([[yamlChildSeqNode objectAtIndex:2] isEqualToString:@"0.278"], @"");
    yamlChildSeqNode = [yamlSeqNode objectAtIndex:2];
    STAssertTrue([yamlChildSeqNode isYAMLSequenceNode], @"");
    STAssertTrue([yamlChildSeqNode count] == 3, @"");
    STAssertTrue([[yamlChildSeqNode objectAtIndex:0] isEqualToString:@"Sammy Sosa"], @"");
    STAssertTrue([[yamlChildSeqNode objectAtIndex:1] isEqualToString:@"63"], @"");
    STAssertTrue([[yamlChildSeqNode objectAtIndex:2] isEqualToString:@"0.288"], @"");
    
    /**** YPath ****/
    
    STAssertTrue([[yaml objectForYPath:@"/"] isYAMLSequenceNode], @"");
    STAssertTrue([[yaml objectForYPath:@"/"] count] == 3, @"");
    STAssertTrue([[yaml objectForYPath:@"/[0]"] isYAMLSequenceNode], @"");
    STAssertTrue([[yaml objectForYPath:@"/[0]"] count] == 3, @"");
    STAssertTrue([[yaml objectForYPath:@"/[1]"] isYAMLSequenceNode], @"");
    STAssertTrue([[yaml objectForYPath:@"/[1]"] count] == 3, @"");
    STAssertTrue([[yaml objectForYPath:@"/[2]"] isYAMLSequenceNode], @"");
    STAssertTrue([[yaml objectForYPath:@"/[2]"] count] == 3, @"");
    
    STAssertTrue([[yaml valueForYPath:@"/[0]/[0]"] isEqualToString:@"name"], @"");
    STAssertTrue([[yaml valueForYPath:@"/[0]/[1]"] isEqualToString:@"hr"], @"");
    STAssertTrue([[yaml valueForYPath:@"/[0]/[2]"] isEqualToString:@"avg"], @"");
    STAssertTrue([[yaml valueForYPath:@"/[1]/[0]"] isEqualToString:@"Mark McGwire"], @"");
    STAssertTrue([[yaml valueForYPath:@"/[1]/[1]"] isEqualToString:@"65"], @"");
    STAssertTrue([[yaml valueForYPath:@"/[1]/[2]"] isEqualToString:@"0.278"], @"");
    STAssertTrue([[yaml valueForYPath:@"/[2]/[0]"] isEqualToString:@"Sammy Sosa"], @"");
    STAssertTrue([[yaml valueForYPath:@"/[2]/[1]"] isEqualToString:@"63"], @"");
    STAssertTrue([[yaml valueForYPath:@"/[2]/[2]"] isEqualToString:@"0.288"], @"");
    
    [yaml release];
}

#define CG_YAMLOBJC_TEST_SPEC110_EXAMPLE_26 \
@"Mark McGwire: {hr: 65, avg: 0.278}\n" \
@"Sammy Sosa: {\n" \
@"hr: 63,\n" \
@"avg: 0.288\n" \
@"}\n"

- (void) testExample26
{
    CGYAML *yaml;
	NSDictionary *yamlMapNode;
	NSDictionary *yamlChildMapNode;
    
    yaml = [[CGYAML alloc] initWithString:CG_YAMLOBJC_TEST_SPEC110_EXAMPLE_26];
    NSLog(@"\n%@", yaml);
    
    STAssertTrue([yaml numDocuments] == 1, @"");
    
    /**** APIs ****/
    
    yamlMapNode = [yaml documentRootNodeAtIndex:0];
    STAssertTrue([yamlMapNode isYAMLMappingNode], @"");
    STAssertTrue([[yamlMapNode allKeys] count] == 2, @"");
    
    yamlChildMapNode = [yamlMapNode objectForKey:@"Mark McGwire"];
    STAssertTrue([yamlChildMapNode isYAMLMappingNode], @"");
    STAssertTrue([[yamlChildMapNode allKeys] count] == 2, @"");
    STAssertTrue([[yamlChildMapNode objectForKey:@"hr"] isEqualToString:@"65"], @"");
    STAssertTrue([[yamlChildMapNode objectForKey:@"avg"] isEqualToString:@"0.278"], @"");

    yamlChildMapNode = [yamlMapNode objectForKey:@"Sammy Sosa"];
    STAssertTrue([yamlChildMapNode isYAMLMappingNode], @"");
    STAssertTrue([[yamlChildMapNode allKeys] count] == 2, @"");
    STAssertTrue([[yamlChildMapNode objectForKey:@"hr"] isEqualToString:@"63"], @"");
    STAssertTrue([[yamlChildMapNode objectForKey:@"avg"] isEqualToString:@"0.288"], @"");
    
    /**** YPath ****/

    STAssertTrue([[yaml objectForYPath:@"/"] isYAMLMappingNode], @"");
    STAssertTrue([[[yaml objectForYPath:@"/"] allKeys] count] == 2, @"");
    STAssertTrue([[yaml objectForYPath:@"/Mark McGwire"] isYAMLMappingNode], @"");
    STAssertTrue([[[yaml objectForYPath:@"/Mark McGwire"] allKeys] count] == 2, @"");
    STAssertTrue([[yaml objectForYPath:@"/Sammy Sosa"] isYAMLMappingNode], @"");
    STAssertTrue([[[yaml objectForYPath:@"/Sammy Sosa"] allKeys] count] == 2, @"");
    
    STAssertTrue([[yaml valueForYPath:@"/Mark McGwire/hr"] isEqualToString:@"65"], @"");
    STAssertTrue([[yaml valueForYPath:@"/Mark McGwire/avg"] isEqualToString:@"0.278"], @"");
    STAssertTrue([[yaml valueForYPath:@"/Sammy Sosa/hr"] isEqualToString:@"63"], @"");
    STAssertTrue([[yaml valueForYPath:@"/Sammy Sosa/avg"] isEqualToString:@"0.288"], @"");
    
    [yaml release];
}

#define CG_YAMLOBJC_TEST_SPEC110_EXAMPLE_27 \
@"# Ranking of 1998 home runs\n" \
@"---\n" \
@"- Mark McGwire\n" \
@"- Sammy Sosa\n" \
@"- Ken Griffey\n" \
@"\n" \
@"# Team ranking\n" \
@"---\n" \
@"- Chicago Cubs\n" \
@"- St Louis Cardinals\n"

- (void) testExample27
{
    CGYAML *yaml;
	NSArray *yamlSeqNode;
	
    yaml = [[CGYAML alloc] initWithString:CG_YAMLOBJC_TEST_SPEC110_EXAMPLE_27];
    NSLog(@"\n%@", yaml);
    
    STAssertTrue([yaml numDocuments] == 2, @"");    
    
    /**** APIs ****/
    
    yamlSeqNode = [yaml documentRootNodeAtIndex:0];    
    STAssertTrue([yamlSeqNode isYAMLSequenceNode], @"");
    STAssertTrue([yamlSeqNode count] == 3, @"");
    STAssertTrue([[yamlSeqNode objectAtIndex:0] isEqualToString:@"Mark McGwire"], @"");
    STAssertTrue([[yamlSeqNode objectAtIndex:1] isEqualToString:@"Sammy Sosa"], @"");
    STAssertTrue([[yamlSeqNode objectAtIndex:2] isEqualToString:@"Ken Griffey"], @"");

    yamlSeqNode = [yaml documentRootNodeAtIndex:1];
    STAssertTrue([yamlSeqNode isYAMLSequenceNode], @"");
    STAssertTrue([yamlSeqNode count] == 2, @"");
    STAssertTrue([[yamlSeqNode objectAtIndex:0] isEqualToString:@"Chicago Cubs"], @"");
    STAssertTrue([[yamlSeqNode objectAtIndex:1] isEqualToString:@"St Louis Cardinals"], @"");
    
    /**** YPath ****/
    
    STAssertTrue([[yaml objectForYPath:@"/"] isYAMLSequenceNode], @"");
    STAssertTrue([[yaml objectForYPath:@"/"] count] == 3, @"");
    STAssertTrue([[yaml objectForYPath:@"[0]/"] isYAMLSequenceNode], @"");
    STAssertTrue([[yaml objectForYPath:@"[0]/"] count] == 3, @"");
    STAssertTrue([[yaml objectForYPath:@"[1]/"] isYAMLSequenceNode], @"");
    STAssertTrue([[yaml objectForYPath:@"[1]/"] count] == 2, @"");
    
    STAssertTrue([[yaml valueForYPath:@"/[0]"] isEqualToString:@"Mark McGwire"], @"");
    STAssertTrue([[yaml valueForYPath:@"/[1]"] isEqualToString:@"Sammy Sosa"], @"");
    STAssertTrue([[yaml valueForYPath:@"/[2]"] isEqualToString:@"Ken Griffey"], @"");
    STAssertTrue([[yaml valueForYPath:@"[0]/[0]"] isEqualToString:@"Mark McGwire"], @"");
    STAssertTrue([[yaml valueForYPath:@"[0]/[1]"] isEqualToString:@"Sammy Sosa"], @"");
    STAssertTrue([[yaml valueForYPath:@"[0]/[2]"] isEqualToString:@"Ken Griffey"], @"");
    STAssertTrue([[yaml valueForYPath:@"[1]/[0]"] isEqualToString:@"Chicago Cubs"], @"");
    STAssertTrue([[yaml valueForYPath:@"[1]/[1]"] isEqualToString:@"St Louis Cardinals"], @"");
    
    STAssertNil([yaml valueForYPath:@"/[3]"], @"");
    STAssertNil([yaml valueForYPath:@"[0]/[3]"], @"");
    STAssertNil([yaml valueForYPath:@"[1]/[2]"], @"");
    
   [yaml release];
}

#define CG_YAMLOBJC_TEST_SPEC110_EXAMPLE_28 \
@"---\n" \
@"time: 20:03:20\n" \
@"player: Sammy Sosa\n" \
@"action: strike (miss)\n" \
@"...\n" \
@"---\n" \
@"time: 20:03:47\n" \
@"player: Sammy Sosa\n" \
@"action: grand slam\n" \
@"...\n"

- (void) testExample28
{
    CGYAML *yaml;
	NSDictionary *yamlMapNode;
    
    yaml = [[CGYAML alloc] initWithString:CG_YAMLOBJC_TEST_SPEC110_EXAMPLE_28];
    NSLog(@"\n%@", yaml);
    
    STAssertTrue([yaml numDocuments] == 2, @"");
    
    /**** APIs ****/
    
    yamlMapNode = [yaml documentRootNodeAtIndex:0];
    STAssertTrue([yamlMapNode isYAMLMappingNode], @"");
    STAssertTrue([[yamlMapNode allKeys] count] == 3, @"");
    STAssertTrue([[yamlMapNode objectForKey:@"time"] isEqualToString:@"20:03:20"], @"");
    STAssertTrue([[yamlMapNode objectForKey:@"player"] isEqualToString:@"Sammy Sosa"], @"");
    STAssertTrue([[yamlMapNode objectForKey:@"action"] isEqualToString:@"strike (miss)"], @"");

    yamlMapNode = [yaml documentRootNodeAtIndex:1];
    STAssertTrue([yamlMapNode isYAMLMappingNode], @"");
    STAssertTrue([[yamlMapNode allKeys] count] == 3, @"");
    STAssertTrue([[yamlMapNode objectForKey:@"time"] isEqualToString:@"20:03:47"], @"");
    STAssertTrue([[yamlMapNode objectForKey:@"player"] isEqualToString:@"Sammy Sosa"], @"");
    STAssertTrue([[yamlMapNode objectForKey:@"action"] isEqualToString:@"grand slam"], @"");
    
    /**** YPath ****/
    
    STAssertTrue([[yaml objectForYPath:@"/"] isYAMLMappingNode], @"");
    STAssertTrue([[[yaml objectForYPath:@"/"] allKeys] count] == 3, @"");
    STAssertTrue([[yaml objectForYPath:@"[0]/"] isYAMLMappingNode], @"");
    STAssertTrue([[[yaml objectForYPath:@"[0]/"] allKeys] count] == 3, @"");
    STAssertTrue([[yaml objectForYPath:@"[1]/"] isYAMLMappingNode], @"");
    STAssertTrue([[[yaml objectForYPath:@"[1]/"] allKeys] count] == 3, @"");
    
    STAssertTrue([[yaml valueForYPath:@"/time"] isEqualToString:@"20:03:20"], @"");
    STAssertTrue([[yaml valueForYPath:@"/player"] isEqualToString:@"Sammy Sosa"], @"");
    STAssertTrue([[yaml valueForYPath:@"/action"] isEqualToString:@"strike (miss)"], @"");
    STAssertTrue([[yaml valueForYPath:@"[0]/time"] isEqualToString:@"20:03:20"], @"");
    STAssertTrue([[yaml valueForYPath:@"[0]/player"] isEqualToString:@"Sammy Sosa"], @"");
    STAssertTrue([[yaml valueForYPath:@"[0]/action"] isEqualToString:@"strike (miss)"], @"");
    STAssertTrue([[yaml valueForYPath:@"[1]/time"] isEqualToString:@"20:03:47"], @"");
    STAssertTrue([[yaml valueForYPath:@"[1]/player"] isEqualToString:@"Sammy Sosa"], @"");
    STAssertTrue([[yaml valueForYPath:@"[1]/action"] isEqualToString:@"grand slam"], @"");
    
    [yaml release];
}

#define CG_YAMLOBJC_TEST_SPEC110_EXAMPLE_29 \
@"---\n" \
@"hr: # 1998 hr ranking\n" \
@"- Mark McGwire\n" \
@"- Sammy Sosa\n" \
@"rbi:\n" \
@"# 1998 rbi ranking\n" \
@"- Sammy Sosa\n" \
@"- Ken Griff\n" 

- (void) testExample29
{
    CGYAML *yaml;
	NSDictionary *yamlMapNode;
	NSArray *yamlSeqNode;
	
    yaml = [[CGYAML alloc] initWithString:CG_YAMLOBJC_TEST_SPEC110_EXAMPLE_29];
    NSLog(@"\n%@", yaml);
    
    STAssertTrue([yaml numDocuments] == 1, @"");
    
    /**** APIs ****/
    
    yamlMapNode = [yaml documentRootNodeAtIndex:0];
    STAssertTrue([yamlMapNode isYAMLMappingNode], @"");
    STAssertTrue([[yamlMapNode allKeys] count] == 2, @"");
    
    yamlSeqNode = [yamlMapNode objectForKey:@"hr"];
    STAssertTrue([yamlSeqNode isYAMLSequenceNode], @"");
    STAssertTrue([[yamlSeqNode objectAtIndex:0] isEqualToString:@"Mark McGwire"], @"");
    STAssertTrue([[yamlSeqNode objectAtIndex:1] isEqualToString:@"Sammy Sosa"], @"");

    yamlSeqNode = [yamlMapNode objectForKey:@"rbi"];
    STAssertTrue([yamlSeqNode isYAMLSequenceNode], @"");
    STAssertTrue([[yamlSeqNode objectAtIndex:0] isEqualToString:@"Sammy Sosa"], @"");
    STAssertTrue([[yamlSeqNode objectAtIndex:1] isEqualToString:@"Ken Griff"], @"");
    
    /**** YPath ****/
    
    STAssertTrue([[yaml objectForYPath:@"/"] isYAMLMappingNode], @"");
    STAssertTrue([[[yaml objectForYPath:@"/"] allKeys] count] == 2, @"");
    STAssertTrue([[yaml objectForYPath:@"/hr"] isYAMLSequenceNode], @"");
    STAssertTrue([[yaml objectForYPath:@"/hr"] count] == 2, @"");
    STAssertTrue([[yaml objectForYPath:@"/rbi"] isYAMLSequenceNode], @"");
    STAssertTrue([[yaml objectForYPath:@"/rbi"] count] == 2, @"");
    
    STAssertTrue([[yaml valueForYPath:@"/hr/[0]"] isEqualToString:@"Mark McGwire"], @"");
    STAssertTrue([[yaml valueForYPath:@"/hr/[1]"] isEqualToString:@"Sammy Sosa"], @"");
    STAssertTrue([[yaml valueForYPath:@"/rbi/[0]"] isEqualToString:@"Sammy Sosa"], @"");
    STAssertTrue([[yaml valueForYPath:@"/rbi/[1]"] isEqualToString:@"Ken Griff"], @"");
    
    [yaml release];
}

#define CG_YAMLOBJC_TEST_SPEC110_EXAMPLE_30 \
@"---\n" \
@"hr:\n" \
@"- Mark McGwire\n" \
@"# Following node labeled SS\n" \
@"- &SS Sammy Sosa\n" \
@"rbi:\n" \
@"- *SS # Subsequent occurrence\n" \
@"- Ken Griffey\n"

- (void) testExample30
{
    CGYAML *yaml;
	NSDictionary *yamlMapNode;
	NSArray *yamlSeqNode;
	
    yaml = [[CGYAML alloc] initWithString:CG_YAMLOBJC_TEST_SPEC110_EXAMPLE_29];
    NSLog(@"\n%@", yaml);
    
    STAssertTrue([yaml numDocuments] == 1, @"");
    
    /**** APIs ****/
    
    yamlMapNode = [yaml documentRootNodeAtIndex:0];
    STAssertTrue([yamlMapNode isYAMLMappingNode], @"");
    STAssertTrue([[yamlMapNode allKeys] count] == 2, @"");
    
    yamlSeqNode = [yamlMapNode objectForKey:@"hr"];
    STAssertTrue([yamlSeqNode isYAMLSequenceNode], @"");
    STAssertTrue([[yamlSeqNode objectAtIndex:0] isEqualToString:@"Mark McGwire"], @"");
    STAssertTrue([[yamlSeqNode objectAtIndex:1] isEqualToString:@"Sammy Sosa"], @"");
    
    yamlSeqNode = [yamlMapNode objectForKey:@"rbi"];
    STAssertTrue([yamlSeqNode isYAMLSequenceNode], @"");
    STAssertTrue([[yamlSeqNode objectAtIndex:0] isEqualToString:@"Sammy Sosa"], @"");
    STAssertTrue([[yamlSeqNode objectAtIndex:1] isEqualToString:@"Ken Griff"], @"");
    
    /**** YPath ****/
    
    STAssertTrue([[yaml objectForYPath:@"/"] isYAMLMappingNode], @"");
    STAssertTrue([[[yaml objectForYPath:@"/"] allKeys] count] == 2, @"");
    STAssertTrue([[yaml objectForYPath:@"/hr"] isYAMLSequenceNode], @"");
    STAssertTrue([[yaml objectForYPath:@"/hr"] count] == 2, @"");
    STAssertTrue([[yaml objectForYPath:@"/rbi"] isYAMLSequenceNode], @"");
    STAssertTrue([[yaml objectForYPath:@"/rbi"] count] == 2, @"");
    
    STAssertTrue([[yaml valueForYPath:@"/hr/[0]"] isEqualToString:@"Mark McGwire"], @"");
    STAssertTrue([[yaml valueForYPath:@"/hr/[1]"] isEqualToString:@"Sammy Sosa"], @"");
    STAssertTrue([[yaml valueForYPath:@"/rbi/[0]"] isEqualToString:@"Sammy Sosa"], @"");
    STAssertTrue([[yaml valueForYPath:@"/rbi/[1]"] isEqualToString:@"Ken Griff"], @"");
    
    [yaml release];
}

@end
