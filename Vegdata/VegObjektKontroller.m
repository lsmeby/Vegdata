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
#import "Veglenke.h"
#import "Fartsgrense.h"

@interface VegObjektKontroller()

- (void)sokMedVegreferanse:(Vegreferanse *)vegreferanse;
- (NSArray *)hentObjekttyper;
- (RKDynamicMapping *) hentObjektMapping;

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

- (void)sokMedVegreferanse:(Vegreferanse *)vegreferanse
{
    Sok * sokObjekt = [[Sok alloc] init];
    sokObjekt.lokasjon = [[Lokasjon alloc] init];
    sokObjekt.lokasjon.veglenker = vegreferanse.veglenker;
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
    [mapping addMatcher:[RKObjectMappingMatcher matcherWithKeyPath:@"objektTypeNavn"
                                                     expectedValue:@"Fartsgrense"
                                                     objectMapping:[Fartsgrense mapping]]];
    return mapping;
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
        Vegreferanse * vegref = (Vegreferanse *)resultat[0];
        [self sokMedVegreferanse:vegref];
    }
    else
    {
        NSLog(@"HEI");
    }
}

@end
