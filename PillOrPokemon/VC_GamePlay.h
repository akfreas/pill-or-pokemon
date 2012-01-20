//
//  VC_GamePlay.h
//  PillOrPokemon
//
//  Created by Alexander Freas on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC_GamePlay : UIViewController < UIAlertViewDelegate, UIPopoverControllerDelegate> {
    
    
}

-(id)initWithZone:(NSInteger)theZone;
-(IBAction)chooseType:(id)sender;
@end
