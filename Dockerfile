# Updated version with cowsay
FROM rocker/rstudio:4.4.2

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# Switch to rstudio user
USER rstudio
WORKDIR /home/rstudio

# Copy renv configuration files
COPY --chown=rstudio:rstudio renv.lock renv.lock
COPY --chown=rstudio:rstudio .Rprofile .Rprofile
COPY --chown=rstudio:rstudio renv/activate.R renv/activate.R
COPY --chown=rstudio:rstudio renv/settings.json renv/settings.json

# Install renv and restore packages
RUN R -e "install.packages('renv', repos='https://cloud.r-project.org/')"
RUN R -e "renv::restore()"

# Copy test script
COPY --chown=rstudio:rstudio test.R test.R