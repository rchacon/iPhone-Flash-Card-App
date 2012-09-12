//
//  SubjectsModel.m
//  FlashCards
//
//  Created by Raul Chacon on 12/2/11.
//  Copyright (c) 2011 Student. All rights reserved.
//

#import "SubjectsModel.h"

@implementation SubjectsModel
@synthesize iD, title, isHidden, insertDate;

- (id) initWithId: (int) aId title: (NSString *) aTitle isHidden: (int) isHiddenBit insertDate: (NSString *) aInsertDate
{
    self.iD = aId;
    self.title = aTitle;
    self.isHidden = isHiddenBit;
    self.insertDate = aInsertDate;
    
    return self;
}

@end
