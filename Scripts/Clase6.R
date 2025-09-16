######################################################
#------------------Parte 1---------------------------
######################################################

#Limpiar espacio de trabajo
cat("\014")
rm(list = ls())

#Instalar y cargar libreria
install.packages("wooldridge"); 
library(wooldridge)

#Cargar datos
data('wage1')
names(wage1) #Variables en la base de datos

#Crear variable nuevas
wage1$ln_wage <- log(wage1$wage) #log del salario

wage1$occup <- 1 #Ocupacion
wage1$occup[wage1$profocc==1] <- 2
wage1$occup[wage1$clerocc==1] <- 3
wage1$occup[wage1$servocc==1] <- 4
table(wage1$occup)

#Variables dummy
table(I(wage1$occup==2)) #Profesionales
table(I(wage1$occup==3)) #Servicios generales
table(I(wage1$occup==4)) #Servicios

#Modelo con variables categoricas
summary(lm(log(wage) ~ educ + exper + expersq + female + 
             I(occup==2) + I(occup==3) + I(occup==4) + I(occup==1), 
             data = wage1))
#Nota: observe que R excluye la ultima categoria que se incluye. 
#Es importante indicar cual categoria debe excluir

#Modelo con variables categoricas
summary(lm(log(wage) ~ educ + exper + expersq + female + 
             factor(occup), data = wage1))

#Interacciones

#Entre variables binarias
summary(lm(log(wage) ~ female + married + educ + female*married, data = wage1))

#Entre una variable binaria y una variable continua
summary(lm(log(wage) ~ female + educ + female*educ, data = wage1))


######################################################
#------------------Parte 2---------------------------
######################################################

#Ejemplo de multicolinealidad

#Limpiar espacio de trabajo
cat("\014")
rm(list = ls())

w <- c(0.8, 1, 1.4, 1.2, 1.8, 2, 1.8, 2.1, 2.7, 3.0) #Salarios
s <- c(1, 1, 2, 2, 3, 3, 4, 4, 5, 5) #educacion
f <- c(1, 0, 1, 0, 1, 0, 1, 0, 1, 0) #mujer=1, hombre=0

s_mp <- 1 + 2*s
s_imp <- c(1, 1, 2, 1, 3, 3, 4, 4, 5, 5)

summary(lm(w ~ s))

#Multicolinealidad Perfecta
rho <- cor(s, s_mp); print(paste0('Correlacion entre s y s_mp = ', rho))
summary(lm(w ~ s + s_mp))

#Multicolinealidad Imperfecta
rho <- cor(s, s_imp); print(paste0('Correlacion entre s y s_imp = ', rho))
summary(lm(w ~ s + s_imp))

######################################################
#------------------Parte 3---------------------------
######################################################

#Normalidad de los errores

#Limpiar espacio de trabajo
cat("\014")
rm(list = ls())

#Cargar datos
data('wage1')
names(wage1) 

model <- lm(log(wage) ~ educ + exper + expersq + female, data = wage1)
e <- model$residuals

par(mfrow=c(1,2))
hist(e, xlab = "Residuals", probability = T, ylim = c(0, 1)) #Histograma de esiduales
lines(density(e, na.rm=T), lwd = 2, col = "red") # Densidad estimada de los residuales
curve(dnorm(x, mean = mean(e, na.rm=T), sd = sd(e, na.rm=T)), lty = 2, lwd = 2, add = TRUE, col = "blue") #Distribucion normal
qqnorm(rstandard(model), col="red", pch=20) ##Q-Q plot
abline(a=0, b=1, col="blue", lty=2, lwd=2)

shapiro.test(e)
ks.test(e, "pnorm", mean = mean(e), sd = sd(e))

######################################################
#------------------Parte 4---------------------------
######################################################

#Heteroscedasticidad

#Limpiar espacio de trabajo
cat("\014")
rm(list = ls())

install.packages("scales")
library(scales)

set.seed(080925)

#Ejemplo 1
x <- abs(rnorm(1000, 0, 3))
e <- rnorm(1000, 0, 1)*x
plot(x, e, ylim = c(-20, 20), xlim = c(0, 10), 
     xlab = "Variable x", ylab = expression(paste("Errores (", epsilon, ")")), 
     cex = 1.5, pch = 19, col = alpha("red", 0.5), frame = F)

#Ejemplo 2
x <- rnorm(1000, 0, 3)
e <- rnorm(1000, 0, 1)*x
plot(x, e, ylim = c(-20, 20), xlim = c(-10, 10), 
     xlab = "Variable x", ylab = expression(paste("Errores (", epsilon, ")")), 
     cex = 1.5, pch = 19, col = alpha("blue", 0.5), frame = F)

e <- c(rnorm(500, 0, 1), rnorm(500, 0, 5)) 
f <- c(rep(1, 500), rep(0, 500))

#Ejemplo 3
markers <- c(19, 17)
colors <- c("#66BD63", "#FDAE61")
plot(x, e, ylim = c(-20, 20), xlim = c(0, 10), 
     xlab = "Variable x", ylab = expression(paste("Errores (", epsilon, ")")), 
     cex = 1.5, pch = markers[factor(f)], col = alpha(colors[factor(f)], 0.5), frame = F)

#Prueba G-Q: Ejemplo 1
#-------------------------------------------------------------------
x <- abs(rnorm(1000, 0, 3))
e <- rnorm(1000, 0, 1)*x
y <- 1 + 2*x + e

quantile(x, probs = c(0.33, 0.66))
q <- rep(2, 1000)
q[x < 1.252345] <- 1
q[x > 2.939415] <- 3
table(q)

summary(x[q==1])
summary(x[q==2])
summary(x[q==3])

#Errores
par(mfrow=c(1,2))
plot(x, e, ylim = c(-20, 20), xlim = c(0, 10), 
     xlab = "Variable x", ylab = expression(paste("Errores (", epsilon, ")")), 
     cex = 0.8, pch = 19, col = alpha("red", 0.5), frame = F)

colors <- c("red", "white", "red")
markers <- c(19, 2, 19)
plot(x, e, , ylim = c(-20, 20), xlim = c(0, 10),
     pch = markers[factor(q)], cex = 0.8, frame = FALSE, 
     xlab = "Variable x", ylab = expression(paste("Errores (", epsilon, ")")), 
     col =  alpha(colors[factor(q)], 0.5))

#Variable dependiente
par(mfrow=c(1,2))
plot(x, y, ylim = c(0, 30), xlim = c(0, 10), 
     xlab = "Variable x", ylab = expression(paste("Errores (", epsilon, ")")), 
     cex = 0.8, pch = 19, col = alpha("red", 0.5), frame = F)

colors <- c("red", "white", "red")
markers <- c(19, 2, 19)
plot(x, y, ylim = c(0, 30), xlim = c(0, 10),
     pch = markers[factor(q)], cex = 0.8, frame = FALSE, 
     col =  alpha(colors[factor(q)], 0.5))

#Regresion en grupo 1
summary(lm(y[q == 1] ~ x[q == 1]))

#Regresion en grupo 3
summary(lm(y[q == 3] ~ x[q == 3]))

F_stat = (4.744/0.7309)^2; F_stat

n1 <- sum(I(q==1)); n1
n2 <- sum(I(q==3)); n2

#Region de Rechazo
qf(0.025, n2-2, n1-2)
qf(0.975, n2-2, n1-2)

1-pf(F_stat, n2-2, n1-2)

#Prueba G-Q: Ejemplo 2
#-------------------------------------------------------------------
x <- rnorm(1000, 0, 3)
e <- rnorm(1000, 0, 1)*x
y <- 1 + 2*x + e

quantile(x, probs = c(0.33, 0.66))
q <- rep(2, 1000)
q[x < -1.493869] <- 1
q[x >  1.198188] <- 3
table(q)

summary(x[q==1])
summary(x[q==2])
summary(x[q==3])

#Errores
par(mfrow=c(1,2))
plot(x, e, ylim = c(-20, 20), xlim = c(-10, 10), 
     xlab = "Variable x", ylab = expression(paste("Errores (", epsilon, ")")), 
     cex = 0.8, pch = 19, col = alpha("blue", 0.5), frame = F)

colors <- c("blue", "white", "blue")
markers <- c(19, 2, 19)
plot(x, e, , ylim = c(-20, 20), xlim = c(-10, 10),
     pch = markers[factor(q)], cex = 0.8, frame = FALSE, 
     xlab = "Variable x", ylab = expression(paste("Errores (", epsilon, ")")), 
     col =  alpha(colors[factor(q)], 0.5))

#Variable dependiente
par(mfrow=c(1,2))
plot(x, y, ylim = c(-40, 40), xlim = c(-10, 10), 
     xlab = "Variable x", ylab = expression(paste("Errores (", epsilon, ")")), 
     cex = 0.8, pch = 19, col = alpha("blue", 0.5), frame = F)

colors <- c("blue", "white", "blue")
markers <- c(19, 2, 19)
plot(x, y, ylim = c(-40, 40), xlim = c(-10, 10),
     pch = markers[factor(q)], cex = 0.8, frame = FALSE, 
     col =  alpha(colors[factor(q)], 0.5))

#Regresion en grupo 1
summary(lm(y[q == 1] ~ x[q == 1]))

#Regresion en grupo 3
summary(lm(y[q == 3] ~ x[q == 3]))

F_stat = (3.658/3.799)^2; F_stat

n1 <- sum(I(q==1)); n1
n2 <- sum(I(q==3)); n2

#Region de Rechazo
qf(0.025, n2-2, n1-2)
qf(0.975, n2-2, n1-2)

#P-value
1-pf(F_stat, n2-2, n1-2)

#-----------Prueba de Breusch-Pagan---------------------------------
model <- lm(y ~ x)
summary(model)

install.packages("lmtest")
library("lmtest")
bptest(model)

install.packages("skedastic")
library("skedastic")
white(mainlm =  model, interactions = TRUE)