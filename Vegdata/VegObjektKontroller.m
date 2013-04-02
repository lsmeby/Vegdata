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
#import "Hoydebegrensning.h"
#import "Jernbanekryssing.h"
#import "Fartsdemper.h"

@interface VegObjektKontroller()

- (void)sokMedVegreferanse;
- (NSArray *)hentObjekttyper;
- (RKDynamicMapping *)hentObjektMapping;
- (NSDecimalNumber *)kalkulerVeglenkePosisjon;
- (void)leggTilDataIDictionary:(NSMutableDictionary *)returDictionary FraSokeresultater:(SokResultater *)resultater;
- (void)leggTilLinjeDataIDictionary:(NSMutableDictionary *)returDictionary MedVegObjekt:(Vegobjekt *)objekt;
- (void)leggTilPunktDataIDictionary:(NSMutableDictionary *)returDictionary MedVegObjekt:(Vegobjekt *)objekt;
- (NSMutableDictionary *)opprettReturDictionaryMedDefaultVerdier;
+ (NSDecimalNumber *)diffMellomA:(NSDecimalNumber *)desimalA OgB:(NSDecimalNumber *)desimalB;

@end

@implementation VegObjektKontroller

@synthesize delegate;

- (id)initMedDelegate:(id)delegat OgManagedObjectContext:(NSManagedObjectContext *)context
{
    self.delegate = delegate;
    dataProv = [[NVDB_DataProvider alloc] initMedManagedObjectContrext:context];
    return self;
}

- (void)oppdaterMedBreddegrad:(NSDecimalNumber *)breddegrad OgLengdegrad:(NSDecimalNumber *)lengdegrad
{
    [dataProv hentVegreferanseMedBreddegrad:breddegrad Lengdegrad:lengdegrad OgAvsender:self];
}

#pragma mark - Metoder som forbereder og utfører søk mot dataprovideren

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
                                                      Antall:[[NSNumber alloc] initWithInt:0] OgFiltere:nil]];
    [objekttyper addObject:[[Objekttype alloc] initMedTypeId:[[NSNumber alloc] initWithInt:291]
                                                      Antall:[[NSNumber alloc] initWithInt:0] OgFiltere:nil]];
    [objekttyper addObject:[[Objekttype alloc] initMedTypeId:[[NSNumber alloc] initWithInt:591]
                                                      Antall:[[NSNumber alloc] initWithInt:0] OgFiltere:nil]];
    [objekttyper addObject:[[Objekttype alloc] initMedTypeId:[[NSNumber alloc] initWithInt:100]
                                                      Antall:[[NSNumber alloc] initWithInt:0] OgFiltere:nil]];
    [objekttyper addObject:[[Objekttype alloc] initMedTypeId:[[NSNumber alloc] initWithInt:103]
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
    [mapping addMatcher:[RKObjectMappingMatcher matcherWithKeyPath:@"typeId"
                                                     expectedValue:[[NSNumber alloc] initWithInt:591]
                                                     objectMapping:[Hoydebegrensning mapping]]];
    [mapping addMatcher:[RKObjectMappingMatcher matcherWithKeyPath:@"typeId"
                                                     expectedValue:[[NSNumber alloc] initWithInt:100]
                                                     objectMapping:[Jernbanekryssing mapping]]];
    [mapping addMatcher:[RKObjectMappingMatcher matcherWithKeyPath:@"typeId"
                                                     expectedValue:[[NSNumber alloc] initWithInt:103]
                                                     objectMapping:[Fartsdemper mapping]]];
    return mapping;
}

#pragma mark - Metoder som tolker de returnerte objektene

- (void) leggTilDataIDictionary:(NSMutableDictionary *)returDictionary FraSokeresultater:(SokResultater *)resultater
{
    if(returDictionary == nil || resultater == nil || resultater.objekter == nil || resultater.objekter.count == 0)
        return;
    
    NSDecimalNumber * posisjon = [self kalkulerVeglenkePosisjon];
    if(posisjon == nil)
        return;
    
    NSDecimalNumber * naermestePosisjon;
    
    for (Vegobjekt * obj in resultater.objekter)
    {
        if(obj.veglenker == nil || obj.veglenker.count == 0)
            continue;
        
        for(Veglenke * vLenke in obj.veglenker)
        {
            if(vLenke.lenkeId.intValue == self.vegRef.veglenkeId.intValue)
            {
                if([obj isKindOfClass:[LinjeObjekt class]] && posisjon.doubleValue >= vLenke.fra.doubleValue && posisjon.doubleValue <= vLenke.til.doubleValue)
                // Hvis mottatte objekter er LinjeObjekter og enhetens posisjon er på objektets linje
                {
                    [self leggTilLinjeDataIDictionary:returDictionary MedVegObjekt:obj];
                    return;
                }
                else if([obj isKindOfClass:[PunktObjekt class]])
                // Hvis mottatte objekter er PunktObjekter
                {
                    if(!naermestePosisjon)
                        naermestePosisjon = [[NSDecimalNumber alloc] initWithInt:-1];
                
                    // A - self.forrigePosisjon == nil
                    // B - self.forrigePosisjon.doubleValue < 0
                    // C - naermestePosisjon.doubleValue < 0
                    // D - [VegObjektKontroller diffMellomA:posisjon OgB:vLenke.fra].doubleValue
                    //     <= [VegObjektKontroller diffMellomA:naermestePosisjon OgB:vLenke.fra].doubleValue
                    // E - posisjon.doubleValue >= self.forrigePosisjon.doubleValue
                    // F - vLenke.fra.doubleValue > posisjon.doubleValue
                    // G - vLenke.fra.doubleValue < posisjon.doubleValue
                    //
                    // Hvis vi ikke vet hvilken vei vi kjører på en veglenke, og objektet enten
                    // er det første eller det nærmeste objektet til enhetens posisjon:
                    //
                    // (A || B) && (C || D)
                    //
                    // Hvis vi kjører i stigende retning på en veglenke, og objektet enten er
                    // det første eller det nærmeste objektet til enhetens posisjon, samtidig
                    // som det har en høyere posisjon enn enheten (altså ligger foran enheten):
                    //
                    // E && F && (C || D)
                    //
                    // Hvis vi kjører i synkende retning på en veglenke, og objektet enten er
                    // det første eller det nærmeste objektet til enhetens posisjon, samtidig
                    // som det har en lavere posisjon enn enheten (altså ligger foran enheten):
                    //
                    // G && (C && D)
                    //
                    // Setter vi sammen disse får vi:
                    //
                    // ((A || B) && (C || D)) || (E && F && (C || D)) || (G && (C || D))
                    //
                    // Med boolsk algebra finner vi at dette er ekvivalent med:
                    //
                    // (A || B || E || G) && (A || B || F || G) && (C || D)
                    //
                    // Dette gir if-testen under:
                    
                    if((self.forrigePosisjon == nil ||
                        self.forrigePosisjon.doubleValue < 0 ||
                        posisjon.doubleValue >= self.forrigePosisjon.doubleValue ||
                        vLenke.fra.doubleValue < posisjon.doubleValue)
                        &&
                       (self.forrigePosisjon == nil ||
                        self.forrigePosisjon.doubleValue < 0 ||
                        vLenke.fra.doubleValue > posisjon.doubleValue ||
                        vLenke.fra.doubleValue < posisjon.doubleValue)
                        &&
                       (naermestePosisjon.doubleValue < 0 ||
                        [VegObjektKontroller diffMellomA:posisjon OgB:vLenke.fra].doubleValue <=
                        [VegObjektKontroller diffMellomA:naermestePosisjon OgB:vLenke.fra].doubleValue))
                    {
                        naermestePosisjon = posisjon;
                        [self leggTilPunktDataIDictionary:returDictionary MedVegObjekt:obj];
                    }
                }
            }
        }
    }
}

- (void)leggTilLinjeDataIDictionary:(NSMutableDictionary *)returDictionary MedVegObjekt:(Vegobjekt *)objekt
{
    if ([objekt isKindOfClass:[Fartsgrense class]])
        [returDictionary setObject:[(Fartsgrense *)objekt hentFartFraEgenskaper] forKey:@"fart"];
    
    else if ([objekt isKindOfClass:[Forkjorsveg class]])
        [returDictionary setObject:@"yes" forKey:@"forkjorsveg"];
    
    else if ([objekt isKindOfClass:[Vilttrekk class]])
    {
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"fare_vilttrekk"])
            [returDictionary setObject:@"-1" forKey:@"vilttrekk"];
        else
            [returDictionary setObject:[(Vilttrekk *)objekt hentDyreartFraEgenskaper] forKey:@"vilttrekk"]; // Trenger filter for å unngå vilttrekk over/under veg
    }
}

- (void)leggTilPunktDataIDictionary:(NSMutableDictionary *)returDictionary MedVegObjekt:(Vegobjekt *)objekt
{
    if([objekt isKindOfClass:[Hoydebegrensning class]])
    {
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"fare_hoydebegrensning"])
            [returDictionary setObject:@"-1" forKey:@"hoydebegrensning"];
        else
            [returDictionary setObject:[(Hoydebegrensning *)objekt hentHoydebegrensningFraEgenskaper] forKey:@"hoydebegrensning"];
    }
    
    else if([objekt isKindOfClass:[Jernbanekryssing class]])
    {
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"fare_jernbanekryssing"])
            [returDictionary setObject:@"-1" forKey:@"jernbanekryssing"];
        else
        {
            NSString * kryssing = [(Jernbanekryssing *)objekt hentTypeFraEgenskaper];
            if(![kryssing isEqualToString:@"Veg over"] && ![kryssing isEqualToString:@"Veg under"]) // Erstattes av filter
                [returDictionary setObject:kryssing forKey:@"jernbanekryssing"];
        }
    }
    
    else if([objekt isKindOfClass:[Fartsdemper class]])
    {
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"fare_fartsdemper"])
            [returDictionary setObject:@"-1" forKey:@"fartsdemper"];
        else
        {
            NSString * demper = [(Fartsdemper *)objekt hentTypeFraEgenskaper];
            if(![demper isEqualToString:@"Rumlefelt"]) // Erstattes av filter
                [returDictionary setObject:demper forKey:@"fartsdemper"];
        }
    }
}

- (NSDecimalNumber *)kalkulerVeglenkePosisjon
{
    if(self.vegRef == nil || self.vegRef.veglenker == nil || self.vegRef.veglenker.count == 0)
        return nil;
    
    double intervall = ((Veglenke *)self.vegRef.veglenker[0]).til.doubleValue - ((Veglenke *)self.vegRef.veglenker[0]).fra.doubleValue;
    double returPos = ((Veglenke *)self.vegRef.veglenker[0]).fra.doubleValue + (intervall * self.vegRef.veglenkePosisjon.doubleValue);
    
    return [[NSDecimalNumber alloc] initWithDouble:returPos];
}

+ (NSDecimalNumber *)diffMellomA:(NSDecimalNumber *)desimalA OgB:(NSDecimalNumber *)desimalB
{
    if(desimalA.doubleValue < desimalB.doubleValue)
        return [desimalB decimalNumberBySubtracting:desimalA];
    else
        return [desimalA decimalNumberBySubtracting:desimalB];
}

#pragma mark - NVDBResponseDelegate

- (void)svarFraNVDBMedResultat:(NSArray *)resultat
{
    if(resultat == nil || resultat.count == 0)
    {
        NSLog(@"\n### Mottok tomt resultat (NVDB finner ingen objekter som matcher søket)");
        NSMutableDictionary * returDictionary = [self opprettReturDictionaryMedDefaultVerdier];
        [self.delegate vegObjekterErOppdatert:returDictionary];
    }
    else if([resultat[0] isKindOfClass:[Vegreferanse class]])
    {
        if(self.vegRef != nil && self.vegRef.veglenkeId.intValue == ((Vegreferanse *)resultat[0]).veglenkeId.intValue)
            self.forrigePosisjon = [self kalkulerVeglenkePosisjon];
        else
            self.forrigePosisjon = [[NSDecimalNumber alloc] initWithInt:-1];
        
        self.vegRef = (Vegreferanse *)resultat[0];
        [self sokMedVegreferanse];
    }
    else
    {
        NSLog(@"\n### Mottatt søkeresultater: %d objekttype(r)", resultat.count);
        NSMutableDictionary * returDictionary = [self opprettReturDictionaryMedDefaultVerdier];
        
        for (NSObject * obj in resultat)
            if ([obj isKindOfClass:[SokResultater class]])
                [self leggTilDataIDictionary:returDictionary FraSokeresultater:(SokResultater *)obj];
        
        [self.delegate vegObjekterErOppdatert:returDictionary];
    }
}

- (NSMutableDictionary *) opprettReturDictionaryMedDefaultVerdier
{
    NSMutableDictionary * returDictionary = [[NSMutableDictionary alloc] init];
    
    // Legger  til default-verdier så viewet vet at det ble søkt etter men ikke funnet objekter
    [returDictionary setObject:@"-1" forKey:@"fart"];
    [returDictionary setObject:@"no" forKey:@"forkjorsveg"];
    [returDictionary setObject:@"-1" forKey:@"vilttrekk"];
    [returDictionary setObject:@"-1" forKey:@"hoydebegrensning"];
    [returDictionary setObject:@"-1" forKey:@"jernbanekryssing"];
    [returDictionary setObject:@"-1" forKey:@"fartsdemper"];
    
    return returDictionary;
}

@end
