package body Lexer with SPARK_Mode => On is

    procedure yield(src: String; ptr: in out Positive; tok: out Token) is
        cur_state : Valid_States := 0; -- aktueller Zustand (valide)
        new_state : States;            -- naechster Zustand
        first : Positive := ptr;       -- Alias fuer Anfangszeiger
    begin
        -- Schleife
        loop
            -- Beweishilfen
            -- Folgende Aussagen bleiben wahr fuer jede beliebige Iteration:
            pragma Loop_Invariant(ptr >= src'First and ptr <= src'Last + 1 and
                                    (if ptr = 1 then cur_state = 0));

            -- Falls die Eingangszeichenfolge endete:
            if ptr > src'Last then
                -- Falls die Eingangszeichenfolge endete, versuche per alpha
                -- den naechsten Zustand zu ermitteln.
                new_state := transition(cur_state, alpha);

                -- Wenn dieser ein Endzustand ist, so verlasse die Schleife.
                exit when new_state in end_yields'Range;

                -- Ansonsten liegt ein Fehler vor.
                goto error;
            else
                -- naechster Zustand := Uebergangstabelle[naechster Buchstabe]
                new_state := transition(cur_state, src(ptr));
            end if;

            -- Falls der naechste Zustand ein Fehlerzustand waere:
            if new_state = -1 then
                if transition(cur_state, alpha) = -1 then   -- Alpha undefiniert
                    -- Wenn alpha von dem aktuellen Zustand nicht weiterfuehrt,
                    -- so liegt ein Fehler vor.
                    goto error;
                end if;
        
                -- Der naechste Zustand wird vermittelst alpha vom aktuellen
                -- aus ermittelt.
                new_state := transition(cur_state, alpha);

                -- Verlasse die Schleife.
                exit;
            end if;

            -- Falls kein Endzustand per alpha und kein Fehler vorlag,
            -- inkrementiere den Zeiger.
            ptr := ptr + 1;

            -- Falls ein normaler Endzustand vorliegt, so verlasse die Schleife.
            exit when new_state in end_yields'Range;

            -- aktueller Zustand := naechster Zustand
            cur_state := new_state;
        end loop;

        -- Gebe den Token zurueck.
        -- Der Typus ergibt sich aus Rueckgabetabelle[naechster Zustand], und
        -- der Bereich aus dem urspruenglichen Zeiger und dem Vorgaenger des
        -- jetzigen.
        tok := Token'(end_yields(new_state), first, ptr - 1);
        return;

        -- Wenn ein Fehler vorlag, so gebe einen null_token zurueck.
        <<error>>
        tok.typ := Null_Token_Type;
        tok.first := ptr;
        tok.last := ptr;
    end yield;

end Lexer;
