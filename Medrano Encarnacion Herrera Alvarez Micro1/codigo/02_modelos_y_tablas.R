# ============================================================
# 02_modelos_y_tablas.R
# Proyecto Micro I - Gig Economy RD
# Objetivo: estimar modelos y exportar tablas/figuras
# ============================================================

rm(list = ls())

library(tidyverse)
library(stargazer)
library(lmtest)
library(sandwich)

datos <- read_csv("datos/encuesta_limpia.csv", show_col_types = FALSE)
dim(datos)
dir.create("resultados", showWarnings = FALSE)

# ------------------------------------------------------------
# Grafico 1: Distribucion de horas semanales trabajadas
# ------------------------------------------------------------

g_horas <- ggplot(datos, aes(x = factor(horas_semanales))) +
  geom_bar(fill = "steelblue") +
  labs(
    title = "Distribución de horas semanales trabajadas",
    x = "Horas trabajadas por semana",
    y = "Número de personas"
  ) +
  theme_minimal()

ggsave(
  filename = "resultados/figura_1_horas_semanales.png",
  plot = g_horas,
  width = 6,
  height = 6,
  dpi=300
)

# ------------------------------------------------------------
# Grafico 2: Horas semanales por ingreso principal
# ------------------------------------------------------------

grafico_ingreso <- ggplot(datos, aes(x=factor(ingreso_principal),
                                     y=horas_semanales)) +
  geom_boxplot() +
  labs(
    title = "Horas trabajadas según si la plataforma es ingreso principal",
    x= "Ingreso principal (1=sí, 0=no)",
    y= "Horas semanales trabajadas"
  )

ggsave(
  filename = "resultados/figura_2_horas_vs_ingreso_principal.png",
  plot = grafico_ingreso,
  width=6,
  height=6,
  dpi=300
)

# ------------------------------------------------------------
# Prueba de diferencias de medias (t-test)
# ------------------------------------------------------------

t_test_ingreso <- t.test(
  horas_semanales ~ ingreso_principal,
  data = datos
)

t_test_ingreso


modelo1 <- lm(
  horas_semanales ~ ingreso_principal + sector + educacion + edad,
  data = datos
)

summary(modelo1)

modelo2 <- glm(
  ingreso_principal ~ horas_semanales + sector + educacion + edad,
  data = datos,
  family = binomial(link = "logit")
)

summary(modelo2)

modelo4 <- lm(
  horas_semanales ~ periodo + sector + educacion + edad,
  data = datos
)

summary(modelo4)

# ------------------------------------------------------------
# Modelo 3: Respuesta a incentivos (bonos vs salario)
# ------------------------------------------------------------

mean(datos$respuesta_bonos, na.rm = TRUE)
mean(datos$respuesta_salario, na.rm = TRUE)

t_test_incentivos <- t.test(
  datos$respuesta_salario,
  datos$respuesta_bonos,
  paired = TRUE
)

t_test_incentivos

stargazer(
  modelo1,
  type = "html",
  out = "resultados/tabla_modelo1.doc",
  title = "Tabla 1. Modelo 1: Determinantes de las horas trabajadas",
  digits = 3
)

stargazer(
  modelo2,
  type = "html",
  out = "resultados/tabla_modelo2.doc",
  title = "Tabla 2. Modelo 2 (Logit): Probabilidad de ingreso principal",
  digits = 3
)

stargazer(
  modelo4,
  type = "html",
  out = "resultados/tabla_modelo4.doc",
  title = "Tabla 3. Modelo 4: Diferencias por periodo de inicio",
  digits = 3
)



