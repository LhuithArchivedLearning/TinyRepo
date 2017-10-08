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
var Class: char;
var Typ: char;
var Sign: char;
{-------------------------------------------------------}
{Post a Label to Output}
procedure PostLabel(L: string);
begin
     WriteLn(L, ':');
end;
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
{Recognize a Decimal Digit}

function IsDigit(c: char): boolean;
begin
     IsDigit := c in ['0'..'9']
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
{Process Label Statement}

procedure Labels;
begin
     Match('l');
end;
{-------------------------------------------------------}
{Process Const Statment}

procedure Constants;
begin
     Match('c');
end;

{-------------------------------------------------------}
{Process Type Statment}

procedure Types;
begin
     Match('t');
end;
{--------------------------------------------------------}
{Process Var Statment}

procedure Variables;
begin
     Match('v');
end;
{---------------------------------------------------------}
{Process Procedure Definition}

procedure DoProcedure;
begin
     Match('p');
end;
{---------------------------------------------------------}

procedure DoFunction;
begin
     Match('f');
end;
{---------------------------------------------------------}
{Process a Function Definintion}

procedure DoFunc(n: char);
begin
     Match('(');
     Match(')');
     Match('{');
     Match('}');
     if Typ = ' ' then Typ := 'i';
     WriteLn(Class, Sign, Typ, ' function ', n);
end;

{---------------------------------------------------------}
{Process a Data Declaration}

procedure DoData(n: char);
begin
     if Typ = ' ' then Expected('Type Declaration');
     WriteLn(Class, Sign, Typ, 'data ', n);
     while Look = ',' do begin
     Match(',');
     n := GetName;
     WriteLn(Class, Sign, Typ, ' data', n);
  end;
  Match(';');
end;
{---------------------------------------------------------}
{Get a Storage Class Specifier}

procedure GetClass;
begin
     if Look in ['a', 'x', 's'] then begin
     Class := Look;
     GetChar;
     end
     else Class := 'a';
end;

{---------------------------------------------------------}
{Get a Type Specifier}

procedure GetType;
begin
     Typ := ' ';
     If Look = 'u' then begin
     Sign := 'u';
     Typ := 'i';
     GetChar;
     end
  else Sign := 's';
  if Look in ['i','l','c'] then begin
     Typ := Look;
     GetChar;
  end;
end;
{---------------------------------------------------------}
{Process a Top Level Declaration}

procedure TopDecl;
var Name: char;
begin
     Name := GetName;
     if Look = '(' then
        DoFunc(Name)
     else
        DoData(Name);
end;

{-------------------------------------------------------}
{Write the Prolog}

procedure Prolog;
begin
     EmitLn('WARMST EQU $A01E');
end;
{-------------------------------------------------------}
{Write the Epilog}

procedure Epilog(Name: char);
begin
     EmitLn('DC WARST');
     EmitLn('END ' + NAME);
end;
{-------------------------------------------------------}
{Parse and Translate a Decleration}

procedure Declarations;
begin
     while Look in ['l','c','t','v','p','f'] do
     case Look of
     'l': Labels;
     'c': Constants;
     't': Types;
     'v': Variables;
     'p': DoProcedure;
     'f': DoFunction;
     end;
end;

{-------------------------------------------------------}
{Parse and Translate a Statement}

procedure Statements;
begin
     Match('b');
     while Look <> 'e' do
     GetChar;
     Match('e');
end;

{-------------------------------------------------------}
{Pars and Translate a Pascal Block}

procedure DoBlock(Name: char);
begin
     Declarations;
     PostLabel(Name);
     Statements;

end;
{-------------------------------------------------------}
{Parse and Translate a Program}

procedure Prog;
var Name: char;

begin
     Match('p');                {Handles program Header Part}
     Name := GetName;
     Prolog;
     DoBlock(Name);
     Match('.');
     Epilog(Name);
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
     while Look <> ^Z do begin
     GetClass;
     GetType;
     TopDecl;
     end;
end.








































