unit ListArray;

interface

Uses Tipos, stdctrls, SysUtils, Variants;

Const
MIN = 1;
MAX = 10; // Corte de lista llena
Nulo= 0; // Indica posici�n invalida de la lista

Type
  PosicionLista = LongInt;
  Lista = Object
    Private
      Elementos: Array [MIN .. MAX] Of TipoElemento;
      Inicio, Final: PosicionLista;
      Q_Items: Integer;
      // Comportamiento privado
      Procedure Intercambio (P,Q: PosicionLista);
      Public
      // Comportamiento del objeto (Operaciones del TAO)
      Procedure Crear();
      Function EsVacia(): Boolean;
      Function EsLLena(): Boolean;
      Function Agregar(X:TipoElemento): Errores;
      Function Insertar(X:TipoElemento; P:PosicionLista): Errores;
      Function Eliminar(P:PosicionLista): Errores;
      Function Buscar(X:TipoElemento; ComparaPor:CampoComparar):PosicionLista;
      Function Siguiente(P:PosicionLista): PosicionLista;
      Function Anterior(P:PosicionLista): PosicionLista;
      Function Ordinal(PLogica: Integer): PosicionLista;
      Function Recuperar(Var X:TipoElemento; P:PosicionLista): Errores;
      Function Actualizar(X:TipoElemento; P:PosicionLista): Errores;
      Function ValidarPosicion(P:PosicionLista): Boolean;
      Function RetornarString(): String;
      Function LlenarRandom(RangoHasta: LongInt): Errores;
      Procedure Sort(ComparaPor: CampoComparar);
      // Procedure Salvar(sFileName: String);
      // Procedure Cargar(sFileName: String);
      Function Comienzo: PosicionLista;
      Function Fin: PosicionLista;
      Function CantidadElementos: LongInt;
  End;

implementation

Procedure Lista.Crear();
Begin
  Inicio := Nulo;
  Final := Nulo;
  Q_Items := 0;
End;

Function Lista.EsVacia(): Boolean;
begin
   Esvacia := (Inicio = Nulo);
end;

Function Lista.EsLLena(): Boolean;
begin
  Esllena := (Final = MAX);
end;

//agrega un elemento en la ultima posicion de la lista
Function Lista.Agregar(X: TipoElemento): Errores;
begin
  Agregar := CError;
  if EsLlena then
    Agregar := LLena
  else begin
    Final := Final+1;
    Elementos[Final] := X;
    Inc(Q_Items);
    if EsVacia then Inicio := Final;
    Agregar := ok;
  end;
end;

//inserta un elemento entre el inicio y el final de la lista
Function Lista.Insertar(X: TipoElemento; P: PosicionLista): Errores;
Var Q: PosicionLista;
begin
  Insertar :=  CError;
  if EsLlena then
    Insertar := LLena
  else begin
    if ValidarPosicion(P) then begin
      for Q := Final DownTo P do
        Elementos[Q+1] := Elementos[Q]; // genera Hueco para el item a insertar
      Elementos[p] := X;
      Insertar := PosicionInvalida;
      Inc(Final);
      Inc(Q_Items);
      Insertar := ok;
    end
    else
      Insertar := PosicionInvalida;
  end;
end;

Function Lista.Ordinal(PLogica: Integer): PosicionLista;
begin
  Ordinal := PLogica;
end;

//elimina un elemento de la lista, por posicion valida
Function Lista.Eliminar(P: PosicionLista): Errores;
Var Q: PosicionLista;
begin
  Eliminar := CError;

  if EsVacia then
    Eliminar := Vacia
  else begin
    if ValidarPosicion(P) then begin
      for Q := p to (Final-1) do
        Elementos[Q] := Elementos[Q+1]; //aplastando el item a borrar

      Dec(Final);
      Dec(Q_Items);
      if Final < Inicio then
      Crear();
      Eliminar := ok;
    end
    else
      Eliminar := PosicionInvalida;
  end;
end;

// busca un elemento dentro de la lista, en funcion de un dato
Function Lista.Buscar(X: TipoElemento; ComparaPor: CampoComparar): PosicionLista;
Var Q : PosicionLista;
    Encontre : Boolean;
begin
  Buscar := Nulo;
  Encontre := false;
  Q := Inicio;
  while (Q <> Nulo) and (Q <= Final) And Not (Encontre) do begin
    if Elementos[Q].CompararTE(X, ComparaPor) = igual then Encontre := True
    Else Q := Q+1;
  end;
end;

// retorna la siguiente posicion de p, o Nulo
Function Lista.Siguiente(P: PosicionLista): PosicionLista;
begin
  if(ValidarPosicion(P)) and (P < Inicio) then Siguiente := p+1
  else Siguiente := Nulo;
end;

// retorn la siguiente posicion de p, o nulo
Function Lista.Anterior(P: PosicionLista): PosicionLista;
begin
  if(ValidarPosicion(P)) and (P > Inicio) then Anterior := p-1
  else Anterior := Nulo;
end;

Function Lista.ValidarPosicion(P: PosicionLista): Boolean;
begin
  ValidarPosicion := false;
  if not EsVacia and (p >= Inicio) and (p <= Final) then ValidarPosicion := true;
end;

// devuelve por referencia un valor de la lista(se pasa x como referencia)
Function Lista.Recuperar(Var X: TipoElemento; P: PosicionLista): Errores;
begin
  Recuperar := CError;
  if(ValidarPosicion(P)) then begin
    x := Elementos[P];
    Recuperar := OK;
  end;
end;

// reemplaza en la posicion de p, el valor de x en la lista
Function Lista.Actualizar(X: TipoElemento; P: PosicionLista): Errores;
begin
  Actualizar := Cerror;
  if(ValidarPosicion(P)) then begin
    Elementos[P] := X;
    Actualizar := OK;
  end;
end;

// intercambia entre dos posiciones de la misma lista
Procedure Lista.Intercambio(P, Q: PosicionLista);
Var X1, X2: TipoElemento;
begin
  Recuperar(X1, P);
  Recuperar(X2, Q);

  Actualizar(X2, P);
  Actualizar(X1, Q);
end;

Procedure Lista.Sort(ComparaPor: CampoComparar);
Var P, Q: posicionLista;
    X1, X2: TipoElemento;
begin
    X1.Inicializar;
    X2.Inicializar;

    // ordenamiento por burbuja
    P := Inicio;
    while P <> Nulo do begin
      Q := Inicio;
      while Q <> Nulo do begin
        Recuperar(X1, Q);
        if Siguiente(Q) <> Nulo then begin
          Recuperar(X2, Siguiente(Q));
          case ComparaPor of
            CDI: If X1.CompararTE(X2, ComparaPor) = mayor Then Intercambio(Q, Siguiente(Q));
            CDR: If X1.CompararTE(X2, ComparaPor) = mayor Then Intercambio(Q, Siguiente(Q));
            CDS: If X1.CompararTE(X2, ComparaPor) = mayor Then Intercambio(Q, Siguiente(Q));
          End;
          Q := Siguiente(Q);
        end;
        P := Siguiente(P);
      end;
    end;
end;

// Retorna un string con todos los elementos de lista
// Cada campo de cada item separado por Tabuladores
// Cada Item separado por Retorno de Carro + Final de Linea
Function Lista.RetornarString():String;
Var Q: PosicionLista;
    X: TipoElemento;
    S, SS: String;
Begin
  SS:= '';
  Q := Inicio;

  While Q <> Nulo Do Begin
    Recuperar(X, Q);
    S := X.ArmarString;
    SS := SS + S + cCRLF;
    Q := Siguiente(Q);
  End;
  RetornarString := SS;
End;

Function Lista.Comienzo(): PosicionLista;
begin
  Comienzo := Inicio;
end;

Function Lista.Fin(): PosicionLista;
begin
  Fin := Final;
end;

Function Lista.CantidadElementos(): LongInt;
begin
  CantidadElementos := Q_Items;
end;

Function Lista.LlenarRandom(RangoHasta: LongInt): Errores;
Var X: TipoElemento;
begin
  LlenarRandom := CError;
  Crear;
  X.Inicializar;
  Randomize;
  while not EsLlena do begin
    X.DI := Random(RangoHasta);
    Agregar(X);
  end;
  LlenarRandom := OK;
end;

end .
