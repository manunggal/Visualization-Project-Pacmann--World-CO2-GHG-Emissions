library(shiny)
library(bs4Dash)
library(ggplot2)
library(tidyverse)
library(paletteer)
library(DT)
library(knitr)
library(markdown)
library(glue)
library(plotly)
source("plotting_function.r")


server = function(input, output) {
  
  
  # Filter selected countries from dropdown menu
  data_to_plot = reactive({
    req(input$select_data)
    data %>%
      filter(country %in% input$select_data)
    
  })
  
  # Filter selected countries from dropdown menu
  data_ghg_to_plot = reactive({
    req(input$select_data)
    data_ghg %>%
      filter(country %in% input$select_data) %>% 
      filter(!sector %in% c('Total excluding LUCF', 'Total including LUCF'))
  })
  
  # plotfunction input(data, data_x, data_y, line/fill_colour,
  #                    xlabel, ylabel,
  #                    title, subtitle, caption)
  
  # plot annual emission
  output$annual = renderPlotly({
    
    ggplotly(
      plot_linechart(data_to_plot(), data_x = data_to_plot()$year, data_y = data_to_plot()$co2, line_colour = data_to_plot()$country, 
                     xlabel = 'Year', ylabel = 'Annual CO2 Emission (million tonnes)', 
                     caption = 'CO2 emissions from fossil fuels & industry. Land use change is not included')
    ) 
    
  })
  
  # plot accumulative emission
  output$cumulative = renderPlotly({
    
    ggplotly(
      plot_linechart(data_to_plot(), data_x = data_to_plot()$year, data_y = data_to_plot()$cumulative_co2, line_colour = data_to_plot()$country,
                     xlabel = 'Year', ylabel = 'Cumulative CO2 Emission (million tonnes)',
                     caption = 'Represents the total sum of CO2 emissions produced from fossil fuel and cement production only')
    )

  })
  
  # plot per capita CO2 emission
  output$percapita = renderPlotly({
    
    ggplotly(
      plot_linechart(data_to_plot(), data_x = data_to_plot()$year, data_y = data_to_plot()$co2_per_capita, line_colour = data_to_plot()$country, 
                     xlabel = 'Year', ylabel = 'Annual CO2 Emission (tonnes per person)', 
                     caption = 'CO2 emissions from fossil fuels & industry. Land use change is not included')
    )
    
    
  })
  
  # plot per gdp co2 emission
  output$pergdp = renderPlotly({
    
    ggplotly(
      plot_linechart(data_to_plot(), data_x = data_to_plot()$year, data_y = data_to_plot()$co2_per_gdp, line_colour = data_to_plot()$country, 
                     xlabel = 'Year', ylabel = 'Annual CO2 Emission (kG per dollar of GDP)', 
                     caption = 'Production-based CO2 emissions are based on territorial emissions, which do not account for emissions embedded in traded goods')
    )
    
  })
  
  # plot total ghg
  output$total_ghg = renderPlotly({
    
    ggplotly(
      plot_linechart(data_to_plot(), data_x = data_to_plot()$year, data_y = data_to_plot()$total_ghg, line_colour = data_to_plot()$country, 
                     xlabel = 'Year', ylabel = 'Million tonnes of CO2-equivalents', 
                     caption = 'Iincluding land-use change and forestry') + xlim(1990, 2019)
    )
    
  })
  
  # plot ghg per capita
  output$ghg_per_capita = renderPlotly({
    
    ggplotly(
      plot_linechart(data_to_plot(), data_x = data_to_plot()$year, data_y = data_to_plot()$ghg_per_capita, line_colour = data_to_plot()$country, 
                     xlabel = 'Year', ylabel = 'Tonnes of CO2-equivalents per capita', 
                     caption = 'Iincluding land-use change and forestry') + xlim(1990, 2019)
    )
    
    
  })
  
  # plot ghg per sector
  output$ghg_per_sector = renderPlotly({
    
    ggplotly(
      plot_barchart(data_ghg_to_plot(), data_x = data_ghg_to_plot()$sector, data_y = eval(parse(text=glue('data_ghg_to_plot()$`{input$ghg_year}`'))),
                    Country = data_ghg_to_plot()$country, xlabel = 'Sector', ylabel = 'MtCO2e')
    )
   

    
  })
  
  
  # plot primary_energy_consumption
  output$primary_energy_consumption = renderPlotly({
    
    ggplotly(
      plot_linechart(data_to_plot(), data_x = data_to_plot()$year, data_y = data_to_plot()$primary_energy_consumption, line_colour = data_to_plot()$country, 
                     xlabel = 'Year', ylabel = 'Terawatt-hours per year', 
                     caption = '') + xlim(1965, 2020)
    )
    
    
  })
  
  # plot co2_per_unit_energy
  output$co2_per_unit_energy = renderPlotly({
    
    ggplotly(
      plot_linechart(data_to_plot(), data_x = data_to_plot()$year, data_y = data_to_plot()$co2_per_unit_energy, line_colour = data_to_plot()$country, 
                     xlabel = 'Year', ylabel = 'kilograms per kilowatt-hour', 
                     caption = 'Production-based emissions are based on territorial emissions, which do not account for emissions embedded in traded goods') + xlim(1965, 2020)
    )
    
    
  })
  
  # plot energy_per_capita
  output$energy_per_capita = renderPlotly({
    
    ggplotly(
      plot_linechart(data_to_plot(), data_x = data_to_plot()$year, data_y = data_to_plot()$energy_per_capita, line_colour = data_to_plot()$country, 
                     xlabel = 'Year', ylabel = 'kilowatt-hours per person per year', 
                     caption = '') + xlim(1965, 2020)
    )
    
    
  })
  
  # plot energy_per_gdp
  output$energy_per_gdp = renderPlotly({
    
    ggplotly(
      plot_linechart(data_to_plot(), data_x = data_to_plot()$year, data_y = data_to_plot()$energy_per_gdp, line_colour = data_to_plot()$country, 
                     xlabel = 'Year', ylabel = 'kilowatt-hours per international-$', 
                     caption = '') + xlim(1965, 2020)
    )
    
  })
  
}