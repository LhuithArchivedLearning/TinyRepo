{-----------------------------------------------}
program Cradle;

{-----------------------------------------------}
{Constant Declaration}

const TAB = ^I;
const CR = ^M;
const LF = ^J;
{-----------------------------------------------}
{Variable Declarations}

var Look: char;         {Lookahead Character}

{-----------------------------------------------}
{Read New Character from Input Stream}

procedure GetChar;
begin
     Read(Look);
end;

{-----------------------------------------------}
{Report an Error}
procedure Error(s: string);
begin
     Writeln;
     Writeln(^G, 'Error: ', s, '.');
end;
{-----------------------------------------------}
{Report Error and Halt!}

procedure Abort(s: string);
begin
     Error(s);
     Halt;
end;

{-----------------------------------------------}
{Report What Was Expected}

procedure Expected(s: string);
begin
     Abort(s + 'Expected');
end;

{-----------------------------------------------}
{Match a specific input Character}
procedure Match(x : char);
begin
     if Look = x then GetChar
     else Expected(''''+ x + '''');
end;

{-----------------------------------------------}
{Recognize an Alpha Character}

function IsAlpha(c: char): boolean;
begin
     IsAlpha := upcase(c) in ['A'..'Z'];
end;

{-----------------------------------------------}
{Recognize a Decimal Digit}

function IsDigit(c: char): boolean;
begin
     IsDigit := c in ['0'..'9']
end;

{-----------------------------------------------}
{Recognize an Alphanumeric Character}

function IsAlNum(c: char): boolean;
begin
     IsAlNum := IsAlpha(c) or IsDigit(c);
end;

{------------------------------------------------}
{Recognize an Addop}
function isAddop(c: char): boolean;
begin
     isAddop := c in ['+','-'];
end;

{-------------------------------------------------}
{Recognize a Mulop}

function isMulop(c: char): boolean;
begin
     isMulop := c in['*', '/'];
end;
{-------------------------------------------------}
{Recognize a Boolean OrOp}

function IsOrop(c: char): Boolean;
begin
     IsOrop := c in ['|', '~'];
end;

{-------------------------------------------------}
{Recognize a Relop}

function IsRelop(c: char): Boolean;
begin
     IsRelop := c in ['=', '#', '<','>'];
end;


{-----------------------------------------------}
{Recognize White Space}
function isWhite(c: char): boolean;
begin
     IsWhite := c in [' ', TAB];
end;

{-----------------------------------------------}
{Skip Over Leading White Space}
procedure SkipWhite;
begin
     while IsWhite(Look) do
           GetChar;
end;
{------------------------------------------------}
{Skip a CRLF}

procedure Fin;
begin
     if Look = CR then GetChar;
     if Look = LF then GetChar;
end;


{-----------------------------------------------}
{Get an Identifier}

function GetName: char;
begin
     if not IsAlpha(Look) then Expected('Name');
     GetName := UpCase(Look);
     GetChar;
end;

{-----------------------------------------------}
{Get a Number}

function GetNum: char;
begin
     if not IsDigit(Look) then Expected('Integer');
     GetNum := Look;
     GetChar;
end;

{-------------------------------------------------------}
{Output a String with Tab}

procedure Emit(s: string);
begin
     Write(TAB, s);
end;

{-------------------------------------------------------}
{Output a string with Tab and CRLF}

procedure EmitLn(s: string);
begin
     Emit(s);
     WriteLn;
end;

{-------------------------------------------------------}
{ Initialize }

procedure Init;
begin
     GetChar;
end;

{-------------------------------------------------------}
{Main Program}

begin
     Init;
end.








































