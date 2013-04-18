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
#import "Motorveg.h"
#import "Fartsdemper.h"
#import "Hoydebegrensning.h"
#import "Jernbanekryssing.h"
#import "Vegreferanse.h"
#import "Sok.h"
#import "Veglenke.h"
#import "Egenskap.h"
#import "SokResultater.h"
#import "MapQuestRoute.h"
#import "Skiltplate.h"
#import "SkiltObjekt.h"

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
#import "CD_Forkjorsveg.h"
#import "CD_Vilttrekk.h"
#import "CD_Motorveg.h"
#import "CD_Annenfare.h"
#import "CD_AutomatiskTrafikkontroll.h"
#import "CD_Avstandtilgangfelt.h"
#import "CD_Barn.h"
#import "CD_Bevegeligbru.h"
#import "CD_Brattbakke.h"
#import "CD_Farligsving.h"
#import "CD_Farligvegkryss.h"
#import "CD_Farligvegskulder.h"
#import "CD_Fly.h"
#import "CD_Forkjorsveg.h"
#import "CD_Glattkjorebane.h"
#import "CD_KaiStrandFerjeleie.h"
#import "CD_Ko.h"
#import "CD_Ku.h"
#import "CD_Motendetrafikk.h"
#import "CD_Rasfare.h"
#import "CD_Ridende.h"
#import "CD_Rundkjoring.h"
#import "CD_SaerligUlykkesfare.h"
#import "CD_Sau.h"
#import "CD_Sidevind.h"
#import "CD_Skilopere.h"
#import "CD_SkiltObjekt.h"
#import "CD_Smalereveg.h"
#import "CD_Steinsprut.h"
#import "CD_Syklende.h"
#import "CD_Trafikklyssignal.h"
#import "CD_Tunnel.h"
#import "CD_Ujevnveg.h"
#import "CD_VariabelSkiltplate.h"
#import "CD_Vegarbeid.h"
#import "CD_Videokontroll.h"

@interface NVDB_DataProvider()
- (void)hentVegObjekterFraNVDBMedSokeObjekt:(Sok *)sok OgMapping:(RKMapping *)mapping;
- (void)hentVegObjekterFraCoreDataMedVeglenkeCDObjekt:(VeglenkeDBStatus *)vlenke;
+ (NSArray *)gjorOmTilSkiltobjekterMedResultat:(NSArray *)resultat;
+ (NSDictionary *)parametereForKoordinaterMedBreddegrad:(NSDecimalNumber *)breddegrad OgLengdegrad:(NSDecimalNumber *)lengdegrad;
+ (NSDictionary *)parametereForBoundingBoxMedBreddegrad:(NSDecimalNumber *)breddegrad OgLengdegrad:(NSDecimalNumber *)lengdegrad;
+ (NSDictionary *)parametereForMapQuestAvstandMedAX:(NSDecimalNumber *)ax AY:(NSDecimalNumber *)ay BX:(NSDecimalNumber *)bx OgBY:(NSDecimalNumber *)by;
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
    NSEntityDescription * veglenkeEntity = [NSEntityDescription entityForName:VEGLENKEDBSTATUS_CD
                                                       inManagedObjectContext:managedObjectContext];
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:veglenkeEntity];
    
    NSNumber * vlenke = ((Veglenke *)sok.veglenker[0]).lenkeId;
    NSString * predicateStreng = [NSString stringWithFormat: @"(%@ == %@)", VEGLENKEDBSTATUS_LENKEID, vlenke];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:predicateStreng];
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
    [restkit hentAvstandMellomKoordinaterMedParametere:[NVDB_DataProvider parametereForMapQuestAvstandMedAX:ax
                                                                                                         AY:ay
                                                                                                         BX:bx
                                                                                                       OgBY:by]
                                               Mapping:[MapQuestRoute mapping]
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
    NSMutableArray * motorveger = [[NSMutableArray alloc] init];
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
        else if([obj isKindOfClass:[CD_Forkjorsveg class]])
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
        else if([obj isKindOfClass:[CD_Motorveg class]])
        {
            Motorveg * motorveg = [Motorveg alloc];
            motorveg.egenskaper = egenskaper;
            motorveg.veglenker = veglenker;
            motorveg.lokasjon = obj.lokasjon;
            motorveg.strekningsLengde = ((CD_LinjeObjekt *)obj).strekningsLengde;
            [motorveger addObject:motorveg];
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
    Motorveger * s_motorveger = [[Motorveger alloc] initMedObjekter:[motorveger copy]];
    Fartsdempere * s_fartsdempere = [[Fartsdempere alloc] initMedObjekter:[fartsdempere copy]];
    Hoydebegrensninger * s_hoydebegrensninger = [[Hoydebegrensninger alloc] initMedObjekter:[hoydebegrensninger copy]];
    Jernbanekryssinger * s_jernbanekryssinger = [[Jernbanekryssinger alloc] initMedObjekter:[jernbanekryssinger copy]];
    
    NSArray * resultat = [[NSArray alloc] initWithObjects:s_fartsgrenser, s_forkjorsveier, s_vilttrekk, s_motorveger,
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
        resultat = [NVDB_DataProvider gjorOmTilSkiltobjekterMedResultat:resultat];
        
        NSEntityDescription * veglenkeEntity = [NSEntityDescription entityForName:VEGLENKEDBSTATUS_CD
                                                           inManagedObjectContext:managedObjectContext];
        NSFetchRequest * request = [[NSFetchRequest alloc] init];
        [request setEntity:veglenkeEntity];
        
        NSString * predicateStreng = [NSString stringWithFormat: @"(%@ == %@)", VEGLENKEDBSTATUS_LENKEID, lenkeId];
        NSPredicate * predicate = [NSPredicate predicateWithFormat:predicateStreng];
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
                        CD_Egenskap * e = [NSEntityDescription insertNewObjectForEntityForName:EGENSKAP_CD
                                                                        inManagedObjectContext:managedObjectContext];
                        e.navn = v_eg.navn;
                        e.verdi = v_eg.verdi;
                        [egenskaper addObject:e];
                    }
                    
                    for(Veglenke * v_vlenke in v_obj.veglenker)
                    {
                        CD_Veglenke * v = [NSEntityDescription insertNewObjectForEntityForName:VEGLENKE_CD
                                                                        inManagedObjectContext:managedObjectContext];
                        v.lenkeId = v_vlenke.lenkeId;
                        v.fra = v_vlenke.fra;
                        v.til = v_vlenke.til;
                        v.retning = v_vlenke.retning;
                        [veglenker addObject:v];
                    }
                    
                    CD_Vegobjekt * cdVegobj;
                    
                    if([v_obj isKindOfClass:[Fartsgrense class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:FARTSGRENSE_CD
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[Forkjorsveg class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:FORKJORSVEG_CD
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[Vilttrekk class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:VILTTREKK_CD
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[Motorveg class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:MOTORVEG_CD
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[Fartsdemper class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:FARTSDEMPER_CD
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[Hoydebegrensning class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:HOYDEBEGRENSNING_CD
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[Jernbanekryssing class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:JERNBANEKRYSSING_CD
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[Farligsving class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:FARLIGSVING_CD
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[Brattbakke class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:BRATTBAKKE_CD
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[Smalereveg class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:SMALEREVEG_CD
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[Ujevnveg class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:UJEVNVEG_CD
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[Vegarbeid class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:VEGARBEID_CD
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[Steinsprut class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:STEINSPRUT_CD
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[Rasfare class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:RASFARE_CD
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[Glattkjorebane class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:GLATTKJOREBANE_CD
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[Farligvegskulder class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:FARLIGVEGSKULDER_CD
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[Bevegeligbru class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:BEVEGELIGBRU_CD
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[KaiStrandFerjeleie class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:KAISTRANDFERJELEIE_CD
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[Tunnel class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:TUNNEL_CD
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[Farligvegkryss class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:FARLIGVEGKRYSS_CD
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[Rundkjoring class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:RUNDKJORING_CD
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[Trafikklyssignal class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:TRAFIKKLYSSIGNAL_CD
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[Avstandtilgangfelt class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:AVSTANDTILGANGFELT_CD
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[Barn class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:BARN_CD
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[Syklende class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:SYKLENDE_CD
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[Ku class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:KU_CD
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[Sau class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:SAU_CD
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[Motendetrafikk class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:MOTENDETRAFIKK_CD
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[Ko class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:KO_CD
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[Fly class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:FLY_CD
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[Sidevind class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:SIDEVIND_CD
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[Skilopere class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:SKILOPERE_CD
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[Ridende class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:RIDENDE_CD
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[Annenfare class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:ANNENFARE_CD
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[AutomatiskTrafikkontroll class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:AUTOMATISKTRAFIKKONTROLL_CD
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[Videokontroll class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:VIDEOKONTROLL_CD
                                                                 inManagedObjectContext:managedObjectContext];
                    else if([v_obj isKindOfClass:[SaerligUlykkesfare class]])
                        cdVegobj = [NSEntityDescription insertNewObjectForEntityForName:SAERLIGULYKKESFARE_CD
                                                                 inManagedObjectContext:managedObjectContext];
                    else
                        continue;
                    
                    [cdVegobj addEgenskaper:egenskaper];
                    [cdVegobj addVeglenker:veglenker];
                    cdVegobj.lokasjon = v_obj.lokasjon;
                    
                    if([cdVegobj isKindOfClass:[CD_LinjeObjekt class]])
                        ((CD_LinjeObjekt *)cdVegobj).strekningsLengde = ((LinjeObjekt *)v_obj).strekningsLengde;
                    
                    if([cdVegobj isKindOfClass:[CD_SkiltObjekt class]])
                    {
                        ((CD_SkiltObjekt *)cdVegobj).ansiktsside = ((SkiltObjekt *)v_obj).ansiktsside;
                        ((CD_SkiltObjekt *)cdVegobj).avstandEllerUtstrekning = ((SkiltObjekt *)v_obj).avstandEllerUtstrekning;
                        
                        if([cdVegobj isKindOfClass:[CD_VariabelSkiltplate class]])
                            ((CD_VariabelSkiltplate *)cdVegobj).type = ((VariabelSkiltplate *)v_obj).type;
                    }
                    
                    [cdObjekter addObject:cdVegobj];
                }
            }
        }
        
        VeglenkeDBStatus * cdStatus = [NSEntityDescription insertNewObjectForEntityForName:VEGLENKEDBSTATUS_CD
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

- (void)svarFraMapQuestMedResultat:(NSArray *)resultat OgKey:(NSString *)key
{
    [delegate svarFraMapQuestMedResultat:resultat OgKey:key];
}

#pragma mark - Statiske hjelpemetoder

+ (NSArray *)gjorOmTilSkiltobjekterMedResultat:(NSArray *)resultat
{
    if(!resultat)
        return nil;
    
    NSMutableArray * nyttResultat = [[NSMutableArray alloc] initWithArray:resultat];
    
    NSMutableArray * farligesvinger = [[NSMutableArray alloc] init];
    NSMutableArray * brattebakker = [[NSMutableArray alloc] init];
    NSMutableArray * smalereveger = [[NSMutableArray alloc] init];
    NSMutableArray * ujevneveger = [[NSMutableArray alloc] init];
    NSMutableArray * vegarbeids = [[NSMutableArray alloc] init];
    NSMutableArray * steinspruts = [[NSMutableArray alloc] init];
    NSMutableArray * rasfarer = [[NSMutableArray alloc] init];
    NSMutableArray * glattekjorebaner = [[NSMutableArray alloc] init];
    NSMutableArray * farligevegskuldere = [[NSMutableArray alloc] init];
    NSMutableArray * bevegeligebruer = [[NSMutableArray alloc] init];
    NSMutableArray * kaistrandferjeleies = [[NSMutableArray alloc] init];
    NSMutableArray * tunneler = [[NSMutableArray alloc] init];
    NSMutableArray * farligevegkryss = [[NSMutableArray alloc] init];
    NSMutableArray * rundkjoringer = [[NSMutableArray alloc] init];
    NSMutableArray * trafikklyssignaler = [[NSMutableArray alloc] init];
    NSMutableArray * avstandertilgangfelt = [[NSMutableArray alloc] init];
    NSMutableArray * barns = [[NSMutableArray alloc] init];
    NSMutableArray * syklendes = [[NSMutableArray alloc] init];
    NSMutableArray * kuer = [[NSMutableArray alloc] init];
    NSMutableArray * sauer = [[NSMutableArray alloc] init];
    NSMutableArray * motendetrafikks = [[NSMutableArray alloc] init];
    NSMutableArray * koer = [[NSMutableArray alloc] init];
    NSMutableArray * flys = [[NSMutableArray alloc] init];
    NSMutableArray * sidevinder = [[NSMutableArray alloc] init];
    NSMutableArray * skiloperes = [[NSMutableArray alloc] init];
    NSMutableArray * ridendes = [[NSMutableArray alloc] init];
    NSMutableArray * andrefarer = [[NSMutableArray alloc] init];
    NSMutableArray * automatisketrafikkontroller = [[NSMutableArray alloc] init];
    NSMutableArray * videokontroller = [[NSMutableArray alloc] init];
    NSMutableArray * saerligeulykkesfarer = [[NSMutableArray alloc] init];
    
    for(NSObject * o in nyttResultat)
    {
        if([o isKindOfClass:[Skiltplater class]])
        {
            for(Skiltplate * skiltplate in ((Skiltplater *)o).objekter)
            {
                NSString * type = [skiltplate hentSkilttypeFraEgenskaper];
                
                void (^settOppSkiltObjekt)(SkiltObjekt *) = ^(SkiltObjekt * skiltobj)
                {
                    skiltobj.lokasjon = skiltplate.lokasjon;
                    skiltobj.ansiktsside = [skiltplate hentAnsiktssideFraEgenskaper];
                    skiltobj.veglenker = skiltplate.veglenker;
                    
                    if([skiltobj isKindOfClass:[VariabelSkiltplate class]])
                        ((VariabelSkiltplate *)skiltobj).type = type;
                    
                    for(Skiltplate * tekstskilt in ((Skiltplater *)o).objekter)
                        if(([[tekstskilt hentSkilttypeFraEgenskaper] isEqualToString:SKILTPLATE_SKILTNUMMER_AVSTAND] ||
                            [[tekstskilt hentSkilttypeFraEgenskaper] isEqualToString:SKILTPLATE_SKILTNUMMER_UTSTREKNING])
                           && [skiltplate.lokasjon isEqualToString:tekstskilt.lokasjon])
                        {
                            skiltobj.avstandEllerUtstrekning = [tekstskilt hentTekstFraEgenskaper];
                            break;
                        }
                };

                if([type isEqualToString:SKILTPLATE_SKILTNUMMER_FARLIGESVINGER_H] ||
                   [type isEqualToString:SKILTPLATE_SKILTNUMMER_FARLIGESVINGER_V] ||
                   [type isEqualToString:SKILTPLATE_SKILTNUMMER_FARLIGSVING_H] ||
                   [type isEqualToString:SKILTPLATE_SKILTNUMMER_FARLIGSVING_V])
                {
                    Farligsving * farligsving = [Farligsving alloc];
                    settOppSkiltObjekt(farligsving);
                    [farligesvinger addObject:farligsving];
                }
                
                else if([type isEqualToString:SKILTPLATE_SKILTNUMMER_BRATTBAKKE_FALL] ||
                        [type isEqualToString:SKILTPLATE_SKILTNUMMER_BRATTBAKKE_STIGNING])
                {
                    Brattbakke * brattbakke = [Brattbakke alloc];
                    settOppSkiltObjekt(brattbakke);
                    [brattebakker addObject:brattbakke];
                }
                
                else if([type isEqualToString:SKILTPLATE_SKILTNUMMER_SMALEREVEG_BEGGE] ||
                        [type isEqualToString:SKILTPLATE_SKILTNUMMER_SMALEREVEG_H] ||
                        [type isEqualToString:SKILTPLATE_SKILTNUMMER_SMALEREVEG_V])
                {
                    Smalereveg * smalereveg = [Smalereveg alloc];
                    settOppSkiltObjekt(smalereveg);
                    [smalereveger addObject:smalereveg];
                }
                
                else if([type isEqualToString:SKILTPLATE_SKILTNUMMER_UJEVNVEG])
                {
                    Ujevnveg * ujevnveg = [Ujevnveg alloc];
                    settOppSkiltObjekt(ujevnveg);
                    [ujevneveger addObject:ujevnveg];
                }
                
                else if([type isEqualToString:SKILTPLATE_SKILTNUMMER_VEGARBEID])
                {
                    Vegarbeid * vegarbeid = [Vegarbeid alloc];
                    settOppSkiltObjekt(vegarbeid);
                    [vegarbeids addObject:vegarbeid];
                }
                
                else if([type isEqualToString:SKILTPLATE_SKILTNUMMER_STEINSPRUT])
                {
                    Steinsprut * steinsprut = [Steinsprut alloc];
                    settOppSkiltObjekt(steinsprut);
                    [steinspruts addObject:steinsprut];
                }
                
                else if([type isEqualToString:SKILTPLATE_SKILTNUMMER_RASFARE_H] ||
                        [type isEqualToString:SKILTPLATE_SKILTNUMMER_RASFARE_V])
                {
                    Rasfare * rasfare = [Rasfare alloc];
                    settOppSkiltObjekt(rasfare);
                    [rasfarer addObject:rasfare];
                }
                
                else if([type isEqualToString:SKILTPLATE_SKILTNUMMER_GLATTKJOREBANE])
                {
                    Glattkjorebane * glattkjorebane = [Glattkjorebane alloc];
                    settOppSkiltObjekt(glattkjorebane);
                    [glattekjorebaner addObject:glattkjorebane];
                }
                
                else if([type isEqualToString:SKILTPLATE_SKILTNUMMER_FARLIGVEGSKULDER])
                {
                    Farligvegskulder * farligvegskulder = [Farligvegskulder alloc];
                    settOppSkiltObjekt(farligvegskulder);
                    [farligevegskuldere addObject:farligvegskulder];
                }
                
                else if([type isEqualToString:SKILTPLATE_SKILTNUMMER_BEVEGELIGBRU])
                {
                    Bevegeligbru * bevegeligbru = [Bevegeligbru alloc];
                    settOppSkiltObjekt(bevegeligbru);
                    [bevegeligebruer addObject:bevegeligbru];
                }
                
                else if([type isEqualToString:SKILTPLATE_SKILTNUMMER_KAISTRANDFERJELEIE])
                {
                    KaiStrandFerjeleie * kaistrandferjeleie = [KaiStrandFerjeleie alloc];
                    settOppSkiltObjekt(kaistrandferjeleie);
                    [kaistrandferjeleies addObject:kaistrandferjeleie];
                }
                
                else if([type isEqualToString:SKILTPLATE_SKILTNUMMER_TUNNEL])
                {
                    Tunnel * tunnel = [Tunnel alloc];
                    settOppSkiltObjekt(tunnel);
                    [tunneler addObject:tunnel];
                }
                
                else if([type isEqualToString:SKILTPLATE_SKILTNUMMER_FARLIGVEGKRYSS])
                {
                    Farligvegkryss * farligvegkryss = [Farligvegkryss alloc];
                    settOppSkiltObjekt(farligvegkryss);
                    [farligevegkryss addObject:farligvegkryss];
                }
                
                else if([type isEqualToString:SKILTPLATE_SKILTNUMMER_RUNDKJORING])
                {
                    Rundkjoring * rundkjoring = [Rundkjoring alloc];
                    settOppSkiltObjekt(rundkjoring);
                    [rundkjoringer addObject:rundkjoring];
                }
                
                else if([type isEqualToString:SKILTPLATE_SKILTNUMMER_TRAFIKKLYSSIGNAL])
                {
                    Trafikklyssignal * trafikklyssignal = [Trafikklyssignal alloc];
                    settOppSkiltObjekt(trafikklyssignal);
                    [trafikklyssignaler addObject:trafikklyssignal];
                }
                
                else if([type isEqualToString:SKILTPLATE_SKILTNUMMER_AVSTANDTILGANGFELT])
                {
                    Avstandtilgangfelt * avstandtilgangfelt = [Avstandtilgangfelt alloc];
                    settOppSkiltObjekt(avstandtilgangfelt);
                    [avstandertilgangfelt addObject:avstandtilgangfelt];
                }
                
                else if([type isEqualToString:SKILTPLATE_SKILTNUMMER_BARN])
                {
                    Barn * barn = [Barn alloc];
                    settOppSkiltObjekt(barn);
                    [barns addObject:barn];
                }
                
                else if([type isEqualToString:SKILTPLATE_SKILTNUMMER_SYKLENDE])
                {
                    Syklende * syklende = [Syklende alloc];
                    settOppSkiltObjekt(syklende);
                    [syklendes addObject:syklende];
                }
                
                else if([type isEqualToString:SKILTPLATE_SKILTNUMMER_KU])
                {
                    Ku * ku = [Ku alloc];
                    settOppSkiltObjekt(ku);
                    [kuer addObject:ku];
                }
                
                else if([type isEqualToString:SKILTPLATE_SKILTNUMMER_SAU])
                {
                    Sau * sau = [Sau alloc];
                    settOppSkiltObjekt(sau);
                    [sauer addObject:sau];
                }
                
                else if([type isEqualToString:SKILTPLATE_SKILTNUMMER_MOTENDETRAFIKK])
                {
                    Motendetrafikk * motendetrafikk = [Motendetrafikk alloc];
                    settOppSkiltObjekt(motendetrafikk);
                    [motendetrafikks addObject:motendetrafikk];
                }
                
                else if([type isEqualToString:SKILTPLATE_SKILTNUMMER_KO])
                {
                    Ko * ko = [Ko alloc];
                    settOppSkiltObjekt(ko);
                    [koer addObject:ko];
                }
                
                else if([type isEqualToString:SKILTPLATE_SKILTNUMMER_FLY])
                {
                    Fly * fly = [Fly alloc];
                    settOppSkiltObjekt(fly);
                    [flys addObject:fly];
                }
                
                else if([type isEqualToString:SKILTPLATE_SKILTNUMMER_SIDEVIND])
                {
                    Sidevind * sidevind = [Sidevind alloc];
                    settOppSkiltObjekt(sidevind);
                    [sidevinder addObject:sidevind];
                }
                
                else if([type isEqualToString:SKILTPLATE_SKILTNUMMER_SKILOPERE])
                {
                    Skilopere * skilopere = [Skilopere alloc];
                    settOppSkiltObjekt(skilopere);
                    [skiloperes addObject:skilopere];
                }
                
                else if([type isEqualToString:SKILTPLATE_SKILTNUMMER_RIDENDE])
                {
                    Ridende * ridende = [Ridende alloc];
                    settOppSkiltObjekt(ridende);
                    [ridendes addObject:ridende];
                }
                
                else if([type isEqualToString:SKILTPLATE_SKILTNUMMER_ANNENFARE])
                {
                    Annenfare * annenfare = [Annenfare alloc];
                    settOppSkiltObjekt(annenfare);
                    [andrefarer addObject:annenfare];
                }
                
                else if([type isEqualToString:SKILTPLATE_SKILTNUMMER_AUTOMATISKTRAFIKKONTROLL])
                {
                    AutomatiskTrafikkontroll * automatisktrafikkontroll = [AutomatiskTrafikkontroll alloc];
                    settOppSkiltObjekt(automatisktrafikkontroll);
                    [automatisketrafikkontroller addObject:automatisktrafikkontroll];
                }
                
                else if([type isEqualToString:SKILTPLATE_SKILTNUMMER_VIDEOKONTROLL])
                {
                    Videokontroll * videokontroll = [Videokontroll alloc];
                    settOppSkiltObjekt(videokontroll);
                    [videokontroller addObject:videokontroll];
                }
                
                else if([type isEqualToString:SKILTPLATE_SKILTNUMMER_SAERLIGULYKKESFARE_1] ||
                        [type isEqualToString:SKILTPLATE_SKILTNUMMER_SAERLIGULYKKESFARE_2] ||
                        [type isEqualToString:SKILTPLATE_SKILTNUMMER_SAERLIGULYKKESFARE_3] ||
                        [type isEqualToString:SKILTPLATE_SKILTNUMMER_SAERLIGULYKKESFARE_4] ||
                        [type isEqualToString:SKILTPLATE_SKILTNUMMER_SAERLIGULYKKESFARE_5])
                {
                    SaerligUlykkesfare * saerligulykkesfare = [SaerligUlykkesfare alloc];
                    settOppSkiltObjekt(saerligulykkesfare);
                    [saerligeulykkesfarer addObject:saerligulykkesfare];
                }
            }
            
            [nyttResultat removeObject:o];
            break;
        }
    }
    
    Farligesvinger * s_farligesvinger = [[Farligesvinger alloc] initMedObjekter:[farligesvinger copy]];
    Brattebakker * s_brattebakker = [[Brattebakker alloc] initMedObjekter:[brattebakker copy]];
    Smalereveger * s_smalereveger = [[Smalereveger alloc] initMedObjekter:[smalereveger copy]];
    Ujevneveger * s_ujevneveger = [[Ujevneveger alloc] initMedObjekter:[ujevneveger copy]];
    Vegarbeids * s_vegarbeids = [[Vegarbeids alloc] initMedObjekter:[vegarbeids copy]];
    Steinspruts * s_steinspruts = [[Steinspruts alloc] initMedObjekter:[steinspruts copy]];
    Rasfarer * s_rasfarer = [[Rasfarer alloc] initMedObjekter:[rasfarer copy]];
    Glattekjorebaner * s_glattekjorebaner = [[Glattekjorebaner alloc] initMedObjekter:[glattekjorebaner copy]];
    Farligevegskuldere * s_farligevegskuldere = [[Farligevegskuldere alloc] initMedObjekter:[farligevegskuldere copy]];
    Bevegeligebruer * s_bevegeligebruer = [[Bevegeligebruer alloc] initMedObjekter:[bevegeligebruer copy]];
    KaiStrandFerjeleies * s_kaistrandferjeleies = [[KaiStrandFerjeleies alloc] initMedObjekter:[kaistrandferjeleies copy]];
    Tunneler * s_tunneler = [[Tunneler alloc] initMedObjekter:[tunneler copy]];
    Farligevegkryss * s_farligevegkryss = [[Farligevegkryss alloc] initMedObjekter:[farligevegkryss copy]];
    Rundkjoringer * s_rundkjoringer = [[Rundkjoringer alloc] initMedObjekter:[rundkjoringer copy]];
    Trafikklyssignaler * s_trafikklyssignaler = [[Trafikklyssignaler alloc] initMedObjekter:[trafikklyssignaler copy]];
    Avstandertilgangfelt * s_avstandertilgangfelt = [[Avstandertilgangfelt alloc] initMedObjekter:[avstandertilgangfelt copy]];
    Barns * s_barns = [[Barns alloc] initMedObjekter:[barns copy]];
    Syklendes * s_syklendes = [[Syklendes alloc] initMedObjekter:[syklendes copy]];
    Kuer * s_kuer = [[Kuer alloc] initMedObjekter:[kuer copy]];
    Sauer * s_sauer = [[Sauer alloc] initMedObjekter:[sauer copy]];
    Motendetrafikks * s_motendetrafikks = [[Motendetrafikks alloc] initMedObjekter:[motendetrafikks copy]];
    Koer * s_koer = [[Koer alloc] initMedObjekter:[koer copy]];
    Flys * s_flys = [[Flys alloc] initMedObjekter:[flys copy]];
    Sidevinder * s_sidevinder = [[Sidevinder alloc] initMedObjekter:[sidevinder copy]];
    Skiloperes * s_skiloperes = [[Skiloperes alloc] initMedObjekter:[skiloperes copy]];
    Ridendes * s_ridendes = [[Ridendes alloc] initMedObjekter:[ridendes copy]];
    Andrefarer * s_andrefarer = [[Andrefarer alloc] initMedObjekter:[andrefarer copy]];
    Automatisketrafikkontroller * s_automatisketrafikkontroller = [[Automatisketrafikkontroller alloc] initMedObjekter:[automatisketrafikkontroller copy]];
    Videokontroller * s_videokontroller = [[Videokontroller alloc] initMedObjekter:[videokontroller copy]];
    Saerligeulykkesfarer * s_saerligeulykkesfarer = [[Saerligeulykkesfarer alloc] initMedObjekter:[saerligeulykkesfarer copy]];
    
    [nyttResultat addObjectsFromArray:@[s_farligesvinger, s_brattebakker, s_smalereveger, s_ujevneveger, s_vegarbeids, s_steinspruts, s_rasfarer, s_glattekjorebaner, s_farligevegskuldere, s_bevegeligebruer, s_kaistrandferjeleies, s_tunneler, s_farligevegkryss, s_rundkjoringer, s_trafikklyssignaler, s_avstandertilgangfelt, s_barns, s_syklendes, s_kuer, s_sauer, s_motendetrafikks, s_koer, s_flys, s_sidevinder, s_skiloperes, s_ridendes, s_andrefarer, s_automatisketrafikkontroller, s_videokontroller, s_saerligeulykkesfarer]];
    
    NSLog(@"\n### Skiltplater omgjort til skiltobjekter.");
    return [nyttResultat copy];
}

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

+ (NSDictionary *)parametereForMapQuestAvstandMedAX:(NSDecimalNumber *)ax AY:(NSDecimalNumber *)ay BX:(NSDecimalNumber *)bx OgBY:(NSDecimalNumber *)by
{
    NSString * jsonstreng = [NSString stringWithFormat:@"{locations:[{latLng:{lat:%@,lng:%@}},{latLng:{lat:%@,lng:%@}}],options:{unit:k}}", ax, ay, bx, by];
    
    return @{@"key": MAPQUEST_KEY, @"json" : jsonstreng};
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
