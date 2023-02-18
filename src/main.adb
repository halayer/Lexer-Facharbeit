with Ada.Command_Line;
with Ada.Text_IO;
with Lexer;

procedure main with SPARK_Mode => Off is
    function get_arg return String is begin
        if Ada.Command_Line.Argument_Count = 0 then
            Ada.Text_IO.Put_Line("Keine Eingabe, nutze ""3,14+0+2,71""!");
            return "3,14+0+2,71";
        end if;
        
        return Ada.Command_Line.Argument(1);
    end get_arg;

    src : constant String := get_arg;
    
    ptr : Positive;
    tok : Lexer.Token;
    
    use type Lexer.Token_Type;
begin
    ptr := src'First;
    
    while ptr <= src'Last loop
        Lexer.yield(src, ptr, tok);
        if tok.typ = Lexer.Null_Token_Type then
            Ada.Text_IO.Put_Line("Error while lexing: unexpected """ &
                                   src(tok.first .. tok.last) & '"');
            exit;
        end if;

        Ada.Text_IO.Put_Line(tok.typ'Img & "(" & src(tok.first .. tok.last) & ")");
    end loop;
end main;
