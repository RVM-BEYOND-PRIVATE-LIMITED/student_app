FROM node:22-alpine AS base
WORKDIR /app
RUN addgroup -S app && adduser -S app -G app
COPY package.json pnpm-workspace.yaml turbo.json ./
COPY apps/api/package.json apps/api/
COPY packages/openapi/package.json packages/openapi/
RUN corepack enable && corepack prepare pnpm@9.0.0 --activate && pnpm install --frozen-lockfile || pnpm install
COPY . .
RUN pnpm build
USER app
ENV NODE_ENV=production
EXPOSE 3000
# Single image, two processes: api (server.ts) and worker (worker.ts) via CMD override in Lightsail.
CMD ["node", "apps/api/dist/server.js"]
