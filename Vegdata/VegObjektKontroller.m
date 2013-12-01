//
//  VegObjektController.m
//  Vegdata
//
//  Created by Lars Smeby on 05.03.13.
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

#import "NVDB_DataProvider.h"
#import "VegObjektKontroller.h"
#import "Vegreferanse.h"
#import "Sok.h"
#import "SokResultater.h"
#import "Veglenke.h"
#import "Fartsgrense.h"
#import "Forkjorsveg.h"
#import "Egenskap.h"
#import "Vilttrekk.h"
#import "Motorveg.h"
#import "Hoydebegrensning.h"
#import "Jernbanekryssing.h"
#import "Fartsdemper.h"
#import "Skiltplate.h"
#import "MapQuestRoute.h"
#import "SkiltObjekt.h"
#import "Rasteplass.h"
#import "Toalett.h"
#import "SOSlomme.h"

@interface VegObjektKontroller()

+ (NSArray *)settOppObjektreferanseArray;
- (void)sokMedVegreferanse;
- (NSArray *)hentObjekttyper;
- (RKDynamicMapping *)hentObjektMapping;
- (NSDecimalNumber *)kalkulerVeglenkePosisjon:(Vegreferanse *)vegRef;
- (void)leggTilDataIDictionary:(NSMutableDictionary *)returDictionary FraSokeresultater:(SokResultater *)resultater MedAvstandsArray:(NSMutableArray *)avstand;
- (void)leggTilLinjeDataIDictionary:(NSMutableDictionary *)returDictionary MedVegObjekt:(LinjeObjekt <VegobjektProtokoll> *)objekt;
- (void)leggTilPunktDataIDictionary:(NSMutableDictionary *)returDictionary MedVegObjekt:(PunktObjekt <VegobjektProtokoll> *)objekt OgAvstandsArray:(NSMutableArray *)avstand;
- (void)leggTilSkiltDataIDictionary:(NSMutableDictionary *)returDictionary MedVegObjekt:(SkiltObjekt <VegobjektProtokoll> *)objekt OgAvstandsArray:(NSMutableArray *)avstand;
- (NSMutableDictionary *)opprettReturDictionaryMedDefaultVerdier;
+ (NSDecimalNumber *)diffMellomA:(NSDecimalNumber *)desimalA OgB:(NSDecimalNumber *)desimalB;

@end

@implementation VegObjektKontroller

@synthesize delegate;

- (id)initMedDelegate:(id)delegat OgManagedObjectContext:(NSManagedObjectContext *)context
{
    self.delegate = delegat;
    dataProv = [[NVDB_DataProvider alloc] initMedManagedObjectContext:context OgAvsender:self];
    self.objektreferanse = [VegObjektKontroller settOppObjektreferanseArray];
    self.forrigeRetning = UKJENT;
    self.gjettetVeglenkeID = [[NSNumber alloc] initWithInt:-1];
    self.forrigeNyeVeglenkeID = [[NSNumber alloc] initWithInt:-1];
    return self;
}

+ (NSArray *)settOppObjektreferanseArray
{
    return [[NSArray alloc] initWithObjects:[Fartsgrense class], [Forkjorsveg class], [Vilttrekk class], [Motorveg class], [Hoydebegrensning class], [Jernbanekryssing class], [Fartsdemper class], [Rasteplass class], [Toalett class], [SOSlomme class], [Skiltplate class], [Farligsving class], [Brattbakke class], [Smalereveg class], [Ujevnveg class], [Vegarbeid class], [Steinsprut class], [Rasfare class], [Glattkjorebane class], [Farligvegskulder class], [Bevegeligbru class], [KaiStrandFerjeleie class], [Tunnel class], [Farligvegkryss class], [Rundkjoring class], [Trafikklyssignal class], [Avstandtilgangfelt class], [Barn class], [Syklende class], [Ku class], [Sau class], [Motendetrafikk class], [Ko class], [Fly class], [Sidevind class], [Skilopere class], [Ridende class], [Annenfare class], [AutomatiskTrafikkontroll class], [Videokontroll class], [SaerligUlykkesfare class], nil];
}

- (void)oppdaterMedBreddegrad:(NSDecimalNumber *)breddegrad OgLengdegrad:(NSDecimalNumber *)lengdegrad
{
    [dataProv hentVegreferanseMedBreddegrad:breddegrad Lengdegrad:lengdegrad OgSpoerringsType:NORMAL];
}

#pragma mark - Metoder som forbereder og utfører søk mot dataprovideren

- (void)sokMedVegreferanse
{
    if(self.vegRef == nil)
        return;
    
    Sok * sokObjekt = [[Sok alloc] init];
    sokObjekt.veglenker = self.vegRef.veglenker;
    sokObjekt.objektTyper = [self hentObjekttyper];
    
    RKDynamicMapping * mapping = [self hentObjektMapping];
    
    [dataProv hentVegObjekterMedSokeObjekt:sokObjekt OgMapping:mapping];
}

- (NSArray *)hentObjekttyper
{
    NSMutableArray * objekttyper = [[NSMutableArray alloc] init];
    NSNumber * antall = [[NSNumber alloc] initWithInt:0];
    
    for(Vegobjekt <VegobjektProtokoll> * o in self.objektreferanse)
        if([[o class] idNr])
            [objekttyper addObject:[[Objekttype alloc] initMedTypeId:[[o class] idNr]
                                                              Antall:antall
                                                           OgFiltere:[[o class] filtere]]];

    return objekttyper;
}

- (RKDynamicMapping *) hentObjektMapping
{
    RKDynamicMapping * mapping = [[RKDynamicMapping alloc] init];
    
    for(Vegobjekt <VegobjektProtokoll> * o in self.objektreferanse)
        if([[o class] idNr])
            [mapping addMatcher:[RKObjectMappingMatcher matcherWithKeyPath:VEGOBJEKT_MATCHER_KEY
                                                             expectedValue:[[o class] idNr]
                                                             objectMapping:[[o class] mapping]]];
    
    return mapping;
}

#pragma mark - Metoder som tolker de returnerte objektene

- (void) leggTilDataIDictionary:(NSMutableDictionary *)returDictionary FraSokeresultater:(SokResultater *)resultater MedAvstandsArray:(NSMutableArray *)avstand
{
    if(!returDictionary || !resultater || !resultater.objekter || resultater.objekter.count == 0)
        return;
    
    NSDecimalNumber * posisjon = [self kalkulerVeglenkePosisjon:nil];
    if(!posisjon)
        return;
    
    NSDecimalNumber * naermestePosisjon = [[NSDecimalNumber alloc] initWithInt:-1];
    
    for (Vegobjekt * obj in resultater.objekter)
    {
        if(!obj.veglenker || obj.veglenker.count == 0)
            continue;
        
        for(Veglenke * vLenke in obj.veglenker)
        {
            if(vLenke.lenkeId.intValue == self.vegRef.veglenkeId.intValue)
            {
                if([obj isKindOfClass:[LinjeObjekt class]] && posisjon.doubleValue >= vLenke.fra.doubleValue && posisjon.doubleValue <= vLenke.til.doubleValue)
                // Hvis mottatte objekter er LinjeObjekter og enhetens posisjon er på objektets linje
                {
                    [self leggTilLinjeDataIDictionary:returDictionary MedVegObjekt:(LinjeObjekt <VegobjektProtokoll> *)obj];
                    return;
                }
                
                else if(
                        self.forrigePosisjon
                        &&
                        self.forrigePosisjon.doubleValue >= 0
                        &&
                        (
                            naermestePosisjon.doubleValue < 0
                            ||
                            [VegObjektKontroller diffMellomA:posisjon OgB:vLenke.fra].doubleValue <=
                                [VegObjektKontroller diffMellomA:naermestePosisjon OgB:vLenke.fra].doubleValue
                         )
                        &&
                        (
                            (
                                posisjon.doubleValue > self.forrigePosisjon.doubleValue
                                &&
                                vLenke.fra.doubleValue > posisjon.doubleValue
                                &&
                                (
                                    [obj isKindOfClass:[PunktObjekt class]]
                                    ||
                                    (
                                        [obj isKindOfClass:[SkiltObjekt class]]
                                        &&
                                        [((SkiltObjekt *)obj).ansiktsside isEqualToString:SKILTPLATE_ANSIKTSSIDE_MED]
                                     )
                                 )
                             )
                            ||
                            (
                                posisjon.doubleValue < self.forrigePosisjon.doubleValue
                                &&
                                vLenke.fra.doubleValue < posisjon.doubleValue
                                &&
                                (
                                    [obj isKindOfClass:[PunktObjekt class]]
                                    ||
                                    (
                                        [obj isKindOfClass:[SkiltObjekt class]]
                                        &&
                                        [((SkiltObjekt *)obj).ansiktsside isEqualToString:SKILTPLATE_ANSIKTSSIDE_MOT]
                                     )
                                 )
                             )
                         )
                    )
                //
                // A - [obj isKindOfClass:[PunktObjekt class]]
                // B - [obj isKindOfClass:[SkiltObjekt class]]
                // C - self.forrigePosisjon
                // D - self.forrigePosisjon.doubleValue >= 0
                // E - naermestePosisjon.doubleValue < 0
                // F - [VegObjektKontroller diffMellomA:posisjon OgB:vLenke.fra].doubleValue
                //     <= [VegObjektKontroller diffMellomA:naermestePosisjon OgB:vLenke.fra].doubleValue
                // G - posisjon.doubleValue > self.forrigePosisjon.doubleValue
                // L - posisjon.doubleValue < self.forrigePosisjon.doubleValue
                // H - vLenke.fra.doubleValue > posisjon.doubleValue
                // I - vLenke.fra.doubleValue < posisjon.doubleValue
                // J - [((SkiltObjekt *)obj).ansiktsside isEqualToString:SKILTPLATE_ANSIKTSSIDE_MED]
                // K - [((SkiltObjekt *)obj).ansiktsside isEqualToString:SKILTPLATE_ANSIKTSSIDE_MOT]
                //
                // Hvis vi kjører i stigende retning på en veglenke, og objektet enten er
                // det første eller det nærmeste objektet til enhetens posisjon, samtidig
                // som det har en høyere posisjon enn enheten (altså ligger foran enheten).
                // Hvis objektet er et skiltobjekt må ansiktssiden være med metreringsretning:
                //
                // C && D && G && H && (E || F) && (A || (B && J))
                //
                // Hvis vi kjører i synkende retning på en veglenke, og objektet enten er
                // det første eller det nærmeste objektet til enhetens posisjon, samtidig
                // som det har en lavere posisjon enn enheten (altså ligger foran enheten)
                // Hvis objektet er et skiltobjekt må ansiktssiden være mot metreringsretning:
                //
                // C && D && L && I && (E || F) && (A || (B && K))
                //
                // Setter vi sammen disse får vi:
                //
                // (C && D && G && H && (E || F) && (A || (B && J))) || (C && D && L && I && (E || F) && (A || (B && K)))
                //
                // Med boolsk algebra finner vi at dette er ekvivalent med:
                //
                // C && D && (E || F) && ((G && H && (A || (B && J))) || (L && I && (A || (B && K))))
                //
                {
                    naermestePosisjon = posisjon;
                    
                    if([obj isKindOfClass:[PunktObjekt class]])
                        [self leggTilPunktDataIDictionary:returDictionary MedVegObjekt:(PunktObjekt <VegobjektProtokoll> *)obj OgAvstandsArray:avstand];
                    else if([obj isKindOfClass:[SkiltObjekt class]])
                        [self leggTilSkiltDataIDictionary:returDictionary MedVegObjekt:(SkiltObjekt <VegobjektProtokoll> *)obj OgAvstandsArray:avstand];
                }
            }
        }
    }
}

- (void)leggTilLinjeDataIDictionary:(NSMutableDictionary *)returDictionary MedVegObjekt:(LinjeObjekt <VegobjektProtokoll> *)objekt
{
    NSString * key = [[objekt class] key];
    
    if(![[objekt class] objektSkalVises])
    {
        [returDictionary setObject:INGEN_OBJEKTER forKey:key];
        return;
    }
    
    if ([objekt isKindOfClass:[Fartsgrense class]])
        [returDictionary setObject:[(Fartsgrense *)objekt hentFartFraEgenskaper] forKey:key];
    else if([objekt isKindOfClass:[Vilttrekk class]])
        [returDictionary setObject:[(Vilttrekk *)objekt hentDyreartFraEgenskaper] forKey:key];
    else if ([objekt isKindOfClass:[Motorveg class]])
        [returDictionary setObject:[(Motorveg *)objekt hentTypeFraEgenskaper] forKey:key];
    else
        [returDictionary setObject:key forKey:key];
}

- (void)leggTilPunktDataIDictionary:(NSMutableDictionary *)returDictionary MedVegObjekt:(PunktObjekt <VegobjektProtokoll> *)objekt OgAvstandsArray:(NSMutableArray *)avstand
{
    NSString * key = [[objekt class] key];
    
    if(![[objekt class] objektSkalVises])
    {
        [returDictionary setObject:INGEN_OBJEKTER forKey:key];
        return;
    }
    
    if([objekt isKindOfClass:[Hoydebegrensning class]])
        [returDictionary setObject:[(Hoydebegrensning *)objekt hentHoydebegrensningFraEgenskaper] forKey:key];
    else
        [returDictionary setObject:key forKey:key];
    
    /*NSDictionary * fra = [Vegreferanse hentKoordinaterFraNVDBString:self.vegRef.geometriWgs84];
    NSDictionary * til = [Vegreferanse hentKoordinaterFraNVDBString:objekt.lokasjon];
    
    avstand[0] = [fra objectForKey:VEGREFERANSE_BREDDEGRAD];
    avstand[1] = [fra objectForKey:VEGREFERANSE_LENGDEGRAD];
    avstand[2] = [til objectForKey:VEGREFERANSE_BREDDEGRAD];
    avstand[3] = [til objectForKey:VEGREFERANSE_LENGDEGRAD];
    avstand[4] = key;*/
}

- (void)leggTilSkiltDataIDictionary:(NSMutableDictionary *)returDictionary MedVegObjekt:(SkiltObjekt <VegobjektProtokoll> *)objekt OgAvstandsArray:(NSMutableArray *)avstand
{
    NSString * key = [[objekt class] key];
    
    if(![[objekt class] objektSkalVises])
    {
        [returDictionary setObject:INGEN_OBJEKTER forKey:key];
        return;
    }
    
    if([objekt isKindOfClass:[VariabelSkiltplate class]])
    {
        if(objekt.avstandEllerUtstrekning)
            [returDictionary setObject:[@[((VariabelSkiltplate *)objekt).type, objekt.avstandEllerUtstrekning]
                                        componentsJoinedByString:SKILLETEGN_SKILTOBJEKTER]
                                forKey:key];
        else
            [returDictionary setObject:((VariabelSkiltplate *)objekt).type forKey:key];
    }
    else if(objekt.avstandEllerUtstrekning)
        [returDictionary setObject:objekt.avstandEllerUtstrekning forKey:key];
    else
        [returDictionary setObject:key forKey:key];

    /*NSDictionary * fra = [Vegreferanse hentKoordinaterFraNVDBString:self.vegRef.geometriWgs84];
    NSDictionary * til = [Vegreferanse hentKoordinaterFraNVDBString:objekt.lokasjon];
    
    avstand[0] = [fra objectForKey:VEGREFERANSE_BREDDEGRAD];
    avstand[1] = [fra objectForKey:VEGREFERANSE_LENGDEGRAD];
    avstand[2] = [til objectForKey:VEGREFERANSE_BREDDEGRAD];
    avstand[3] = [til objectForKey:VEGREFERANSE_LENGDEGRAD];
    avstand[4] = key;*/
}

- (NSDecimalNumber *)kalkulerVeglenkePosisjon: (Vegreferanse *) vegRef
{
    if(vegRef == nil)
        vegRef = self.vegRef;
    
    if(vegRef == nil || vegRef.veglenker == nil || vegRef.veglenker.count == 0)
        return nil;
    
    double intervall = ((Veglenke *)vegRef.veglenker[0]).til.doubleValue - ((Veglenke *)vegRef.veglenker[0]).fra.doubleValue;
    double returPos = ((Veglenke *)vegRef.veglenker[0]).fra.doubleValue + (intervall * vegRef.veglenkePosisjon.doubleValue);
    
    return [[NSDecimalNumber alloc] initWithDouble:returPos];
}

+ (NSDecimalNumber *)diffMellomA:(NSDecimalNumber *)desimalA OgB:(NSDecimalNumber *)desimalB
{
    if(desimalA.doubleValue < desimalB.doubleValue)
        return [desimalB decimalNumberBySubtracting:desimalA];
    else
        return [desimalA decimalNumberBySubtracting:desimalB];
}

#pragma mark - NVDBResponseDelegate

- (void)svarFraNVDBMedResultat:(NSArray *)resultat VeglenkeId:(NSNumber *)lenkeId Vegreferanse:(Vegreferanse *)vegref OgSpoerringsType:(Spoerring)type
{
    if(resultat == nil || resultat.count == 0)
    {
        NSLog(@"Mottok tomt resultat (NVDB finner ingen objekter som matcher søket)");
        NSMutableDictionary * returDictionary = [self opprettReturDictionaryMedDefaultVerdier];
        [self.delegate vegObjekterErOppdatert:returDictionary];
    }
    else if([resultat[0] isKindOfClass:[Vegreferanse class]])
    {
        Vegreferanse * nyVegref = ((Vegreferanse *)resultat[0]);
        if(!self.vegRef)
            self.vegRef = nyVegref;
        
        if(type == GJETNING)
        {
            self.gjettetVeglenkeID = nyVegref.veglenkeId;
            return;
        }
        if(type == VEGLENKEENDE)
        {
            [self gjettVeglenkeMedEndevegref:nyVegref];
            return;
        }
        if(self.vegRef && self.vegRef.veglenkeId.intValue == nyVegref.veglenkeId.intValue)
        {
            self.forrigePosisjon = [self kalkulerVeglenkePosisjon:self.vegRef];
            self.forrigeNyeVeglenkeID = [[NSNumber alloc] initWithInt:-1];
            
            // følgende skal være gjort, men må testes
            // finne ut hvilken retning på veglenken vi kjører
            // hvis retningen er endret, eller vi ikke har gjettet på neste veglenke - utfør gjetting
            
            self.vegRef = (Vegreferanse *)resultat[0];
            
            NSDecimalNumber * nyPosisjon = [self kalkulerVeglenkePosisjon:self.vegRef];
            
            Retning nyRetning = UKJENT;
            
            double posisjonsDiff = nyPosisjon.doubleValue - self.forrigePosisjon.doubleValue;
            
            if(posisjonsDiff > 0)
                nyRetning = STIGENDE;
            else if(posisjonsDiff < 0)
                nyRetning = SYNKENDE;
            else
                nyRetning = UKJENT;
            
            if(nyRetning != UKJENT && self.forrigeRetning != nyRetning)
            {
                self.forrigeRetning = nyRetning;
                [self finnEndevegrefOgGjettVeglenke];
            }
            
            [self sokMedVegreferanse];
        }
        else
        {
            if(nyVegref.veglenkeId.intValue == self.gjettetVeglenkeID.intValue || nyVegref.veglenkeId.intValue == self.forrigeNyeVeglenkeID.intValue) {
                self.gjettetVeglenkeID = [[NSNumber alloc] initWithInt:-1];
                self.forrigeNyeVeglenkeID = [[NSNumber alloc] initWithInt:-1];
                self.forrigePosisjon = [[NSDecimalNumber alloc] initWithInt:-1];
                self.forrigeRetning = UKJENT;
            
                self.vegRef = nyVegref;
                [self sokMedVegreferanse];
            }
            else
                self.forrigeNyeVeglenkeID = nyVegref.veglenkeId;
            
            
            // følgende skal være gjort, men må testes
            // hvis den nye veglenken er den vi gjettet på, eller hvis den nye veglenken er den samme 2 cycles på rad - kjør søk med vegreferanse
            // hvis ikke - noter og ignorer veglenke
        }
    }
    else
    {
        NSLog(@"Mottatt søkeresultater: %d objekttype(r)", resultat.count);
        NSMutableDictionary * returDictionary = [self opprettReturDictionaryMedDefaultVerdier];
        
        NSMutableArray * avstandsdata = [[NSMutableArray alloc] initWithCapacity:5];
        
        for (NSObject * obj in resultat)
            if ([obj isKindOfClass:[SokResultater class]])
            {
                [avstandsdata removeAllObjects];
                
                [self leggTilDataIDictionary:returDictionary FraSokeresultater:(SokResultater *)obj MedAvstandsArray:avstandsdata];
                
                /*if([avstandsdata count] > 0)
                    [dataProv hentAvstandmedKoordinaterAX:avstandsdata[0]
                                                       AY:avstandsdata[1]
                                                       BX:avstandsdata[2]
                                                       BY:avstandsdata[3]
                                                    ogKey:avstandsdata[4]];*/
            }
        
        [self.delegate vegObjekterErOppdatert:returDictionary];
    }
}

- (void) finnEndevegrefOgGjettVeglenke
{
    int posisjonsInt;
    if(self.forrigeRetning == STIGENDE)
        posisjonsInt = 1;
    else if(self.forrigeRetning == SYNKENDE)
        posisjonsInt = 0;
    else
        posisjonsInt = -1;
    
    NSDecimalNumber * posisjon = [[NSDecimalNumber alloc] initWithInt:posisjonsInt];
    
    [dataProv hentVegreferanseMedVeglenkeID:self.vegRef.veglenkeId OgPosisjon:posisjon];
}

- (void) gjettVeglenkeMedEndevegref:(Vegreferanse *)vegRef
{
    /*
     * Feiler fordi vi ser på vegreferansens koordinater.
     * Vi må bruke retning for så å hente vegreferansen ved veglenkens posisjon 0 eller 1.
     * Deretter kan vi bruke denne vegreferansen slik vi nå gjør med den vi har.
     */
    
    NSArray * rawKoordinater = [vegRef.geometriWgs84 componentsSeparatedByString:@", "];
    if(!rawKoordinater || [rawKoordinater count] < 2)
        return;
    
    NSString * fra;
    NSString * til;
    
    if(self.forrigeRetning == STIGENDE)
    {
        fra = rawKoordinater[[rawKoordinater count] - 2];
        NSArray * rawTil = [[rawKoordinater lastObject] componentsSeparatedByString:@")"];
        til = rawTil[0];
    }
    else if(self.forrigeRetning == SYNKENDE)
    {
        fra = rawKoordinater[1];
        NSArray * rawTil = [[rawKoordinater lastObject] componentsSeparatedByString:@"("];
        til = [rawTil lastObject];
    }
    
    NSArray * fraKoordArray = [fra componentsSeparatedByString:@" "];
    NSArray * tilKoordArray = [til componentsSeparatedByString:@" "];
    
    NSDecimalNumber * fraX = [[NSDecimalNumber alloc] initWithDouble:[((NSString *)fraKoordArray[1]) doubleValue]];
    NSDecimalNumber * fraY = [[NSDecimalNumber alloc] initWithDouble:[((NSString *)fraKoordArray[0]) doubleValue]];
    NSDecimalNumber * tilX = [[NSDecimalNumber alloc] initWithDouble:[((NSString *)tilKoordArray[1]) doubleValue]];
    NSDecimalNumber * tilY = [[NSDecimalNumber alloc] initWithDouble:[((NSString *)tilKoordArray[0]) doubleValue]];
    
    NSDecimalNumber * gjettetX = [[NSDecimalNumber alloc] initWithDouble:(tilX.doubleValue - fraX.doubleValue) + tilX.doubleValue];
    NSDecimalNumber * gjettetY = [[NSDecimalNumber alloc] initWithDouble:(tilY.doubleValue - fraY.doubleValue) + tilY.doubleValue];
    
    [dataProv hentVegreferanseMedBreddegrad:gjettetX Lengdegrad:gjettetY OgSpoerringsType:GJETNING];
}

- (void) svarFraMapQuestMedResultat:(NSArray *)resultat OgKey:(NSString *)key
{
    if(resultat && [resultat count] > 0)
    {
        MapQuestRoute * mQMap = resultat[0];
        if(mQMap.status.intValue == 0)
        {
            NSDecimalNumber * avst;
            
            for(NSDecimalNumber * km in mQMap.avstand)
            {
                if(!avst || km.doubleValue > avst.doubleValue)
                    avst = km;
            }
            
            [self.delegate avstandTilPunktobjekt:avst MedKey:key];
        }
    }
}

- (NSMutableDictionary *) opprettReturDictionaryMedDefaultVerdier
{
    NSMutableDictionary * returDictionary = [[NSMutableDictionary alloc] init];
    
    for(Vegobjekt <VegobjektProtokoll> * o in self.objektreferanse)
        if([[o class] key])
            [returDictionary setObject:INGEN_OBJEKTER forKey:[[o class] key]];
    
    return returDictionary;
}

@end
