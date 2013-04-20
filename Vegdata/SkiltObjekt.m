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
+ (BOOL)objektSkalVises {return YES;}
@end

@implementation Brattbakke
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return BRATTBAKKE_KEY;}
+ (BOOL)objektSkalVises {return YES;}
@end

@implementation Smalereveg
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return SMALEREVEG_KEY;}
+ (BOOL)objektSkalVises {return YES;}
@end

@implementation Ujevnveg
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return UJEVNVEG_KEY;}
+ (BOOL)objektSkalVises {return YES;}
@end

@implementation Vegarbeid
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return VEGARBEID_KEY;}
+ (BOOL)objektSkalVises {return YES;}
@end

@implementation Steinsprut
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return STEINSPRUT_KEY;}
+ (BOOL)objektSkalVises {return YES;}
@end

@implementation Rasfare
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return RASFARE_KEY;}
+ (BOOL)objektSkalVises {return YES;}
@end

@implementation Glattkjorebane
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return GLATTKJOREBANE_KEY;}
+ (BOOL)objektSkalVises {return YES;}
@end

@implementation Farligvegskulder
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return FARLIGVEGSKULDER_KEY;}
+ (BOOL)objektSkalVises {return YES;}
@end

@implementation Bevegeligbru
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return BEVEGELIGBRU_KEY;}
+ (BOOL)objektSkalVises {return YES;}
@end

@implementation KaiStrandFerjeleie
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return KAISTRANDFERJELEIE_KEY;}
+ (BOOL)objektSkalVises {return YES;}
@end

@implementation Tunnel
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return TUNNEL_KEY;}
+ (BOOL)objektSkalVises {return YES;}
@end

@implementation Farligvegkryss
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return FARLIGVEGKRYSS_KEY;}
+ (BOOL)objektSkalVises {return YES;}
@end

@implementation Rundkjoring
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return RUNDKJORING_KEY;}
+ (BOOL)objektSkalVises {return YES;}
@end

@implementation Trafikklyssignal
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return TRAFIKKLYSSIGNAL_KEY;}
+ (BOOL)objektSkalVises {return YES;}
@end

@implementation Avstandtilgangfelt
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return AVSTANDTILGANGFELT_KEY;}
+ (BOOL)objektSkalVises {return YES;}
@end

@implementation Barn
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return BARN_KEY;}
+ (BOOL)objektSkalVises {return YES;}
@end

@implementation Syklende
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return SYKLENDE_KEY;}
+ (BOOL)objektSkalVises {return YES;}
@end

@implementation Ku
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return KU_KEY;}
+ (BOOL)objektSkalVises {return YES;}
@end

@implementation Sau
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return SAU_KEY;}
+ (BOOL)objektSkalVises {return YES;}
@end

@implementation Motendetrafikk
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return MOTENDETRAFIKK_KEY;}
+ (BOOL)objektSkalVises {return YES;}
@end

@implementation Ko
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return KO_KEY;}
+ (BOOL)objektSkalVises {return YES;}
@end

@implementation Fly
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return FLY_KEY;}
+ (BOOL)objektSkalVises {return YES;}
@end

@implementation Sidevind
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return SIDEVIND_KEY;}
+ (BOOL)objektSkalVises {return YES;}
@end

@implementation Skilopere
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return SKILOPERE_KEY;}
+ (BOOL)objektSkalVises {return YES;}
@end

@implementation Ridende
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return RIDENDE_KEY;}
+ (BOOL)objektSkalVises {return YES;}
@end

@implementation Annenfare
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return ANNENFARE_KEY;}
+ (BOOL)objektSkalVises {return YES;}
@end

@implementation AutomatiskTrafikkontroll
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return AUTOMATISKTRAFIKKONTROLL_KEY;}
+ (BOOL)objektSkalVises {return YES;}
@end

@implementation Videokontroll
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return VIDEOKONTROLL_KEY;}
+ (BOOL)objektSkalVises {return YES;}
@end

@implementation SaerligUlykkesfare
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return SAERLIGULYKKESFARE_KEY;}
+ (BOOL)objektSkalVises {return YES;}
@end
