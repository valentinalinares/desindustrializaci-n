library(tidyverse)
library(ggthemes)

# -----------------------------------------------------------------------------
# Consigna1: Evolución de la participación del Empleo industrial
# -----------------------------------------------------------------------------

options(scipen = 999)

datos_empleo <- read_csv("~/Downloads/M3_PC1/empleo_industrial.csv")
#view(datos_empleo)
datos_empleo <- datos_empleo  %>% 
  select(Anio, País, Regiones.economicas, Ocup_TOTAL_ECONOMIA, Ocup_INDUSTRIA) %>% 
  
  filter(Anio >= 1991,
         Anio <= 2018,
         Anio != 1999    # faltan datos de china para el 99'
  ) %>% 
  
  mutate(pp_empleo_industrial = Ocup_INDUSTRIA / Ocup_TOTAL_ECONOMIA)

datos_filtrados <- datos_empleo %>%
  filter(País %in% c("DEU", "ARG", "CHN", "MEX")) %>%
  arrange(País, Anio) 

datos_empleo_1991 <- datos_filtrados %>% 
  group_by(País) %>% 
  mutate(datos_empleo_1991 = pp_empleo_industrial[Anio==1991],
         indice = (pp_empleo_industrial / datos_empleo_1991) * 100 ) %>% 
  ungroup()

datos_empleo_1991 %>% 
  ggplot(aes(x = Anio, y = indice, color = País, group = País)) +
  
  geom_line(linewidth = 1.2, alpha = 0.9) +
  
  geom_point(size = 2.5, alpha = 0.7) +
  
  scale_x_continuous(breaks = seq(from = 1991, to = 2018, by = 1)) +
  
  labs(
    title = "Índices de participación del empleo industrial (1991 = 100)",
    subtitle = "Alemania, Argentina, China y México (1991-2018)",
    x = "",
    y = "",
    caption = "Fuente: Graña y Terranova (2022)"
  ) +
  
  theme_fivethirtyeight() +
  
  scale_color_tableau() +
  
  theme(
    legend.position = "bottom",
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(size = 12, color = "darkgrey"),
    axis.title = element_text(face = "bold"),
    panel.grid.minor = element_blank(),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )


# -----------------------------------------------------------------------------
# Consigna2: Gráfico de barras apiladas por región
# -----------------------------------------------------------------------------
library(tidyverse)
library(forcats)
library(scales)

datos_consigna2 <- datos_empleo %>%
  filter(Anio >= 1991 & Anio <= 2018 & Anio != 1999) %>%
  filter(!is.na(Regiones.economicas) & !is.na(Ocup_INDUSTRIA))

empleo_participacion_regional <- datos_consigna2 %>%
  group_by(Anio, Regiones.economicas) %>%
  summarise(
    Total_Ocup_Industria_Region = sum(Ocup_INDUSTRIA, na.rm = TRUE),
    .groups = 'drop'
  ) %>%
  group_by(Anio) %>%
  mutate(
    Total_Ocup_Industria_Anio_Muestra = sum(Total_Ocup_Industria_Region, na.rm = TRUE),
    Participacion_Region_En_Total_Industria = ifelse(Total_Ocup_Industria_Anio_Muestra > 0,
                                                     Total_Ocup_Industria_Region / Total_Ocup_Industria_Anio_Muestra,
                                                     0)
  ) %>%
  ungroup() %>%
  filter(Total_Ocup_Industria_Anio_Muestra > 0)

# reordenar las categorías para el apilamiento y la leyenda
empleo_participacion_regional <- empleo_participacion_regional %>%
  mutate(
    Regiones.economicas = fct_relevel(Regiones.economicas, "Latin American", "East Asia", "Developed")
  )

# etiquetas para el gráfico horizontal
empleo_con_etiquetas_horizontal <- empleo_participacion_regional %>%
  arrange(Anio, desc(Regiones.economicas)) %>%
  group_by(Anio) %>%
  mutate(
    posicion_label_x = cumsum(Participacion_Region_En_Total_Industria) - 0.5 * Participacion_Region_En_Total_Industria
  ) %>%
  ungroup()

paleta_final <- c(
  "Developed" = "#CC5500",      # 3er color: Naranja Quemado
  "East Asia" = "#6A8EAE",      # 2do color: Azul Acero
  "Latin American" = "#D4AF37"  # 1er color: Dorado Antiguo
)

grafico_definitivo <- ggplot(empleo_con_etiquetas_horizontal,
                             aes(x = Participacion_Region_En_Total_Industria,
                                 y = factor(Anio),
                                 fill = Regiones.economicas)) +
  # eliminar los espacios entre las barras de los años
  geom_col(position = "stack", width = 1) +
  # Etiquetas de texto (solo en el primer y último año)
  geom_text(data = . %>% filter(Anio == 1991 | Anio == 2018),
            aes(x = posicion_label_x, label = percent(Participacion_Region_En_Total_Industria, accuracy = 1)),
            color = "white",
            size = 3.5,
            fontface = "bold") +
  # paleta de colores
  scale_fill_manual(values = paleta_final) +
  # ejes
  scale_x_continuous(labels = percent_format(accuracy = 1L), expand = c(0, 0.01)) +
  scale_y_discrete(limits = rev) +
  
  # etiquetas
  labs(title = "Participación del Empleo Industrial 
       por Región Económica",
       subtitle = "Comparación del cambio entre 1991 y 2018",
       x = "Participación en el Empleo Industrial Total",
       y = "Año",
       fill = NULL) +
  
  # tema visual ligero
  theme_minimal(base_size = 14) +
  theme(
    plot.background = element_rect(fill = "grey92", color = "grey92"),
    panel.background = element_rect(fill = "grey92", color = "grey92"),
    panel.grid.major = element_line(color = "white", linewidth = 0.5),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    plot.title = element_text(color = "grey10", face = "bold", size = 18, hjust = 0.5),
    plot.subtitle = element_text(color = "grey30", size = 14, hjust = 0.5, margin = margin(b=10)),
    axis.title = element_text(color = "grey30", face = "bold"),
    axis.text = element_text(color = "grey30"),
    axis.text.x = element_text(angle = 0),
    legend.position = "bottom",
    legend.background = element_rect(fill = "grey92"),
    legend.text = element_text(color = "grey30", size = 12),
    legend.key = element_rect(fill = "grey92")
  )

print(grafico_definitivo)

# guardar el gráfico como un archivo de imagen con forma vertical
ggsave(
  "grafico_empleo_vertical.png", 
  plot = grafico_definitivo,
  width = 7,   # Ancho (menor)
  height = 11, # Altura (mayor) para asegurar la forma vertical
  units = "in",
  dpi = 300
)

