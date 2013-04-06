//
//  NVDB_DataProvider.m
//  Vegdata
//
//  Created by Lars Smeby on 20.02.13.
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

#import "NVDB_DataProvider.h"
#import "NVDB_RESTkit.h"
#import "Vegreferanse.h"
#import "Sok.h"
#import "Veglenke.h"
#import "CD_Fartsgrense.h"

static NSString * const NVDB_GEOMETRI = @"WGS84";
static double const WGS84_BBOX_RADIUS = 0.0001;

@interface NVDB_DataProvider()
- (void)hentVegObjekterFraNVDBMedSokeObjekt:(Sok *)sok OgMapping:(RKMapping *)mapping;
- (void)hentVegObjekterFraCoreDataMedVeglenkeId:(NSNumber *)id;
+ (NSDictionary *)parametereForKoordinaterMedBreddegrad:(NSDecimalNumber *)breddegrad OgLengdegrad:(NSDecimalNumber *)lengdegrad;
+ (NSDictionary *)parametereForBoundingBoxMedBreddegrad:(NSDecimalNumber *)breddegrad OgLengdegrad:(NSDecimalNumber *)lengdegrad;
+ (NSDictionary *)parametereForSok:(Sok *)sok;
@end

@implementation NVDB_DataProvider
{
    NVDB_RESTkit * restkit;
    id delegate;
}

@synthesize fetchedResultsController, managedObjectContext;

- (id)initMedManagedObjectContext:(NSManagedObjectContext *)context OgAvsender:(NSObject *)aAvsender
{
    fetchedResultsController = [[NSFetchedResultsController alloc] init];
    managedObjectContext = context;
    restkit = [NVDB_RESTkit alloc];
    restkit.delegate = self;
    delegate = aAvsender;
    
    return self;
}

- (void)hentVegreferanseMedBreddegrad:(NSDecimalNumber *)breddegrad OgLengdegrad:(NSDecimalNumber *)lengdegrad
{
    [restkit hentDataMedURI:[Vegreferanse getURI]
                 Parametere:[NVDB_DataProvider parametereForKoordinaterMedBreddegrad:breddegrad
                                                                        OgLengdegrad:lengdegrad]
                    Mapping:[Vegreferanse mapping]
                  OgkeyPath:[Vegreferanse getKeyPath]];
}

- (void)hentVegObjekterMedSokeObjekt:(Sok *)sok OgMapping:(RKMapping *)mapping
{
    //Veglenke * lenke = (Veglenke *)sok.veglenker[0];
    //if(lenke.lenkeId.intValue)
    
    [self hentVegObjekterFraNVDBMedSokeObjekt:sok OgMapping:mapping];
}

- (void)hentVegObjekterFraNVDBMedSokeObjekt:(Sok *)sok OgMapping:(RKMapping *)mapping
{
    [restkit hentDataMedURI:[Sok getURI]
                 Parametere:[NVDB_DataProvider parametereForSok:sok]
                    Mapping:mapping
                  OgkeyPath:[Sok getKeyPath]];
}

- (void)hentVegObjekterFraCoreDataMedVeglenkeId:(NSNumber *)id
{
    CD_Fartsgrense * test;
    
}

#pragma mark - NVDBResponseDelegate

- (void)svarFraNVDBMedResultat:(NSArray *)resultat
{
    if(!(resultat == nil || resultat.count == 0 || [resultat[0] isKindOfClass:[Vegreferanse class]]))
    {
        // Lagre til Core Data
    }
    
    [delegate svarFraNVDBMedResultat:resultat];
}

#pragma mark - Statiske hjelpemetoder

+ (NSDictionary *)parametereForKoordinaterMedBreddegrad:(NSDecimalNumber *)breddegrad OgLengdegrad:(NSDecimalNumber *)lengdegrad
{
    return @{@"y" : breddegrad.stringValue, @"x" : lengdegrad.stringValue, @"srid" : NVDB_GEOMETRI};
}

+ (NSDictionary *)parametereForBoundingBoxMedBreddegrad:(NSDecimalNumber *)breddegrad OgLengdegrad:(NSDecimalNumber *)lengdegrad
{
    NSDecimalNumber * bboxRadius = [[NSDecimalNumber alloc] initWithDouble:WGS84_BBOX_RADIUS];
    
    NSString * bboxString = [[NSArray arrayWithObjects:[lengdegrad decimalNumberBySubtracting:bboxRadius],
                              [breddegrad decimalNumberBySubtracting:bboxRadius],
                              [lengdegrad decimalNumberByAdding:bboxRadius],
                              [breddegrad decimalNumberByAdding:bboxRadius],
                              nil] componentsJoinedByString:@","];
    
    return @{@"bbox" : bboxString, @"srid" : NVDB_GEOMETRI};
}

+ (NSDictionary *)parametereForSok:(Sok *)sok
{
    
//    NSDictionary * sokDic = @{@"objektTyper" : @"[{id:105, antall:2}]"};
//    NSArray * sokArray = [[NSArray alloc] initWithObjects:sok, nil];
//    NSData * test = [NSJSONSerialization dataWithJSONObject:sokDic options:NSJSONWritingPrettyPrinted error:nil];
//    NSString * test2 = [[NSString alloc] initWithData:test encoding:NSUTF8StringEncoding];
//    NSLog(@"\n test: %@ \n test2: %@", test, test2);
    NSMutableArray * veglenker = [[NSMutableArray alloc] init];
    for(Veglenke * v in sok.veglenker)
    {
        NSString * veglenke = [NSString stringWithFormat:@"{id:%@, fra:0, til:1}",
                               v.lenkeId.stringValue];
        [veglenker addObject:veglenke];
    }
    NSString * veglenkestring = [veglenker componentsJoinedByString:@","];
    
    NSMutableArray * objekttyper = [[NSMutableArray alloc] init];
    for(Objekttype * o in sok.objektTyper)
    {
        NSMutableArray * filtere = [[NSMutableArray alloc] init];
        for(Filter * f in o.filtere)
        {
            NSMutableArray * verdier = [[NSMutableArray alloc] init];
            for(NSString * verdi in f.verdier)
                [verdier addObject:[NSString stringWithFormat:@"\"%@\"",verdi]];
            NSString * verdistring = [verdier componentsJoinedByString:@","];
            
            NSString * filter = [NSString stringWithFormat:@"{ type: \"%@\", operator: \"%@\", verdi: [%@]}",
                                 f.type,
                                 f.filterOperator,
                                 verdistring];
            [filtere addObject:filter];
        }
        NSString * filterstring = [filtere componentsJoinedByString:@","];
        NSString * objekttype = [NSString stringWithFormat:@"{id:%@, antall:%@, filter: [%@]}",
                                 o.typeId.stringValue,
                                 o.antall.stringValue,
                                 filterstring];
        [objekttyper addObject:objekttype];
    }
    NSString * objekttypestring = [objekttyper componentsJoinedByString:@","];
    
    NSString * kriterie = [NSString stringWithFormat:@"{lokasjon: {veglenker: [%@]}, objektTyper:[%@]}",
                           veglenkestring,
                           objekttypestring];

//    NSString * kriterie = [NSString stringWithFormat:@"{lokasjon: {bbox: \"59.880965,10.824816,59.880966,10.824817\", srid: \"WGS84\"}, objektTyper:[%@]}",
//                           objekttypestring];
    
    return @{@"kriterie" : kriterie};
    
    //return @{@"kriterie" : @"{lokasjon: {veglenker: [{id:443636, fra:0, til:1}]}, objektTyper:[{id:105, antall:0}]}"};
}

@end
