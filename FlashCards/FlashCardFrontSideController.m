//
//  FlashCardFrontSideController.m
//  FlashCards
//
//  Created by Raul Chacon on 12/4/11.
//  Copyright (c) 2011 Student. All rights reserved.
//

#import "FlashCardFrontSideController.h"
#import "FlashCardBackSideController.h"
#import "FlashCardListController.h"
#import "DatabaseModel.h"
#import "FlashCardModel.h"
#import "WebViewController.h"

@implementation FlashCardFrontSideController
@synthesize frontSideLabel, stringForFrontSideToPassToBackSide, listView, subjectTitleFromFlashCardList, flashCardPosition, flashCards, databaseModel, backSideController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// set definition of flash card for rear side of flash card
- (void) setTextForBackSideController
{
    NSLog(@"setTextForBackSideController");
    self.backSideController = [self.storyboard instantiateViewControllerWithIdentifier:@"FlashCardBackSideController"];
    
    if(self.backSideController.backSideString == nil)
    {
        self.backSideController.backSideString = [[NSMutableString alloc] init ];
    }
    
    [self.backSideController.backSideString setString:self.stringForFrontSideToPassToBackSide];
}


// push to flash card back side controller with custom animation
- (void) flipToBackSide
{
    [self setTextForBackSideController];
    
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    
    [self.navigationController pushViewController:backSideController animated:NO];
    [UIView commitAnimations];
}

// get all flash cards for current subject in order to have access to them for swiping
- (void) getSimilarFlashCards
{
    // get all flash cards for current subject
    int parentSubjectId = [self.databaseModel selectIdFromSubjectsWhere:self.subjectTitleFromFlashCardList];
    self.flashCards = [self.databaseModel selectAllFromFlashCardsWhereIsHidden:0 subjectId:parentSubjectId];
}


// Show previous flash card after swipe gesture
- (void) showPreviousFlashCard
{
    [self getSimilarFlashCards];
    
    if(self.flashCardPosition != 0)
    {
        //[self getFlashCardsForSwiping: @"previous"];
        self.flashCardPosition = self.flashCardPosition - 1;
    
        // update question text
        self.frontSideLabel.text = [[self.flashCards objectAtIndex:self.flashCardPosition] title];
        
        [UIView beginAnimations:@"View Flip" context:nil];
        [UIView setAnimationDuration:0.80];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
        [UIView setAnimationTransition: UIViewAnimationTransitionCurlDown forView:self.navigationController.view cache:NO];
    
        // update answer text
        [self.stringForFrontSideToPassToBackSide setString:[[self.flashCards objectAtIndex:self.flashCardPosition] getDefinition]];
    
        // update text for back side controller
        [self setTextForBackSideController];
    
        [UIView commitAnimations];
    }

}

// Show next flash card after swipe gesture
- (void) showNextFlashCard
{
    [self getSimilarFlashCards];
    
    NSLog(@"CURRENT POSITION %d == %d", self.flashCardPosition, self.flashCards.count);
    
    if(self.flashCardPosition != self.flashCards.count - 1)
    {
        //[self getFlashCardsForSwiping: @"next"];
        self.flashCardPosition = self.flashCardPosition + 1;
    
        // update question text
        self.frontSideLabel.text = [[self.flashCards objectAtIndex:self.flashCardPosition] title];
    
        [UIView beginAnimations:@"View Flip" context:nil];
        [UIView setAnimationDuration:0.80];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
        [UIView setAnimationTransition: UIViewAnimationTransitionCurlUp forView:self.navigationController.view cache:NO];
    
        // update answer text
        [self.stringForFrontSideToPassToBackSide setString:[[self.flashCards objectAtIndex:self.flashCardPosition] getDefinition]];
    
        // update text for back side controller
        [self setTextForBackSideController];
    
        [UIView commitAnimations];
    }
}

// add swipe left, right and double tap gestures to view
-(void) addGestures
{
    // create swipe left gesture recognizer
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showPreviousFlashCard)];
    swipeLeft.numberOfTouchesRequired = 1;
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    
    // create swipe right gesture recognizer
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showNextFlashCard)];
    swipeRight.numberOfTouchesRequired = 1;
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];

    
    // add double tap gesture recognizer to switch to back side controller
    UITapGestureRecognizer *doubleTap = 
    [[UITapGestureRecognizer alloc]
     initWithTarget:self 
     action:@selector(flipToBackSide)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    
}

// ensure navigation bar shows up since it is hidden on back side controller
- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Question";
    
    [self addGestures];
    
    // set background image
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"IndexCard.png"]];
    self.view.backgroundColor = background;
    
    // get reference to flash card list controller
    if(self.databaseModel == nil)
    {
        databaseModel = [[DatabaseModel alloc]init];
    }
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

// set data in segue destination controller
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    NSLog(@"segue identifier is: %@", [segue identifier]);
    
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"pushToWikipedia"])
    {
        // Get reference to the destination view controller
        WebViewController *webViewController = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        webViewController.flashCardTitle = [[NSMutableString alloc]init ];
        [webViewController.flashCardTitle setString: self.frontSideLabel.text];
    }
}


@end
