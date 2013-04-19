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
@end

@implementation Brattbakke
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return BRATTBAKKE_KEY;}
@end

@implementation Smalereveg
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return SMALEREVEG_KEY;}
@end

@implementation Ujevnveg
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return UJEVNVEG_KEY;}
@end

@implementation Vegarbeid
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return VEGARBEID_KEY;}
@end

@implementation Steinsprut
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return STEINSPRUT_KEY;}
@end

@implementation Rasfare
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return RASFARE_KEY;}
@end

@implementation Glattkjorebane
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return GLATTKJOREBANE_KEY;}
@end

@implementation Farligvegskulder
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return FARLIGVEGSKULDER_KEY;}
@end

@implementation Bevegeligbru
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return BEVEGELIGBRU_KEY;}
@end

@implementation KaiStrandFerjeleie
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return KAISTRANDFERJELEIE_KEY;}
@end

@implementation Tunnel
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return TUNNEL_KEY;}
@end

@implementation Farligvegkryss
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return FARLIGVEGKRYSS_KEY;}
@end

@implementation Rundkjoring
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return RUNDKJORING_KEY;}
@end

@implementation Trafikklyssignal
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return TRAFIKKLYSSIGNAL_KEY;}
@end

@implementation Avstandtilgangfelt
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return AVSTANDTILGANGFELT_KEY;}
@end

@implementation Barn
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return BARN_KEY;}
@end

@implementation Syklende
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return SYKLENDE_KEY;}
@end

@implementation Ku
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return KU_KEY;}
@end

@implementation Sau
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return SAU_KEY;}
@end

@implementation Motendetrafikk
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return MOTENDETRAFIKK_KEY;}
@end

@implementation Ko
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return KO_KEY;}
@end

@implementation Fly
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return FLY_KEY;}
@end

@implementation Sidevind
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return SIDEVIND_KEY;}
@end

@implementation Skilopere
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return SKILOPERE_KEY;}
@end

@implementation Ridende
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return RIDENDE_KEY;}
@end

@implementation Annenfare
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return ANNENFARE_KEY;}
@end

@implementation AutomatiskTrafikkontroll
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return AUTOMATISKTRAFIKKONTROLL_KEY;}
@end

@implementation Videokontroll
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return VIDEOKONTROLL_KEY;}
@end

@implementation SaerligUlykkesfare
+ (RKObjectMapping *)mapping {return nil;}
+ (NSArray *)filtere {return nil;}
+ (NSNumber *)idNr {return nil;}
+ (NSString *)key {return SAERLIGULYKKESFARE_KEY;}
@end
