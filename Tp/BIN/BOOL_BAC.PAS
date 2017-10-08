{-----------------------------------------------}
program Cradle;

{-----------------------------------------------}
{Constant Declaration}

const TAB = ^I;
const CR = ^M;
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

{Recognize an Addop}
function isAddop(c: char): boolean;
begin
     isAddop := c in ['+','-'];
end;
{-----------------------------------------------}
{Recognize a Boolean Orop}
function IsOrop(c: char): Boolean;
begin
     IsOrop := c in ['|', '~'];
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
{Recognize a Decimal Digit}

function IsDigit(c: char): boolean;
begin
     IsDigit := c in ['0'..'9']
end;
{-----------------------------------------------}
{Recognize a Relop}

function IsRelop(c: char): boolean;
begin
     IsRelop := c in ['=', '#', '<', '>'];
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
{Recognize a Boolean Literal}

function IsBoolean(c: char): Boolean;
begin
     IsBoolean := UpCase(c) in ['T' , 'F'];
end;
{-------------------------------------------------------}
{Get a Boolean Literal}

function GetBoolean: Boolean;
var c: char;
begin
     if not IsBoolean(Look) then Expected('Boolean Literal');
     GetBoolean := UpCase(Look) = 'T';
     GetChar;
end;

{-------------------------------------------------------}
{Output a string with Tab and CRLF}

procedure EmitLn(s: string);
begin
     Emit(s);
     WriteLn;
end;
{-------------------------------------------------------}
{Recognize and Translate an Identifier}

procedure Ident;
var Name: char;
begin
     Name:= GetName;
     if Look = '(' then begin
     Match('(');
     Match(')');
     EmitLn('BSR ' + Name);
     end
   else
   EmitLn('MOVE ' + Name + '(PC), D0');
end;

{---------------------------------------------------------}
{Parse and Translate a Math Factor}

procedure Expression; Forward;

procedure Factor;
begin
     if Look = '(' then begin
     Match ('(');
     Expression;
     Match(')');
     end
   else if IsAlpha(Look) then
        Ident
   else
   EmitLn('MOVE #' + GetNum + ',D0');
end;

{---------------------------------------------------------}
{Parse and Translate the First Math Factor}

procedure SignedFactor;
begin
     if Look = '+' then
     GetChar;
     if Look = '-' then begin
     GetChar;
     if IsDigit(Look) then
     EmitLn('MOVE #-' + GetNum + ',D0')
     else begin
     Factor;
     EmitLn('NEG D0');
     end;
     end
     else Factor;
end;
{--------------------------------------------------------}
{Parse and Translate a Mulitply}

procedure Multiply;
begin
     Match('*');
     Factor;
     EmitLn('MULS (SP)+, D0');
end;
{--------------------------------------------------------}
{Parse and Translate a Divide}

procedure Divide;
begin
     Match('/');
     Factor;
     EmitLn('MOVE (SP)+, D0');
     EmitLn('EXS.L D0');
     EmitLn('DIVS D1, D0');
end;
{--------------------------------------------------------}
{Parse and Translate a Math Term}

procedure Term;
begin
     SignedFactor;
     while Look in ['*', '/'] do begin
     EmitLn('MOVE D0, -(SP)');
     case Look of
     '*' : Multiply;
     '/' : Divide;
     end;
  end;
end;
{----------------------------------------------------------}
{Recognize and Translate an Add}

procedure Add;
begin
     Match('+');
     Term;
     EmitLn('ADD (SP)+, D0');
end;
{----------------------------------------------------------}
{Recognize and Translate a Subtract}

procedure Subtract;
begin
     Match('-');
     Term;
     EmitLn('SUB (SP)+, D0');
     EmitLn('NEG D0');
end;
{----------------------------------------------------------}
{Parse and Translate an Expression}

procedure Expression;
begin
     Term;
     While isAddop(Look) do begin
     EmitLn('MOVE D0, -(SP)');
     case Look of
     '+' : Add;
     '-' : Subtract;
     end;
end;
end;
{----------------------------------------------------------}
{Recognize and Translate a Relational "Equals"}

procedure Equals;
begin
     Match('=');
     Expression;
     EmitLn('CMP (SP)+, D0');
     EmitLn('SEQ D0');
end;
{-------------------------------------------------------}
{Recognize and Translate a Relational "Not Equals"}

procedure NotEquals;
begin
     Match('#');
     Expression;
     EmitLn('CMP (SP)+, D0');
     EmitLn('SEQ D0');
end;
{--------------------------------------------------------}
{Recognize and Translate a Relational "Less Than"}

procedure Less;
begin
     Match('<');
     Expression;
     EmitLn('CMP (SP)+, D0');
     EmitLn('SLE D0');
end;
{--------------------------------------------------------}
{Recognize and Translate a Relational "Greater Than"}

procedure Greater;
begin
     Match('>');
     Expression;
     EmitLn('CMP (SP)+, D0');
     EmitLn('SLE D0');
end;

{--------------------------------------------------------}
{Parse and Translate a Relation}

procedure Relation;
begin
     Expression;
     if isRelop(Look) then begin
     EmitLn('MOVE D0, -(SP)');
     case look of
     '=': Equals;
     '#': NotEquals;
     '<': Less;
     '>': Greater;
     end;
     EmitLn('TST D0');
     end;
end;

{-------------------------------------------------------}
{Parse and Translate a Bool Factor}
procedure BoolFactor;
begin
     if IsBoolean(Look) then
     if GetBoolean then
     EmitLn('MOVE #-1, D0')
     else
     EmitLn('CLR D0')
     else
     Relation;
end;
{-------------------------------------------------------}
{Parse and Translate a Boolean Facor with NOT}

procedure NotFactor;
begin
     if Look = '!' then begin
     Match('!');
     BoolFactor;
     EmitLn('EOR #-1,D0');
     end
     else
     BoolFactor;
end;
{-------------------------------------------------------}
{Parse and Translate a Boolean Term}

procedure BoolTerm;
begin
     NotFactor;
     while Look = '&' do begin
     EmitLn('MOVE D0,-(SP)');
     Match('&');
     NotFactor;
     EmitLn('AND (SP)+,D0');
   end;
end;

{-------------------------------------------------------}
{Recognize and Translate a Boolean Or}

procedure BoolOr;
begin
     Match('|');
     BoolTerm;
     EmitLn('OR (SP)+, D0');
end;
{--------------------------------------------------------}
{Recognize and Translate an Exclusive Or}

procedure BoolXor;
begin
     Match('~');
     BoolTerm;
     EmitLn('EOR (SP)+, D0');
end;

{-------------------------------------------------------}
{Parse and Translate a Boolean Expression}

procedure BoolExpression;
begin
     BoolTerm;
     while IsOrOp(Look) do begin
        EmitLn('MOVE D0, -(SP)');
     case Look of
     '|': BoolOr;
     '~': BoolXor;
     end;
  end;
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
     BoolExpression;
end.








































