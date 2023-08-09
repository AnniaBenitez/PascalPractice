program ejercicio2;
uses crt;
const
NombreArchivo = 'entrada.txt';
NombreArTraduc = 'salida.txt';
var
   PunteroDeArchivo : Text;
   PunteroDeArchivoTrad : text;
   codigoAscii : integer;
   Oracion : String;
   i: Integer;


   {METODOS}
   function traducirCh(c:Char):Char;
   begin
        codigoAscii := ord(c)-2;
        c := chr(codigoAscii);
        traducirCh := c ;
   end;

   procedure tomarCaracteres(sentence:String);
   var
      oracionTraducida : String;
   begin
        oracionTraducida := '';
        For i := 1 to length(sentence) do
              begin
                   oracionTraducida := oracionTraducida + traducirCh(sentence[i]);
              end;
        writeln(PunteroDeArchivoTrad,oracionTraducida);
   end;

   procedure imprimirTexto;
   begin
        reset(PunteroDeArchivoTrad);
        while not eof(PunteroDeArchivoTrad) do
        begin
             ReadLn(PunteroDeArchivoTrad, Oracion);
             writeln(oracion);
        end;
   end;
{Aca inicia todo////////////////////////////////////////////}
begin
     Assign(PunteroDeArchivo, NombreArchivo);  {Paso el puntero}
     Assign(PunteroDeArchivoTrad, NombreArTraduc);  {Paso el puntero}
     reset (PunteroDeArchivo); { va al inicio para lectura }
     Rewrite(PunteroDeArchivoTrad); { Para agregar texto en el archivo }
     While NOT EOF(PunteroDeArchivo) do  {Recorro cada linea de salida.txt}
           begin
                Readln(PunteroDeArchivo, Oracion);     {Sacamos oracion}
                tomarCaracteres(Oracion);              {Paso a c-2}
                end;
     imprimirTexto();
     Close(PunteroDeArchivo);
     close(PunteroDeArchivoTrad);
     readkey;
     end.

