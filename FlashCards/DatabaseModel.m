//
//  DatabaseModel.m
//  FlashCards
//
//  Created by Raul Chacon on 12/2/11.
//  Copyright (c) 2011 Student. All rights reserved.
//

#import "DatabaseModel.h"
#import "SubjectsModel.h"
#import "FlashCardModel.h"

@implementation DatabaseModel

- (id)init
{
    self = [super init];
    
    if (self) 
    {
        dbName = @"istudy.sqlite";
        
        // copy sqlite file to device if it doesn't already exist
        [self createDB];
    }
    
    return self;
}

// called by init method to create sqlite file if it doesn't already exist
- (void) createDB
{
    BOOL success;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writeableDBPath = [documentsDirectory stringByAppendingPathComponent:dbName];
    
    success = [fileManager fileExistsAtPath:writeableDBPath];
    
    if(success)
    {
        NSLog(@"makeDBCopyAsNeeded - success!");
        return;
    }
    
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
    
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writeableDBPath error:&error];
    
    if(!success)
    {
        NSLog(@"fail");
        NSAssert1(0, @"Failed to create writeable database with message '%@'.", [error localizedDescription]);
    }
}


#pragma mark - Selects

// fetch all subjects from database where is_hidden is 0 or 1
// is_hidden is 0 by default. can be toggled to 1 if deleted by user
- (NSMutableArray*) selectAllFromSubjectsWhereIsHidden: (int) isHidden
{
    subjects = [[NSMutableArray alloc] init ];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent: dbName];
    
    NSLog(@"databasePath = %@", databasePath);
    
    if(sqlite3_open([databasePath UTF8String], &dbHandle) == SQLITE_OK)
    {
        NSString *sql = [NSString stringWithFormat:@"select * from subjects where is_hidden = %d", isHidden];
        
        const char *sqlStatment = [sql UTF8String];
        
        sqlite3_stmt *searchStatement;
        
        if(sqlite3_prepare_v2(dbHandle, sqlStatment, -1, &searchStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(searchStatement) == SQLITE_ROW)
            {
                int aId = (int)sqlite3_column_int64(searchStatement, 0);
                NSString *aTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStatement, 1)];
                int isHiddenBit = (int)sqlite3_column_int64(searchStatement, 2);
                NSString *aInsertDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStatement, 3)];
                
                SubjectsModel *subject = [[SubjectsModel alloc] initWithId:aId title:aTitle isHidden:isHiddenBit insertDate:aInsertDate];
                
                [subjects addObject:subject];
            }
        }
        
        sqlite3_finalize(searchStatement);
    }
    else
    {
        NSLog(@"Failed to open database at %@ with error '%s'", databasePath, sqlite3_errmsg(dbHandle));
        NSLog(@"THIS HAPPENED - %@", sqlite3_open([databasePath UTF8String], &dbHandle));
    }
    
    sqlite3_close (dbHandle);
    
    return subjects;
    
}


// fetch all flash cards from database where is_hidden is 0 or 1
// is_hidden is 0 by default. can be toggled to 1 if deleted by user
- (NSMutableArray*) selectAllFromFlashCardsWhereIsHidden: (int)isHidden
{
    NSLog(@"getAllFlashCards");
    flashCards = [[NSMutableArray alloc] init ];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent: dbName];
    
    NSLog(@"databasePath = %@", databasePath);
    
    if(sqlite3_open([databasePath UTF8String], &dbHandle) == SQLITE_OK)
    {        
        NSString *sql = [NSString stringWithFormat:@"select * from flash_cards where is_hidden = %d", isHidden];
        
        const char *sqlStatment = [sql UTF8String];
        
        sqlite3_stmt *searchStatement;
        
        if(sqlite3_prepare_v2(dbHandle, sqlStatment, -1, &searchStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(searchStatement) == SQLITE_ROW)
            {
                int aId = (int)sqlite3_column_int64(searchStatement, 0);
                NSString *aTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStatement, 1)];
                NSString *aDefinition = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStatement, 2)];
                int isHidden = (int)sqlite3_column_int64(searchStatement, 3);
                NSString *aInsertDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStatement, 4)];
                
                FlashCardModel *flashCard = [[FlashCardModel alloc] initWithId:aId title:aTitle definition:aDefinition isHidden:isHidden insertDate:aInsertDate];
                
                [flashCards addObject:flashCard];
                NSLog(@"%@ = %@", aTitle, aDefinition);
            }
        }
        
        sqlite3_finalize(searchStatement);
    }
    else
    {
        NSLog(@"Failed to open database at %@ with error '%s'", databasePath, sqlite3_errmsg(dbHandle));
        NSLog(@"THIS HAPPENED - %@", sqlite3_open([databasePath UTF8String], &dbHandle));
    }
    
    sqlite3_close (dbHandle);
    
    return flashCards;
    
}

// fetch all flash cards from database where is_hidden is 0 or 1
// is_hidden is 0 by default. can be toggled to 1 if deleted by user
// where clause expanded to include subject title. flash cards are grouped by subject
- (NSMutableArray*) selectAllFromFlashCardsWhereIsHidden:(int)isHidden subjectId: (int)subjectId
{
    flashCards = [[NSMutableArray alloc] init ];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent: dbName];
    
    NSLog(@"databasePath = %@", databasePath);
    
    if(sqlite3_open([databasePath UTF8String], &dbHandle) == SQLITE_OK)
    {
        NSString *sql = [NSString stringWithFormat:@"select * from flash_cards where is_hidden = %d and id in (select flash_card_id from flash_card_subjects where subject_id = %d)", isHidden, subjectId];
        
        const char *sqlStatment = [sql UTF8String];
        
        sqlite3_stmt *searchStatement;
        
        if(sqlite3_prepare_v2(dbHandle, sqlStatment, -1, &searchStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(searchStatement) == SQLITE_ROW)
            {
                int aId = (int)sqlite3_column_int64(searchStatement, 0);
                NSString *aTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStatement, 1)];
                NSString *aDefinition = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStatement, 2)];
                int isHiddenBit = (int)sqlite3_column_int64(searchStatement, 3);
                NSString *aInsertDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStatement, 4)];
                
                FlashCardModel *flashCard = [[FlashCardModel alloc] initWithId:aId title:aTitle definition:aDefinition isHidden:isHiddenBit insertDate:aInsertDate];
                
                [flashCards addObject:flashCard];
                NSLog(@"%@ = %@", aTitle, aDefinition);
            }
        }
        
        sqlite3_finalize(searchStatement);
    }
    else
    {
        NSLog(@"Failed to open database at %@ with error '%s'", databasePath, sqlite3_errmsg(dbHandle));
        NSLog(@"THIS HAPPENED - %@", sqlite3_open([databasePath UTF8String], &dbHandle));
    }
    
    sqlite3_close (dbHandle);
    
    return flashCards;
    
}

// select id from flash card table where flash card title is @param flashCardTitle
- (int) selectIdFromFlashCardsWhere:(NSString *)flashCardTitle
{   
    int flashCardId = 0;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent: dbName];
    
    NSLog(@"databasePath = %@", databasePath);
    
    if(sqlite3_open([databasePath UTF8String], &dbHandle) == SQLITE_OK)
    {
        NSString *sql = [NSString stringWithFormat:@"select id from flash_cards where title = '%@'", flashCardTitle];
        
        NSLog(@"sql = %@", sql);
        
        const char *sqlStatment = [sql UTF8String];
        
        sqlite3_stmt *searchStatement;
        
        if(sqlite3_prepare_v2(dbHandle, sqlStatment, -1, &searchStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(searchStatement) == SQLITE_ROW)
            {
                flashCardId = (int)sqlite3_column_int64(searchStatement, 0);
                NSLog(@"answer is: %d", flashCardId);
            }
        }
        
        sqlite3_finalize(searchStatement);
    }
    else
    {
        NSLog(@"Failed to open database at %@ with error '%s'", databasePath, sqlite3_errmsg(dbHandle));
        NSLog(@"THIS HAPPENED - %@", sqlite3_open([databasePath UTF8String], &dbHandle));
    }
    
    sqlite3_close (dbHandle);
    
    return flashCardId;
    
}

// select id from subjects table where flash card title is @param subjectTitle
- (int) selectIdFromSubjectsWhere:(NSString *)subjectTitle
{   
    int subjectId = 0;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent: dbName];
    
    NSLog(@"databasePath = %@", databasePath);
    
    if(sqlite3_open([databasePath UTF8String], &dbHandle) == SQLITE_OK)
    {
        NSString *sql = [NSString stringWithFormat:@"select * from subjects where title = '%@'", subjectTitle];
        
        NSLog(@"sql = %@", sql);
        
        const char *sqlStatment = [sql UTF8String];
        
        sqlite3_stmt *searchStatement;
        
        if(sqlite3_prepare_v2(dbHandle, sqlStatment, -1, &searchStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(searchStatement) == SQLITE_ROW)
            {
                subjectId = (int)sqlite3_column_int64(searchStatement, 0);
                NSLog(@"subjectId queried: %d", (int)sqlite3_column_text(searchStatement, 0));
            }
        }
        
        sqlite3_finalize(searchStatement);
    }
    else
    {
        NSLog(@"Failed to open database at %@ with error '%s'", databasePath, sqlite3_errmsg(dbHandle));
        NSLog(@"THIS HAPPENED - %@", sqlite3_open([databasePath UTF8String], &dbHandle));
    }
    
    sqlite3_close (dbHandle);
    
    return subjectId;
    
}

#pragma mark - Inserts


// insert subject into subjects table with @param title
- (BOOL) insertSubjectIntoSubjects: (NSString *)title
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent: dbName];
    
    NSString *todaysDate = @"12-12-2011";
    
    if(sqlite3_open([databasePath UTF8String], &dbHandle) == SQLITE_OK)
    {
        NSString *sql = [NSString stringWithFormat:@"insert into subjects values (NULL, '%@', 0, '%@')", title, todaysDate];
        
        const char *sqlStatment = [sql UTF8String];
        
        sqlite3_stmt *insertStatement;
        
        if(sqlite3_prepare_v2(dbHandle, sqlStatment, -1, &insertStatement, NULL) == SQLITE_OK)
        {
            if (SQLITE_DONE != sqlite3_step(insertStatement))
            {
                return FALSE;
            }
            else // success!
            {
                return TRUE;
            }
        }
    }
    
    return FALSE;
}


// insert flash card into flash cards table with @param title and @param definition
- (BOOL) insertFlashCardIntoFlashCards: (NSString *)title definition: (NSString *) definition
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent: dbName];
    
    NSString *todaysDate = @"12-12-2011";
    
    if(sqlite3_open([databasePath UTF8String], &dbHandle) == SQLITE_OK)
    {
        NSString *sql = [NSString stringWithFormat:@"insert into flash_cards values (NULL, '%@','%@', 0,'%@')", title, definition, todaysDate];
        
        const char *sqlStatment = [sql UTF8String];
        
        sqlite3_stmt *insertStatement;
        
        if(sqlite3_prepare_v2(dbHandle, sqlStatment, -1, &insertStatement, NULL) == SQLITE_OK)
        {
            if (SQLITE_DONE != sqlite3_step(insertStatement))
            {
                return FALSE;
            }
            else // success!
            {
                return TRUE;
            }
        }
    }
    
    return FALSE;
}


// insert flash card and subject id's into flash_card_subjects link table which allows many-to-many relationship
- (BOOL) insertFlashCardSubjectIntoFlashCardSubjects: (int)flashCardId subjectId: (int) subjectId
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent: dbName];
    
    NSString *todaysDate = @"12-03-2011";
    
    if(sqlite3_open([databasePath UTF8String], &dbHandle) == SQLITE_OK)
    {
        NSString *sql = [NSString stringWithFormat:@"insert into flash_card_subjects values (NULL, %d, %d, '%@')", flashCardId, subjectId, todaysDate];
        
        const char *sqlStatment = [sql UTF8String];
        
        sqlite3_stmt *insertStatement;
        
        if(sqlite3_prepare_v2(dbHandle, sqlStatment, -1, &insertStatement, NULL) == SQLITE_OK)
        {
            if (SQLITE_DONE != sqlite3_step(insertStatement))
            {
                return FALSE;
            }
            else // success!
            {
                return TRUE;
            }
        }
    }
    
    return FALSE;
}

#pragma mark - Updates

// update isHidden bit in flash_card database table to either 1(hidden) or 1(visible)
- (BOOL) updateFlashCardsIsHidden:(int)bit flashCard:(NSString *)flashCard
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent: dbName];
    
    if(sqlite3_open([databasePath UTF8String], &dbHandle) == SQLITE_OK)
    {
        NSString *sql = [NSString stringWithFormat:@"update flash_cards set is_hidden = %d where title = '%@'", bit, flashCard];
        
        const char *sqlStatment = [sql UTF8String];
        
        sqlite3_stmt *updateStatement;
        
        if(sqlite3_prepare_v2(dbHandle, sqlStatment, -1, &updateStatement, NULL) == SQLITE_OK)
        {
            if (SQLITE_DONE != sqlite3_step(updateStatement))
            {
                return FALSE;
            }
            else // success!
            {
                return TRUE;
            }
        }
    }
    
    return FALSE;
}

// update isHidden bit in subjects database table to either 1(hidden) or 1(visible)
- (BOOL) updateSubjectsIsHidden:(int)bit subject:(NSString *)title
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent: dbName];
    
    if(sqlite3_open([databasePath UTF8String], &dbHandle) == SQLITE_OK)
    {
        NSString *sql = [NSString stringWithFormat:@"update subjects set is_hidden = %d where title = '%@'", bit, title];
        
        const char *sqlStatment = [sql UTF8String];
        
        sqlite3_stmt *updateStatement;
        
        if(sqlite3_prepare_v2(dbHandle, sqlStatment, -1, &updateStatement, NULL) == SQLITE_OK)
        {
            if (SQLITE_DONE != sqlite3_step(updateStatement))
            {
                return FALSE;
            }
            else // success!
            {
                return TRUE;
            }
        }
    }
    
    return FALSE;
}

@end
