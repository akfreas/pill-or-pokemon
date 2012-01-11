//
//  VC_GamePlay.m
//  PillOrPokemon
//
//  Created by Alexander Freas on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VC_GamePlay.h"

@implementation VC_GamePlay

-(id)initWithZone:(NSInteger)zone {
    self = [super initWithNibName:@"GamePlay" bundle:nil];
    NSString *gameInfoFile = [[NSBundle mainBundle] pathForResource:@"GamePlayData" ofType:@"plist"];
    NSArray *temp = [[NSArray alloc] initWithContentsOfFile:gameInfoFile];
    gamePlayData = [NSArray arrayWithArray:[temp objectAtIndex:zone]];
    
    return self;
    
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
