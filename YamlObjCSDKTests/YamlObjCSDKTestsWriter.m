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
 * YAML 1.1 (2nd Edition): http://yaml.org/spec/[1].1/
 */

@implementation YamlObjCSDKTests(Writer)

#define CG_YAMLOBJC_TEST_SPEC110_EXAMPLE_21 \
@"- Mark McGwire\n" \
@"- Sammy Sosa\n" \
@"- Ken Griffey"

#define CG_YAMLOBJC_TEST_SPEC110_EXAMPLE_22 \
@"hr:  65    # Home runs\n" \
@"avg: 0.278 # Batting average\n" \
@"rbi: 147   # Runs Batted In\n"

#define CG_YAMLOBJC_TEST_SPEC110_EXAMPLE_23 \
@"american:\n" \
@"- Boston Red Sox\n" \
@"- Detroit Tigers\n" \
@"- New York Yankees\n" \
@"national:\n" \
@"- New York Mets\n" \
@"- Chicago Cubs\n" \
@"- Atlanta Braves\n"

#define CG_YAMLOBJC_TEST_SPEC110_EXAMPLE_24 \
@"-\n" \
@" name: Mark McGwire\n" \
@" hr:   65\n" \
@" avg:  0.278\n" \
@"-\n" \
@" name: Sammy Sosa\n" \
@" hr:   63\n" \
@" avg:  0.288\n" 

#define CG_YAMLOBJC_TEST_SPEC110_EXAMPLE_25 \
@"- [name        , hr, avg  ]\n" \
@"- [Mark McGwire, 65, 0.278]\n" \
@"- [Sammy Sosa  , 63, 0.288]\n" 

#define CG_YAMLOBJC_TEST_SPEC110_EXAMPLE_26 \
@"Mark McGwire: {hr: 65, avg: 0.278}\n" \
@"Sammy Sosa: {\n" \
@"hr: 63,\n" \
@"avg: 0.288\n" \
@"}\n"

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

#define CG_YAMLOBJC_TEST_SPEC110_EXAMPLE_29 \
@"---\n" \
@"hr: # 1998 hr ranking\n" \
@"- Mark McGwire\n" \
@"- Sammy Sosa\n" \
@"rbi:\n" \
@"# 1998 rbi ranking\n" \
@"- Sammy Sosa\n" \
@"- Ken Griff\n" 

#define CG_YAMLOBJC_TEST_SPEC110_EXAMPLE_30 \
@"---\n" \
@"hr:\n" \
@"- Mark McGwire\n" \
@"# Following node labeled SS\n" \
@"- &SS Sammy Sosa\n" \
@"rbi:\n" \
@"- *SS # Subsequent occurrence\n" \
@"- Ken Griffey\n"

- (void) testWriter 
{
	NSArray *yamlSamples = [NSArray arrayWithObjects:
    						CG_YAMLOBJC_TEST_SPEC110_EXAMPLE_21,
                            CG_YAMLOBJC_TEST_SPEC110_EXAMPLE_22,
                            CG_YAMLOBJC_TEST_SPEC110_EXAMPLE_23,
                            CG_YAMLOBJC_TEST_SPEC110_EXAMPLE_24,
                            CG_YAMLOBJC_TEST_SPEC110_EXAMPLE_25,
                            CG_YAMLOBJC_TEST_SPEC110_EXAMPLE_26,
                            CG_YAMLOBJC_TEST_SPEC110_EXAMPLE_27,
                            CG_YAMLOBJC_TEST_SPEC110_EXAMPLE_28,
                            CG_YAMLOBJC_TEST_SPEC110_EXAMPLE_29,
                            CG_YAMLOBJC_TEST_SPEC110_EXAMPLE_30,
                            nil];
	for (NSString *yamlData in yamlSamples) {
	    CGYAML *yamlIn = [[[CGYAML alloc] initWithString:yamlData] autorelease];
	    CGYAML *yamlOut = [[[CGYAML alloc] initWithString:[yamlIn description]] autorelease];
        NSMutableString *errorString = [NSMutableString string];
        [errorString appendString:yamlData];
        [errorString appendString:[yamlIn description]];
        [errorString appendString:[yamlOut description]];
	    STAssertTrue([[yamlIn description] isEqualToString:[yamlOut description]], errorString
        );
    }                            
}

@end
