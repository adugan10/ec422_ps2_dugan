# EC 422 - Problem Set 2
# Aidan Dugan
# Parts 3-5: data, wrangling, and visualizations
# Run from the ec422_ps2_dugan RStudio Project.

library(tidyverse)

# PART 3: READ IN DATA ---------------------------------------------------------
# Professor Piger's Oct. 16 email replaces tq_get() with a provided RDS file.
# Save the email attachment as data/unemp_raw.rds inside this RStudio project.
# Do not rename the file or try to download it using tq_get().
unemp_raw <- read_rds("data/unemp_raw.rds")
head(unemp_raw)

# PART 4: WRANGLE DATA ---------------------------------------------------------
# 4.1: Give the unemployment rates and regions informative names.
unemp <- unemp_raw |>
  rename(unemployment_rate = price) |>
  mutate(
    region = case_when(
      symbol == "UNRATE" ~ "United States",
      symbol == "ORUR"   ~ "Oregon",
      symbol == "CAUR"   ~ "California",
      symbol == "TXUR"   ~ "Texas",
      symbol == "NYUR"   ~ "New York"
    )
  )

# 4.2(a): Create a row for any missing month (including October 2025 if FRED
# omits it entirely) before applying the assignment's replacement rule.
unemp <- unemp |>
  group_by(region, symbol) |>
  complete(date = seq.Date(min(date), max(date), by = "month")) |>
  ungroup()

# Replace the October 2025 rate with the September 2025 rate in each region.
unemp <- unemp |>
  arrange(region, date) |>
  group_by(region) |>
  mutate(
    unemployment_rate = replace(
      unemployment_rate,
      date == as.Date("2025-10-01"),
      unemployment_rate[date == as.Date("2025-09-01")]
    )
  ) |>
  ungroup()

# 4.2(b): Month-over-month change in each region's unemployment rate.
# Rate changes are in percentage points, not percent growth rates.
unemp <- unemp |>
  arrange(region, date) |>
  group_by(region) |>
  mutate(
    unemployment_rate_change = unemployment_rate - lag(unemployment_rate)
  ) |>
  ungroup()

# 4.2(c): Restrict to January 2015 onward.
unemp_recent <- unemp |>
  filter(date >= as.Date("2015-01-01"))

# 4.2(d): Summary statistics by region over the full and recent samples.
unemp_summary <- unemp |>
  group_by(region) |>
  summarize(
    mean_rate = mean(unemployment_rate, na.rm = TRUE),
    min_rate = min(unemployment_rate, na.rm = TRUE),
    max_rate = max(unemployment_rate, na.rm = TRUE),
    .groups = "drop"
  )

unemp_recent_summary <- unemp_recent |>
  group_by(region) |>
  summarize(
    mean_rate = mean(unemployment_rate, na.rm = TRUE),
    min_rate = min(unemployment_rate, na.rm = TRUE),
    max_rate = max(unemployment_rate, na.rm = TRUE),
    .groups = "drop"
  )

# 4.3: Five largest monthly increases and decreases, INCLUDING ties.
unemp_top_increases <- unemp |>
  filter(!is.na(unemployment_rate_change)) |>
  slice_max(order_by = unemployment_rate_change, n = 5, with_ties = TRUE) |>
  select(region, date, unemployment_rate_change, unemployment_rate)

unemp_top_decreases <- unemp |>
  filter(!is.na(unemployment_rate_change)) |>
  slice_min(order_by = unemployment_rate_change, n = 5, with_ties = TRUE) |>
  select(region, date, unemployment_rate_change, unemployment_rate)

# 4.4: Same extremes, excluding every observation during 2020.
unemp_no_covid <- unemp |>
  filter(format(date, "%Y") != "2020")

unemp_top_increases_no_covid <- unemp_no_covid |>
  filter(!is.na(unemployment_rate_change)) |>
  slice_max(order_by = unemployment_rate_change, n = 5, with_ties = TRUE) |>
  select(region, date, unemployment_rate_change, unemployment_rate)

unemp_top_decreases_no_covid <- unemp_no_covid |>
  filter(!is.na(unemployment_rate_change)) |>
  slice_min(order_by = unemployment_rate_change, n = 5, with_ties = TRUE) |>
  select(region, date, unemployment_rate_change, unemployment_rate)

# Inspect results in RStudio.
print(unemp_summary)
print(unemp_recent_summary)
print(unemp_top_increases)
print(unemp_top_decreases)
print(unemp_top_increases_no_covid)
print(unemp_top_decreases_no_covid)

# PART 5: VISUALIZE DATA ------------------------------------------------------
# 5.1: One line per region in a single plot.
plot_5_1 <- ggplot(unemp, aes(x = date, y = unemployment_rate, color = region)) +
  geom_line(linewidth = 0.55, na.rm = TRUE) +
  labs(
    title = "Monthly unemployment rates: U.S. and four states",
    x = "Date",
    y = "Unemployment rate (%)",
    color = "Region"
  ) +
  theme_minimal()

# 5.2: One line chart in each region's panel.
plot_5_2 <- ggplot(unemp, aes(x = date, y = unemployment_rate)) +
  geom_line(color = "steelblue4", linewidth = 0.55, na.rm = TRUE) +
  facet_wrap(~ region) +
  labs(
    title = "Monthly unemployment rates by region",
    x = "Date",
    y = "Unemployment rate (%)"
  ) +
  theme_minimal()

# 5.3: Mean unemployment rate by region, ordered low to high.
plot_5_3 <- ggplot(
  unemp_summary,
  aes(x = fct_reorder(region, mean_rate), y = mean_rate)
) +
  geom_col(fill = "steelblue4") +
  labs(
    title = "Average unemployment rate by region, full sample",
    x = "Region (lowest to highest average)",
    y = "Mean unemployment rate (%)"
  ) +
  theme_minimal()

# 5.4: Original plot: month-to-month volatility for each region.
plot_5_4 <- ggplot(
  unemp |> filter(!is.na(unemployment_rate_change)),
  aes(x = region, y = abs(unemployment_rate_change))
) +
  geom_boxplot(fill = "skyblue3", outlier.alpha = 0.45) +
  labs(
    title = "Magnitude of monthly unemployment changes by region",
    x = "Region",
    y = "Absolute month-over-month change (percentage points)"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 20, hjust = 1))

print(plot_5_1)
print(plot_5_2)
print(plot_5_3)
print(plot_5_4)
