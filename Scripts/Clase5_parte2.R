#Limpiar espacio de trabajo
cat("\014")
rm(list = ls())

#Datos
install.packages('haven')
library('haven')

link_datos <- 'https://www.dropbox.com/scl/fi/vy1cw4zkgm3op6pzd7lau/skills_data.dta?rlkey=p11n80lk68nzkqigt2dhbtyl9&dl=1'
datos <- read_dta(link_datos)

#Queremos estudiar la relacion entre habilidades cognitivas y el salario
#Para ello usaremos datos del Saber Pro y el Mercado Laboral Formal en Colombia

#Describamos los datos
names(datos)
attach(datos)

#Numero de mujeres
table(female)

#Estadisticas descriptivas de las variables
summary(datos)

#Histograma de Puntajes en Prueba
hist(lit, breaks = 100, prob = T, ylim = c(0,0.5), xlim = c(-4, 4), main = 'Comprension de Lectura (Saber Pro)', ylab = "Probabilidad", xlab = 'Puntaje Estandarizado')
lines(density(lit), lty = 2, lw = 2, col = "black")

#Relacion entre comprension de lectura y 
plot(lit, ln_fst_wage)
markers <- c(17, 19)
colors <- c("red", "blue")
plot(lit, ln_fst_wage,  pch = markers[factor(female)], col = colors[factor(female)] , xlab = 'Comprension de Lectura', ylab = 'Salario (logaritmo)', cex = 0.7)
legend("topleft",  legend = c("Hombre", "Mujer"), col = colors,  pch = markers, cex = 0.9, bty = "n")

#Promedios
bins_female <- cut(lit[female == 1], breaks = seq(-3, 3, by = 0.25), include.lowest = TRUE, right = FALSE, ordered_result = T)
means_female <- tapply(ln_fst_wage[female == 1], bins_female, mean)
bins_male <- cut(lit[female == 0], breaks = seq(-3, 3, by = 0.25), include.lowest = TRUE, right = FALSE, ordered_result = T)
means_male <- tapply(ln_fst_wage[female == 0], bins_male, mean)
means <-rbind(means_male, means_female)

literacy <- c(seq(-3, 3, by = 0.25)[-1], seq(-3, 3, by = 0.25)[-1])
plot(literacy, means)

markers <- c(17, 19)
colors <- c("red", "blue")
f <- c(rep(0, 24), rep(1, 24))
plot(literacy, means,  pch = markers[factor(f)], col = colors[factor(f)] , xlab = 'Puntaje Compresion Lectura', ylab = 'Logaritmo del Salario')
legend("topleft",  legend = c("Hombre", "Mujer"), col = colors,  pch = markers, cex = 0.9, bty = "n")

#---------------------Estimacion del Modelo---------------------------------------

#Modelo sin controles
model1 <- lm(ln_fst_wage ~ lit + num + eng)
summary(model1)

#Modelo con controles
model2 <- lm(ln_fst_wage ~ lit + num + eng
               + sb11_literacy + sb11_numeracy + sb11_english
               + female + age + age_2 + factor(stratum))
summary(model2)

#Decidamos si dejamos el modelo con controles
SST <- sum((ln_fst_wage - mean(ln_fst_wage))^2)

SSE_R <- sum(model1$residuals^2)
R2_R = 1 - SSE_R/SST; R2_R

SSE_NR <- sum(model2$residuals^2)  
R2_NR = 1 - SSE_NR/SST; R2_NR

#Estadistico de Prueba
n <- length(ln_fst_wage)
k <- length(model2$coefficients)
F_stat = (R2_NR - R2_R)/((1-R2_NR)/(n - k)); F_stat
F_critico <- qf(1-0.05, k-1, n - k); F_critico

#Conclusion?
if (F_stat > F_critico) {
  print('Rechace H0 (con alpha = 5%)')
} else {
  print('No rechace H0 (con alpha = 5%)')
}
#entonces rechazamos H0 y nos quedamos con el modelo con controles

#---------------------Modelo Completo---------------------------------------

model <- lm(ln_fst_wage ~ lit + num + eng
            + program_type_1 + program_type_4 + program_type_3
            + female + age + age_2 + factor(stratum) + factor(educ_madre) + factor(study_field) + factor(test_edition) + factor(grad_year))

summary(model)