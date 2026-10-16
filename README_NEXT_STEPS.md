# EC 422 Problem Set 2 — DO THIS IN ORDER (Oct 16 FRED workaround)

**Due Friday, Oct 16, 2026 at 11:59 PM.** These are draft source files; you must run, review, and render them yourself.

**IMPORTANT:** This ZIP does **not** include `unemp_raw.rds`. Download that exact attachment from Professor Piger's **“Issues with tq_get”** email first. The `.R` script and `.qmd` in this updated ZIP already use his new `read_rds()` instructions. They do not call `tq_get()`.

R code is entered into RStudio's **Console**; `git` commands into **Terminal**. Press Return after each command.

## Start here

1. **Unzip** the updated ZIP. Open `ec422_ps2_dugan/ec422_ps2_dugan.Rproj` in RStudio.
2. **Save the emailed attachment** `unemp_raw.rds` inside the project's `data` folder. Exact location: `ec422_ps2_dugan/data/unemp_raw.rds`. The `data` folder already exists in the ZIP. Do not put the file next to the `.Rproj`, and do not leave it in Downloads.
3. In the **Console**, check the file location:

   ```r
   file.exists("data/unemp_raw.rds")
   ```

   It must return `TRUE`. If it says `FALSE`, stop and fix the file location before continuing. You can also use `getwd()` to see the folder RStudio is running in.
4. In the **Console**, install packages (skip if already installed):

   ```r
   install.packages(c("tidyverse", "knitr"))
   ```

   `tidyquant` is no longer required.

## GitHub and real project checkpoints

5. In the **Terminal**, create Git if not already initialized:

   ```bash
   git init
   git add .gitignore ec422_ps2_dugan.Rproj README_NEXT_STEPS.md data/.gitkeep
   git commit -m "Initialize EC422 project"
   ```

   This is **commit 1** for project setup (skip it if already committed).
6. Go to github.com, create a **new public** repo named `ec422_ps2_dugan`, leaving the README/.gitignore/license options **unchecked**. Copy its HTTPS URL. In the **Terminal** run (substitute your username or paste your own URL):

   ```bash
   git remote add origin https://github.com/YOUR_USERNAME/ec422_ps2_dugan.git
   git branch -M main
   git push -u origin main
   ```

   Do not repeat `git remote add origin` if you previously connected this project. GitHub may require authentication with your personal access token.
7. Once you've put the professor's RDS attachment in `data/` and `file.exists(...)` returns `TRUE`, commit that **actual supplied data**:

   ```bash
   git add data/unemp_raw.rds
   git commit -m "Add professor-provided FRED dataset"
   git push
   ```

   **Commit 2** — data import milestone. Only do this if the file really exists and you have permission to publish it as part of the assignment.
8. In RStudio open `ps2_script_dugan.R` and click **Source**. It should complete Parts 3–5 (six summary/extremes data objects and four plots). Inspect errors and results, and save any genuine corrections. Then:

   ```bash
   git add ps2_script_dugan.R
   git commit -m "Complete and check unemployment analysis"
   git push
   ```

   **Commit 3** — checked R analysis.
9. Open `ps2_writeup_dugan.qmd` in RStudio. Change `YOUR_GITHUB_USERNAME` to your actual username and edit the Reflection to truthfully describe what you personally did. Save (Cmd+S). Then:

   ```bash
   git add ps2_writeup_dugan.qmd
   git commit -m "Finish Quarto writeup and reflection"
   git push
   ```

   **Commit 4** — edited report.
10. With `.qmd` open, click **Render**. If it errors, check whether `file.exists("data/unemp_raw.rds")` is `TRUE`; also check missing packages and your project's active working directory. When rendering succeeds, open `ps2_writeup_dugan.html` and confirm the **four tables**, **four graphs**, and reflection. Then:

    ```bash
    git add ps2_writeup_dugan.html
    git commit -m "Render and verify final HTML report"
    git push
    git log --oneline
    git status
    ```

    **Commit 5** — finished rendered report. If `git status` still shows genuinely changed files, inspect and commit them as necessary; do not fabricate commits.

**Note:** Your professor requires **at least five meaningful incremental commits over more than one sitting**. The commands above correspond to real milestones, but doing everything in one sitting may still cost points. Never create fake or empty commits to simulate earlier work.

## Submit to Canvas

11. On github.com, open your public `ec422_ps2_dugan` repository, confirm the final R, QMD, HTML, and data files are present and check the commit history. The last versions must match what you submit to Canvas.
12. On Canvas, upload **exactly these three submission files** from the project folder:
    - `ps2_script_dugan.R`
    - `ps2_writeup_dugan.qmd`
    - `ps2_writeup_dugan.html` (**must be created by Render**)

    Click **Submit Assignment** and confirm that Canvas lists all three files.

## Already started your project?

**Do not make a second GitHub repository or run `git init` / `git remote add origin` again.** Put the emailed RDS file inside your existing project's `data` folder. If you already edited the original R/QMD files, preserve your changes and only replace the old `tq_get()` loading code in **both** files with:

```r
library(tidyverse)
unemp_raw <- read_rds("data/unemp_raw.rds")
head(unemp_raw)
```

Continue with your existing real Git history and render your report.
