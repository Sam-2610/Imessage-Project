# Monolith: Vite frontend + Express API. Build from repo root.

# --- Stage 1: build the SPA (Vite) ---
# Produces static HTML/JS/CSS under frontend/dist.
FROM node:22-bookworm-slim AS frontend-build
WORKDIR /app/frontend
COPY frontend/package.json frontend/package-lock.json ./
RUN npm install --no-audit --no-fund --legacy-peer-deps
COPY frontend/ ./
# Empty = browser calls /api on the same host as the page.
ENV VITE_API_URL=
# Public Clerk key is embedded in client JS.
ARG VITE_CLERK_PUBLISHABLE_KEY
ENV VITE_CLERK_PUBLISHABLE_KEY=$VITE_CLERK_PUBLISHABLE_KEY
RUN npm run build

# --- Stage 2: build the API bundle ---
# This backend is ESM JavaScript, so npm run build copies src/ to dist/.
FROM node:22-bookworm-slim AS backend-build
WORKDIR /app
COPY backend/package.json backend/package-lock.json ./
RUN npm install --no-audit --no-fund
COPY backend/ ./
RUN npm run build