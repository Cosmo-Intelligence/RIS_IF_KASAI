unit KanaRoma;
{
���@�\����
  �J�^�J�i�����[�}���ϊ����[�`��

  ���ϊ��\�̏����l�͌P�ߎ��Ƃ���
  ���ϊ��\��÷��̧�قƂ��邱�Ƃ��\(�������KanaRomaHyo.txt���쐬)

  �����[�}���ƃJ�i�̕ϊ��\�����������[�`��

    function func_Kana_To_Roma_s: Boolean;

    �����F�Ȃ�
    �߂�F�����FTrue�A���s�FFalse

  ���J�^�J�i�����[�}���ϊ����[�`��
    MS-IME2 for Windows�̃��[�}���ƃJ�i�̕ϊ��\

    function func_Kana_To_Roma_n(arg_Kana: string; arg_h,arg_s,arg_c,arg_u: integer): string;

    �����Farg_Kana    //�ϊ����̃J�i
          arg_h       //�����|�u݁v�̈����i0:�P�ߎ��A1:�w�{�����A2:NN�j
          arg_s       //�����|�u��v�̈����i0:�P�ߎ��A1:�w�{�����j
          arg_c       //�����|�u-�v�̈����i0:�ꉹ������ׂ�A1:���̂܂܁j
          arg_u       //���A���̍Ōオ�uU�v�̈����i0:���̂܂܁A1:U�������j
    �߂�F�ϊ����ꂽ���[�}��(���s�����ꍇ�ɂ͋�)

//�����g�p���@�\�i��O���j�F�S������̑S�p�`�F�b�N
func_ALL_ZENKAKU_CHECK(arg_text: string):Boolean;
//�����g�p���@�\�i��O���j�F�S������̔��p�`�F�b�N
func_ALL_HANKAKU_CHECK(arg_text: string):Boolean;
//�����g�p���@�\�i��O���j�F�����ϊ�
func_Moji_Henkan(arg_Moji: string;
                 arg_Flg: Integer  //1:�S�p�����p�A2:���p���S�p�A3:�S�p�Ђ炪�ȁ����p�J�^�J�i
                 ): string;
������
�V�K�쐬�F2002.03.21�F���R
�C�������F

}
interface //*****************************************************************
//�g�p���j�b�g---------------------------------------------------------------
uses
//�V�X�e���|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
  Windows, Messages, SysUtils, Classes, Controls, Dialogs,
  IniFiles, FileCtrl, TcpSocket;

////�^�N���X�錾-------------------------------------------------------------
//type

//�萔�錾-------------------------------------------------------------------
//const

//�ϐ��錾-------------------------------------------------------------------
//var

//�֐��葱���錾-------------------------------------------------------------
//���@�\�i��O���j�F���[�}���ƃJ�i�̕ϊ��\��������
  function func_Kana_To_Roma_s(arg_Mode: integer): Boolean;
//���@�\�i��O���j�F�J�^�J�i�����[�}���ϊ�
// MS-IME2 for Windows�̃��[�}���ƃJ�i�̕ϊ��\
  function func_Kana_To_Roma_n(arg_Kana: string; arg_h,arg_s,arg_c,arg_u: integer): string;
//�����g�p���@�\�i��O���j�F�S������̑S�p�`�F�b�N
  function func_ALL_ZENKAKU_CHECK(arg_text: string):Boolean;
//�����g�p���@�\�i��O���j�F�S������̔��p�`�F�b�N
  function func_ALL_HANKAKU_CHECK(arg_text: string):Boolean;
//�����g�p���@�\�i��O���j�F�����ϊ�
  function func_Moji_Henkan(arg_Moji: string;
                 arg_Flg: Integer  //1:�S�p�����p�A2:���p���S�p�A3:�S�p�Ђ炪�ȁ����p�J�^�J�i
                 ): string;

implementation //**************************************************************

//�g�p���j�b�g---------------------------------------------------------------
//uses

//�萔�錾       -------------------------------------------------------------
const
//���[�}���ƃJ�i�̕ϊ��\(�����l)
//�A�`���s�y�ё��_��
  //̧�ٖ�
  cst_ktr_Kana_Area_File = 'KanaRomaHyo.txt';
  //�����ő吔
  cst_ktr_Kana_Area_Max = 300;
  //�J�i�\
  cst_ktr_Kana_Area : array[0..299] of String =
       (
        '�',	'�',	'�',	'�',	'�',
        '�',	'�',	'�',	'�',	'�',
        '�',	'�',	'�',	'�',	'�',
        '�',	'�',	'�',	'�',	'�',
        '�',	'�',	'�',	'�',	'�',
        '�',	'�',	'�',	'�',	'�',
        '�',	'�',	'�',	'�',	'�',
        '�',	' ',	'�',	' ',	'�',
        '�',	'�',	'�',	'�',	'�',
        '�',	'�',	' ',	' ',	'�',
        ' ',	' ',	'��',   ' ',    ' ',
        '��',	'��',	'��',	'��',	'��',
        '��',	'��',	'��',	'��',	'��',
        '��',	'��',	'��',	'��',	'��',
        '��',	'��',	'��',	'��',	'��',
        '��',	'��',	'��',	'��',	'��',
        '��',	'��',	' ',	'��',	'��',
        '��',	'��',	'��',	'��',	'��',
        '��',	'��',	'��',	'��',	'��',
        '§',	'¨',	' ',	'ª',	'«',
        'ħ',	'Ĩ', 	'ĩ',	'Ī',	'ī',
        '̧',	'̨',	'̩',	'̪',	'̫',
        '�ާ',	'�ި',	' ',	'�ު',	'�ޫ',
        '�ާ',	'�ި',	'�ީ',	'�ު',	'�ޫ',
        '�ާ',	'�ި',	'�ީ',	'�ު',	'�ޫ',
        '��',	'��',	'��', 	'��',	'��',
        '��',	' ',	'��',	' ',	'��',
        '��',	'��',	'��',	'��',	'��',
        '��',	'��',	'��',	'��',	'��',
        'ì',	'è',	'í',	'ê',	'î',
        'Ƭ',	'ƨ',	'ƭ',	'ƪ',	'Ʈ',
        'ˬ',	'˨',	'˭',	'˪',	'ˮ',
        'Ь',	'Ш',	'Э',	'Ъ',	'Ю',
        'ج',	'ب',	'ح',	'ت',	'خ',
        '�ެ',	'�ި',	'�ޭ',	'�ު',	'�ޮ',
        '�ެ',	'�ި',	'�ޭ',	'�ު',	'�ޮ',
        '�ެ',	'�ި',	'�ޭ',	'�ު',	'�ޮ',
        '�ެ',	'�ި',	'�ޭ',	'�ު',	'�ޮ',
        '�ެ',	'�ި',	'�ޭ',	'�ު',	'�ޮ',
        '�߬',	'�ߨ',	'�߭',	'�ߪ',	'�߮',
        '�',	'�', 	'�',	'�',	'�',
        '�',	' ',	'�',	' ',	'�',
        '�',    ' ',    ' ',    ' ',    ' ',
        '�',	'�',	'�',    ' ',    ' ',
        '!',	'"',	'#',	'$',	'%',
        '&',	'''',	'(',	')',	'=',
        '^',	'~',	'\',	'|',	'�',
        '{',	'@',	'`',	'�',	'}',
        ':',	'*',	';',	'+',	'_',
        '�',	'?',	'�',	'>',	'�',
        '<',	'/',    '.',    ' ',    ' ',
        '0',	'1',	'2',	'3',	'4',
        '5',	'6',	'7',	'8',	'9',
        ' ',    ' ',    ' ',    ' ',    ' ',
        ' ',    ' ',    ' ',    ' ',    ' ',
        ' ',    ' ',    ' ',    ' ',    ' ',
        ' ',    ' ',    ' ',    ' ',    ' ',
        ' ',    ' ',    ' ',    ' ',    ' ',
        ' ',    ' ',    ' ',    ' ',    ' ',
        ' ',    ' ',    ' ',    ' ',    ' '
       );
  //���[�}���\(�����l�͌P�ߎ�)
  cst_ktr_Roma_Area : array[0..299] of String =
       (
        'A',	'I',	'U',	'E',	'O',
        'KA',	'KI',	'KU',	'KE',	'KO',
        'SA',	'SI',	'SU', 	'SE',	'SO',
        'TA',	'TI',	'TU',	'TE',	'TO',
        'NA',	'NI',	'NU',	'NE',	'NO',
        'HA',	'HI',	'HU',	'HE',	'HO',
        'MA',	'MI',	'MU',	'ME',	'MO',
        'YA',	' ',	'YU',	' ',	'YO',
        'RA',	'RI',	'RU',	'RE',	'RO',
        'WA',	'O',	' ',	' ',	'N',
        ' ',	' ',	'VU',   ' ',    ' ',
        'GA',	'GI',	'GU',	'GE',	'GO',
        'ZA',	'ZI',	'ZU',	'ZE',	'ZO',
        'DA',	'DI',	'DU',	'DE',	'DO',
        'BA',	'BI',	'BU',	'BE',	'BO',
        'PA',	'PI',	'PU',	'PE',	'PO',
        'WHA',	'WHI',	' ',	'WHE',	'WHO',
        'QWA',	'QWI',	'QWU',	'QWE',	'QWO',
        'SWA',	'SWI',	'SWU',	'SWE',	'SWO',
        'TSA',	'TSI',	' ',	'TSE',	'TSO',
        'TWA',	'TWI',	'TWU',	'TWE',	'TWO',
        'FWA',	'FWI',	'FWU',	'FWE',	'FWO',
        'VA',	'VI',	' ',	'VE',	'VO',
        'GWA',	'GWI',	'GWU',	'GWE',	'GWO',
        'DWA',	'DWI',	'DWU',	'DWE',	'DWO',
        'KYA',	'KYI',	'KYU',	'KYE',	'KYO',
        'QYA',	' ',	'QYU',	' ',	'QYO',
        'SYA',	'SYI',	'SYU',	'SYE',	'SYO',
        'TYA',	'TYI',	'TYU',	'TYE',	'TYO',
        'THA',	'THI',	'THU',	'THE',	'THO',
        'NYA',	'NYI',	'NYU',	'NYE',	'NYO',
        'HYA',	'HYI',	'HYU',	'HYE',	'HYO',
        'MYA',	'MYI',	'MYU',	'MYE',	'MYO',
        'RYA',	'RYI',	'RYU',	'RYE',	'RYO',
        'GYA',	'GYI',	'GYU',	'GYE',	'GYO',
        'ZYA',	'ZYI',	'ZYU',	'ZYE',	'ZYO',
        'ZYA',	'ZYI',	'ZYU',	'ZYE',	'ZYO',
        'DHA',	'DHI',	'DHU',	'DHE',	'DHO',
        'BYA',	'BYI',	'BYU',	'BYE',	'BYO',
        'PYA',	'PYI',	'PYU',	'PYE',	'PYO',
        'LA',	'LI',	'LU',	'LE',	'LO',
        'LYA',	' ',	'LYU',	' ',	'LYO',
        'LTU',  ' ',    ' ',    ' ',    ' ',
        '�',	'�',	'-',    ' ',    ' ',
        '!',	'"',	'#',	'$',	'%',
        '&',	'''',	'(',	')',	'=',
        '^',	'~',	'\',	'|',	'�',
        '{',	'@',	'`',	'�',	'}',
        ':',	'*',	';',	'+',	'_',
        '�',	'?',	'�',	'>',	'�',
        '<',	'/',    '.',    ' ',    ' ',
        '0',	'1',	'2',	'3',	'4',
        '5',	'6',	'7',	'8',	'9',
        ' ',    ' ',    ' ',    ' ',    ' ',
        ' ',    ' ',    ' ',    ' ',    ' ',
        ' ',    ' ',    ' ',    ' ',    ' ',
        ' ',    ' ',    ' ',    ' ',    ' ',
        ' ',    ' ',    ' ',    ' ',    ' ',
        ' ',    ' ',    ' ',    ' ',    ' ',
        ' ',    ' ',    ' ',    ' ',    ' '
       );

//�ϐ��錾     ---------------------------------------------------------------
var
  ktr_Kana_Area : array[0..299] of String;
  ktr_Roma_Area : array[0..299] of String;

//�֐��葱���錾--------------------------------------------------------------

//���@�\�i��O���j�F���[�}���ƃJ�i�̕ϊ��\��������
function func_Kana_To_Roma_s(
         arg_Mode: integer
         ): Boolean;
var
  w_t: integer;
  TxtFile: TextFile;
  w_Record: string[255];
  w_tStr: TStringList;
  w_kbn: string;
  w_k,w_r: integer;
begin
  Result := True;
  for w_t := 0 to (cst_ktr_Kana_Area_Max - 1) do begin
    ktr_Kana_Area[w_t] := cst_ktr_Kana_Area[w_t];
    ktr_Roma_Area[w_t] := cst_ktr_Roma_Area[w_t];
  end;
  //�ϊ��\̧�ّ��݃`�F�b�N
  if not(FileExists(g_TcpIniPath + cst_ktr_Kana_Area_File)) then Exit;
  //�ϊ��\̧�ق��ǂݍ���
  AssignFile(TxtFile, g_TcpIniPath + cst_ktr_Kana_Area_File);
  Reset(TxtFile);
  w_tStr := TStringList.Create;
  w_k := 0;
  w_r := 0;
  try
    while not Eof(TxtFile) do
    begin
      Readln(TxtFile, w_Record);
      if Copy(w_Record,1,2) = '//' then Continue;
      if (w_Record = '') or (w_Record = ' ') then Continue;
//2002.11.05
      if Copy(w_Record,Length(w_Record),1) = ',' then
        w_Record := Copy(w_Record,1,Length(w_Record)-1);
      //����
      w_kbn := Copy(w_Record,1,1);
      w_tStr.CommaText := Copy(w_Record,4,Length(w_Record)-4+1);
      for w_t := 0 to w_tStr.Count - 1 do begin
        //�J�i
        if w_kbn = 'K' then begin
          if w_k < 300 then
            ktr_Kana_Area[w_k] := w_tStr.Strings[w_t];
          w_k := w_k + 1;
        end
        //۰ώ�
        else if w_kbn = 'R' then begin
          if w_r < 300 then
            ktr_Roma_Area[w_r] := w_tStr.Strings[w_t];
          w_r := w_r + 1;
        end;
      end;
    end;
  finally
    CloseFile(TxtFile);
    w_tStr.Free;
  end;
end;
//���@�\�i��O���j�F�J�^�J�i�����[�}���ϊ�
// MS-IME2 for Windows�̃��[�}���ƃJ�i�̕ϊ��\
function func_Kana_To_Roma_n(
         arg_Kana: string;
         arg_h,
         arg_s,
         arg_c,
         arg_u: integer
         ): string;
var
  w_i,w_ii,w_t: integer;
  w_Get_Kana,w_Get_Roma: string;
  w_Roma: string;
  w_Before_Kana,w_After_Kana: string;
  w_LTU: Boolean;
begin
  //������
  Result := '';
  arg_Kana := Trim(arg_Kana);
  w_Roma := '';
  w_LTU := False;
  //�P�����Â���
  w_i := 1;
  while w_i <= (Length(arg_Kana)) do
  begin
    w_Get_Kana := Copy(arg_Kana,w_i,1);
    w_After_Kana := Copy(arg_Kana,w_i+1,1);
    w_Before_Kana := Copy(arg_Kana,w_i-1,1);
    w_ii := w_i;
    //�u��v�͎��ŏ�������̂Ŕ�΂�
    if (w_Get_Kana = '�') then begin
      if w_LTU = True then begin
        w_Roma := w_Roma + 'LTU';
      end;
      w_LTU := True;
      w_i := w_i + 1;
      Continue;
    end;
    //�uށv�A�u߁v�͌������ď�������
    if (w_After_Kana = '�') or (w_After_Kana = '�') then begin
      w_Get_Kana := w_Get_Kana + w_After_Kana;
      w_i := w_i + 1;
      //�X�ɂ��̎�������
      w_After_Kana := Copy(arg_Kana,w_i+1,1);
    end;
    //�u��v�u��v�u��v�u��v�u��v
    //�u��v�u��v�u��v�u��v�u��v
    //�͌������ď�������
    if (w_After_Kana = '�') or
       (w_After_Kana = '�') or
       (w_After_Kana = '�') or
       (w_After_Kana = '�') or
       (w_After_Kana = '�') or
       (w_After_Kana = '�') or
       (w_After_Kana = '�') or
       (w_After_Kana = '�') then begin
      w_Get_Kana := w_Get_Kana + w_After_Kana;
      w_i := w_i + 1;
      //�X�ɂ��̎�������
      w_After_Kana := Copy(arg_Kana,w_i+1,1);
    end;
    //�u��v�͐��A���̍Ō�ł���Δ�΂�
    if (w_Get_Kana = '�') then begin
      if (w_After_Kana = '')  or
         (w_After_Kana = ' ') then begin
        if arg_u = 1 then begin
          w_Get_Kana := w_After_Kana;
          w_i := w_i + 1;
          //�X�ɂ��̎�������
          w_After_Kana := Copy(arg_Kana,w_i+1,1);
        end;
      end;
    end;

    w_Get_Roma := '';
    w_t := 0;
    while w_t <= (cst_ktr_Kana_Area_Max - 1) do begin
      if ktr_Kana_Area[w_t] = w_Get_Kana then begin
        w_Get_Roma := ktr_Roma_Area[w_t];
        w_t := cst_ktr_Kana_Area_Max;
      end;
      w_t := w_t + 1;
    end;
    if w_Get_Roma = '' then begin
      if w_ii <> w_i then begin
        w_i := w_ii;
        w_Get_Kana := Copy(arg_Kana,w_i,1);
        while w_t <= (cst_ktr_Kana_Area_Max - 1) do begin
          if ktr_Kana_Area[w_t] = w_Get_Kana then begin
            w_Get_Roma := ktr_Roma_Area[w_t];
            w_t := cst_ktr_Kana_Area_Max;
          end;
          w_t := w_t + 1;
        end;
      end;
    end;

    if (w_Get_Roma = '') then begin
      if w_LTU = True then begin
        w_Get_Roma := 'LTU';
        w_LTU := False;
      end;
      w_Get_Roma := w_Get_Roma + ' ';
    end
    else if (w_Get_Roma = ' ') then begin
      if w_LTU = True then begin
        w_Get_Roma := 'LTU' + ' ';
        w_LTU := False;
      end;
    end
    else begin
      //�����|�O�Ɂu݁v������ꍇ
      if (w_Before_Kana = '�') then begin
        if ((w_Get_Kana = '�') or
            (w_Get_Kana = '�') or
            (w_Get_Kana = '�') or
            (w_Get_Kana = '�') or
            (w_Get_Kana = '�') ) then begin
          if arg_h = 0 then begin //�P�ߎ��|n�̂܂�
            w_Get_Roma := w_Get_Roma;
          end
          else if arg_h = 2 then begin //nn
            w_Get_Roma := 'N' + w_Get_Roma;
          end;
        end;
        if (Copy(w_Get_Roma,1,1) = 'M') or
           (Copy(w_Get_Roma,1,1) = 'B') or
           (Copy(w_Get_Roma,1,1) = 'P') then begin
          if arg_h = 1 then begin //���ݎ��|m,b,p�̑O��n�̕ς��m������
            w_Roma := Copy(w_Roma,1,Length(w_Roma) - 1);
            w_Get_Roma := 'M' + w_Get_Roma;
          end;
        end;
      end;
      //�����|�u��v
      if w_LTU = True then begin
        if arg_s = 0 then begin  //�P�ߎ��|�q�����d�˂�
          w_Get_Roma := Copy(w_Get_Roma, 1, 1) + w_Get_Roma;
        end
        else if arg_s = 1 then begin //���ݎ��|chi,cha,chu,cho�Ɍ���O��t������
          if (w_Get_Roma = 'CHI') or
             (w_Get_Roma = 'CHA') or
             (w_Get_Roma = 'CHU') or
             (w_Get_Roma = 'CHO') then begin
            w_Get_Roma := 'T' + w_Get_Roma;
          end
          else begin //���ݎ��|�q�����d�˂�
            w_Get_Roma := Copy(w_Get_Roma, 1, 1) + w_Get_Roma;
          end;
        end;
        w_LTU := False;
      end;
      //�����|�u-�v
      if w_Get_Roma = '-' then begin
        if arg_c = 0 then begin //�ꉹ������ׂ�
          if Length(w_Roma) > 0 then begin
            w_Get_Roma := Copy(w_Roma,Length(w_Roma),1);
          end
          else begin
            w_Get_Roma := w_Get_Roma;
          end;
        end
        else if arg_c = 1 then begin //���̂܂�
          w_Get_Roma := w_Get_Roma;
        end;
      end;
    end;
    //�P�����Â�����
    w_Roma := w_Roma + w_Get_Roma;
    //����
    w_i := w_i + 1;
  end;

  w_Roma := Trim(w_Roma);
  //�Ō�ɯ���c���Ă���ꍇ
  if w_LTU = True then begin
    w_Roma := w_Roma + 'LTU';
  end;
  //�߂�l
  Result := Trim(w_Roma);
end;
//���@�\�i��O���j�F�S������̑S�p�`�F�b�N
function func_ALL_ZENKAKU_CHECK(arg_text: string):Boolean;
var
  i: integer;
  r: Boolean;
begin
  r := True;
  for i := 1 to Length(Trim(arg_text)) do begin
    if StrByteType(PChar(Trim(arg_text)), i-1) = mbSingleByte then begin
      r := False;
      Break;
    end;
  end;
  Result := r;
end;
//���@�\�i��O���j�F�S������̔��p�`�F�b�N
function func_ALL_HANKAKU_CHECK(arg_text: string):Boolean;
var
  i: integer;
  r: Boolean;
begin
  r := True;
  for i := 1 to Length(Trim(arg_text)) do begin
    if (StrByteType(PChar(Trim(arg_text)), i-1) = mbLeadByte)  or
       (StrByteType(PChar(Trim(arg_text)), i-1) = mbTrailByte) then begin
      r := False;
      Break;
    end;
  end;
  Result := r;
end;
//2002.11.18
//���@�\�i��O���j�F�S������̔��p�`�F�b�N
function func_ALL_HANKAKU_AISUU_CHECK(arg_text: string):Boolean;
var
  i: integer;
  r: Boolean;
  s: String;
begin
  r := True;
  for i := 1 to Length(Trim(arg_text)) do begin
    if (StrByteType(PChar(Trim(arg_text)), i-1) = mbLeadByte)  or
       (StrByteType(PChar(Trim(arg_text)), i-1) = mbTrailByte) then begin
      r := False;
      Break;
    end else begin
      s := Copy(Trim(arg_text), i, 1);
//      if (PChar(s) < #48)
//      or ((PChar(s) > #57) and (PChar(s) < #65))
//      or ((PChar(s) > #90) and (PChar(s) < #97))
//      or (PChar(s) > #122) then begin
      if (PChar(s) < #32)
      or (PChar(s) > #126) then begin
        r := False;
        Break;
      end;
    end;
  end;
  Result := r;
end;
//���@�\�i��O���j�F�����ϊ�
function func_Moji_Henkan(arg_Moji: string;
                          arg_Flg: Integer  //1:�S�p�����p�A2:���p���S�p�A3:�S�p�Ђ炪�ȁ����p�J�^�J�i
                          ): string;
var
  w_Chr:        array [0..255] of char;
  w_MapFlags:   DWORD;
begin
  // �S�p(2�޲�)�����p(1�޲�)�ɕϊ�
  if arg_Flg = 1 then begin
    LCMapString(
                GetUserDefaultLCID(),
                LCMAP_HALFWIDTH,
                PChar(arg_Moji),      //�ϊ����镶����
                Length(arg_Moji) + 1, //�T�C�Y
                w_Chr,                //�ϊ�����
                Sizeof(w_Chr)         //�T�C�Y
               );
  end;
  // ���p(1�޲�)���S�p(2�޲�)�ɕϊ�
  if arg_Flg = 2 then begin
    LCMapString(
                GetUserDefaultLCID(),
                LCMAP_FULLWIDTH,
                PChar(arg_Moji),      //�ϊ����镶����
                Length(arg_Moji) + 1, //�T�C�Y
                w_Chr,                //�ϊ�����
                Sizeof(w_Chr)         //�T�C�Y
               );
  end;
  // �S�p�Ђ炪�ȁ����p�J�^�J�i�ɕϊ�
  if arg_Flg = 3 then begin
    w_MapFlags := LCMAP_KATAKANA;               //�J�^�J�i
    w_MapFlags := w_MapFlags + LCMAP_HALFWIDTH; //���p����
    LCMapString(
                GetUserDefaultLCID(),
                w_MapFlags,
                PChar(arg_Moji),
                Length(arg_Moji) + 1,
                w_Chr,
                Sizeof(w_Chr)
               );
  end;

  Result := Trim(w_Chr);
end;

initialization
begin
  //�J�^�J�i�����[�}���ϊ�������
  func_Kana_To_Roma_s(0);
end;

finalization
begin
//
end;

end.
