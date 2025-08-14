library(httr2)
library(jsonlite)
library(tidyverse)
req = request("https://statsbank.statsghana.gov.gh:443/api/v1/en/")

# req_update = 
#   req |> 
#   req_url_path_append("PHC%202021%20StatsBank") |> 
#   req_url_path_append("Water%20and%20Sanitation") |> 
#   req_url_path_append("defaecate_table.px") |> 
#   req_perform()

req_update =
  req |>
  req_url_path_append("PHC%202021%20StatsBank") |>
  req_url_path_append("Water%20and%20Sanitation") |>
  req_url_path_append("defaecate_table.px") 

query = list(
  query = list(
    list(
      code = "Defaecatepoint",
      selection = list(filter="item", values=list("Defaecation point"))
    ),
    list(
      code = "Geographic_Area",
      selection = list(filter="all", values=list("*"))
    )
  ),
  response = list(
    format = "csv"
  )
)

resp = req_update |> 
  req_body_json(query) |> 
  req_perform()

# resp |> 
#   resp_body_json() |> 
#   toJSON() 
# 
# d = 
#   resp |> 
#   resp_body_json()
# 
# fn = function(x){
#   c(x$key[[2]], x$values[[1]])
# }
# 
# 
# dd = lapply(d$data, fn)
# df = do.call(rbind, dd) |> 
#   as.data.frame() 
# colnames(df) = c("geographic_area", "n_households")

resp |> 
  resp_body_raw() |> 
  readr::read_csv() |> 
  select(-1) |> 
  tidyr::pivot_longer(everything(), names_to = "Geographic area", values_to = "hh") |> 
  View()
