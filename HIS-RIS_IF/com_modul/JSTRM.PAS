unit jstrm;
{  ファイル名:  JStrM.PAS   1.1

   説明 :日本語（２バイトコード）文字列を処理する関数を集めた物
          特徴としては，Delphi 1.0 , 2.0で共通に使用できることと、ほとんどの
          関数で２バイトコードの判定にIsDBCSLeadByte()を使っているので、他の
          言語にも使用可能であることである。

   インターフェース:
     function IsSecond(const ASource : String; const AIndex : Integer): Boolean;
     　　ASource[AIndex]の１バイトが２バイトコードの２バイト目かどうかを判定す
         る。２バイト目ならTrue。1バイト目もしくはアスキーコードであればfalse
         を返す。判定にはIsDBCSLeadByte()を使っているので、使用システムのコント
         ロールパネルで設定した言語に従って判定される。
         また、文字列を先頭から見ていくことはしないので、長い文字列の途中の一
         バイトの判定には有効である。
         AIndexにASourceの範囲を越えた値を指定するとExceptionが上がるので注意
         されたい。

     function MtoB(S: string; AMoji: Integer): Integer;
         S文字列において先頭からAMoji番目の文字が何バイト目に相当するかを返す。
         ただし、最後が２バイトコードの場合には１バイト目のインデックスを返す
         ので、この戻り値をもとに文字数分のバッファを確保しようとする場合には
         注意が必要である。

     function BtoM(S: string; AByte: Integer): Integer;
         S文字列においてAByte目が何文字目にあたるかを返す。

     function JCopy(S: String; Index, Count: Integer): String;
         Copy関数の日本語対応版である。Countには文字数を渡す

     procedure JDelete(var S: string; Index, Count: Integer);
         Delete関数の日本語対応版である。Index, Countには文字数を渡す

     procedure JInsert(Source: string; var S: string; Index: Integer);
         Insert関数の日本語対応版である。Indexには文字数を渡す

     function JLength(S: String): Integer;
         Length関数の日本語対応版である。戻り値は文字数である。

     function JPos(Substr: String; S: String): Integer;
         Pos関数の日本語対応版である。SubStrの存在する位置を文字数で返す

     function JPosByte( substr: string; s : string ) : Integer;
     　　Pos関数の日本語対応版である。SubStrの存在する位置をバイト数で返す。

     function JToken(var s : string; delimita : string ): string;
         デリミタで区切られた文字列を分割して返す。たとえば
         s = '日本語|にほんご,ニホンゴ Ｎｉｈｏｎｇｏ',  delimita = ',| '
         のようによびだすと
         s = 'にほんご,ニホンゴ Ｎｉｈｏｎｇｏ', Result = '日本語'
         のようにもとの文字列からデリミタまでの文字列を切り出して返す。
         このときデリミタは戻り値には含まれないので注意する必要がある。
         また、delimitaの文字がsに含まれない場合にはResultにはもとのS
         が返され、Sには空文字列が入るので注意すること
         なお、delimitaには２バイトコードは指定できない。（誤動作する）

     function JTrim( const source : string ): string;
     　　sourceの前後のスペースを取り除いた文字列を返す。全角スペースもとりのぞ
     　　く。ただし、この関数はスペースの判定にシフトJISのスペースかどうかでみ
     　　ているので、他のコード体系には対応しないので注意が必要である。

     function JUniCase( const source : string ): string;
         小文字を大文字にそろえる。全角アルファベットや記号,数字はASCIIにする。
         半角カタカナは全角カタカナにする。

     Version Up 1.0 -> 1.1
      JDeleteで最後の文字を消去しようとすると例外が発生するバグを修正
　　　JUniCaseを追加

     コメント:
         本ソースコードの配布および使用にあたっての改変は自由に行ってかまいません。

     サポート:
         PXK04012@niftyserve.or.jpにメールにてご連絡ください。


   　                        Created By Makoto Muramatsu( PXK04012 ) }

interface

{ASource文字列においてAIndex目がダブルコードの２バイト目かどうかを判定する。}
function IsSecond(const ASource : String; const AIndex : Integer): Boolean;

{文字数をバイト数にして返す}
function MtoB(S: string; AMoji: Integer): Integer;

{バイト数を文字数にして返す}
function BtoM(S: string; AByte: Integer): Integer;

{日本語文字列に対応したCopy}
function JCopy(S: String; Index, Count: Integer): String;

{日本語文字列に対応したDelete}
procedure JDelete(var S: string; Index, Count: Integer);

{日本語文字列に対応したInsert}
procedure JInsert(Source: string; var S: string; Index: Integer);

{日本語文字列に対応した文字数}
function JLength(S: String): Integer;

{日本語文字列に対応したPos関数(２バイトコードを１文字と数える)}
function JPos(Substr: String; S: String): Integer;

{日本語文字列に対応したPos関数(バイト数を返す)}
function JPosByte( substr: string; s : string ) : Integer;

{デリミタで区切られた文字列をとりだす。}
function JToken(var s : string; delimita : string ): string;

{文字列の前後のスペースを取り除く}
function JTrim( const source : string ): string;

{文字列を大文字にそろえる。全角アルファベットや記号は半角にする。
半角カタカナは全角カタカナにする。}
function JUniCase( const source : string ): string;

implementation

uses SysUtils, WinTypes, WinProcs;

const
  kana : array [$A1..$DD] of WORD = (
         $8142, $8175, $8176, $8141, $8145, $8392, $8340,
  $8342, $8344, $8346, $8348, $8383, $8385, $8387, $8362,
  $815b, $8341, $8343, $8345, $8347, $8349, $834a, $834c,
  $834e, $8350, $8352, $8354, $8356, $8358, $835a, $835c,
  $835e, $8360, $8363, $8365, $8367, $8369, $836a, $836b,
  $836c, $836d, $836e, $8371, $8374, $8377, $837a, $837d,
  $837e, $8380, $8381, $8382, $8384, $8386, $8388, $8389,
  $838a, $838b, $838c, $838d, $838f, $8393);
  daku : array [$A1..$DD] of WORD = (
         $8142, $8175, $8176, $8141, $8145, $8392, $8340,
  $8342, $8344, $8346, $8348, $8383, $8385, $8387, $8362,
  $815b, $8341, $8343, $8394, $8347, $8349, $834b, $834d,
  $834f, $8351, $8353, $8355, $8357, $8359, $835b, $835d,
  $835f, $8361, $8364, $8366, $8368, $8369, $836a, $836b,
  $836c, $836d, $836f, $8372, $8375, $8378, $837b, $837d,
  $837e, $8380, $8381, $8382, $8384, $8386, $8388, $8389,
  $838a, $838b, $838c, $838d, $838f, $8393);
  handaku : array [$A1..$DD] of WORD = (
         $8142, $8175, $8176, $8141, $8145, $8392, $8340,
  $8342, $8344, $8346, $8348, $8383, $8385, $8387, $8362,
  $815b, $8341, $8343, $8345, $8347, $8349, $834a, $834c,
  $834e, $8350, $8352, $8354, $8356, $8358, $835a, $835c,
  $835e, $8360, $8363, $8365, $8367, $8369, $836a, $836b,
  $836c, $836d, $8370, $8373, $8376, $8379, $837c, $837d,
  $837e, $8380, $8381, $8382, $8384, $8386, $8388, $8389,
  $838a, $838b, $838c, $838d, $838f, $8393);

{function BtoM--------------------------------------------------function BtoM}
Function BtoM(S: string; AByte: Integer): Integer;
{Sにおける日本語のバイト数を、文字数として返す}
var
  p : integer;
begin
  Result := 0;
  p := 1;
  while (AByte > 0 ) and (p <= length( s ) ) do begin
    Inc( Result );
    if IsDBCSLeadByte(BYTE(s[p])) then begin
      Dec( AByte );
      Inc( p );
      if (AByte = 0 ) or ( p = Length(s) ) then break;
    end;
    Dec( AByte );
    Inc( p );
  end;
end;

{function MtoB--------------------------------------------------function MtoB}
Function MtoB(S: string; AMoji: Integer): Integer;
{Sにおける日本語の位置を、バイト数として返す}
var
  len : Integer;
begin
  Result := 1;
  len := Length(s);
  while (AMoji > 1) and ( len > 0) do begin
    if IsDBCSLeadByte(BYTE(s[Result])) then begin
      Inc( Result );
      Dec( len );
    end;
    Dec( AMoji );
    Dec( len );
    Inc( Result );
  end ;
end;

{Function IsSencond------------------------------------------Function IsSecond}
function IsSecond(
  const ASource : String;
  const AIndex : Integer): Boolean;
{Source文字列においてAIndex目がダブルコードの２バイト目かどうかを判定する。}
var
  p : integer;
begin
  if (AIndex < 1 ) or
    (AIndex > Length(ASource) )
     then Raise Exception.Create('Illegal Index');
  if AIndex = 1 then
    Result := false
  else begin
    p := AIndex - 1;
    While p > 0 do begin
      if Not IsDBCSLeadByte( BYTE( ASource[p] )) then break;
      Dec( P );
    end;
    Result := (((AIndex - p) mod 2) = 0);
  end;
end;

{function JPosByte-------------------------------------------function JPosByte}
Function JPosByte;
var
  SearchStr: string;
  len, pos1 : Integer;
begin
  Result := 0;
  len := Length( S );
  repeat
    SearchStr := Copy(s, Result + 1, len - Result);
    pos1 := Pos(Substr, SearchStr);
    if pos1 = 0 then begin
      Result := 0;
      break;
    end;
    Result := Result + pos1;
  until not IsSecond( SearchStr, pos1 );
end;

{function JPos---------------------------------------------------function JPos}
function JPos;
var
  index, moji, len : Integer;
begin
  index := 1;
  moji := 1;
  Result := 0;
  len := length(s) - length(substr) + 1;
  repeat
    if substr[1] = s[index] then begin
      if substr = copy(s, index, length(substr)) then begin
        Result := moji;
        break;
      end;
    end;
    if IsDBCSLeadByte(BYTE(s[index])) then inc( index );
    Inc( index );
    inc( moji );
  until index > len ;
end;

{function JLength---------------------------------------------function JLength}
Function JLength;
var
  index: Integer;
begin
  Result := 0;
  index := 1;
  Repeat
    if IsDBCSLeadByte(BYTE(s[index])) then inc( index );
    Inc(Result);
    Inc(index);
  until index > length(s);
end;

{function JCopy-------------------------------------------------function JCopy}
Function JCopy;
var
  i: Integer;
  moji : Integer;
begin
  Result := '';
  i := 1;
  moji := 1;
  Repeat
    if moji >= Index then begin
      Result := Result + s[i];
      if IsDBCSLeadByte(BYTE(s[i])) then begin
        inc( i );
        Result := Result + s[i];
      end;
    end
    else begin
      if IsDBCSLeadByte(BYTE(s[i])) then Inc(i);
    end;
    inc(moji);
    Inc(i);
  until (i > length(s)) or (moji >= index + count );
end;

{function JInsert----------------------------------------------function JInsert}
{日本語文字列に対応したInsert}
procedure JInsert(Source: string; var S: string; Index: Integer);
var
  I: Integer;
  moji : Integer;
begin
  if Index < 1 then Index := 1;
  moji := 1;
  I := 1;
  Repeat
    if moji = index then begin
      s := Copy( s, 1, I - 1 ) + source + Copy( s, I, Length(S) - I + 1 );
      exit;
    end;
    if IsDBCSLeadByte(BYTE(s[I])) then inc( I );
    Inc(moji);
    Inc(I);
  until I > length(s);
  s := S + source;
end;

{function JDelete----------------------------------------------function JDelete}
{日本語文字列に対応したDelete}
procedure JDelete(var S: string; Index, Count: Integer);
var
  I: Integer;
  moji : Integer;
  deleteByte : Integer;

  function MtoBLocal( max : Integer ): Integer;
  var
    j : integer;
  begin
    j := i;
    while (count > 0) and ( max >= j ) do begin
      if IsDBCSLeadByte(BYTE(s[j])) then begin
        Inc( j );
      end;
      Dec( count );
      Inc( j );
    end ;
    Result := J;
  end;

begin
  if Index < 1 then Index := 1;
  moji := 1;
  I := 1;
  Repeat
    if moji = index then begin
      deleteByte := MtoBLocal( Length(S));
      if deleteByte > length(s) then begin
        s := Copy( s, 1, I - 1 );
      end
      else begin
        if IsSecond(s,deleteByte) then begin
          Inc(DeleteByte);
        end;
        s := Copy( s, 1, I - 1 ) +
          Copy( s, deleteByte, Length(S) - deleteByte + 1 );
      end;
      exit;
    end;
    if IsDBCSLeadByte(BYTE(s[I])) then inc( I );
    Inc(moji);
    Inc(I);
  until I > length(s);
end;

{function JToken------------------------------------------------function JToken}
function JToken(var s : string; delimita : string ): string;
var
  I : Integer;
  J : Integer;
  len : Integer;
  dellen : Integer;
begin
  len := Length( s );
  if (len = 0 ) then begin
    Result := '';
  end
  else if delimita = '' then begin
    Result := s;
    s := '';
  end
  else begin
    dellen := Length( delimita );
    I := 1;
    Repeat
      if Not IsSecond( s, I ) then begin
        for J := 1 to dellen do begin
          if delimita[j] = s[i] then begin
            Result := Copy( s, 1, I - 1 );
            Delete(s, 1, I );
            exit;
          end;
        end;
      end;
      Inc( I );
    Until len < I;
    Result := Copy( s, 1, I - 1 );
    Delete(s, 1, I );
  end;
end;


{function JTrim-------------------------------------------------function JTrim}
function JTrim( const source : string ): string;

  procedure RemoveTopSpace ( var s : string );
  begin
    if length(s) = 0 then exit;
    if BYTE(s[1]) = $20 then begin
      System.Delete( s, 1, 1);
      RemoveTopSpace( s );
    end
    else if (BYTE(s[1]) = $81 ) and
     ( BYTE(s[2]) = $40 ) then begin
     System.Delete( s, 1, 2 );
     RemoveTopSpace( S );
    end;
  end;

  procedure RemoveBottomSpace( var s : string );
  var
    len : integer;
  begin
    if length( s ) = 0 then exit;
    len := Length( s );
    if IsSecond( s, len ) then begin
      if (BYTE(s[len - 1]) = $81) and
        (BYTE(s[len]) = $40 ) then begin
        System.Delete( s, len - 1, 2 );
        RemoveBottomSpace( s );
      end;
    end
    else if BYTE(s[len]) = $20 then begin
      System.Delete( s, len, 1 );
      RemoveBottomSpace( s );
    end;
  end;

begin
  if length( source ) > 0 then begin
    Result := source;
    RemoveTopSpace( Result );
    RemoveBottomSpace( Result );
  end
  else begin
    Result := '';
  end;
end;


function JUniCase( const source: string ): string;
var
  P: PChar;
  i, len: integer;
  wc : WORD;
begin
  P := PChar( source );
  len := length( source );
  i := 1;
  Result := '';
  repeat
    if IsDBCSLeadByte( BYTE( p^ ) ) then begin
      wc := ( BYTE(p^) shl 8 ) or Byte( (p + 1)^ );
      case wc of
        {全角大文字アルファベット->半角大文字アルファベット}
        $8260..$8279: Result := Result + Char((wc and $ff ) - $1F );
         {全角小文字アルファベット->半角大文字アルファベット}
        $8281..$829a: Result := Result + Char((wc and $ff ) - $40 );
        {全角数字->半角数字}
        $824f..$8258 : Result := Result + Char((wc and $ff ) - $1F );
        {全角スペース ->半角スペース}
        $8140 : Result := Result + #$20;
        {全角；、： -> 半角}
        $8146, $8147 : Result := Result + Char((wc and $ff ) - $0c );
        {?}
        $8148 : Result := Result + #$3f;
        {!}
        $8149 : Result := Result + #$21;
        {"}
        $8167, $8168,$818d : Result := Result + #$22;
        {'}
        $8165, $8166,$818c : Result := Result + #$27;
        {#}
        $8194 : Result := Result + #$23;
        {}
        $8190 : Result := Result + #$24;
        {%}
        $8193 : Result := Result + #$25;
        {&}
        $8195 : Result := Result + #$26;
        {(}
        $8169 : Result := Result + #$28;
        {)}
        $816a : Result := Result + #$29;
        {*}
        $8196 : Result := Result + #$2a;
        {+}
        $817b : Result := Result + #$2b;
        {,}
        $8143 : Result := Result + #$2c;
        {-}
        $817c : Result := Result + #$2D;
        {.}
        $8144 : Result := Result + #$2e;
        {/}
        $815e : Result := Result + #$2f;
        {<}
        $8183 : Result := Result + #$3c;
        {=}
        $8181,$81ac : Result := Result + #$3d;
        {>}
        $8184 : Result := Result + #$3c;
        {@}
        $8197 : Result := Result + #$40;
        {[}
        $816d : Result := Result + #$5b;
        {\}
        $818f : Result := Result + #$5c;
        {]}
        $816e : Result := Result + #$5d;
        {^}
        $814f : Result := Result + #$5e;
        {}
        $816f : Result := Result + #$7b;
        {|}
        $8162 : Result := Result + #$7c;
        { }
        $8170 : Result := Result + #$7d;
        { ~ }
        $8160 : Result := Result + #$7e;
        else  Result := Result + p^ + (p + 1)^;
      end;
      Inc( p );
      Inc( i );
    end
    {半角カタカナ}
    else if p^ in [#$a1..#$dd] then begin
      if (p + 1 )^ = #$DE then begin
        wc := daku[ BYTE(p^)];
        Result := Result + Char(wc shr 8 ) + Char(wc and $ff );
        Inc( p );
        Inc( i );
      end
      else if (p + 1)^ = #$DF then begin
        wc := handaku[ BYTE(p^)];
        Result := Result + Char(HIBYTE(wc)) + Char(LOBYTE( wc ));
        Inc(p);
        Inc(i);
      end
      else begin
        wc := kana[ BYTE(p^)];
        Result := Result + Char(HIBYTE(wc)) + Char(LOBYTE( wc ));
      end;;

    end
    {小文字アルファベット}
    else if p^ in [#$61..#$7a] then begin
      Result := Result + Char(BYTE(p^) - $20 );
    end
    else begin
      Result := Result + p^;
    end;
    Inc( p );
    Inc( i );
  until i > len;

end;


end.


