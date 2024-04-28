loadNamespace("googlesheets4")
loadNamespace("tidyverse")


# extract -----------------------------------------------------------------

googlesheets4::gs4_auth(email = "jbrannock2018@gmail.com")

transactions <- 
  googlesheets4::read_sheet(
    ss = "https://docs.google.com/spreadsheets/d/1t2W19sLUmLwpT2L1ABKIltaA4n0mOPcTlKem7txuMtw",
    sheet = "Transactions"
    )

# transform ---------------------------------------------------------------

recategorizing <- 
  transactions |> 
  dplyr::mutate(
    Category = dplyr::case_when(
      grepl("lunchdrop", Description, ignore.case = TRUE) ~ "lunch"
    )
  )

# load --------------------------------------------------------------------

googlesheets4::sheet_write(
  recategorizing, 
  ss = "https://docs.google.com/spreadsheets/d/1t2W19sLUmLwpT2L1ABKIltaA4n0mOPcTlKem7txuMtw",
  sheet = "fixed"
)
