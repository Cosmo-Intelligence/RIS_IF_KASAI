unit jis2sjis;
{
■機能説明（使用予定：あり）
--------------------------------------------------------------------------------
★★★★★★★★★★★★★★★ JIS << - >> Shift JIS 変換プログラム for DELPHI 3
  インターネットアプリケーション作成のための文字コード変換ユニット ---
  ISO-2022-JP文字セットを作成することができますのでメールなどの送受信ができます

  １．文字列をJISからShiftJISにコード変換する
    function JisToSJis(const s: AnsiString): AnsiString
                            sにJIS文字列を指定するとShiftJISコードが戻り値に入る

  ２．文字列をShiftJISからJISにコード変換する
    function SJisToJis(const s: AnsiString): AnsiString
                            sにShiftJIS文字列を指定するとJISコードが戻り値に入る
                            半角英数字と半角ｶﾀｶﾅは変換されません、
                            JIS(iso-2022-jp)では半角ｶﾀｶﾅは認められないので事前に
                            HanToZenを使って全角に変換してからJISに変換すること
                            またはSJis8ToSJis7で半角ｶﾀｶﾅを７ビット変換する

  ３．文字列に含まれる「半角カナ(ASCII)」を「全角カナ(ShiftJIS)」に変換する
    function HanToZen (const s: AnsiString): AnsiString
                            濁点カナを濁点つき２バイトコードに変換する

  ４．文字列に含まれる「半角カナ(ASCII)」を「全角カナ(ShiftJIS)」に変換する
    function HanToZen2 (const s: AnsiString): AnsiString
                            濁点は濁点として別々に変換する
  ５．文字列に含まれる「半角カナ(ASCII)」をSOつきの7ﾋﾞｯﾄに変換する
    function SJis8ToSJis7(const s: AnsiString): AnsiString;
  ６．文字列に含まれるSOつきの7ﾋﾞｯﾄ「半角カナ(ASCII)」を8ﾋﾞｯﾄに変換する
    function SJis7ToSJis8(const s: AnsiString): AnsiString;

★★★★★★★★★★★★★★★ Ｗｅｂコード変換プログラム
  Ｗｅｂサーバ等で使用しているコード変換です
  ８ビット目がたっている文字を%nnの形でエンコード／デコードします

  １．Ｗｅｂコードにエンコードする
    function WebEncode(const s: AnsiString): AnsiString;
                            文字列内で８ビット目が”１”の文字を１６進表記”%nn”
                            に変換する

  ２．Ｗｅｂコードをデコードする
    function WebDecode(const s: AnsiString): AnsiString;
                            文字列内のエンコードされた%nn部分を通常の文字に変換
                            する

--------------------------------------------------------------------------------
■履歴
新規作成：2000.12.05：担当 iwai
オリジナルのバグを修正

}
interface

  uses SysUtils;
  Const
  G_SO = $0E;
  G_SI = $0F;
  function SJis7ToSJis8(const s: AnsiString): AnsiString;
  function SJis8ToSJis7(const s: AnsiString): AnsiString;
  function SJis8ToSJis7_a(const s: AnsiString): AnsiString;
  function JisToSJis(const s: AnsiString): AnsiString;
  function SJisToJis(const s: AnsiString): AnsiString;
  function HanToZen (const s: AnsiString): AnsiString;
  function HanToZen2(const s: AnsiString): AnsiString;

  function WebEncode(const s: AnsiString): AnsiString;
  function WebDecode(const s: AnsiString): AnsiString;

implementation

const
  CODE_TABLE :
    array[0..62,0..1] of byte =
    ( (129, 66),(129,117),(129,118),(129, 65),(129, 69),(131,146),(131, 64),
      (131, 66),(131, 68),(131, 70),(131, 72),(131,131),(131,133),(131,135),
      (131, 98),(129, 91),(131, 65),(131, 67),(131, 69),(131, 71),(131, 73),
      (131, 74),(131, 76),(131, 78),(131, 80),(131, 82),(131, 84),(131, 86),
      (131, 88),(131, 90),(131, 92),(131, 94),(131, 96),(131, 99),(131,101),
      (131,103),(131,105),(131,106),(131,107),(131,108),(131,109),(131,110),
      (131,113),(131,116),(131,119),(131,122),(131,125),(131,126),(131,128),
      (131,129),(131,130),(131,132),(131,134),(131,136),(131,137),(131,138),
      (131,139),(131,140),(131,141),(131,143),(131,147),(129, 74),(129, 75) );

///// JIS7コードをJIS8コードに変換 - 1byte
function Jis7_Jis8(c0: byte): byte;
begin
  result := c0;
  if ( $21 <= c0 ) and ( c0 <= $5F) then
  begin
    result :=   result + $80;
  end;
end;
///// JIS8コードをJIS7コードに変換 - 1byte
function Jis8_Jis7(c0: byte): byte;
begin
  result := c0;
  if ( $A1 <= c0 ) and ( c0 <= $DF) then
  begin
    result :=   result - $80;
  end;
end;
///// JISコードをSJISコードに変換 - 1文字
function Jis_SJis(c0,c1: AnsiChar): AnsiString;
var
  b0,b1,off: byte;
begin
  b0 := Byte(c0);
  b1 := Byte(c1);
  Result := '';
  if (b0 < $21) or (b0 > $7E) then exit;  //0x21-  0x7E only
  off := $7E;
  if b0 mod 2 = 1 then
    if b1 < $60 then off := $1F else off := $20;  //60  1F  20
  b1 := b1 + off;
  if b0 < $5F then off := $70 else off := $B0;
  b0 := ((b0 + 1) shr 1) + off;
  Result := AnsiChar(b0) + AnsiChar(b1);
end;

///// SJISコードをJISコードに変換 - 1文字
function SJis_Jis(c0,c1: AnsiChar): AnsiString;
var
  b0,b1,adj,off: byte;
begin
  b0 := Byte(c0);
  b1 := Byte(c1);
  Result := '';
  if b0 <= $9F  then off := $70  else off := $B0;
  if b1 < $9F  then adj := 1   else adj := 0;
  b0 := ((b0 - off) shl 1) - adj;
  off := $7E;
  if b1 < $7F then off := $1F else if b1 < $9F then off := $20;
  b1 := b1 - off;
  Result := AnsiChar(b0) + AnsiChar(b1);
end;

///// 濁点か
function IsDakuten (c: AnsiChar): boolean;
var i: byte;
begin
  i := Byte(c);
  if  ((i >= 182) and (i <= 196))
   or ((i >= 202) and (i <= 206))
   or  (i = 179)  then result := true
  else result := false;
end;

///// 半濁点か
function IsHanDakuten (c: AnsiChar): boolean;
var i: byte;
begin
  i := Byte(c);
  if (i >= 202) and (i <= 206) then result := true
  else result := false;
end;

///// 半角カタカナか
function IsHanKana (c: AnsiChar): boolean;
var i: byte;
begin
  i := Byte(c);
  if (i >= 161) and (i <= 223) then result := true
  else result := false;
end;


///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////
///// SJIS7コードをSJIS8コードに変換
function SJis7ToSJis8(const s: AnsiString): AnsiString;
var
i: integer;
flg: boolean;
begin
  flg := false;
  Result := '';
  i := 1;
  while (i <= Length(s)) do
  begin
    if (Byte(s[i])= G_SO ) then //カナ開始
    begin
      flg := true;
      i   := i + 1;
    end;
    if (byte(s[i]) = G_SI) then  //カナ終了
    begin
      flg := false;
      i   := i + 1;
    end;

    if flg and (ByteType(s,i) = mbSingleByte) then
    begin
      Result := Result + Chr(Jis7_Jis8(Byte(s[i])));
    end
    else
    begin
      Result := Result + s[i];
    end;
    inc(i);
  end;
end;
///// SJIS8コードをSJIS7コードに変換
function SJis8ToSJis7(const s: AnsiString): AnsiString;
var
i: integer;
flg1Byte: boolean;
begin
  flg1Byte := false;
  Result := '';
  i := 1;
  while (i <= Length(s)) do
  begin
    if (ByteType(s,i) = mbSingleByte) then   //1バイト文字
    begin
      if (( $A1 <= Byte(s[i]) ) and ( Byte(s[i]) <= $DF)) then //カタカナ
      begin
        if (not flg1Byte) then //
        begin
          flg1Byte    := true;
        end;
      end;
      Result := Result + Chr(Jis8_Jis7(Byte(s[i])));
      inc(i);
    end
    else
    begin
      inc(i);
    end;
  end;
  if flg1Byte then result := Chr(G_SO) + result + Chr(G_SI);
end;
function SJis8ToSJis7_a(const s: AnsiString): AnsiString;
var
i: integer;
flg1Byte: boolean;
begin
  flg1Byte := true;
  Result := '';
  i := 1;
  while (i <= Length(s)) do
  begin
    if (ByteType(s,i) = mbSingleByte) then   //1バイト文字
    begin
      if (( $A1 <= Byte(s[i]) ) and ( Byte(s[i]) <= $DF)) then //カタカナ
      begin
        if (not flg1Byte) then //
        begin
          flg1Byte    := true;
          result := result + Chr(G_SO);
        end;
      end
      else if (( $21 <= Byte(s[i]) ) and ( Byte(s[i]) <= $7E)) then
      begin
        if flg1Byte then //
        begin
          flg1Byte    := false;
          result := result + Chr(G_SI);
        end;
      end;
      result := result + Chr(Jis8_Jis7(Byte(s[i])));
      inc(i);
    end
    else
    begin
      Result := Result + s[i];
      inc(i);
    end;
  end;
//  if flg1Byte then result :=  result + Chr(G_SI);
end;

///// JISコードをSJISコードに変換
function JisToSJis(const s: AnsiString): AnsiString;
var
i: integer;
flg: boolean;
begin
  flg := false;
  Result := '';
  i := 1;
  while (i <= Length(s)) do
  begin
    if (Copy(s,i,3) = (chr($1B) + '$B')) then //jis1983 only jis1978 $@ not support
    begin
      flg := true;
      i   := i + 3;
    end;
    if (Copy(s,i,3) = (Chr($1B) + '(B')) then  //ascii only    jis8 (j not support
    begin
      flg := false;
      i   := i + 3;
    end;

    if flg then
    begin
      Result := Result + Jis_Sjis(s[i],s[i+1]);
      inc(i);
    end
    else
    begin
      Result := Result + s[i];
    end;
    inc(i);
  end;
end;

///// SJISコードをJISコードに変換
function SJisToJis(const s: AnsiString): AnsiString;
var
i: integer;
flg2Byte: boolean;
begin
  flg2Byte := false;
  Result := '';
  i := 1;
  while (i <= Length(s)) do
  begin
    if ByteType(s,i) = mbLeadByte then   //2 バイト文字の第 1 バイト
    begin
      if not flg2Byte then //New Kanji
      begin
        flg2Byte    := true;
        Result := Result + Chr($1B) + '$B'; //Kanji IN 追加
      end;
      Result := Result + Sjis_Jis(s[i],s[i+1]);
      inc(i);
    end else
    begin   //1 バイト文字ANK 文字，すなわち ASCII 文字もしくは半角カタカナである
      if flg2Byte then
      begin
        flg2Byte    := false;
        Result := Result + Chr($1B) + '(B'; //Kanji OUT 追加
      end;
      Result := Result + s[i];
    end;
    inc(i);
  end;
  if flg2Byte then Result := Result + Chr($1B) + '(B'; //最後にAsciiにする
end;

///// Ascii 8bit 半角カタカナをSJIS 全角コードに変換 濁点判定あり
function HanToZen (const s: AnsiString): AnsiString;
var
  c0,c1: AnsiChar;
  b0,b1: Byte;
  fDaku,fHandaku,fDbyte: boolean;
  i,len: integer;
begin
  Result := '';
  len := length(s);
  i := 1;
  While (i <= len) do
  begin
    //第１、２バイトをテーブルから
    c0 := s[i];
    c1 := Char(0);
    if i < len then //2001.02.16
    c1 := s[i+1];
    //１バイト目が半角仮名でないならスキップ
    if (not IsHanKana(c0)) or (not (ByteType(s,i) = mbSingleByte)) then
    begin
      result := result + c0;
      inc(i);
      continue;
    end;
    //FLAG 初期化
    fDaku := false; fHandaku := false; fDbyte := false;
    //濁点チェック
    if Byte(c1) = 222 then
    begin
      if IsDakuten(c0) then fDaku := true;
    //半濁点チェック
    end else if Byte(c1) = 223 then
      if IsHanDakuten(c0) then fHandaku := true;
    //テーブル変換
    b0 := CODE_TABLE[byte(c0)-161,0];
    b1 := CODE_TABLE[byte(c0)-161,1];
    //濁点の場合
    if fDaku then
    begin
      if ((b1 >= 74) and (b1 <= 103)) or ((b1 >= 110) and (b1 <=122)) then
      begin
        b1 := b1 + 1;
        fDbyte := true;
      end else if (b0 = 131) and (b1 = 69) then
      begin
        b1 := 148;
        fDbyte := true;
      end;
    end else if (fHandaku) and (b1 >= 110) and (b1 <= 122) then
    begin
      b1 := b1 + 2;
      fDbyte := true;
    end;
    result := result + AnsiChar(b0);
    result := result + AnsiChar(b1);
    inc(i);
    if fDbyte then inc(i);
  end;{while}
end;

///// Ascii 8bit 半角カタカナをSJIS 全角コードに変換 濁点判定なし
function HanToZen2 (const s: AnsiString): AnsiString;
var
  c0   : AnsiChar;
  b0,b1: Byte;
  i,len: integer;
begin
  Result := '';
  len := length(s);
  i := 1;
  While (i <= len) do
  begin
    //第１、２バイトをテーブルから
    c0 := s[i];
    //１バイト目が半角仮名でないならスキップ
    if (not IsHanKana(c0)) or (not (ByteType(s,i) = mbSingleByte)) then
    begin
      result := result + c0;
      inc(i);
      continue;
    end;
    //テーブル変換
    if Byte(c0) = 222 then {濁点}
    begin
      b0 := $81;  //129
      b1 := $4a;  // 74
    end else
    if Byte(c0) = 223 then {半濁点}
    begin
      b0 := $81;  //129
      b1 := $4b;  // 75
    end else
    begin
      b0 := CODE_TABLE[byte(c0)-161,0];
      b1 := CODE_TABLE[byte(c0)-161,1];
    end;
    //
    result := result + AnsiChar(b0);
    result := result + AnsiChar(b1);
    inc(i);
  end;{while}
end;


///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////

///// Hex(Char)をinteger(Byte)に変換
function Hex2Int(c: AnsiChar): Byte;
begin
  result := 0;
  if ('0' <= c) and (c <= '9') then
    result := Byte(c) - Byte('0')
  else if ('a' <= c) and (c <= 'f') then
    result := Byte(c) - Byte('a') + 10
  else if ('A' <= c) and (c <= 'F') then
    result := Byte(c) - Byte('A') + 10;
end;

///// integer(Char)をHex(Char X 2)に変換
function Int2Hex(c: AnsiChar): AnsiString;
var
  i0,i1: Integer;
  b: Byte;
begin
  result := '';
  b := Byte(c);
  i0 := b shr 4;
  i1 := b and $0F;
  //
  if (0 <= i0) and (i0 <= 9) then
    result := AnsiChar(i0 + Integer('0'))
  else if (10 <= i0) and (i0 <= 15) then
    result := AnsiChar((i0 - 10) + Integer('a'));
  //
  if (0 <= i1) and (i1 <= 9) then
    result := result + AnsiChar(i1 + Integer('0'))
  else if (10 <= i1) and (i1 <= 15) then
    result := result + AnsiChar((i1 - 10) + Integer('a'));
end;


///// 文字列内で８ビット目が”１”の文字を１６進表記”%nn”に変換
function WebEncode(const s: AnsiString): AnsiString;
var
  i: Integer;
  b: Byte;
begin
  Result := '';
  i := 1;
  while (i <= length(s)) do
  begin
    b := Byte(s[i]);
    if (b shr 7) = 1 then
      Result := Result + '%' + Int2Hex(s[i])
//    else if not(ByteType(s,i) = mbSingleByte) then
//      Result := Result + '%' + Int2Hex(s[i])
    else
      Result := Result + s[i];
    inc(i);
  end;
end;

///// 文字列内の%nn部分を通常の文字に変換
function WebDecode(const s: AnsiString): AnsiString;
var
  i:     Integer;
  h,l :  Byte;
  sbyte: AnsiChar;
begin
  Result := '';
  i := 1;
  while (i <= length(s)) do
  begin
    sbyte := s[i];
    inc(i);
    if sbyte = '%' then
    begin
      sbyte := s[i];
      inc(i);
      h := Hex2Int(sbyte);
      sbyte := s[i];
      inc(i);
      l := Hex2Int(sbyte);
      sbyte := Char(h*16 + l);
    end;
    if sbyte = '+' then sbyte := ' ';  { '+' ==>> ' ' }
    Result := Result + sbyte;
  end;
end;



end.
