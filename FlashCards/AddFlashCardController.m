//
//  AddFlashCardController.m
//  FlashCards
//
//  Created by Raul Chacon on 12/3/11.
//  Copyright (c) 2011 Student. All rights reserved.
//

#import "AddFlashCardController.h"
#import "DatabaseModel.h"

@implementation AddFlashCardController
@synthesize databaseModel, subjectTitle;

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
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

#pragma  mark - IBActions
- (IBAction)addFlashCard:(id)sender
{
    int newlyGeneratedFlashCardId = 0; // get id of flash card to be inserted
    int subjectId = 0; // to be set to current subject id
    
    if(self.databaseModel == nil)
    {
        self.databaseModel = [[DatabaseModel alloc] init];
    }
    
    // try to insert flash card into flash card database
    BOOL success = [self.databaseModel insertFlashCardIntoFlashCards:titleField.text definition:definitionField.text];
    
    // get id of newly inserted flash card
    newlyGeneratedFlashCardId = [self.databaseModel selectIdFromFlashCardsWhere:titleField.text];
    
    // get subject id
    subjectId = [self.databaseModel selectIdFromSubjectsWhere:self.subjectTitle];
    
    BOOL doubleSucess = FALSE;
    
    // if successfully inserted flash card into database, insert row in flash_card_subjects table which serves
    // as a link table between flash cards and subjects
    if (success)
    {
        doubleSucess = [self.databaseModel insertFlashCardSubjectIntoFlashCardSubjects:newlyGeneratedFlashCardId subjectId:subjectId];
    }
    
    // after inserting into two different database tables, show results in a UIAlertView
    if (success && doubleSucess)
    {
        UIAlertView *alertOK = [[UIAlertView alloc] initWithTitle:@"Sucess!" message:@"Flash Card successfully added." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertOK show];
    }
    else
    {
        UIAlertView *alertOK = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An error occured creating your flash card." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertOK show];
    }
}

- (IBAction)dismissKeyboard:(id)sender
{
    [sender resignFirstResponder];
}

@end
