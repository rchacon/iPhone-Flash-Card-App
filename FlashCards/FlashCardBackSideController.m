//
//  FlashCardBackSideController.m
//  FlashCards
//
//  Created by Raul Chacon on 12/4/11.
//  Copyright (c) 2011 Student. All rights reserved.
//

#import "FlashCardBackSideController.h"
#import "FlashCardFrontSideController.h"

@implementation FlashCardBackSideController
@synthesize backSideLabel, backSideString;

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


// return to front side of flash card
- (void) flipToFrontSide
{
    NSLog(@"flipToFrontSide");
    NSLog(@"view controller count %d", self.navigationController.viewControllers.count);
    
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    
    // since a back bar button is hidden, pop the back side controller from stack to return to front side
    [self.navigationController popViewControllerAnimated:YES];
    [UIView commitAnimations];
}

// add swipe left, right and double tap gestures
-(void) addGestures
{
    // add double tap gesture recognizer
    UITapGestureRecognizer *doubleTap = 
    [[UITapGestureRecognizer alloc]
     initWithTarget:self 
     action:@selector(flipToFrontSide)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addGestures];
    
    // hide navigation bar.
    [self.navigationController setNavigationBarHidden:YES]; 
    
    // set label text
    NSLog(@"backsideString = %@", self.backSideString);
    self.backSideLabel.text = self.backSideString;
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
