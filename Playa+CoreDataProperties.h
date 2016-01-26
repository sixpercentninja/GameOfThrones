//
//  Playa+CoreDataProperties.h
//  GameOfThrones
//
//  Created by Andrew Chen on 1/26/16.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Playa.h"

NS_ASSUME_NONNULL_BEGIN

@interface Playa (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *group;
@property (nullable, nonatomic, retain) NSString *singer;

@end

NS_ASSUME_NONNULL_END
