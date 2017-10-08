{-----------------------------------------------}
program Calls;

{-----------------------------------------------}
{Constant Declaration}

const TAB = ^I;
const CR = ^M;
const LF = ^J;

{-----------------------------------------------}
{Variable Declarations}

var Look: char;         {Lookahead Character}
var ST: Array['A'..'Z'] of char;
var Params: Array['A'..'Z'] of integer;
var NumParams: integer;

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
{Report an Unidefined Indentifier}

procedure Undefined(n: string);
begin
     Abort('Undefined Identifier ' + n);
end;

{-----------------------------------------------}
{Report a Duplicate Identifier}

procedure Duplicate(n: string);
begin
     Abort('Duplicate Identifier ' + n);
end;
{------------------------------------------------}
{See if an Identifier is a Parameter}

function IsParam(N: char): boolean;
begin
     IsParam := Params[N] <> 0;
end;

{-----------------------------------------------}
{Get Type of Symbol}

function TypeOf(n: char): char;
begin
     if IsParam(n) then
         TypeOf := 'f'
     else
     TypeOf := ST[n];
end;

{-----------------------------------------------}
{Look for Symbol to Table}

function InTable(n: char): Boolean;
begin
     InTable := ST[n] <> ' ';
end;

{-----------------------------------------------]
{Add a New Symbol to Table}

procedure AddEntry(Name, T: char);
begin
     if InTable(name) then Duplicate(Name);
     ST[Name] := T;
end;

{-----------------------------------------------}
{Check an Entry to Make sure It's a Variable}

procedure CheckVar(Name: char);
begin
     if not InTable(Name) then Undefined(Name);
     if TypeOf(Name) <> 'v' then Abort(Name + ' is not a variable');
end;

{-----------------------------------------------}
{ Find the Parameter Number}

function ParamNumber(N: char): integer;
begin
     ParamNumber := Params[N];
end;

{-----------------------------------------------}

{-----------------------------------------------}
{Add a New Parameter to Table}

procedure AddParam(Name: char);
begin
     if IsParam(Name) then Duplicate(Name);
     Inc(NumParams);
     Params[Name] := NumParams;
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
{-----------------------------------------------}
{Skip Over an End-Of-Line}
procedure Fin;
begin
     if Look = CR then begin
      GetChar;
     if Look = LF then
      GetChar;
      end;
end;

{-----------------------------------------------}
{Match a specific input Character}
procedure Match(x : char);
begin
     if Look = x then GetChar
     else Expected(''''+ x + '''');
     SkipWhite;
end;

{-----------------------------------------------}
{Get an Identifier}

function GetName: char;
begin
     if not IsAlpha(Look) then Expected('Name');
     GetName := UpCase(Look);
     GetChar;
     SkipWhite;
end;

{-----------------------------------------------}
{Get a Number}

function GetNum: char;
begin
     if not IsDigit(Look) then Expected('Integer');
     GetNum := Look;
     GetChar;
     SkipWhite;
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
{Post a Label to Ouput}

procedure PostLabel(L: string);
begin
     WriteLn(L, ':');
end;

{-------------------------------------------------------}
{Load a Variable to the Primary Register}

procedure LoadVar(Name: char);
begin
     CheckVar(Name);
     EmitLn('MOVE ' + Name + '(PC), D0');
end;

{-------------------------------------------------------}
{Store the Primary Register}

procedure StoreVar(Name: char);
begin
     CheckVar(Name);
     EmitLn('LEA ' + Name + '(PC), A0');
     EmitLn('MOVE D0, (A0)');
end;

{------------------------------------------------------}
{ Load a Parameter to the Primary Register}

procedure LoadParam(N: integer);
var Offset: integer;
begin
     Offset := 8 + 4 * (NumParams - N);
     Emit('MOVE.L ');
     WriteLn(Offset, '(A6), A0');
     EmitLn('MOVE (A0), D0');
end;

{------------------------------------------------------}
{Store a Parameter from the Primary Register}

procedure StoreParam(N: integer);
var Offset: integer;
begin
     Offset := 8 + 4 * (NumParams - N);
     Emit('MOVE.L ');
     WriteLn(Offset, '(A6), A0 ');
     EmitLn('MOVE D0,(A0)');
end;
{-------------------------------------------------------}
{Push the Primary Register to the Stack}

procedure Push;
begin
     EmitLn('MOVE D0, -(SP)');
end;
{------------------------------------------------------}
{Adjust the Stack Pointer Upwards by N Bytes}

procedure CleanStack(N: integer);
begin
     if N > 0 then begin
        Emit('ADD #');
        WriteLn(N, ',SP');
     end;
end;

{-------------------------------------------------------}
{Write Header Info}

procedure Header;
begin
     WriteLn('WARMST', TAB, 'EQU $A01E');
end;
{-------------------------------------------------------}
{Write the Prolog}

procedure Prolog;
begin
     PostLabel('MAIN');
end;

{-------------------------------------------------------}
{Write the Epilog}

procedure Epilog;
begin
     EmitLn('DC WARMST');
     EmitLn('END MAIN');
end;
{----------------------------------------------------}
{Write the Prolog for a Procedure}

procedure ProcProlog(N: char);
begin
     PostLabel(N);
     EmitLn('LINK A6, #0');
end;

{----------------------------------------------------}
{Write the Epilog for a Procedure}

procedure ProcEpilog;
begin
     EmitLn('UNLK A6');
     EmitLn('RTS');
end;

{-------------------------------------------------------}
{Call a Procedure}

procedure Call(N: char);
begin
     EmitLn('BSR ' + N);
end;

{-------------------------------------------------------}
{Initialize Parameter Table to Null}

procedure ClearParams;
var i: char;
begin
     for i := 'A' to 'Z' do
         Params[i] := 0;
     NumParams := 0;
end;

{-------------------------------------------------------}
{ Initialize }

procedure Init;
var i: char;
begin
     GetChar;
     SkipWhite;
     for i := 'A' to 'Z' do
     ST[i] := ' ';
     ClearParams;
end;
{-------------------------------------------------------}
{Parse and Translate an Expression}
{Vestigial Version}

procedure Expression;
var Name: char;

begin
     Name := GetName;
     if IsParam(Name) then
     LoadParam(ParamNumber(Name))
     else
     LoadVar(GetName);
end;
{-------------------------------------------------------}
{Process an Actual Parameter}

procedure Param;
begin
     EmitLn('PEA ' + GetName + '(PC) ');
end;
{-------------------------------------------------------}
{Proccess a Formal Parameter}

procedure FormalParam;
var Name: char;
begin
     AddParam(GetName);
end;

{-------------------------------------------------------}
{Process the Parametere List for a Procedure Call}

function ParamList: integer;
Var N: integer;
begin
     N := 0;
     Match('(');
     if Look <> ')' then begin
     Param;
     inc(N);
     while Look = ',' do begin
           Match(',');
           Param;
           Inc(N);
     end;
   end;
   Match(')');
   ParamList := 4 * N;
end;

{------------------------------------------------------}
{Call a Procedure}

procedure CallProc(Name: char);
var N: integer;
begin
     N := ParamList;
     Call(Name);
     CleanStack(N);
end;

{-------------------------------------------------------}
{Process the formal Parametre List of a Procedure}

procedure FormalList;
begin
     Match('(');
     if Look <> ')' then begin
     FormalParam;
     While Look = ',' do begin
           Match (',');
           FormalParam;
     end;
   end;
   Match(')');
end;

{-------------------------------------------------------}
{Parse and Translate an Assignment Statement}

procedure Assignment(Name: char);
begin
     Match('=');
     Expression;
     if IsParam(Name) then
        StoreParam(ParamNumber(Name))
     else

     StoreVar(Name);
end;
{-------------------------------------------------------}
{Decide if a Statement is an Assignment or a Procedure Call}

procedure AssignOrProc;
var Name: char;
begin
     Name := GetName;
     case TypeOf(Name) of
     ' ': Undefined(Name);
     'v', 'f': Assignment(Name);
     'p': CallProc(Name);

     else Abort('Identifier ' + Name + 'Cannot be Used here');
     end;
end;
{-------------------------------------------------------}
{Parse and Translate a Block Statement}

procedure DoBlock;
begin
     While not(Look in ['e']) do begin
     AssignOrProc;
     Fin;
  end;
end;

{--------------------------------------------------------}
{Parse and Translate a Begin-Block}

procedure BeginBlock;
begin
     Match('b');
     Fin;
     DoBlock;
     Match('e');
     Fin;
end;
{-------------------------------------------------------}
{Allocate Storage for a Variable}

procedure Alloc(N: char);
begin
     if InTable(N) then Duplicate(N);
     ST[N] := 'v';
     WriteLn(N, ':', TAB, 'DC 0');
end;

{-------------------------------------------------------}
{Parse and Translate a Data Declaration}

procedure Decl;
var Name: char;
begin
     Match('v');
     Alloc(GetName);
end;
{-------------------------------------------------------}
{Emit Return}

procedure Return;
begin
     EmitLn('RTS');

end;
{-------------------------------------------------------}
{Parse and Translate a Main Program}

procedure DoMain;
var N: char;
begin
     Match('P');
     N := GetName;
     Fin;
     if InTable(N) then Duplicate(N);
     Prolog;
     BeginBlock;
     end;

{-------------------------------------------------------}
{Parse and Translate a Procedure Declaration}

procedure DoProc;
var N: char;
begin
     Match('p');
     N := GetName;
     FormalList;
     Fin;
     if InTable(N) then Duplicate(N);
     ST[N] := 'p';
     ProcProlog(N);
     BeginBlock;
     ProcEpilog;
     ClearParams;
end;
{-------------------------------------------------------}
{Parse and Translate Global Declarations}

procedure TopDecls;
begin
     while Look <> '.' do begin
     case Look of
     'v': Decl;
     'p' : DoProc;
     'P' : DoMain;
     Else Abort('Unrecognized Keyword ' + Look);
     end;
     Fin;
  end;
end;

{---------------------------------------------------------}
{Main Program}

begin
     Init;
     TopDecls;
     Epilog;
end.








































