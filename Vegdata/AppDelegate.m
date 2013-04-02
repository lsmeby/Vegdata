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

@implementation AppDelegate

- (NSManagedObjectContext *) managedObjectContext
{
    if (self.managedObjectContext != nil)
        return self.managedObjectContext;
    
    NSPersistentStoreCoordinator * coordinator = [self persistentStoreCoordinator];
    
    if(coordinator != nil)
    {
        self.managedObjectContext = [[NSManagedObjectContext alloc] init];
        [self.managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return self.managedObjectContext;
}

- (NSManagedObjectModel *) managedObjectModel
{
    if(self.managedObjectModel != nil)
        return self.managedObjectModel;
    
    self.managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] init];
    return self.managedObjectModel;
}

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator
{
    if(self.persistentStoreCoordinator != nil)
        return self.persistentStoreCoordinator;
    
    NSURL * storeUrl = [NSURL fileURLWithPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Vegdata.sqlite"]];
    
    self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSError * error = nil;
    
    if(![self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error])
        NSLog(@"\n### Feil: %@", error.description);
    
    return self.persistentStoreCoordinator;
}

- (NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) lastObject];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSString * testVerdi = [[NSUserDefaults standardUserDefaults] stringForKey:@"varslingsavstand"];
    if(testVerdi == nil)
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
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
