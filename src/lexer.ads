package Lexer with SPARK_Mode => On is

    -- Tokentypen: Addition, natuerliche Zahl, Dezimalzahl
    type Token_Type is (Null_Token_Type, Add, Nat, Float);
    type Token is record
        typ : Token_Type;         -- Tokentyp
        first, last : Positive;   -- Bereich der Eingangszeichenfolge, in dem der Token erfasst wurde
    end record;

    -- Naechsten Token ausgeben.
    -- Parameter:
    --   src: String             - Eingangszeichenfolge
    --   ptr: in out Positive    - Zeiger in die Eingangszeichenfolge
    --   tok: out Token          - Ausgabetoken
    -- Parametervoraussetzungen:
    --   ptr muss sich innerhalb der Grenzen der Eingangszeichenfolge src befinden.
    --   Fernerhin darf der letzte Index von src nicht groeßer oder gleich dem
    --   Maximalwert des Datentyps Positive sein. 
    procedure yield(src: String; ptr: in out Positive; tok: out Token) with
      Pre => (ptr in src'Range and src'Last < Positive'Last
              and String'(1 => Character'Val(0)) not in src);

private

    type States is range -1 .. 7;                   -- alle Zustaende (-1 := Fehler)
    subtype Valid_States is States range 0 .. 4;    -- valide, fehlerfreie Zustaende (0 := Initial)
    subtype End_States is States range 5 .. 7;      -- Endzustaende

    -- Zwecks der einfacheren Implementierung wird alpha ebenso innerhalb der
    -- Zustandsuebergangstabelle aufgenommen, doch muss dafuer vom Datentyp
    -- Character sein.
    -- Da anzunehmen ist, dass sich in der Eingabe kein Nullbyte befindet, wird
    -- alpha als solches definiert.
    alpha : constant Character := Character'Val(0);
    
    -- valider Zustand, Buchstabe -> Zustand
    transition : constant array(Valid_States, Character) of States :=
        (0 => ('0' => 1, '1' .. '9' => 3, '+' => 5, others => -1),   -- Uebergaenge von Zustand 0 aus
         1 => (',' => 2, alpha => 6, others => -1),                  -- Uebergaenge von Zustand 1 aus
         2 => ('0' .. '9' => 4, others => -1),                       -- Uebergaenge von Zustand 2 aus
         3 => ('0' .. '9' => 3, ',' => 2, alpha => 6, others => -1), -- Uebergaenge von Zustand 3 aus
         4 => ('0' .. '9' => 4, alpha => 7, others => -1));          -- Uebergaenge von Zustand 4 aus

    -- Rueckgabetabelle
    end_yields : constant array(End_States) of Token_Type :=
        (5 => Add, 6 => Nat, 7 => Float);

end Lexer;
