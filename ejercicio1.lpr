program ejercicio1;
uses crt, sysutils,LCLIntf, unit1;
const
  NombreArchivo = 'Ventas.csv';
  NombreArchivoHTML = 'mi_archivo.html';
  NombreArchivoHTMLSalida = 'miArchivoActualizado.html';
type
  totalVentas = Array[1..80] of Integer;
  datosVenta = Array[1..4] of String;
var
   total99A : totalVentas;
   total00A : totalVentas;
   total99B : totalVentas;
   total00B : totalVentas;
   total99C : totalVentas;
   total00C : totalVentas;
   cadena : datosVenta;
   PunteroDeArchivo : Text;
   PunteroDeArchivoUpdate : Text;
   oracion : string;
{METODOS///////////////////////////////////////////////////////////////////////}
{Separa una cadena de texto por sus comas, arreglo de 4 espacios}
function split(cadena : String): datosVenta;
var
   Arreglo : datosVenta;
   i : integer;
   palabra : String;
   indice : integer;
begin
     indice := 1;
     palabra := '';
     for i := 1 to length(cadena) do
     begin
          if cadena[i] <> ',' then
          begin
               palabra := palabra + cadena[i];
          end
          else
          begin
               Arreglo[indice] := palabra;
               palabra := '';
               indice := indice + 1;
          end;
     end;
     Arreglo[indice] := palabra;
     split := Arreglo;
end;
{Busca el indice del ultimo elemento cargado al array}
function finalArray(cadena : totalVentas) : integer;
var
   contador : integer;
begin
     contador := 1;
     while cadena[contador] <> 0 do
     begin
          contador := contador + 1;
     end;
     finalArray := contador;
end;
{Lee el archivo e inicializa el type definido}
procedure leerArchivo;
begin
     Assign(PunteroDeArchivo, NombreArchivo);
     Reset(PunteroDeArchivo); { va al inicio para lectura }
end;
{Se compara de que anho es el ingreso}
procedure compararAnho(var negocio99 : totalVentas;var negocio00:totalVentas; var sentence : datosVenta);
var
   indice : integer;
begin
     if sentence[1] = '1999' then
             begin
                  indice := finalArray(negocio99);
                  negocio99[indice]:= StrToInt(sentence[3]) * StrToInt(sentence[4]);
             end
     else
         begin
              indice := finalArray(negocio00);
              negocio00[indice]:= StrToInt(sentence[3]) * StrToInt(sentence[4]);
         end;
end;
{Se compara de que negocio es el ingreso}
procedure compararNegocioAnho(sentence : datosVenta);
begin
     if sentence[2] = 'A' then
     begin
          compararAnho(total99A, total00A, sentence);
     end
     else if sentence[2] = 'B' then
     begin
          compararAnho(total99B, total00B, sentence);
     end
     else if sentence[2] = 'C' then
     begin
          compararAnho(total99C, total00C, sentence);
     end;
end;
{Clasifica a qué grupo de tiendda corresponde}
procedure calcularTabla;
begin
     Readln(PunteroDeArchivo, Oracion); {Se ignora la primera linea de cabecera}
     while NOT EOF(PunteroDeArchivo)do
     begin
          Readln(PunteroDeArchivo, Oracion);
          compararNegocioAnho(split(oracion));
     end;
end;
{Suma todos los valores de un array seleccionado}
function sumarArray(arreglo : totalVentas) : integer;
var
   total : integer;
   i : Integer;
begin
     total :=0;
     for i := 1 to length(arreglo) do
     begin
          total := total + arreglo[i];
     end;
     sumarArray := total;
end;
{Busca la parte del documento html en donde deben ir los datos}
procedure buscarTBody;
begin
     Assign(PunteroDeArchivo, NombreArchivoHTML);
     Reset(PunteroDeArchivo); { va al inicio para lectura }
     Assign(PunteroDeArchivoUpdate, NombreArchivoHTMLSalida);
     Rewrite(PunteroDeArchivoUpdate); { crear un archivo o sobre-escribir existente }
     While NOT EOF(PunteroDeArchivo) do
           begin
                Readln(PunteroDeArchivo, Oracion);
                Writeln(PunteroDeArchivoUpdate, Oracion);
                if oracion = #$09'<tbody>' then
                   begin
                        Writeln(PunteroDeArchivoUpdate,'<tr>'#$0A + '<td>A</td>'#$0A + '<td>' + IntToStr(sumarArray(total99A)) + '</td>'#$0A + '<td>' + IntToStr(sumarArray(total00A)) + '</td>'#$0A + '<td>' + IntToStr(sumarArray(total99A) + sumarArray(total00A)) + '</td>'#$0A);
                        Writeln(PunteroDeArchivoUpdate,'<tr>'#$0A + '<td>B</td>'#$0A + '<td>' + IntToStr(sumarArray(total99B)) + '</td>'#$0A + '<td>' + IntToStr(sumarArray(total00B)) + '</td>'#$0A + '<td>' + IntToStr(sumarArray(total99B) + sumarArray(total00B)) + '</td>'#$0A);
                        Writeln(PunteroDeArchivoUpdate,'<tr>'#$0A + '<td>C</td>'#$0A + '<td>' + IntToStr(sumarArray(total99C)) + '</td>'#$0A + '<td>' + IntToStr(sumarArray(total00C)) + '</td>'#$0A + '<td>' + IntToStr(sumarArray(total99C) + sumarArray(total00C)) + '</td>'#$0A);
                        Writeln(PunteroDeArchivoUpdate,'<tr>'#$0A + '<td>TOTAL</td>'#$0A + '<td>' + IntToStr(sumarArray(total99A)+sumarArray(total99B)+sumarArray(total99C)) + '</td>'#$0A + '<td>' + IntToStr(sumarArray(total00A)+sumarArray(total00B)+sumarArray(total00C)) + '</td>'#$0A + '<td>' + IntToStr(sumarArray(total00A) + sumarArray(total00B)+sumarArray(total99B) + sumarArray(total00B)+sumarArray(total99C) + sumarArray(total00C)) + '</td>'#$0A);
                        end;
           end;
end;
{Escribe todo a html}
procedure escribirHTML;
begin
     buscarTBody;
     Close(PunteroDeArchivo);
     Close(PunteroDeArchivoUpdate);
     OpenDocument(NombreArchivoHTMLSalida);
end;
{PROGRAMA MAIN}
begin
     leerArchivo;
     calcularTabla;
     Close(PunteroDeArchivo);
     escribirHTML;
end.
