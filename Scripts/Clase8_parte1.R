#Limpiar espacio de trabajo
cat("\014")
rm(list = ls())
options(scipen=0)
options(digits = 4)

#Instalar y Cargar Librerias
PackageNames <- c("fastDummies", "haven", "fixest", "jtools", "tidyverse", "stargazer", "magrittr", "margins", "caret")
for(i in PackageNames){
  if(!require(i, character.only = T)){
    install.packages(i, dependencies = T)
    require(i, character.only = T)
  }
}

link_datos <- 'https://www.dropbox.com/scl/fi/ng7f1qoig9xxesn8lzp9h/GEIH.dta?rlkey=ws58sutee6n5rjev6p36j27su&st=w4ilis6r&dl=1'
datos <- read_dta(link_datos)

#Muestra Aleatoria
datos <- datos[datos$u<0.02,]

#Participacion Laboral
#Brecha de genero
mujeres <- aggregate(ocupado ~ area, data = datos[datos$mujer ==1, ], FUN = mean)
hombres <- aggregate(ocupado ~ area, data = datos[datos$mujer ==0, ], FUN = mean)
brecha <- mujeres[, 2]-hombres[, 2]
ocupacion <- cbind(mujeres, hombres[, 2], brecha)
names(brecha) <- c('ciudad', 'mujeres', 'hombres', 'brecha')

#Crear variables binarias
datos <- dummy_cols(datos, select_columns = c("area"))

#Edad al cuadrado
datos$edad2 <- datos$edad^2

#Describamos los datos
names(datos)
attach(datos)

#Estadisticas descriptivas de las variables
summary(datos)

#------------------------------------------------------------------
#Modelo de Probabilidad Lineal
#------------------------------------------------------------------

#Modelo 1
modelo1 <- lm(ocupado ~ mujer, data = datos)
summ(modelo1, digits = 4)
summ(modelo1, robust = "HC1", digits = 4)

#Modelo 2: 1 + Controles de Persona
modelo2 <- lm(ocupado ~ mujer + 
             escolaridad + edad + edad2 + d_esc, data = datos)
summ(modelo2, robust = "HC1", digits = 4)

#Modelo 3: 2 + Controles Geograficos
modelo3 <- lm(ocupado ~ mujer + 
             escolaridad + edad + edad2 + d_esc +
               area_Barranquilla + area_Bucaramanga + area_Cali + area_Cartagena +
               area_Cúcuta + area_Ibagué + area_Manizales + area_Medellin + area_Montería + area_Pasto +
               area_Pereira + area_Villavicencio, data = datos)
summ(modelo3, robust = "HC1", digits = 4)

#Prediccion del Modelo
datos %<>% mutate(mpl_yhat = fitted(modelo3))

#Valores Predichos
table(datos$mpl_yhat < 0)
table(datos$mpl_yhat > 1)

#Distribucion de valores predichos
hist(datos$mpl_yhat, probability = T, main = "", xlab = "Prediccion MPL", breaks=100)
lines(density(datos$mpl_yhat, na.rm=T), lwd = 2, col = "red")

#------------------------------------------------------------------
#Modelo Logit
#------------------------------------------------------------------

logit <- glm(ocupado ~ mujer + 
               escolaridad + edad + edad2 + d_esc +
               area_Barranquilla + area_Bogota + area_Bucaramanga + area_Cali + area_Cartagena +
               area_Cúcuta + area_Ibagué + area_Manizales + area_Medellin + area_Montería + area_Pasto +
               area_Pereira + area_Villavicencio, 
               family = binomial(link = "logit"), data = datos)
summary(logit)

datos %<>% mutate(logit_yhat = fitted(logit))

#Valores Predichos
table(datos$logit_yhat < 0)
table(datos$logit_yhat > 1)

#Distribucion de valores predichos
hist(datos$logit_yhat, probability = T, main = "", xlab = "Prediccion Logit", breaks=100)
lines(density(datos$logit_yhat, na.rm=T), lwd = 2, col = "green")

#------------------------------------------------------------------
#Modelo Probit
#------------------------------------------------------------------

probit <- glm(ocupado ~ mujer + 
                escolaridad + edad + edad2 + d_esc +
                area_Barranquilla + area_Bogota + area_Bucaramanga + area_Cali + area_Cartagena +
                area_Cúcuta + area_Ibagué + area_Manizales + area_Medellin + area_Montería + area_Pasto +
                area_Pereira + area_Villavicencio, 
              family = binomial(link = "probit"), data = datos)
summary(probit)

datos %<>% mutate(probit_yhat = fitted(probit))

#Valores Predichos
table(datos$probit_yhat < 0)
table(datos$probit_yhat > 1)

#Distribucion de valores predichos
hist(datos$probit_yhat, probability = T, main = "", xlab = "Prediccion Logit", breaks=100)
lines(density(datos$probit_yhat, na.rm=T), lwd = 2, col = "blue")

#------------------------------------------------------------------
#Efectos Marginales
#------------------------------------------------------------------

#MPL
summary(modelo3)
coef(modelo3)

#Los coeficientes son los efectos marginales

# Logit model
summary(logit)

# Logit - marginal effect at the mean
logit.atmean <- margins(logit, at = Mean)
summary(logit.atmean)

# Logit - average marginal effect
logit.AME <- margins(logit)
summary(logit.AME)

# Modelo Probit
summary(probit)
Mean <- model.frame(probit) %>% 
  map_df(mean) # mean of independent variables

# Probit - efecto marginal en la media
probit.atmean <- margins(probit, at = Mean)
summary(probit.atmean)

# Probit - efecto marginal promedio
probit.AME <- margins(probit)
summary(probit.AME)

#--------------------------------------------------------
# Pseudo R-cuadrado
#--------------------------------------------------------

# Probit no restringido
summary(probit)

nr.model <- probit 
summary(nr.model)

# Log-verosimiltud
(LLur <- logLik(nr.model))

# Probit restringido
r.model <- glm(ocupado ~ 1, binomial(link = "probit"), data = datos) 
summary(r.model)

# Log-likelihood for model with only constant
(LL0 <- logLik(r.model))

# Calculate pseudo R-squared
(pseudo_r2 <- 1 - LLur/LL0)

#----------------------------------------------------
# Porcentaje de Predicciones Correctamente Predichas 
#----------------------------------------------------

#Probit
(Probit.pred <- (fitted(probit) > 0.5) %>% as.numeric %>% as.factor) # Prediction
(actual <- datos$ocupado %>% as.factor) # actual data
caret::confusionMatrix(Probit.pred, actual, positive = "1")

#Logit
(Logit.pred <- (fitted(logit) > 0.5) %>% as.numeric %>% as.factor) # Prediction
confusionMatrix(Logit.pred, actual, positive = "1")
