use "/Users/smontano/Desktop/Datos/Teachers Complete 2007-2015.dta", clear

keep if t_2015 == 1
keep national_id_type national_id *2015 cdoc*

egen doc_examen = rowfirst(cdoc_promedio?????) 
gen doc_exper = 2015 - year(fecha_vinculacion2015)

gen educ = 1 if inlist(nivel_educativo2015, 0, 1, 3)
replace educ = 2 if inlist(nivel_educativo2015, 2, 4, 5)
replace educ = 3 if inlist(nivel_educativo2015, 6, 7)
replace educ = 4 if inlist(nivel_educativo2015, 8, 9)
tab educ, gen(doc_educ_)

replace genero = upper(genero)
tab genero, gen(sexo_)
rename sexo_1 doc_mujer

gen num_doc = 1
collapse (mean) doc_examen doc_exper doc_educ_* doc_mujer (sum) num_doc, by(codigo_dane2015)
rename codigo_dane2015 codigo_dane

tempfile Teachers
save `Teachers', replace

use "/Users/smontano/Desktop/Datos/Saber 11 Students - Reduced.dta", clear

keep if exam_year == 2015

global T rawscore_math rawscore_reading rawscore_frgn_language rawscore_natural_sc rawscore_social_sc rawscore_overall

tab mother_educ, gen(mother_educ_)

gen n = 1
collapse (mean) $T stud_age stud_gender stud_stratum stud_work mother_educ_* (sum) n if public == 1, by(codigo_dane)

merge 1:1 codigo_dane using `Teachers'
keep if _merge == 3
drop _merge

drop if stud_stratum == .
drop if doc_examen == .
drop if stud_work  == .

drop if num_doc < 10
drop if n < 3

rename ($T) (matematicas lectura ingles ciencias sociales promedio)
rename (stud_age stud_gender stud_stratum stud_work) (edad mujer estrato trabaja)
rename (mother_educ_1 mother_educ_5 mother_educ_4) (meduc_preg meduc_prim meduc_sec)
rename ( doc_educ_2 doc_educ_3 doc_educ_4) (doc_normal doc_preg doc_posg)

drop mother_educ_2 mother_educ_3 doc_educ_1 n num_doc

label var codigo_dane "Colegio ID"
label var mate "Matematicas (Saber 11)"
label var lec "Lectura (Saber 11)"
label var ing "Ingles (Saber 11)"
label var cien "Ciencias (Saber 11)"
label var soc "Ciencias Sociales (Saber 11)"
label var prom "Promedio (Saber 11)"
label var edad "Edad Promedio Estudiantes"
label var mujer "% Estudiantes Mujeres"
label var estrato "Estrato Promedio Estudiantes"
label var trabaja "% Estudiantes Trabajan"
label var meduc_preg "% Madres con Pregrado"
label var meduc_sec "% Madres con Secundaria"
label var meduc_prim "% Madres con Primaria"
label var doc_examen "Puntaje Ingreso Docentes"
label var doc_exper "Experiencia Docentes"
label var doc_normal "% Docentes Normalistas"
label var doc_preg "% Docentes con Pregrado"
label var doc_posg "% Docentes con Posgrado"
label var doc_mujer "% Docentes Mujeres"
  
order codigo_dane mujer edad estrato trabaja meduc_prim meduc_sec meduc_preg promedio matematicas lectura ingles ciencias sociales doc_mujer doc_exper doc_normal doc_preg doc_posg doc_examen

sum doc_examen
gen aux1 = (doc_examen - r(mean))/r(sd)
drop if abs(aux1) > 4

sum promedio
gen aux2 = (promedio - r(mean))/r(sd)
drop if abs(aux2) > 3

drop aux*
drop matematicas lectura ingles ciencias sociales 
save "/Users/smontano/Desktop/Datos/Saber11_Colegios", replace



global X mujer edad estrato trabaja meduc_prim meduc_sec meduc_preg
global W doc_mujer doc_exper doc_normal doc_preg doc_posg

reg promedio doc_examen

reg promedio doc_examen $X

reg promedio doc_examen $X $W

reg promedio doc_examen $X $W, robust
