# Lexer-Facharbeit
Der Praxisteil der Facharbeit "Algorithmen zur Sprachanalyse".

## Voraussetzungen
Um das Programm zu kompilieren, gilt es GNAT zu installieren.

Für Windows:
    https://community.download.adacore.com/v1/797dbae8bdb8a3f661dad78dd73d8e40218a68d8?filename=gnat-2021-20210519-x86_64-windows64-bin.exe

Für Linux:
    apt-get install gnat-gps
    yay -S gnat-gps


## Beweis
Sobald GNAT installiert wurde, kann das Programm mit
    ./prove.sh
bzw.
    prove.bat
bewiesen werden.
Da der Beweis recht rechenintensiv ist, dauert dieser Schritt u.U. 2-3 Minuten.


## Kompilation
Sobald GNAT installiert wurde, ist das Programm mit
    ./build.sh
bzw.
    build.bat
zu kompilieren.


## Ausführung
Anschließend wird die ausführbare Datei mit
    [./]main[.exe] <Eingabestring>
ausgeführt.
Der Eingabestring wird in seine Tokens zerlegt und diese darnach ausgegeben.


## Sonstiges
Für die Quellcodeinspektion eignet sich
    gnatstudio
gut.
Auf Windows genügt es bei entsprechender GNAT-Installation, im Explorer auf die
Projektdatei lexer.gpr Doppelklick anzuwenden.

Auf Linux gilt es in dem Ordner ein Terminal zu öffnen, und
    gnatstudio lexer.gpr
einzugeben.

Die Quelldateien sind unter dem Ordner src zu finden.
In main.adb ist das Konsoleninterface implementiert.
Es wird auf lexer.adb zugegriffen, welche die Implementation für die Funktion,
welche in der Spezifikationsdatei lexer.ads deklariert wurde enthält.
Außerdem befinden sich in der Spezifikationsdatei die Zustandsübergangstabellen
und die Rückgabetabelle.
