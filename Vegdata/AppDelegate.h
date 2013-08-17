//
//  AppDelegate.h
//  Vegdata
//
//  Created by Lars Smeby on 14.02.13.
//
//  Copyright (C) 2013  Henrik Hermansen og Lars Smeby
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import <UIKit/UIKit.h>
#import "VeglenkeDBStatus.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) NSManagedObjectModel * managedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext * managedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator * persistentStoreCoordinator;

@property (strong, nonatomic) UIWindow *window;

- (void)saveContext;
- (NSNumber *)coreDataSize;
- (NSNumber *)coreDataSizeLimit;
- (NSURL *)applicationLibraryCachesDirectory; 

@end
