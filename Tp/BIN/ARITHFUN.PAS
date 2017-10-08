program ArithFunc;

const
     Sentinel =0.0;
     var
     X:Real;
begin
     writeln('After each line enter a real number or 0.0 to stop');
     writeln;
     writeln('X', 'Trunc(x)' :16, 'Round(x)' : 10, 'Abs(X)' :10,
                  'Sqr(X)' :10, 'Sqrt(Abs(X))' : 15);
     readln(X);
     while x <> Sentinel do
     begin
          writeln(Trunc(X) : 17, Round(X) : 10, Abs(X) : 10:2,
          Sqr(x) : 10:2, Sqrt(Abs(X)) :10:2);
     readln(X);

     end
     end.