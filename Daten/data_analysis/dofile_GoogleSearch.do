* Article: Google search: Exploratory analysis
* Author: Zumofen
clear all
cd "/Users/ZumofenG/OneDrive/PhD/P9_Google_Search bar/Daten/data_analysis"
capture log close
log using p9_googlesearchbar.log, replace
set more off

*********************************************************

* Figure 1
use trends_votation, replace
twoway (line abstimmung Semaine, lcolor(black) lpattern(solid)) (line votation Semaine), ytitle(Salience) ytitle(, color(black)) xtitle(Weeks) xtitle(, color(black)) xlabel(#52, labels labsize(vsmall) angle(vertical)) subtitle(Google trends in Switzerland from 11/22/2015 to 11/08/2020) legend(order(1 "Search query 'abstimmung' (German)" 2 "Search query 'votation' (French)") rows(2)) xlabel(#20) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
use trends_rffa_2019, replace
twoway (line newsp semaine, lcolor(black) lpattern(solid)) (line staf semaine) (line rffa semaine), ytitle(Salience) ytitle(, color(black)) xtitle(Weeks) xtitle(, color(black)) xlabel(#52, labels labsize(vsmall) angle(vertical)) subtitle(Referendum vote on fiscal policy '19 May 2019') legend(order(1 "Newspaper articles on fiscal policy" 2 "Search query 'STAF' (German)" 3 "Search query 'RFFA' (French)") rows(3)) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
* do for 2017 Energy act

*********************************************************
* Project 1 - Energy Referendum - 2017
* 1. Merging with manual coding data
use energy_referendum_2017_coder1.dta, replace
sort qsid
save energy_referendum_2017_coder1.dta, replace

use energy_referendum_GoogleSearch_2017.dta, replace
sort qsid
merge 1:1 qsid using energy_referendum_2017_coder1

* drop observations who did not use the mock Google search bar
drop if _merge==1

* N=740

* 2. Data preparation
drop if qsid=="NA"
* 2.1 Sociodemographic characteristics
destring language, replace
label var language "Language" 
*1=DE, 2=FR, 3=IT (nominal)"
label var canton "Canton (nominal)"
drop if language==3
tab language, m

replace agecat="." if agecat=="NA"
destring agecat, replace
label var agecat "Age"
* Age category (ordinal)
tab agecat

replace educ="." if educ=="NA" | educ=="98"
destring educ, replace
label var educ "Education" 
* Education level (ordinal)
tab educ
sum educ

replace revenu="." if revenu=="98"
destring revenu, replace
label var revenu "Income"
* Income (ordinal)
tab revenu
sum revenu

replace sex="0" if sex=="2"
destring sex, replace
label var sex "Sex"
* Sex: 0=men, 1=women (binary)
tab sex

replace demossector="." if demossector=="98"
rename demossector job_sector
destring job_sector, replace
label var job_sector "Job sector: 1,2,3 (nominal)"

replace demosprosp="." if demosprosp=="98"
destring demosprosp, replace
rename demosprosp prosperity
label var prosperity "Good living conditions with revenu (ordinal-inverted)"

replace demosauto="." if demosauto=="98"
destring demosauto, replace
rename demosauto auto_household
label var auto_household "Auto in household (ordinal)"

replace demoshousehold="." if demoshousehold=="20"
destring demoshousehold, replace
rename demoshousehold people_household
label var people_household "How many people living in household (ordinal)"

* 2.2 Political related attributes
destring votsubj11, replace
replace votsubj11=0 if votsubj11==.
rename votsubj11 correct_vote
label var correct_vote "Know what the vote is about (1) - Knowledge (nominal)"

destring partic, replace
rename partic participation
label var participation "Probability to participate (ordinal)"

generate participation_bin=0 if participation<80
replace participation_bin=1 if participation>=80
label var participation_bin "Participation (binary)"

destring decint, replace
destring decnonint, replace
destring decnonsuff, replace
generate attitude=decint
replace attitude=decnonint if attitude==.
replace attitude=decnonsuff if attitude==.
label var attitude "Attitude 0 (no)- 100 (yes) (ordinal)"

gen opinion=0 if attitude<=20
replace opinion=1 if attitude>20 & attitude<=40
replace opinion=2 if attitude>40 & attitude<60
replace opinion=3 if attitude>=60 & attitude<80
replace opinion=4 if attitude>=80 

label define status 0 "Absolutely against" 1 "Slightly against" 2"Mostly undecided" 3 "Slightly pro" 4 "Absolutely pro"
label value opinion status
label var opinion "Opinion 0 (no)- 5 (yes) (ordinal)"
tab opinion

generate decided=0 if opinion==2
replace decided=1 if opinion==1 | opinion==3
replace decided=2 if opinion==0 | opinion==4
label define ostatus 0 "Mostly undecided" 1 "Slightly decided" 2 "Absolutely decided"
label value decided ostatus
label var decided "Clear decision (or not) on the issue (ordinal)"

destring freq, replace
rename freq frequency_vote
label var frequency_vote "How frequent you vote (ordinal)"

destring lire, replace
rename lire ideo_orient
label var ideo_orient "Ideological orienation"

destring pid, replace
generate party_ident=1 if pid==3
replace party_ident=2 if pid==2
replace party_ident=3 if pid==1
label var party_ident "Party attachment"
* "How close to a party (ordinal)"
tab party_ident

destring interest, replace
generate pol_interest=4 if interest==1
replace pol_interest=3 if interest==2
replace pol_interest=2 if interest==3
replace pol_interest=1 if interest==4
label var pol_interest "Political interest"
* Political interest (ordinal)"
tab pol_interest
sum pol_interest

generate knowl_1=1 if knowl1=="3"
replace knowl_1=0 if knowl_1==.
generate knowl_2=1 if knowl2=="1"
replace knowl_2=0 if knowl_2==.
generate knowl_3=1 if knowl3=="1"
replace knowl_3=0 if knowl_3==.
generate knowl_4=1 if knowl4=="2"
replace knowl_4=0 if knowl_4==.
generate pol_knowl=knowl_1+knowl_2+knowl_3+knowl_4
label var pol_knowl "Political knowledge"
* Politicak knowledge (ordinal)"
sum pol_knowl

destring trust1, replace
destring trust2, replace
destring trust3, replace
destring trust4, replace
destring trust5, replace
destring trust6, replace
rename trust1 trust_fc
label var trust_fc "Trust government"
* Trust Government (ordinal)"
sum trust_fc

rename trust3 trust_party
label var trust_party "Trust political parties (ordinal)"

rename trust2 trust_parliament
label var trust_parliament "Trust parliament (ordinal)"

generate trust_institution=(trust_fc+trust_parliament+trust4+trust5)/4
label var trust_institution "Trust institution (ordinal)"

rename trust6 trust_nuclear_owner
label var trust_nuclear_owner "Trust nuclear owner (ordinal)"

* 2.3 Issue-related variables
destring issuesenergie, replace
destring issuesclima, replace
generate issue_agenda=1 if issuesenergie==1| issuesclima==1
replace issue_agenda=0 if issue_agenda==.
label var issue_agenda "Consider the referendum issue as an important issue (binary)"

destring decrel, replace
rename decrel att_importance
label var att_importance "Attitude importance (ordinal)"

destring deccompl, replace
rename deccompl att_certainty
label var att_certainty "Attitude certainty (ordinal)"

generate att_extremity=0 if attitude>=45 & attitude<=55
replace att_extremity = 1 if attitude>=40 & attitude<45
replace att_extremity = 1 if attitude>55 & attitude<=60
replace att_extremity = 2 if attitude>=35 & attitude<40
replace att_extremity = 2 if attitude>60 & attitude<=65
replace att_extremity = 3 if attitude>=30 & attitude<35
replace att_extremity = 3 if attitude>65 & attitude<=70
replace att_extremity = 4 if attitude>=25 & attitude<30
replace att_extremity = 4 if attitude>70 & attitude<=75
replace att_extremity = 5 if attitude>=20 & attitude<25
replace att_extremity = 5 if attitude>75 & attitude<=80
replace att_extremity = 6 if attitude>=15 & attitude<20
replace att_extremity = 6 if attitude>80 & attitude<=85
replace att_extremity = 7 if attitude>=10 & attitude<15
replace att_extremity = 7 if attitude>85 & attitude<=90
replace att_extremity = 8 if attitude>=5 & attitude<10
replace att_extremity = 8 if attitude>90 & attitude<=95
replace att_extremity = 9 if attitude>=0 & attitude<5
replace att_extremity = 9 if attitude>95 & attitude<=100
label var att_extremity "Attitude extremity 0-9 (ordinal)"

rename estrargu2 estrargu7
rename estrargu4 estrargu8
generate estrargu2=1 if estrargu7=="4"
replace estrargu2=2 if estrargu7=="3"
replace estrargu2=3 if estrargu7=="2"
replace estrargu2=4 if estrargu7=="1"
generate estrargu4=1 if estrargu8=="4"
replace estrargu4=2 if estrargu8=="3"
replace estrargu4=3 if estrargu8=="2"
replace estrargu4=4 if estrargu8=="1"
drop estrargu7 estrargu8
destring estrargu1, replace
destring estrargu3, replace
alpha estrargu1 estrargu2 estrargu3 estrargu4

generate estr_argu2 = estrargu1 + estrargu2 + estrargu3 + estrargu4
gen att_strength=estr_argu2-10
replace att_strength=att_strength*(-1) if att_strength<0
label var att_strength "Attitude strength 0-6 (ordinal)"

gen attienv5=0 if attienv1=="6"
replace attienv5=1 if attienv1=="5"
replace attienv5=2 if attienv1=="4"
replace attienv5=3 if attienv1=="3"
replace attienv5=4 if attienv1=="2"
replace attienv5=5 if attienv1=="1"
replace attienv5=6 if attienv1=="0"
gen attienv6=0 if attienv2=="6"
replace attienv6=1 if attienv2=="5"
replace attienv6=2 if attienv2=="4"
replace attienv6=3 if attienv2=="3"
replace attienv6=4 if attienv2=="2"
replace attienv6=5 if attienv2=="1"
replace attienv6=6 if attienv2=="0"
destring attienv3, replace
alpha attienv5 attienv6 attienv3
gen att_environment =(attienv5+attienv6+attienv3)/3
label var att_environment "Attitude towards environment 1-6"

* 2.4 Operating system
generate operation = 1 if techos == "iPhone"
replace operation = 1 if techos == "iPad"
replace operation = 1 if techos == "Android"
replace operation = 1 if techos == "Android 4.3"
replace operation = 1 if techos == "Android 4.4.2"
replace operation = 1 if techos == "Android 5.0.1"
replace operation = 1 if techos == "Android 5.0.2"
replace operation = 1 if techos == "Android 5.1"
replace operation = 1 if techos == "Android 5.1.1"
replace operation = 1 if techos == "Android 6.0"
replace operation = 1 if techos == "Android 6.0.1"
replace operation = 1 if techos == "Windows Phone 10.0"
replace operation = 0 if operation ==.
label variable operation "Operating system"
tab operation

* 2.5 Manual coding
replace c_not_relevant=0 if c_not_relevant==.
label var c_not_relevant "Query is not relevant"
* N= 632

replace c_neutral_enlightened=0 if c_neutral_enlightened==.
label var c_neutral_enlightened "Query is neutral/enlightened"
replace c_selective_yes=0 if c_selective_yes==.
label var c_selective_yes "Query is Yes-oriented"
replace c_selective_no=0 if c_selective_no==.
label var c_selective_no "Query is No-oriented"
replace c_government_institution=0 if c_government_institution==.
label var c_government_institution "Query asks for government/instutions information"
replace c_political_party=0 if c_political_party==.
label var c_political_party "Query asks for political parties' information"
replace c_others=0 if c_others==.
label var c_others "Query asks for information from an other political actor"
replace c_t1_cost_economy=0 if c_t1_cost_economy==.
label var c_t1_cost_economy "Query is related to cost"
replace c_t2_kern_nuclear=0 if c_t2_kern_nuclear==.
label var c_t2_kern_nuclear "Query is related to nuclear energy"
replace c_t3_dependance_importation=0 if c_t3_dependance_importation==.
label var c_t3_dependance_importation "Query is related to import, dependence and supply"
replace c_t4_renewable_green=0 if c_t4_renewable_green==.
label var c_t4_renewable_gree "Query is related to renewable/green energy"
replace c_t5_climate_change=0 if c_t5_climate_change==.
label var c_t5_climate_change "Query is related to climate change/environment"
replace c_t6_oil=0 if c_t6_oil==.
label var c_t6_oil "Query is related to oil, combustion, power"
replace c_t7_consumption=0 if c_t7_consumption==.
label var c_t7_consumption "Query is related to consumption"
replace c_t8_comparative=0 if c_t8_comparative==.
label var c_t8_comparative "Query is related to comparative-countries"
replace c_fakt_true=0 if c_fakt_true==.
label var c_fakt_true "Query asks for true/real infos (fake news)"

* 3. Data analysis
* 3.1 Descriptive statistics
generate c_topics=1 if c_t1_cost_economy==1 | c_t2_kern_nuclear==1 | c_t3_dependance_importation==1 | c_t4_renewable_green==1 | c_t5_climate_change==1 | c_t6_oil==1 | c_t7_consumption==1 | c_fakt_true==1
replace c_topics=0 if c_topics==.
* Selective
generate c_selective=1 if c_selective_yes==1 | c_selective_no==1
replace c_selective=0 if c_selective==.
tab c_selective

* Bar chart - Descriptive statitics "search query"
graph hbar (mean) c_neutral_enlightened (mean) c_selective (mean) c_government_institution (mean) c_political_party (mean) c_topics (mean) c_not_relevant, bar(1, fcolor(black) lcolor(none)) bar(2, fcolor(black%80) lcolor(none)) bar(3, fcolor(black%60) lcolor(none)) bar(4, fcolor(black%40) lcolor(none)) bar(5, fcolor(black%20) lcolor(none)) bar(6, fcolor(black%10) lcolor(none)) bargap(5) blabel(bar, format(%3.2f)) yscale(off) title(Energy Act - Respondents' search queries, size(medsmall) color(black)) legend(order(1 "Neutral query" 2 "Selective query" 3 "Heuristic query (Government)" 4 "Heuristic query (Political party)" 5 "Subdimension query" 6 "Irrelevant query") cols(1) size(small) title(Categories, size(medsmall))) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))


* 3.2 Correlation matrix
pwcorr pol_knowl c_not_relevant c_neutral_enlightened c_selective_yes c_selective_no c_government_institution c_political_party c_others c_t1_cost_economy c_t2_kern_nuclear c_t3_dependance_importation c_t4_renewable_green c_t5_climate_change c_t6_oil c_t7_consumption c_t8_comparative c_fakt_true, star (.05)
pwcorr pol_interest c_not_relevant c_neutral_enlightened c_selective_yes c_selective_no c_government_institution c_political_party c_others c_t1_cost_economy c_t2_kern_nuclear c_t3_dependance_importation c_t4_renewable_green c_t5_climate_change c_t6_oil c_t7_consumption c_t8_comparative c_fakt_true, star (.05)
* ...


* 3.3 Logit regression
logit c_neutral_enlightened i.language i.sex agecat revenu educ pol_interest pol_knowl trust_fc party_ident operation, vce(robust) or
estimate store neutral_query
logit c_selective i.language i.sex agecat revenu educ pol_interest pol_knowl trust_fc party_ident operation, vce(robust) or
estimate store selective_query
logit c_government_institution i.language i.sex agecat revenu educ pol_interest pol_knowl trust_fc party_ident operation, vce(robust) or
estimate store government_query
logit c_political_party i.language i.sex agecat revenu educ pol_interest pol_knowl trust_fc party_ident operation, vce(robust) or
estimate store cues_query
logit c_topics i.language i.sex agecat revenu educ pol_interest pol_knowl trust_fc party_ident operation, vce(robust) or
estimate store subdimension_query
coefplot (neutral_query, label(Neutral query) m(O) mcolor (black) mfcolor(white) msize(small)) (subdimension_query, label(Subdimension query) m(D) mcolor(black) mfcolor(white) msize(small)) , drop(_cons) eform xline(1) keep(1.language 1.sex agecat revenu educ pol_interest pol_knowl trust_fc party_ident operation) levels (95) xtitle (Odds ratio) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) grid( between glcolor(black) glpattern(dot)) title(Energy Act, size(medsmall) color(black)) legend(position(4) ring(0) cols(1) size(vsmall) title(Categories, size(small)))



* T1 Cost economy
logit c_t1_cost_economy educ agecat i.sex revenu i.language pol_interest pol_knowl i.party_ident trust_fc if c_not_relevant==0, robust
logit c_t1_cost_economy educ agecat i.sex revenu i.language pol_interest pol_knowl i.party_ident trust_fc att_importance att_certainty att_extremity att_strength if c_not_relevant==0, robust
logit c_t1_cost_economy educ agecat i.sex revenu i.language pol_interest pol_knowl i.party_ident trust_fc att_strength if c_not_relevant==0, robust

* T2 Nuclear
logit c_t2_kern_nuclear educ agecat i.sex revenu i.language pol_interest pol_knowl i.party_ident trust_fc if c_not_relevant==0, robust
logit c_t2_kern_nuclear educ agecat i.sex revenu i.language pol_interest pol_knowl i.party_ident trust_fc att_importance att_certainty att_extremity att_strength if c_not_relevant==0, robust
logit c_t2_kern_nuclear educ agecat i.sex revenu i.language pol_interest pol_knowl i.party_ident trust_fc att_strength if c_not_relevant==0, robust

* T3 Dependence, importation, supply
logit c_t3_dependance_importation educ agecat i.sex revenu i.language pol_interest pol_knowl i.party_ident trust_fc if c_not_relevant==0, robust
logit c_t3_dependance_importation educ agecat i.sex revenu i.language pol_interest pol_knowl i.party_ident trust_fc att_importance att_certainty att_extremity att_strength if c_not_relevant==0, robust
logit c_t3_dependance_importation educ agecat i.sex revenu i.language pol_interest pol_knowl i.party_ident trust_fc att_strength if c_not_relevant==0, robust

* T4 Renewable energy
logit c_t4_renewable_green educ agecat i.sex revenu i.language pol_interest pol_knowl i.party_ident trust_fc if c_not_relevant==0, robust
logit c_t4_renewable_green educ agecat i.sex revenu i.language pol_interest pol_knowl i.party_ident trust_fc att_importance att_certainty att_extremity att_strength if c_not_relevant==0, robust
logit c_t4_renewable_green educ agecat i.sex revenu i.language pol_interest pol_knowl i.party_ident trust_fc att_strength if c_not_relevant==0, robust

* T5 Climate change
logit c_t5_climate_change educ agecat i.sex revenu i.language pol_interest pol_knowl i.party_ident trust_fc if c_not_relevant==0, robust
logit c_t5_climate_change educ agecat i.sex revenu i.language pol_interest pol_knowl i.party_ident trust_fc att_importance att_certainty att_extremity att_strength if c_not_relevant==0, robust
logit c_t5_climate_change educ agecat i.sex revenu i.language pol_interest pol_knowl i.party_ident trust_fc att_strength if c_not_relevant==0, robust

* T8 Comparative 
logit c_t8_comparative educ agecat i.sex revenu i.language pol_interest pol_knowl i.party_ident trust_fc if c_not_relevant==0, robust
logit c_t8_comparative educ agecat i.sex revenu i.language pol_interest pol_knowl i.party_ident trust_fc att_importance att_certainty att_extremity att_strength if c_not_relevant==0, robust
logit c_t8_comparative educ agecat i.sex revenu i.language pol_interest pol_knowl i.party_ident trust_fc att_strength if c_not_relevant==0, robust

* 3.4 Wordcount
gen words = wordcount(googlesearch)
sum words if c_not_relevant==0
tab words if c_not_relevant==0


* 4. Disentangle between Trust in Google (ranking effect) and Enlightened information seeking strategy (enlightened strategy)
* Run a multilevel mixed-effects logistic regression

destring selectivesearch12, replace
replace selectivesearch12=0 if selectivesearch12==.
destring selectivesearch15, replace
replace selectivesearch15=0 if selectivesearch15==.
destring selectivesearch3, replace
replace selectivesearch3=0 if selectivesearch3==.
destring selectivesearch4, replace
replace selectivesearch4=0 if selectivesearch4==.
destring selectivesearch6, replace
replace selectivesearch6=0 if selectivesearch6==.
destring selectivesearch7, replace
replace selectivesearch7=0 if selectivesearch7==.
destring selectivesearch8, replace
replace selectivesearch8=0 if selectivesearch8==.
destring selectivesearch9, replace
replace selectivesearch9=0 if selectivesearch9==.
destring selectivesearch10, replace
replace selectivesearch10=0 if selectivesearch10==.
destring selectivesearch11, replace
replace selectivesearch11=0 if selectivesearch11==.

* 4.1 Generate an ID for each observation (for panel data)
reshape long selectivesearch, i(qsid) j(source)

* 4.2 Set ranking
gen ranking=0 if source==12|source==15|source==3|source==4|source==6
replace ranking=1 if source==7|source==8|source==9|source==10|source==11

* 4.3 Set source category
gen s_topics=1 if source==7|source==8
replace s_topics=0 if s_topics==.

gen s_neutral=1 if source==6|source==11
replace s_neutral=0 if s_neutral==.

gen s_selective=1 if source==12|source==15|source==9
replace s_selective=0 if s_selective==.

gen s_cues=1 if source==3|source==4|source==10
replace s_cues=0 if s_cues==.

*  4.4 Source result selection (binary variable)
destring selectivesearch, replace
replace selectivesearch=0 if selectivesearch==.

* 4.5 Regression (think about it ...........)
logit selectivesearch i.language i.sex agecat revenu educ pol_interest pol_knowl trust_fc party_ident operation i.ranking#i.c_neutral_enlightened i.s_neutral#i.c_neutral_enlightened if c_not_relevant==0 
logit selectivesearch i.language i.sex agecat revenu educ pol_interest pol_knowl trust_fc party_ident operation i.ranking i.s_neutral if c_not_relevant==0 & c_neutral_enlightened==1
logit selectivesearch i.language i.sex agecat revenu educ pol_interest pol_knowl trust_fc party_ident operation i.ranking i.s_neutral if c_not_relevant==0 & c_neutral_enlightened==0

logit selectivesearch i.language i.sex agecat revenu educ pol_interest pol_knowl trust_fc party_ident operation i.ranking i.s_topics if c_not_relevant==0 & c_topics==1
logit selectivesearch i.language i.sex agecat revenu educ pol_interest pol_knowl trust_fc party_ident operation i.ranking i.s_topics if c_not_relevant==0 & c_topics==0

logit selectivesearch i.language i.sex agecat revenu educ pol_interest pol_knowl trust_fc party_ident operation i.ranking i.s_selective if c_not_relevant==0 & c_selective==1
logit selectivesearch i.language i.sex agecat revenu educ pol_interest pol_knowl trust_fc party_ident operation i.ranking i.s_selective if c_not_relevant==0 & c_selective==0

logit selectivesearch i.language i.sex agecat revenu educ pol_interest pol_knowl trust_fc party_ident operation i.ranking#i.s_neutral#i.c_neutral_enlightened if c_not_relevant==0

logit selectivesearch i.language i.sex agecat revenu educ pol_interest pol_knowl trust_fc party_ident operation i.ranking##i.s_neutral##i.c_neutral_enlightened
margins ranking, over(c_neutral_enlightened)
marginsplot
margins s_neutral, over(c_neutral_enlightened)
marginsplot
margins s_neutral, over(c_neutral_enlightened) at(ranking=(0(1)1))
marginsplot, level(95) plot1opts(mcolor(black) msymbol(circle) lpattern(shortdash)) plot2opts(mcolor(black) msymbol(square)lpattern(dot)) plot3opts(mcolor(black) msymbol(diamond) lpattern(dash)) plot4opts(mcolor(black) msymbol(triangle)lpattern(solid)) ciopts(lcolor(black) lpattern(solid)) ytitle(Average marginal effects (95% confidence interval)) ytitle(, size(small) color(black)) xtitle(Ranking on Google's page) xtitle(, size(small) color(black)) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))


*****************************************************************
* Project 2 - STAF Referendum - 2019
* 1. Merging with manual coding data
use staf_referendum_2019_coder1.dta, replace
sort qsid
save staf_referendum_2019_coder1.dta, replace

use staf_referendum_GoogleSearch_2019.dta, replace
sort qsid
merge 1:1 qsid using staf_referendum_2019_coder1

* drop observations who did not use the mock Google search bar
drop if _merge==1

* N= 1022

* 2. Data preparation
* 2.1 Sociodemographic characteristics
generate language=0 if userlanguage=="DE"
replace language=1 if userlanguage=="FR"
label var language "Language"
* Language: 0=DE, 1=FR (nominal)"
tab language

label var canton "Canton (nominal)"

destring age, replace
generate agecat=1 if age>=1994
replace agecat=2 if age>=1984 & age<1994
replace agecat=3 if age>=1974 & age<1984
replace agecat=4 if age>=1964 & age<1974
replace agecat=5 if age>=1954 & age<1964
replace agecat=6 if age>=1944 & age<1954
replace agecat=7 if age<1944
label var agecat "Age category*
* Age (ordinal)"
tab agecat

label var educ "Education"
* Education level (ordinal)
tab educ 
sum educ

label var revenu "Income"
* Income (ordinal)
tab revenu

replace sex=0 if sex==2
replace sex=. if sex==3
label var sex "Sex"
* Sex: 0=men, 1=women (binary)
tab sex

* 2.2 Political related attributes
generate pol_interest=4 if polint==1
replace pol_interest=3 if polint==2
replace pol_interest=2 if polint==3
replace pol_interest=1 if polint==4
replace pol_interest=. if polint==5
label var pol_interest "Political interest"
* Political interest (ordinal)
sum pol_interest

rename trust_br trust_fc
label var trust_fc "Trust government"
* Trust Government (ordinal)
sum trust_fc

destring party_prox, replace
generate party_ident=1 if party_prox==3
replace party_ident=2 if party_prox==2
replace party_ident=3 if party_prox==1
replace party_ident=. if party_prox==9
label var party_ident "Party attachment"
* How close to a party (ordinal)"
tab party_ident

destring knowl1, replace
destring knowl2, replace
destring knowl3, replace
destring knowl4, replace
generate pol_knowl1 = 1 if knowl1==3
replace pol_knowl1 = 0 if pol_knowl1==.
generate pol_knowl2 = 1 if knowl2==1
replace pol_knowl2 = 0 if pol_knowl2==.
generate pol_knowl3 = 1 if knowl3==1
replace pol_knowl3 = 0 if pol_knowl3==.
generate pol_knowl4 = 1 if knowl4==2
replace pol_knowl4 = 0 if pol_knowl4==.
generate pol_knowl= pol_knowl1+pol_knowl2+pol_knowl3+pol_knowl4
label variable pol_knowl "Political knowledge"
sum pol_knowl

replace entsch1w1=. if entsch1w1==9
replace entsch2w1=. if entsch2w1==9
generate opinion=entsch1w1
replace opinion=entsch2w1 if entsch1w1==.
label define status 0 "Absolutely against" 1 "Slightly against" 2 "Slightly pro" 3 "Absolutely pro"
label value opinion status
label var opinion "Opinion 0 (no)- 3 (yes) (ordinal)"
tab opinion

* 2.4 Source of information
rename internet source_internet
label variable source_internet "Internet is a source"
* Internet as a source of political information"
sum source_internet

generate source_google=1 if so_google=="1"
replace source_google=0 if source_google==.

generate operation = 1 if meta_operatingsystem == "iPhone"
replace operation = 1 if meta_operatingsystem == "iPad"
replace operation = 1 if meta_operatingsystem == "Android 4.4.2"
replace operation = 1 if meta_operatingsystem == "Android 5.0.2"
replace operation = 1 if meta_operatingsystem == "Android 5.1"
replace operation = 1 if meta_operatingsystem == "Android 6.0"
replace operation = 1 if meta_operatingsystem == "Android 6.0.1"
replace operation = 1 if meta_operatingsystem == "Android 7.0"
replace operation = 1 if meta_operatingsystem == "Android 7.1.1"
replace operation = 1 if meta_operatingsystem == "Android 8.0.0"
replace operation = 1 if meta_operatingsystem == "Android 8.1.0"
replace operation = 1 if meta_operatingsystem == "Android 9"
replace operation = 0 if operation ==.
label variable operation "Operating system"
tab operation

* 2.5 Manual coding
replace c_not_relevant=0 if c_not_relevant==.
label var c_not_relevant "Query is not relevant"
* N= 918

replace c_neutral_enlightened=0 if c_neutral_enlightened==.
label var c_neutral_enlightened "Query is neutral/enlightened"
replace c_selective_yes=0 if c_selective_yes==.
label var c_selective_yes "Query is Yes-oriented"
replace c_selective_no=0 if c_selective_no==.
label var c_selective_no "Query is No-oriented"
replace c_government_institution=0 if c_government_institution==.
label var c_government_institution "Query asks for government/instutions information"
replace c_political_party=0 if c_political_party==.
label var c_political_party "Query asks for political parties' information"
replace c_others=0 if c_others==.
label var c_others "Query asks for information from an other political actor"

replace c_t1_ahv_retraite=0 if c_t1_ahv_retraite==.
label var c_t1_ahv_retraite "Query is related to AHV/retraite"
replace c_t2_steuer_fiscal=0 if c_t2_steuer_fiscal==.
label var c_t2_steuer_fiscal "Query is related to fiscal"
replace c_t3_cost_finance=0 if c_t3_cost_finance==.
label var c_t3_cost_finance "Query is related to cost"
replace c_t4_health=0 if c_t4_health==.
label var c_t4_health "Query is related to health"
replace c_t5_people=0 if c_t5_people==.
label var c_t5_people "Query is related to people (volk)"

generate c_t6_onlyahv=1 if c_neutral_enlightened==0 & c_t1_ahv_retraite==1
replace c_t6_onlyahv=0 if c_t6_onlyahv==.
label var c_t6_onlyahv "Query is related to only AHV"
generate c_t7_neutralahv=1 if c_neutral_enlightened==1 & c_t1_ahv_retraite==1
replace c_t7_neutralahv=0 if c_t7_neutralahv==.
label var c_t7_neutralahv "Query is neutral but related to  AHV"

generate c_t8_onlyfiscal=1 if c_neutral_enlightened==0 & c_t2_steuer_fiscal==1
replace c_t8_onlyfiscal=0 if c_t8_onlyfiscal==.
label var c_t8_onlyfiscal "Query is related to only fiscal"
generate c_t9_neutralfiscal=1 if c_neutral_enlightened==1 & c_t2_steuer_fiscal==1
replace c_t9_neutralfiscal=0 if c_t9_neutralfiscal==.
label var c_t9_neutralfiscal "Query is neutral but related to fiscal"

replace c_fakt_true=0 if c_fakt_true==.
label var c_fakt_true "Query asks for true/real infos (fake news)"

* 3. Data analysis
* 3.1 Descriptive statistics
generate c_topics=1 if c_t3_cost_finance==1 | c_t4_health==1 | c_t5_people==1 | c_t1_ahv_retraite==1 | c_t2_steuer_fiscal==1 | c_fakt_true==1
replace c_topics=0 if c_topics==.

generate c_both=1 if c_t1_ahv_retraite==1 | c_t2_steuer_fiscal==1
replace c_both=0 if c_both==.
generate c_neutral=1 if c_neutral_enlightened==1 & c_both==0
replace c_neutral=0 if c_neutral==.

generate c_selective=1 if c_selective_yes==1 | c_selective_no==1
replace c_selective=0 if c_selective==.
tab c_selective

* Bar chart - Descriptive statitics "search query"
graph hbar (mean) c_neutral (mean) c_selective (mean) c_government_institution (mean) c_political_party (mean) c_topics (mean) c_not_relevant, bar(1, fcolor(black) lcolor(none)) bar(2, fcolor(black%80) lcolor(none)) bar(3, fcolor(black%60) lcolor(none)) bar(4, fcolor(black%40) lcolor(none)) bar(5, fcolor(black%20) lcolor(none)) bar(6, fcolor(black%10) lcolor(none)) bargap(5) blabel(bar, format(%3.2f)) yscale(off) title(Tax proposal and pension financing reform - Respondents' search queries, size(medsmall) color(black)) legend(order(1 "Neutral query" 2 "Selective query" 3 "Heuristic query (Government)" 4 "Heuristic query (Political party)" 5 "Subdimension query" 6 "Irrelevant query") cols(1) size(small) title(Categories, size(medsmall))) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

* 3.2 Correlation matrix
pwcorr sex c_not_relevant c_neutral_enlightened c_selective_yes c_selective_no c_government_institution c_political_party c_others c_t1_ahv_retraite c_t2_steuer_fiscal c_t3_cost_finance c_t4_health c_t5_people c_t6_onlyahv c_t7_neutralahv c_t8_onlyfiscal c_t9_neutralfiscal c_topics c_fakt_true, star (.05)

* ...



* 3.3 Logit regression
logit c_neutral_enlightened i.language i.sex agecat revenu educ pol_interest pol_knowl trust_fc party_ident source_internet operation, vce(robust) or
estimate store neutral_query
logit c_selective i.language i.sex agecat revenu educ pol_interest pol_knowl trust_fc party_ident source_internet operation, vce(robust) or
estimate store selective_query
logit c_government_institution i.language i.sex agecat revenu educ pol_interest pol_knowl trust_fc party_ident source_internet operation, vce(robust) or
estimate store government_query
logit c_political_party i.language i.sex agecat revenu educ pol_interest pol_knowl trust_fc party_ident source_internet operation, vce(robust) or
estimate store cues_query
logit c_topics i.language i.sex agecat revenu educ pol_interest pol_knowl trust_fc party_ident source_internet operation, vce(robust) or
estimate store subdimension_query
coefplot (neutral_query, label(Neutral query) m(O) mcolor (black) mfcolor(white) msize(small)) (subdimension_query, label(Subdimension query) m(D) mcolor(black) mfcolor(white) msize(small)) , drop(_cons) eform xline(1) keep(1.sex agecat revenu educ pol_interest pol_knowl trust_fc party_ident operation source_internet) levels (95) xtitle (Odds ratio) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) grid( between glcolor(black) glpattern(dot)) title(Tax proposal and pension financing reform, size(medsmall) color(black)) legend(position(4) ring(0) cols(1) size(vsmall) title(Categories, size(small)))

**** Topics 3 - Cost
logit c_t3_cost_finance educ agecat i.sex revenu i.language pol_interest pol_knowl i.party_ident trust_fc source_google if c_not_relevant==0, robust

**** Topics 1 - AHV-all
logit c_t1_ahv_retraite educ agecat i.sex revenu i.language pol_interest pol_knowl i.party_ident trust_fc source_google if c_not_relevant==0, robust

**** Topics 2 - Steuer-all
logit c_t2_steuer_fiscal educ agecat i.sex revenu i.language pol_interest pol_knowl i.party_ident trust_fc source_google if c_not_relevant==0, robust

**** Topics 6 - AHV-only
logit c_t6_onlyahv educ agecat i.sex revenu i.language pol_interest pol_knowl i.party_ident trust_fc source_google if c_not_relevant==0, robust

**** Topics 8 - Steuer-only
logit c_t8_onlyfiscal educ agecat i.sex revenu i.language pol_interest pol_knowl i.party_ident trust_fc source_google if c_not_relevant==0, robust

**** Topics 7 - AHV-neutral
logit c_t7_neutralahv educ agecat i.sex revenu i.language pol_interest pol_knowl i.party_ident trust_fc source_google if c_not_relevant==0, robust

**** Topics 9 - Steuer-neutral
logit c_t9_neutralfiscal educ agecat i.sex revenu i.language pol_interest pol_knowl i.party_ident trust_fc source_google if c_not_relevant==0, robust

* 3.3 Wordcount
gen words = wordcount(googlesearch)
sum words if c_not_relevant==0
tab words if c_not_relevant==0


* 4. Disentangle between Trust in Google (ranking effect) and Enlightened information seeking strategy (enlightened strategy)

* Treatment and control groups
* 4.1: Define the 6 groups
destring googlerandom_1, replace
replace googlerandom_1=0 if googlerandom_1==.
destring googlerandom_2, replace
replace googlerandom_1=0 if googlerandom_2==.
destring googlerandom_3, replace
replace googlerandom_3=0 if googlerandom_3==.
destring googlerandom_4, replace
replace googlerandom_4=0 if googlerandom_4==.
destring googlerandom_5, replace
replace googlerandom_5=0 if googlerandom_5==.
destring googlerandom_6, replace
replace googlerandom_6=0 if googlerandom_6==.
destring googlerandom_7, replace
replace googlerandom_7=0 if googlerandom_7==.
destring googlerandom_8, replace
replace googlerandom_8=0 if googlerandom_8==.
destring googlerandom_9, replace
replace googlerandom_9=0 if googlerandom_9==.
destring googlerandom_10, replace
replace googlerandom_10=0 if googlerandom_10==.

destring googletop51_1, replace
replace googletop51_1=0 if googletop51_1==.
destring googletop51_2, replace
replace googletop51_2=0 if googletop51_2==.
destring googletop51_3, replace
replace googletop51_3=0 if googletop51_3==.
destring googletop51_4, replace
replace googletop51_4=0 if googletop51_4==.
destring googletop51_5, replace
replace googletop51_5=0 if googletop51_5==.
destring googletop51_6, replace
replace googletop51_6=0 if googletop51_6==.
destring googletop51_7, replace
replace googletop51_7=0 if googletop51_7==.
destring googletop51_8, replace
replace googletop51_8=0 if googletop51_8==.
destring googletop51_9, replace
replace googletop51_9=0 if googletop51_9==.
destring googletop51_10, replace
replace googletop51_10=0 if googletop51_10==.

destring googletop52_1, replace
replace googletop52_1=0 if googletop52_1==.
destring googletop52_2, replace
replace googletop52_2=0 if googletop52_2==.
destring googletop52_3, replace
replace googletop52_3=0 if googletop52_3==.
destring googletop52_4, replace
replace googletop52_4=0 if googletop52_4==.
destring googletop52_5, replace
replace googletop52_5=0 if googletop52_5==.
destring googletop52_6, replace
replace googletop52_6=0 if googletop52_6==.
destring googletop52_7, replace
replace googletop52_7=0 if googletop52_7==.
destring googletop52_8, replace
replace googletop52_8=0 if googletop52_8==.
destring googletop52_9, replace
replace googletop52_9=0 if googletop52_9==.
destring googletop52_10, replace
replace googletop52_10=0 if googletop52_10==.

destring googletop2gov_1, replace
replace googletop2gov_1=0 if googletop2gov_1==.
destring googletop2gov_2, replace
replace googletop2gov_2=0 if googletop2gov_2==.
destring googletop2gov_3, replace
replace googletop2gov_3=0 if googletop2gov_3==.
destring googletop2gov_4, replace
replace googletop2gov_4=0 if googletop2gov_4==.
destring googletop2gov_5, replace
replace googletop2gov_5=0 if googletop2gov_5==.
destring googletop2gov_6, replace
replace googletop2gov_6=0 if googletop2gov_6==.
destring googletop2gov_7, replace
replace googletop2gov_7=0 if googletop2gov_7==.
destring googletop2gov_8, replace
replace googletop2gov_8=0 if googletop2gov_8==.
destring googletop2gov_9, replace
replace googletop2gov_9=0 if googletop2gov_9==.
destring googletop2gov_10, replace
replace googletop2gov_10=0 if googletop2gov_10==.

destring googletop2ads_1, replace
replace googletop2ads_1=0 if googletop2ads_1==.
destring googletop2ads_2, replace
replace googletop2ads_2=0 if googletop2ads_2==.
destring googletop2ads_3, replace
replace googletop2ads_3=0 if googletop2ads_3==.
destring googletop2ads_4, replace
replace googletop2ads_4=0 if googletop2ads_4==.
destring googletop2ads_5, replace
replace googletop2ads_5=0 if googletop2ads_5==.
destring googletop2ads_6, replace
replace googletop2ads_6=0 if googletop2ads_6==.
destring googletop2ads_7, replace
replace googletop2ads_7=0 if googletop2ads_7==.
destring googletop2ads_8, replace
replace googletop2ads_8=0 if googletop2ads_8==.
destring googletop2ads_9, replace
replace googletop2ads_9=0 if googletop2ads_9==.
destring googletop2ads_10, replace
replace googletop2ads_10=0 if googletop2ads_10==.

destring googleune_1, replace
replace googleune_1=0 if googleune_1==.
destring googleune_2, replace
replace googleune_1=0 if googleune_2==.
destring googleune_3, replace
replace googleune_3=0 if googleune_3==.
destring googleune_4, replace
replace googleune_4=0 if googleune_4==.
destring googleune_5, replace
replace googleune_5=0 if googleune_5==.
destring googleune_6, replace
replace googleune_6=0 if googleune_6==.
destring googleune_7, replace
replace googleune_7=0 if googleune_7==.
destring googleune_8, replace
replace googleune_8=0 if googleune_8==.
destring googleune_9, replace
replace googleune_9=0 if googleune_9==.
destring googleune_10, replace
replace googleune_10=0 if googleune_10==.

generate group = 1 if googlerandom_1==1 | googlerandom_2==1 | googlerandom_3==1 | googlerandom_4==1 | googlerandom_5==1 | googlerandom_6==1 | googlerandom_7==1 | googlerandom_8==1 | googlerandom_9==1 | googlerandom_10==1 
replace group = 2 if googletop51_1==1 | googletop51_3==1 | googletop51_8==1 | googletop51_4==1 | googletop51_5==1 | googletop51_6==1 | googletop51_7==1 | googletop51_2==1 | googletop51_9==1 | googletop51_10==1
replace group = 3 if googletop52_1==1 | googletop52_3==1 | googletop52_8==1 | googletop52_4==1 | googletop52_5==1 | googletop52_6==1 | googletop52_7==1 | googletop52_2==1 | googletop52_9==1 | googletop52_10==1
replace group = 4 if googletop2gov_1==1 | googletop2gov_2==1 | googletop2gov_3==1 | googletop2gov_4==1 | googletop2gov_5==1 | googletop2gov_6==1 | googletop2gov_7==1 | googletop2gov_8==1 | googletop2gov_9==1 | googletop2gov_10==1
replace group = 5 if googletop2ads_4==1 | googletop2ads_9==1 | googletop2ads_1==1 | googletop2ads_2==1 | googletop2ads_3==1 | googletop2ads_5==1 | googletop2ads_6==1 | googletop2ads_7==1 | googletop2ads_8==1 | googletop2ads_10==1
replace group = 6 if googleune_8==1 | googleune_6==1 | googleune_1==1 | googleune_2==1 | googleune_3==1 | googleune_4==1 | googleune_5==1 | googleune_7==1 | googleune_9==1 | googleune_10==1

label define group 1 "random" 2 "top51" 3 "top52" 4 "top2gov" 5 "top2ads" 6 "news"

generate database = 1 if group==1 | group==2 | group==3 | group==4 | group==5
replace database = 0 if database!=1

* 4.2 Analysis
generate result1 = googlerandom_1+ googletop51_1+ googletop52_1+ googletop2gov_1+ googletop2ads_1+ googleune_1
label variable result1 "Choice of result 1"

generate result2 = googlerandom_2+ googletop51_2+ googletop52_2+ googletop2gov_2+ googletop2ads_2+ googleune_2
label variable result2 "Choice of result 2"

generate result3 = googlerandom_3+ googletop51_3+ googletop52_3+ googletop2gov_3+ googletop2ads_3+ googleune_3
label variable result3 "Choice of result 3"

generate result4 = googlerandom_4+ googletop51_4+ googletop52_4+ googletop2gov_4+ googletop2ads_4+ googleune_4
label variable result4 "Choice of result 4"

generate result5 = googlerandom_5+ googletop51_5+ googletop52_5+ googletop2gov_5+ googletop2ads_5+ googleune_5
label variable result5 "Choice of result 5"

generate result6 = googlerandom_6+ googletop51_6+ googletop52_6+ googletop2gov_6+ googletop2ads_6+ googleune_6
label variable result6 "Choice of result 6"

generate result7 = googlerandom_7+ googletop51_7+ googletop52_7+ googletop2gov_7+ googletop2ads_7+ googleune_7
label variable result7 "Choice of result 7"

generate result8 = googlerandom_8+ googletop51_8+ googletop52_8+ googletop2gov_8+ googletop2ads_8+ googleune_8
label variable result8 "Choice of result 8"

generate result9 = googlerandom_9+ googletop51_9+ googletop52_9+ googletop2gov_9+ googletop2ads_9+ googleune_9
label variable result9 "Choice of result 9"

generate result10 = googlerandom_10+ googletop51_10+ googletop52_10+ googletop2gov_10+ googletop2ads_10+ googleune_10
label variable result10 "Choice of result 10"

generate total_choice = googlerandom_1+ googletop51_1+ googletop52_1+ googletop2gov_1+ googletop2ads_1+ googleune_1 + googlerandom_2+ googletop51_2+ googletop52_2+ googletop2gov_2+ googletop2ads_2+ googleune_2+ googlerandom_1+ googletop51_3+ googletop52_3+ googletop2gov_3+ googletop2ads_3+ googleune_3+googlerandom_4+ googletop51_4+ googletop52_4+ googletop2gov_4+ googletop2ads_4+ googleune_4+googlerandom_5+ googletop51_5+ googletop52_5+ googletop2gov_5+ googletop2ads_5+ googleune_5+googlerandom_6+ googletop51_6+ googletop52_6+ googletop2gov_6+ googletop2ads_6+ googleune_6+googlerandom_7+ googletop51_7+ googletop52_7+ googletop2gov_7+ googletop2ads_7+ googleune_7+googlerandom_8+ googletop51_8+ googletop52_8+ googletop2gov_8+ googletop2ads_8+ googleune_8+googlerandom_9+ googletop51_9+ googletop52_9+ googletop2gov_9+ googletop2ads_9+ googleune_9+googlerandom_10+ googletop51_10+ googletop52_10+ googletop2gov_10+ googletop2ads_10+ googleune_10

replace database = 0 if total_choice==6 | total_choice==7 | total_choice==8 | total_choice==9 | total_choice==10

* 4.2 Reshape the data from wide to long: panelvar = id, timevar = source
reshape long result, i(qsid) j(source)

* 4.3 Create a variable "ranking"
gen ranking = 0 if group==1
replace ranking = 1 if group==4 & source==1
replace ranking = 2 if group==4 & source==2
replace ranking = 2 if group==6 & source==6
replace ranking = 3 if group==5 & source==1
replace ranking = 3 if group==6 & source==1
replace ranking = 4 if group==5 & source==2
replace ranking = 4 if group==6 & source==2
replace ranking = 5 if group==5 & source==3
replace ranking = 5 if group==6 & source==3
replace ranking = 6 if group==2 & source==1
replace ranking = 6 if group==3 & source==2
replace ranking = 6 if group==2 & source==2
replace ranking = 6 if group==2 & source==4
replace ranking = 6 if group==2 & source==5
replace ranking = 6 if group==3 & source==6
replace ranking = 6 if group==3 & source==7
replace ranking = 6 if group==2 & source==8
replace ranking = 6 if group==3 & source==9
replace ranking = 6 if group==3 & source==10
replace ranking = 7 if group==3 & source==1
replace ranking = 7 if group==6 & source==4
replace ranking = 7 if group==5 & source==5
replace ranking = 7 if group==2 & source==6
replace ranking = 8 if group==3 & source==3
replace ranking = 8 if group==6 & source==5
replace ranking = 8 if group==5 & source==6
replace ranking = 8 if group==2 & source==7
replace ranking = 9 if group==2 & source==2
replace ranking = 9 if group==3 & source==5
replace ranking = 9 if group==5 & source==7
replace ranking = 9 if group==6 & source==7
replace ranking = 10 if group==3 & source==4
replace ranking = 10 if group==5 & source==8
replace ranking = 10 if group==2 & source==9
replace ranking = 10 if group==6 & source==9
replace ranking = 11 if group==3 & source==8
replace ranking = 11 if group==2 & source==10
replace ranking = 11 if group==5 & source==10
replace ranking = 11 if group==6 & source==10
replace ranking = 12 if group==4 & source==3
replace ranking = 12 if group==4 & source==4
replace ranking = 12 if group==4 & source==5
replace ranking = 12 if group==4 & source==6
replace ranking = 12 if group==4 & source==7
replace ranking = 12 if group==4 & source==8
replace ranking = 12 if group==4 & source==9
replace ranking = 12 if group==4 & source==10
replace ranking = 13 if group==5 & source==9
replace ranking = 13 if group==5 & source==4

label define ranking 0"random" 1"1st" 2"2nd" 3"3rd" 4"4th" 5"5th" 6"Top 5" 7"6th" 8"7th" 9"8th" 10"9th" 11"10th" 12"Least 8" 13"Google ads"

generate ranking_cat=0 if ranking==1 |ranking==2| ranking==3 | ranking==4 | ranking==5 | ranking==6
replace ranking_cat=1 if ranking==0
replace ranking_cat=2 if ranking==7 |ranking==8| ranking==9 | ranking==10 | ranking==11 | ranking==12

generate ranking_cat2=0 if ranking==1 |ranking==2
replace ranking_cat2=1 if ranking==0
replace ranking_cat2=2 if ranking==3 | ranking==4 | ranking==5 | ranking==7 |ranking==8| ranking==9 | ranking==10 | ranking==11 | ranking==12

label define ranking_cat 0"Top 5" 1"random" 2"Least 5" 
label define ranking_cat2 0"Top 2" 1"random" 2"Least 8" 

* 4.4 Define source category
gen s_topics=1 if source==2|source==6|source==7
replace s_topics=0 if s_topics==.

gen s_neutral=1 if source==1|source==10|source==8
replace s_neutral=0 if s_neutral==.

gen s_selective=1 if source==3|source==5
replace s_selective=0 if s_selective==.

gen s_cues=1 if source==4|source==9
replace s_cues=0 if s_cues==.

* 4.5 Logit regression 3-way interaction
logit result i.language i.sex agecat revenu educ pol_interest pol_knowl trust_fc party_ident operation c.ranking#i.s_neutral#i.c_neutral_enlightened
logit result i.language i.sex agecat revenu educ pol_interest pol_knowl trust_fc party_ident operation c.ranking##i.s_neutral##i.c_neutral_enlightened
margins ranking, over(c_neutral_enlightened)
marginsplot
margins s_neutral, over(c_neutral_enlightened)
marginsplot
margins s_neutral, over(c_neutral_enlightened) at(ranking=(0(1)13))
marginsplot


logit result i.language i.sex agecat revenu educ pol_interest pol_knowl trust_fc party_ident operation i.ranking_cat##i.s_neutral##i.c_neutral_enlightened
margins s_neutral, over(c_neutral_enlightened) at(ranking_cat=(0(1)2))
marginsplot, level(95) plot1opts(mcolor(black) msymbol(circle) lpattern(shortdash)) plot2opts(mcolor(black) msymbol(square)lpattern(dot)) plot3opts(mcolor(black) msymbol(diamond) lpattern(dash)) plot4opts(mcolor(black) msymbol(triangle)lpattern(solid)) ciopts(lcolor(black) lpattern(solid)) ytitle(Average marginal effects (95% confidence interval)) ytitle(, size(small) color(black)) xtitle(Ranking on Google's page) xtitle(, size(small) color(black)) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

logit result i.language i.sex agecat revenu educ pol_interest pol_knowl trust_fc party_ident operation i.ranking_cat2##i.s_neutral##i.c_neutral_enlightened
margins s_neutral, over(c_neutral_enlightened) at(ranking_cat2=(0(1)2))
marginsplot, level(95) plot1opts(mcolor(black) msymbol(circle) lpattern(shortdash)) plot2opts(mcolor(black) msymbol(square)lpattern(dot)) plot3opts(mcolor(black) msymbol(diamond) lpattern(dash)) plot4opts(mcolor(black) msymbol(triangle)lpattern(solid)) ciopts(lcolor(black) lpattern(solid)) ytitle(Average marginal effects (95% confidence interval)) ytitle(, size(small) color(black)) xtitle(Ranking on Google's page) xtitle(, size(small) color(black)) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))


