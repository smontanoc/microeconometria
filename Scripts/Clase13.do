/*
Implementacion de Variables Instrumentales 

Card (1993): Using Geographic Variation in College Proximity to Estimate the Return to Schooling
https://www.nber.org/papers/w4483

*/

//Load data
	use "https://www.dropbox.com/scl/fi/dzviia10xwl6jjciow26f/card.dta?rlkey=rlohtoo7dx9c1gkrqfy0a3llp&dl=1", clear

//Regresion endogena
	reg lwage educ exper expersq black south smsa

	reg lwage educ exper expersq black south smsa reg66* smsa66

	*Variables Instrumentales es una Metodologia para tratar problemas de Endogeneidad
		*Recuerte que es importante cumplir con dos condiciones:
			*Cov(Z, X) != 0 (Relevancia o Restriccion de Inclusion)
			*Cov(Z, e) == 0 (Exogeneidad o Restriccion de Exclusion)
				*Observe que la restriccion de exclusion se tambien podria plantearse como Cov(Z, y) == 0

//Primera Etapa
	reg educ nearc4 exper expersq black south smsa reg66* smsa66

//Segunda Etapa
	predict educ_hat, xb

	reg lwage educ_hat exper expersq black south smsa reg66* smsa66

//Es necesario corregir los errores estandar ya que la segunda etapa usa estimadores
//La correccion la realiza automaticamente el comando ivreg2

	ivreg2 lwage (educ=nearc4) exper expersq black south smsa reg66* smsa66

		*Este comando es util ya que presenta diferentes pruebas que permiten determinar si se tiene un instrumento debil (opcion first)
		*Recuerde que si el instrumento es debil, la metodologia no corrige la violacion al supuesto de independencia condicional
		*Mas aun, en presencia de un instrumento debil no es posible saber el tipo de sesgo

	ivreg2 lwage (educ=nearc4) exper expersq black south smsa reg66* smsa66, first
