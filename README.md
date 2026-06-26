# teto-toys-infrastructure

Shared infrastructure layer for the teto-toys project. Currently hosts **Redis** for distributed refresh-token storage across all three backends.

## Quick Start

```bash
# 1. Copy and fill in your env vars
cp .env.example .env

# 2. Start Redis
docker compose up -d

# 3. Verify
docker compose logs redis
```

Redis will be available at `127.0.0.1:6379` (local dev only — not exposed on a public interface).

---

## How Each Backend Connects

Add these variables to each backend's `.env` file:

```
REDIS_HOST=127.0.0.1
REDIS_PORT=6379
REDIS_PASSWORD=YourStrongPasswordHere
```

| Backend | Library | Connection |
|---|---|---|
| Node.js (`teto-toys-backend`) | `ioredis` | `new Redis({ host, port, password })` — single global instance in `server.js` |
| Flask (`teto-toys-backend-flask`) | `redis-py` | `redis.ConnectionPool(...)` — passed to `redis.Redis()` in `app.py` |
| ASP.NET Core (`TatoToys.Api`) | `StackExchange.Redis` | `ConnectionMultiplexer.Connect(...)` — singleton in `Program.cs` |

---

## Security Decisions

| Decision | Reason |
|---|---|
| `--requirepass` enforced | Protects against SSRF attacks even inside Docker network |
| Port bound to `127.0.0.1` only | Redis never reachable from external network |
| `FLUSHALL`, `FLUSHDB`, `KEYS` disabled | Prevents accidental data wipe and blocking operations |
| `allkeys-lru` eviction | Safe fallback if memory fills — evicts least-recently-used keys |
| AOF persistence (`--appendonly yes`) | Tokens survive Redis restarts; no re-login required |
| Named volume `/data` | Data persists across container rebuilds |

---

## Refresh Token TTL

All backends store refresh tokens with a **7-day TTL** (604800 seconds).  
Keys expire automatically — no manual cleanup needed.
