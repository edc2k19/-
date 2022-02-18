# Builder stage
FROM node:17-alpine AS builder
WORKDIR /usr/src/fw-rebirth

COPY package*.json ./
COPY tsconfig*.json ./

COPY ./src ./src
COPY ./scripts ./scripts

RUN npm ci --quiet && npm run build

# Production stage
FROM node:17-alpine
WORKDIR /usr/src/fw-rebirth

ENV NODE_ENV=production

COPY package*.json ./
COPY LICENSE.txt ./
RUN npm ci --quiet --only=production

COPY --from=builder /usr/src/fw-rebirth/dist ./dist
COPY ./scripts ./scripts

CMD ["npm", "start"]
