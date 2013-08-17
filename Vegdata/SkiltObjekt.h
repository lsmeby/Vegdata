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

@interface Farligsving : VariabelSkiltplate <VegobjektProtokoll>
@end

@interface Brattbakke : VariabelSkiltplate <VegobjektProtokoll>
@end

@interface Smalereveg : VariabelSkiltplate <VegobjektProtokoll>
@end

@interface Ujevnveg : SkiltObjekt <VegobjektProtokoll>
@end

@interface Vegarbeid : SkiltObjekt <VegobjektProtokoll>
@end

@interface Steinsprut : SkiltObjekt <VegobjektProtokoll>
@end

@interface Rasfare : VariabelSkiltplate <VegobjektProtokoll>
@end

@interface Glattkjorebane : SkiltObjekt <VegobjektProtokoll>
@end

@interface Farligvegskulder : SkiltObjekt <VegobjektProtokoll>
@end

@interface Bevegeligbru : SkiltObjekt <VegobjektProtokoll>
@end

@interface KaiStrandFerjeleie : SkiltObjekt <VegobjektProtokoll>
@end

@interface Tunnel : SkiltObjekt <VegobjektProtokoll>
@end

@interface Farligvegkryss : SkiltObjekt <VegobjektProtokoll>
@end

@interface Rundkjoring : SkiltObjekt <VegobjektProtokoll>
@end

@interface Trafikklyssignal : SkiltObjekt <VegobjektProtokoll>
@end

@interface Avstandtilgangfelt : SkiltObjekt <VegobjektProtokoll>
@end

@interface Barn : SkiltObjekt <VegobjektProtokoll>
@end

@interface Syklende : SkiltObjekt <VegobjektProtokoll>
@end

@interface Ku : SkiltObjekt <VegobjektProtokoll>
@end

@interface Sau : SkiltObjekt <VegobjektProtokoll>
@end

@interface Motendetrafikk : SkiltObjekt <VegobjektProtokoll>
@end

@interface Ko : SkiltObjekt <VegobjektProtokoll>
@end

@interface Fly : SkiltObjekt <VegobjektProtokoll>
@end

@interface Sidevind : SkiltObjekt <VegobjektProtokoll>
@end

@interface Skilopere : SkiltObjekt <VegobjektProtokoll>
@end

@interface Ridende : SkiltObjekt <VegobjektProtokoll>
@end

@interface Annenfare : SkiltObjekt <VegobjektProtokoll>
@end

@interface AutomatiskTrafikkontroll : SkiltObjekt <VegobjektProtokoll>
@end

@interface Videokontroll : SkiltObjekt <VegobjektProtokoll>
@end

@interface SaerligUlykkesfare : VariabelSkiltplate <VegobjektProtokoll>
@end
