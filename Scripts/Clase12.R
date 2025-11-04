#Limpiar espacio de trabajo
cat("\014")
rm(list = ls())

#install.packages("AER")

library(AER)
library(stargazer)
library(fixest)
library(jtools)
library(tidyverse)
library(stargazer)
library(magrittr)
library(margins)
library(caret)
library(modelsummary)
library(haven)
library(ggplot2)

#Cargar datos
data(STAR)

#Revisar datos
head(STAR, 2)
dim(STAR)
names(STAR)

#Computar las diferencias para cada grado
fmk <- lm(I(readk + mathk) ~ stark, data = STAR)
summ(fmk, digits = 4)
summ(fmk, robust = "HC1", digits = 4) #Errores estandar robustos
fm1 <- lm(I(read1 + math1) ~ star1, data = STAR)
fm2 <- lm(I(read2 + math2) ~ star2, data = STAR)
fm3 <- lm(I(read3 + math3) ~ star3, data = STAR)

#Comparar resultados
models <- list("Preescolar " = fmk, "Grado 1" = fm1, "Grado 2" = fm2, "Grado 3" = fm3)
modelsummary(models, vcov = "HC1", gof_map = c("nobs"))

#Modelo con covariables
STARK <- STAR %>% 
  transmute(gender,
            ethnicity,
            stark,
            readk,
            mathk,
            lunchk,
            experiencek,
            schoolidk) %>% 
  mutate(black = ifelse(ethnicity == "afam", 1, 0),
         race = ifelse(ethnicity == "afam" | ethnicity == "cauc", 1, 0),
         boy = ifelse(gender == "male", 1, 0))

gradeK0 <- lm(I(mathk + readk) ~ stark, 
              data = STARK)

gradeK1 <- lm(I(mathk + readk) ~ stark + experiencek, 
              data = STARK)

gradeK2 <- lm(I(mathk + readk) ~ stark + experiencek + boy + lunchk 
              + black + race, 
              data = STARK)

gradeK3 <- lm(I(mathk + readk) ~ stark + experiencek + boy + lunchk 
              + black + race + schoolidk, 
              data = STARK)

models <- list("Modelo 1" = gradeK0, "Modelo 1" = gradeK1, "Modelo 2" = gradeK2, "Modelo 3" = gradeK3)
modelsummary(models, vcov = "HC1", gof_map = c("nobs"))
