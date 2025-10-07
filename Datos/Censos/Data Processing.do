cls
clear all

set more off

cd ~/Dropbox/Lectures/Andes/MECA4108_Microeconometrics/microeconometria/Datos/Censos

quietly infix                ///
  int     country     1-3    ///
  int     year        4-7    ///
  double  sample      8-16   ///
  double  serial      17-28  ///
  double  hhwt        29-36  ///
  int     pernum      37-40  ///
  double  perwt       41-48  ///
  byte    relate      49-49  ///
  int     related     50-53  ///
  int     age         54-56  ///
  byte    sex         57-57  ///
  byte    marst       58-58  ///
  int     marstd      59-61  ///
  byte    consens     62-62  ///
  byte    nativity    63-63  ///
  long    bplcountry  64-68  ///
  byte    school      69-69  ///
  byte    lit         70-70  ///
  byte    edattain    71-71  ///
  int     edattaind   72-74  ///
  byte    yrschool    75-76  ///
  int     educco      77-79  ///
  byte    empstat     80-80  ///
  int     empstatd    81-83  ///
  byte    labforce    84-84  ///
  byte    classwk     85-85  ///
  int     classwkd    86-88  ///
  using `"ipumsi_00001.dat"'

replace hhwt       = hhwt       / 100
replace perwt      = perwt      / 100

format sample     %9.0f
format serial     %12.0f
format hhwt       %8.2f
format perwt      %8.2f

label var country    `"Country"'
label var year       `"Year"'
label var sample     `"IPUMS sample identifier"'
label var serial     `"Household serial number"'
label var hhwt       `"Household weight"'
label var pernum     `"Person number"'
label var perwt      `"Person weight"'
label var relate     `"Relationship to household head [general version]"'
label var related    `"Relationship to household head [detailed version]"'
label var age        `"Age"'
label var sex        `"Sex"'
label var marst      `"Marital status [general version]"'
label var marstd     `"Marital status [detailed version]"'
label var consens    `"Consensual union"'
label var nativity   `"Nativity status"'
label var bplcountry `"Country of birth"'
label var school     `"School attendance"'
label var lit        `"Literacy"'
label var edattain   `"Educational attainment, international recode [general version]"'
label var edattaind  `"Educational attainment, international recode [detailed version]"'
label var yrschool   `"Years of schooling"'
label var educco     `"Educational attainment, Colombia"'
label var empstat    `"Activity status (employment status) [general version]"'
label var empstatd   `"Activity status (employment status) [detailed version]"'
label var labforce   `"Labor force participation"'
label var classwk    `"Status in employment (class of worker) [general version]"'
label var classwkd   `"Status in employment (class of worker) [detailed version]"'

label define sex_lbl 1 `"Male"'
label define sex_lbl 2 `"Female"', add
label define sex_lbl 9 `"Unknown"', add
label values sex sex_lbl

label define marst_lbl 0 `"NIU (not in universe)"'
label define marst_lbl 1 `"Single/never married"', add
label define marst_lbl 2 `"Married/in union"', add
label define marst_lbl 3 `"Separated/divorced/spouse absent"', add
label define marst_lbl 4 `"Widowed"', add
label define marst_lbl 9 `"Unknown/missing"', add
label values marst marst_lbl

label define marstd_lbl 000 `"NIU (not in universe)"'
label define marstd_lbl 100 `"Single/never married"', add
label define marstd_lbl 110 `"Engaged"', add
label define marstd_lbl 111 `"Never married and never cohabited"', add
label define marstd_lbl 200 `"Married or consensual union"', add
label define marstd_lbl 210 `"Married, formally"', add
label define marstd_lbl 211 `"Married, civil"', add
label define marstd_lbl 212 `"Married, religious"', add
label define marstd_lbl 213 `"Married, civil and religious"', add
label define marstd_lbl 214 `"Married, civil or religious"', add
label define marstd_lbl 215 `"Married, traditional/customary"', add
label define marstd_lbl 216 `"Married, monogamous"', add
label define marstd_lbl 217 `"Married, polygamous"', add
label define marstd_lbl 219 `"Married, spouse absent (historical samples)"', add
label define marstd_lbl 220 `"Consensual union"', add
label define marstd_lbl 300 `"Separated/divorced/spouse absent"', add
label define marstd_lbl 310 `"Separated or divorced"', add
label define marstd_lbl 320 `"Separated or annulled"', add
label define marstd_lbl 330 `"Separated"', add
label define marstd_lbl 331 `"Separated legally"', add
label define marstd_lbl 332 `"Separated de facto"', add
label define marstd_lbl 333 `"Separated from marriage"', add
label define marstd_lbl 334 `"Separated from consensual union"', add
label define marstd_lbl 335 `"Separated from consensual union or marriage"', add
label define marstd_lbl 340 `"Annulled"', add
label define marstd_lbl 350 `"Divorced"', add
label define marstd_lbl 400 `"Widowed"', add
label define marstd_lbl 410 `"Widowed or divorced"', add
label define marstd_lbl 411 `"Widowed from consensual union or marriage"', add
label define marstd_lbl 412 `"Widowed from marriage"', add
label define marstd_lbl 413 `"Widowed from consensual union"', add
label define marstd_lbl 420 `"Widowed, divorced, or separated"', add
label define marstd_lbl 999 `"Unknown/missing"', add
label values marstd marstd_lbl

label define consens_lbl 1 `"Yes, in consensual union"'
label define consens_lbl 2 `"No, married"', add
label define consens_lbl 8 `"Unknown"', add
label define consens_lbl 9 `"NIU (not in universe)"', add
label values consens consens_lbl

label define nativity_lbl 0 `"NIU (not in universe)"'
label define nativity_lbl 1 `"Native-born"', add
label define nativity_lbl 2 `"Foreign-born"', add
label define nativity_lbl 9 `"Unknown/missing"', add
label values nativity nativity_lbl

label define school_lbl 0 `"NIU (not in universe)"'
label define school_lbl 1 `"Yes"', add
label define school_lbl 2 `"No, not specified"', add
label define school_lbl 3 `"No, attended in the past"', add
label define school_lbl 4 `"No, never attended"', add
label define school_lbl 9 `"Unknown/missing"', add
label values school school_lbl

label define lit_lbl 0 `"NIU (not in universe)"'
label define lit_lbl 1 `"No, illiterate"', add
label define lit_lbl 2 `"Yes, literate"', add
label define lit_lbl 9 `"Unknown/missing"', add
label values lit lit_lbl

label define edattain_lbl 0 `"NIU (not in universe)"'
label define edattain_lbl 1 `"Less than primary completed"', add
label define edattain_lbl 2 `"Primary completed"', add
label define edattain_lbl 3 `"Secondary completed"', add
label define edattain_lbl 4 `"University completed"', add
label define edattain_lbl 9 `"Unknown"', add
label values edattain edattain_lbl

label define edattaind_lbl 000 `"NIU (not in universe)"'
label define edattaind_lbl 100 `"Less than primary completed (n.s.)"', add
label define edattaind_lbl 110 `"No schooling"', add
label define edattaind_lbl 120 `"Some primary completed"', add
label define edattaind_lbl 130 `"Primary (4 yrs) completed"', add
label define edattaind_lbl 211 `"Primary (5 yrs) completed"', add
label define edattaind_lbl 212 `"Primary (6 yrs) completed"', add
label define edattaind_lbl 221 `"Lower secondary general completed"', add
label define edattaind_lbl 222 `"Lower secondary technical completed"', add
label define edattaind_lbl 311 `"Secondary, general track completed"', add
label define edattaind_lbl 312 `"Some college completed"', add
label define edattaind_lbl 320 `"Secondary or post-secondary technical completed"', add
label define edattaind_lbl 321 `"Secondary, technical track completed"', add
label define edattaind_lbl 322 `"Post-secondary technical education"', add
label define edattaind_lbl 400 `"University completed"', add
label define edattaind_lbl 999 `"Unknown/missing"', add
label values edattaind edattaind_lbl

label define yrschool_lbl 00 `"None or pre-school"'
label define yrschool_lbl 01 `"1 year"', add
label define yrschool_lbl 02 `"2 years"', add
label define yrschool_lbl 03 `"3 years"', add
label define yrschool_lbl 04 `"4 years"', add
label define yrschool_lbl 05 `"5 years"', add
label define yrschool_lbl 06 `"6 years"', add
label define yrschool_lbl 07 `"7 years"', add
label define yrschool_lbl 08 `"8 years"', add
label define yrschool_lbl 09 `"9 years"', add
label define yrschool_lbl 10 `"10 years"', add
label define yrschool_lbl 11 `"11 years"', add
label define yrschool_lbl 12 `"12 years"', add
label define yrschool_lbl 13 `"13 years"', add
label define yrschool_lbl 14 `"14 years"', add
label define yrschool_lbl 15 `"15 years"', add
label define yrschool_lbl 16 `"16 years"', add
label define yrschool_lbl 17 `"17 years"', add
label define yrschool_lbl 18 `"18 years or more"', add
label define yrschool_lbl 90 `"Not specified"', add
label define yrschool_lbl 91 `"Some primary"', add
label define yrschool_lbl 92 `"Some technical after primary"', add
label define yrschool_lbl 93 `"Some secondary"', add
label define yrschool_lbl 94 `"Some tertiary"', add
label define yrschool_lbl 95 `"Adult literacy"', add
label define yrschool_lbl 96 `"Special education"', add
label define yrschool_lbl 98 `"Unknown/missing"', add
label define yrschool_lbl 99 `"NIU (not in universe)"', add
label values yrschool yrschool_lbl

label define educco_lbl 000 `"None"'
label define educco_lbl 100 `"Preschool"', add
label define educco_lbl 110 `"Preschool, years unspecified"', add
label define educco_lbl 120 `"Preschool, 0 years"', add
label define educco_lbl 130 `"Preschool, 1 year"', add
label define educco_lbl 140 `"Preschool, 2 years"', add
label define educco_lbl 200 `"Primary"', add
label define educco_lbl 210 `"Primary, 0 years"', add
label define educco_lbl 220 `"Primary, 1 year"', add
label define educco_lbl 230 `"Primary, 2 years"', add
label define educco_lbl 240 `"Primary, 3 years"', add
label define educco_lbl 250 `"Primary, 4 years"', add
label define educco_lbl 260 `"Primary, 5 years"', add
label define educco_lbl 270 `"Primary, years unspecified"', add
label define educco_lbl 300 `"Secondary"', add
label define educco_lbl 310 `"Secondary, 0 years"', add
label define educco_lbl 320 `"Secondary, 1 year"', add
label define educco_lbl 330 `"Secondary, 2 years"', add
label define educco_lbl 340 `"Secondary, 3 years"', add
label define educco_lbl 350 `"Secondary, 4 years"', add
label define educco_lbl 360 `"Secondary, 5 years"', add
label define educco_lbl 370 `"Secondary, 6 years"', add
label define educco_lbl 380 `"Secondary, years unspecified"', add
label define educco_lbl 390 `"Teaching school (2005)"', add
label define educco_lbl 391 `"3 years"', add
label define educco_lbl 392 `"4 years"', add
label define educco_lbl 399 `"Years unspecified"', add
label define educco_lbl 400 `"Unspecified level"', add
label define educco_lbl 401 `"University, 0 years"', add
label define educco_lbl 402 `"University, 1 year"', add
label define educco_lbl 403 `"University, 2 years"', add
label define educco_lbl 404 `"University, 3 years"', add
label define educco_lbl 405 `"University, 4 years"', add
label define educco_lbl 406 `"University, 5 years"', add
label define educco_lbl 407 `"University, 6 years"', add
label define educco_lbl 408 `"University, 7 years"', add
label define educco_lbl 409 `"University, 8 years"', add
label define educco_lbl 410 `"University, 9 years"', add
label define educco_lbl 419 `"University, level unspecified"', add
label define educco_lbl 420 `"Professional technical (2005)"', add
label define educco_lbl 421 `"Professional technical, 1 year"', add
label define educco_lbl 422 `"Professional technical, 2 years"', add
label define educco_lbl 429 `"Professional technical, years unspecified"', add
label define educco_lbl 430 `"Technological (2005)"', add
label define educco_lbl 431 `"Technological, 1 year"', add
label define educco_lbl 432 `"Technological, 2 years"', add
label define educco_lbl 433 `"Technological, 3 years"', add
label define educco_lbl 439 `"Technological, years unspecified"', add
label define educco_lbl 440 `"Undergraduate college (2005)"', add
label define educco_lbl 441 `"Undergraduate college, 1 year"', add
label define educco_lbl 442 `"Undergraduate college, 2 years"', add
label define educco_lbl 443 `"Undergraduate college, 3 years"', add
label define educco_lbl 444 `"Undergraduate college, 4 years"', add
label define educco_lbl 445 `"Undergraduate college, 5 years"', add
label define educco_lbl 446 `"Undergraduate college, 6 years"', add
label define educco_lbl 449 `"Undergraduate college, years unspecified"', add
label define educco_lbl 500 `"Graduate education"', add
label define educco_lbl 510 `"Specialization (2005)"', add
label define educco_lbl 511 `"Graduate education, specialization, 1 year"', add
label define educco_lbl 512 `"Graduate education, specialization, 2 years"', add
label define educco_lbl 519 `"Graduate education, specialization, years unspecified"', add
label define educco_lbl 520 `"Masters program (2005)"', add
label define educco_lbl 521 `"Masters program, 1 year"', add
label define educco_lbl 522 `"Masters program, 2 years"', add
label define educco_lbl 523 `"Masters program, 3 years"', add
label define educco_lbl 529 `"Masters program, years unspecified"', add
label define educco_lbl 530 `"Doctoral program (2005)"', add
label define educco_lbl 531 `"Doctoral program, 1 year"', add
label define educco_lbl 532 `"Doctoral program, 2 years"', add
label define educco_lbl 533 `"Doctoral program, 3 years"', add
label define educco_lbl 534 `"Doctoral program, 4 years"', add
label define educco_lbl 535 `"Doctoral program, 5 years"', add
label define educco_lbl 536 `"Doctoral program, 6 years"', add
label define educco_lbl 539 `"Doctoral program, years unspecified"', add
label define educco_lbl 590 `"University graduate, years unspecified"', add
label define educco_lbl 600 `"Other"', add
label define educco_lbl 601 `"Other, 0 years"', add
label define educco_lbl 602 `"Other, 1 year"', add
label define educco_lbl 603 `"Other, 2 years"', add
label define educco_lbl 604 `"Other, 3 years"', add
label define educco_lbl 605 `"Other, 4 years"', add
label define educco_lbl 606 `"Other, 5 years"', add
label define educco_lbl 607 `"Other, 6 years"', add
label define educco_lbl 610 `"Special education, years unspecified"', add
label define educco_lbl 620 `"Fundamental education, years unspec"', add
label define educco_lbl 998 `"Unknown/missing"', add
label define educco_lbl 999 `"NIU (not in universe)"', add
label values educco educco_lbl

label define empstat_lbl 0 `"NIU (not in universe)"'
label define empstat_lbl 1 `"Employed"', add
label define empstat_lbl 2 `"Unemployed"', add
label define empstat_lbl 3 `"Inactive"', add
label define empstat_lbl 9 `"Unknown/missing"', add
label values empstat empstat_lbl

label define empstatd_lbl 000 `"NIU (not in universe)"'
label define empstatd_lbl 100 `"Employed, not specified"', add
label define empstatd_lbl 110 `"At work"', add
label define empstatd_lbl 111 `"At work, and 'student'"', add
label define empstatd_lbl 112 `"At work, and 'housework'"', add
label define empstatd_lbl 113 `"At work, and 'seeking work'"', add
label define empstatd_lbl 114 `"At work, and 'retired'"', add
label define empstatd_lbl 115 `"At work, and 'no work'"', add
label define empstatd_lbl 116 `"At work, and other situation"', add
label define empstatd_lbl 117 `"At work, family holding, not specified"', add
label define empstatd_lbl 118 `"At work, family holding, not agricultural"', add
label define empstatd_lbl 119 `"At work, family holding, agricultural"', add
label define empstatd_lbl 120 `"Have job, not at work in reference period"', add
label define empstatd_lbl 130 `"Armed forces"', add
label define empstatd_lbl 131 `"Armed forces, at work"', add
label define empstatd_lbl 132 `"Armed forces, not at work in reference period"', add
label define empstatd_lbl 133 `"Military trainee"', add
label define empstatd_lbl 140 `"Marginally employed"', add
label define empstatd_lbl 200 `"Unemployed, not specified"', add
label define empstatd_lbl 201 `"Unemployed 6 or more months"', add
label define empstatd_lbl 202 `"Worked fewer than 6 months, permanent job"', add
label define empstatd_lbl 203 `"Worked fewer than 6 months, temporary job"', add
label define empstatd_lbl 210 `"Unemployed, experienced worker"', add
label define empstatd_lbl 220 `"Unemployed, new worker"', add
label define empstatd_lbl 230 `"No work available"', add
label define empstatd_lbl 240 `"Inactive unemployed"', add
label define empstatd_lbl 300 `"Inactive (not in labor force)"', add
label define empstatd_lbl 301 `"Unavailable jobseekers"', add
label define empstatd_lbl 302 `"Available potential jobseekers"', add
label define empstatd_lbl 310 `"Housework"', add
label define empstatd_lbl 320 `"Health reasons, unable to work, or disabled"', add
label define empstatd_lbl 321 `"Permanent disability"', add
label define empstatd_lbl 322 `"Temporary illness"', add
label define empstatd_lbl 323 `"Disabled or imprisoned"', add
label define empstatd_lbl 330 `"In school"', add
label define empstatd_lbl 340 `"Retirees and living on rent"', add
label define empstatd_lbl 341 `"Living on rents"', add
label define empstatd_lbl 342 `"Living on rents or pension"', add
label define empstatd_lbl 343 `"Retirees/pensioners"', add
label define empstatd_lbl 344 `"Retired"', add
label define empstatd_lbl 345 `"Pensioner"', add
label define empstatd_lbl 346 `"Non-retirement pension"', add
label define empstatd_lbl 347 `"Disability pension"', add
label define empstatd_lbl 348 `"Retired without benefits"', add
label define empstatd_lbl 350 `"Elderly"', add
label define empstatd_lbl 351 `"Elderly or disabled"', add
label define empstatd_lbl 360 `"Institutionalized"', add
label define empstatd_lbl 361 `"Prisoner"', add
label define empstatd_lbl 370 `"Intermittent worker"', add
label define empstatd_lbl 371 `"Not working, seasonal worker"', add
label define empstatd_lbl 372 `"Not working, occasional worker"', add
label define empstatd_lbl 380 `"Other income recipient"', add
label define empstatd_lbl 390 `"Inactive, other reasons"', add
label define empstatd_lbl 391 `"Too young to work"', add
label define empstatd_lbl 392 `"Dependent"', add
label define empstatd_lbl 999 `"Unknown/missing"', add
label values empstatd empstatd_lbl

label define labforce_lbl 1 `"No, not in the labor force"'
label define labforce_lbl 2 `"Yes, in the labor force"', add
label define labforce_lbl 8 `"Unknown"', add
label define labforce_lbl 9 `"NIU (not in universe)"', add
label values labforce labforce_lbl

label define classwk_lbl 0 `"NIU (not in universe)"'
label define classwk_lbl 1 `"Self-employed"', add
label define classwk_lbl 2 `"Wage/salary worker"', add
label define classwk_lbl 3 `"Unpaid worker"', add
label define classwk_lbl 4 `"Other"', add
label define classwk_lbl 9 `"Unknown/missing"', add
label values classwk classwk_lbl

label define classwkd_lbl 000 `"NIU (not in universe)"'
label define classwkd_lbl 100 `"Self-employed"', add
label define classwkd_lbl 101 `"Self-employed, unincorporated"', add
label define classwkd_lbl 102 `"Self-employed, incorporated"', add
label define classwkd_lbl 110 `"Employer"', add
label define classwkd_lbl 111 `"Sharecropper, employer"', add
label define classwkd_lbl 120 `"Working on own account"', add
label define classwkd_lbl 121 `"Own account, agriculture"', add
label define classwkd_lbl 122 `"Domestic worker, self-employed"', add
label define classwkd_lbl 123 `"Subsistence worker, own consumption"', add
label define classwkd_lbl 124 `"Own account, other"', add
label define classwkd_lbl 125 `"Own account, without temporary/unpaid help"', add
label define classwkd_lbl 126 `"Own account, with temporary/unpaid help"', add
label define classwkd_lbl 130 `"Member of cooperative"', add
label define classwkd_lbl 140 `"Sharecropper"', add
label define classwkd_lbl 141 `"Sharecropper, self-employed"', add
label define classwkd_lbl 142 `"Sharecropper, employee"', add
label define classwkd_lbl 150 `"Kibbutz member"', add
label define classwkd_lbl 199 `"Self-employed, not specified"', add
label define classwkd_lbl 200 `"Wage/salary worker"', add
label define classwkd_lbl 201 `"Management"', add
label define classwkd_lbl 202 `"Non-management"', add
label define classwkd_lbl 203 `"White collar (non-manual)"', add
label define classwkd_lbl 204 `"Blue collar (manual)"', add
label define classwkd_lbl 205 `"White or blue collar"', add
label define classwkd_lbl 206 `"Day laborer"', add
label define classwkd_lbl 207 `"Employee, with a permanent job"', add
label define classwkd_lbl 208 `"Employee, occasional, temporary, contract"', add
label define classwkd_lbl 209 `"Employee without legal contract"', add
label define classwkd_lbl 210 `"Wage/salary worker, private employer"', add
label define classwkd_lbl 211 `"Apprentice"', add
label define classwkd_lbl 212 `"Religious worker"', add
label define classwkd_lbl 213 `"Wage/salary worker, non-profit, NGO"', add
label define classwkd_lbl 214 `"White collar, private"', add
label define classwkd_lbl 215 `"Blue collar, private"', add
label define classwkd_lbl 216 `"Paid family worker"', add
label define classwkd_lbl 217 `"Cooperative employee"', add
label define classwkd_lbl 220 `"Wage/salary worker, government or public sector"', add
label define classwkd_lbl 221 `"Federal, government employee"', add
label define classwkd_lbl 222 `"State government employee"', add
label define classwkd_lbl 223 `"Local government employee"', add
label define classwkd_lbl 224 `"White collar, public"', add
label define classwkd_lbl 225 `"Blue collar, public"', add
label define classwkd_lbl 226 `"Public companies"', add
label define classwkd_lbl 227 `"Civil servants, local collectives"', add
label define classwkd_lbl 230 `"Domestic worker (work for private household)"', add
label define classwkd_lbl 240 `"Seasonal migrant"', add
label define classwkd_lbl 241 `"Seasonal migrant, no broker"', add
label define classwkd_lbl 242 `"Seasonal migrant, uses broker"', add
label define classwkd_lbl 250 `"Other wage and salary"', add
label define classwkd_lbl 251 `"Canal zone/commission employee"', add
label define classwkd_lbl 252 `"Government employment/training program"', add
label define classwkd_lbl 253 `"Mixed state/private enterprise/parastatal"', add
label define classwkd_lbl 254 `"Government public work program"', add
label define classwkd_lbl 255 `"State enterprise employee"', add
label define classwkd_lbl 256 `"Coordinated and continuous collaboration job"', add
label define classwkd_lbl 300 `"Unpaid worker"', add
label define classwkd_lbl 310 `"Unpaid family worker"', add
label define classwkd_lbl 320 `"Apprentice, unpaid or unspecified"', add
label define classwkd_lbl 330 `"Trainee"', add
label define classwkd_lbl 340 `"Apprentice or trainee"', add
label define classwkd_lbl 350 `"Works for others without wage"', add
label define classwkd_lbl 400 `"Other"', add
label define classwkd_lbl 999 `"Unknown/missing"', add
label values classwkd classwkd_lbl

save "Censos_1973_2005.dta", replace

use "Censos_1973_2005.dta", clear

keep if age >= 18 & age <= 60

keep year age sex marst lit edattain labforce empstat

rename labforce aux
gen labforce = 0 if inlist(aux, 1, 8)
replace labforce = 1 if inlist(aux, 2)
drop aux

gen female = sex == 2
drop sex

gen single = marst == 1
gen married = marst == 2
gen divorced = marst == 3
gen widowed_ukn = marst == 4 | marst == 9
drop marst

gen literate = lit == 2
drop lit

gen primary = edattain == 2
gen secondary = edattain == 3
gen tertiary = edattain == 4
drop edattain

save "LaborForce_1973_2005.dta", replace
