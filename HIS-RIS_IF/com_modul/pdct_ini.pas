unit pdct_ini;
{
■機能説明 （使用予定：あり）
 EXEプロジェクトに固有のini情報定義
 定義のみで処理は基本的に書かないこと
■履歴
新規作成：2000.10.27：担当  iwai
修正    ：2000.12.19：増田 DB_ACCから"const"を移動
修正    ：2001.02.21：iwai RIG接続情報を追加
修正    ：2001.02.21：増田 新しくカラーを追加
                           g_MODE_CURSOR_COLOR = 'CURSOR';
                           表にカーソルが当たっている場合の色(ﾃﾞｰﾀｷｰ)
修正01：03：13 : iwai
                           符号化方式を追加
修正    ：2001.03.15：増田 gi_RIG_Usedを追加
                           送信中フラグ
修正    ：2001.03.15：増田 g_MODE_SATUEIDISPLAYを追加
修正    ：2001.09.25：iwai
        gi_RIG_Usedを削除
修正    ：2001.10.23：増田
        //乳児/小児年齢範囲（セクションキー）
        g_PARAMETER = 'PARAMETER';
        //乳児年齢範囲（ﾃﾞｰﾀキー）
        g_PARAMETER_NYUUJI = 'NYUUJI';
        //小児年齢範囲（ﾃﾞｰﾀキー）
        g_PARAMETER_SHOUNI = 'SHOUNI';
        を設定
修正　　：2003.12.11：谷川 伝票印刷フラグ用ｾｸｼｮﾝｷｰ.ﾃﾞｰﾀｷｰを追加。
追加    ：2004.01.13：小泉 ｷｰﾎﾞｰﾄﾞｲﾝﾀｰﾌｪｰｽ用ｾｸｼｮﾝｷｰ,ﾃﾞｰﾀｷｰ追加
追加    ：2004.01.22：小泉 ﾚﾎﾟｰﾄ連携用ﾊﾟﾗﾒｰﾀ(ReportRis登録フラグ)追加
追加    ：2004.04.09：小泉 ﾀﾞﾐｰ患者ID設定追加
追加    ：2004.04.28：増田 W9表示コメントID設定追加
}
interface //*****************************************************************
//使用ユニット---------------------------------------------------------------
uses
//システムのでそれ以外は追加しないこと－－－－－－－－－－－－－－－－－－－－－
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
  FileCtrl,
  Registry,
  ExtCtrls,
  ComCtrls,
  StdCtrls,
  Grids;
////型クラス宣言-------------------------------------------------------------
//type
//定数宣言-------------------------------------------------------------------
const
//プロダクト固有情報↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
G_SYSPID      = 'FM000W00';    //共通部ID
G_SYSERROR00  = '00';          //ｴﾗｰｺｰﾄﾞ
G_DBID        = 'FM000W99';    //DB部ID
G_DBERROR02   = '02';          //MainCONECTｴﾗｰｺｰﾄﾞ
G_DBERROR03   = '03';          //MainConect中
G_SYSTEM_USERID = 'yokogawa';  //システムユーサID
G_SYSTEM_USERPASS = 'huris';   //上記パスワード
//↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑

//INIファイル情報↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
//実行単位のINIファイル名（環境パス）
 G_PRODUCT_INI_NAME = 'RIS_SYS.INI';
 //セクション：サブDBシステム情報
  g_PLS1_DB_SECSION = 'DBPLS1';
    g_PLS1_UID_KEY         = 'dbuid'     ;//キーDB接続ユーザID
        g_PLS1_DB_ACCOUNT  = 'pls1'   ;//デフォルト INIで設定可変となるため使用不可
    g_PLS1_USERPSS_KEY     = 'dbpss'     ;//キーユーザパスワード
        g_PLS1_DB_PASS     = 'pls1'   ;//デフォルト INIで設定可変となるため使用不可
    g_PLS1_DBNAME_KEY      = 'dbname'    ;//キーDBname
        g_PLS1_DB_NAME     = 'pls1ORA';//デフォルト INIで設定可変となるため使用不可
    g_PLS1_DB_CONECT_KEY   = 'dbcntmax'  ;//キーDB初期接続最大数
        g_PLS1_DB_CONECT_N = '0'         ;//デフォルトDB初期接続最大数


//ini情報読込域 ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑

 //WINMASTERで使用している文字列の定義（各自使うものが定義する）↓↓↓↓↓↓↓↓
 G_PASSWORD_SEC = 'PASSWORD';
   G_MSTPAS_KEY   = 'MST'  ;
   G_MSTSYSPAS_KEY   = 'MSTSYS'  ;
 G_CARD_INFO_SEC = 'CARD_INFO';
   G_CARDKIND_KEY   = 'CARDKIND'  ;
   G_CARDPORT_KEY   = 'CARDPORT'  ;
 G_IDT_INFO_SEC = 'IDT_INFO';
   G_IDTPORT1_KEY   = 'IDTPORT1'  ;
   G_IDTPORT2_KEY   = 'IDTPORT2'  ;
   G_IDTPORT3_KEY   = 'IDTPORT3'  ;
//DB_ACCから移動
  g_ALL_TEXT = '';
  g_SCREENCOLOR = 'SCREENCOLOR';   //ｾｸｼｮﾝｷｰ
  g_MODE_JUNBI = 'MODE1';          //準備系画面カラーﾓｰﾄﾞ(ﾃﾞｰﾀｷｰ)
  g_MODE_UKETUKE = 'MODE2';        //受付系画面カラーﾓｰﾄﾞ(ﾃﾞｰﾀｷｰ)
  g_MODE_JISEKI = 'MODE3';         //実績系画面カラーﾓｰﾄﾞ(ﾃﾞｰﾀｷｰ)
  g_MODE_INSATU = 'MODE4';         //印刷系画面カラーﾓｰﾄﾞ(ﾃﾞｰﾀｷｰ)
  g_MODE_SANSYOU = 'MODE8';        //参照系画面カラーﾓｰﾄﾞ(ﾃﾞｰﾀｷｰ)
  g_MODE_MENTE = 'MODE9';          //マスタメンテ系画面カラーﾓｰﾄﾞ(ﾃﾞｰﾀｷｰ)
  g_MODE_INPUT = 'INPUT';          //必須入力カラーﾓｰﾄﾞ(ﾃﾞｰﾀｷｰ)
  g_MODE_KYOUTYOU = 'KYOUTYOU';    //強調カラーﾓｰﾄﾞ(ﾃﾞｰﾀｷｰ)
  //g_MODE_ORDERSINFO = 'ORDERSINFO';//ｵｰﾀﾞ情報の表色(ﾃﾞｰﾀｷｰ)
  //g_MODE_SATUEISINFO = 'SATUEISINFO'; //撮影情報の表色(ﾃﾞｰﾀｷｰ)
  //g_MODE_SATUEI1_COLOR = 'SATUEI1_COLOR'; //撮影進捗"済"の色(ﾃﾞｰﾀｷｰ)
  //g_MODE_SATUEI2_COLOR = 'SATUEI2_COLOR'; //撮影進捗"消"の色(ﾃﾞｰﾀｷｰ)
  g_MODE_CURSOR_COLOR = 'CURSOR';         //表にカーソルが当たっている場合の色(ﾃﾞｰﾀｷｰ) 2001.02.21
  g_MODE_NOTCURSOR_COLOR = 'NOTCURSOR';         //表にカーソルが当たっていない場合の色(ﾃﾞｰﾀｷｰ)
  //g_MODE_SATUEIDISPLAY = 'SATUEIDISPLAY'; //再撮影、Ｘ造以降のCR/FP送信の撮影進捗ダイアログの色(ﾃﾞｰﾀｷｰ) 2001.04.12
  g_MODE_VISUALDISPLAY = 'VISUALDISPLAY'; //ビジュアル表示の色(ﾃﾞｰﾀｷｰ) 2001.09.23
  g_MODE_SINCHOKU1_COLOR = 'SINCHOKU1';         //部位進捗ｶﾗｰ(済)
  g_MODE_SINCHOKU2_COLOR = 'SINCHOKU2';         //部位進捗ｶﾗｰ(中止)
  g_MODE_RIGBTN_COLOR = 'RIGBTN';         //RIG送信ボタンｶﾗｰ
  g_MODE_FCRBTN_COLOR = 'FCRBTN';         //FCR送信ボタンｶﾗｰ
//2002.11.19
  g_MODE_MIUKE = 'MIUKE';               //未受付ステータス表示背景色
  g_MODE_YOBIDASI = 'YOBIDASI';         //呼出ステータス表示背景色
  g_MODE_TIKOKU = 'TIKOKU';             //遅刻ステータス表示背景色
  g_MODE_UKEZUMI = 'UKEZUMI';           //受付済ステータス表示背景色
  g_MODE_KAKUHO = 'KAKUHO';             //確保ステータス表示背景色
  g_MODE_KENCYUU = 'KENCYUU';           //検査中ステータス表示背景色
  g_MODE_TAKENCYUU = 'TAKENCYUU';       //他検査検査中ステータス表示背景色
  g_MODE_HORYUU = 'HORYUU';             //保留ステータス表示背景色
  g_MODE_SAIYOBI = 'SAIYOBI';           //再呼出ステータス表示背景色
  g_MODE_SAIUKE = 'SAIUKE';             //再受付ステータス表示背景色
  g_MODE_KENZUMI = 'KENZUMI';           //検査済ステータス表示背景色
  g_MODE_CYUUSI = 'CYUUSI';             //中止ステータス表示背景色
  g_MODE_SYUDOU = 'SYUDOU';             //手動表示ボタン色
  g_MODE_JIDOU = 'JIDOU';               //自動表示ボタン色
  g_MODE_OTOKOKUTI = 'OTOKOKUTI';       //音告知表示ボタン色
//2002.11.19
  g_GET_DATA = 'DATA';             //取得項目名"ﾃﾞｰﾀ"
  g_GET_BIKO = 'BIKO';             //取得項目名"備考"
  g_TIMEKIND = 'TIMEKIND';         //タイマー機能取得
  g_TIME = 'TIME';                 //タイマー時間取得
  g_ROWLIMIT = 'ROWLIMIT';         //表示最大行取得
  g_PRINTER_INFO = 'PRINTER_INFO'; //プリンター情報取得
  g_PRINTERNAME = 'PRINTERNAME';   //プリンター名取得
  g_DISPNAME = 'DISPNAME';         //帳票タイトル取得
  g_PORTNAME = 'PORTNAME';         //ポート取得
  g_DRIVERNAME = 'DRIVERNAME';     //ドライバ取得
  g_SYSTEM = '*';                  //ｼｽﾃﾑ名
  g_COPIES = 'COPIES';             //印刷部数
  g_PRINT_INFO = 'PRINT_INFO';     //プリンター情報取得(端末ごと)
  g_PRINTERNO = 'PRINTERNO';       //プリンター情報取得
  g_PRINTTITLE = 'PRINTTITLE';     //帳票ﾀｲﾄﾙ取得
  g_IRAI_PRINT_INFO = 'IRAI_PRINT_INFO';     //プリンター情報取得(依頼区分ごと)
  //WORKLIST情報
  g_HOSP = 'HOSP';                 //ｾｸｼｮﾝｷｰ
   g_HOSP_NAME = 'NAME';            //病院名
   g_HOSP_NAME_ENG = 'NAMEENGLSH';  //病院名(英語)
   g_HOSP_ADDRESS = 'ADDRESS';      //病院住所
   g_HOSP_ADDRESS_ENG ='ADDRESSENGLISH'; //病院住所（英語）
   g_BUSYO_NAME = 'BUSYO';          //部署名
   g_BUSYO_NAME_ENG = 'BUSYOENGLISH'; //部署名(英語)
   g_HOSP_ZOUEIZAI = 'ZOUEIZAI';   //日替わり造影剤
   g_HOSP_ZOUEIZAI_NYUIN  = 'ZOUEIZAI1'; //日替わり造影剤（入院） //2003.12.08
   g_HOSP_ZOUEIZAI_GAIRAI = 'ZOUEIZAI2'; //日替わり造影剤（外来） //2003.12.08
   g_HOSP_INSATU = 'INSATU';   //当該帳票印刷
   g_HOSP_RADIOGRAPHYID = 'RADIOGRAPHYID';   //放射線科ＩＤ
  //2004.01.13
  //ｷｰﾎﾞｰﾄﾞｲﾝﾀｰﾌｪｰｽ設定
  g_KEYBORDIFKEY = 'KEYBOADIFKEY'; //ｾｸｼｮﾝｷｰ
   g_KEYBOADIFKEY_DATAKEY = 'SYOKUIN'; //取得項目名"ﾃﾞｰﾀ"
   g_KEYBOADIFKEY_ADDKEYCODE = 'ADDKEYCODE'; //STXのキーコード 2004.01.29
   g_KEYBOADIFKEY_ADDSTRING = 'ADDSTRING'; //付加キャラクタ 2004.01.29
//2003.04.03
   g_HOSP_FILM = 'FILM';   //フィルム自動計算（フィルムID複数カンマ編集）
  //2002.10.22 追加
  g_HOSP_SUID = 'SUID';            //StudyInstancdUID
  //2002.11.05 追加
  g_HOSP_IRAIDOCTORNO = 'IRAIDOCTORNO'; //依頼医利用者番号
  g_HOSP_DENPYOHOKENPTN = 'DENPYOHOKENPTN'; //保険パターン
  //2002.11.27 追加
  g_HOSP_RISNO  = 'RISNO';              //RISオーダ上２桁
  g_WORKLIST_INFO = 'WORKLISTINFO';//ｾｸｼｮﾝｷｰ
  g_WORKLIST_UID = 'YCH_UID';      //山形JobインスタンスUID
  g_WORKLIST_I_ROMA = 'I_ROMA';    //予約された実行医師名(ROMA)
  g_WORKLIST_I_KANJI = 'I_KANJI';  //予約された実行医師名(漢字)
  g_WORKLIST_I_KANA = 'I_KANA';    //予約された実行医師名(カナ)
  //フォーマット情報
  g_FORMAT = 'FORMAT';             //ｾｸｼｮﾝｷｰ
  g_FORMAT_KANJAID = 'KANJAID';    //患者IDフォーマット
  g_FORMAT_KUGIRI  = 'KUGIRI';     //区切
  //０件メッセージ表示情報
  g_ZERODISPLAY = 'ZERODISPLAY';   //０件メッセージ表示
  {2001.10.23 Start}
  //乳児/小児年齢範囲（セクションキー）
  g_PARAMETER = 'PARAMETER';
  //乳児年齢範囲（ﾃﾞｰﾀキー）
  g_PARAMETER_NYUUJI = 'NYUUJI';
  //小児年齢範囲（ﾃﾞｰﾀキー）
  g_PARAMETER_SHOUNI = 'SHOUNI';
  {2001.10.23 End}
  //IE情報
  g_IE_INFO            = 'IE';             //ｾｸｼｮﾝｷｰ
    g_IE_NAME            = 'NAME';           //IE名称
    g_IE_MODULE          = 'MODULE';         //IEモジュール名称
    g_IE_VINSTITLE       = 'VINSTITLE';      //IE画像連携用ﾌﾞﾗｳｻﾞ終了ﾀｲﾄﾙ候補
    g_IE_REPORTTITLE     = 'REPORTTITLE';    //IEﾚﾎﾟｰﾄ用ﾌﾞﾗｳｻﾞ終了ﾀｲﾄﾙ候補
    g_IE_SHEMA           = 'SHEMA';          //IEｼｪｰﾏ用ﾌﾞﾗｳｻﾞ終了ﾀｲﾄﾙ
  //HTTP情報
  g_HTTP_INFO          = 'HTTP';           //ｾｸｼｮﾝｷｰ
    g_HTTP_REPORT        = 'REPORT';         //レポートHTTP
//2002.11.05 追加
  //患者プロファイル情報取得メッセージ
  g_MSG          = 'MSG';           //取得要求メッセージ
//2002.11.08 追加
  g_FIELDCOLOR         = 'FIELDCOLOR';     //ｾｸｼｮﾝｷｰ
//2002.11.16 追加
  //WEB連携用
  g_VINS ='VINS';                  //ｾｸｼｮﾝｷｰ
  g_VINS_IP ='IP';                 //(連携先IPｱﾄﾞﾚｽ)(ﾃﾞｰﾀｷｰ)
  g_VINS_WEBDIR ='WEBDIR';         //(画像参照先 ｻﾑﾈｲﾙ/直接画像)(ﾃﾞｰﾀｷｰ)
  g_VINS_SHOWMODE ='SHOWMODE';     //(画像参照先 0:ｻﾑﾈｲﾙ/1:直接画像)(ﾃﾞｰﾀｷｰ)
  g_VINS_PATIENTID ='PATIENTID';   //WEB連携用ﾊﾟﾗﾒｰﾀ(患者ID)
  g_VINS_DATE ='DATE';             //WEB連携用ﾊﾟﾗﾒｰﾀ(日付)
  g_VINS_ACCESSION ='ACCESSION';   //WEB連携用ﾊﾟﾗﾒｰﾀ(ｵｰﾀﾞNO)
  g_VINS_MODALITY ='MODALITY';     //WEB連携用ﾊﾟﾗﾒｰﾀ(ﾓﾀﾞﾘﾃｨﾀｲﾌﾟ)
//2002.12.03 追加
  //ﾚﾎﾟｰﾄ連携用
  g_REPORT ='REPORT';                   //ｾｸｼｮﾝｷｰ
  g_REPORT_HTTP ='HTTP';                //ﾚﾎﾟｰﾄHTTP
  g_REPORT_PATIENTID ='PATIENTID';      //ﾚﾎﾟｰﾄ連携用ﾊﾟﾗﾒｰﾀ(患者ID)
  g_REPORT_DATE ='DATE';                //ﾚﾎﾟｰﾄ連携用ﾊﾟﾗﾒｰﾀ(日付)
  g_REPORT_ACCESSION ='ACCESSION';      ///ﾚﾎﾟｰﾄ連携用ﾊﾟﾗﾒｰﾀ(ｵｰﾀﾞNO)
  g_REPORT_MODALITY ='MODALITY';        //ﾚﾎﾟｰﾄ連携用ﾊﾟﾗﾒｰﾀ(ﾓﾀﾞﾘﾃｨﾀｲﾌﾟ)
  //2004.01.22
  g_REPORT_YOYAKU = 'YOYAKU';       //ﾚﾎﾟｰﾄ連携用ﾊﾟﾗﾒｰﾀ(ReportRis登録フラグ)
//2002.11.22
  g_RENRAKU ='RENRAKU';  //ﾒｲﾝﾒﾆｭｰ用連絡メモ(ﾃﾞｰﾀｷｰ)
//2002.11.28
  //MWM連携用
  g_MWM = 'MWM';                   //ｾｸｼｮﾝｷｰ
  g_MWM_IP ='REMOTEHOST';          //(MWM接続先IPｱﾄﾞﾚｽ)(ﾃﾞｰﾀｷｰ)
  g_MWM_PORT ='REMOTEPORT';        //(MWM接続先ﾎﾟｰﾄ)(ﾃﾞｰﾀｷｰ)
  g_MWM_TIME ='TIMEOUT';           //(MWMﾀｲﾑｱｳﾄ)(ﾃﾞｰﾀｷｰ)
  //ｼｪｰﾏ用
  g_SHEMA ='HTML';                 //ｾｸｼｮﾝｷｰ
  g_SHEMA_FILE_PASS ='SHEMA';      //ｼｪｰﾏｵﾘｼﾞﾅﾙﾌｧｲﾙﾊﾟｽ

//2003.12.11 追加
//伝票印刷フラグ用
  g_MARK = 'MARK';               //ｾｸｼｮﾝｷｰ
  g_MARK_DENPYOPRINT_KEY   = 'DENPYOPRINT';
 g_NAMELABEL_SEC = 'NAMELABLE';
   g_KENSATYPEPRINT_KEY   = 'KENSATYPEPRINT';

//2004.02.05
//RISオーダの送信キュー作成設定
  g_RISORDER = 'RISORDER';               //ｾｸｼｮﾝｷｰ
  g_RISORDER_SOUSIN   = 'SOUSIN';        //ﾃﾞｰﾀｷｰ

//2004.03.29 追加
//オンコール表示設定
  g_ON_CALL_SEC = 'ON_CALL';               //ｾｸｼｮﾝｷｰ
  g_ON_CALL_CHG_KEY   = 'CHG';

//2004.04.09
//ダミー患者ID設定
  g_DUMMYKANJA = 'DUMMYKANJA';           //ｾｸｼｮﾝｷｰ
  g_DUMMYKANJA_KEY = 'ID_';           //ﾃﾞｰﾀｷｰ（接頭）

//2004.04.28
//W9画面がプレチェック画面から呼ばれた場合の表示ID設定
  g_DISP_COMID = 'DISP_COMID';           //ｾｸｼｮﾝｷｰ
  g_DISP_COMID_KEY = 'COMID';           //ﾃﾞｰﾀｷｰ

  g_MODE_ZOUEIF_COLOR = 'ZOUEIF';         //ﾌﾟﾚﾁｪｯｸ時要造影ｶﾗｰ

//↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑

//変数宣言-------------------------------------------------------------------
var
//ini情報読込域 ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
//サブ用DB
   gi_Pls1DB_Name       : string ; //BDEで設定されたｱﾘｱｽ名
   gi_Pls1DB_Account    : string ;//ORACLのアカウント
   gi_Pls1DB_Pass       : string ;   //ORACLのPASSWORD
   g_Pls1DB_CONECT_MAX  : integer;   //DB初期接続最大数

//ini情報読込域 ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑



//関数手続き宣言-------------------------------------------------------------
implementation //**************************************************************
//使用ユニット---------------------------------------------------------------
//uses
//定数宣言       -------------------------------------------------------------
const
W_KANRI_RMODE = '0';
W_KANRI_WMODE = '1';
//変数宣言     ---------------------------------------------------------------
//var
//関数手続き宣言--------------------------------------------------------------
initialization
begin
//1)デフォルト値
(**例
//1)値読込
     gi_Arqs_DB_Name   :=func_ReadIniKeyVale(g_ARQS_SECSION,
                                                   g_ARQS_DB_NAME_KEY,
                                                   gi_Arqs_DB_Name);

*)
//
end;

finalization
begin
//
end;

end.
