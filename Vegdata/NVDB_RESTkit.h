//
//  NVDB_RESTkit.h
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

#import <Foundation/Foundation.h>
#import "Vegreferanse.h"

@protocol NVDBResponseDelegate
@required
- (void) svarFraNVDBMedResultat:(NSArray *)resultat VeglenkeId:(NSNumber *)lenkeId Vegreferanse:(Vegreferanse *)vegref OgSpoerringsType:(Spoerring)type;
- (void) svarFraMapQuestMedResultat:(NSArray *)resultat OgKey:(NSString *)key;
@end

@interface NVDB_RESTkit : NSObject

@property (nonatomic, assign) id delegate;

- (void) hentDataMedURI:(NSString *)uri Parametere:(NSDictionary *)parametere Mapping:(RKMapping *)mapping KeyPath:(NSString *)keyPath VeglenkeId:(NSNumber *)lenkeId Vegreferanse:(Vegreferanse *)vegref OgSpoerringsType:(Spoerring)type;
- (void) hentAvstandMellomKoordinaterMedParametere:(NSDictionary *)parametere Mapping:(RKMapping *)mapping OgKey:(NSString *)key;

@end
