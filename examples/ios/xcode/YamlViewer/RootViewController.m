//
//  RootViewController.m
//  YamlViewer
//
//  Created by Satoshi Konno on 11/04/01.
//  Copyright 2011 Satoshi Konno. All rights reserved.
//

#import "RootViewController.h"
#import "YamlViewerController.h"

@interface RootViewController()
@property(retain) NSArray *examples;
@end

@implementation RootViewController

@synthesize examples;

- (void)viewDidLoad
{
    [self setTitle:@"YAML 1.1 Examples"];
    
    self.examples = [NSArray arrayWithObjects:
                     @"YAML_1.1_Example_2.1",
                     @"YAML_1.1_Example_2.2",
                     @"YAML_1.1_Example_2.3",
                     @"YAML_1.1_Example_2.4",
                     @"YAML_1.1_Example_2.5",
                     @"YAML_1.1_Example_2.6",
                     @"YAML_1.1_Example_2.7",
                     @"YAML_1.1_Example_2.8",
                     @"YAML_1.1_Example_2.9",
                     @"YAML_1.1_Example_2.10",
                     nil];
    
    [super viewDidLoad];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [examples count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    [[cell textLabel] setText:[NSString stringWithFormat:@"Exsample 2.%d", ([indexPath row]+1)]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
     
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YamlViewerController *detailViewController = [[YamlViewerController alloc] init];
    [detailViewController setTitle:[NSString stringWithFormat:@"Exsample 2.%d", ([indexPath row]+1)]];
    NSString *resouceName = [examples objectAtIndex:[indexPath row]];
    [detailViewController setResourceURL:[[NSBundle mainBundle] URLForResource:resouceName withExtension:@"yaml"]];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

- (void)dealloc
{
    [super dealloc];
}

@end
