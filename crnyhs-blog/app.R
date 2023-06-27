library(shiny)

# Sample project data
projects <- data.frame(
  Name = c("Restaurant List", "Reinsurance Contact List", "Gallagher List"),
  Description = c("The NY Restaurant List is a convenient tool to locate nearby dining options in close proximity to the NY office. This list is particularly valuable for various occasions, including celebrations and meetings with clients. This resource significantly minimizes the time and effort required when searching for a suitable restaurant. By providing a carefully curated selection of nearby dining establishments, individuals can swiftly access a range of options without the need for extensive research or browsing. Individuals can easily identify suitable restaurants that offer a desirable dining experience without having to venture far from their workplace. Whether it's a team celebration or an important client meeting, the Restaurant List provides a go-to guide for selecting a restaurant that meets the needs and preferences of the occasion, ensuring a seamless and enjoyable dining experience for all involved.",
                  "Specifically designed to streamline the process for reinsurers to find and access essential contact information for employment and other purposes. This comprehensive list comprises over 500 names and includes crucial details such as individuals' names, company affiliations, positions, and additional relevant information.",
                  "Brian and Alex are collaborating on the development of Gallagher's List, a web app tailored for Gallagher. This innovative platform will empower individuals to effortlessly connect with skilled professionals who match their specific requirements. By streamlining the app's interface, Brian and Alex aim to provide users with a seamless and user-friendly experience."),
  stringsAsFactors = FALSE
)

ui <- fluidPage(
  tags$head(
    tags$style(
      HTML(
        "
        body {
          background-color: #B3D1FF; /* Slightly lighter Lambent blue */
          color: #333333;
          font-family: Arial, sans-serif;
        }
        
        .container {
          display: flex;
          flex-direction: column;
          align-items: center;
          justify-content: center;
          height: 100vh;
        }

        .project-heading {
          margin-top: 50px;
          margin-bottom: 20px;
          text-align: center;
          font-weight: bold;
          font-size: 24px;
        }

        .search-bar {
          margin-bottom: 20px;
          text-align: center;
        }

        .table {
          width: 80%;
          border-collapse: collapse;
          margin-top: 20px;
        }

        .table th {
          background-color: #9AC2FF; /* Lambent blue */
          color: white;
          padding: 10px;
          font-weight: bold;
        }

        .table td {
          background-color: #D6E7FF; /* Lighter shade of Lambent blue */
          padding: 10px;
        }

        .table td a {
          text-decoration: none;
          color: #333333;
        }

        .table td a:hover {
          color: #9AC2FF; /* Lambent blue */
        }
        "
      )
    )
  ),
  titlePanel("Project List"),
  mainPanel(
    div(
      class = "container",
      div(
        class = "search-bar",
        textInput("searchInput", "Search", value = "")
      ),
      h3("Projects", class = "project-heading"),
      div(class = "table", tableOutput("projectTable"))
    )
  )
)

server <- function(input, output) {
  output$projectTable <- renderTable({
    keyword <- input$searchInput
    filtered_projects <- projects[grep(keyword, projects$Name, ignore.case = TRUE), ]
    filtered_projects
  })
  
  observeEvent(input$projectTable_rows_selected, {
    if (!is.null(input$projectTable_rows_selected)) {
      selected_project <- projects[input$projectTable_rows_selected, ]
      showModal(modalDialog(
        withTags({
          ui <- fluidPage(
            tags$a(href = selected_project$URL, target = "_blank", "Click here to open in a new window")
          )
          tags$head(tags$style(HTML(".modal-dialog { width: 80% !important; }")))
        }),
        tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "https://fonts.googleapis.com/css2?family=Caprisimo&display=swap")),
        tags$h1("Restaurant List", style = "font-family: 'Caprisimo', cursive; text-align: center;"),
        tags$p(selected_project$Description, style = "text-align: center; font-size: 16px;")
      ))
    }
  })
}

shinyApp(ui = ui, server = server)
