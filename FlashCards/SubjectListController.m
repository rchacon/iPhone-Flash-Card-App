//
//  SubjectListController.m
//  FlashCards
//
//  Created by Raul Chacon on 12/2/11.
//  Copyright (c) 2011 Student. All rights reserved.
//

#import "SubjectListController.h"
#import "DatabaseModel.h"
#import "SubjectsModel.h"
#import "FlashCardListController.h"


@implementation SubjectListController
@synthesize subjects, databaseModel, flashCardListController;

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
    
    if(self.databaseModel == nil)
    {
        self.databaseModel = [[DatabaseModel alloc] init];
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
    
    // fetch all subjects where is_hidden = false
    self.subjects = [self.databaseModel selectAllFromSubjectsWhereIsHidden:0];
    
    // reload table data. needed when returning to this view after creating a new subject
    [self.tableView reloadData];
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
    // if bar button pressed while editing, stop editing
	if(self.editing)
	{
		[super setEditing:NO animated:NO]; 
		[self.tableView setEditing:NO animated:NO];
		[self.tableView reloadData];
		[self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
		[self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
	}
    // if bar button pressed while not editing, turn editing on
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
    
    // if editing and table cell is last row 
    if (self.editing && (indexPath.row == self.subjects.count)) 
    {
		return UITableViewCellEditingStyleInsert;
	} 
    // if editing and table cell is not last row
    else if(self.editing && (indexPath.row != self.subjects.count))
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
        // set is_hidden bit in subject database table to true
        [self.databaseModel updateSubjectsIsHidden:1 subject:[[self.subjects objectAtIndex:indexPath.row] title]];
        
        // fetch all subjects where is_hidden = false
        self.subjects = [self.databaseModel selectAllFromSubjectsWhereIsHidden:0];
        [self.tableView reloadData];
    } 
    else if (editingStyle == UITableViewCellEditingStyleInsert) 
    {
        // take segue to add flash card view
        [self performSegueWithIdentifier:@"pushToAddSubject" sender:self];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Name";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // increase counter when in editing mode to display "add new subject" on last row
    int count = self.subjects.count;
    if(self.editing) count++;
    
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
	if((indexPath.row == self.subjects.count) && self.editing)
    {
		cell.textLabel.text = @"add a new subject";
		return cell;
	}
    
    // Configure the cell...
    cell.textLabel.text = [[self.subjects objectAtIndex:indexPath.row] title];
    
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
    // go to Flash Card List Controller
    FlashCardListController *listView = [self.storyboard instantiateViewControllerWithIdentifier:@"FlashCardListView"];
    [self.navigationController pushViewController:listView animated:YES];
    
    // set title of flash card view
    listView.title = [[self.subjects objectAtIndex:indexPath.row] title];
    
    // fetch flashcard for appropiate subject and should be displayed (is_hidden = 0)
    listView.flashCards = [self.databaseModel selectAllFromFlashCardsWhereIsHidden:0 
                                                                         subjectId: [[self.subjects objectAtIndex:indexPath.row] iD]];
    
    // pass subject title to flash card list controller
    [listView.parentSubjectTitle setString:[[self.subjects objectAtIndex:indexPath.row] title]];
}


@end
