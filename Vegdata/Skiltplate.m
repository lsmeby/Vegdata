//
//  Skiltplate.m
//  Vegdata
//
//  Created by Lars Smeby on 12.04.13.
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

#import "Skiltplate.h"
#import "SokResultater.h"
#import "Sok.h"
#import "Egenskap.h"

@implementation Skiltplate

@synthesize egenskaper;

- (NSString *)hentSkilttypeFraEgenskaper
{
    for (Egenskap * e in egenskaper)
    {
        if([e.navn isEqualToString:SKILTPLATE_SKILTNUMMER_KEY])
        {
            return e.verdi;
        }
    }
    return INGEN_OBJEKTER;
}

- (NSString *)hentAnsiktssideFraEgenskaper
{
    for (Egenskap * e in egenskaper)
    {
        if([e.navn isEqualToString:SKILTPLATE_ANSIKTSSIDE_KEY])
        {
            return e.verdi;
        }
    }
    return INGEN_OBJEKTER;
}

- (NSString *)hentTekstFraEgenskaper
{
    for (Egenskap * e in egenskaper)
    {
        if([e.navn isEqualToString:SKILTPLATE_TEKST_KEY])
            return e.verdi;
    }
    return INGEN_OBJEKTER;
}

+ (RKObjectMapping *)mapping
{
    return [self standardMappingMedKontainerKlasse:[Skiltplater class]];
}

+ (NSArray *)filtere
{
    return [[NSArray alloc]
            initWithObjects:[[Filter alloc]
                             initMedType:SKILTPLATE_ANSIKTSSIDE_KEY
                             FilterOperator:FILTER_LIK
                             OgVerdier:[[NSArray alloc] initWithObjects:
                                        SKILTPLATE_ANSIKTSSIDE_MED,
                                        SKILTPLATE_ANSIKTSSIDE_MOT,
                                        nil]],
                            [[Filter alloc]
                             initMedType:SKILTPLATE_SKILTNUMMER_KEY
                             FilterOperator:FILTER_LIK
                             OgVerdier:[[NSArray alloc] initWithObjects:
                                        SKILTPLATE_SKILTNUMMER_FARLIGSVING_H,
                                        SKILTPLATE_SKILTNUMMER_FARLIGSVING_V,
                                        SKILTPLATE_SKILTNUMMER_FARLIGESVINGER_H,
                                        SKILTPLATE_SKILTNUMMER_FARLIGESVINGER_V,
                                        SKILTPLATE_SKILTNUMMER_BRATTBAKKE_STIGNING,
                                        SKILTPLATE_SKILTNUMMER_BRATTBAKKE_FALL,
                                        SKILTPLATE_SKILTNUMMER_SMALEREVEG_BEGGE,
                                        SKILTPLATE_SKILTNUMMER_SMALEREVEG_H,
                                        SKILTPLATE_SKILTNUMMER_SMALEREVEG_V,
                                        SKILTPLATE_SKILTNUMMER_UJEVNVEG,
                                        SKILTPLATE_SKILTNUMMER_VEGARBEID,
                                        SKILTPLATE_SKILTNUMMER_STEINSPRUT,
                                        SKILTPLATE_SKILTNUMMER_RASFARE_H,
                                        SKILTPLATE_SKILTNUMMER_RASFARE_V,
                                        SKILTPLATE_SKILTNUMMER_GLATTKJOREBANE,
                                        SKILTPLATE_SKILTNUMMER_FARLIGVEGSKULDER,
                                        SKILTPLATE_SKILTNUMMER_BEVEGELIGBRU,
                                        SKILTPLATE_SKILTNUMMER_KAISTRANDFERJELEIE,
                                        SKILTPLATE_SKILTNUMMER_TUNNEL,
                                        SKILTPLATE_SKILTNUMMER_FARLIGVEGKRYSS,
                                        SKILTPLATE_SKILTNUMMER_RUNDKJORING,
                                        SKILTPLATE_SKILTNUMMER_TRAFIKKLYSSIGNAL,
                                        SKILTPLATE_SKILTNUMMER_AVSTANDTILGANGFELT,
                                        SKILTPLATE_SKILTNUMMER_BARN,
                                        SKILTPLATE_SKILTNUMMER_SYKLENDE,
                                        SKILTPLATE_SKILTNUMMER_KU,
                                        SKILTPLATE_SKILTNUMMER_SAU,
                                        SKILTPLATE_SKILTNUMMER_MOTENDETRAFIKK,
                                        SKILTPLATE_SKILTNUMMER_KO,
                                        SKILTPLATE_SKILTNUMMER_FLY,
                                        SKILTPLATE_SKILTNUMMER_SIDEVIND,
                                        SKILTPLATE_SKILTNUMMER_SKILOPERE,
                                        SKILTPLATE_SKILTNUMMER_RIDENDE,
                                        SKILTPLATE_SKILTNUMMER_ANNENFARE,
                                        SKILTPLATE_SKILTNUMMER_AUTOMATISKTRAFIKKONTROLL,
                                        SKILTPLATE_SKILTNUMMER_VIDEOKONTROLL,
                                        SKILTPLATE_SKILTNUMMER_AVSTAND,
                                        SKILTPLATE_SKILTNUMMER_UTSTREKNING,
                                        SKILTPLATE_SKILTNUMMER_SAERLIGULYKKESFARE_1,
                                        SKILTPLATE_SKILTNUMMER_SAERLIGULYKKESFARE_2,
                                        SKILTPLATE_SKILTNUMMER_SAERLIGULYKKESFARE_3,
                                        SKILTPLATE_SKILTNUMMER_SAERLIGULYKKESFARE_4,
                                        SKILTPLATE_SKILTNUMMER_SAERLIGULYKKESFARE_5,
                                        nil]],
                            nil];
}

+ (NSNumber *)idNr
{
    return [[NSNumber alloc] initWithInt:SKILTPLATE_ID];
}

+ (NSString *)key
{
    return nil;
}

@end
