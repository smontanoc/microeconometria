install.packages('dplyr')
install.packages('plotly')
install.packages('knitr')
install.packages('tidyverse')
install.packages('tidyr')
install.packages('stargazer')
library(dplyr)
library(plotly)
library(knitr)
library(tidyverse)
library(tidyr)
library(stargazer)

#Cargar datos 
data <- readr::read_csv("https://docs.google.com/uc?id=10h_5og14wbNHU-lapQaS1W6SBdzI7W6Z&export=download")

#---------------------------------------------------------------------------
#Figura 1
x_st_wage_before_nj <- 
  data$x_st_wage_before[data$d_nj == 1]
x_st_wage_before_pa <- 
  data$x_st_wage_before[data$d_pa == 1]

# Histograma - Pre Tratamiento
xbins <- list(start=4.20, end=5.60, size=0.1)

p <- plot_ly(alpha = 0.6) %>%
  add_histogram(x = x_st_wage_before_nj, 
                xbins = xbins,
                histnorm = "percent", 
                name = "Wage Before (New Jersey)") %>%
  add_histogram(x = x_st_wage_before_pa, 
                xbins = xbins,
                histnorm = "percent",
                name = "Wage Before (Pennsylvania)") %>%
  layout(barmode = "group", title = "February 1992",
         xaxis = list(tickvals=seq(4.25, 5.55, 0.1),
                      title = "Wage in $ per hour"),
         yaxis = list(range = c(0, 50)),
         margin = list(b = 100, 
                       l = 80, 
                       r = 80, 
                       t = 80, 
                       pad = 0, 
                       autoexpand = TRUE))
p

# Histograma Post-Tratamiento
x_st_wage_after_nj <- 
  data$x_st_wage_after[data$d_nj == 1]
x_st_wage_after_pa <- 
  data$x_st_wage_after[data$d_pa == 1]

xbins <- list(start=4.20,
              end=5.60,
              size=0.1)
p <- plot_ly(alpha = 0.6) %>%
  add_histogram(x = x_st_wage_after_nj, 
                xbins = xbins,
                histnorm = "percent", 
                name = "Wage After (New Jersey)") %>%
  add_histogram(x = x_st_wage_after_pa, 
                xbins = xbins,
                histnorm = "percent",
                , name = "Wage After (Pennsylvania)") %>%
  layout(barmode = "group", title = "November 1992",
         xaxis = list(tickvals=seq(4.25, 5.55, 0.1),
                      title = "Wage in $ per hour"),
         yaxis = list(range = c(0, 100)),
         margin = list(b = 100, 
                       l = 80, 
                       r = 80, 
                       t = 80, 
                       pad = 0, 
                       autoexpand = TRUE))
p

#--------------------------------------------------------------------------
# Tabla 3: Columnas 1-3, Row 1
# Fila 1: medias and SE
results <- data %>% group_by(d_nj) %>%
  dplyr::select(d_nj, y_ft_employment_before) %>%
  group_by(N = n(), add = TRUE) %>%
  summarize_all(funs(mean, var, na_sum = sum(is.na(.))), na.rm = TRUE) %>%
  mutate(n = N - na_sum) %>% 
  mutate(se = sqrt(var/n))

#Aggregar filas con diferencias
results <- bind_rows(results, results[2,]-results[1,])
results$group<- c("Control (Pennsylvania)", "Treatment (New Jersey)", "Difference")
kable(results, digits=2)

#Error estandar de las diferencias
diff_se <- sqrt(results$var[1]/results$n[1] + results$var[2]/results$n[2])
diff_se

# Fila 2: medias and SE
results <- data %>% group_by(d_nj) %>%
  dplyr::select(d_nj, y_ft_employment_after) %>%
  group_by(N = n(), add = TRUE) %>%
  summarize_all(funs(mean, var, na_sum = sum(is.na(.))), na.rm = TRUE) %>%
  mutate(n = N - na_sum) %>% 
  mutate(se = sqrt(var/n))

results <- bind_rows(results, results[2,]-results[1,])
results$group<- c("Control (Pennsylvania)", "Treatment (New Jersey)", "Difference")
kable(results, digits=2)
