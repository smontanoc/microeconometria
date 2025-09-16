#Limpiar espacio de trabajo
cat("\014")
rm(list = ls())

#Datos
w <- c(0.8, 1, 1.4, 1.2, 1.8, 2, 1.8, 2.1, 2.7, 3.0) #Salarios
s <- c(1, 1, 2, 2, 3, 3, 4, 4, 5, 5) #educacion
f <- c(1, 0, 1, 0, 1, 0, 1, 0, 1, 0) #mujer=1, hombre=0
n = length(w)

#Diagrama de dispercion
markers <- c(17, 19)
colors <- c("red", "blue")
plot(s, w,  pch = markers[factor(f)], col = colors[factor(f)] , xlab = 'Años de Educación', ylab = 'Salario (Millones de Pesos)', ylim = c(0, 3))
legend("topleft",  legend = c("Hombre", "Mujer"), col = colors,  pch = markers, cex = 0.9, bty = "n")

#---------------------Modelo 1----------------------------------------------------
# Inicialmnete estimaremos w = b0 + b1 s + u

#Estimemos los coeficientes
num <- sum( (w - mean(w))*(s - mean(s)) ); num
den <- sum( (s - mean(s))^2 ); den
b1 <- num/den; b1
b1 <- cov(w, s)/var(s); b1
b0 <- mean(w) - b1*mean(s); b0

#Interpretacion
print(paste('Un año adicional de educacion incrementa en', b1*1000000, 'pesos el salario de una persona'))  

#Prediccion del modelo
w_hat <- (b0 + b1 * s); w_hat

#Calcular los residuales
e <- w - w_hat; e

#Varianza del Modelo
sigma2_hat <- sum(e^2)/(n-2)
sigma2_hat

#---------------------Prueba de hipotesis---------------------------------------

# Estadistico de prueba
var_b1 <- sigma2_hat/sum( (s - mean(s))^2 )
ee_b1 <- sqrt(var_b1); ee_b1
t <- b1/ee_b1; t

#Valores criticos
t_critico1 <-qt(0.025, n-2)
t_critico2 <-qt(1-0.025, n-2)

#Distribucion t
set.seed(9225)
x <- rt(10000, n-2)
hist(x, breaks = 100, prob = T, ylim = c(0,0.4), xlim = c(-11, 11), main = 'Distribución t-Student (gl = n-2)', ylab = "Probabilidad", xlab = 't')
lines(density(x), lty = 2, lw = 2, col = "black")

#Region de Rechazo
polygon(c(-11, t_critico1, t_critico1, -11), c(0.4, 0.4, 0, 0), col = "#6BD7AF", density = 10)
polygon(c(11, t_critico2, t_critico2, 11), c(0.4, 0.4, 0, 0), col = "#6BD7AF", density = 10)
abline(v = t_critico1, col = "black")
abline(v = t_critico2, col = "black")

#Estadistico de prueba
abline(v = t, col = "red") 

#Conclusion?
if (abs(t) > abs(t_critico1)) {
  print('Rechace H0 (con alpha = 5%)')
} else {
  print('No rechace H0 (con alpha = 5%)')
}
  
#---------------------P-valor---------------------------------------------------
#Mínimo alpha para el que podemos rechazar H0

#Pr(T < t)
pt(t, n-2)

#Ya que es una prueba de dos colas
p_value = (1-pt(t, n-2))*2; p_value 

#---------------------Bondad de Ajuste------------------------------------------

SST <- sum( (w - mean(w))^2 )
SSR <- sum( (w_hat - mean(w_hat))^2 )
SSE <- sum( (w - w_hat)^2 )

r2 <- SSR/SST; r2
r2 <- 1 - SSE/SST; r2

#---------------------Veamoslo en R---------------------------------------------
model <- lm(w ~ s)
print(summary(model), digits = 3, signif.stars = TRUE)

#---------------------Modelo 2----------------------------------------------------
# Estimaremos ahora la relacion entre genero y salario usando el siguiente modelo
# w = a0 + a1 f + u

#Coeficientes
a1 <- cov(w, f)/var(f); a1
a0 <- mean(w) - a1*mean(f); a0

#Observen lo siguiente:
mean(w[f==1]) #Salario medio de las mujeres
mean(w[f==0]) #Salario medio de los hombres
mean(w[f==1]) - mean(w[f==0]) #a1 = diferencia de promedios condicionales
mean(w[f==0]) #a0 = media condicional en ser hombre

#No nos deberia soprender porque 
#una regresion es un promedio condicional :D

#Prediccion del modelo
w_hat <- (a0 + a1 * f); w_hat

#Calcular los residuales
e <- w - w_hat; e

#Varianza del Modelo
sigma2_hat <- sum(e^2)/(n-2) #estimador de sigma2

# Estadistico de prueba
var_a1 <- sigma2_hat/sum( (f - mean(f))^2 )
ee_a1 <- sqrt(var_a1); ee_a1
t <- a1/ee_a1; t

#Distribucion t
hist(x, breaks = 100, prob = T, ylim = c(0,0.4), xlim = c(-11, 11), main = 'Distribución t-Student (gl = n-2)', ylab = "Probabilidad", xlab = 't')
lines(density(x), lty = 2, lw = 2, col = "black")

#Region de Rechazo
polygon(c(-11, t_critico1, t_critico1, -11), c(0.4, 0.4, 0, 0), col = "#6BD7AF", density = 10)
polygon(c(11, t_critico2, t_critico2, 11), c(0.4, 0.4, 0, 0), col = "#6BD7AF", density = 10)
abline(v = t_critico1, col = "black")
abline(v = t_critico2, col = "black")

#Estadistico de prueba
abline(v = t, col = "red") 

#Conclusion?
if (abs(t) > abs(t_critico1)) {
  print('Rechace H0 (con alpha = 5%)')
} else {
  print('No rechace H0 (con alpha = 5%)')
}

model2 <- lm(w ~ f)
print(summary(model2), digits = 3, signif.stars = TRUE)

#---------------------Modelo Multivariado---------------------------------------
# Estimemos ahora nuestro modelo 
#w = b0 + b1*s + b2*f + u

#Estimemos el modelo usando el comando lm

model_full <- lm(w ~ s + f)
print(summary(model_full), digits = 3, signif.stars = TRUE)

#Repliquemos el resultado de R

#Numero de parametros a estimar
k <- 3 #b0, b1, b2

#Preparemos nuestra matrix de covariables
one <- c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1) #vector de 1
X <- cbind(one, s, f); X

#Estimemos los coeficientes
XX <- t(X)%*%X
XX1 = solve(XX)
XY <- t(X)%*%w
b = XX1%*%XY; b

#Residuales
e = w - X%*%b; e

#Varianza del Modelo
sigma2_hat <- sum(e^2)/(n-k) #estimador de sigma2
sigma2_hat <- t(e)%*%e/(n-k) #estimador de sigma2

#Matriz de Varianz-Covarianza
VarCov <- sigma2_hat[1, 1]*XX1; VarCov

#---------------------Pruebas de hipotesis---------------------------------------

#1. Pruebas Individuales

#b1
#Queremos ver si (H0: b1 = 0) vs (H1: b1 != 0)
b1 = b[2, 1]; b1
var_b1 = VarCov[2, 2]
ee_b1 = sqrt(var_b1)
t_b1 = b1/ee_b1; t_b1

t_critico = abs(qt(0.025, n-k)); t_critico

#Conclusion para b1?
if (abs(t_b1) > abs(t_critico)) {
  print('Rechace H0 (con alpha = 5%)')
} else {
  print('No rechace H0 (con alpha = 5%)')
}

#b2
#Queremos ver si (H0: b2 = 0) vs (H1: b2 != 0)
b2 = b[3, 1]; b2
var_b2 = VarCov[3, 3]
ee_b2 = sqrt(var_b2)
t_b2 = b2/ee_b2; t_b2

#Conclusion para b2?
if (abs(t_b2) > abs(t_critico)) {
  print('Rechace H0 (con alpha = 5%)')
} else {
  print('No rechace H0 (con alpha = 5%)')
}

#2. Prueba de Significancia Global
#Queremos ver si el modelo es conjuntamente significativo
#(H0: b2 = b3 = 0) vs (H1: alguno diferente de 0)

#Estadistico de Prueba

SSR <- sum( (X%*%b - mean(w))^2 )
MSR <- SSR/(k-1);MSR

SSE <- sum( (w - X%*%b)^2 )
MSE <- SSE/(n-k)

F_stat = MSR/MSE; F_stat

#F critico
F_critico <- qf(1-0.05, k-1, n-k); F_critico

#Distribucion F
set.seed(9225)
x <- rf(10000, k-1, n-k)
hist(x, breaks = 100, prob = T, ylim = c(0,0.8), xlim = c(0, 50), main = 'Distribución t-Student (gl = n-2)', ylab = "Probabilidad", xlab = 't')
lines(density(x), lty = 2, lw = 2, col = "black")

#Region de Rechazo
polygon(c(F_critico, 40, 40, F_critico), c(0.8, 0.8, 0, 0), col = "#6BD7AF", density = 10)
abline(v = F_critico, col = "black")
abline(v = F_stat, col = "red")

#P-valor
1-pf(F_stat, k-1, n-k)