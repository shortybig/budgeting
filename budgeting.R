loadNamespace("googlesheets4")
loadNamespace("tidyverse")


# extract -----------------------------------------------------------------
# currently using Tiller, but I'd like to eventually switch to using Plaid APIs
googlesheets4::gs4_auth(email = "jbrannock2018@gmail.com")

transactions <- 
  googlesheets4::read_sheet(
    ss = "https://docs.google.com/spreadsheets/d/1t2W19sLUmLwpT2L1ABKIltaA4n0mOPcTlKem7txuMtw",
    sheet = "Transactions"
    )

# transform ---------------------------------------------------------------

recategorizing <- 
  transactions |> 
  dplyr::rename(
    "subcategory" = "Category"
  ) |> 
  dplyr::mutate(
    subcategory = dplyr::case_when(
      grepl("lunchdrop", Description, ignore.case = TRUE) ~ "lunchdrop",
      TRUE ~ "unknown"
    )
  ) |> 
  dplyr::mutate(
    category = dplyr::case_when(
      subcategory %in% c("lunchdrop") ~ "food",
      TRUE ~ "other"
    )
  ) |> 
  dplyr::select(-c(Account, `Account #`, `Transaction ID`, `Account ID`, `Check Number`, `Date Added`, Month, Week)) |> 
  dplyr::mutate(
    Date = format(Date, format = "%Y-%m-%d")
  ) |>
  dplyr::arrange(desc(Date))

# load --------------------------------------------------------------------

googlesheets4::sheet_write(
  recategorizing, 
  ss = "https://docs.google.com/spreadsheets/d/1t2W19sLUmLwpT2L1ABKIltaA4n0mOPcTlKem7txuMtw",
  sheet = "fixed"
)
