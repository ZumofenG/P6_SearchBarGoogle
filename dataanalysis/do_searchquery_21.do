* Article: Google search queries: Exploratory analysis
* Author: Zumofen G.
clear all
cd "/Users/zumofeng/OneDrive/011_PhD/8_Projects/P6_Search Bar Google/Daten/data_analysis"
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
* 1. Upload the independent coders file
use energystrategy_17_coded, replace
* 2. Preprocess data - Create nominal variable for each independent coders - Variable of interest
gen search_c1 = 0 if unclassified_c1==1
replace search_c1 = 1 if generic_c1==1
replace search_c1 = 2 if se_pa_c1==1
replace search_c1 = 3 if se_conf_c1==1
replace search_c1 = 4 if se_bal_c1==1
replace search_c1 = 5 if se_sub_c1==1

gen search_c2 = 0 if unclassified_c2==1
replace search_c2 = 1 if generic_c2==1
replace search_c2 = 2 if se_pa_c2==1
replace search_c2 = 3 if se_conf_c2==1
replace search_c2 = 4 if se_bal_c2==1
replace search_c2 = 5 if se_sub_c2==1

gen search_c3 = 0 if unclassified_c3==1
replace search_c3 = 1 if generic_c3==1
replace search_c3 = 2 if se_pa_c3==1
replace search_c3 = 3 if se_conf_c3==1
replace search_c3 = 4 if se_bal_c3==1
replace search_c3 = 5 if se_sub_c3==1

gen search_c4 = 0 if unclassified_c4==1
replace search_c4 = 1 if generic_c4==1
replace search_c4 = 2 if se_pa_c4==1
replace search_c4 = 3 if se_conf_c4==1
replace search_c4 = 4 if se_bal_c4==1
replace search_c4 = 5 if se_sub_c4==1

replace unclassified_c1 = 0 if unclassified_c1==.
replace unclassified_c2 = 0 if unclassified_c2==.
replace unclassified_c3 = 0 if unclassified_c3==.
replace unclassified_c4 = 0 if unclassified_c4==.
generate unclassified_c = (unclassified_c1+unclassified_c2+unclassified_c3+unclassified_c4)/4

replace generic_c1 = 0 if generic_c1==.
replace generic_c2 = 0 if generic_c2==.
replace generic_c3 = 0 if generic_c3==.
replace generic_c4 = 0 if generic_c4==.
generate generic_c = (generic_c1+generic_c2+generic_c3+generic_c4)/4

replace se_pa_c1 = 0 if se_pa_c1==.
replace se_pa_c2 = 0 if se_pa_c2==.
replace se_pa_c3 = 0 if se_pa_c3==.
replace se_pa_c4 = 0 if se_pa_c4==.
generate se_pa_c = (se_pa_c1+se_pa_c2+se_pa_c3+se_pa_c4)/4

replace se_conf_c1 = 0 if se_conf_c1==.
replace se_conf_c2 = 0 if se_conf_c2==.
replace se_conf_c3 = 0 if se_conf_c3==.
replace se_conf_c4 = 0 if se_conf_c4==.
generate se_conf_c = (se_conf_c1+se_conf_c2+se_conf_c3+se_conf_c4)/4

replace se_bal_c1 = 0 if se_bal_c1==.
replace se_bal_c2 = 0 if se_bal_c2==.
replace se_bal_c3 = 0 if se_bal_c3==.
replace se_bal_c4 = 0 if se_bal_c4==.
generate se_bal_c = (se_bal_c1+se_bal_c2+se_bal_c3+se_bal_c4)/4

replace se_sub_c1 = 0 if se_sub_c1==.
replace se_sub_c2 = 0 if se_sub_c2==.
replace se_sub_c3 = 0 if se_sub_c3==.
replace se_sub_c4 = 0 if se_sub_c4==.
generate se_sub_c = (se_sub_c1+se_sub_c2+se_sub_c3+se_sub_c4)/4

* 3. Measure Krippendorff intercoder reliability alpha
kappaetc search_c1 search_c2 search_c3 search_c4
* Interagreement = 0.81

* 4. Combine independent coders measurement into a nominal measurement
generate search_c = 0 if unclassified_c>0.5
replace search_c = 0 if unclassified_c==0.5 & generic_c!=0.5 & se_pa_c!=0.5 & se_conf_c!=0.5 & se_bal_c!=0.5 & se_sub_c!=0.5
replace search_c = 1 if generic_c>0.5
replace search_c = 1 if generic_c==0.5 & unclassified_c!=0.5 & se_pa_c!=0.5 & se_conf_c!=0.5 & se_bal_c!=0.5 & se_sub_c!=0.5
replace search_c = 2 if se_pa_c>0.5
replace search_c = 2 if se_pa_c==0.5 & unclassified_c!=0.5 & generic_c!=0.5 & se_conf_c!=0.5 & se_bal_c!=0.5 & se_sub_c!=0.5
replace search_c = 3 if se_conf_c>0.5
replace search_c = 3 if se_conf_c==0.5 & unclassified_c!=0.5 & generic_c!=0.5 & se_pa_c!=0.5 & se_bal_c!=0.5 & se_sub_c!=0.5
replace search_c = 4 if se_bal_c>0.5 
replace search_c = 4 if se_bal_c==0.5 & unclassified_c!=0.5 & generic_c!=0.5 & se_pa_c!=0.5 & se_conf_c!=0.5 & se_sub_c!=0.5
replace search_c = 5 if se_sub_c>0.5
replace search_c = 5 if se_sub_c==0.5 & unclassified_c!=0.5 & generic_c!=0.5 & se_pa_c!=0.5 & se_conf_c!=0.5 & se_bal_c!=0.5

tab search_c, m

* 5. Merge content analysis with survey data
sort qsid
save energystrategy_17_coded2, replace

use energy_referendum_GoogleSearch_2017.dta, replace
sort qsid
merge 1:1 qsid using energystrategy_17_coded2

* drop observations who did not use the mock Google search bar
drop if _merge==1
* N=740

* 6. Data preparation - Independent variables
* 6.1 Sociodemographic characteristics
destring language, replace
label var language "Language" 
*1=DE, 2=FR, 3=IT (nominal)"
drop if language==3
label var canton "Canton"
tab language, m
* N=728

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

* 6.2 Political related attributes
destring votsubj11, replace
replace votsubj11=0 if votsubj11==.
rename votsubj11 correct_vote
label var correct_vote "Know what the vote is about (1) - Knowledge (nominal)"

destring partic, replace
rename partic participation
label var participation "Participation"

generate participation_bin=0 if participation<80
replace participation_bin=1 if participation>=80
label var participation_bin "Participation"

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

* 6.3 Issue-related variables
destring issuesenergie, replace
destring issuesclima, replace
generate issue_agenda=1 if issuesenergie==1| issuesclima==1
replace issue_agenda=0 if issue_agenda==.
label var issue_agenda "Policy importance"

destring decrel, replace
rename decrel att_importance
label var att_importance "Attitude importance"

destring deccompl, replace
rename deccompl att_certainty
label var att_certainty "Vote certainty"

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
label var att_extremity "Attitude extremity"

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
label var att_strength "Attitude strength"

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
label var att_environment "Attitude environment"

* 6.4 Operating system
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

* 7. Data analysis

* 7.0 Wordcount
gen words = wordcount(googlesearch)
sum words
tab words 

* 7.1 RQ1: Do individuals type different search queries to obtain political information on the same political event?
tab search_c
graph hbar, over(search_c, relabel(1"Unclassified" 2"Generic" 3"Political actors" 4"Confirmation bias" 5"Balanced" 6"Subdimension") gap(1) label(labcolor("black") labsize(small))) bar(1, fcolor(black)) bar(2, fcolor(black)) bar(6, fcolor(black)) blabel(bar, format(%5.4g)) ytitle(Type of search query in %) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

gen search_bin = 0 if search_c==1
replace search_bin = 1 if search_c==2 | search_c==3 | search_c==4 | search_c==5

gen search_tri = 0 if search_c==0
replace search_tri = 1 if search_c==1
replace search_tri = 2 if search_c==2 | search_c==3 | search_c==4
replace search_tri = 3 if search_c==5

* 7.2 RQ2: which individual characteristics drive different search queries?
logit search_bin i.sex educ agecat revenu i.language pol_interest pol_knowl i.party_ident trust_fc issue_agenda att_certainty i.operation, robust
estimate store search_bin

coefplot (search_bin, label(Selective query) m(O) mcolor(black) mfcolor(white) msize(small)), drop(_cons) eform xline(1) keep(1.sex 1.language agecat revenu educ party_ident pol_interest pol_knowl trust_fc issue_agenda att_certainty i.operation) levels (95) ylabel(, labsize(small)) xtitle (Odds ratio) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) grid( between glcolor(black) glpattern(dot))


mlogit search_c i.sex agecat revenu educ pol_interest pol_knowl trust_fc i.party_ident opinion  i.operation if search_c!=0, robust b(1)


* 7.3 RQ3: To what extent, do different search queries induce differnt selection strategy when facing a SERP?
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

tabulate selectivesearch12 search_bin, chi2
tabulate selectivesearch15 search_bin, chi2
tabulate selectivesearch3 search_bin, chi2
tabulate selectivesearch4 search_bin, chi2
tabulate selectivesearch6 search_bin, chi2
tabulate selectivesearch7 search_bin, chi2
tabulate selectivesearch8 search_bin, chi2
tabulate selectivesearch9 search_bin, chi2
tabulate selectivesearch10 search_bin, chi2
tabulate selectivesearch11 search_bin, chi2

gen selectivesearch_total = selectivesearch3+selectivesearch4+selectivesearch6+selectivesearch8+ selectivesearch9+ selectivesearch10+ selectivesearch11+ selectivesearch12+ selectivesearch15
sum selectivesearch_total

gen search_diff=0 if search_c==1
replace search_diff=1 if search_c==2 | search_c==3 | search_c==4 | search_c==5
sort search_diff
ttest selectivesearch_total, by(search_diff)

* To analyze contemporary trust VS selective awakening hypothesis, I need to incorporate the influence of ranking.
* To do so I reshape the dataset
* Generate an ID for each observation (for panel data)
reshape long selectivesearch, i(qsid) j(source)
* Set ranking
gen ranking=0 if source==12|source==15|source==3|source==4|source==6
replace ranking=1 if source==7|source==8|source==9|source==10|source==11

gen ranking_2=0 if source==12|source==15
replace ranking_2=1 if source==3|source==4|source==6|source==7|source==8|source==9|source==10|source==11

gen ranking_3=0 if source==12|source==15
replace ranking_3=1 if source==3|source==4
replace ranking_3=2 if source==6|source==7|source==8|source==9|source==10|source==11

* Source result selection (binary variable)
destring selectivesearch, replace
replace selectivesearch=0 if selectivesearch==.

logit selectivesearch i.sex educ agecat revenu i.language pol_interest pol_knowl i.party_ident trust_fc i.operation i.search_bin##i.ranking, robust
margins ranking, over(search_bin)
marginsplot,  level(95) plot1opts(mcolor(black) msymbol(circle)) plot2opts(mcolor(black) msymbol(square)) ciopts(lcolor(black) lpattern(solid)) ytitle(Average marginal effects (95% confidence interval)) ytitle(, size(small) color(black)) xtitle(Ranking on Google's page) xtitle(, size(small) color(black)) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

logit selectivesearch i.sex educ agecat revenu i.language pol_interest pol_knowl i.party_ident trust_fc i.operation i.search_bin##i.ranking_3, robust
margins ranking_3, over(search_bin)
marginsplot,  level(95) plot1opts(mcolor(black) msymbol(circle)) plot2opts(mcolor(black) msymbol(square)) ciopts(lcolor(black) lpattern(solid)) ytitle(Average marginal effects (95% confidence interval)) ytitle(, size(small) color(black)) xtitle(Ranking on Google's page) xtitle(, size(small) color(black)) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))


******************************************************************************************************
* Project 2 - STAF Referendum - 2019
* 1. Upload the independent coders file
use staf_19_coded, replace

* 2. Preprocess data - Create nominal variable for each independent coders
gen search_c1 = 0 if unclassified_c1==1
replace search_c1 = 1 if generic_c1==1
replace search_c1 = 2 if se_pa_c1==1
replace search_c1 = 3 if se_conf_c1==1
replace search_c1 = 4 if se_bal_c1==1
replace search_c1 = 5 if se_sub_c1==1

gen search_c2 = 0 if unclassified_c2==1
replace search_c2 = 1 if generic_c2==1
replace search_c2 = 2 if se_pa_c2==1
replace search_c2 = 3 if se_conf_c2==1
replace search_c2 = 4 if se_bal_c2==1
replace search_c2 = 5 if se_sub_c2==1

gen search_c3 = 0 if unclassified_c3==1
replace search_c3 = 1 if generic_c3==1
replace search_c3 = 2 if se_pa_c3==1
replace search_c3 = 3 if se_conf_c3==1
replace search_c3 = 4 if se_bal_c3==1
replace search_c3 = 5 if se_sub_c3==1

gen search_c4 = 0 if unclassified_c4==1
replace search_c4 = 1 if generic_c4==1
replace search_c4 = 2 if se_pa_c4==1
replace search_c4 = 3 if se_conf_c4==1
replace search_c4 = 4 if se_bal_c4==1
replace search_c4 = 5 if se_sub_c4==1

replace unclassified_c1 = 0 if unclassified_c1==.
replace unclassified_c2 = 0 if unclassified_c2==.
replace unclassified_c3 = 0 if unclassified_c3==.
replace unclassified_c4 = 0 if unclassified_c4==.
generate unclassified_c = (unclassified_c1+unclassified_c2+unclassified_c3+unclassified_c4)/4

replace generic_c1 = 0 if generic_c1==.
replace generic_c2 = 0 if generic_c2==.
replace generic_c3 = 0 if generic_c3==.
replace generic_c4 = 0 if generic_c4==.
generate generic_c = (generic_c1+generic_c2+generic_c3+generic_c4)/4

replace se_pa_c1 = 0 if se_pa_c1==.
replace se_pa_c2 = 0 if se_pa_c2==.
replace se_pa_c3 = 0 if se_pa_c3==.
replace se_pa_c4 = 0 if se_pa_c4==.
generate se_pa_c = (se_pa_c1+se_pa_c2+se_pa_c3+se_pa_c4)/4

replace se_conf_c1 = 0 if se_conf_c1==.
replace se_conf_c2 = 0 if se_conf_c2==.
replace se_conf_c3 = 0 if se_conf_c3==.
replace se_conf_c4 = 0 if se_conf_c4==.
generate se_conf_c = (se_conf_c1+se_conf_c2+se_conf_c3+se_conf_c4)/4

replace se_bal_c1 = 0 if se_bal_c1==.
replace se_bal_c2 = 0 if se_bal_c2==.
replace se_bal_c3 = 0 if se_bal_c3==.
replace se_bal_c4 = 0 if se_bal_c4==.
generate se_bal_c = (se_bal_c1+se_bal_c2+se_bal_c3+se_bal_c4)/4

replace se_sub_c1 = 0 if se_sub_c1==.
replace se_sub_c2 = 0 if se_sub_c2==.
replace se_sub_c3 = 0 if se_sub_c3==.
replace se_sub_c4 = 0 if se_sub_c4==.
generate se_sub_c = (se_sub_c1+se_sub_c2+se_sub_c3+se_sub_c4)/4

* 3. Measure Krippendorff intercoder reliability alpha
kappaetc search_c1 search_c2 search_c3 search_c4
* Interagreement = 0.81

* 4. Combine independent coders measurement into a nominal measurement
generate search_c = 0 if unclassified_c>0.5
replace search_c = 0 if unclassified_c==0.5 & generic_c!=0.5 & se_pa_c!=0.5 & se_conf_c!=0.5 & se_bal_c!=0.5 & se_sub_c!=0.5
replace search_c = 1 if generic_c>0.5
replace search_c = 1 if generic_c==0.5 & unclassified_c!=0.5 & se_pa_c!=0.5 & se_conf_c!=0.5 & se_bal_c!=0.5 & se_sub_c!=0.5
replace search_c = 2 if se_pa_c>0.5
replace search_c = 2 if se_pa_c==0.5 & unclassified_c!=0.5 & generic_c!=0.5 & se_conf_c!=0.5 & se_bal_c!=0.5 & se_sub_c!=0.5
replace search_c = 3 if se_conf_c>0.5
replace search_c = 3 if se_conf_c==0.5 & unclassified_c!=0.5 & generic_c!=0.5 & se_pa_c!=0.5 & se_bal_c!=0.5 & se_sub_c!=0.5
replace search_c = 4 if se_bal_c>0.5 
replace search_c = 4 if se_bal_c==0.5 & unclassified_c!=0.5 & generic_c!=0.5 & se_pa_c!=0.5 & se_conf_c!=0.5 & se_sub_c!=0.5
replace search_c = 5 if se_sub_c>0.5
replace search_c = 5 if se_sub_c==0.5 & unclassified_c!=0.5 & generic_c!=0.5 & se_pa_c!=0.5 & se_conf_c!=0.5 & se_bal_c!=0.5

tab search_c, m

generate search_bin = 0 if search_c==1
replace search_bin = 1 if search_c==2 | search_c==3 | search_c==4 | search_c==5

* 5. Merge content analysis with survey data
sort qsid
save staf_19_coded2, replace

use staf_referendum_GoogleSearch_2019.dta, replace
sort qsid
merge 1:1 qsid using staf_19_coded2

* drop observations who did not use the mock Google search bar
drop if _merge==1

* N= 1022

* 6. Data preparation
* 6.1 Sociodemographic characteristics
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

* 6.2 Political related attributes
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

* 6.3 Source of information
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

* 7.0 Wordcount
gen words = wordcount(googlesearch)
sum words
tab words 

* 7.1 RQ1: Do individuals type different search queries to obtain political information on the same political event?
tab search_c
graph hbar, over(search_c, relabel(1"Unclassified" 2"Generic" 3"Political actors" 4"Confirmation bias" 5"Balanced" 6"Subdimension") gap(1) label(labcolor("black") labsize(small))) bar(1, fcolor(black)) bar(2, fcolor(black)) bar(6, fcolor(black)) blabel(bar, format(%5.4g)) ytitle(Type of search query in %) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

* 7.2 RQ2: which individual characteristics drive different search queries?
logit search_bin i.sex educ agecat revenu i.language pol_interest pol_knowl i.party_ident trust_fc i.opinion i.operation, robust
estimate store search_bin

coefplot (search_bin, label(Selective query) m(O) mcolor(black) mfcolor(white) msize(small)), drop(_cons) eform xline(1) keep(1.sex 1.language agecat revenu educ party_ident pol_interest pol_knowl trust_fc i.operation) levels (95) ylabel(, labsize(small)) xtitle (Odds ratio) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) grid( between glcolor(black) glpattern(dot))
* No factors. No influences.

mlogit search_c i.sex agecat revenu educ pol_interest pol_knowl trust_fc i.party_ident opinion source_internet i.operation if search_c!=0, robust b(1)




* 7.3 RQ3: To what extent, do different search queries induce differnt selection strategy when facing a SERP?
* 7.3.1: Define the 6 groups
destring googlerandom_1, replace
replace googlerandom_1=0 if googlerandom_1==.
destring googlerandom_2, replace
replace googlerandom_2=0 if googlerandom_2==.
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

* 7.3.2 Analysis
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

gen search_diff=0 if search_c==1
replace search_diff=1 if search_c==2 | search_c==3 | search_c==4 | search_c==5
sort search_diff
ttest total_choice, by(search_diff)

* 7.3.3 Reshape the data from wide to long: panelvar = id, timevar = source
reshape long result, i(qsid) j(source)

* 7.3.4 Create a variable "ranking"
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

generate ranking_cat=1 if ranking==1 |ranking==2| ranking==3 | ranking==4 | ranking==5 | ranking==6
replace ranking_cat=0 if ranking==0
replace ranking_cat=2 if ranking==7 |ranking==8| ranking==9 | ranking==10 | ranking==11 | ranking==12

generate ranking_cat2=1 if ranking==1 |ranking==2
replace ranking_cat2=0 if ranking==0
replace ranking_cat2=2 if ranking==3 | ranking==4 | ranking==5 | ranking==7 |ranking==8| ranking==9 | ranking==10 | ranking==11 | ranking==12

label define ranking_cat 0"Random" 1"Top 5" 2"Least 5" 
label define ranking_cat2 0"Random" 1"Top 2" 2"Least 8" 

* 7.3.5 Logit regression
logit result i.sex educ agecat revenu i.language pol_interest pol_knowl i.party_ident trust_fc i.operation i.search_bin##i.ranking_cat2, robust
margins ranking_cat2, over(search_bin)
marginsplot,  level(95) plot1opts(mcolor(black) msymbol(circle)) plot2opts(mcolor(black) msymbol(square)) ciopts(lcolor(black) lpattern(solid)) ytitle(Average marginal effects (95% confidence interval)) ytitle(, size(small) color(black)) xtitle(Ranking on Google's page) xtitle(, size(small) color(black)) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

logit result i.sex educ agecat revenu i.language pol_interest pol_knowl i.party_ident trust_fc i.operation i.search_bin##i.ranking_cat, robust
margins ranking_cat, over(search_bin)
marginsplot,  level(95) plot1opts(mcolor(black) msymbol(circle)) plot2opts(mcolor(black) msymbol(square)) ciopts(lcolor(black) lpattern(solid)) ytitle(Average marginal effects (95% confidence interval)) ytitle(, size(small) color(black)) xtitle(Ranking on Google's page) xtitle(, size(small) color(black)) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

logit result i.sex educ agecat revenu i.language pol_interest pol_knowl i.party_ident trust_fc i.operation i.search_bin##i.ranking, robust
margins ranking, over(search_bin)
marginsplot,  level(95) plot1opts(mcolor(black) msymbol(circle)) plot2opts(mcolor(black) msymbol(square)) ciopts(lcolor(black) lpattern(solid)) ytitle(Average marginal effects (95% confidence interval)) ytitle(, size(small) color(black)) xtitle(Ranking on Google's page) xtitle(, size(small) color(black)) scheme(sj) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))


