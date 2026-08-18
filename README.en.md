<div align="right">

[Srpski](README.md) · **English**

</div>

# Oracle + APEX + ORDS in Docker

A local environment for APEX development - one command, no database installed on your own machine.

```bash
docker compose up -d
```

In five minutes you have Oracle Database 23ai Free, APEX and ORDS working together.

---

## Why

Setting up Oracle and APEX on your own machine is half a day's work, and the result is something you can't remove without a trace. This way everything lives in containers: break it, delete it, bring it back up, clean.

Handy when you work on two projects with different versions, or when you need to try something quickly without touching a development database.

## What comes up

| Service | Port | What it is |
|---|---|---|
| **Oracle Database 23ai Free** | 1521 | The database, PDB `FREEPDB1` |
| **EM Express** | 5500 | Database monitoring in the browser |
| **ORDS + APEX** | 8080 | APEX and REST services |

## Getting started

```bash
git clone https://github.com/Cvoki/oracle-apex-docker.git
cd oracle-apex-docker

cp .env.example .env      # change the passwords!
docker compose up -d

# the first startup takes 3–5 min, follow it with:
docker compose logs -f oracle
```

It's ready when the log says `DATABASE IS READY TO USE!`.

> **Note:** Oracle's images require signing in to `container-registry.oracle.com` and accepting the terms. Do it once with `docker login container-registry.oracle.com`.

## First steps

**1. Create the APEX workspace** (once, after the first startup):

```bash
docker cp scripts/apex-workspace.sql oracle-db:/tmp/
docker exec -it oracle-db sqlplus / as sysdba @/tmp/apex-workspace.sql
```

**2. Open APEX:**

```
http://localhost:8080/ords/
```

| Field | Value |
|---|---|
| Workspace | `RAZVOJ` |
| User | `ADMIN` |
| Password | `Apex_2026!` |

**3. Connect from SQL Developer or SQLcl:**

```
Host:     localhost
Port:     1521
Service:  FREEPDB1
User:     razvoj
Password: Razvoj_2026
```

## Day-to-day

```bash
docker compose stop           # stop, data stays
docker compose start          # resume
docker compose logs -f ords   # ORDS logs

# SQL right away, no client needed:
docker exec -it oracle-db sqlplus razvoj/Razvoj_2026@FREEPDB1
```

**Wipe everything, data included:**

```bash
docker compose down -v
```

## Adding your own scripts

Everything in the `sql/` folder runs **only when the database is first created** - that's how Oracle's image works. Good for users and an initial schema.

For scripts you need to run repeatedly:

```bash
docker exec -i oracle-db sqlplus razvoj/Razvoj_2026@FREEPDB1 < my_script.sql
```

## When something breaks

**The database won't start, the log stops at "ORA-27104"**
Docker needs more memory. In Docker Desktop → Settings → Resources, raise it to at least 4 GB.

**ORDS returns 503**
The database isn't ready yet. Run `docker compose logs oracle` and wait for `DATABASE IS READY TO USE!`.

**Non-ASCII characters show as question marks**
Check that `ORACLE_CHARACTERSET: AL32UTF8` was set **before the first startup**. If it wasn't - `docker compose down -v` and start over, since the character set is fixed when the database is created.

**Port 1521 is taken**
You already have an Oracle running. Change the mapping in `docker-compose.yml` to `"1522:1521"`.

## License

MIT for the configuration and scripts in this repository. Oracle's images carry their own terms - the Free edition is free for both development and production, within resource limits.

---

<sub><a href="https://github.com/Cvoki">Luka Cvoro</a> - <a href="mailto:lukac95@gmail.com">lukac95@gmail.com</a></sub>
