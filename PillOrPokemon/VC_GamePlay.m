    //
//  VC_GamePlay.m
//  PillOrPokemon
//
//  Created by Alexander Freas on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VC_GamePlay.h"
#import "VC_ZoneSelector.h"
#import "GamePlayData.h"
#import "QuizItem.h"


@implementation VC_GamePlay {
    
    IBOutlet UILabel *quizItemLabel;
    IBOutlet UILabel *answerTextLabel;
    IBOutlet UILabel *answerDescriptionLabel;
    IBOutlet UILabel *scoreLabel;
    IBOutlet UILabel *progressLabel;
    
    IBOutlet UIButton *moveToNextButton;
    IBOutlet UIButton *pillButton;
    IBOutlet UIButton *pokeButton;
    
    IBOutlet UIProgressView *quizProgressView;
    
    NSInteger currentQuizItemIndex;
    NSUInteger score;
    NSUInteger zone;
    NSUInteger totalNumberOfQuestions;
    
    NSArray *quizData;
    NSMutableArray *incorrectQuizQuestions;
    NSArray *selectionType;
    QuizItem *currentQuizItem;
    
    VC_ZoneSelector *zoneSelector;
}



-(id)initWithZone:(NSInteger)theZone zoneSelector:(VC_ZoneSelector *)theZoneSelector {
    self = [super initWithNibName:@"GamePlay" bundle:nil];
    
    zoneSelector = theZoneSelector;
    zone = theZone;
    quizProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    
    incorrectQuizQuestions = [NSMutableArray arrayWithCapacity:0];
    [[GamePlayData sharedInstance] setZone:theZone];
    quizData = [[GamePlayData sharedInstance] quizItems];
    totalNumberOfQuestions = [quizData count];
    selectionType = [[NSArray alloc] initWithObjects:@"pill", @"pokemon", nil];
    [[GamePlayData sharedInstance] shuffleQuizData];
    return self;
}





-(NSString *)scoreString:(NSInteger)theScore totalPoints:(NSInteger)thePoints {
    
    NSString *progress = [NSString stringWithFormat:@"%d/%d", theScore, thePoints];
    return progress;
    
}

-(void)markCorrect {
    score++;
    quizItemLabel.textColor = [UIColor greenColor];
    answerTextLabel.textColor = [UIColor greenColor];
    answerTextLabel.text = @"Correct!";
    answerDescriptionLabel.text = currentQuizItem.itemDescription;
    currentQuizItem.correct = [NSNumber numberWithBool:YES];
    scoreLabel.text = [self scoreString:score totalPoints:totalNumberOfQuestions];
}

-(void)markIncorrect {
    quizItemLabel.textColor = [UIColor redColor];
    answerTextLabel.textColor = [UIColor redColor];
    answerTextLabel.text = @"Incorrect.";
    answerDescriptionLabel.text = currentQuizItem.itemDescription;
    currentQuizItem.correct = [NSNumber numberWithBool:NO];
}

-(void)moveToNextItem {
    
    if([quizData count] > currentQuizItemIndex) {
        float progress = (float)currentQuizItemIndex/(float)totalNumberOfQuestions;
        [quizProgressView setProgress:progress];
        
        
        NSInteger questionsRemaining = totalNumberOfQuestions - currentQuizItemIndex;
        
        progressLabel.text = [NSString stringWithFormat:@"%d questions left", questionsRemaining];

        
        currentQuizItem = [quizData objectAtIndex:currentQuizItemIndex];
        
        [self configureUIElementsForUnansweredQuestion];
        
        [moveToNextButton setTitle:@"Skip" forState:UIControlStateNormal]; 
        currentQuizItemIndex++;

    } else {
        
        BOOL perfect = NO;
        
        if (totalNumberOfQuestions == score) {
            perfect = YES;
            [[GamePlayData sharedInstance] markZoneComplete:zone];
            if (zone != 4) {
                [[GamePlayData sharedInstance] unlockZone:zone + 1];
                [[GamePlayData sharedInstance] markZoneComplete:zone];
            }
        }
        [self showEndOfGameMessageWithStatus:perfect];
        [[GamePlayData sharedInstance] save];
    }
    
}

-(void)showEndOfGameMessageWithStatus:(BOOL)perfect {

    NSString *endOfGameMessage;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Results"
                                                    message: @""
                                                   delegate: self
                                          cancelButtonTitle: @"Main Menu"
                                          otherButtonTitles: nil];
    if (perfect && zone < 4) {
        
        endOfGameMessage = [[NSString alloc] initWithString:@"Congratulations! You got a perfect score and have unlocked the next zone!"];
        [alert addButtonWithTitle:@"Proceed to next zone"];
    } else if (perfect && zone == 4) {
        endOfGameMessage = [[NSString alloc] initWithString:@"Congratulations! You beat the game! If you enjoyed playing, please rate the game well on the iTunes store!"];
    } else {
        endOfGameMessage = [[NSString alloc] initWithFormat:@"Your score was %d out of %d. Play again to get a perfect score and unlock the next level!", score, totalNumberOfQuestions];
        [alert addButtonWithTitle:@"Play again"];
    }
    
    alert.message = endOfGameMessage;
    
    [alert show];
}



-(void)setQuizData {
    
    selectionType = [[NSArray alloc] initWithObjects:@"pill", @"pokemon", nil];
    totalNumberOfQuestions = [quizData count];

    [[GamePlayData sharedInstance] shuffleQuizData];
}

-(void)configureUIElementsForUnansweredQuestion {
    
    quizItemLabel.text = [currentQuizItem valueForKey:@"name"];
    quizItemLabel.textColor = [UIColor whiteColor];
    
    answerTextLabel.hidden = YES;
    answerTextLabel.textColor = [UIColor whiteColor];
    
    answerDescriptionLabel.textColor = [UIColor whiteColor];
    answerDescriptionLabel.hidden = YES;
    
    pillButton.hidden = NO;
    pokeButton.hidden = NO;
    
    scoreLabel.text = [self scoreString:score totalPoints:totalNumberOfQuestions];
}

-(void)resetGame {
    
    [self setQuizData];
    [self configureUIElementsForUnansweredQuestion];
    
    currentQuizItemIndex = 0;
    score = 0;
  
    [moveToNextButton setTitle:@"Skip" forState:UIControlStateNormal];   
    [self moveToNextItem];
}


-(void)goToHomeScreen {
    
    [self dismissModalViewControllerAnimated:YES];    
}

-(IBAction)clickNext:(id)sender {
    
    [self moveToNextItem];
    
}

-(IBAction)chooseType:(id)sender {
    
    [moveToNextButton setTitle:@"Next" forState:UIControlStateNormal];   
    UIButton *selectedButton = (UIButton *)sender;
    answerTextLabel.hidden = NO;
    answerDescriptionLabel.hidden = NO;
    NSInteger selection = selectedButton.tag;
    
    if([currentQuizItem.type isEqualToString:[selectionType objectAtIndex:selection]]) {
        
        [self markCorrect];
        
    } else {
        [self markIncorrect];
    } 
    pillButton.hidden = YES;
    pokeButton.hidden = YES;
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
 
    switch (buttonIndex) {
            
        case 0:
            [zoneSelector refresh];
            [self goToHomeScreen];
            
        case 1:
            [self resetGame];
            break;
            
        default:
            break;
    }
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleDone target:self action:@selector(goToHomeScreen)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStyleDone target:self action:@selector(resetGame)];
    
    [self resetGame];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
