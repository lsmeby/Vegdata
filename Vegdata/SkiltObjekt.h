//
//  SkiltObjekt.h
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

#import "Vegobjekt.h"

@interface SkiltObjekt : Vegobjekt
@property (nonatomic, strong) NSString * ansiktsside;
@property (nonatomic, strong) NSString * avstandEllerUtstrekning;
@end

@interface VariabelSkiltplate : SkiltObjekt
@property (nonatomic, strong) NSString * type;
@end

@interface Farligsving : VariabelSkiltplate
@end

@interface Brattbakke : VariabelSkiltplate
@end

@interface Smalerevei : VariabelSkiltplate
@end

@interface Ugjevnvei : SkiltObjekt
@end

@interface Vegarbeid : SkiltObjekt
@end

@interface Steinsprut : SkiltObjekt
@end

@interface Rasfare : VariabelSkiltplate
@end

@interface Glattkjorebane : SkiltObjekt
@end

@interface Farligvegskulder : SkiltObjekt
@end

@interface Bevegeligbru : SkiltObjekt
@end

@interface KaiStrandFerjeleie : SkiltObjekt
@end

@interface Tunnel : SkiltObjekt
@end

@interface Farligvegkryss : SkiltObjekt
@end

@interface Rundkjoring : SkiltObjekt
@end

@interface Trafikklyssignal : SkiltObjekt
@end

@interface Avstandtilgangfelt : SkiltObjekt
@end

@interface Barn : SkiltObjekt
@end

@interface Syklende : SkiltObjekt
@end

@interface Ku : SkiltObjekt
@end

@interface Sau : SkiltObjekt
@end

@interface Motendetrafikk : SkiltObjekt
@end

@interface Ko : SkiltObjekt
@end

@interface Fly : SkiltObjekt
@end

@interface Sidevind : SkiltObjekt
@end

@interface Skilopere : SkiltObjekt
@end

@interface Ridende : SkiltObjekt
@end

@interface Annenfare : SkiltObjekt
@end

@interface AutomatiskTrafikkontroll : SkiltObjekt
@end

@interface Videokontroll : SkiltObjekt
@end

@interface SaerligUlykkesfare : VariabelSkiltplate
@end
