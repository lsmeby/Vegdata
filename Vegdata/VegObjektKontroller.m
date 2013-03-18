//
//  VegObjektController.m
//  Vegdata
//
//  Created by Lars Smeby on 05.03.13.
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
#import "VegObjektKontroller.h"
#import "Vegreferanse.h"
#import "Sok.h"
#import "SokResultater.h"
#import "Veglenke.h"
#import "Fartsgrense.h"
#import "Forkjorsveg.h"
#import "Egenskap.h"
#import "Vilttrekk.h"

@interface VegObjektKontroller()

- (void)sokMedVegreferanse;
- (NSArray *)hentObjekttyper;
- (RKDynamicMapping *)hentObjektMapping;
- (NSDecimalNumber *)kalkulerVeglenkePosisjon;
- (void)leggTilLinjeDataIDictionary:(NSMutableDictionary *)returDictionary FraSokeresultater:(SokResultater *)resultater;
- (NSMutableDictionary *)opprettReturDictionaryMedDefaultVerdier;

@end

@implementation VegObjektKontroller

@synthesize delegate;

- (id)initMedDelegate:(id)aDelegate
{
    self.delegate = aDelegate;
    dataProv = [[NVDB_DataProvider alloc] init];
    return self;
}

- (void)oppdaterMedBreddegrad:(NSDecimalNumber *)breddegrad OgLengdegrad:(NSDecimalNumber *)lengdegrad
{
    [dataProv hentVegreferanseMedBreddegrad:breddegrad Lengdegrad:lengdegrad OgAvsender:self];
}

- (void)sokMedVegreferanse
{
    if(self.vegRef == nil)
        return;
    
    Sok * sokObjekt = [[Sok alloc] init];
    sokObjekt.veglenker = self.vegRef.veglenker;
    sokObjekt.objektTyper = [self hentObjekttyper];
    
    RKDynamicMapping * mapping = [self hentObjektMapping];
    
    [dataProv hentVegObjekterMedSokeObjekt:sokObjekt Mapping:mapping OgAvsender:self];
}

- (NSArray *)hentObjekttyper
{
    NSMutableArray * objekttyper = [[NSMutableArray alloc] init];
    [objekttyper addObject:[[Objekttype alloc] initMedTypeId:[[NSNumber alloc] initWithInt:105]
                                                      Antall:[[NSNumber alloc] initWithInt:0] OgFiltere:nil]];
    [objekttyper addObject:[[Objekttype alloc] initMedTypeId:[[NSNumber alloc] initWithInt:596]
                                                      Antall:[[NSNumber alloc] initWithInt:0] OgFiltere: nil]];
    [objekttyper addObject:[[Objekttype alloc] initMedTypeId:[[NSNumber alloc] initWithInt:291]
                                                      Antall:[[NSNumber alloc] initWithInt:0] OgFiltere:nil]];
    // Sjekk egenskaper og finn ut hvilke objekttyper vi skal finne
    return objekttyper;
}

- (RKDynamicMapping *) hentObjektMapping
{
    RKDynamicMapping * mapping = [[RKDynamicMapping alloc] init];
    [mapping addMatcher:[RKObjectMappingMatcher matcherWithKeyPath:@"typeId"
                                                     expectedValue:[[NSNumber alloc] initWithInt:105]
                                                     objectMapping:[Fartsgrense mapping]]];
    [mapping addMatcher:[RKObjectMappingMatcher matcherWithKeyPath:@"typeId"
                                                     expectedValue:[[NSNumber alloc] initWithInt:596]
                                                     objectMapping:[Forkjorsveg mapping]]];
    [mapping addMatcher:[RKObjectMappingMatcher matcherWithKeyPath:@"typeId"
                                                     expectedValue:[[NSNumber alloc] initWithInt:291]
                                                     objectMapping:[Vilttrekk mapping]]];
    return mapping;
}

- (NSDecimalNumber *)kalkulerVeglenkePosisjon
{
    if(self.vegRef.veglenker == nil || self.vegRef.veglenker.count == 0)
        return nil;
    
    double intervall = ((Veglenke *)self.vegRef.veglenker[0]).til.doubleValue - ((Veglenke *)self.vegRef.veglenker[0]).fra.doubleValue;
    double returPos = ((Veglenke *)self.vegRef.veglenker[0]).fra.doubleValue + (intervall * self.vegRef.veglenkePosisjon.doubleValue);
    
    return [[NSDecimalNumber alloc] initWithDouble:returPos];
}

#pragma mark - Metoder som tolker de returnerte objektene

- (void) leggTilLinjeDataIDictionary:(NSMutableDictionary *)returDictionary FraSokeresultater:(SokResultater *)resultater
{
    if(self.vegRef == nil || returDictionary == nil || resultater == nil || resultater.objekter == nil || resultater.objekter.count == 0)
        return;
    
    NSDecimalNumber * posisjon = [self kalkulerVeglenkePosisjon];
    if(posisjon == nil)
        return;
    
    for (Vegobjekt * obj in resultater.objekter)
    {
        if(obj.veglenker == nil || obj.veglenker.count == 0)
            continue;
        
        for(Veglenke * vLenke in obj.veglenker)
        {
            if(vLenke.lenkeId.intValue == self.vegRef.veglenkeId.intValue && posisjon.doubleValue >= vLenke.fra.doubleValue && posisjon.doubleValue <= vLenke.til.doubleValue)
            {
                if ([obj isKindOfClass:[Fartsgrense class]])
                {
                    NSString * fart = [(Fartsgrense *)obj hentFartFraEgenskaper];
                    
                    if(![fart isEqualToString:@"-1"])
                        [returDictionary setObject:fart forKey:@"fart"];
                }
                else if ([obj isKindOfClass:[Forkjorsveg class]])
                {
                    [returDictionary setObject:@"yes" forKey:@"forkjorsveg"];
                }
                else if ([obj isKindOfClass:[Vilttrekk class]])
                {
                    NSString * vilttrekk = [(Vilttrekk *)obj hentDyreartFraEgenskaper];
                    
                    if(![vilttrekk isEqualToString:@"-1"])
                        [returDictionary setObject:vilttrekk forKey:@"vilttrekk"];
                }
                
                return;
            }
        }
    }
}

- (NSMutableDictionary *) opprettReturDictionaryMedDefaultVerdier
{
    NSMutableDictionary * returDictionary = [[NSMutableDictionary alloc] init];
    
    // Legger  til default-verdier så viewet vet at det ble søkt etter men ikke funnet objekter
    [returDictionary setObject:@"-1" forKey:@"fart"];
    [returDictionary setObject:@"no" forKey:@"forkjorsveg"];
    [returDictionary setObject:@"-1" forKey:@"vilttrekk"];
    
    return returDictionary;
}

#pragma mark - NVDBResponseDelegate

- (void)svarFraNVDBMedResultat:(NSArray *)resultat
{
    NSLog(@"\n### MOTTAT SVAR FRA NVDB");
    if(resultat == nil || resultat.count == 0)
    {
        NSLog(@"\n### Mottok tomt resultat (NVDB finner ingen objekter som matcher søket)");
        NSMutableDictionary * returDictionary = [self opprettReturDictionaryMedDefaultVerdier];
        [self.delegate vegObjekterErOppdatert:returDictionary];
    }
    else if([resultat[0] isKindOfClass:[Vegreferanse class]])
    {
        NSLog(@"\n### Mottatt objekt er av type Vegreferanse");
        self.vegRef = (Vegreferanse *)resultat[0];
        [self sokMedVegreferanse];
    }
    else
    {
        NSLog(@"\n### Mottatt søkeresultater: %d objekttype(r)", resultat.count);
        NSMutableDictionary * returDictionary = [self opprettReturDictionaryMedDefaultVerdier];
        
        for (NSObject * obj in resultat)
            if ([obj isKindOfClass:[SokResultater class]])
                [self leggTilLinjeDataIDictionary:returDictionary FraSokeresultater:(SokResultater *)obj];
        
        [self.delegate vegObjekterErOppdatert:returDictionary];
    }
}

@end
