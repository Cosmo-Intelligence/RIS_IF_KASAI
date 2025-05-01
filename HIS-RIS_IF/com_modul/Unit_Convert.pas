// -----------------------------------------------------------------------------
//  �y�f�[�^�^�ϊ����W���[���z
// -----------------------------------------------------------------------------
//------------------------------------------------------------------------------
// ���j�b�g��`
//------------------------------------------------------------------------------
unit Unit_Convert;

//------------------------------------------------------------------------------
interface
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// �C���N���[�h
//------------------------------------------------------------------------------
uses
  SysUtils;

//------------------------------------------------------------------------------
// �e���J�^��`
//------------------------------------------------------------------------------
type
  T_DBConvert = class
    public
      class function IntToStr(IpNum: integer; const IpDef: String = 'null'): String;
      class function DateTimeToStr(IpDate: TDateTime; const IpFrm: String; IpQuote: boolean; const IpDef: String = 'null'): String;
      class function StrToInt(const IpStr: String): integer;
      class function StrToDate(const IpDate: String; const IpDef: TDateTime): TDateTime;
  end;

  //���p�� �� ���[�}���ϊ�
  function KanaToRoma(const IpKana: String) : String;

//------------------------------------------------------------------------------
// �e�萔
//------------------------------------------------------------------------------
const
  //NULL �Ή��f�[�^
  INVALID_NUM   = -9999;  //���l
  INVALID_DATE  = 0;      //���t

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// �e�萔
//------------------------------------------------------------------------------
const
  MAX_PATTERN_4 : Integer = 12;
  MAX_PATTERN_3 : Integer = 65;
  MAX_PATTERN_2 : Integer = 88;
  MAX_PATTERN_1 : Integer = 98;
  ROMA_PATTERN_4 : array[1..12] of String
      = ('GGYA','GGYU','GGYO','JJA','JJU','JJO','BBYA','BBYU','BBYO','PPYA','PPYU','PPYO');
  ROMA_PATTERN_3 : array[1..65] of String
      = ('GGA','GGI','GGU','GGE','GGO','ZZA','JJI','ZZU','ZZE','ZZO',
         'DDA','JJI','ZZU','DDE','DDO','BBA','BBI','BBU','BBE','BBO',
         'PPA','PPI','PPU','PPE','PPO','KKYA','KKYU','KKYO','SSYA','SSYU',
         'SSYO','TCHA','TCHU','TCHO','NNYA','NNYU','NNYO','HHYA','HHYU','HHYO',
         'MMYA','MMYU','MMYO','MBA','MBI','MBU','MBE','NBO','MPA','MPI','MPU','MPE','MPO',
         'GYA','GYU','GYO','JA','JU','JO','BYA','BYU','BYO','PYA','PYU','PYO');
  ROMA_PATTERN_2 : array[1..88] of String
      = ('KKA','KKI','KKU','KKE','KKO','SSA','SSHI','SSU','SSE','SSO','TTA','TCHI','TTSU','TTE','TTO',
         'NNA','NNI','NNU','NNE','NNO','HHA','HHI','FFU','HHE','HHO','MMA','MMI','MMU','MME','MMO',
         'YYA','RRA','RRI','RRU','RRE','RRO','WWA','GA','GI','GU','GE','GO','ZA','JI','ZU',
         'ZE','ZO','DA','JI','ZU','DE','DO','BA','BI','BU','BE','BO','PA','PI','PU',
         'PE','PO','KYA','KYU','KYO','SHA','SHU','SHO','CHA','CHU','CHO','NYA','NYU','NYO','HYA',
         'HYU','HYO','MYA','MYU','MYO','RYA','RYU','RYO','MMA','MMI','MMU','MME','MMO');
  ROMA_PATTERN_1 : array[1..98] of String
      = ('A','I','U','E','O','KA','KI','KU','KE','KO','SA','SHI','SU','SE','SO',
         'TA','CHI','TSU','TE','TO','NA','NI','NU','NE','NO','HA','HI','FU','HE','HO',
         'MA','MI','MU','ME','MO','YA','YU','YO','RA','RI','RU','RE','RO','WA','N',
         ' ','A','B','C','D','E','F','G','H','I','J','K','L','M','N',
         'O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b','c',
         'd','e','f','g','h','i','j','k','l','m','n','o','p','q','r',
         's','t','u','v','w','x','y','z');
  KANA_PATTERN_4 : array[1..12] of String
      = ('��ެ','��ޭ','��ޮ','��ެ','��ޭ','��ޮ','��ެ','��ޭ','��ޮ','��߬','��߭','��߮');
  KANA_PATTERN_3 : array[1..65] of String
      = ('���','���','���','���','���','���','���','���','���','���',
         '���','���','���','���','���','���','���','���','���','���',
         '���','���','���','���','���','���','���','���','���','���',
         '���','���','���','���','�Ƭ','�ƭ','�Ʈ','�ˬ','�˭','�ˮ',
         '�Ь','�Э','�Ю','���','���','���','���','���','���','���',
         '���','���','���','�ެ','�ޭ','�ޮ','�ެ','�ޭ','�ޮ','�ެ',
         '�ޭ','�ޮ','�߬','�߭','�߮');
  KANA_PATTERN_2 : array[1..88] of String
      = ('��','��','��','��','��','��','��','��','��','��','��','��','��','��','��',
         '��','��','��','��','��','��','��','��','��','��','��','��','��','��','��',
         '��','��','��','��','��','��','��','��','��','��','��','��','��','��','��',
         '��','��','��','��','��','��','��','��','��','��','��','��','��','��','��',
         '��','��','��','��','��','��','��','��','��','��','��','Ƭ','ƭ','Ʈ','ˬ',
         '˭','ˮ','Ь','Э','Ю','ج','ح','خ','��','��','��','��','��');
  KANA_PATTERN_1 : array[1..98] of String
      = ('�','�','�','�','�','�','�','�','�','�','�','�','�','�','�',
         '�','�','�','�','�','�','�','�','�','�','�','�','�','�','�',
         '�','�','�','�','�','�','�','�','�','�','�','�','�','�','�',
         ' ','A','B','C','D','E','F','G','H','I','J','K','L','M','N',
         'O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b','c',
         'd','e','f','g','h','i','j','k','l','m','n','o','p','q','r',
         's','t','u','v','w','x','y','z');

//------------------------------------------------------------------------------
// T_DBConvert �e���\�b�h����
//------------------------------------------------------------------------------
//******************************************************************************
//* function name       : StrToInt(const IpStr: String): integer;
//* description         : ���l�ϊ�
//*   <function>
//*     ������ �� ���l�ϊ� NULL�`�F�b�N�t
//*   <include file>
//*   <calling sequence>
//*     StrToInt(const IpStr: String): integer;
//*   <remarks>
//******************************************************************************
class function T_DBConvert.StrToInt(const IpStr: String): integer;
begin
  result:= StrToIntDef(IpStr, INVALID_NUM);
end;

//******************************************************************************
//* function name       : DBDateTimeToStr
//* description         : ������ϊ�
//*   <function>
//*     ���t �� ������ϊ� NULL�`�F�b�N�t
//*   <include file>
//*   <calling sequence>
//*     DBDateTimeToStr(IpDate: TDateTime; const IpFrm: String): String;
//*   <remarks>
//******************************************************************************
class function T_DBConvert.DateTimeToStr(IpDate: TDateTime;
  const IpFrm: String; IpQuote: boolean; const IpDef: String): String;
begin
  result:= IpDef;
  //�������t�̎��� "'"�Ŋ���Ȃ�
  if IpDate = INVALID_DATE then exit;
  try
    DateTimeToString(result, IpFrm, IpDate);
  finally
    // "'" �ň͂�
    if IpQuote = true then result:= AnsiQuotedStr(result, '''');
  end;
end;

//******************************************************************************
//* function name       : DBIntToStr
//* description         : ������ϊ�
//*   <function>
//*     ���� �� ������ϊ� NULL�`�F�b�N�t
//*   <include file>
//*   <calling sequence>
//*     DBIntToStr(IpNum: integer): String;
//*   <remarks>
//******************************************************************************
class function T_DBConvert.IntToStr(IpNum: integer;
  const IpDef: String): String;
begin
  result:= IpDef;
  if IpNum = INVALID_NUM then exit;
  result:= IntToStr(IpNum);
end;

//******************************************************************************
//* function name       : StrToDate
//* description         : ������ϊ�
//*   <function>
//*     ������(YYYYMMDD�`���̂�) �� Date
//*   <include file>
//*   <calling sequence>
//*     StrToDate(const IpDate: String; const IpDef: TDateTime): TDateTime;
//*   <remarks>
//******************************************************************************
class function T_DBConvert.StrToDate(const IpDate: String; const IpDef: TDateTime): TDateTime;
var
  boRslt: boolean;
begin
  if Length(IpDate) <> 8 then begin
    result:= IpDef;
    exit;
  end;

  boRslt:= TryEncodeDate( StrToIntDef(Copy(IpDate, 1, 4), -1),
                          StrToIntDef(Copy(IpDate, 5, 2), -1),
                          StrToIntDef(Copy(IpDate, 7, 2), -1),
                          result );
  if boRslt = false then result:= IpDef;
end;

//******************************************************************************
//* function name :  KanaToRoma
//*
//* description   : ���p�� �� ���[�}���ϊ�
//*
//*  < function >
//*    ���p�� �� ���[�}���ϊ�
//*
//*  < calling sequence >
//* function KanaToRoma(const IpKana: String) : String;
//*
//*     IpKana    : String  (i/ )  ���Җ��i�J�i�j
//*
//*  < return value >
//*     String  : ���[�}��
//*
//*  < Remarks >
//*   �ϊ��s�\�ȕ����� '_' �ŏo��
//******************************************************************************
function KanaToRoma(const IpKana: String) : String;
var
  Pnt     : Integer;
  lp      : Integer;
  TmpStr  : String;
  ConvStr : String;
  Match   : Boolean;
  Cnt     : Integer;
begin
  //������ϊ�����
  Pnt := 1;
  Cnt := 0;
  ConvStr := '';
  while Pnt <= Length(IpKana) do begin
    TmpStr := Copy(IpKana,Pnt,4);
    Match := False;
    for lp := 1 to MAX_PATTERN_4 do begin
      if KANA_PATTERN_4[lp] = TmpStr then begin
        ConvStr := ConvStr + ROMA_PATTERN_4[lp];
        Pnt := Pnt + 4;
        Cnt := Cnt + Length(ROMA_PATTERN_4[lp]);
        Match := True;
        break;
      end;
    end;
    if Match = True then Continue;
    TmpStr := Copy(IpKana,Pnt,3);
    Match := False;
    for lp := 1 to MAX_PATTERN_3 do begin
      if KANA_PATTERN_3[lp] = TmpStr then begin
        ConvStr := ConvStr + ROMA_PATTERN_3[lp];
        Pnt := Pnt + 3;
        Cnt := Cnt + Length(ROMA_PATTERN_3[lp]);
        Match := True;
        break;
      end;
    end;
    if Match = True then Continue;
    TmpStr := Copy(IpKana,Pnt,2);
    Match := False;
    for lp := 1 to MAX_PATTERN_2 do begin
      if KANA_PATTERN_2[lp] = TmpStr then begin
        ConvStr := ConvStr + ROMA_PATTERN_2[lp];
        Pnt := Pnt + 2;
        Cnt := Cnt + Length(ROMA_PATTERN_2[lp]);
        Match := True;
        break;
      end;
    end;
    if Match = True then Continue;
    TmpStr := Copy(IpKana,Pnt,1);
    Match := False;
    for lp := 1 to MAX_PATTERN_1 do begin
      if KANA_PATTERN_1[lp] = TmpStr then begin
        if (lp <> 3) then begin
          ConvStr := ConvStr + ROMA_PATTERN_1[lp];
          Cnt := Cnt + Length(ROMA_PATTERN_1[lp]);
        end else begin
          if (Cnt <= 1) then begin
            ConvStr := ConvStr + ROMA_PATTERN_1[lp];
            Cnt := Cnt + Length(ROMA_PATTERN_1[lp]);
          end else if (ConvStr[Cnt]<>ROMA_PATTERN_1[3]) and
                    (ConvStr[Cnt]<>ROMA_PATTERN_1[5]) then begin
            ConvStr := ConvStr + ROMA_PATTERN_1[lp];
            Cnt := Cnt + Length(ROMA_PATTERN_1[lp]);
          end;
        end;
        Pnt := Pnt + 1;
        Match := True;
        break;
      end;
    end;
    if Match = False then begin
      ConvStr := ConvStr + '_';
      Pnt := Pnt + 1;
    end;
  end;

  Result := ConvStr;
end;


end.
