unit HisMsgDef01_IRAI;
{
■機能説明
  HISの通信電文の定義
  処理は記述しないこと
  01電文定義
■履歴
新規作成：2004.08.26：担当 増田
}
interface //*****************************************************************
//使用ユニット---------------------------------------------------------------
uses
//システム－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
  Windows,
  Messages,
  SysUtils,
  Classes,
  DBTables,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  IniFiles,
  //FileCtrl,
  Registry,
  ExtCtrls,
//プロダクト開発共通－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
  HisMsgDef;
////型クラス宣言-------------------------------------------------------------
//const
//定数宣言-------------------------------------------------------------------
const
  G_MSG_01_ITEMPRP_SATUEI   = 'FE';  //電文01 繰り返し項目属性 撮影区分
  G_MSG_01_ITEMPRP_BUI      = 'FB';  //電文01 繰り返し項目属性 部位
  G_MSG_01_ITEMPRP_HOKOU    = 'FH';  //電文01 繰り返し項目属性 方向
  G_MSG_01_ITEMPRP_HOHO     = 'FT';  //電文01 繰り返し項目属性 方法
  G_MSG_01_ITEMPRP_COMENT   = 'FC';  //電文01 繰り返し項目属性 部位コメント
  G_MSG_01_ITEMPRP_SIJICOM  = 'FD';  //電文01 繰り返し項目属性 指示コメント
  G_MSG_01_ITEMPRP_RINSYO   = 'FW';  //電文01 繰り返し項目属性 臨床診断
  G_MSG_01_ITEMPRP_MOKUTEKI = 'FX';  //電文01 繰り返し項目属性 検査目的
  G_MSG_01_ITEMPRP_RI       = 'FI2'; //電文01 繰り返し項目属性 RI注射
  G_MSG_01_ITEMPRP_RI_DOC   = 'FI3'; //電文01 繰り返し項目属性 RI注射文書番号
  G_MSG_01_ITEMPRP_KIKI     = 'FS2'; //電文01 繰り返し項目属性 検査機器
  G_MSG_01_ITEMCD_ETS       = '999'; //電文01 繰り返し項目属性 コメント 検査目的臨床診断
  G_MSG_01_ITEMCD_SFLGON    = '101'; //電文01 繰り返し項目属性 コメント 所見不要
  G_MSG_01_ITEMCD_SFLGOFF   = '102'; //電文01 繰り返し項目属性 コメント 所見要

  //項目属性
  //部位関係
  G_CST_FE  =  'FE'; //撮影区分
  G_CST_FB  =  'FB'; //部位
  G_CST_FC6 = 'FC6'; //方向/体位
  G_CST_FC5 = 'FC5'; //左右
  G_CST_FCC = 'FCC'; //詳細部位（複数）
  G_CST_FT1 = 'FT1'; //造影有無
  G_CST_FB9 = 'FB9'; //部位セパレータ
  //部位繰り返しの中にあるコメント関係
  G_CST_FC0 = 'FC0'; //希望事項（複数）
  G_CST_FCE = 'FCE'; //備考
  G_CST_FC9 = 'FC9'; //食事制限
  G_CST_FCB = 'FCB'; //前処置
  G_CST_FCJ = 'FCJ'; //検査方法（複数）
  G_CST_FCK = 'FCK'; //指示コメント（複数）
  G_CST_FCF = 'FCF'; //経口
  G_CST_FCX = 'FCX'; //シーケンス１
  G_CST_FCY = 'FCY'; //シーケンス２（複数）
  G_CST_FCL = 'FCL'; //特殊（複数）
  G_CST_FC3 = 'FC3'; //MR備考
  G_CST_FCI = 'FCI'; //注意事項（複数）
  G_CST_FC2 = 'FC2'; //治療備考
  //検査日・予約日・予約時間
  G_CST_FA1 = 'FA1'; //検査日
  G_CST_FA2 = 'FA2'; //予約日
  G_CST_FA3 = 'FA3'; //予約時間
  //オーダ情報コメント関係
  G_CST_FD  =  'FD'; //オーダ情報コメント
  G_CST_FJ  =  'FJ'; //オーダ情報コメント
  G_CST_FK  =  'FK'; //オーダ情報コメント
  //オーダ付帯情報関係
  G_CST_FGC = 'FGC'; //臨床診断（複数）
  G_CST_FGA = 'FGA'; //検査目的（複数）
  G_CST_FGD = 'FGD'; //身長
  G_CST_FGE = 'FGE'; //体重
  G_CST_FG1 = 'FG1'; //前回検査日
  G_CST_FG2 = 'FG2'; //カテNo.
  //繰り返し・MAX定数
  CST_KOUMOKU_LOOP_MAX = 99;
  CST_MEISAI_LOOP_MAX = 99;
  CST_PROFILE_LOOP_MAX = 30;
  CST_SHEMA_LOOP_MAX = 10;
  CST_SIJICOM_MAX = 15;
  CST_BUI_MAX = 16;
  CST_FCC_MAX = 10;
  CST_FC0_MAX = 10;
  CST_FCJ_MAX = 10;
  CST_FCK_MAX = 10;
  CST_FCY_MAX = 10;
  CST_FCL_MAX = 10;
  CST_FCI_MAX = 10;
  CST_FD_MAX  = 10;
  CST_FJ_MAX  = 10;
  CST_FK_MAX  = 10;
  //2003.07.04
  CST_FCX_MAX = 10;
  CST_FGC_MAX = 8;
  CST_FGA_MAX = 8;
  CST_FC5_MAX = 2;
  CST_FC5_CUT = '3';
  CST_FC5_R   = '00001';
  CST_FC5_L   = '00002';
//並び順チェック項目用
  G_CST_ZOKUSEI_CHEACK_S = 1;
  G_CST_ZOKUSEI_CHEACK_E = 6;
  type ZOKUSEI_FIELD = array [G_CST_ZOKUSEI_CHEACK_S..G_CST_ZOKUSEI_CHEACK_E] of String;
  const
    ZOKUSEI_FIELD_NAME : ZOKUSEI_FIELD =
    (G_CST_FE,G_CST_FB,G_CST_FC6,G_CST_FC5,G_CST_FCC,G_CST_FT1);

  type ZOKUSEI_LENGTH = array [G_CST_ZOKUSEI_CHEACK_S..G_CST_ZOKUSEI_CHEACK_E] of Integer;
  const
    ZOKUSEI_LENGTH_COUNT : ZOKUSEI_LENGTH =
    (2,2,3,3,3,3);
  //2003.07.04
  CST_PROF_KANSE_0 = '0'; //感染症無し
  CST_PROF_KANSE_1 = '1'; //感染症有り
  CST_HOKEN_SIKIBETU = 'HKN';
  //2003.08.18
  CST_DUMMY_HEYA = '     ';
  //2003.08.19
  CST_DUMMY_BYOUTOU = '   ';
  CST_GROUP_LOOP_MAX = 99;
  CST_RISTYPE = '1';
  CST_THERARISTYPE = '2';
  CST_REPORTTYPE = '3';

  //2011.06 DBExpress対応
  (*
  IRAICOMMANDNO       : Integer = 0;
  IRAIHOSPCODENO      : Integer = 0;
  IRAIPIDNO           : Integer = 0;
  IRAIPNAMENO         : Integer = 0;
  IRAIPKANANO         : Integer = 0;
  IRAISEXNO           : Integer = 0;
  IRAIBIRTHDAYNO      : Integer = 0;
  IRAIPOSTCODE1NO     : Integer = 0;
  IRAIADDRESS1NO      : Integer = 0;
  IRAITEL1NO          : Integer = 0;
  IRAIPOSTCODE2NO     : Integer = 0;
  IRAIADDRESS2NO      : Integer = 0;
  IRAITEL2NO          : Integer = 0;
  IRAIBYOUTOIDNO      : Integer = 0;
  IRAIBYOUTONAMENO    : Integer = 0;
  IRAIROOMIDNO        : Integer = 0;
  IRAIKANGOKBNNO      : Integer = 0;
  IRAIKANJAKBNNO      : Integer = 0;
  IRAIKYUGOKBNNO      : Integer = 0;
  IRAIYOBIKBNNO       : Integer = 0;
  IRAISYOGAINO        : Integer = 0;
  IRAIHEIGHTNO        : Integer = 0;
  IRAIWEIGHTNO        : Integer = 0;
  IRAIBLOODABONO      : Integer = 0;
  IRAIBLOODRHNO       : Integer = 0;
  IRAIKANSENNO        : Integer = 0;
  IRAIKANSENCOMNO     : Integer = 0;
  IRAIKINKINO         : Integer = 0;
  IRAIKINKICOMNO      : Integer = 0;
  IRAININSINNO        : Integer = 0;
  IRAIDETHDATENO      : Integer = 0;
  IRAIORDERNO         : Integer = 0;
  IRAISTARTDATENO     : Integer = 0;
  IRAISTARTTIMENO     : Integer = 0;
  IRAISATUEICODENO    : Integer = 0;
  IRAISATUEINAMENO    : Integer = 0;
  IRAIINOUTKBNNO      : Integer = 0;
  IRAISECTIONCODENO   : Integer = 0;
  IRAISECTIONNAMENO   : Integer = 0;
  IRAIDOCTORCODENO    : Integer = 0;
  IRAIDOCTORNAMENO    : Integer = 0;
  IRAIKINKYUKBNNO     : Integer = 0;
  IRAISIKYUKBNNO      : Integer = 0;
  IRAIGENZOUKBNNO     : Integer = 0;
  IRAIYOYAKUKBNNO     : Integer = 0;
  IRAIDOKUEIKBNNO     : Integer = 0;
  IRAIKBN6NO          : Integer = 0;
  IRAIKBN7NO          : Integer = 0;
  IRAIUPDATEDATENO    : Integer = 0;
  IRAIGROUPCOUNTNO    : Integer = 0;
  IRAIMOKUTEKILENNO   : Integer = 0;
  IRAIMOKUTEKINO      : Integer = 0;
  IRAISIJILENNO       : Integer = 0;
  IRAISIJINO          : Integer = 0;
  IRAISONOTALENNO     : Integer = 0;
  IRAISONOTANO        : Integer = 0;
  IRAIBYOUMEILENNO    : Integer = 0;
  IRAIBYOUMEINO       : Integer = 0;
  IRAIGROUPNO         : Integer = 0;
  IRAIORDERSTATUSNO   : Integer = 0;
  IRAIACCOUNTSTATUSNO : Integer = 0;
  IRAIORDEREXDATENO   : Integer = 0;
  IRAIORDEREXTIMENO   : Integer = 0;
  IRAIKOUMOKUCODENO   : Integer = 0;
  IRAIKOUMOKUNAMENO   : Integer = 0;
  IRAIORDERSYUCODENO  : Integer = 0;
  IRAIORDERSYUNAMENO  : Integer = 0;
  IRAIBUICODENO       : Integer = 0;
  IRAIBUINAMENO       : Integer = 0;
  IRAIKENSAROOMCODENO : Integer = 0;
  IRAIKENSAROOMNAMENO : Integer = 0;
  IRAIMEISAICOUNTNO   : Integer = 0;
  IRAIYRECKBNNO       : Integer = 0;
  IRAIYKMKCODENO      : Integer = 0;
  IRAIYKMKNAMENO      : Integer = 0;
  IRAIYUSENO          : Integer = 0;
  IRAIYBUNKATUNO      : Integer = 0;
  IRAIYYOBINO         : Integer = 0;
  IRAICRECKBNNO       : Integer = 0;
  IRAICKMKCODENO      : Integer = 0;
  IRAICKMKNAMENO      : Integer = 0;
  IRAICYOBINO         : Integer = 0;
  IRAISRECKBNNO       : Integer = 0;
  IRAISNAMENO         : Integer = 0;
  IRAISINFONO         : Integer = 0;
  IRAISYOBINO         : Integer = 0;
  *)

  IRAICOMMANDLEN       = 8;
  IRAIHOSPCODELEN      = 2;
  IRAIPIDLEN           = 10;
  IRAIPNAMELEN         = 41;
  IRAIPKANALEN         = 21;
  IRAISEXLEN           = 1;
  IRAIBIRTHDAYLEN      = 8;
  IRAIPOSTCODE1LEN     = 7;
  IRAIADDRESS1LEN      = 100;
  IRAITEL1LEN          = 12;
  IRAIPOSTCODE2LEN     = 7;
  IRAIADDRESS2LEN      = 100;
  IRAITEL2LEN          = 12;
  IRAIBYOUTOIDLEN      = 4;
  IRAIBYOUTONAMELEN    = 10;
  IRAIROOMIDLEN        = 4;
  IRAIKANGOKBNLEN      = 1;
  IRAIKANJAKBNLEN      = 1;
  IRAIKYUGOKBNLEN      = 1;
  IRAIYOBIKBNLEN       = 1;
  IRAISYOGAILEN        = 15;
  IRAIHEIGHTLEN        = 5;
  IRAIWEIGHTLEN        = 5;
  IRAIBLOODABOLEN      = 1;
  IRAIBLOODRHLEN       = 1;
  IRAIKANSENLEN        = 20;
  IRAIKANSENCOMLEN     = 20;
  IRAIKINKILEN         = 10;
  IRAIKINKICOMLEN      = 20;
  IRAININSINLEN        = 8;       
  IRAIDETHDATELEN      = 8;
  IRAIORDERLEN         = 16;
  IRAISTARTDATELEN     = 8;       
  IRAISTARTTIMELEN     = 4;
  IRAISATUEICODELEN    = 6;       
  IRAISATUEINAMELEN    = 40;
  IRAIINOUTKBNLEN      = 1;       
  IRAISECTIONCODELEN   = 2;
  IRAISECTIONNAMELEN   = 10;
  IRAIDOCTORCODELEN    = 10;      
  IRAIDOCTORNAMELEN    = 20;
  IRAIKINKYUKBNLEN     = 1;       
  IRAISIKYUKBNLEN      = 1;
  IRAIGENZOUKBNLEN     = 1;       
  IRAIYOYAKUKBNLEN     = 1;
  IRAIDOKUEIKBNLEN     = 1;
  IRAIKBN6LEN          = 1;
  IRAIKBN7LEN          = 1;
  IRAIUPDATEDATELEN    = 8;
  IRAIGROUPCOUNTLEN    = 2;
  IRAIMOKUTEKILENLEN   = 4;
  IRAIMOKUTEKILEN      = 9999;
  IRAISIJILENLEN       = 4;
  IRAISIJILEN          = 9999;
  IRAISONOTALENLEN     = 4;
  IRAISONOTALEN        = 9999;
  IRAIBYOUMEILENLEN    = 4;
  IRAIBYOUMEILEN       = 9999;
  IRAIGROUPLEN         = 3;       
  IRAIORDERSTATUSLEN   = 1;
  IRAIACCOUNTSTATUSLEN = 1;       
  IRAIORDEREXDATELEN   = 8;
  IRAIORDEREXTIMELEN   = 4;       
  IRAIKOUMOKUCODELEN   = 6;
  IRAIKOUMOKUNAMELEN   = 40;      
  IRAIORDERSYUCODELEN  = 6;
  IRAIORDERSYUNAMELEN  = 20;      
  IRAIBUICODELEN       = 6;
  IRAIBUINAMELEN       = 20;      
  IRAIKENSAROOMCODELEN = 6;
  IRAIKENSAROOMNAMELEN = 20;      
  IRAIMEISAICOUNTLEN   = 2;
  IRAIYRECKBNLEN       = 2;       
  IRAIYKMKCODELEN      = 6;       
  IRAIYKMKNAMELEN      = 60;
  IRAIYUSELEN          = 9;       
  IRAIYBUNKATULEN      = 2;       
  IRAIYYOBILEN         = 9;
  IRAICRECKBNLEN       = 2;       
  IRAICKMKCODELEN      = 6;       
  IRAICKMKNAMELEN      = 40;
  IRAICYOBILEN         = 40;      
  IRAISRECKBNLEN       = 2;       
  IRAISNAMELEN         = 20;
  IRAISINFOLEN         = 64;      
  IRAISYOBILEN         = 2;       

  IRAICOMMANDNAME       = 'コマンド名';
  IRAIHOSPCODENAME      = '病院コード';
  IRAIPIDNAME           = '患者番号';
  IRAIPNAMENAME         = '患者氏名';
  IRAIPKANANAME         = '患者カナ名';
  IRAISEXNAME           = '性別';
  IRAIBIRTHDAYNAME      = '生年月日';
  IRAIPOSTCODE1NAME     = '郵便番号１';
  IRAIADDRESS1NAME      = '住所１';
  IRAITEL1NAME          = '電話番号１';
  IRAIPOSTCODE2NAME     = '郵便番号２';
  IRAIADDRESS2NAME      = '住所２';
  IRAITEL2NAME          = '電話番号２';
  IRAIBYOUTOIDNAME      = '病棟コード';
  IRAIBYOUTONAMENAME    = '病棟名称';
  IRAIROOMIDNAME        = '病室コード';
  IRAIKANGOKBNNAME      = '看護区分';
  IRAIKANJAKBNNAME      = '患者区分';
  IRAIKYUGOKBNNAME      = '救護区分';
  IRAIYOBIKBNNAME       = '予備区分';
  IRAISYOGAINAME        = '障害情報';
  IRAIHEIGHTNAME        = '身長';
  IRAIWEIGHTNAME        = '体重';
  IRAIBLOODABONAME      = '血液型AB';
  IRAIBLOODRHNAME       = '血液型＋－';
  IRAIKANSENNAME        = '感染情報';
  IRAIKANSENCOMNAME     = '感染コメント';
  IRAIKINKINAME         = '禁忌情報';
  IRAIKINKICOMNAME      = '禁忌コメント';
  IRAININSINNAME        = '妊娠日';
  IRAIDETHDATENAME      = '死亡退院日';
  IRAIORDERNAME         = 'オーダ番号';
  IRAISTARTDATENAME     = '開始日';
  IRAISTARTTIMENAME     = '開始時間';
  IRAISATUEICODENAME    = '検査種コード';
  IRAISATUEINAMENAME    = '検査種名称';
  IRAIINOUTKBNNAME      = '入外区分';
  IRAISECTIONCODENAME   = '依頼科コード';
  IRAISECTIONNAMENAME   = '依頼科名称';
  IRAIDOCTORCODENAME    = '依頼医コード';
  IRAIDOCTORNAMENAME    = '依頼医名称';
  IRAIKINKYUKBNNAME     = '区分１';
  IRAISIKYUKBNNAME      = '区分２';
  IRAIGENZOUKBNNAME     = '区分３';
  IRAIYOYAKUKBNNAME     = '区分４';
  IRAIDOKUEIKBNNAME     = '区分５';
  IRAIKBN6NAME          = '区分６';
  IRAIKBN7NAME          = '区分７';
  IRAIUPDATEDATENAME    = '依頼年月日';
  IRAIGROUPCOUNTNAME    = 'グループ数';
  IRAIMOKUTEKILENNAME   = '検査目的長';
  IRAIMOKUTEKINAME      = '検査目的';
  IRAISIJILENNAME       = '特別指示長';
  IRAISIJINAME          = '特別指示';
  IRAISONOTALENNAME     = 'その他詳細長';
  IRAISONOTANAME        = 'その他詳細';
  IRAIBYOUMEILENNAME    = '依頼時病名長';
  IRAIBYOUMEINAME       = '依頼時病名';
  IRAIGROUPNAME         = 'グループ番号';
  IRAIORDERSTATUSNAME   = 'オーダ進捗';
  IRAIACCOUNTSTATUSNAME = '会計進捗';
  IRAIORDEREXDATENAME   = '実施日';
  IRAIORDEREXTIMENAME   = '実施時間';
  IRAIKOUMOKUCODENAME   = '項目コード';
  IRAIKOUMOKUNAMENAME   = '項目名称';
  IRAIORDERSYUCODENAME  = '撮影種コード';
  IRAIORDERSYUNAMENAME  = '撮影種名称';
  IRAIBUICODENAME       = '部位コード';
  IRAIBUINAMENAME       = '部位名称';
  IRAIKENSAROOMCODENAME = '検査室コード';
  IRAIKENSAROOMNAMENAME = '検査室名称';
  IRAIMEISAICOUNTNAME   = '明細数';
  IRAIYRECKBNNAME       = '薬剤等レコード区分';
  IRAIYKMKCODENAME      = '薬剤等項目コード';
  IRAIYKMKNAMENAME      = '薬剤等項目名称';
  IRAIYUSENAME          = '薬剤等使用量';
  IRAIYBUNKATUNAME      = '薬剤等分割数';
  IRAIYYOBINAME         = '薬剤等予備';
  IRAICRECKBNNAME       = 'コメントレコード区分';
  IRAICKMKCODENAME      = 'コメント項目コード';
  IRAICKMKNAMENAME      = 'コメント項目名称';
  IRAICYOBINAME         = 'コメント予備';
  IRAISRECKBNNAME       = 'シェーマレコード区分';
  IRAISNAMENAME         = 'シェーマシェーマ名称情報';
  IRAISINFONAME         = 'シェーマシェーマ情報';
  IRAISYOBINAME         = 'シェーマ予備情報';

//変数宣言-------------------------------------------------------------------
var
//電文フォーマット定義記憶部
  g_Stream01_IRAI     : array[1..G_MSGFNUM_IRAI] of TStreamField;

  //2011.06 DBExpress対応
  IRAICOMMANDNO       : Integer = 0;
  IRAIHOSPCODENO      : Integer = 0;
  IRAIPIDNO           : Integer = 0;
  IRAIPNAMENO         : Integer = 0;
  IRAIPKANANO         : Integer = 0;
  IRAISEXNO           : Integer = 0;
  IRAIBIRTHDAYNO      : Integer = 0;
  IRAIPOSTCODE1NO     : Integer = 0;
  IRAIADDRESS1NO      : Integer = 0;
  IRAITEL1NO          : Integer = 0;
  IRAIPOSTCODE2NO     : Integer = 0;
  IRAIADDRESS2NO      : Integer = 0;
  IRAITEL2NO          : Integer = 0;
  IRAIBYOUTOIDNO      : Integer = 0;
  IRAIBYOUTONAMENO    : Integer = 0;
  IRAIROOMIDNO        : Integer = 0;
  IRAIKANGOKBNNO      : Integer = 0;
  IRAIKANJAKBNNO      : Integer = 0;
  IRAIKYUGOKBNNO      : Integer = 0;
  IRAIYOBIKBNNO       : Integer = 0;
  IRAISYOGAINO        : Integer = 0;
  IRAIHEIGHTNO        : Integer = 0;
  IRAIWEIGHTNO        : Integer = 0;
  IRAIBLOODABONO      : Integer = 0;
  IRAIBLOODRHNO       : Integer = 0;
  IRAIKANSENNO        : Integer = 0;
  IRAIKANSENCOMNO     : Integer = 0;
  IRAIKINKINO         : Integer = 0;
  IRAIKINKICOMNO      : Integer = 0;
  IRAININSINNO        : Integer = 0;
  IRAIDETHDATENO      : Integer = 0;
  IRAIORDERNO         : Integer = 0;
  IRAISTARTDATENO     : Integer = 0;
  IRAISTARTTIMENO     : Integer = 0;
  IRAISATUEICODENO    : Integer = 0;
  IRAISATUEINAMENO    : Integer = 0;
  IRAIINOUTKBNNO      : Integer = 0;
  IRAISECTIONCODENO   : Integer = 0;
  IRAISECTIONNAMENO   : Integer = 0;
  IRAIDOCTORCODENO    : Integer = 0;
  IRAIDOCTORNAMENO    : Integer = 0;
  IRAIKINKYUKBNNO     : Integer = 0;
  IRAISIKYUKBNNO      : Integer = 0;
  IRAIGENZOUKBNNO     : Integer = 0;
  IRAIYOYAKUKBNNO     : Integer = 0;
  IRAIDOKUEIKBNNO     : Integer = 0;
  IRAIKBN6NO          : Integer = 0;
  IRAIKBN7NO          : Integer = 0;
  IRAIUPDATEDATENO    : Integer = 0;
  IRAIGROUPCOUNTNO    : Integer = 0;
  IRAIMOKUTEKILENNO   : Integer = 0;
  IRAIMOKUTEKINO      : Integer = 0;
  IRAISIJILENNO       : Integer = 0;
  IRAISIJINO          : Integer = 0;
  IRAISONOTALENNO     : Integer = 0;
  IRAISONOTANO        : Integer = 0;
  IRAIBYOUMEILENNO    : Integer = 0;
  IRAIBYOUMEINO       : Integer = 0;
  IRAIGROUPNO         : Integer = 0;
  IRAIORDERSTATUSNO   : Integer = 0;
  IRAIACCOUNTSTATUSNO : Integer = 0;
  IRAIORDEREXDATENO   : Integer = 0;
  IRAIORDEREXTIMENO   : Integer = 0;
  IRAIKOUMOKUCODENO   : Integer = 0;
  IRAIKOUMOKUNAMENO   : Integer = 0;
  IRAIORDERSYUCODENO  : Integer = 0;
  IRAIORDERSYUNAMENO  : Integer = 0;
  IRAIBUICODENO       : Integer = 0;
  IRAIBUINAMENO       : Integer = 0;
  IRAIKENSAROOMCODENO : Integer = 0;
  IRAIKENSAROOMNAMENO : Integer = 0;
  IRAIMEISAICOUNTNO   : Integer = 0;
  IRAIYRECKBNNO       : Integer = 0;
  IRAIYKMKCODENO      : Integer = 0;
  IRAIYKMKNAMENO      : Integer = 0;
  IRAIYUSENO          : Integer = 0;
  IRAIYBUNKATUNO      : Integer = 0;
  IRAIYYOBINO         : Integer = 0;
  IRAICRECKBNNO       : Integer = 0;
  IRAICKMKCODENO      : Integer = 0;
  IRAICKMKNAMENO      : Integer = 0;
  IRAICYOBINO         : Integer = 0;
  IRAISRECKBNNO       : Integer = 0;
  IRAISNAMENO         : Integer = 0;
  IRAISINFONO         : Integer = 0;
  IRAISYOBINO         : Integer = 0;

//関数手続き宣言-------------------------------------------------------------

implementation //**************************************************************

//使用ユニット---------------------------------------------------------------
//uses

//定数宣言       -------------------------------------------------------------
//const

//変数宣言     ---------------------------------------------------------------
var
  g_wi  : INTEGER;
//関数手続き宣言--------------------------------------------------------------

initialization
begin
  //1
  g_wi := 1;
  g_Stream01_IRAI[g_wi].name   := g_Stream_Base[COMMON1SDIDNO].name;
  g_Stream01_IRAI[g_wi].x9     := g_Stream_Base[COMMON1SDIDNO].x9;
  g_Stream01_IRAI[g_wi].size   := g_Stream_Base[COMMON1SDIDNO].size;
  g_Stream01_IRAI[g_wi].offset := g_Stream_Base[COMMON1SDIDNO].offset;
  //2
  inc(g_wi);
  g_Stream01_IRAI[g_wi].name   := g_Stream_Base[COMMON1RVIDNO].name;
  g_Stream01_IRAI[g_wi].x9     := g_Stream_Base[COMMON1RVIDNO].x9;
  g_Stream01_IRAI[g_wi].size   := g_Stream_Base[COMMON1RVIDNO].size;
  g_Stream01_IRAI[g_wi].offset := g_Stream_Base[COMMON1RVIDNO].offset;
  //3
  inc(g_wi);
  g_Stream01_IRAI[g_wi].name   := g_Stream_Base[COMMON1COMMANDNO].name;
  g_Stream01_IRAI[g_wi].x9     := g_Stream_Base[COMMON1COMMANDNO].x9;
  g_Stream01_IRAI[g_wi].size   := g_Stream_Base[COMMON1COMMANDNO].size;
  g_Stream01_IRAI[g_wi].offset := g_Stream_Base[COMMON1COMMANDNO].offset;
  //4
  inc(g_wi);
  g_Stream01_IRAI[g_wi].name   := g_Stream_Base[COMMON1STATUSNO].name;
  g_Stream01_IRAI[g_wi].x9     := g_Stream_Base[COMMON1STATUSNO].x9;
  g_Stream01_IRAI[g_wi].size   := g_Stream_Base[COMMON1STATUSNO].size;
  g_Stream01_IRAI[g_wi].offset := g_Stream_Base[COMMON1STATUSNO].offset;
  //5
  inc(g_wi);
  g_Stream01_IRAI[g_wi].name   := g_Stream_Base[COMMON1DENLENNO].name;
  g_Stream01_IRAI[g_wi].x9     := g_Stream_Base[COMMON1DENLENNO].x9;
  g_Stream01_IRAI[g_wi].size   := g_Stream_Base[COMMON1DENLENNO].size;
  g_Stream01_IRAI[g_wi].offset := g_Stream_Base[COMMON1DENLENNO].offset;
  //6
  inc(g_wi);
  IRAICOMMANDNO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAICOMMANDNAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAICOMMANDLEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //7
  inc(g_wi);
  IRAIHOSPCODENO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIHOSPCODENAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIHOSPCODELEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //8
  inc(g_wi);
  IRAIPIDNO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIPIDNAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIPIDLEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //9
  inc(g_wi);
  IRAIPNAMENO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIPNAMENAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIPNAMELEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //10
  inc(g_wi);
  IRAIPKANANO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIPKANANAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIPKANALEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //11
  inc(g_wi);
  IRAISEXNO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAISEXNAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAISEXLEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //12
  inc(g_wi);
  IRAIBIRTHDAYNO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIBIRTHDAYNAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIBIRTHDAYLEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //13
  inc(g_wi);
  IRAIPOSTCODE1NO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIPOSTCODE1NAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIPOSTCODE1LEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //14
  inc(g_wi);
  IRAIADDRESS1NO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIADDRESS1NAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIADDRESS1LEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //15
  inc(g_wi);
  IRAITEL1NO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAITEL1NAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAITEL1LEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //16
  inc(g_wi);
  IRAIPOSTCODE2NO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIPOSTCODE2NAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIPOSTCODE2LEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //17
  inc(g_wi);
  IRAIADDRESS2NO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIADDRESS2NAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIADDRESS2LEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //18
  inc(g_wi);
  IRAITEL2NO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAITEL2NAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAITEL2LEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //19
  inc(g_wi);
  IRAIBYOUTOIDNO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIBYOUTOIDNAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIBYOUTOIDLEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //20
  inc(g_wi);
  IRAIBYOUTONAMENO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIBYOUTONAMENAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIBYOUTONAMELEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //21
  inc(g_wi);
  IRAIROOMIDNO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIROOMIDNAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIROOMIDLEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //22
  inc(g_wi);
  IRAIKANGOKBNNO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIKANGOKBNNAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIKANGOKBNLEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //23
  inc(g_wi);
  IRAIKANJAKBNNO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIKANJAKBNNAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIKANJAKBNLEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //24
  inc(g_wi);
  IRAIKYUGOKBNNO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIKYUGOKBNNAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIKYUGOKBNLEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //25
  inc(g_wi);
  IRAIYOBIKBNNO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIYOBIKBNNAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIYOBIKBNLEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //26
  inc(g_wi);
  IRAISYOGAINO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAISYOGAINAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAISYOGAILEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //27
  inc(g_wi);
  IRAIHEIGHTNO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIHEIGHTNAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_N;
  g_Stream01_IRAI[g_wi].size   := IRAIHEIGHTLEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //28
  inc(g_wi);
  IRAIWEIGHTNO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIWEIGHTNAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_N;
  g_Stream01_IRAI[g_wi].size   := IRAIWEIGHTLEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //29
  inc(g_wi);
  IRAIBLOODABONO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIBLOODABONAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIBLOODABOLEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //30
  inc(g_wi);
  IRAIBLOODRHNO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIBLOODRHNAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIBLOODRHLEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //31
  inc(g_wi);
  IRAIKANSENNO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIKANSENNAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIKANSENLEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //32
  inc(g_wi);
  IRAIKANSENCOMNO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIKANSENCOMNAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIKANSENCOMLEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //33
  inc(g_wi);
  IRAIKINKINO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIKINKINAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIKINKILEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //34
  inc(g_wi);
  IRAIKINKICOMNO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIKINKICOMNAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIKINKICOMLEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //35
  inc(g_wi);
  IRAININSINNO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAININSINNAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAININSINLEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //36
  inc(g_wi);
  IRAIDETHDATENO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIDETHDATENAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIDETHDATELEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //37
  inc(g_wi);
  IRAIORDERNO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIORDERNAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIORDERLEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //38
  inc(g_wi);
  IRAISTARTDATENO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAISTARTDATENAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAISTARTDATELEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //39
  inc(g_wi);
  IRAISTARTTIMENO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAISTARTTIMENAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAISTARTTIMELEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //40
  inc(g_wi);
  IRAISATUEICODENO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAISATUEICODENAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAISATUEICODELEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //41
  inc(g_wi);
  IRAISATUEINAMENO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAISATUEINAMENAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAISATUEINAMELEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //42
  inc(g_wi);
  IRAIINOUTKBNNO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIINOUTKBNNAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIINOUTKBNLEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //43
  inc(g_wi);
  IRAISECTIONCODENO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAISECTIONCODENAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAISECTIONCODELEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //44
  inc(g_wi);
  IRAISECTIONNAMENO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAISECTIONNAMENAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAISECTIONNAMELEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //45
  inc(g_wi);
  IRAIDOCTORCODENO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIDOCTORCODENAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIDOCTORCODELEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //46
  inc(g_wi);
  IRAIDOCTORNAMENO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIDOCTORNAMENAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIDOCTORNAMELEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //47
  inc(g_wi);
  IRAIKINKYUKBNNO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIKINKYUKBNNAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIKINKYUKBNLEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //48
  inc(g_wi);
  IRAISIKYUKBNNO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAISIKYUKBNNAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAISIKYUKBNLEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //49
  inc(g_wi);
  IRAIGENZOUKBNNO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIGENZOUKBNNAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIGENZOUKBNLEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //50
  inc(g_wi);
  IRAIYOYAKUKBNNO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIYOYAKUKBNNAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIYOYAKUKBNLEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //51
  inc(g_wi);
  IRAIDOKUEIKBNNO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIDOKUEIKBNNAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIDOKUEIKBNLEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //52
  inc(g_wi);
  IRAIKBN6NO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIKBN6NAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIKBN6LEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //53
  inc(g_wi);
  IRAIKBN7NO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIKBN7NAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIKBN7LEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //54
  inc(g_wi);
  IRAIUPDATEDATENO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIUPDATEDATENAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIUPDATEDATELEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //55
  inc(g_wi);
  IRAIGROUPCOUNTNO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIGROUPCOUNTNAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_N;
  g_Stream01_IRAI[g_wi].size   := IRAIGROUPCOUNTLEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //56
  inc(g_wi);
  IRAIMOKUTEKILENNO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIMOKUTEKILENNAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_N;
  g_Stream01_IRAI[g_wi].size   := IRAIMOKUTEKILENLEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //57
  inc(g_wi);
  IRAIMOKUTEKINO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIMOKUTEKINAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIMOKUTEKILEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //58
  inc(g_wi);
  IRAISIJILENNO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAISIJILENNAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_N;
  g_Stream01_IRAI[g_wi].size   := IRAISIJILENLEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //59
  inc(g_wi);
  IRAISIJINO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAISIJINAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAISIJILEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //60
  inc(g_wi);
  IRAISONOTALENNO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAISONOTALENNAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_N;
  g_Stream01_IRAI[g_wi].size   := IRAISONOTALENLEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //61
  inc(g_wi);
  IRAISONOTANO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAISONOTANAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAISONOTALEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //62
  inc(g_wi);
  IRAIBYOUMEILENNO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIBYOUMEILENNAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_N;
  g_Stream01_IRAI[g_wi].size   := IRAIBYOUMEILENLEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //63
  inc(g_wi);
  IRAIBYOUMEINO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIBYOUMEINAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIBYOUMEILEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //64
  inc(g_wi);
  IRAIGROUPNO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIGROUPNAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIGROUPLEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //65
  inc(g_wi);
  IRAIORDERSTATUSNO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIORDERSTATUSNAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIORDERSTATUSLEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //66
  inc(g_wi);
  IRAIACCOUNTSTATUSNO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIACCOUNTSTATUSNAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIACCOUNTSTATUSLEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //67
  inc(g_wi);
  IRAIORDEREXDATENO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIORDEREXDATENAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIORDEREXDATELEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //68
  inc(g_wi);
  IRAIORDEREXTIMENO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIORDEREXTIMENAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIORDEREXTIMELEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //69
  inc(g_wi);
  IRAIKOUMOKUCODENO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIKOUMOKUCODENAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIKOUMOKUCODELEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //70
  inc(g_wi);
  IRAIKOUMOKUNAMENO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIKOUMOKUNAMENAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIKOUMOKUNAMELEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //71
  inc(g_wi);
  IRAIORDERSYUCODENO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIORDERSYUCODENAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIORDERSYUCODELEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //72
  inc(g_wi);
  IRAIORDERSYUNAMENO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIORDERSYUNAMENAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIORDERSYUNAMELEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //73
  inc(g_wi);
  IRAIBUICODENO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIBUICODENAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIBUICODELEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //74
  inc(g_wi);
  IRAIBUINAMENO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIBUINAMENAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIBUINAMELEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //75
  inc(g_wi);
  IRAIKENSAROOMCODENO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIKENSAROOMCODENAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIKENSAROOMCODELEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //76
  inc(g_wi);
  IRAIKENSAROOMNAMENO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIKENSAROOMNAMENAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIKENSAROOMNAMELEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //77
  inc(g_wi);
  IRAIMEISAICOUNTNO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIMEISAICOUNTNAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIMEISAICOUNTLEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //78
  inc(g_wi);
  IRAIYRECKBNNO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIYRECKBNNAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIYRECKBNLEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //79
  inc(g_wi);
  IRAIYKMKCODENO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIYKMKCODENAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIYKMKCODELEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //80
  inc(g_wi);
  IRAIYKMKNAMENO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIYKMKNAMENAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIYKMKNAMELEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //81
  inc(g_wi);
  IRAIYUSENO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIYUSENAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIYUSELEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //82
  inc(g_wi);
  IRAIYBUNKATUNO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIYBUNKATUNAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIYBUNKATULEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //83
  inc(g_wi);
  IRAIYYOBINO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAIYYOBINAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAIYYOBILEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //84
  inc(g_wi);
  IRAICRECKBNNO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAICRECKBNNAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAICRECKBNLEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //85
  inc(g_wi);
  IRAICKMKCODENO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAICKMKCODENAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAICKMKCODELEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //86
  inc(g_wi);
  IRAICKMKNAMENO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAICKMKNAMENAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAICKMKNAMELEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //87
  inc(g_wi);
  IRAICYOBINO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAICYOBINAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAICYOBILEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //88
  inc(g_wi);
  IRAISRECKBNNO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAISRECKBNNAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAISRECKBNLEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //89
  inc(g_wi);
  IRAISNAMENO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAISNAMENAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAISNAMELEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //90
  inc(g_wi);
  IRAISINFONO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAISINFONAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAISINFOLEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
  //91
  inc(g_wi);
  IRAISYOBINO := g_wi;
  g_Stream01_IRAI[g_wi].name   := IRAISYOBINAME;
  g_Stream01_IRAI[g_wi].x9     := G_FIELD_C;
  g_Stream01_IRAI[g_wi].size   := IRAISYOBILEN;
  g_Stream01_IRAI[g_wi].offset := g_Stream01_IRAI[g_wi-1].size + g_Stream01_IRAI[g_wi-1].offset;
end;

finalization
begin
//
end;

end.
