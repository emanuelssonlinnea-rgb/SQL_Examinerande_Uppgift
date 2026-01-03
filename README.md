# E-handel analys

## Introduction
Projektet analyserar AdventureWorks-databasen för att kunna skapa visualiseringar som besvara affärsfrågor-

I analysis.ipynb svarar vi på frågor:
1: Hur många produkter finns i varje kategori?
2: Vilka produktkategorier genererar mest intäkter?
3: Hur har försäljningen utvecklats över tid?
4: Hur ser total försäljning och antal ordrar ut per år?
5: Vilka 10 produkter genererar mest försäljning?
6: Hur skiljer sig försäljningen mellan olika regioner, och hur många unika kunder har varje region?
7: Vilka regioner har högst/lägst genomsnittligt ordervärde, och skiljer det sig mellan individuella kunder och företagskunder?
Djupanalys: Regional försäljningsoptimering
8: Vilken region presterar bäst/sämst?
9: Vilka produktkategorier säljer bäst var?
10: Finns säsongsmönster per region?
11: Rekommendationer för förbättring?

I SQL_Queries.sql kan man se originalkalkyleringar i SQL för dessa frågor.

## Hur man kör projektet
# klona projetet
git clone https://github.com/emanuelssonlinnea-rgb/SQL_Examinerande_Uppgift.git
# Skapa och aktivera virtuell miljö
python -m venv .venv
# Windows PowerShell
.venv\Scripts\Activate
# macOS/Linux
source .venv/bin/activate 
# installera beroenden
python -m pip install -r requirements.txt

## Miljö
Python 3.13.7
Paket: Pandas, matplotlib (se requirements.txt)

