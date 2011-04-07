//
//  YamlViewerController.m
//  YamlViewer
//
//  Created by Satoshi Konno on 11/04/01.
//  Copyright 2011 Satoshi Konno. All rights reserved.
//

#import "YamlViewerController.h"
#import "CGYAML.h"

@interface YamlViewerController()
@property(retain) UITextView *textView;
@end

@implementation YamlViewerController

@synthesize resourceURL;
@synthesize textView;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)loadResouce
{
    CGYAML *yaml = [[CGYAML alloc] initWithURL:resourceURL];
    NSLog(@"\n%@", [yaml description]);
    [textView setText:[yaml description]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
	textView.textColor = [UIColor blackColor];
	textView.backgroundColor = [UIColor whiteColor];
	textView.editable = NO;
	textView.scrollEnabled = YES;
	[self.view addSubview: textView];
    
    [self loadResouce];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
