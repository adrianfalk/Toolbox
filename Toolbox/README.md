# Toolbox

Professionellt, modulärt PowerShell-baserat IT-supportverktyg med terminal-UI.

## Användning

```powershell
irm https://tools.ecit.com | iex
```

`Loader.ps1` (publicerad bakom domänen ovan) hämtar hela ramverket från GitHub
till `%LOCALAPPDATA%\Toolbox` och startar `Start-Toolbox.ps1`.

## Lokal utveckling

```powershell
git clone https://github.com/ecit/toolbox.git
cd toolbox
./Start-Toolbox.ps1
```

## Lägga till ett nytt verktyg

Skapa en ny `.ps1`-fil under `Modules/<Kategori>/` med ett metadata-block:

```powershell
$Tool = @{
    Name          = "Mitt verktyg"
    Category      = "Network"
    Description   = "Vad verktyget gör"
    Icon          = "🌐"
    RequiresAdmin = $false
    Hidden        = $false
    Version       = "1.0"
}

# ... verktygets logik ...
```

Verktyget dyker automatiskt upp i menyn nästa gång programmet startas — ingen
meny är hårdkodad. Committa och pusha till main, så får alla användare
uppdateringen automatiskt vid nästa körning.

## Arkitektur

```
Toolbox/
├── Loader.ps1              # Bootstrap - den enda filen som körs via irm | iex
├── Start-Toolbox.ps1      # Riktig entry point, laddas av Loader
├── Core/                    # Motor: meny, loader, loggning, tema, uppdatering, sök
├── Modules/                 # Fristående verktygsskript, ett per fil
├── Assets/                  # Logo, tema och konfiguration
├── Cache/                   # Lokal cache (skapas vid körning)
└── Logs/                    # Körloggar (skapas vid körning)
```

## Distribution

1. `git add . && git commit -m "..." && git push`
2. Domänen `tools.ecit.com` pekar mot `Loader.ps1` i repot (t.ex. via
   GitHub Pages eller en enkel redirect till raw-URL:en).
3. `Loader.ps1` laddar alltid `main`-grenens senaste zip, så inga fler steg
   krävs för att rulla ut ändringar.
