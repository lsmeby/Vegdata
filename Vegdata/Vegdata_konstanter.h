//
//  Vegdata_konstanter.h
//  Vegdata
//
//  Created by Lars Smeby on 11.04.13.
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

#ifndef Vegdata_Vegdata_konstanter_h
#define Vegdata_Vegdata_konstanter_h


// -- URL'ER --

#define NVDB_GRUNN_URL @"http://nvdb1.demo.bekk.no:7001/nvdb/api"
//#define NVDB_GRUNN_URL @"https://www.vegvesen.no/nvdb/api"
#define MAPQUEST_GRUNN_URL @"http://open.mapquestapi.com"
#define MAPQUEST_MATRIX_URL @"/directions/v1/routematrix"
#define MAPQUEST_KEY @"Fmjtd|luub2qu72h,8l=o5-96105y"


// -- POSISJON --

#define POS_OPPDATERING_SEK 2
#define POS_MSEK_TIL_KMT 3.6
#define POS_OPPDATERING_METER 5
#define POS_OPPDATERING_SEK_VED_BEVEGELSE_STOPP (POS_OPPDATERING_SEK * 10)


// -- DATAPROVIDER --

#define NVDB_GEOMETRI @"WGS84"
#define WGS84_BBOX_RADIUS 0.0001
#define SEKUNDER_PER_DAG 86400
#define DAGER_MELLOM_NY_OPPDATERING 30


// -- VEGOBJEKTER --

#define INGEN_OBJEKTER @"-1"

#define VEGREFERANSE_BREDDEGRAD @"breddegrad"
#define VEGREFERANSE_LENGDEGRAD @"lengdegrad"

#define FARTSGRENSE_ID 105
#define FARTSGRENSE_KEY @"fartsgrense"
#define FARTSGRENSE_CD @"CD_Fartsgrense"
#define FARTSGRENSE_FART_KEY @"Fartsgrense"

#define FORKJORSVEG_ID 596
#define FORKJORSVEG_KEY @"forkjorsveg"
#define FORKJORSVEG_CD @"CD_Forkjorsveg"
#define FORKJORSVEG_YES @"yes"
#define FORKJORSVEG_BRUKERPREF @"skilt_forkjorsveg"

#define VILTTREKK_ID 291
#define VILTTREKK_KEY @"vilttrekk"
#define VILTTREKK_CD @"CD_Vilttrekk"
#define VILTTREKK_TYPE_ELG @"Elg"
#define VILTTREKK_TYPE_HJORT @"Hjort"
#define VILTTREKK_TYPE_REIN @"Rein"
#define VILTTREKK_TYPE_KEY @"Dyreart"
#define VILTTREKK_FILTER_OVER @"Over, ledet"
#define VILTTREKK_FILTER_UNDER @"Under, ledet"
#define VILTTREKK_FILTER_KEY @"Type vegkryssing"
#define VILTTREKK_BRUKERPREF @"fare_vilttrekk"

#define MOTORVEG_ID 595
#define MOTORVEG_KEY @"motorveg"
#define MOTORVEG_CD @"CD_Motorveg"
#define MOTORVEG_TYPE_KEY @"Motorvegtype"
#define MOTORVEG_TYPE_MOTORVEG @"motorveg"
#define MOTORVEG_TYPE_MOTORTRAFIKKVEG @"motortrafikkveg"
#define MOTORVEG_BRUKERPREF @""

#define HOYDEBEGRENSNING_ID 591
#define HOYDEBEGRENSNING_KEY @"hoydebegrensning"
#define HOYDEBEGRENSNING_CD @"CD_Hoydebegrensning"
#define HOYDEBEGRENSNING_TYPE_KEY @"Skilta høyde"
#define HOYDEBEGRENSNING_BRUKERPREF @"fare_hoydebegrensning"

#define JERNBANEKRYSSING_ID 100
#define JERNBANEKRYSSING_KEY @"jernbanekryssing"
#define JERNBANEKRYSSING_CD @"CD_Jernbanekryssing"
#define JERNBANEKRYSSING_TYPE_KEY @"Type"
#define JERNBANEKRYSSING_FILTER_OVER @"Veg over"
#define JERNBANEKRYSSING_FILTER_UNDER @"Veg under"
#define JERNBANEKRYSSING_BRUKERPREF @"fare_jernbanekryssing"

#define FARTSDEMPER_ID 103
#define FARTSDEMPER_KEY @"fartsdemper"
#define FARTSDEMPER_CD @"CD_Fartsdemper"
#define FARTSDEMPER_TYPE_KEY @"Type"
#define FARTSDEMPER_FILTER_RUMLEFELT @"Rumlefelt"
#define FARTSDEMPER_BRUKERPREF @"fare_fartsdemper"


// -- FILTER --

#define FILTER_LIK @"="
#define FILTER_ULIK @"!="


// -- CORE DATA --

#define VEGLENKEDBSTATUS_CD @"VeglenkeDBStatus"
#define VEGLENKEDBSTATUS_LENKEID @"veglenkeId"
#define EGENSKAP_CD @"CD_Egenskap"
#define VEGLENKE_CD @"CD_Veglenke"


// -- MAPPING --

#define VEGOBJEKT_MATCHER_KEY @"typeId"


// -- VIEWCONTROLLER --

#define VEGDATA_STORYBOARD @"MainStoryboard"
#define VEGDATA_HOVEDSKJERM_LANDSKAP @"HovedskjermLandskap"


// -- BRUKERPREFERANSER --

#define HUDKNAPP_BRUKERPREF @"skjerm_hudknapp"
#define LYDVARSLING_BRUKERPREF @"lydvarsling"


#endif
