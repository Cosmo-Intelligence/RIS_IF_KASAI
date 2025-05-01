unit KanaRoma;
{
■機能説明
  カタカナ→ローマ字変換ルーチン

  ※変換表の初期値は訓令式とする
  ※変換表をﾃｷｽﾄﾌｧｲﾙとすることが可能(同一内にKanaRomaHyo.txtを作成)

  ●ローマ字とカナの変換表を初期化ルーチン

    function func_Kana_To_Roma_s: Boolean;

    引数：なし
    戻り：成功：True、失敗：False

  ●カタカナ→ローマ字変換ルーチン
    MS-IME2 for Windowsのローマ字とカナの変換表

    function func_Kana_To_Roma_n(arg_Kana: string; arg_h,arg_s,arg_c,arg_u: integer): string;

    引数：arg_Kana    //変換元のカナ
          arg_h       //撥音－「ﾝ」の扱い（0:訓令式、1:ヘボン式、2:NN）
          arg_s       //促音－「ｯ」の扱い（0:訓令式、1:ヘボン式）
          arg_c       //長音－「-」の扱い（0:母音字を並べる、1:そのまま）
          arg_u       //姓、名の最後が「U」の扱い（0:そのまま、1:Uを除く）
    戻り：変換されたローマ字(失敗した場合には空白)

//●★使用可★機能（例外無）：全文字列の全角チェック
func_ALL_ZENKAKU_CHECK(arg_text: string):Boolean;
//●★使用可★機能（例外無）：全文字列の半角チェック
func_ALL_HANKAKU_CHECK(arg_text: string):Boolean;
//●★使用可★機能（例外無）：文字変換
func_Moji_Henkan(arg_Moji: string;
                 arg_Flg: Integer  //1:全角→半角、2:半角→全角、3:全角ひらがな→半角カタカナ
                 ): string;
■履歴
新規作成：2002.03.21：杉山
修正履歴：

}
interface //*****************************************************************
//使用ユニット---------------------------------------------------------------
uses
//システム－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
  Windows, Messages, SysUtils, Classes, Controls, Dialogs,
  IniFiles, FileCtrl, TcpSocket;

////型クラス宣言-------------------------------------------------------------
//type

//定数宣言-------------------------------------------------------------------
//const

//変数宣言-------------------------------------------------------------------
//var

//関数手続き宣言-------------------------------------------------------------
//●機能（例外無）：ローマ字とカナの変換表を初期化
  function func_Kana_To_Roma_s(arg_Mode: integer): Boolean;
//●機能（例外無）：カタカナ→ローマ字変換
// MS-IME2 for Windowsのローマ字とカナの変換表
  function func_Kana_To_Roma_n(arg_Kana: string; arg_h,arg_s,arg_c,arg_u: integer): string;
//●★使用可★機能（例外無）：全文字列の全角チェック
  function func_ALL_ZENKAKU_CHECK(arg_text: string):Boolean;
//●★使用可★機能（例外無）：全文字列の半角チェック
  function func_ALL_HANKAKU_CHECK(arg_text: string):Boolean;
//●★使用可★機能（例外無）：文字変換
  function func_Moji_Henkan(arg_Moji: string;
                 arg_Flg: Integer  //1:全角→半角、2:半角→全角、3:全角ひらがな→半角カタカナ
                 ): string;

implementation //**************************************************************

//使用ユニット---------------------------------------------------------------
//uses

//定数宣言       -------------------------------------------------------------
const
//ローマ字とカナの変換表(初期値)
//ア～ワ行及び濁点等
  //ﾌｧｲﾙ名
  cst_ktr_Kana_Area_File = 'KanaRomaHyo.txt';
  //検索最大数
  cst_ktr_Kana_Area_Max = 300;
  //カナ表
  cst_ktr_Kana_Area : array[0..299] of String =
       (
        'ｱ',	'ｲ',	'ｳ',	'ｴ',	'ｵ',
        'ｶ',	'ｷ',	'ｸ',	'ｹ',	'ｺ',
        'ｻ',	'ｼ',	'ｽ',	'ｾ',	'ｿ',
        'ﾀ',	'ﾁ',	'ﾂ',	'ﾃ',	'ﾄ',
        'ﾅ',	'ﾆ',	'ﾇ',	'ﾈ',	'ﾉ',
        'ﾊ',	'ﾋ',	'ﾌ',	'ﾍ',	'ﾎ',
        'ﾏ',	'ﾐ',	'ﾑ',	'ﾒ',	'ﾓ',
        'ﾔ',	' ',	'ﾕ',	' ',	'ﾖ',
        'ﾗ',	'ﾘ',	'ﾙ',	'ﾚ',	'ﾛ',
        'ﾜ',	'ｦ',	' ',	' ',	'ﾝ',
        ' ',	' ',	'ｳﾞ',   ' ',    ' ',
        'ｶﾞ',	'ｷﾞ',	'ｸﾞ',	'ｹﾞ',	'ｺﾞ',
        'ｻﾞ',	'ｼﾞ',	'ｽﾞ',	'ｾﾞ',	'ｿﾞ',
        'ﾀﾞ',	'ﾁﾞ',	'ﾂﾞ',	'ﾃﾞ',	'ﾄﾞ',
        'ﾊﾞ',	'ﾋﾞ',	'ﾌﾞ',	'ﾍﾞ',	'ﾎﾞ',
        'ﾊﾟ',	'ﾋﾟ',	'ﾌﾟ',	'ﾍﾟ',	'ﾎﾟ',
        'ｳｧ',	'ｳｨ',	' ',	'ｳｪ',	'ｳｫ',
        'ｸｧ',	'ｸｨ',	'ｸｩ',	'ｸｪ',	'ｸｫ',
        'ｽｧ',	'ｽｨ',	'ｽｩ',	'ｽｪ',	'ｽｫ',
        'ﾂｧ',	'ﾂｨ',	' ',	'ﾂｪ',	'ﾂｫ',
        'ﾄｧ',	'ﾄｨ', 	'ﾄｩ',	'ﾄｪ',	'ﾄｫ',
        'ﾌｧ',	'ﾌｨ',	'ﾌｩ',	'ﾌｪ',	'ﾌｫ',
        'ｳﾞｧ',	'ｳﾞｨ',	' ',	'ｳﾞｪ',	'ｳﾞｫ',
        'ｸﾞｧ',	'ｸﾞｨ',	'ｸﾞｩ',	'ｸﾞｪ',	'ｸﾞｫ',
        'ﾄﾞｧ',	'ﾄﾞｨ',	'ﾄﾞｩ',	'ﾄﾞｪ',	'ﾄﾞｫ',
        'ｷｬ',	'ｷｨ',	'ｷｭ', 	'ｷｪ',	'ｷｮ',
        'ｸｬ',	' ',	'ｸｭ',	' ',	'ｸｮ',
        'ｼｬ',	'ｼｨ',	'ｼｭ',	'ｼｪ',	'ｼｮ',
        'ﾁｬ',	'ﾁｨ',	'ﾁｭ',	'ﾁｪ',	'ﾁｮ',
        'ﾃｬ',	'ﾃｨ',	'ﾃｭ',	'ﾃｪ',	'ﾃｮ',
        'ﾆｬ',	'ﾆｨ',	'ﾆｭ',	'ﾆｪ',	'ﾆｮ',
        'ﾋｬ',	'ﾋｨ',	'ﾋｭ',	'ﾋｪ',	'ﾋｮ',
        'ﾐｬ',	'ﾐｨ',	'ﾐｭ',	'ﾐｪ',	'ﾐｮ',
        'ﾘｬ',	'ﾘｨ',	'ﾘｭ',	'ﾘｪ',	'ﾘｮ',
        'ｷﾞｬ',	'ｷﾞｨ',	'ｷﾞｭ',	'ｷﾞｪ',	'ｷﾞｮ',
        'ｼﾞｬ',	'ｼﾞｨ',	'ｼﾞｭ',	'ｼﾞｪ',	'ｼﾞｮ',
        'ﾁﾞｬ',	'ﾁﾞｨ',	'ﾁﾞｭ',	'ﾁﾞｪ',	'ﾁﾞｮ',
        'ﾃﾞｬ',	'ﾃﾞｨ',	'ﾃﾞｭ',	'ﾃﾞｪ',	'ﾃﾞｮ',
        'ﾋﾞｬ',	'ﾋﾞｨ',	'ﾋﾞｭ',	'ﾋﾞｪ',	'ﾋﾞｮ',
        'ﾋﾟｬ',	'ﾋﾟｨ',	'ﾋﾟｭ',	'ﾋﾟｪ',	'ﾋﾟｮ',
        'ｧ',	'ｨ', 	'ｩ',	'ｪ',	'ｫ',
        'ｬ',	' ',	'ｭ',	' ',	'ｮ',
        'ｯ',    ' ',    ' ',    ' ',    ' ',
        'ﾟ',	'ﾞ',	'ｰ',    ' ',    ' ',
        '!',	'"',	'#',	'$',	'%',
        '&',	'''',	'(',	')',	'=',
        '^',	'~',	'\',	'|',	'｢',
        '{',	'@',	'`',	'｣',	'}',
        ':',	'*',	';',	'+',	'_',
        '･',	'?',	'｡',	'>',	'､',
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
  //ローマ字表(初期値は訓令式)
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
        'ﾟ',	'ﾞ',	'-',    ' ',    ' ',
        '!',	'"',	'#',	'$',	'%',
        '&',	'''',	'(',	')',	'=',
        '^',	'~',	'\',	'|',	'｢',
        '{',	'@',	'`',	'｣',	'}',
        ':',	'*',	';',	'+',	'_',
        '･',	'?',	'｡',	'>',	'､',
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

//変数宣言     ---------------------------------------------------------------
var
  ktr_Kana_Area : array[0..299] of String;
  ktr_Roma_Area : array[0..299] of String;

//関数手続き宣言--------------------------------------------------------------

//●機能（例外無）：ローマ字とカナの変換表を初期化
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
  //変換表ﾌｧｲﾙ存在チェック
  if not(FileExists(g_TcpIniPath + cst_ktr_Kana_Area_File)) then Exit;
  //変換表ﾌｧｲﾙより読み込み
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
      //識別
      w_kbn := Copy(w_Record,1,1);
      w_tStr.CommaText := Copy(w_Record,4,Length(w_Record)-4+1);
      for w_t := 0 to w_tStr.Count - 1 do begin
        //カナ
        if w_kbn = 'K' then begin
          if w_k < 300 then
            ktr_Kana_Area[w_k] := w_tStr.Strings[w_t];
          w_k := w_k + 1;
        end
        //ﾛｰﾏ字
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
//●機能（例外無）：カタカナ→ローマ字変換
// MS-IME2 for Windowsのローマ字とカナの変換表
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
  //初期化
  Result := '';
  arg_Kana := Trim(arg_Kana);
  w_Roma := '';
  w_LTU := False;
  //１文字づつ処理
  w_i := 1;
  while w_i <= (Length(arg_Kana)) do
  begin
    w_Get_Kana := Copy(arg_Kana,w_i,1);
    w_After_Kana := Copy(arg_Kana,w_i+1,1);
    w_Before_Kana := Copy(arg_Kana,w_i-1,1);
    w_ii := w_i;
    //「ｯ」は次で処理するので飛ばす
    if (w_Get_Kana = 'ｯ') then begin
      if w_LTU = True then begin
        w_Roma := w_Roma + 'LTU';
      end;
      w_LTU := True;
      w_i := w_i + 1;
      Continue;
    end;
    //「ﾞ」、「ﾟ」は結合して処理する
    if (w_After_Kana = 'ﾞ') or (w_After_Kana = 'ﾟ') then begin
      w_Get_Kana := w_Get_Kana + w_After_Kana;
      w_i := w_i + 1;
      //更にその次を見る
      w_After_Kana := Copy(arg_Kana,w_i+1,1);
    end;
    //「ｧ」「ｨ」「ｩ」「ｪ」「ｫ」
    //「ｬ」「ｨ」「ｭ」「ｪ」「ｮ」
    //は結合して処理する
    if (w_After_Kana = 'ｧ') or
       (w_After_Kana = 'ｨ') or
       (w_After_Kana = 'ｩ') or
       (w_After_Kana = 'ｪ') or
       (w_After_Kana = 'ｫ') or
       (w_After_Kana = 'ｬ') or
       (w_After_Kana = 'ｭ') or
       (w_After_Kana = 'ｮ') then begin
      w_Get_Kana := w_Get_Kana + w_After_Kana;
      w_i := w_i + 1;
      //更にその次を見る
      w_After_Kana := Copy(arg_Kana,w_i+1,1);
    end;
    //「ｳ」は姓、名の最後であれば飛ばす
    if (w_Get_Kana = 'ｳ') then begin
      if (w_After_Kana = '')  or
         (w_After_Kana = ' ') then begin
        if arg_u = 1 then begin
          w_Get_Kana := w_After_Kana;
          w_i := w_i + 1;
          //更にその次を見る
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
      //撥音－前に「ﾝ」がある場合
      if (w_Before_Kana = 'ﾝ') then begin
        if ((w_Get_Kana = 'ｱ') or
            (w_Get_Kana = 'ｲ') or
            (w_Get_Kana = 'ｳ') or
            (w_Get_Kana = 'ｴ') or
            (w_Get_Kana = 'ｵ') ) then begin
          if arg_h = 0 then begin //訓令式－nのまま
            w_Get_Roma := w_Get_Roma;
          end
          else if arg_h = 2 then begin //nn
            w_Get_Roma := 'N' + w_Get_Roma;
          end;
        end;
        if (Copy(w_Get_Roma,1,1) = 'M') or
           (Copy(w_Get_Roma,1,1) = 'B') or
           (Copy(w_Get_Roma,1,1) = 'P') then begin
          if arg_h = 1 then begin //ﾍﾎﾞﾝ式－m,b,pの前にnの変りにmをおく
            w_Roma := Copy(w_Roma,1,Length(w_Roma) - 1);
            w_Get_Roma := 'M' + w_Get_Roma;
          end;
        end;
      end;
      //促音－「ｯ」
      if w_LTU = True then begin
        if arg_s = 0 then begin  //訓令式－子音を重ねる
          w_Get_Roma := Copy(w_Get_Roma, 1, 1) + w_Get_Roma;
        end
        else if arg_s = 1 then begin //ﾍﾎﾞﾝ式－chi,cha,chu,choに限り前にtをおく
          if (w_Get_Roma = 'CHI') or
             (w_Get_Roma = 'CHA') or
             (w_Get_Roma = 'CHU') or
             (w_Get_Roma = 'CHO') then begin
            w_Get_Roma := 'T' + w_Get_Roma;
          end
          else begin //ﾍﾎﾞﾝ式－子音を重ねる
            w_Get_Roma := Copy(w_Get_Roma, 1, 1) + w_Get_Roma;
          end;
        end;
        w_LTU := False;
      end;
      //長音－「-」
      if w_Get_Roma = '-' then begin
        if arg_c = 0 then begin //母音字を並べる
          if Length(w_Roma) > 0 then begin
            w_Get_Roma := Copy(w_Roma,Length(w_Roma),1);
          end
          else begin
            w_Get_Roma := w_Get_Roma;
          end;
        end
        else if arg_c = 1 then begin //そのまま
          w_Get_Roma := w_Get_Roma;
        end;
      end;
    end;
    //１文字づつを結合
    w_Roma := w_Roma + w_Get_Roma;
    //次へ
    w_i := w_i + 1;
  end;

  w_Roma := Trim(w_Roma);
  //最後にｯが残っている場合
  if w_LTU = True then begin
    w_Roma := w_Roma + 'LTU';
  end;
  //戻り値
  Result := Trim(w_Roma);
end;
//●機能（例外無）：全文字列の全角チェック
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
//●機能（例外無）：全文字列の半角チェック
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
//●機能（例外無）：全文字列の半角チェック
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
//●機能（例外無）：文字変換
function func_Moji_Henkan(arg_Moji: string;
                          arg_Flg: Integer  //1:全角→半角、2:半角→全角、3:全角ひらがな→半角カタカナ
                          ): string;
var
  w_Chr:        array [0..255] of char;
  w_MapFlags:   DWORD;
begin
  // 全角(2ﾊﾞｲﾄ)→半角(1ﾊﾞｲﾄ)に変換
  if arg_Flg = 1 then begin
    LCMapString(
                GetUserDefaultLCID(),
                LCMAP_HALFWIDTH,
                PChar(arg_Moji),      //変換する文字列
                Length(arg_Moji) + 1, //サイズ
                w_Chr,                //変換結果
                Sizeof(w_Chr)         //サイズ
               );
  end;
  // 半角(1ﾊﾞｲﾄ)→全角(2ﾊﾞｲﾄ)に変換
  if arg_Flg = 2 then begin
    LCMapString(
                GetUserDefaultLCID(),
                LCMAP_FULLWIDTH,
                PChar(arg_Moji),      //変換する文字列
                Length(arg_Moji) + 1, //サイズ
                w_Chr,                //変換結果
                Sizeof(w_Chr)         //サイズ
               );
  end;
  // 全角ひらがな→半角カタカナに変換
  if arg_Flg = 3 then begin
    w_MapFlags := LCMAP_KATAKANA;               //カタカナ
    w_MapFlags := w_MapFlags + LCMAP_HALFWIDTH; //半角文字
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
  //カタカナ→ローマ字変換初期化
  func_Kana_To_Roma_s(0);
end;

finalization
begin
//
end;

end.
