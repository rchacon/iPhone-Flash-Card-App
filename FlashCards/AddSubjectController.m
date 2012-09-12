//
//  AddSubjectController.m
//  FlashCards
//
//  Created by Raul Chacon on 12/3/11.
//  Copyright (c) 2011 Student. All rights reserved.
//

#import "AddSubjectController.h"
#import "DatabaseModel.h"

@implementation AddSubjectController
@synthesize databaseModel;


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

#pragma mark - IBActions
- (IBAction)addSubject:(id)sender
{
    //NSLog(@"you entered: '%@' and '%@'", titleField.text, notesField.text);
    if(self.databaseModel == nil)
    {
        self.databaseModel = [[DatabaseModel alloc] init];
    }
    
    // try to insert subject into subjects
    BOOL success = [self.databaseModel insertSubjectIntoSubjects:titleField.text];
    
    // show UIAlertView after insertion whether succesfull or not
    if (success)
    {
        UIAlertView *alertOK = [[UIAlertView alloc] initWithTitle:@"Sucess!" message:@"Subject successfully added." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertOK show];
    }
    else
    {
        UIAlertView *alertOK = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An error occured inserting the Subject." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertOK show];
    }
}

- (IBAction)dismissKeyboard:(id)sender
{
    [sender resignFirstResponder];
}

@end
