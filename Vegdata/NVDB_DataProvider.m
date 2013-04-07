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

#import <CoreData/CoreData.h>
#import "NVDB_DataProvider.h"
#import "NVDB_RESTkit.h"

// NVDBObjekter
#import "Fartsgrense.h"
#import "Forkjorsveg.h"
#import "Vilttrekk.h"
#import "Fartsdemper.h"
#import "Hoydebegrensning.h"
#import "Jernbanekryssing.h"
#import "Vegreferanse.h"
#import "Sok.h"
#import "Veglenke.h"
#import "Egenskap.h"
#import "SokResultater.h"
#import "GoogleMapsAvstand.h"

// Core Data
#import "VeglenkeDBStatus.h"
#import "CD_Vegobjekt.h"
#import "CD_Egenskap.h"
#import "CD_Veglenke.h"
#import "CD_PunktObjekt.h"
#import "CD_LinjeObjekt.h"
#import "CD_Fartsdemper.h"
#import "CD_Hoydebegrensning.h"
#import "CD_Jernbanekryssing.h"
#import "CD_Fartsgrense.h"
#import "CD_Forkjorsvei.h"
#import "CD_Vilttrekk.h"

static NSString * const NVDB_GEOMETRI = @"WGS84";
static double const WGS84_BBOX_RADIUS = 0.0001;
static double const SEKUNDER_PER_DAG = 86400;
static int const DAGER_MELLOM_NY_OPPDATERING = 30;

@interface NVDB_DataProvider()
- (void)hentVegObjekterFraNVDBMedSokeObjekt:(Sok *)sok OgMapping:(RKMapping *)mapping;
- (void)hentVegObjekterFraCoreDataMedVeglenkeCDObjekt:(VeglenkeDBStatus *)vlenke;
+ (NSDictionary *)parametereForKoordinaterMedBreddegrad:(NSDecimalNumber *)breddegrad OgLengdegrad:(NSDecimalNumber *)lengdegrad;
+ (NSDictionary *)parametereForBoundingBoxMedBreddegrad:(NSDecimalNumber *)breddegrad OgLengdegrad:(NSDecimalNumber *)lengdegrad;
+ (NSDictionary *)parametereForGoogleMapsAvstandMedAX:(NSDecimalNumber *)ax AY:(NSDecimalNumber *)ay BX:(NSDecimalNumber *)bx OgBY:(NSDecimalNumber *)by;
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
                    KeyPath:[Vegreferanse getKeyPath]
               OgVeglenkeId:nil];
}

- (void)hentVegObjekterMedSokeObjekt:(Sok *)sok OgMapping:(RKMapping *)mapping
{
    NSEntityDescription * veglenkeEntity = [NSEntityDescription entityForName:@"VeglenkeDBStatus"
                                                       inManagedObjectContext:managedObjectContext];
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:veglenkeEntity];
    
    NSNumber * vlenke = ((Veglenke *)sok.veglenker[0]).lenkeId;
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"(veglenkeId == %@)", vlenke];
    [request setPredicate:predicate];
    
    NSError * feil;
    NSArray * resultat = [managedObjectContext executeFetchRequest:request error:&feil];
    
    if(feil || !resultat || [resultat count] == 0)
    {
        if(feil)
            NSLog(@"\n### Feil ved spørring mot Core Data: %@", feil.description);
        NSLog(@"\n### Fant ikke veglenken i databasen, spør mot NVDB.");
    }
    else
    {
        VeglenkeDBStatus * vlenkeDB = (VeglenkeDBStatus *)resultat[0];
        if([vlenkeDB.sistOppdatert timeIntervalSinceNow] / SEKUNDER_PER_DAG > (- DAGER_MELLOM_NY_OPPDATERING))
        {
            [self hentVegObjekterFraCoreDataMedVeglenkeCDObjekt:vlenkeDB];
            return;
        }
        NSLog(@"\n### Lagrede data er eldre enn %d dager, spør mot NVDB.", DAGER_MELLOM_NY_OPPDATERING);
    }
    
    [self hentVegObjekterFraNVDBMedSokeObjekt:sok OgMapping:mapping];
}

- (void)hentAvstandmedKoordinaterAX:(NSDecimalNumber *)ax AY:(NSDecimalNumber *)ay BX:(NSDecimalNumber *)bx BY:(NSDecimalNumber *)by ogKey:(NSString *)key
{
    [restkit hentAvstandMellomKoordinaterMedParametere:[NVDB_DataProvider parametereForGoogleMapsAvstandMedAX:ax
                                                                                                           AY:ay
                                                                                                           BX:bx
                                                                                                         OgBY:by]
                                               Mapping:[GoogleMapsAvstand mapping]
                                                 OgKey:key];
}

- (void)hentVegObjekterFraNVDBMedSokeObjekt:(Sok *)sok OgMapping:(RKMapping *)mapping
{
    [restkit hentDataMedURI:[Sok getURI]
                 Parametere:[NVDB_DataProvider parametereForSok:sok]
                    Mapping:mapping
                    KeyPath:[Sok getKeyPath]
               OgVeglenkeId:((Veglenke *)sok.veglenker[0]).lenkeId];
}

- (void)hentVegObjekterFraCoreDataMedVeglenkeCDObjekt:(VeglenkeDBStatus *)vlenke
{
    NSArray * objekter = [vlenke.vegobjekter allObjects];
    
    if(!objekter)
    {
        NSLog(@"\n### Feil: Veglenkeobjektet fra Core Data inneholder ingen objekter.");
        return;
    }
    
    NSMutableArray * fartsgrenser = [[NSMutableArray alloc] init];
    NSMutableArray * forkjorsveier = [[NSMutableArray alloc] init];
    NSMutableArray * vilttrekk = [[NSMutableArray alloc] init];
    NSMutableArray * fartsdempere = [[NSMutableArray alloc] init];
    NSMutableArray * hoydebegrensninger = [[NSMutableArray alloc] init];
    NSMutableArray * jernbanekryssinger = [[NSMutableArray alloc] init];
    
    for(CD_Vegobjekt * obj in objekter)
    {
        NSMutableArray * egenskaper = [[NSMutableArray alloc] initWithCapacity:[obj.egenskaper count]];
        NSMutableArray * veglenker = [[NSMutableArray alloc] initWithCapacity:[obj.veglenker count]];
        
        for(CD_Egenskap * cdEg in obj.egenskaper)
        {
            Egenskap * e = [Egenskap alloc];
            e.navn = cdEg.navn;
            e.verdi = cdEg.verdi;
            [egenskaper addObject:e];
        }
        
        for(CD_Veglenke * cdVl in obj.veglenker)
        {
            Veglenke * v = [Veglenke alloc];
            v.lenkeId = cdVl.lenkeId;
            v.fra = cdVl.fra;
            v.til = cdVl.til;
            v.retning = cdVl.retning;
            [veglenker addObject:v];
        }
        
        if([obj isKindOfClass:[CD_Fartsgrense class]])
        {
            Fartsgrense * fartsgrense = [Fartsgrense alloc];
            fartsgrense.egenskaper = egenskaper;
            fartsgrense.veglenker = veglenker;
            fartsgrense.lokasjon = obj.lokasjon;
            fartsgrense.strekningsLengde = ((CD_LinjeObjekt *)obj).strekningsLengde;
            [fartsgrenser addObject:fartsgrense];
        }
        else if([obj isKindOfClass:[CD_Forkjorsvei class]])
        {
            Forkjorsveg * forkjorsveg = [Forkjorsveg alloc];
            forkjorsveg.egenskaper = egenskaper;
            forkjorsveg.veglenker = veglenker;
            forkjorsveg.lokasjon = obj.lokasjon;
            forkjorsveg.strekningsLengde = ((CD_LinjeObjekt *)obj).strekningsLengde;
            [forkjorsveier addObject:forkjorsveg];
        }
        else if([obj isKindOfClass:[CD_Vilttrekk class]])
        {
            Vilttrekk * ettVilttrekk = [Vilttrekk alloc];
            ettVilttrekk.egenskaper = egenskaper;
            ettVilttrekk.veglenker = veglenker;
            ettVilttrekk.lokasjon = obj.lokasjon;
            ettVilttrekk.strekningsLengde = ((CD_LinjeObjekt *)obj).strekningsLengde;
            [vilttrekk addObject:ettVilttrekk];
        }
        else if([obj isKindOfClass:[CD_Fartsdemper class]])
        {
            Fartsdemper * fartsdemper = [Fartsdemper alloc];
            fartsdemper.egenskaper = egenskaper;
            fartsdemper.veglenker = veglenker;
            fartsdemper.lokasjon = obj.lokasjon;
            [fartsdempere addObject:fartsdemper];
        }
        else if([obj isKindOfClass:[CD_Hoydebegrensning class]])
        {
            Hoydebegrensning * hoydebegrensning = [Hoydebegrensning alloc];
            hoydebegrensning.egenskaper = egenskaper;
            hoydebegrensning.veglenker = veglenker;
            hoydebegrensning.lokasjon = obj.lokasjon;
            [hoydebegrensninger addObject:hoydebegrensning];
        }
        else if([obj isKindOfClass:[CD_Jernbanekryssing class]])
        {
            Jernbanekryssing * jernbanekryssing = [Jernbanekryssing alloc];
            jernbanekryssing.egenskaper = egenskaper;
            jernbanekryssing.veglenker = veglenker;
            jernbanekryssing.lokasjon = obj.lokasjon;
            [jernbanekryssinger addObject:jernbanekryssing];
        }
    }
    
    Fartsgrenser * s_fartsgrenser = [[Fartsgrenser alloc] initMedObjekter:[fartsgrenser copy]];
    Forkjorsveger * s_forkjorsveier = [[Forkjorsveger alloc] initMedObjekter:[forkjorsveier copy]];
    Vilttrekks * s_vilttrekk = [[Vilttrekks alloc] initMedObjekter:[vilttrekk copy]];
    Fartsdempere * s_fartsdempere = [[Fartsdempere alloc] initMedObjekter:[fartsdempere copy]];
    Hoydebegrensninger * s_hoydebegrensninger = [[Hoydebegrensninger alloc] initMedObjekter:[hoydebegrensninger copy]];
    Jernbanekryssinger * s_jernbanekryssinger = [[Jernbanekryssinger alloc] initMedObjekter:[jernbanekryssinger copy]];
    
    NSArray * resultat = [[NSArray alloc] initWithObjects:s_fartsgrenser, s_forkjorsveier, s_vilttrekk,
                          s_fartsdempere, s_hoydebegrensninger, s_jernbanekryssinger, nil];
    
    NSLog(@"\n### Data lastet fra Core Data.");
    [delegate svarFraNVDBMedResultat:resultat OgVeglenkeId:vlenke.veglenkeId];
}

#pragma mark - NVDBResponseDelegate

- (void)svarFraNVDBMedResultat:(NSArray *)resultat OgVeglenkeId:(NSNumber *)lenkeId
{
    // Lagrer data til Core Data
    if(!(resultat == nil || resultat.count == 0 || [resultat[0] isKindOfClass:[Vegreferanse class]]))
    {
        NSEntityDescription * veglenkeEntity = [NSEntityDescription entityForName:@"VeglenkeDBStatus"
                                                           inManagedObjectContext:managedObjectContext];
        NSFetchRequest * request = [[NSFetchRequest alloc] init];
        [request setEntity:veglenkeEntity];
        
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"(veglenkeId == %@)", lenkeId];
        [request setPredicate:predicate];
        
        NSError * feil;
        NSArray * eksisterende = [managedObjectContext executeFetchRequest:request error:&feil];
        
        if(feil)
        {
            NSLog(@"\n### Feil ved spørring mot Core Data: %@.\n### Lagrer ikke data til databasen.", feil.description);
            [delegate svarFraNVDBMedResultat:resultat OgVeglenkeId:lenkeId];
        }
        
        // Sletter eksisterende oppføring i databasen
        if(eksisterende && [eksisterende count] > 0)
        {
            for(VeglenkeDBStatus * x in eksisterende)
            {
                [managedObjectContext deleteObject:x];
                
                feil = nil;
                [managedObjectContext save:&feil];
            
                if(feil)
                    NSLog(@"\n### Feil ved sletting av objekt fra databasen:%@", feil.description);
                else
                    NSLog(@"\n### Objekt ble slettet fra Core Data.");
            }
        }
        
        NSMutableSet * cdObjekter = [[NSMutableSet alloc] init];
        
        for (NSObject * r_obj in resultat)
        {
            if ([r_obj isKindOfClass:[SokResultater class]])
            {
                SokResultater * s_obj = (SokResultater *)r_obj;
                
                if(s_obj.objekter == nil || s_obj.objekter.count == 0)
                    continue;

                for (Vegobjekt * v_obj in s_obj.objekter)
                {
                    NSMutableSet * egenskaper = [[NSMutableSet alloc] init];
                    NSMutableSet * veglenker = [[NSMutableSet alloc] init];
                    
                    for(Egenskap * v_eg in v_obj.egenskaper)
                    {
                        CD_Egenskap * e = [NSEntityDescription insertNewObjectForEntityForName:@"CD_Egenskap"
                                                                        inManagedObjectContext:managedObjectContext];
                        e.navn = v_eg.navn;
                        e.verdi = v_eg.verdi;
                        [egenskaper addObject:e];
                    }
                    
                    for(Veglenke * v_vlenke in v_obj.veglenker)
                    {
                        CD_Veglenke * v = [NSEntityDescription insertNewObjectForEntityForName:@"CD_Veglenke"
                                                                        inManagedObjectContext:managedObjectContext];
                        v.lenkeId = v_vlenke.lenkeId;
                        v.fra = v_vlenke.fra;
                        v.til = v_vlenke.til;
                        v.retning = v_vlenke.retning;
                        [veglenker addObject:v];
                    }
                    
                    CD_Vegobjekt * cdVegobj;
                    
                    if([v_obj isKindOfClass:[Fartsgrense class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:@"CD_Fartsgrense"
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[Forkjorsveg class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:@"CD_Forkjorsvei"
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[Vilttrekk class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:@"CD_Vilttrekk"
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[Fartsdemper class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:@"CD_Fartsdemper"
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[Hoydebegrensning class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:@"CD_Hoydebegrensning"
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[Jernbanekryssing class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:@"CD_Jernbanekryssing"
                                                                 inManagedObjectContext:managedObjectContext];
                    else
                        continue;
                    
                    [cdVegobj addEgenskaper:egenskaper];
                    [cdVegobj addVeglenker:veglenker];
                    cdVegobj.lokasjon = v_obj.lokasjon;
                    
                    if([cdVegobj isKindOfClass:[CD_LinjeObjekt class]])
                        ((CD_LinjeObjekt *)cdVegobj).strekningsLengde = ((LinjeObjekt *)v_obj).strekningsLengde;
                    
                    [cdObjekter addObject:cdVegobj];
                }
            }
        }
        
        VeglenkeDBStatus * cdStatus = [NSEntityDescription insertNewObjectForEntityForName:@"VeglenkeDBStatus"
                                                                    inManagedObjectContext:managedObjectContext];
        cdStatus.sistOppdatert = [[NSDate alloc] init];
        cdStatus.veglenkeId = lenkeId;
        [cdStatus addVegobjekter:cdObjekter];

        feil = nil;
        [managedObjectContext save:&feil];

        if(feil)
            NSLog(@"\n### Feil ved lagring til Core Data: %@", feil.description);
        else
            NSLog(@"\n### Data lagret i databasen.");
    }

    [delegate svarFraNVDBMedResultat:resultat OgVeglenkeId:lenkeId];
}

- (void)svarFraGoogleMapsMedResultat:(NSArray *)resultat OgKey:(NSString *)key
{
    [delegate svarFraGoogleMapsMedResultat:resultat OgKey:key];
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

+ (NSDictionary *)parametereForGoogleMapsAvstandMedAX:(NSDecimalNumber *)ax AY:(NSDecimalNumber *)ay BX:(NSDecimalNumber *)bx OgBY:(NSDecimalNumber *)by
{
    NSString * fra = [[NSArray arrayWithObjects:ax, ay, nil] componentsJoinedByString:@","];
    NSString * til = [[NSArray arrayWithObjects:bx, by, nil] componentsJoinedByString:@","];
    return @{@"origins" : fra, @"destinations" : til, @"sensor" : @"true"};
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
