//
//  AppDelegate.m
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

#import "AppDelegate.h"

@interface AppDelegate()

- (BOOL)isForstegangsOppstart;

@end

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    if([self isForstegangsOppstart])
    {
        NSLog(@"Førstegangsoppstart for appen - setter verdier i settings");
        NSURL * settingsURL = [[NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"Settings" withExtension:@"bundle"]] URLForResource:@"Root" withExtension:@"plist"];
        NSDictionary * settingsDictionary = [NSDictionary dictionaryWithContentsOfURL:settingsURL];
        NSArray * settingsArray = [settingsDictionary objectForKey:@"PreferenceSpecifiers"];
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        for(NSDictionary * setting in settingsArray)
        {
            NSString * key = [setting objectForKey:@"Key"];
            if(!key)
                continue;
            if(![defaults objectForKey:key])
                [defaults setObject:[setting objectForKey:@"DefaultValue"] forKey:key];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil
                                                         message:@"Inneholder data under norsk lisens for offentlige data (NLOD) tilgjengeliggjort av Statens vegvesen.\n\nDirections Courtesy of MapQuest (http://www.mapquest.com/)\n\nMå brukes på eget ansvar. Statens vegvesen, MapQuest eller Kjørehjelperen gir ingen garantier for eventuelle feil eller mangler i informasjonen som vises."
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [alert show];
    }
    
    return YES;
}

- (BOOL)isForstegangsOppstart
{
    NSString * testVerdi = [[NSUserDefaults standardUserDefaults] stringForKey:COREDATASIZE_BRUKERPREF];
    if(testVerdi == nil)
        return YES;
    return NO;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appDidBecomeActive" object:nil];
    
    unsigned long long coreDataSize = [[self coreDataSize] longLongValue];
    unsigned long long coreDataSizeLimit = [[self coreDataSizeLimit] longLongValue];
    
    if(coreDataSizeLimit > 0 && coreDataSize > coreDataSizeLimit)
    {
        coreDataSizeLimit = coreDataSizeLimit * 0.9;
        
        NSEntityDescription * veglenkeEntity = [NSEntityDescription entityForName:VEGLENKEDBSTATUS_CD
                                                           inManagedObjectContext:self.managedObjectContext];
        NSFetchRequest * request = [[NSFetchRequest alloc] init];
        NSSortDescriptor * sortStreng = [[NSSortDescriptor alloc] initWithKey:@"sistOppdatert" ascending:YES];
        NSArray * sortStrenger = [[NSArray alloc] initWithObjects:sortStreng, nil];
        
        [request setEntity:veglenkeEntity];
        [request setSortDescriptors:sortStrenger];
        [request setFetchLimit:1];
        
        NSError * feil;
        NSArray * eksisterende = [self.managedObjectContext executeFetchRequest:request error:&feil];
        
        if(feil)
        {
            NSLog(@"\n### Feil ved spørring mot Core Data: %@.\n### Sletter ingen rader fra databasen.", feil.description);
        }
        else
        {
            while(coreDataSize > coreDataSizeLimit && (eksisterende && [eksisterende count] > 0) && !feil)
            {
                for(VeglenkeDBStatus * x in eksisterende)
                {
                    NSLog(@"\n### Objekt funnet. Sist oppdatert: %@. VeglenkeID: %@.", x.sistOppdatert, x.veglenkeId);
                    [self.managedObjectContext deleteObject:x];
                
                    feil = nil;
                    [self.managedObjectContext save:&feil];
                
                    if(feil)
                        NSLog(@"\n### Feil ved sletting av objekt fra databasen:%@", feil.description);
                    else
                        NSLog(@"\n### Objekt ble slettet fra Core Data.");
                }
                coreDataSize = [[self coreDataSize] longLongValue];
                feil = nil;
                eksisterende = [self.managedObjectContext executeFetchRequest:request error:&feil];
            }
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Vegobjekter_CoreData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationLibraryCachesDirectory] URLByAppendingPathComponent:@"Vegdata.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSNumber *)coreDataSize
{
    NSArray * persistentStores = [self.persistentStoreCoordinator persistentStores];
    unsigned long long antallBytes = 0;
    NSFileManager * fileManager = [NSFileManager defaultManager];
    for(NSPersistentStore * store in persistentStores)
    {
        if(![store.URL isFileURL]) continue;
        NSString * path = [[store URL] path];
        antallBytes += [[fileManager attributesOfItemAtPath:path error:nil] fileSize];
    }
    return [[NSNumber alloc] initWithLongLong:antallBytes];
}

- (NSNumber *)coreDataSizeLimit
{
    int CDSizeLimit = [[NSUserDefaults standardUserDefaults] integerForKey:COREDATASIZE_BRUKERPREF];
    CDSizeLimit = CDSizeLimit * 1024 * 1024;
    return [[NSNumber alloc] initWithInteger:CDSizeLimit];
}

#pragma mark - Application's Library/Caches directory

- (NSURL *)applicationLibraryCachesDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
