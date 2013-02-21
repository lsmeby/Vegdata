//
//  Fartsgrense.m
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

#import "Fartsgrense.h"
#import "Vegreferanse.h"
#import "NVDB_DataProvider.h"

static NSString * const OBJEKTTYPE = @"105";

// Metoder i dette interfacet kan kun aksesseres i denne klassen (aka. private)
@interface Fartsgrense()

- (void)hentFartsgrense;

@end

@implementation Fartsgrense
{
    NVDB_DataProvider * dataProv;
}

@synthesize fart, strekningsLengde;

- (id)init
{
    fart = @"-1";
    strekningsLengde = [[NSNumber alloc] initWithInt: -1];
    dataProv = [[NVDB_DataProvider alloc] init];
    return self;
}

- (void) oppdaterMedBreddegrad:(NSDecimalNumber *)breddegrad OgLengdegrad:(NSDecimalNumber *)lengdegrad
{
    [dataProv hentVegreferanseMedBreddegrad:breddegrad Lengdegrad:lengdegrad OgAvsender:self];
}

- (void)hentFartsgrense
{
    
}

- (void)svarFraNVDBMedResultat:(NSArray *)resultat
{
    NSLog(@"\n### MOTTAT SVAR");
    if([resultat[0] isKindOfClass:[Vegreferanse class]])
    {
        Vegreferanse * vegref = (Vegreferanse *)resultat[0];
        NSLog(@"\n### Mottat objekt er av type Vegreferanse");
    }
}

@end
