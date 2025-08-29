FROM pytorch/pytorch:2.7.1-cuda12.6-cudnn9-runtime

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        python3-dev \
        git \
        wget \
        libglib2.0-0 \
        libsm6 \
        libxrender1 \
        libxext6 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY pyproject.toml .
COPY README.md .
COPY src ./src
COPY model_cache /app/.boltz/

# Install dependencies and package in editable mode
RUN pip install --upgrade pip && \
    pip install -e .

# Set entrypoint for CLI usage (optional)
ENTRYPOINT ["boltz", "predict"]