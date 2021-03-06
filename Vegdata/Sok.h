//
//  Sok.h
//  Vegdata
//
//  Created by Henrik Hermansen on 05.03.13.
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

//@class Lokasjon;

@interface Sok : NSObject
//@property (nonatomic, strong) Lokasjon * lokasjon;
@property (nonatomic, strong) NSArray * veglenker;
@property (nonatomic, strong) NSArray * objektTyper;

+ (NSString *)getURI;
+ (NSString *)getKeyPath;
@end

@interface Lokasjon : NSObject
@property (nonatomic, strong) NSArray * veglenker;
@end

@interface Objekttype : NSObject
@property (nonatomic, strong) NSNumber * typeId;
@property (nonatomic, strong) NSNumber * antall;
@property (nonatomic, strong) NSArray * filtere;
- (id) initMedTypeId:(NSNumber *)aTypeId Antall:(NSNumber *)aAntall OgFiltere:(NSArray *)aFiltere;
@end

@interface Filter : NSObject
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSString * filterOperator;
@property (nonatomic, strong) NSArray * verdier;
- (id) initMedType:(NSString *)aType FilterOperator:(NSString *)aFilterOperator OgVerdier:(NSArray *)aVerdier;
@end