//
//  SokResultater.h
//  Vegdata
//
//  Created by Henrik Hermansen on 06.03.13.
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
#import <Foundation/Foundation.h>

@interface SokResultater : NSObject
@property (nonatomic, strong) NSArray * objekter;
-(id)initMedObjekter:(NSArray *)aObjekter;
@end

@interface Fartsgrenser : SokResultater
@end

@interface Forkjorsveger : SokResultater
@end

@interface Vilttrekks : SokResultater
@end

@interface Motorveger : SokResultater
@end

@interface Hoydebegrensninger : SokResultater
@end

@interface Jernbanekryssinger : SokResultater
@end

@interface Fartsdempere : SokResultater
@end

@interface Rasteplasser : SokResultater
@end

@interface Toaletter : SokResultater
@end

@interface SOSlommer : SokResultater
@end

@interface Skiltplater : SokResultater
@end

@interface Farligesvinger : SokResultater
@end

@interface Brattebakker : SokResultater
@end

@interface Smalereveger : SokResultater
@end

@interface Ujevneveger : SokResultater
@end

@interface Vegarbeids : SokResultater
@end

@interface Steinspruts : SokResultater
@end

@interface Rasfarer : SokResultater
@end

@interface Glattekjorebaner : SokResultater
@end

@interface Farligevegskuldere : SokResultater
@end

@interface Bevegeligebruer : SokResultater
@end

@interface KaiStrandFerjeleies : SokResultater
@end

@interface Tunneler : SokResultater
@end

@interface Farligevegkryss : SokResultater
@end

@interface Rundkjoringer : SokResultater
@end

@interface Trafikklyssignaler : SokResultater
@end

@interface Avstandertilgangfelt : SokResultater
@end

@interface Barns : SokResultater
@end

@interface Syklendes : SokResultater
@end

@interface Kuer : SokResultater
@end

@interface Sauer : SokResultater
@end

@interface Motendetrafikks : SokResultater
@end

@interface Koer : SokResultater
@end

@interface Flys : SokResultater
@end

@interface Sidevinder : SokResultater
@end

@interface Skiloperes : SokResultater
@end

@interface Ridendes : SokResultater
@end

@interface Andrefarer : SokResultater
@end

@interface Automatisketrafikkontroller : SokResultater
@end

@interface Videokontroller : SokResultater
@end

@interface Saerligeulykkesfarer : SokResultater
@end
