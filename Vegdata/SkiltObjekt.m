//
//  SkiltObjekt.m
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

#import "SkiltObjekt.h"

@implementation SkiltObjekt
@synthesize ansiktsside, avstandEllerUtstrekning;
@end

@implementation VariabelSkiltplate
@synthesize type;
@end

@implementation Farligsving
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return FARLIGSVING_KEY;}
+ (BOOL)objektSkalVises {return [[NSUserDefaults standardUserDefaults] boolForKey:FARLIGSVING_BRUKERPREF];}
@end

@implementation Brattbakke
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return BRATTBAKKE_KEY;}
+ (BOOL)objektSkalVises {return [[NSUserDefaults standardUserDefaults] boolForKey:BRATTBAKKE_BRUKERPREF];}
@end

@implementation Smalereveg
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return SMALEREVEG_KEY;}
+ (BOOL)objektSkalVises {return [[NSUserDefaults standardUserDefaults] boolForKey:SMALEREVEG_BRUKERPREF];}
@end

@implementation Ujevnveg
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return UJEVNVEG_KEY;}
+ (BOOL)objektSkalVises {return [[NSUserDefaults standardUserDefaults] boolForKey:UJEVNVEG_BRUKERPREF];}
@end

@implementation Vegarbeid
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return VEGARBEID_KEY;}
+ (BOOL)objektSkalVises {return [[NSUserDefaults standardUserDefaults] boolForKey:VEGARBEID_BRUKERPREF];}
@end

@implementation Steinsprut
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return STEINSPRUT_KEY;}
+ (BOOL)objektSkalVises {return [[NSUserDefaults standardUserDefaults] boolForKey:STEINSPRUT_BRUKERPREF];}
@end

@implementation Rasfare
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return RASFARE_KEY;}
+ (BOOL)objektSkalVises {return [[NSUserDefaults standardUserDefaults] boolForKey:RASFARE_BRUKERPREF];}
@end

@implementation Glattkjorebane
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return GLATTKJOREBANE_KEY;}
+ (BOOL)objektSkalVises {return [[NSUserDefaults standardUserDefaults] boolForKey:GLATTKJOREBANE_BRUKERPREF];}
@end

@implementation Farligvegskulder
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return FARLIGVEGSKULDER_KEY;}
+ (BOOL)objektSkalVises {return [[NSUserDefaults standardUserDefaults] boolForKey:FARLIGVEGSKULDER_BRUKERPREF];}
@end

@implementation Bevegeligbru
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return BEVEGELIGBRU_KEY;}
+ (BOOL)objektSkalVises {return [[NSUserDefaults standardUserDefaults] boolForKey:BEVEGELIGBRU_BRUKERPREF];}
@end

@implementation KaiStrandFerjeleie
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return KAISTRANDFERJELEIE_KEY;}
+ (BOOL)objektSkalVises {return [[NSUserDefaults standardUserDefaults] boolForKey:KAISTRANDFERJELEIE_BRUKERPREF];}
@end

@implementation Tunnel
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return TUNNEL_KEY;}
+ (BOOL)objektSkalVises {return [[NSUserDefaults standardUserDefaults] boolForKey:TUNNEL_BRUKERPREF];}
@end

@implementation Farligvegkryss
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return FARLIGVEGKRYSS_KEY;}
+ (BOOL)objektSkalVises {return [[NSUserDefaults standardUserDefaults] boolForKey:FARLIGVEGKRYSS_BRUKERPREF];}
@end

@implementation Rundkjoring
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return RUNDKJORING_KEY;}
+ (BOOL)objektSkalVises {return [[NSUserDefaults standardUserDefaults] boolForKey:RUNDKJORING_BRUKERPREF];}
@end

@implementation Trafikklyssignal
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return TRAFIKKLYSSIGNAL_KEY;}
+ (BOOL)objektSkalVises {return [[NSUserDefaults standardUserDefaults] boolForKey:TRAFIKKLYSSIGNAL_BRUKERPREF];}
@end

@implementation Avstandtilgangfelt
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return AVSTANDTILGANGFELT_KEY;}
+ (BOOL)objektSkalVises {return [[NSUserDefaults standardUserDefaults] boolForKey:AVSTANDTILGANGFELT_BRUKERPREF];}
@end

@implementation Barn
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return BARN_KEY;}
+ (BOOL)objektSkalVises {return [[NSUserDefaults standardUserDefaults] boolForKey:BARN_BRUKERPREF];}
@end

@implementation Syklende
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return SYKLENDE_KEY;}
+ (BOOL)objektSkalVises {return [[NSUserDefaults standardUserDefaults] boolForKey:SYKLENDE_BRUKERPREF];}
@end

@implementation Ku
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return KU_KEY;}
+ (BOOL)objektSkalVises {return [[NSUserDefaults standardUserDefaults] boolForKey:KU_BRUKERPREF];}
@end

@implementation Sau
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return SAU_KEY;}
+ (BOOL)objektSkalVises {return [[NSUserDefaults standardUserDefaults] boolForKey:SAU_BRUKERPREF];}
@end

@implementation Motendetrafikk
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return MOTENDETRAFIKK_KEY;}
+ (BOOL)objektSkalVises {return [[NSUserDefaults standardUserDefaults] boolForKey:MOTENDETRAFIKK_BRUKERPREF];}
@end

@implementation Ko
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return KO_KEY;}
+ (BOOL)objektSkalVises {return [[NSUserDefaults standardUserDefaults] boolForKey:KO_BRUKERPREF];}
@end

@implementation Fly
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return FLY_KEY;}
+ (BOOL)objektSkalVises {return [[NSUserDefaults standardUserDefaults] boolForKey:FLY_BRUKERPREF];}
@end

@implementation Sidevind
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return SIDEVIND_KEY;}
+ (BOOL)objektSkalVises {return [[NSUserDefaults standardUserDefaults] boolForKey:SIDEVIND_BRUKERPREF];}
@end

@implementation Skilopere
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return SKILOPERE_KEY;}
+ (BOOL)objektSkalVises {return [[NSUserDefaults standardUserDefaults] boolForKey:SKILOPERE_BRUKERPREF];}
@end

@implementation Ridende
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return RIDENDE_KEY;}
+ (BOOL)objektSkalVises {return [[NSUserDefaults standardUserDefaults] boolForKey:RIDENDE_BRUKERPREF];}
@end

@implementation Annenfare
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return ANNENFARE_KEY;}
+ (BOOL)objektSkalVises {return [[NSUserDefaults standardUserDefaults] boolForKey:ANNENFARE_BRUKERPREF];}
@end

@implementation SaerligUlykkesfare
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return SAERLIGULYKKESFARE_KEY;}
+ (BOOL)objektSkalVises {return [[NSUserDefaults standardUserDefaults] boolForKey:SAERLIGULYKKESFARE_BRUKERPREF];}
@end
