# ============================================================
# 01_preparacion_datos.R
# Proyecto Micro I - Gig Economy RD
# Objetivo: importar, limpiar y preparar los datos de encuesta
# ============================================================

rm(list = ls())

library(readxl)
library(tidyverse)
library(janitor)
library(skimr)
library(stargazer)
library(lmtest)
library(sandwich)

datos_raw <- read_excel("datos/encuesta_plataformas.xlsx")

datos <- datos_raw %>%
  clean_names()

names(datos)

datos <- datos %>%
  mutate(
    horas_semanales = case_when(
      a3_en_promedio_cuantas_horas_a_la_semana_dedica_a_esta_actividad == "Menos de 10 horas" ~ 5,
      a3_en_promedio_cuantas_horas_a_la_semana_dedica_a_esta_actividad == "10-20 horas" ~ 15,
      a3_en_promedio_cuantas_horas_a_la_semana_dedica_a_esta_actividad == "21-30 horas" ~ 25,
      a3_en_promedio_cuantas_horas_a_la_semana_dedica_a_esta_actividad == "31-40 horas" ~ 35,
      a3_en_promedio_cuantas_horas_a_la_semana_dedica_a_esta_actividad == "Más de 40 horas" ~ 45,
      TRUE ~ NA_real_
    )
  )

summary(datos$horas_semanales)
table(datos$horas_semanales, useNA = "ifany")

datos <- datos %>%
  mutate(
    ingreso_principal = ifelse(
      a4_esta_actividad_es_actualmente_su_principal_fuente_de_ingreso %in% c(
        "Sí, es mi único ingreso",
        "Sí, es mi ingreso principal"
      ),
      1, 0
    )
  )
table(datos$ingreso_principal, useNA = "ifany")

datos <- datos %>%
  mutate(
    sector = a1_en_que_tipo_de_trabajo_en_plataforma_participa_principalmente,
    educacion = e3_nivel_educativo_mas_alto_alcanzado,
    edad = e2_edad_anos_38,
    genero = e1_genero,
    ciudad = e4_en_que_ciudad_vive
  )

table(datos$sector, useNA = "ifany")
table(datos$educacion, useNA = "ifany")
table(datos$edad, useNA = "ifany")

datos <- datos %>%
  mutate(
    respuesta_bonos = case_when(
      c1_ante_bonos_por_metas_usted == "Aumenta significativamente sus horas" ~ 3,
      c1_ante_bonos_por_metas_usted == "Aumenta un poco sus horas" ~ 2,
      c1_ante_bonos_por_metas_usted == "No cambia sus horas" ~ 1,
      c1_ante_bonos_por_metas_usted == "Disminuye sus horas" ~ 0,
      TRUE ~ NA_real_
    ),
    respuesta_salario = case_when(
      c2_si_el_pago_subiera_un_20_percent_usted == "Trabajaría muchas más horas" ~ 3,
      c2_si_el_pago_subiera_un_20_percent_usted == "Trabajaría algunas horas más" ~ 2,
      c2_si_el_pago_subiera_un_20_percent_usted == "Trabajaría las mismas horas" ~ 1,
      c2_si_el_pago_subiera_un_20_percent_usted == "Trabajaría menos horas" ~ 0,
      TRUE ~ NA_real_
    )
  )

table(datos$respuesta_bonos, useNA = "ifany")
table(datos$respuesta_salario, useNA = "ifany")

datos <- datos %>%
  mutate(
    periodo = case_when(
      a2_en_que_ano_comenzo_a_trabajar_en_esta_plataforma %in% c("2019 o antes", "2020", "2021") ~ 0,
      a2_en_que_ano_comenzo_a_trabajar_en_esta_plataforma %in% c("2022", "2023", "2024", "2025") ~ 1,
      TRUE ~ NA_real_
    )
  )

table(datos$periodo, useNA = "ifany")

datos <- datos %>%
  mutate(
    ingreso_principal = factor(ingreso_principal),
    sector = factor(sector),
    educacion = factor(educacion),
    edad = factor(edad),
    genero = factor(genero),
    periodo = factor(periodo)
  )

write_csv(datos, "datos/encuesta_limpia.csv")
