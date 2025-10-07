use "https://www.dropbox.com/scl/fi/3n6yy0ilxectetvedv55n/Saber11.dta?rlkey=iovl23jtawcnd3s2auf15o9h4&dl=1", clear

//Modelo base
reg sdscore_overall ib2004.exam_year##i.public, robust

//Modelo con controles
reg sdscore_overall ib2004.exam_year##i.public stud_age stud_gender i.sch_schedule i.stud_stratum, robust

//Modelo completo
areg sdscore_overall ib2004.exam_year##i.public stud_age stud_gender i.sch_schedule i.stud_stratum, absorb(codigo_dane) robust