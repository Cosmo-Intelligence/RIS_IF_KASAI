// -----------------------------------------------------------------------------
//  【データ型変換モジュール】
// -----------------------------------------------------------------------------
//------------------------------------------------------------------------------
// ユニット定義
//------------------------------------------------------------------------------
unit Unit_Convert;

//------------------------------------------------------------------------------
interface
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// インクルード
//------------------------------------------------------------------------------
uses
  SysUtils;

//------------------------------------------------------------------------------
// 各公開型定義
//------------------------------------------------------------------------------
type
  T_DBConvert = class
    public
      class function IntToStr(IpNum: integer; const IpDef: String = 'null'): String;
      class function DateTimeToStr(IpDate: TDateTime; const IpFrm: String; IpQuote: boolean; const IpDef: String = 'null'): String;
      class function StrToInt(const IpStr: String): integer;
      class function StrToDate(const IpDate: String; const IpDef: TDateTime): TDateTime;
  end;

  //半角ｶﾅ → ローマ字変換
  function KanaToRoma(const IpKana: String) : String;

//------------------------------------------------------------------------------
// 各定数
//------------------------------------------------------------------------------
const
  //NULL 対応データ
  INVALID_NUM   = -9999;  //数値
  INVALID_DATE  = 0;      //日付

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// 各定数
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
      = ('ｯｷﾞｬ','ｯｷﾞｭ','ｯｷﾞｮ','ｯｼﾞｬ','ｯｼﾞｭ','ｯｼﾞｮ','ｯﾋﾞｬ','ｯﾋﾞｭ','ｯﾋﾞｮ','ｯﾋﾟｬ','ｯﾋﾟｭ','ｯﾋﾟｮ');
  KANA_PATTERN_3 : array[1..65] of String
      = ('ｯｶﾞ','ｯｷﾞ','ｯｸﾞ','ｯｹﾞ','ｯｺﾞ','ｯｻﾞ','ｯｼﾞ','ｯｽﾞ','ｯｾﾞ','ｯｿﾞ',
         'ｯﾀﾞ','ｯﾁﾞ','ｯﾂﾞ','ｯﾃﾞ','ｯﾄﾞ','ｯﾊﾞ','ｯﾋﾞ','ｯﾌﾞ','ｯﾍﾞ','ｯﾎﾞ',
         'ｯﾊﾟ','ｯﾋﾟ','ｯﾌﾟ','ｯﾍﾟ','ｯﾎﾟ','ｯｷｬ','ｯｷｭ','ｯｷｮ','ｯｼｬ','ｯｼｭ',
         'ｯｼｮ','ｯﾁｬ','ｯﾁｭ','ｯﾁｮ','ﾝﾆｬ','ﾝﾆｭ','ﾝﾆｮ','ｯﾋｬ','ｯﾋｭ','ｯﾋｮ',
         'ｯﾐｬ','ｯﾐｭ','ｯﾐｮ','ﾝﾊﾞ','ﾝﾋﾞ','ﾝﾌﾞ','ﾝﾍﾞ','ﾝﾎﾞ','ﾝﾊﾟ','ﾝﾋﾟ',
         'ﾝﾌﾟ','ﾝﾍﾟ','ﾝﾎﾟ','ｷﾞｬ','ｷﾞｭ','ｷﾞｮ','ｼﾞｬ','ｼﾞｭ','ｼﾞｮ','ﾋﾞｬ',
         'ﾋﾞｭ','ﾋﾞｮ','ﾋﾟｬ','ﾋﾟｭ','ﾋﾟｮ');
  KANA_PATTERN_2 : array[1..88] of String
      = ('ｯｶ','ｯｷ','ｯｸ','ｯｹ','ｯｺ','ｯｻ','ｯｼ','ｯｽ','ｯｾ','ｯｿ','ｯﾀ','ｯﾁ','ｯﾂ','ｯﾃ','ｯﾄ',
         'ｯﾅ','ｯﾆ','ｯﾇ','ｯﾈ','ｯﾉ','ｯﾊ','ｯﾋ','ｯﾌ','ｯﾍ','ｯﾎ','ｯﾏ','ｯﾐ','ｯﾑ','ｯﾒ','ｯﾓ',
         'ｯﾔ','ｯﾗ','ｯﾘ','ｯﾙ','ｯﾚ','ｯﾛ','ｯﾜ','ｶﾞ','ｷﾞ','ｸﾞ','ｹﾞ','ｺﾞ','ｻﾞ','ｼﾞ','ｽﾞ',
         'ｾﾞ','ｿﾞ','ﾀﾞ','ﾁﾞ','ﾂﾞ','ﾃﾞ','ﾄﾞ','ﾊﾞ','ﾋﾞ','ﾌﾞ','ﾍﾞ','ﾎﾞ','ﾊﾟ','ﾋﾟ','ﾌﾟ',
         'ﾍﾟ','ﾎﾟ','ｷｬ','ｷｭ','ｷｮ','ｼｬ','ｼｭ','ｼｮ','ﾁｬ','ﾁｭ','ﾁｮ','ﾆｬ','ﾆｭ','ﾆｮ','ﾋｬ',
         'ﾋｭ','ﾋｮ','ﾐｬ','ﾐｭ','ﾐｮ','ﾘｬ','ﾘｭ','ﾘｮ','ﾝﾏ','ﾝﾐ','ﾝﾑ','ﾝﾒ','ﾝﾓ');
  KANA_PATTERN_1 : array[1..98] of String
      = ('ｱ','ｲ','ｳ','ｴ','ｵ','ｶ','ｷ','ｸ','ｹ','ｺ','ｻ','ｼ','ｽ','ｾ','ｿ',
         'ﾀ','ﾁ','ﾂ','ﾃ','ﾄ','ﾅ','ﾆ','ﾇ','ﾈ','ﾉ','ﾊ','ﾋ','ﾌ','ﾍ','ﾎ',
         'ﾏ','ﾐ','ﾑ','ﾒ','ﾓ','ﾔ','ﾕ','ﾖ','ﾗ','ﾘ','ﾙ','ﾚ','ﾛ','ﾜ','ﾝ',
         ' ','A','B','C','D','E','F','G','H','I','J','K','L','M','N',
         'O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b','c',
         'd','e','f','g','h','i','j','k','l','m','n','o','p','q','r',
         's','t','u','v','w','x','y','z');

//------------------------------------------------------------------------------
// T_DBConvert 各メソッド実装
//------------------------------------------------------------------------------
//******************************************************************************
//* function name       : StrToInt(const IpStr: String): integer;
//* description         : 数値変換
//*   <function>
//*     文字列 → 数値変換 NULLチェック付
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
//* description         : 文字列変換
//*   <function>
//*     日付 → 文字列変換 NULLチェック付
//*   <include file>
//*   <calling sequence>
//*     DBDateTimeToStr(IpDate: TDateTime; const IpFrm: String): String;
//*   <remarks>
//******************************************************************************
class function T_DBConvert.DateTimeToStr(IpDate: TDateTime;
  const IpFrm: String; IpQuote: boolean; const IpDef: String): String;
begin
  result:= IpDef;
  //無効日付の時は "'"で括らない
  if IpDate = INVALID_DATE then exit;
  try
    DateTimeToString(result, IpFrm, IpDate);
  finally
    // "'" で囲む
    if IpQuote = true then result:= AnsiQuotedStr(result, '''');
  end;
end;

//******************************************************************************
//* function name       : DBIntToStr
//* description         : 文字列変換
//*   <function>
//*     整数 → 文字列変換 NULLチェック付
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
//* description         : 文字列変換
//*   <function>
//*     文字列(YYYYMMDD形式のみ) → Date
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
//* description   : 半角ｶﾅ → ローマ字変換
//*
//*  < function >
//*    半角ｶﾅ → ローマ字変換
//*
//*  < calling sequence >
//* function KanaToRoma(const IpKana: String) : String;
//*
//*     IpKana    : String  (i/ )  患者名（カナ）
//*
//*  < return value >
//*     String  : ローマ字
//*
//*  < Remarks >
//*   変換不能な文字は '_' で出力
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
  //文字を変換する
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
