//
//  YamlObjCSDKTests.m
//  YamlObjCSDKTests
//
//  Created by Satoshi Konno on 11/03/24.
//  Copyright 2011 Satoshi Konno. All rights reserved.
//

#import "YamlObjCSDKTests.h"
#import "CGYAML.h"

@implementation YamlObjCSDKTests(Misc)

#define CG_YAMLOBJC_TEST_DATA_SEQMAP_MIX \
@"- Mark McGwire\n" \
@"- Sammy Sosa\n" \
@"- Ken Griffey" \
@"hr:  65    # Home runs\n" \
@"avg: 0.278 # Batting average\n" \
@"rbi: 147   # Runs Batted In\n"

- (void) testSeqMapMix {

    CGYAML *yaml;
    
    yaml = [[CGYAML alloc] initWithString:CG_YAMLOBJC_TEST_DATA_SEQMAP_MIX];
    NSLog(@"\n%@", yaml);
    
    STAssertTrue([yaml error] != nil, @"");
    NSLog(@"\n%@", [yaml error]);
}

@end
