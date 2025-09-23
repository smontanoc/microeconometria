/*******************************************************************************/

cls
clear all
set more off

pwd

global data Data/


/********************************************************************************/
//GEIH

tempfile GEIH
local y = 1
foreach year in 2018 {
	local m = 1
	foreach month in Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre {

	clear

	cap import spss using "$data/`year'/`month'/Area - Caracteristicas generales (Personas).sav", clear
	cap use "$data/`year'/`month'/Area - Caracteristicas generales (Personas).dta", clear
	
	preserve
	cap import spss using "$data/`year'/`month'/Area - Ocupados.sav", clear	
	cap use "$data/`year'/`month'/Area - Ocupados.dta", clear	
	tempfile Ocupados 
	save `Ocupados', replace
	restore 
	
	merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using `Ocupados'
	keep if _merge == 3 | _merge == 1
	drop _merge

	gen year = `year'
	gen month = `m'
	
	if `y' == 1 & `m' == 1 save `GEIH', replace
	else append using `GEIH'
	
	save `GEIH', replace 
	
	local m = `m' + 1
	}
local y = `y' + 1
}

//Poblacion en Edad de Trabajar
gen pet = P6040 >= 12

//Ocupados
gen ocupado = OCI == 1 if pet == 1

gen mujer = P6020 == 2 if P6020 != .
gen edad = P6040

replace P6220 = 1 if P6220 == 9

decode P6220, gen(educ)
replace educ = "TyT" if regexm(educ, "cnico")

rename ESC escolaridad

gen d_esc = P6170 == 1 if P6170 != .

destring AREA, replace

label define a 5 "Medellin" 8 "Barranquilla" 11 "Bogota" 13 "Cartagena" 17 "Manizales" 23 "Montería" 50 "Villavicencio" 52 "Pasto" 54 "Cúcuta" 66 "Pereira" 68 "Bucaramanga" 73 "Ibagué" 76 "Cali"
label values AREA a 

decode AREA, gen(area)

rename month mes 

keep mes pet ocupado mujer edad escolaridad d_esc area fex_c_2011
keep if ocupado != . & escolaridad != .

gen double u = .
foreach i of numlist 1(1)12 {
replace u = runiform() if mes == `i'
}

save "GEIH.dta", replace

