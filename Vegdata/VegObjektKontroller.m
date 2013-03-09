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

@interface VegObjektKontroller()

- (void)sokMedVegreferanse;
- (NSArray *)hentObjekttyper;
- (RKDynamicMapping *)hentObjektMapping;
- (NSDecimalNumber *)kalkulerVeglenkePosisjon;
- (void)leggTilKorrektFart:(NSMutableDictionary *)returDictionary FraFartsgrenser:(Fartsgrenser *)fartsgrenser;
- (void)settForkjorsvegStatus:(NSMutableDictionary *)returDictionary FraForkjorsveger:(Forkjorsveger *)forkjorsveger;

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

- (void) leggTilKorrektFart:(NSMutableDictionary *)returDictionary FraFartsgrenser:(Fartsgrenser *)fartsgrenser
{
    if(self.vegRef == nil || returDictionary == nil || fartsgrenser == nil || fartsgrenser.fartsgrenser == nil || fartsgrenser.fartsgrenser.count == 0)
        return;

    NSDecimalNumber * posisjon = [self kalkulerVeglenkePosisjon];
    if(posisjon == nil)
        return;
    
    for (Fartsgrense * fGr in fartsgrenser.fartsgrenser)
    {
        if(fGr.veglenker == nil || fGr.veglenker.count == 0)
            continue;
        
        for (Veglenke * vLenke in fGr.veglenker)
        {
            if(vLenke.lenkeId.intValue == self.vegRef.veglenkeId.intValue && posisjon.doubleValue > vLenke.fra.doubleValue && posisjon.doubleValue < vLenke.til.doubleValue)
            {
                if(fGr.egenskaper == nil || fGr.egenskaper.count == 0)
                    return;
                    
                for (Egenskap * eg in fGr.egenskaper)
                {
                    if([eg.navn isEqualToString:@"Fartsgrense"])
                        [returDictionary setObject:eg.verdi forKey:@"fart"];
                }
                return;
            }
        }
    }
}

- (void) settForkjorsvegStatus:(NSMutableDictionary *)returDictionary FraForkjorsveger:(Forkjorsveger *)forkjorsveger
{
    if(self.vegRef == nil || returDictionary == nil || forkjorsveger == nil || forkjorsveger.forkjorsveger == nil ||
       forkjorsveger.forkjorsveger.count == 0)
        return;
    
    NSDecimalNumber * posisjon = [self kalkulerVeglenkePosisjon];
    if(posisjon == nil)
        return;
    
    for (Forkjorsveg * f in forkjorsveger.forkjorsveger)
    {
        if(f.veglenker == nil || f.veglenker.count == 0)
            continue;
        
        for (Veglenke * vLenke in f.veglenker)
        {
            if(vLenke.lenkeId.intValue == self.vegRef.veglenkeId.intValue && posisjon.doubleValue > vLenke.fra.doubleValue &&
               posisjon.doubleValue < vLenke.til.doubleValue)
            {
                [returDictionary setObject:@"yes" forKey:@"forkjorsveg"];
            }
        }
    }
}

#pragma mark - NVDBResponseDelegate

- (void)svarFraNVDBMedResultat:(NSArray *)resultat
{
    NSLog(@"\n### MOTTAT SVAR FRA NVDB");
    if(resultat == nil || resultat.count == 0)
    {
        NSLog(@"\n### Mottok tomt resultat (NVDB finner ingen objekter som matcher søket)");
        [self.delegate vegObjekterErOppdatert:nil];
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
        NSMutableDictionary * returDictionary = [[NSMutableDictionary alloc] init];
        
        for (NSObject * obj in resultat)
        {
            if ([obj isKindOfClass:[Fartsgrenser class]])
            {
                NSLog(@"\n### Mottatt objekt er av type Fartsgrenser");
                [self leggTilKorrektFart:returDictionary FraFartsgrenser:(Fartsgrenser *)obj];
            }
            if([obj isKindOfClass:[Forkjorsveger class]])
            {
                NSLog(@"\n### Mottatt objekt er av type Forkjørsveger");
                [self settForkjorsvegStatus:returDictionary FraForkjorsveger:(Forkjorsveger *)obj];
            }
        }
        
        [self.delegate vegObjekterErOppdatert:returDictionary];
    }
}

@end
