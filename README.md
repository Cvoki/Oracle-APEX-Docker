<div align="right">

**Srpski** · [English](README.en.md)

</div>

# Oracle + APEX + ORDS u Docker-u

Lokalno okruženje za razvoj APEX aplikacija — jednom komandom, bez instaliranja baze na svoj računar.

```bash
docker compose up -d
```

Za pet minuta imaš Oracle Database 23ai Free, APEX i ORDS koji rade zajedno.

---

## Zašto

Podešavanje Oracle baze i APEX-a na svom računaru je posao od pola dana, a rezultat je nešto što ne možeš da obrišeš bez traga. Ovako sve stoji u kontejnerima: pokvariš — obrišeš, digneš ponovo, čisto.

Korisno i kad radiš na dva projekta sa različitim verzijama, ili kad treba nešto brzo probati a ne diraš razvojnu bazu.

## Šta se digne

| Servis | Port | Šta je |
|---|---|---|
| **Oracle Database 23ai Free** | 1521 | Baza, PDB `FREEPDB1` |
| **EM Express** | 5500 | Nadzor baze kroz pregledač |
| **ORDS + APEX** | 8080 | APEX i REST servisi |

## Pokretanje

```bash
git clone https://github.com/Cvoki/oracle-apex-docker.git
cd oracle-apex-docker

cp .env.example .env      # promeni lozinke!
docker compose up -d

# prvo podizanje traje 3–5 min, prati napredak:
docker compose logs -f oracle
```

Spremno je kad u logu vidiš `DATABASE IS READY TO USE!`.

> **Napomena:** Oracle-ove slike traže prijavu na `container-registry.oracle.com` i prihvatanje uslova. Uradi to jednom, kroz `docker login container-registry.oracle.com`.

## Prvi koraci

**1. Napravi APEX radni prostor** (jednom, posle prvog podizanja):

```bash
docker cp scripts/apex-workspace.sql oracle-db:/tmp/
docker exec -it oracle-db sqlplus / as sysdba @/tmp/apex-workspace.sql
```

**2. Otvori APEX:**

```
http://localhost:8080/ords/
```

| Polje | Vrednost |
|---|---|
| Workspace | `RAZVOJ` |
| Korisnik | `ADMIN` |
| Lozinka | `Apex_2026!` |

**3. Poveži se iz SQL Developer-a ili SQLcl-a:**

```
Host:     localhost
Port:     1521
Service:  FREEPDB1
Korisnik: razvoj
Lozinka:  Razvoj_2026
```

## Svakodnevni rad

```bash
docker compose stop           # zaustavi, podaci ostaju
docker compose start          # nastavi
docker compose logs -f ords   # logovi ORDS-a

# SQL odmah, bez klijenta:
docker exec -it oracle-db sqlplus razvoj/Razvoj_2026@FREEPDB1
```

**Brisanje svega, uključujući podatke:**

```bash
docker compose down -v
```

## Kako se dodaju svoje skripte

Sve iz `sql/` foldera se pokreće **samo pri prvom pravljenju baze** — Oracle-ova slika tako radi. Zgodno za korisnike i početnu šemu.

Za skripte koje treba pokretati više puta, koristi:

```bash
docker exec -i oracle-db sqlplus razvoj/Razvoj_2026@FREEPDB1 < moja_skripta.sql
```

## Kad nešto ne radi

**Baza se ne diže, log staje na „ORA-27104"**
Docker-u treba više memorije. U Docker Desktop → Settings → Resources podigni na bar 4 GB.

**ORDS vraća 503**
Baza još nije spremna. `docker compose logs oracle` i sačekaj `DATABASE IS READY TO USE!`.

**Naša slova se prikazuju kao znakovi pitanja**
Proveri da je `ORACLE_CHARACTERSET: AL32UTF8` bio postavljen **pre prvog podizanja**. Ako nije — `docker compose down -v` i ispočetka, jer se karakterset zadaje pri pravljenju baze.

**Port 1521 zauzet**
Već ti radi neki Oracle. Promeni mapiranje u `docker-compose.yml` na `"1522:1521"`.

## Licenca

MIT za konfiguraciju i skripte iz ovog repozitorijuma. Oracle-ove slike imaju svoje uslove korišćenja — Free izdanje je besplatno i za razvoj i za produkciju, uz ograničenja resursa.

---

<sub><a href="https://github.com/Cvoki">Luka Cvoro</a> — <a href="mailto:lukac95@gmail.com">lukac95@gmail.com</a></sub>
