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

//#define NVDB_GRUNN_URL @"http://nvdb1.demo.bekk.no:7001/nvdb/api"
#define NVDB_GRUNN_URL @"https://www.vegvesen.no/nvdb/api"
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
#define INGEN_EGENSKAPER @"Ingen egenskaper"
#define SKILLETEGN_SKILTOBJEKTER @"#"

#define VEGREFERANSE_BREDDEGRAD @"breddegrad"
#define VEGREFERANSE_LENGDEGRAD @"lengdegrad"

#define FARTSGRENSE_ID 105
#define FARTSGRENSE_KEY @"fartsgrense"
#define FARTSGRENSE_CD @"CD_Fartsgrense"
#define FARTSGRENSE_FART_KEY @"Fartsgrense"
#define FARTSGRENSE_BRUKERPREF @"skilt_fartsgrense"

#define FORKJORSVEG_ID 596
#define FORKJORSVEG_KEY @"forkjorsveg"
#define FORKJORSVEG_CD @"CD_Forkjorsveg"
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
#define VILTTREKK_BRUKERPREF @"skilt_vilttrekk"

#define MOTORVEG_ID 595
#define MOTORVEG_KEY @"motorveg"
#define MOTORVEG_CD @"CD_Motorveg"
#define MOTORVEG_TYPE_KEY @"Motorvegtype"
#define MOTORVEG_TYPE_MOTORVEG @"Motorveg"
#define MOTORVEG_TYPE_MOTORTRAFIKKVEG @"Motortrafikkveg"
#define MOTORVEG_BRUKERPREF @"skilt_motorveg"

#define HOYDEBEGRENSNING_ID 591
#define HOYDEBEGRENSNING_KEY @"hoydebegrensning"
#define HOYDEBEGRENSNING_CD @"CD_Hoydebegrensning"
#define HOYDEBEGRENSNING_TYPE_KEY @"Skilta høyde"
#define HOYDEBEGRENSNING_BRUKERPREF @"skilt_hoydebegrensning"

#define JERNBANEKRYSSING_ID 100
#define JERNBANEKRYSSING_KEY @"jernbanekryssing"
#define JERNBANEKRYSSING_CD @"CD_Jernbanekryssing"
#define JERNBANEKRYSSING_TYPE_KEY @"Type"
#define JERNBANEKRYSSING_FILTER_OVER @"Veg over"
#define JERNBANEKRYSSING_FILTER_UNDER @"Veg under"
#define JERNBANEKRYSSING_BRUKERPREF @"skilt_jernbanekryssing"

#define FARTSDEMPER_ID 103
#define FARTSDEMPER_KEY @"fartsdemper"
#define FARTSDEMPER_CD @"CD_Fartsdemper"
#define FARTSDEMPER_TYPE_KEY @"Type"
#define FARTSDEMPER_FILTER_RUMLEFELT @"Rumlefelt"
#define FARTSDEMPER_BRUKERPREF @"skilt_fartsdemper"

#define RASTEPLASS_ID 39
#define RASTEPLASS_KEY @"rasteplass"
#define RASTEPLASS_CD @"CD_Rasteplass"
#define RASTEPLASS_BRUKERPREF @"skilt_rasteplass"

#define TOALETT_ID 243
#define TOALETT_KEY @"toalett"
#define TOALETT_CD @"CD_Toalett"
#define TOALETT_BRUKERPREF @"skilt_toalett"

#define SOSLOMME_ID 47
#define SOSLOMME_KEY @"soslomme"
#define SOSLOMME_CD @"CD_SOSlomme"
#define SOSLOMME_FILTER_TYPE @"Bruksområde"
#define SOSLOMME_FILTER_HAVARI @"Havarilomme"
#define SOSLOMME_BRUKERPREF @"skilt_soslomme"

#define SKILTPLATE_ID 96
#define SKILTPLATE_ANSIKTSSIDE_KEY @"Ansiktsside"
#define SKILTPLATE_ANSIKTSSIDE_MED @"Med metreringsretning"
#define SKILTPLATE_ANSIKTSSIDE_MOT @"Mot metreringsretning"
#define SKILTPLATE_TEKST_KEY @"Tekst"
#define SKILTPLATE_SKILTNUMMER_KEY @"Skiltnummer HB-050"
#define SKILTPLATE_SKILTNUMMER_FARLIGSVING_H @"100.1 - Farlig sving, til høyre"
#define SKILTPLATE_SKILTNUMMER_FARLIGSVING_V @"100.2 - Farlig sving, til venstre"
#define SKILTPLATE_SKILTNUMMER_FARLIGESVINGER_H @"102.1 - Farlige svinger, den første til høyre"
#define SKILTPLATE_SKILTNUMMER_FARLIGESVINGER_V @"102.2 - Farlige svinger, den første til venstre"
#define SKILTPLATE_SKILTNUMMER_BRATTBAKKE_STIGNING @"104.1 - Bratt bakke, stigning"
#define SKILTPLATE_SKILTNUMMER_BRATTBAKKE_FALL @"104.2 - Bratt bakke, fall"
#define SKILTPLATE_SKILTNUMMER_SMALEREVEG_BEGGE @"106.1 - Smalere veg, Innsnevring på begge sider"
#define SKILTPLATE_SKILTNUMMER_SMALEREVEG_H @"106.2 - Smalere veg, Innsnevring på høyre side"
#define SKILTPLATE_SKILTNUMMER_SMALEREVEG_V @"106.3 - Smalere veg, Innsnevring på venstre side"
#define SKILTPLATE_SKILTNUMMER_UJEVNVEG @"108 - Ujevn veg"
#define SKILTPLATE_SKILTNUMMER_VEGARBEID @"110 - Vegarbeid"
#define SKILTPLATE_SKILTNUMMER_STEINSPRUT @"112 - Steinsprut"
#define SKILTPLATE_SKILTNUMMER_RASFARE_H @"114.1 - Rasfare, høyre side"
#define SKILTPLATE_SKILTNUMMER_RASFARE_V @"114.2 - Rasfare, venstre side"
#define SKILTPLATE_SKILTNUMMER_GLATTKJOREBANE @"116 - Glatt kjørebane"
#define SKILTPLATE_SKILTNUMMER_FARLIGVEGSKULDER @"117 - Farlig vegskulder"
#define SKILTPLATE_SKILTNUMMER_BEVEGELIGBRU @"118 - Bevegelig bru"
#define SKILTPLATE_SKILTNUMMER_KAISTRANDFERJELEIE @"120 - Kai, strand eller ferjeleie"
#define SKILTPLATE_SKILTNUMMER_TUNNEL @"122 - Tunnel."
#define SKILTPLATE_SKILTNUMMER_FARLIGVEGKRYSS @"124 - Farlig vegkryss"
#define SKILTPLATE_SKILTNUMMER_RUNDKJORING @"126 - Rundkjøring"
#define SKILTPLATE_SKILTNUMMER_TRAFIKKLYSSIGNAL @"132 - Trafikklyssignal"
#define SKILTPLATE_SKILTNUMMER_AVSTANDTILGANGFELT @"140 - Avstand til gangfelt"
#define SKILTPLATE_SKILTNUMMER_BARN @"142 - Barn"
#define SKILTPLATE_SKILTNUMMER_SYKLENDE @"144 - Syklende"
#define SKILTPLATE_SKILTNUMMER_KU @"146.4 - Ku"
#define SKILTPLATE_SKILTNUMMER_SAU @"146.5 - Sau"
#define SKILTPLATE_SKILTNUMMER_MOTENDETRAFIKK @"148 - Møtende trafikk"
#define SKILTPLATE_SKILTNUMMER_KO @"149 - Kø"
#define SKILTPLATE_SKILTNUMMER_FLY @"150 - Fly"
#define SKILTPLATE_SKILTNUMMER_SIDEVIND @"152 - Sidevind"
#define SKILTPLATE_SKILTNUMMER_SKILOPERE @"154 - Skiløpere"
#define SKILTPLATE_SKILTNUMMER_RIDENDE @"155 - Ridende"
#define SKILTPLATE_SKILTNUMMER_ANNENFARE @"156 - Annen fare"
#define SKILTPLATE_SKILTNUMMER_AUTOMATISKTRAFIKKONTROLL @"556 - Automatisk trafikkontroll"
#define SKILTPLATE_SKILTNUMMER_VIDEOKONTROLL @"558 - Videokontroll/-overvåking"
#define SKILTPLATE_SKILTNUMMER_AVSTAND @"802 - Avstand"
#define SKILTPLATE_SKILTNUMMER_UTSTREKNING @"804 - Utstrekning"
#define SKILTPLATE_SKILTNUMMER_SAERLIGULYKKESFARE_1 @"817.1 - Særlig ulykkesfare"
#define SKILTPLATE_SKILTNUMMER_SAERLIGULYKKESFARE_2 @"817.2 - Særlig ulykkesfare"
#define SKILTPLATE_SKILTNUMMER_SAERLIGULYKKESFARE_3 @"817.3 - Særlig ulykkesfare"
#define SKILTPLATE_SKILTNUMMER_SAERLIGULYKKESFARE_4 @"817.4 - Særlig ulykkesfare"
#define SKILTPLATE_SKILTNUMMER_SAERLIGULYKKESFARE_5 @"817.5 - Særlig ulykkesfare"

#define FARLIGSVING_KEY @"farligsving"
#define FARLIGSVING_CD @"CD_Farligsving"
#define FARLIGSVING_BRUKERPREF @"skilt_farligsving"

#define BRATTBAKKE_KEY @"brattbakke"
#define BRATTBAKKE_CD @"CD_Brattbakke"
#define BRATTBAKKE_BRUKERPREF @"skilt_brattbakke"

#define SMALEREVEG_KEY @"smalereveg"
#define SMALEREVEG_CD @"CD_Smalereveg"
#define SMALEREVEG_BRUKERPREF @"skilt_smalereveg"

#define UJEVNVEG_KEY @"ujevnveg"
#define UJEVNVEG_CD @"CD_Ujevnveg"
#define UJEVNVEG_BRUKERPREF @"skilt_ujevnveg"

#define VEGARBEID_KEY @"vegarbeid"
#define VEGARBEID_CD @"CD_Vegarbeid"
#define VEGARBEID_BRUKERPREF @"skilt_vegarbeid"

#define STEINSPRUT_KEY @"steinsprut"
#define STEINSPRUT_CD @"CD_Steinsprut"
#define STEINSPRUT_BRUKERPREF @"skilt_steinsprut"

#define RASFARE_KEY @"rasfare"
#define RASFARE_CD @"CD_Rasfare"
#define RASFARE_BRUKERPREF @"skilt_rasfare"

#define GLATTKJOREBANE_KEY @"glattkjorebane"
#define GLATTKJOREBANE_CD @"CD_Glattkjorebane"
#define GLATTKJOREBANE_BRUKERPREF @"skilt_glattkjorebane"

#define FARLIGVEGSKULDER_KEY @"farligvegskulder"
#define FARLIGVEGSKULDER_CD @"CD_Farligvegskulder"
#define FARLIGVEGSKULDER_BRUKERPREF @"skilt_farligvegskulder"

#define BEVEGELIGBRU_KEY @"bevegeligbru"
#define BEVEGELIGBRU_CD @"CD_Bevegeligbru"
#define BEVEGELIGBRU_BRUKERPREF @"skilt_bevegeligbru"

#define KAISTRANDFERJELEIE_KEY @"kaistrandferjeleie"
#define KAISTRANDFERJELEIE_CD @"CD_KaiStrandFerjeleie"
#define KAISTRANDFERJELEIE_BRUKERPREF @"skilt_kaistrandferjeleie"

#define TUNNEL_KEY @"tunnel"
#define TUNNEL_CD @"CD_Tunnel"
#define TUNNEL_BRUKERPREF @"skilt_tunnel"

#define FARLIGVEGKRYSS_KEY @"farligvegkryss"
#define FARLIGVEGKRYSS_CD @"CD_Farligvegkryss"
#define FARLIGVEGKRYSS_BRUKERPREF @"skilt_farligvegkryss"

#define RUNDKJORING_KEY @"rundkjoring"
#define RUNDKJORING_CD @"CD_Rundkjoring"
#define RUNDKJORING_BRUKERPREF @"skilt_rundkjoring"

#define TRAFIKKLYSSIGNAL_KEY @"trafikklyssignal"
#define TRAFIKKLYSSIGNAL_CD @"CD_Trafikklyssignal"
#define TRAFIKKLYSSIGNAL_BRUKERPREF @"skilt_trafikklyssignal"

#define AVSTANDTILGANGFELT_KEY @"avstandtilgangfelt"
#define AVSTANDTILGANGFELT_CD @"CD_Avstandtilgangfelt"
#define AVSTANDTILGANGFELT_BRUKERPREF @"skilt_avstandtilgangfelt"

#define BARN_KEY @"barn"
#define BARN_CD @"CD_Barn"
#define BARN_BRUKERPREF @"skilt_barn"

#define SYKLENDE_KEY @"syklende"
#define SYKLENDE_CD @"CD_Syklende"
#define SYKLENDE_BRUKERPREF @"skilt_syklende"

#define KU_KEY @"ku"
#define KU_CD @"CD_Ku"
#define KU_BRUKERPREF @"skilt_ku"

#define SAU_KEY @"sau"
#define SAU_CD @"CD_Sau"
#define SAU_BRUKERPREF @"skilt_sau"

#define MOTENDETRAFIKK_KEY @"motendetrafikk"
#define MOTENDETRAFIKK_CD @"CD_Motendetrafikk"
#define MOTENDETRAFIKK_BRUKERPREF @"skilt_motendetrafikk"

#define KO_KEY @"ko"
#define KO_CD @"CD_Ko"
#define KO_BRUKERPREF @"skilt_ko"

#define FLY_KEY @"fly"
#define FLY_CD @"CD_Fly"
#define FLY_BRUKERPREF @"skilt_fly"

#define SIDEVIND_KEY @"sidevind"
#define SIDEVIND_CD @"CD_Sidevind"
#define SIDEVIND_BRUKERPREF @"skilt_sidevind"

#define SKILOPERE_KEY @"skilopere"
#define SKILOPERE_CD @"CD_Skilopere"
#define SKILOPERE_BRUKERPREF @"skilt_skilopere"

#define RIDENDE_KEY @"ridende"
#define RIDENDE_CD @"CD_Ridende"
#define RIDENDE_BRUKERPREF @"skilt_ridende"

#define ANNENFARE_KEY @"annenfare"
#define ANNENFARE_CD @"CD_Annenfare"
#define ANNENFARE_BRUKERPREF @"skilt_annenfare"

#define AUTOMATISKTRAFIKKONTROLL_KEY @"automatisktrafikkontroll"
#define AUTOMATISKTRAFIKKONTROLL_CD @"CD_AutomatiskTrafikkontroll"
#define AUTOMATISKTRAFIKKONTROLL_BRUKERPREF @"skilt_automatisktrafikkontroll"

#define VIDEOKONTROLL_KEY @"videokontroll"
#define VIDEOKONTROLL_CD @"CD_Videokontroll"
#define VIDEOKONTROLL_BRUKERPREF @"skilt_videokontroll"

#define SAERLIGULYKKESFARE_KEY @"saerligulykkesfare"
#define SAERLIGULYKKESFARE_CD @"CD_SaerligUlykkesfare"
#define SAERLIGULYKKESFARE_BRUKERPREF @"skilt_saerligulykkesfare"


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
#define COREDATASIZE_BRUKERPREF @"coredatasize"


#endif
