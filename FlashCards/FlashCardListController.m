//
//  FlashCardListController.m
//  FlashCards
//
//  Created by Raul Chacon on 12/2/11.
//  Copyright (c) 2011 Student. All rights reserved.
//

#import "FlashCardListController.h"
#import "DatabaseModel.h"
#import "AddFlashCardController.h"
#import "FlashCardFrontSideController.h"
#import "FlashCardModel.h"


@implementation FlashCardListController
@synthesize flashCards, databaseModel, parentSubjectTitle, needsRefresh;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

- (void)viewDidLoad
{
    [super viewDidLoad];

    // create database model if not already created
    if(self.databaseModel == nil)
    {
        self.databaseModel = [[DatabaseModel alloc] init];
    }
    
    // create flash card model if not already created
    if (self.flashCards == nil)
    {
        self.flashCards = [[NSMutableArray alloc] init ];
    }
    
    if (self.parentSubjectTitle == nil)
    {
        self.parentSubjectTitle = [[NSMutableString alloc] init];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // if returning from add flash card view refresh to show newly added flash card
    if(self.needsRefresh == 1)
    {
        int parentSubjectId = [self.databaseModel selectIdFromSubjectsWhere:self.parentSubjectTitle];
        self.flashCards = [self.databaseModel selectAllFromFlashCardsWhereIsHidden:0 subjectId:parentSubjectId];
        
        [self.tableView reloadData];
        
        self.needsRefresh = 0;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (IBAction) editButtonPressed:(id)sender
{
	if(self.editing)
	{
		[super setEditing:NO animated:NO]; 
		[self.tableView setEditing:NO animated:NO];
		[self.tableView reloadData];
		[self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
		[self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
	}
	else
	{
		[super setEditing:YES animated:YES]; 
		[self.tableView setEditing:YES animated:YES];
		[self.tableView reloadData];
		[self.navigationItem.rightBarButtonItem setTitle:@"Done"];
		[self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
	}    
}

// The editing style for a row is the kind of button displayed to the left of the cell when in editing mode.
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // No editing style if not editing or the index path is nil.
    if (self.editing == NO || !indexPath) 
        return UITableViewCellEditingStyleNone;
    
    // Determine if editing style should be to delete or insert   
    if (self.editing && (indexPath.row == self.flashCards.count)) 
    {
		return UITableViewCellEditingStyleInsert;
	} 
    else 
    {
		return UITableViewCellEditingStyleDelete;
	}
    
    return UITableViewCellEditingStyleNone;
}

// Update the data model according to edit actions delete or insert.
- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (editingStyle == UITableViewCellEditingStyleDelete) 
    {
        // update is_hidden bit in database
        [self.databaseModel updateFlashCardsIsHidden:1 flashCard:[[self.flashCards objectAtIndex:indexPath.row] title]];
        
        // update flash cards array to reflect relevant flash cards after deletion
        int parentSubjectId = [self.databaseModel selectIdFromSubjectsWhere:self.parentSubjectTitle];
        self.flashCards = [self.databaseModel selectAllFromFlashCardsWhereIsHidden:0 subjectId:parentSubjectId];
		[self.tableView reloadData];
    } 
    else if (editingStyle == UITableViewCellEditingStyleInsert) 
    {
        // take segue to add flash card view
        [self performSegueWithIdentifier:@"pushToAddFlashCard" sender:self];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Flash Cards";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = self.flashCards.count;
    
    if (self.editing) count++;
        
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.editingAccessoryType = NO;
    }
    
    // Set up last cell and if in editing mode, to allow creation of new row
	if((indexPath.row == self.flashCards.count) && self.editing)
    {
		cell.textLabel.text = @"add a new flash card";
		return cell;
	}
    
    // Configure the cell...
    cell.textLabel.text = [[self.flashCards objectAtIndex:indexPath.row] title];
    
    // add disclosure button
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // take seque to Flash Card Front Side Controller
    FlashCardFrontSideController *frontSideController = [self.storyboard instantiateViewControllerWithIdentifier:@"FlashCardFrontSideController"];
    [self.navigationController pushViewController:frontSideController animated:YES];

    // set label text of front side controller        
    frontSideController.frontSideLabel.text = [[self.flashCards objectAtIndex:indexPath.row] title];
    
    if(frontSideController.stringForFrontSideToPassToBackSide == nil)
    {
        frontSideController.stringForFrontSideToPassToBackSide = [[NSMutableString alloc] init];
    }
    
    // pass definition (rear side of flash card) to front side controller to then pass to rear side
    [frontSideController.stringForFrontSideToPassToBackSide setString:[[self.flashCards objectAtIndex:indexPath.row] getDefinition]];
    
    
    // pass subject title to front side controller
    if(frontSideController.subjectTitleFromFlashCardList == nil)
    {
        frontSideController.subjectTitleFromFlashCardList = [[NSMutableString alloc] init];
    }
    [frontSideController.subjectTitleFromFlashCardList setString:self.parentSubjectTitle];
    NSLog(@"FlashCardListController: title to pass to front: %@", frontSideController.subjectTitleFromFlashCardList);
    
    // pass selected flash card id to front side controller
    frontSideController.flashCardPosition = indexPath.row;
    
}

// pass title of subject to add flash card controller. 
// this is needed for linking a flash card to a subject in the database
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    self.needsRefresh = 1;
    NSLog(@"segue identifier is: %@", [segue identifier]);
    
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"pushToAddFlashCard"])
    {
        // Get reference to the destination view controller
        AddFlashCardController *addFlashCard = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        addFlashCard.subjectTitle = self.title;
    }
}

- (IBAction)dismissKeyboard:(id)sender
{
    [sender resignFirstResponder];
}


@end
