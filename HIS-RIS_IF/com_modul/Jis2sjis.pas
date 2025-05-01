unit jis2sjis;
{
���@�\�����i�g�p�\��F����j
--------------------------------------------------------------------------------
������������������������������ JIS << - >> Shift JIS �ϊ��v���O���� for DELPHI 3
  �C���^�[�l�b�g�A�v���P�[�V�����쐬�̂��߂̕����R�[�h�ϊ����j�b�g ---
  ISO-2022-JP�����Z�b�g���쐬���邱�Ƃ��ł��܂��̂Ń��[���Ȃǂ̑���M���ł��܂�

  �P�D�������JIS����ShiftJIS�ɃR�[�h�ϊ�����
    function JisToSJis(const s: AnsiString): AnsiString
                            s��JIS��������w�肷���ShiftJIS�R�[�h���߂�l�ɓ���

  �Q�D�������ShiftJIS����JIS�ɃR�[�h�ϊ�����
    function SJisToJis(const s: AnsiString): AnsiString
                            s��ShiftJIS��������w�肷���JIS�R�[�h���߂�l�ɓ���
                            ���p�p�����Ɣ��p���ł͕ϊ�����܂���A
                            JIS(iso-2022-jp)�ł͔��p���ł͔F�߂��Ȃ��̂Ŏ��O��
                            HanToZen���g���đS�p�ɕϊ����Ă���JIS�ɕϊ����邱��
                            �܂���SJis8ToSJis7�Ŕ��p���ł��V�r�b�g�ϊ�����

  �R�D������Ɋ܂܂��u���p�J�i(ASCII)�v���u�S�p�J�i(ShiftJIS)�v�ɕϊ�����
    function HanToZen (const s: AnsiString): AnsiString
                            ���_�J�i����_���Q�o�C�g�R�[�h�ɕϊ�����

  �S�D������Ɋ܂܂��u���p�J�i(ASCII)�v���u�S�p�J�i(ShiftJIS)�v�ɕϊ�����
    function HanToZen2 (const s: AnsiString): AnsiString
                            ���_�͑��_�Ƃ��ĕʁX�ɕϊ�����
  �T�D������Ɋ܂܂��u���p�J�i(ASCII)�v��SO����7�ޯĂɕϊ�����
    function SJis8ToSJis7(const s: AnsiString): AnsiString;
  �U�D������Ɋ܂܂��SO����7�ޯāu���p�J�i(ASCII)�v��8�ޯĂɕϊ�����
    function SJis7ToSJis8(const s: AnsiString): AnsiString;

������������������������������ �v�����R�[�h�ϊ��v���O����
  �v�����T�[�o���Ŏg�p���Ă���R�[�h�ϊ��ł�
  �W�r�b�g�ڂ������Ă��镶����%nn�̌`�ŃG���R�[�h�^�f�R�[�h���܂�

  �P�D�v�����R�[�h�ɃG���R�[�h����
    function WebEncode(const s: AnsiString): AnsiString;
                            ��������łW�r�b�g�ڂ��h�P�h�̕������P�U�i�\�L�h%nn�h
                            �ɕϊ�����

  �Q�D�v�����R�[�h���f�R�[�h����
    function WebDecode(const s: AnsiString): AnsiString;
                            ��������̃G���R�[�h���ꂽ%nn������ʏ�̕����ɕϊ�
                            ����

--------------------------------------------------------------------------------
������
�V�K�쐬�F2000.12.05�F�S�� iwai
�I���W�i���̃o�O���C��

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

///// JIS7�R�[�h��JIS8�R�[�h�ɕϊ� - 1byte
function Jis7_Jis8(c0: byte): byte;
begin
  result := c0;
  if ( $21 <= c0 ) and ( c0 <= $5F) then
  begin
    result :=   result + $80;
  end;
end;
///// JIS8�R�[�h��JIS7�R�[�h�ɕϊ� - 1byte
function Jis8_Jis7(c0: byte): byte;
begin
  result := c0;
  if ( $A1 <= c0 ) and ( c0 <= $DF) then
  begin
    result :=   result - $80;
  end;
end;
///// JIS�R�[�h��SJIS�R�[�h�ɕϊ� - 1����
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

///// SJIS�R�[�h��JIS�R�[�h�ɕϊ� - 1����
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

///// ���_��
function IsDakuten (c: AnsiChar): boolean;
var i: byte;
begin
  i := Byte(c);
  if  ((i >= 182) and (i <= 196))
   or ((i >= 202) and (i <= 206))
   or  (i = 179)  then result := true
  else result := false;
end;

///// �����_��
function IsHanDakuten (c: AnsiChar): boolean;
var i: byte;
begin
  i := Byte(c);
  if (i >= 202) and (i <= 206) then result := true
  else result := false;
end;

///// ���p�J�^�J�i��
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
///// SJIS7�R�[�h��SJIS8�R�[�h�ɕϊ�
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
    if (Byte(s[i])= G_SO ) then //�J�i�J�n
    begin
      flg := true;
      i   := i + 1;
    end;
    if (byte(s[i]) = G_SI) then  //�J�i�I��
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
///// SJIS8�R�[�h��SJIS7�R�[�h�ɕϊ�
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
    if (ByteType(s,i) = mbSingleByte) then   //1�o�C�g����
    begin
      if (( $A1 <= Byte(s[i]) ) and ( Byte(s[i]) <= $DF)) then //�J�^�J�i
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
    if (ByteType(s,i) = mbSingleByte) then   //1�o�C�g����
    begin
      if (( $A1 <= Byte(s[i]) ) and ( Byte(s[i]) <= $DF)) then //�J�^�J�i
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

///// JIS�R�[�h��SJIS�R�[�h�ɕϊ�
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

///// SJIS�R�[�h��JIS�R�[�h�ɕϊ�
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
    if ByteType(s,i) = mbLeadByte then   //2 �o�C�g�����̑� 1 �o�C�g
    begin
      if not flg2Byte then //New Kanji
      begin
        flg2Byte    := true;
        Result := Result + Chr($1B) + '$B'; //Kanji IN �ǉ�
      end;
      Result := Result + Sjis_Jis(s[i],s[i+1]);
      inc(i);
    end else
    begin   //1 �o�C�g����ANK �����C���Ȃ킿 ASCII �����������͔��p�J�^�J�i�ł���
      if flg2Byte then
      begin
        flg2Byte    := false;
        Result := Result + Chr($1B) + '(B'; //Kanji OUT �ǉ�
      end;
      Result := Result + s[i];
    end;
    inc(i);
  end;
  if flg2Byte then Result := Result + Chr($1B) + '(B'; //�Ō��Ascii�ɂ���
end;

///// Ascii 8bit ���p�J�^�J�i��SJIS �S�p�R�[�h�ɕϊ� ���_���肠��
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
    //��P�A�Q�o�C�g���e�[�u������
    c0 := s[i];
    c1 := Char(0);
    if i < len then //2001.02.16
    c1 := s[i+1];
    //�P�o�C�g�ڂ����p�����łȂ��Ȃ�X�L�b�v
    if (not IsHanKana(c0)) or (not (ByteType(s,i) = mbSingleByte)) then
    begin
      result := result + c0;
      inc(i);
      continue;
    end;
    //FLAG ������
    fDaku := false; fHandaku := false; fDbyte := false;
    //���_�`�F�b�N
    if Byte(c1) = 222 then
    begin
      if IsDakuten(c0) then fDaku := true;
    //�����_�`�F�b�N
    end else if Byte(c1) = 223 then
      if IsHanDakuten(c0) then fHandaku := true;
    //�e�[�u���ϊ�
    b0 := CODE_TABLE[byte(c0)-161,0];
    b1 := CODE_TABLE[byte(c0)-161,1];
    //���_�̏ꍇ
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

///// Ascii 8bit ���p�J�^�J�i��SJIS �S�p�R�[�h�ɕϊ� ���_����Ȃ�
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
    //��P�A�Q�o�C�g���e�[�u������
    c0 := s[i];
    //�P�o�C�g�ڂ����p�����łȂ��Ȃ�X�L�b�v
    if (not IsHanKana(c0)) or (not (ByteType(s,i) = mbSingleByte)) then
    begin
      result := result + c0;
      inc(i);
      continue;
    end;
    //�e�[�u���ϊ�
    if Byte(c0) = 222 then {���_}
    begin
      b0 := $81;  //129
      b1 := $4a;  // 74
    end else
    if Byte(c0) = 223 then {�����_}
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

///// Hex(Char)��integer(Byte)�ɕϊ�
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

///// integer(Char)��Hex(Char X 2)�ɕϊ�
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


///// ��������łW�r�b�g�ڂ��h�P�h�̕������P�U�i�\�L�h%nn�h�ɕϊ�
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

///// ���������%nn������ʏ�̕����ɕϊ�
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
