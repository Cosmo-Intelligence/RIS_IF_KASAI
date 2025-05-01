unit DB_ACC;
{
■機能説明
  DBの接続管理
  ◇使用説明
    一番始めに、func_DBMST_Open関数を呼んでください。
    ◆func_DBMST_Open ●機能:必要なﾏｽﾀのｵｰﾌﾟﾝ(ｸｴﾘｰ)
    そうすることによって、色情報、端末情報の取得、修正、追加、
    タイマー機能、時間、表示最大行、プリンターの情報取得関数が使用可能になります。
  ◇追加説明
    ＊メインのｸﾞﾙｰﾌﾟ番号は、'00'を指定してください。
    ＊ｸﾞﾙｰﾌﾟ番号が引数としてある場合は、ｸｴﾘｰｵｰﾌﾟﾝ時に指定したｸﾞﾙｰﾌﾟ番号を使用してください。 
■履歴
新規作成：2000.04.10：担当 iwai
修正    ：2000.04.10：担当 iwai
Error Msg関数を追加
修正：2000.11.02：iwai
セッションのグループ化等ＲＩＳ対応
追加：2000.11.06:増田
function func_DBMST_Open(arg_GroupNo:String): boolean ;
procedure proc_DBMST_Close(arg_GroupNo:String);
function func_Color(arg_GroupNo:String;
                    arg_Section_Key:string;
                    arg_Data_Key:string
                    ): string ;
を追加

追加：2000.11.08:増田
procedure proc_TBL_Open;
procedure proc_TBL_Close;
function func_Section_Key(arg_GroupNo:String): TStrings ;
function func_Data_Key(arg_GroupNo:String): TStrings ;
を追加

修正：2000.11.10:増田
function func_DBMST_Open(arg_GroupNo:String): boolean ;
procedure proc_DBMST_Close(arg_GroupNo:String);
function func_Color(arg_GroupNo:String;
                    arg_Section_Key:string;
                    arg_Data_Key:string
                    ): string ;
procedure proc_TBL_Open;
procedure proc_TBL_Close;
を修正

削除：2000.11.10:増田
function func_Section_Key(arg_GroupNo:String): TStrings ;
function func_Data_Key(arg_GroupNo:String): TStrings ;
を削除

追加：2000.11.20:増田
function func_Get_WinMaster(arg_GroupNo:String;
                            arg_Section_Key:string;
                            arg_Data_Key:string;
                            arg_Get:string
                            ): string ;
function func_Timer(arg_GroupNo:String;
                    arg_Program_ID:string
                    ): Boolean ;
function func_TimerInterval(arg_GroupNo:String;
                            arg_Program_ID:string
                            ): Integer ;
function func_RowLimit(arg_GroupNo:String;
                       arg_Program_ID:string
                       ): Integer ;
procedure proc_PrintInfo(arg_GroupNo:String;
                         arg_PrintNo:String;
                         var Print_name,
                             print_title,
                             print_port,
                             print_driver:String
                         );
function func_Write_WinMaster(arg_Database:TDatabase;
                              arg_Section_Key:String;
                              arg_Data_Key:String;
                              arg_Change_Name:String;
                              arg_Change:String;
                              arg_Update_flg:Integer;
                              arg_Win_flg:Integer
                              ): Boolean ;
を追加

修正：2000.11.20:増田
function func_Color(arg_GroupNo:String;
                    arg_Data_Key:string
                    ): string ;
を修正

追加：2000.11.21:増田
function func_Get_WinMaster_DATA(arg_GroupNo:String;
                                 arg_Section_Key:string;
                                 arg_Data_Key:string
                                 ): string ;
function func_Get_WinMaster_BIKO(arg_GroupNo:String;
                                 arg_Section_Key:string;
                                 arg_Data_Key:string
                                 ): string ;
procedure proc_Write_WinMaster_DATA(arg_Section_Key:String;
                                    arg_Data_Key:String;
                                    arg_Change:String
                                    );
procedure proc_Write_WinMaster_BIKO(arg_Section_Key:String;
                                    arg_Data_Key:String;
                                    arg_Change:String
                                    );
procedure proc_TBL_Refresh;
を追加

修正：2000.11.21:増田
function func_Timer(arg_GroupNo:String;
                    arg_Program_ID:string
                    ): Boolean ;
function func_TimerInterval(arg_GroupNo:String;
                            arg_Program_ID:string
                            ): Integer ;
function func_RowLimit(arg_GroupNo:String;
                       arg_Program_ID:string
                       ): Integer ;
procedure proc_PrintInfo(arg_GroupNo:String;
                         arg_PrintNo:String;
                         var Print_name,
                             print_title,
                             print_port,
                             print_driver:String;
                         var copies:Integer
                         );
procedure proc_Write_WinMaster(arg_Section_Key:String;
                               arg_Data_Key:String;
                               arg_Change_Name:String;
                               arg_Change:String;
                               arg_Win_flg:Integer
                               ) ;

を修正

追加：2000.12.01:増田
procedure proc_Irai_PrintInfo(
                     arg_GroupNo:String;
                     arg_PrintNo:String;
                     var Print_name,
                         print_title,
                         print_port,
                         print_driver:String;
                     var copies:Integer
                      );
を追加

追加：2000.12.08:増田
  g_MODE_KYOUTYOU = 'KYOUTYOU';    //強調カラーﾓｰﾄﾞ(ﾃﾞｰﾀｷｰ)
を追加

修正：2000.12.08:増田
  g_SYSTEM = 'SYSTEM'  → g_SYSTEM = '*'; //ｼｽﾃﾑ名
を修正

修正：2000.12.19：増田 DB_ACCから"const"を移動

修正：2001.04.07:杉山
function func_ID_Format(arg_GroupNo:String;
                        arg_Program_ID:string
                       ): String ;
function func_ZeroDisplay(arg_GroupNo:String;
                          arg_Program_ID:string
                         ): Boolean ;
を追加

修正：2001.08.29:iwai
セッションの統一化に伴う変更

修正：2001.08.29:増田
　　セッションの統一化に伴う変更

修正：2001.09.04:iwai
　　メッセージ関数に詳細をつけるために
　　関数をオーバロードする。
修正：2001.09.14:iwai
    MsgID取得処理等新規作成
}

interface

uses
//システム－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
  Windows, Messages,
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,StdCtrls,
  DBTables,Db, Variants,
//プロダクト開発共通－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
  gval, myInitInf, trace, pdct_ini,
  ErrorMsg;

type TRC_Db = record
  tStr_FormName:string;
  tObj_DBase:TDatabase;
  end;

type TRC_Qry = array of TQuery;

type TRC_WIN_DATA = record
  tWINKEY:TStringList;
  tSECTION_KEY:TStringList;
  tDATA_KEY:TStringList;
  tDATA:TStringList;
  tBIKO:TStringList;
  tOUTPUT_SEQ:TStringList;
  end;
  
type
  TDM_DbAcc = class(TDataModule)
    DBs_MSter: TDatabase;
    Q_Pass: TQuery;
    procedure DM_DbAccCreate(Sender: TObject);
    procedure DM_DbAccDestroy(Sender: TObject);
  private
    { Private 宣言 }
  public
    { Public 宣言 }
    ga_DBList : array of TRC_Db;
    gs_ErrCodMs:TStrings;
    gs_ErrMsgMs:TStrings;
    gs_MsgID:TStrings; //2001.09.14
    gs_ErrCodLogMod:TStrings;
    gs_ErrIcon:TStrings;
    ga_QRY_count:integer; //ｸｴﾘｰﾘｽﾄ数
    ga_TBL:TTable; //WINMASTER
    ga_TDS:TDataSource; //ﾃﾞｰﾀｿｰｽ
    ga_Qry_name:String; //ﾏｽﾀﾌｧｲﾙ名
    ga_Order_name:String; //ｵｰﾀﾞｰﾊﾞｲ句
    g_Qry_Flg:string;

    //2002.12.17
    ga_WinList : array of TRC_WIN_DATA;
    //2001.08.29
    g_WinMaster_DBS:TDatabase; //WINMASTER用データベース
    //ｸｴﾘｰﾘｽﾄ(各ﾏｽﾀごと)
    GQ_WinMaster_LIST:array of TQuery;

    function  func_DBSysDate:TDateTime;
    //●機能:DBの名称とorder by句のセット
    procedure proc_DBMst_order;
    //●機能:必要なﾏｽﾀのﾃｰﾌﾞﾙｵｰﾌﾟﾝ
    procedure proc_TBL_First;
  end;
//DB取得関数
function func_GetDB(arg_FromName : string) : TDatabase ;
//DB開放関数
function funcFreeDB(arg_FromName : string) : boolean ;
//●機能:高レベルIFのMSGBOX（OKﾎﾞﾀﾝのみ）
function func_DBMsgType1(
                     arg_Cap: string;   //タイトル
                     arg_ProID: string; //プログラムID
                     arg_ErrorNo: string; //エラーNO．
                     arg_Addstring:string //付帯文字列
                                         ):integer;overload; //復帰値：IDOK
function func_DBMsgType1(
                     arg_Cap: string;      //タイトル
                     arg_ProID: string;    //プログラムID
                     arg_ErrorNo: string;  //エラーNO．
                     arg_Addstring:string; //付帯文字列
                     arg_TForm:TForm       //オーナForm
                                         ):integer;overload; //復帰値：IDOK
function func_DBMsgType1(
                     arg_Cap: string;      //タイトル
                     arg_ProID: string;    //プログラムID
                     arg_ErrorNo: string;  //エラーNO．
                     arg_Addstring:string; //付帯文字列
                     arg_Detailsstring:string; //詳細文字列
                     arg_TForm:TForm       //オーナForm
                                         ):integer;overload; //復帰値：IDOK

function func_DBMsgType2(
                     arg_Cap: string;   //タイトル
                     arg_ProID: string; //プログラムID
                     arg_ErrorNo: string; //エラーNO．
                     arg_Addstring:string //付帯文字列
                                         ):integer;overload; //復帰値：IDOK IDCANCEL
function func_DBMsgType2(
                     arg_Cap: string;      //タイトル
                     arg_ProID: string;    //プログラムID
                     arg_ErrorNo: string;  //エラーNO．
                     arg_Addstring:string; //付帯文字列
                     arg_TForm:TForm       //オーナForm
                                         ):integer;overload; //復帰値：IDOK

//●機能:高レベルIFのMSGBOX（ﾎﾞﾀﾝなし表示）
procedure proc_DBMsgType3S(
                     arg_TForm:TForm; //入力不可にする親ﾌｫｰﾑ nil：親なし
                     arg_Cap: string; //タイトル
                     arg_ProID: string; //プログラムID
                     arg_ErrorNo: string; //エラーNO．
                     arg_Addstring:string //付帯文字列
                                         );
//●機能:高レベルIFのMSGBOX（ﾎﾞﾀﾝなし消去）
procedure proc_DBMsgType3E(
                     arg_TForm:TForm //入力不可を解除する親ﾌｫｰﾑ nil：親なし
                      );

//●機能:必要なﾏｽﾀのｵｰﾌﾟﾝ(ｸｴﾘｰ)
function func_DBMST_Open(
                     arg_GroupNo:String //ﾏｽﾀのｵｰﾌﾟﾝをするｸﾞﾙｰﾌﾟNo
                      ): boolean ;
{◇"func_DBMST_Open"詳細説明
    ・引数 arg_GroupNo：ｸﾞﾙｰﾌﾟNo｜String(2)
    ・戻り値 boolean(例外が発生するので見なくても使用可能)
    ・詳細説明
      ｸﾞﾙｰﾌﾟNoを指定することによって
      端末ﾏｽﾀのｸｴﾘｰｵｰﾌﾟﾝができる。
    ＊メインのｸﾞﾙｰﾌﾟ番号は、'00'を指定してください。
      メインの場合は、DB_ACCのｸﾘｴｲﾄ時にｸｴﾘｰを作成するように変更したので
      関数を呼ばなくてもｸｴﾘｰはｵｰﾌﾟﾝされています。
      (もちろん関数を呼んでもらってもかまいません。)}
//●機能:ﾏｽﾀのｸﾛｰｽﾞ(ｸｴﾘｰ)
procedure proc_DBMST_Close(
                     arg_GroupNo:String //ﾏｽﾀのｸﾛｰｽﾞをするｸﾞﾙｰﾌﾟNo
                      );
{◇"proc_DBMST_Close"詳細説明
    ・引数 arg_GroupNo：ｸﾞﾙｰﾌﾟNo｜String(2)
    ・戻り値 なし
    ・詳細説明
      ｸﾞﾙｰﾌﾟNoを指定することによって
      端末ﾏｽﾀのｸｴﾘｰｸﾛｰｽﾞができる。
    ＊メインのｸﾞﾙｰﾌﾟ番号は、'00'を指定してください。
    ＊ｸｴﾘｰｵｰﾌﾟﾝ時のｸﾞﾙｰﾌﾟ番号で呼び出してください。}
//●機能:必要な色情報
function func_Color(
                     arg_GroupNo:String; //ｸﾞﾙｰﾌﾟNo
                     arg_Data_Key:string   //ﾃﾞｰﾀｷｰ
                      ): string ;
{◇"func_Color"詳細説明
    ・引数 arg_GroupNo ：ｸﾞﾙｰﾌﾟNo｜String(2)
           arg_Data_Key：ﾃﾞｰﾀｷｰ  ｜String
           (arg_Section_Keyは削除しました。)
    ・戻り値 String
    ・詳細説明
      ｸﾞﾙｰﾌﾟNo、ﾃﾞｰﾀｷｰを指定することによって
      色情報を取得できる。
    ＊メインのｸﾞﾙｰﾌﾟ番号は、'00'を指定してください。
    ＊ｸｴﾘｰｵｰﾌﾟﾝ時のｸﾞﾙｰﾌﾟ番号で呼び出してください。}
//●機能:必要なﾏｽﾀのｵｰﾌﾟﾝ(ﾃｰﾌﾞﾙ)
procedure proc_TBL_Open;
{◇"proc_TBL_Open"詳細説明
    ・引数 なし
    ・戻り値 なし
    ・詳細説明
      端末ﾏｽﾀのﾃｰﾌﾞﾙがｵｰﾌﾟﾝができる。
    ＊ﾃｰﾌﾞﾙの最新情報を取得する場合は、
      "proc_TBL_Refresh"(ﾘﾌﾚｯｼｭ関数)を
      使用してください。}
//●機能:ﾏｽﾀのｸﾛｰｽﾞ(ﾃｰﾌﾞﾙ)
procedure proc_TBL_Close;
{◇"proc_TBL_Close"詳細説明
    ・引数 なし
    ・戻り値 なし
    ・詳細説明
      端末ﾏｽﾀのﾃｰﾌﾞﾙがｸﾛｰｽﾞができる。
    ＊ﾃｰﾌﾞﾙの最新情報を取得する場合は、
      "proc_TBL_Refresh"(ﾘﾌﾚｯｼｭ関数)を
      使用してください。}
//******************************************************************************
//* function name	: func_Query_TO_CBox
//* description		: Masterを読み込み、ComboBoxに内容を格納する。
//* Result		: Integer	(RET)	0	: 正常終了
//*						1	: 異常終了
//*
//*
//* < function >
//* function func_Text_TO_CBox( arg_CBox	: TComboBox;
//*                             arg_SpaceSet	: integer;
//*                             arg_AllSet	: integer;
//*                             arg_Text	: String
//*                           ):Integer;
//*
//******************************************************************************
function func_Query_TO_CBox( arg_Query 		: TQuery;	//Query
                          arg_FieldByName	: String;	//項目名
                          arg_CBox		: TComboBox;	//コンボボックス
                          arg_SpaceSet		: integer;	//'空白'  有無(0:なし、1:あり)
                          arg_AllSet		: integer;	//'すべて'有無(0:なし、1:あり)
                          arg_Text		: String 	//初期表示Text
                        ):Integer;
function func_Query_TO_CBox2( arg_Query 		: TQuery;	//Query
                          arg_FieldByName	: String;	//項目名
                          arg_CBox		: TComboBox;	//コンボボックス
                          arg_SpaceSet		: integer;	//'空白'  有無(0:なし、1:あり)
                          arg_FirstSet		: String;	// Queryの前にセットする値
                          arg_Text		: String 	//初期表示Text
                        ):Integer;
//******************************************************************************
//* function name	: func_Text_TO_CBox
//* description		: Textの内容でComboBoxのTextに表示する。
//*
//******************************************************************************
function func_Text_TO_CBox( arg_CBox		: TComboBox;	//コンボボックス
                            arg_SpaceSet	: integer;	//'空白'  有無(0:なし、1:あり)
                            arg_AllSet		: integer;	//'すべて'有無(0:なし、1:あり)
                            arg_Text		: String 	//初期表示Text
                          ):Integer;
function func_Text_TO_CBox2( arg_CBox		: TComboBox;	//コンボボックス
                            arg_SpaceSet	: integer;	//'空白'  有無(0:なし、1:あり)
                            arg_FirstSet    	: String;	// Queryの前にセットする値
                            arg_Text		: String 	//初期表示Text
                          ):Integer;
//●機能:端末情報の取得
function func_Get_WinMaster(
                     arg_GroupNo:String; //ｸﾞﾙｰﾌﾟNo
                     arg_Section_Key:string; //ｾｸｼｮﾝｷｰ
                     arg_Data_Key:string;  //ﾃﾞｰﾀｷｰ
                     arg_Get:string   //取得項目名
                      ): string ;
{◇"func_Get_WinMaster"詳細説明
    ・引数 arg_GroupNo    ：ｸﾞﾙｰﾌﾟNo  ｜String(2)
           arg_Section_Key：ｾｸｼｮﾝｷｰ   ｜String
           arg_Data_Key   ：ﾃﾞｰﾀｷｰ    ｜String
           arg_Get        ：取得項目名｜String (取得したいﾃｰﾌﾞﾙ項目名)
    ・戻り値 String
    ・詳細説明
      ｸﾞﾙｰﾌﾟNo、ｾｸｼｮﾝｷｰ、ﾃﾞｰﾀｷｰ、取得項目名を指定することによって
      端末情報を取得できる。
    ＊メインのｸﾞﾙｰﾌﾟ番号は、'00'を指定してください。
    ＊ｸｴﾘｰｵｰﾌﾟﾝ時のｸﾞﾙｰﾌﾟ番号で呼び出してください。
    ＊"func_Get_WinMaster_DATA"、"func_Get_WinMaster_BIKO"を、
      使用した方が引数が少なくて使いやすいと思います。}
//●機能:タイマー機能取得
function func_Timer(
                     arg_GroupNo:String; //ｸﾞﾙｰﾌﾟNo
                     arg_Program_ID:string //画面No
                      ): Boolean ;
{◇"func_Timer"詳細説明
    ・引数 arg_GroupNo   ：ｸﾞﾙｰﾌﾟNo｜String(2)
           arg_Program_ID：画面No  ｜String
    ・戻り値 Boolean(True = タイマー機能あり False = タイマー機能なし)
    ・詳細説明
      ｸﾞﾙｰﾌﾟNo、画面Noを指定することによって
      指定画面Noでタイマー機能が必要かどうか取得できる。
    ＊メインのｸﾞﾙｰﾌﾟ番号は、'00'を指定してください。
    ＊ｸｴﾘｰｵｰﾌﾟﾝ時のｸﾞﾙｰﾌﾟ番号で呼び出してください。}
//●機能:タイマー時間取得
function func_TimerInterval(
                     arg_GroupNo:String; //ｸﾞﾙｰﾌﾟNo
                     arg_Program_ID:string //画面No
                      ): Integer ;
{◇"func_TimerInterval"詳細説明
    ・引数 arg_GroupNo   ：ｸﾞﾙｰﾌﾟNo｜String(2)
           arg_Program_ID：画面No  ｜String
    ・戻り値 Integer
    ・詳細説明
      ｸﾞﾙｰﾌﾟNo、画面Noを指定することによって
      指定画面Noでのタイマー時間(ｲﾝﾀｰﾊﾞﾙ)を取得できる。
    ＊メインのｸﾞﾙｰﾌﾟ番号は、'00'を指定してください。
    ＊ｸｴﾘｰｵｰﾌﾟﾝ時のｸﾞﾙｰﾌﾟ番号で呼び出してください。}
//●機能:表示最大行取得
function func_RowLimit(
                     arg_GroupNo:String; //ｸﾞﾙｰﾌﾟNo
                     arg_Program_ID:string //画面No
                      ): Integer ;
{◇"func_RowLimit"詳細説明
    ・引数 arg_GroupNo   ：ｸﾞﾙｰﾌﾟNo｜String(2)
           arg_Program_ID：画面No  ｜String
    ・戻り値 Integer
    ・詳細説明
      ｸﾞﾙｰﾌﾟNo、画面Noを指定することによって
      指定画面Noでの検索の表示最大行を取得できる。
    ＊メインのｸﾞﾙｰﾌﾟ番号は、'00'を指定してください。
    ＊ｸｴﾘｰｵｰﾌﾟﾝ時のｸﾞﾙｰﾌﾟ番号で呼び出してください。}
//●機能:患者IDフォーマット形式取得
function func_ID_Format(
                     arg_GroupNo:String; //ｸﾞﾙｰﾌﾟNo
                     arg_Program_ID:string //画面No
                      ): String ;
{◇"func_ID_Format"詳細説明
    ・引数 arg_GroupNo   ：ｸﾞﾙｰﾌﾟNo｜String(2)
           arg_Program_ID：画面No  ｜String
    ・戻り値 String
    ・詳細説明
      ｸﾞﾙｰﾌﾟNo、画面Noを指定することによって
      患者IDのフォーマット形式を取得できる。(画面Noは未使用)
    ＊メインのｸﾞﾙｰﾌﾟ番号は、'00'を指定してください。
    ＊ｸｴﾘｰｵｰﾌﾟﾝ時のｸﾞﾙｰﾌﾟ番号で呼び出してください。}
//●機能:０件メッセージ表示取得
function func_ZeroDisplay(
                     arg_GroupNo:String; //ｸﾞﾙｰﾌﾟNo
                     arg_Program_ID:string //画面No
                      ): Boolean ;
{◇"func_ZeroDisplay"詳細説明
    ・引数 arg_GroupNo   ：ｸﾞﾙｰﾌﾟNo｜String(2)
           arg_Program_ID：画面No  ｜String
    ・戻り値 Boolean
    ・詳細説明
      ｸﾞﾙｰﾌﾟNo、画面Noを指定することによって
      指定画面Noでの検索の０件メッセージ表示を取得できる。
    ＊メインのｸﾞﾙｰﾌﾟ番号は、'00'を指定してください。
    ＊ｸｴﾘｰｵｰﾌﾟﾝ時のｸﾞﾙｰﾌﾟ番号で呼び出してください。}
//●機能:プリンターの情報取得(端末ごと)
procedure proc_PrintInfo(
                     arg_GroupNo:String; //ｸﾞﾙｰﾌﾟNo
                     arg_PrintNo:String; //ﾌﾟﾘﾝﾀNo
                     var Print_name,     //ﾌﾟﾘﾝﾀｰ名
                         print_title,    //帳票ﾀｲﾄﾙ
                         print_port,     //ﾎﾟｰﾄ
                         print_driver:String; //ﾄﾞﾗｲﾊﾞ
                     var copies:Integer  //印刷部数
                      );
{◇"proc_PrintInfo"詳細説明
    ・引数 arg_GroupNo：ｸﾞﾙｰﾌﾟNo｜String(2)
           arg_PrintNo：ﾌﾟﾘﾝﾀNo ｜String
    ・詳細説明
      ｸﾞﾙｰﾌﾟNo、ﾌﾟﾘﾝﾀNoを指定することによって
      指定ﾌﾟﾘﾝﾀNoのﾌﾟﾘﾝﾀｰ名、帳票ﾀｲﾄﾙ、ﾎﾟｰﾄ、ﾄﾞﾗｲﾊﾞ、印刷部数を取得できる。
      (var以下の引数の所に、変数をセットしてあげることによって
       ﾌﾟﾘﾝﾀｰ名、帳票ﾀｲﾄﾙ、ﾎﾟｰﾄ、ﾄﾞﾗｲﾊﾞ、印刷部数を取得できる。)
      (端末ごと)
    ＊ｸｴﾘｰｵｰﾌﾟﾝ時のｸﾞﾙｰﾌﾟ番号で呼び出してください。}
//●機能:端末情報の修正、追加
procedure proc_Write_WinMaster(
                     arg_Section_Key:String; //ｾｸｼｮﾝｷｰ
                     arg_Data_Key:String;    //ﾃﾞｰﾀｷｰ
                     arg_Change_Name:String; //変更項目名
                     arg_Change:String;      //変更内容
                     arg_Win_flg:Integer     //端末ｷｰ 0 = g_SYSTEM , 1 = "自端末名"
                      ) ;
{◇"proc_Write_WinMaster"詳細説明
    ・引数 arg_Section_Key：ｾｸｼｮﾝｷｰ   ｜String
           arg_Data_Key   ：ﾃﾞｰﾀｷｰ    ｜String
           arg_Change_Name：変更項目名｜String (変更したいﾃｰﾌﾞﾙ項目名)
           arg_Change     ：変更内容  ｜String
           arg_Win_flg    ：端末ｷｰ 0 = g_SYSTEM , 1 = "自端末名"｜Integer
    ・戻り値 なし
    ・詳細説明
      端末ｷｰ、ｾｸｼｮﾝｷｰ、ﾃﾞｰﾀｷｰで変更するﾚｺｰﾄﾞ指定する。
      変更項目名で変更する項目を指定する。
      変更内容は変更する文字列をセットする。
      arg_Win_flgで端末ｷｰ 0 = "SYSTEM" , 1 = "自端末名"を決定する。
    ＊端末情報の修正、追加を自端末の項目を変更する場合は、
      "proc_Write_WinMaster_DATA"、"proc_Write_WinMaster_BIKO"を、
      使用した方が引数が少なくて使いやすいと思います。}
//●機能:端末情報の取得(ﾃﾞｰﾀ項目)
function func_Get_WinMaster_DATA(
                     arg_GroupNo:String;     //ｸﾞﾙｰﾌﾟNo
                     arg_Section_Key:string; //ｾｸｼｮﾝｷｰ
                     arg_Data_Key:string     //ﾃﾞｰﾀｷｰ
                      ): string ;
{◇"func_Get_WinMaster_DATA"詳細説明
    ・引数 arg_GroupNo    ：ｸﾞﾙｰﾌﾟNo  ｜String(2)
           arg_Section_Key：ｾｸｼｮﾝｷｰ   ｜String
           arg_Data_Key   ：ﾃﾞｰﾀｷｰ    ｜String
    ・戻り値 String
    ・詳細説明
      ｸﾞﾙｰﾌﾟNo、ｾｸｼｮﾝｷｰ、ﾃﾞｰﾀｷｰを指定することによって
      端末情報(ﾃﾞｰﾀ項目)を取得できる。
    ＊メインのｸﾞﾙｰﾌﾟ番号は、'00'を指定してください。
    ＊ｸｴﾘｰｵｰﾌﾟﾝ時のｸﾞﾙｰﾌﾟ番号で呼び出してください。}
//●機能:端末情報の取得(備考項目)
function func_Get_WinMaster_BIKO(
                     arg_GroupNo:String;     //ｸﾞﾙｰﾌﾟNo
                     arg_Section_Key:string; //ｾｸｼｮﾝｷｰ
                     arg_Data_Key:string     //ﾃﾞｰﾀｷｰ
                      ): string ;
{◇"func_Get_WinMaster_BIKO"詳細説明
    ・引数 arg_GroupNo    ：ｸﾞﾙｰﾌﾟNo  ｜String(2)
           arg_Section_Key：ｾｸｼｮﾝｷｰ   ｜String
           arg_Data_Key   ：ﾃﾞｰﾀｷｰ    ｜String
    ・戻り値 String
    ・詳細説明
      ｸﾞﾙｰﾌﾟNo、ｾｸｼｮﾝｷｰ、ﾃﾞｰﾀｷｰを指定することによって
      端末情報(備考項目)を取得できる。
    ＊メインのｸﾞﾙｰﾌﾟ番号は、'00'を指定してください。
    ＊ｸｴﾘｰｵｰﾌﾟﾝ時のｸﾞﾙｰﾌﾟ番号で呼び出してください。}
//●機能:端末情報の修正、追加(ﾃﾞｰﾀ項目、自端末のみ)
procedure proc_Write_WinMaster_DATA(
                     arg_Section_Key:String; //ｾｸｼｮﾝｷｰ
                     arg_Data_Key:String;    //ﾃﾞｰﾀｷｰ
                     arg_Change:String       //変更内容
                      );
{◇"proc_Write_WinMaster_DATA"詳細説明
    ・引数 arg_Section_Key：ｾｸｼｮﾝｷｰ   ｜String
           arg_Data_Key   ：ﾃﾞｰﾀｷｰ    ｜String
           arg_Change     ：変更内容  ｜String
    ・戻り値 なし
    ・詳細説明
      ｾｸｼｮﾝｷｰ、ﾃﾞｰﾀｷｰで変更するﾚｺｰﾄﾞ指定する。
      変更内容は変更する文字列をセットする。
      変更は、自端末のﾃﾞｰﾀ項目だけです。}
//●機能:端末情報の修正、追加(備考項目、自端末のみ)
procedure proc_Write_WinMaster_BIKO(
                     arg_Section_Key:String; //ｾｸｼｮﾝｷｰ
                     arg_Data_Key:String;    //ﾃﾞｰﾀｷｰ
                     arg_Change:String       //変更内容
                      );
{◇"proc_Write_WinMaster_BIKO"詳細説明
    ・引数 arg_Section_Key：ｾｸｼｮﾝｷｰ   ｜String
           arg_Data_Key   ：ﾃﾞｰﾀｷｰ    ｜String
           arg_Change     ：変更内容  ｜String
    ・戻り値 なし
    ・詳細説明
      ｾｸｼｮﾝｷｰ、ﾃﾞｰﾀｷｰで変更するﾚｺｰﾄﾞ指定する。
      変更内容は変更する文字列をセットする。
      変更は、自端末の備考項目だけです。}
//●機能:ﾏｽﾀﾃｰﾌﾞﾙのﾘﾌﾚｯｼｭ
procedure proc_TBL_Refresh;
{◇"proc_TBL_Refresh"詳細説明
    ・引数 なし
    ・戻り値 なし
    ・詳細説明
      ﾃｰﾌﾞﾙをｸﾛｰｽﾞ、ｵｰﾌﾟﾝして最新情報をﾒﾓﾘｰ上に展開}
//●機能:プリンターの情報取得(依頼区分ごと)
procedure proc_Irai_PrintInfo(
                     arg_GroupNo:String; //ｸﾞﾙｰﾌﾟNo
                     arg_PrintNo:String; //ﾌﾟﾘﾝﾀNo
                     var Print_name,     //ﾌﾟﾘﾝﾀｰ名
                         print_title,    //帳票ﾀｲﾄﾙ
                         print_port,     //ﾎﾟｰﾄ
                         print_driver:String; //ﾄﾞﾗｲﾊﾞ
                     var copies:Integer  //印刷部数
                      );
{◇"proc_Irai_PrintInfo"詳細説明
    ・引数 arg_GroupNo：ｸﾞﾙｰﾌﾟNo｜String(2)
           arg_PrintNo：ﾌﾟﾘﾝﾀNo ｜String
    ・詳細説明
      ｸﾞﾙｰﾌﾟNo、ﾌﾟﾘﾝﾀNoを指定することによって
      指定ﾌﾟﾘﾝﾀNoのﾌﾟﾘﾝﾀｰ名、帳票ﾀｲﾄﾙ、ﾎﾟｰﾄ、ﾄﾞﾗｲﾊﾞ、印刷部数を取得できる。
      (var以下の引数の所に、変数をセットしてあげることによって
       ﾌﾟﾘﾝﾀｰ名、帳票ﾀｲﾄﾙ、ﾎﾟｰﾄ、ﾄﾞﾗｲﾊﾞ、印刷部数を取得できる。)
      (依頼区分ごと)
    ＊ｸｴﾘｰｵｰﾌﾟﾝ時のｸﾞﾙｰﾌﾟ番号で呼び出してください。}

//●端末マスタのデータ項目拡張に対応 2003.01.30
function func_Get_WinData1to20(arg_Query: TQuery):String;

//●指定テーブルに指定のフィールドが存在するかをチェック 2003.04.24
function func_Exsist_OraFeildName(arg_Query: TQuery;
                                  arg_TableName,
                                  arg_FeildName: String):Boolean;

//●予約時刻を所定の表記に変更 2004.03.29
function func_ChangeKensaStartTime(
                                   arg_GroupNo:String;   //ｸﾞﾙｰﾌﾟNo
                                   arg_StartTime:String  //予約時刻(9999)4桁
                                   ):String;


var
  DM_DbAcc: TDM_DbAcc;


{const
  g_ALL_TEXT = 'すべて';
  g_SCREENCOLOR = 'SCREENCOLOR';   //ｾｸｼｮﾝｷｰ
  g_MODE_YOYAKU = 'MODE1';         //予約系画面カラーﾓｰﾄﾞ(ﾃﾞｰﾀｷｰ)
  g_MODE_UKETUKE = 'MODE2';        //受付系画面カラーﾓｰﾄﾞ(ﾃﾞｰﾀｷｰ)
  g_MODE_JISEKI = 'MODE3';         //実績系画面カラーﾓｰﾄﾞ(ﾃﾞｰﾀｷｰ)
  g_MODE_SANSYOU = 'MODE8';        //参照系画面カラーﾓｰﾄﾞ(ﾃﾞｰﾀｷｰ)
  g_MODE_MENTE = 'MODE9';          //マスタメンテ系画面カラーﾓｰﾄﾞ(ﾃﾞｰﾀｷｰ)
  g_MODE_INPUT = 'INPUT';          //必須入力カラーﾓｰﾄﾞ(ﾃﾞｰﾀｷｰ)
  g_MODE_KYOUTYOU = 'KYOUTYOU';    //強調カラーﾓｰﾄﾞ(ﾃﾞｰﾀｷｰ)
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
  g_IRAI_PRINT_INFO = 'IRAI_PRINT_INFO';     //プリンター情報取得(依頼区分ごと)}

implementation
{$R *.DFM}

const
  PLACE_DB_ACC = 'データベースへの接続';
  ERRMSG_001 = '初期設定の最大接続数を超えました。';
  TAISHOMSG_001 = '最大接続数を超え接続には時間がかかります。';
  g_DBNAME_HEDER = 'DB_';
  g_MASTER_NAME = 'WINMASTER'; //ﾏｽﾀ名
  g_TBL_NAME = 'T_WINMASTER'; //ﾃｰﾌﾞﾙ名
  g_TDS_NAME = 'DS_WINMASTER'; //ﾃﾞｰﾀｿｰｽ名
  g_ORDER_NAME = 'WinKey'; //ｵｰﾀﾞｰﾊﾞｲ句の項目名
  g_QRY_COUNT = 11; //ｸｴﾘｰﾘｽﾄ数
  g_NOT_GROUP_NO = '00'; //ｸﾞﾙｰﾌﾟNo以外
  //2001.08.29
  g_WINMASTER_DBSNAME = 'WinmasterDBS'; //Winmaster用データベース名

//●機能:DBのシステム時間
function  TDM_DbAcc.func_DBSysDate:TDateTime;
//res:string
begin
   Q_Pass.close;
   Q_Pass.SQL.Clear;
   Q_Pass.SQL.Add('SELECT SYSDATE FROM DUAL');
   Q_Pass.Prepare;
   Q_Pass.Open;
   result := Q_Pass.FieldValues['SYSDATE'];
   Q_Pass.close;
   Q_Pass.UnPrepare;
end;

//●機能:ＤＢ接続制御初期処理
//Error:例外発生
procedure TDM_DbAcc.DM_DbAccCreate(Sender: TObject);
var
    w_MaxDBList :integer; //ＤＢ接続の最大保持数
    wi_DBi:integer; //ＤＢ接続参照ＩＮＤＥＸ
    w_i:integer;
    w_s:string;
begin
  //初期化済みなら何もしない
  if (DM_DbAcc <> nil) and (DM_DbAcc <> self) then
  begin
     Abort;
  end;
try
//1) 元となるDB接続情報の設定
//画面の本接続とは別にシステム制御用としてセッションを接続する
//（現状：時間所得のみ））
  DBs_MSter.Connected := false;
  DBs_MSter.Params.Clear;
  DBs_MSter.Params.Add( 'USER NAME=' + gi_DB_Account);
  DBs_MSter.Params.Add( 'PASSWORD=' + gi_DB_Pass);
  DBs_MSter.AliasName:=gi_DB_Name;
  DBs_MSter.Connected := false; //2001.08.29
  //DBs_MSter.Connected :=true; //2001.08.29
  //Q_Pass.DatabaseName := DBs_MSter.DatabaseName;

//2) ini情報の読み込み
  w_MaxDBList := g_DB_CONECT_MAX;
//DB接続数の読み込み（デフォルトは８個）

//3) 管理域の獲得
  SetLength (ga_DBList , w_MaxDBList);
//4) DBの作成と接続
  for wi_DBi:=0 to w_MaxDBList-1 do
  begin
    ga_DBList[wi_DBi].tStr_FormName := '';
    //2001.08.29 S
    if wi_DBi>0 then
    begin
    ga_DBList[wi_DBi].tObj_DBase := ga_DBList[0].tObj_DBase;
    end
    else
    begin

    ga_DBList[wi_DBi].tObj_DBase := TDatabase.Create(self);
    ga_DBList[wi_DBi].tObj_DBase.DatabaseName:= 'DB_' + inttostr(wi_DBi);
    ga_DBList[wi_DBi].tObj_DBase.Params.Clear;
    ga_DBList[wi_DBi].tObj_DBase.Params.Add( 'USER NAME=' + gi_DB_Account);
    ga_DBList[wi_DBi].tObj_DBase.Params.Add( 'PASSWORD=' + gi_DB_Pass);
    ga_DBList[wi_DBi].tObj_DBase.AliasName:=gi_DB_Name;
    ga_DBList[wi_DBi].tObj_DBase.HandleShared:=true;
    ga_DBList[wi_DBi].tObj_DBase.KeepConnection:=true;
    ga_DBList[wi_DBi].tObj_DBase.LoginPrompt:=false;
    ga_DBList[wi_DBi].tObj_DBase.Connected:=true;

    Q_Pass.DatabaseName := ga_DBList[wi_DBi].tObj_DBase.DatabaseName;
    end;
    //2001.08.29 E

  end;
//5)ERR情報の初期化
  gs_ErrCodMs:=TStringList.Create;
  gs_ErrMsgMs:=TStringList.Create;
  gs_MsgID   :=TStringList.Create; //2001.09.14
  gs_ErrCodLogMod:=TStringList.Create;
  gs_ErrIcon:=TStringList.Create;
  Q_Pass.close;
  Q_Pass.SQL.Clear;
  Q_Pass.SQL.Add('SELECT ');
  Q_Pass.SQL.Add('  ScreenID, ');
  Q_Pass.SQL.Add('  ErrorNo, ');
  Q_Pass.SQL.Add('  LogMode, ');
  Q_Pass.SQL.Add('  Icons, ');
  Q_Pass.SQL.Add('  DispMessage, ');
  Q_Pass.SQL.Add('  A.MessageCode MessageCode ');
  Q_Pass.SQL.Add(' from  ERRORCODEMASTER A,  ERRORMSGMASTER  B ');
  Q_Pass.SQL.Add(' where  A.MessageCode = B.MessageCode (+)    ');
  Q_Pass.SQL.Add(' order by  A.MessageCode  ');
//  Q_Pass.SQL.Add(' order by  ScreenID,  ErrorNo  ');
  Q_Pass.Open;
  Q_Pass.Last;
  Q_Pass.First;
  if Q_Pass.RecordCount <=0 then
  begin
    gs_ErrCodMs.Add('99999999'+'99');
    gs_ErrMsgMs.Add('DBのエラーメッセージが空です。');
    gs_MsgID.Add('999999'); //2001.09.14
  end
  else
  begin
   for w_i:=0 to Q_Pass.RecordCount-1 do
   begin
    gs_ErrCodMs.Add(
                    Q_Pass.FieldByName('ScreenID').AsString +
                    Q_Pass.FieldByName('ErrorNo').AsString
                     );
    if Q_Pass.FieldByName('DispMessage').IsNull then
    begin
      w_s := '';
    end
    else
    begin
      w_s:=Q_Pass.FieldByName('DispMessage').AsString;
    end;
    gs_ErrMsgMs.Add(w_s);

    if Q_Pass.FieldByName('LogMode').IsNull then
    begin
      w_s := '';
    end
    else
    begin
      w_s:=Q_Pass.FieldByName('LogMode').AsString;
    end;
    gs_ErrCodLogMod.Add(w_s);

    if Q_Pass.FieldByName('Icons').IsNull then
    begin
      w_s := '';
    end
    else
    begin
      w_s:=Q_Pass.FieldByName('Icons').AsString;
    end;
    gs_ErrIcon.Add(w_s);
//2001.09.14
    if Q_Pass.FieldByName('MessageCode').IsNull then
    begin
      w_s := '';
    end
    else
    begin
      w_s:=Q_Pass.FieldByName('MessageCode').AsString;
    end;
    gs_MsgID.Add(w_s);

    Q_Pass.Next;
   end;
   Q_Pass.Close;
  end;
  proc_DBMst_order;
  proc_TBL_First;
  //ｸﾞﾙｰﾌﾟ番号以外のｸｴﾘｰを作成
  func_DBMST_Open(g_NOT_GROUP_NO);
except
  on E: Exception do
  begin
    func_MsgType1(
                  g_CST_SYSERR,
                  'DB接続処理中に、エラーが起きました。'+ #13#10 +
                   E.Message,
                   '',
                   nil
                );
    Raise;
  end;
end;

end;

//●機能:
//Error:
procedure TDM_DbAcc.DM_DbAccDestroy(Sender: TObject);
var
  i:integer;
begin
  DM_DbAcc := nil;
  if gs_ErrCodMs<>nil then
  begin
    gs_ErrCodMs.Free;
    gs_ErrCodMs:=nil;
  end;
  if gs_ErrMsgMs<>nil then
  begin
    gs_ErrMsgMs.Free;
    gs_ErrMsgMs:=nil;
  end;
  if gs_MsgID<>nil then
  begin
    gs_MsgID.Free;
    gs_MsgID:=nil;
  end;
  if gs_ErrCodLogMod<>nil then
  begin
    gs_ErrCodLogMod.Free;
    gs_ErrCodLogMod:=nil;
  end;

  if g_Qry_Flg = '1' then begin
    for i := 0 to (ga_QRY_count - 1) do begin
      if GQ_WinMaster_LIST[i] <> nil then
        GQ_WinMaster_LIST[i].Free;
      //2002.12.17 start
      if ga_WinList[i].tWINKEY <> nil then begin
          ga_WinList[i].tWINKEY.Clear;
          ga_WinList[i].tWINKEY.Free;

          ga_WinList[i].tSECTION_KEY.Clear;
          ga_WinList[i].tSECTION_KEY.Free;

          ga_WinList[i].tDATA_KEY.Clear;
          ga_WinList[i].tDATA_KEY.Free;

          ga_WinList[i].tDATA.Clear;
          ga_WinList[i].tDATA.Free;

          ga_WinList[i].tBIKO.Clear;
          ga_WinList[i].tBIKO.Free;

          ga_WinList[i].tOUTPUT_SEQ.Clear;
          ga_WinList[i].tOUTPUT_SEQ.Free;
      end;
      //2002.12.17 end

    end;
  end;

  if ga_TBL <> nil then
    ga_TBL.Free;
  if ga_TDS <> nil then
    ga_TDS.Free;
  //2001.08.29
  if g_WinMaster_DBS <> nil then
    g_WinMaster_DBS.Free;
end;

//●機能:接続済みDBの取得
//ﾌｫｰﾑ毎の接続済みDBを取得する
//Error:例外発生
{$HINTS OFF}
function func_GetDB(arg_FromName : string) : TDatabase ;
var
    wi_DBi:integer; //ＤＢ接続参照ＩＮＤＥＸ
    w_resMSG:Word; //MSGBOX復帰値
begin
  result:=nil;
//１）管理ﾌｫｰﾑがﾛｰﾄﾞされていなければﾛｰﾄﾞする
  if DM_DbAcc=nil then DM_DbAcc:=TDM_DbAcc.Create(nil);
//２）管理域を検索して同一のﾌｫｰﾑ名のDBがあればそれを
//無ければ空のﾌｫｰﾑ名を復帰値とする
//それも無い時は時間がかかる旨を表示して作成接続処理を行う。
  //２）１同一のﾌｫｰﾑ名のDB
  for wi_DBi:=0 to high(DM_DbAcc.ga_DBList)  do
  begin
    if DM_DbAcc.ga_DBList[wi_DBi].tStr_FormName = arg_FromName then
    begin
       result:=DM_DbAcc.ga_DBList[wi_DBi].tObj_DBase;
       exit;
    end;
  end;
  //２）３ 空のﾌｫｰﾑ名のDB
  for wi_DBi:=0 to high(DM_DbAcc.ga_DBList)  do
  begin
    if DM_DbAcc.ga_DBList[wi_DBi].tStr_FormName = '' then
    begin
       DM_DbAcc.ga_DBList[wi_DBi].tStr_FormName:=arg_FromName;
       result:=DM_DbAcc.ga_DBList[wi_DBi].tObj_DBase;
       exit;
    end;
  end;
  //３） massage通知
{
  w_resMSG:=func_MsgDlg(
                        PLACE_DB_ACC + 'で、',
                        ERRMSG_001,
                        TAISHOMSG_001,
                        mtInformation,
                        [mbOK],
                        0
                        );
}
  //４） 新規作成
//proc_DBMsgType3S(nil,' ',G_DBID,G_DBERROR03,''); //2001.08.29
try
  SetLength (DM_DbAcc.ga_DBList , high(DM_DbAcc.ga_DBList) + 2);
  wi_DBi :=high(DM_DbAcc.ga_DBList);
  DM_DbAcc.ga_DBList[wi_DBi].tStr_FormName:='';
  //2001.08.29 E
  if wi_DBi>0 then
  begin
  DM_DbAcc.ga_DBList[wi_DBi].tObj_DBase  := DM_DbAcc.ga_DBList[0].tObj_DBase;
  end
  else
  begin
  DM_DbAcc.ga_DBList[wi_DBi].tObj_DBase :=TDatabase.Create(DM_DbAcc);
  DM_DbAcc.ga_DBList[wi_DBi].tObj_DBase.DatabaseName:=
   'DB_' + Inttostr(wi_DBi);
  DM_DbAcc.ga_DBList[wi_DBi].tObj_DBase.Params.Clear;
  DM_DbAcc.ga_DBList[wi_DBi].tObj_DBase.Params.Add( 'USER NAME=' + gi_DB_Account);
  DM_DbAcc.ga_DBList[wi_DBi].tObj_DBase.Params.Add( 'PASSWORD=' + gi_DB_Pass);
  DM_DbAcc.ga_DBList[wi_DBi].tObj_DBase.AliasName:=gi_DB_Name;
  DM_DbAcc.ga_DBList[wi_DBi].tObj_DBase.HandleShared:=true;
  DM_DbAcc.ga_DBList[wi_DBi].tObj_DBase.KeepConnection:=true;
  DM_DbAcc.ga_DBList[wi_DBi].tObj_DBase.LoginPrompt:=false;
  DM_DbAcc.ga_DBList[wi_DBi].tObj_DBase.Connected:= true;

  DM_DbAcc.Q_Pass.DatabaseName := DM_DbAcc.ga_DBList[wi_DBi].tObj_DBase.DatabaseName;
  end;
  //2001.08.29 S

  DM_DbAcc.ga_DBList[wi_DBi].tStr_FormName:=  arg_FromName;
  result:=DM_DbAcc.ga_DBList[wi_DBi].tObj_DBase;
//proc_DBMsgType3E(nil); //2001.08.29
except
  on E: Exception do
  begin
    proc_DBMsgType3E(nil);
    func_DBMsgType1(
                ' ',
                G_DBID,
                G_DBERROR02,
                #13#10 + E.Message
                );
    result:=nil;
    exit;
  end;
end;

end;
{$HINTS ON}

//●機能:使用しなくなったＤＢ接続の開放
//Error: 原則なし
function funcFreeDB(arg_FromName : string) : boolean ;
var
    wi_DBi:integer;
begin
  result:=true;
  if DM_DbAcc=nil then exit;
  for wi_DBi:=0 to high(DM_DbAcc.ga_DBList)  do
  begin
    if DM_DbAcc.ga_DBList[wi_DBi].tStr_FormName = arg_FromName then
    begin
       DM_DbAcc.ga_DBList[wi_DBi].tStr_FormName:='';
       exit;
    end;
  end;
end;

//●機能:高レベルIFのMSGBOX（OKﾎﾞﾀﾝのみ）
function func_DBMsgType1Base(
                     arg_Cap      : string;     //タイトル
                     arg_ProID    : string;     //プログラムID
                     arg_ErrorNo  : string;     //エラーNO．
                     arg_Addstring: string;     //付帯文字列
                     arg_Detail   : string;     //詳細文字列
                     arg_TForm    : TForm       //オーナForm
                                         ):integer; //復帰値：IDOK
var
  w_s:string;
  w_logmod:string;
  w_i:integer;
  w_Icon:string;
  w_MsgID:string;  //2001.09.14
begin
//DBMasterチェック
   if DM_DbAcc.gs_ErrCodMs=nil then
   begin
     result:=IDOK;
     exit;
   end;
//DBMaster検索
   w_i := DM_DbAcc.gs_ErrCodMs.IndexOf(arg_ProID+arg_ErrorNo);
   if w_i=-1 then//対象のMSGが無い時はデフォルトを設定
   begin
     if G_SYSERROR00 = arg_ErrorNo then
     begin//00はすべてｼｽﾃﾑｴﾗとする。
       w_i := DM_DbAcc.gs_ErrCodMs.IndexOf(G_SYSPID+G_SYSERROR00);
       if w_i=-1 then
       begin//存在しないメッセージ
         w_i := DM_DbAcc.gs_ErrCodMs.Count - 1;
       end;
     end
     else
     begin//存在しないメッセージ
       w_i := DM_DbAcc.gs_ErrCodMs.Count - 1;
     end;
   end;
//メッセージ等情報設定
   w_s:=DM_DbAcc.gs_ErrMsgMs[w_i];
   w_Icon:=DM_DbAcc.gs_ErrIcon[w_i];
   //2001.09.14
   w_MsgID:=DM_DbAcc.gs_MsgID[w_i];
//メッセージ表示
   result:=func_MsgType1(
                        arg_Cap,
                        w_s + arg_Addstring,
                        w_Icon,
                        w_MsgID,
                        arg_Detail,
                        arg_TForm
                        );
//Log出力
   w_logmod:=DM_DbAcc.gs_ErrCodLogMod[w_i];
   proc_TraceMsgLog(
                 arg_ProID+arg_ErrorNo,
                 w_s + arg_Addstring,
                 w_logmod
                 );

end;
function func_DBMsgType1(
                     arg_Cap: string;   //タイトル
                     arg_ProID: string; //プログラムID
                     arg_ErrorNo: string; //エラーNO．
                     arg_Addstring:string //付帯文字列
                                         ):integer;overload; //復帰値：IDOK
begin
   result:=func_DBMsgType1Base(
                  arg_Cap,
                  arg_ProID,
                  arg_ErrorNo,
                  arg_Addstring,
                  '',
                  nil);
end;
function func_DBMsgType1(
                     arg_Cap: string;      //タイトル
                     arg_ProID: string;    //プログラムID
                     arg_ErrorNo: string;  //エラーNO．
                     arg_Addstring:string; //付帯文字列
                     arg_TForm:TForm       //オーナForm
                                         ):integer;overload; //復帰値：IDOK
begin
   result:=func_DBMsgType1Base(
                   arg_Cap,
                   arg_ProID,
                   arg_ErrorNo,
                   arg_Addstring,
                   '',
                   arg_TForm);
end;
function func_DBMsgType1(
                     arg_Cap: string;      //タイトル
                     arg_ProID: string;    //プログラムID
                     arg_ErrorNo: string;  //エラーNO．
                     arg_Addstring:string; //付帯文字列
                     arg_Detailsstring:string; //詳細文字列
                     arg_TForm:TForm       //オーナForm
                                         ):integer;overload; //復帰値：IDOK
begin
   result:=func_DBMsgType1Base(
                   arg_Cap,
                   arg_ProID,
                   arg_ErrorNo,
                   arg_Addstring,
                   arg_Detailsstring,
                   arg_TForm);
end;


//●機能:高レベルIFのMSGBOX（OKﾎﾞﾀﾝのみ）
function func_DBMsgType2Base(
                     arg_Cap: string;   //タイトル
                     arg_ProID: string; //プログラムID
                     arg_ErrorNo: string; //エラーNO．
                     arg_Addstring:string; //付帯文字列
                     arg_TForm:TForm       //オーナForm
                                         ):integer; //復帰値：IDOK IDCANCEL
var
  w_logmod:string;
  w_Icon:string;
  w_res:string;
  w_s:string;
  w_i:integer;
  w_MsgID:string;//2001.09.14

begin
//DBMasterチェック
   //仕様でする必要なし。
//DBMaster検索
   w_i:=DM_DbAcc.gs_ErrCodMs.IndexOf(arg_ProID+arg_ErrorNo);
   if w_i=-1 then w_i:=DM_DbAcc.gs_ErrCodMs.Count-1;
//メッセージ等情報設定
   w_s:=DM_DbAcc.gs_ErrMsgMs[w_i];
   w_Icon:=DM_DbAcc.gs_ErrIcon[w_i];
   //2001.09.14
   w_MsgID:=DM_DbAcc.gs_MsgID[w_i];
//メッセージ表示
   result:=func_MsgType2(
                        arg_Cap,
                        w_s + arg_Addstring,
                        w_Icon,
                        w_MsgID,
                        arg_TForm
                        );
//Log出力
   w_logmod:=DM_DbAcc.gs_ErrCodLogMod[w_i];
   if IDOK =  result then
   begin
     w_res:='(OK)'
   end
   else
   begin
     w_res:='(ｷｬﾝｾﾙ)'
   end;
   proc_TraceMsgLog(
                 arg_ProID+arg_ErrorNo,
                 w_s + arg_Addstring+w_res,
                 w_logmod
                 );

end;
function func_DBMsgType2(
                     arg_Cap: string;   //タイトル
                     arg_ProID: string; //プログラムID
                     arg_ErrorNo: string; //エラーNO．
                     arg_Addstring:string //付帯文字列
                                         ):integer;overload; //復帰値：IDOK
begin
   result:=func_DBMsgType2Base(arg_Cap,arg_ProID,arg_ErrorNo,arg_Addstring,nil);
end;
function func_DBMsgType2(
                     arg_Cap: string;      //タイトル
                     arg_ProID: string;    //プログラムID
                     arg_ErrorNo: string;  //エラーNO．
                     arg_Addstring:string; //付帯文字列
                     arg_TForm:TForm       //オーナForm
                                         ):integer;overload; //復帰値：IDOK
begin
   result:=func_DBMsgType2Base(arg_Cap,arg_ProID,arg_ErrorNo,arg_Addstring,arg_TForm);
end;

//●機能:高レベルIFのMSGBOX（ﾎﾞﾀﾝなし表示）
procedure proc_DBMsgType3S(
                     arg_TForm:TForm; //入力不可にする親ﾌｫｰﾑ nil：親なし
                     arg_Cap: string; //タイトル
                     arg_ProID: string; //プログラムID
                     arg_ErrorNo: string; //エラーNO．
                     arg_Addstring:string //付帯文字列
                                         );
var
  w_s:string;
  w_Icon:string;
  w_i:integer;
begin
//DBMasterチェック
   //仕様でする必要なし。
//DBMaster検索
   w_i:=DM_DbAcc.gs_ErrCodMs.IndexOf(arg_ProID+arg_ErrorNo);
   if w_i=-1 then w_i:=DM_DbAcc.gs_ErrCodMs.Count-1;
//メッセージ等情報設定
   w_s:=DM_DbAcc.gs_ErrMsgMs[w_i];
   w_Icon:=DM_DbAcc.gs_ErrIcon[w_i];
//メッセージ表示
   proc_MsgType3S(
                 arg_TForm,
                 arg_Cap,
                 w_s + arg_Addstring
                        );
end;
//●機能:高レベルIFのMSGBOX（ﾎﾞﾀﾝなし消去）
procedure proc_DBMsgType3E(
                     arg_TForm:TForm //入力不可を解除する親ﾌｫｰﾑ nil：親なし
                      );
begin
   proc_MsgType3E(arg_TForm);
end;
//●機能:DBの名称とorder by句のセット
procedure TDM_DbAcc.proc_DBMst_order;
begin
  ga_Qry_name := g_MASTER_NAME;
  ga_Order_name := g_ORDER_NAME;
  ga_QRY_count := g_QRY_COUNT;
  g_Qry_Flg := '0';
end;

//●機能:必要なマスタのｵｰﾌﾟﾝ
function func_DBMST_Open(
                     arg_GroupNo:String //マスタのｵｰﾌﾟﾝをするフォームNo
                      ): boolean ;
var
  w_sQry_name,w_sQry_order:string;
  w_i_Group_no:integer;
  w_no,w_win_name,w_flg:string;
begin
  try

    DM_DbAcc.g_Qry_Flg := '1';
    w_flg := '0';

    if arg_GroupNo <> '' then begin
      w_i_Group_no := StrToInt(arg_GroupNo) - 1;
      if w_i_Group_no < 0 then
        w_i_Group_no := 10;
    end
    else
      w_i_Group_no := 10;

    //ｸｴﾘｰﾘｽﾄ作成
    SetLength (DM_DbAcc.GQ_WinMaster_LIST , DM_DbAcc.ga_QRY_count); //端末マスタ
    SetLength (DM_DbAcc.ga_WinList , DM_DbAcc.ga_QRY_count); //端末マスタ

    w_no := '_' + IntToStr(w_i_Group_no);
    if DM_DbAcc.GQ_WinMaster_LIST[w_i_Group_no] = nil then begin
      DM_DbAcc.GQ_WinMaster_LIST[w_i_Group_no] := TQuery.Create(DM_DbAcc);
      DM_DbAcc.GQ_WinMaster_LIST[w_i_Group_no].DatabaseName := DM_DbAcc.g_WinMaster_DBS.DatabaseName;
      DM_DbAcc.GQ_WinMaster_LIST[w_i_Group_no].DataSource := DM_DbAcc.ga_TDS;
      DM_DbAcc.GQ_WinMaster_LIST[w_i_Group_no].Name := 'GQ_WinMaster' + w_no;
      w_flg := '1';
    end;

    if w_flg = '1' then begin
      w_sQry_name := DM_DbAcc.ga_Qry_name;
      w_sQry_order := DM_DbAcc.ga_Order_name;
      w_win_name := func_GetMachineName;

      if DM_DbAcc.ga_WinList[w_i_Group_no].tWINKEY = nil then begin
        DM_DbAcc.ga_WinList[w_i_Group_no].tWINKEY      := TStringList.Create;
        DM_DbAcc.ga_WinList[w_i_Group_no].tSECTION_KEY := TStringList.Create;
        DM_DbAcc.ga_WinList[w_i_Group_no].tDATA_KEY    := TStringList.Create;
        DM_DbAcc.ga_WinList[w_i_Group_no].tDATA        := TStringList.Create;
        DM_DbAcc.ga_WinList[w_i_Group_no].tBIKO        := TStringList.Create;
        DM_DbAcc.ga_WinList[w_i_Group_no].tOUTPUT_SEQ  := TStringList.Create;
      end;

      if DM_DbAcc.ga_WinList[w_i_Group_no].tWINKEY.Count = 0 then begin
      with DM_DbAcc.GQ_WinMaster_LIST[w_i_Group_no] do begin
        Close;
        SQL.Clear;
        try
{
        SQL.Add('SELECT ');
        SQL.Add('  * ');
        SQL.Add(' from  '+w_sQry_name+' ');
        SQL.Add(' WHERE  (( WINKEY = '''+w_win_name+''') OR ( WINKEY = '''+g_SYSTEM+''' ))');
        SQL.Add(' order by  '+w_sQry_order+'');
}
        SQL.Add('SELECT WINKEY, SECTION_KEY, DATA_KEY, ');
        SQL.Add('        substr(DATA,1,100) DATA1, ');
        SQL.Add('        substr(DATA,101,100) DATA2, ');
        SQL.Add('        substr(DATA,201,100) DATA3, ');
        SQL.Add('        substr(DATA,301,100) DATA4, ');
        SQL.Add('        substr(DATA,401,100) DATA5, ');
        SQL.Add('        substr(DATA,501,100) DATA6, ');
        SQL.Add('        substr(DATA,601,100) DATA7, ');
        SQL.Add('        substr(DATA,701,100) DATA8, ');
        SQL.Add('        substr(DATA,801,100) DATA9, ');
        SQL.Add('        substr(DATA,901,100) DATA10, ');
        SQL.Add('        substr(DATA,1001,100) DATA11, ');
        SQL.Add('        substr(DATA,1101,100) DATA12, ');
        SQL.Add('        substr(DATA,1201,100) DATA13, ');
        SQL.Add('        substr(DATA,1301,100) DATA14, ');
        SQL.Add('        substr(DATA,1401,100) DATA15, ');
        SQL.Add('        substr(DATA,1501,100) DATA16, ');
        SQL.Add('        substr(DATA,1601,100) DATA17, ');
        SQL.Add('        substr(DATA,1701,100) DATA18, ');
        SQL.Add('        substr(DATA,1801,100) DATA19, ');
        SQL.Add('        substr(DATA,1901,100) DATA20, ');
        SQL.Add('        BIKO, OUTPUT_SEQ ');
        SQL.Add(' from  '+w_sQry_name+' ');
        SQL.Add(' WHERE  (( WINKEY = '''+w_win_name+''') OR ( WINKEY = '''+g_SYSTEM+''' ))');
        SQL.Add(' order by  '+w_sQry_order+'');
        if not Prepared then Prepare;
        Open;
        Last;
        First;
        while not (Eof) do begin
          DM_DbAcc.ga_WinList[w_i_Group_no].tWINKEY.Add(FieldByName('WINKEY').AsString);
          DM_DbAcc.ga_WinList[w_i_Group_no].tSECTION_KEY.Add(FieldByName('SECTION_KEY').AsString);
          DM_DbAcc.ga_WinList[w_i_Group_no].tDATA_KEY.Add(FieldByName('DATA_KEY').AsString);
          DM_DbAcc.ga_WinList[w_i_Group_no].tDATA.Add(func_Get_WinData1to20(DM_DbAcc.GQ_WinMaster_LIST[w_i_Group_no]));
          DM_DbAcc.ga_WinList[w_i_Group_no].tOUTPUT_SEQ.Add(FieldByName('OUTPUT_SEQ').AsString);
          Next;
        end;
        finally
          Close;
        end;
      end;
      end;
    end
    else if w_flg <> '1' then begin
//      DM_DbAcc.GQ_WinMaster_LIST[w_i_Group_no].Close;
//      DM_DbAcc.GQ_WinMaster_LIST[w_i_Group_no].Open;
    end;

    result:=True;
  except
    on E: Exception do begin
      DM_DbAcc.g_Qry_Flg := '0';
      raise;
    end;
  end;
end;

function func_Get_WinData1to20(arg_Query: TQuery):String;
var
  w_i: integer;
  w_sdata,w_s: string;
begin
  try
    Result := '';
    with arg_Query do begin
      for w_i := 1 to 20 do begin
        w_sdata := FieldByName('DATA'+IntToStr(W_i)).AsString;
        Result := Result + w_sdata;
      end;
    end;
  except
    raise;
  end;
end;

//●機能:マスタのｸﾛｰｽﾞ
procedure proc_DBMST_Close(
                     arg_GroupNo:String //マスタのｸﾛｰｽﾞをするｸﾞﾙｰﾌﾟNo
                      );
var
  w_i:integer;
begin
  w_i := StrToInt(arg_GroupNo) - 1;

  if DM_DbAcc.g_Qry_Flg = '1' then begin
    if DM_DbAcc.GQ_WinMaster_LIST[w_i] <> nil then
      DM_DbAcc.GQ_WinMaster_LIST[w_i].Close; //WINMASTER
  end;
end;
//●機能:色情報の獲得
function func_Color(
                     arg_GroupNo:String; //ｸﾞﾙｰﾌﾟNo
                     arg_Data_Key:string  //ﾃﾞｰﾀｷｰ
                      ): string ;
var
  w_ans:string;
begin
  w_ans := '';
  w_ans := func_Get_WinMaster(arg_GroupNo,g_SCREENCOLOR,arg_Data_Key,g_GET_DATA);
  //2001.04.12
  if w_ans = '' then
    //w_ans := '$8000000F';
    w_ans := '$00000000';
  Result := w_ans;
end;
//●機能:ﾏｽﾀﾃｰﾌﾞﾙ、ﾃﾞｰﾀｿｰｽの作成
procedure TDM_DbAcc.proc_TBL_First;
begin
  //WINMASTER用データベース作成
  if g_WinMaster_DBS = nil then begin
    //データベース格納変数作成
    g_WinMaster_DBS := TDatabase.Create(nil);
    //データベース作成
    g_WinMaster_DBS := func_GetDB(g_WINMASTER_DBSNAME);
  end;
  //ﾃｰﾌﾞﾙの作成
  if ga_TBL = nil then begin
    ga_TBL := TTable.Create(nil);
    ga_TBL.DatabaseName := g_WinMaster_DBS.DatabaseName;
    ga_TBL.TableName := g_MASTER_NAME; //WINMASTER
    ga_TBL.Name := g_TBL_NAME;
  end;
  //ﾃﾞｰﾀｿｰｽの作成
  if ga_TDS = nil then begin
    ga_TDS := TDataSource.Create(nil);
    ga_TDS.DataSet := ga_TBL;
    ga_TDS.Name := g_TDS_NAME;
  end;
  //ﾃｰﾌﾞﾙｵｰﾌﾟﾝ
  if ga_TBL <> nil then
    ga_TBL.Open;
end;
//●機能:必要なﾏｽﾀのｵｰﾌﾟﾝ(ﾃｰﾌﾞﾙ)
procedure proc_TBL_Open;
begin
  DM_DbAcc.proc_TBL_First;
end;
//●機能:ﾏｽﾀのｸﾛｰｽﾞ(ﾃｰﾌﾞﾙ)
procedure proc_TBL_Close;
begin
  if DM_DbAcc.ga_TBL <> nil then
    DM_DbAcc.ga_TBL.Close;
end;
//******************************************************************************
//* function name	: func_Query_TO_CBox
//* description		: Masterを読み込み、ComboBoxに内容を格納する。
//* Result		: Integer	(RET)	0	: 正常終了
//*						1	: 異常終了
//*
//*
//* < function >
//* function func_Text_TO_CBox( arg_CBox	: TComboBox;
//*                             arg_SpaceSet	: integer;
//*                             arg_AllSet	: integer;
//*                             arg_Text	: String
//*                           ):Integer;
//*
//******************************************************************************
function func_Query_TO_CBox( arg_Query 		: TQuery;	//Query
                          arg_FieldByName	: String;	//項目名
                          arg_CBox		: TComboBox;	//コンボボックス
                          arg_SpaceSet		: integer;	//'空白'  有無(0:なし、1:あり)
                          arg_AllSet		: integer;	//'すべて'有無(0:なし、1:あり)
                          arg_Text		: String 	//初期表示Text
                        ):Integer;
begin
  //戻り値初期化
  Result := 0;

  if arg_Query = nil then Exit;	        //Nil防止確認
  if arg_FieldByName = '' then Exit;	//Nil防止確認
  if arg_CBox = nil then Exit;		//Nil防止確認
  if (arg_SpaceSet <> 0) and (arg_SpaceSet <> 1) then arg_SpaceSet := 0;
  if (arg_AllSet <> 0) and (arg_AllSet <> 1) then arg_AllSet := 0;

  //コンボボックスリストのクリア
  arg_CBox.Items.Clear;

  //'空白'を格納
  if arg_SpaceSet = 1 then begin
    arg_CBox.Items.Add('');
  end;
  arg_CBox.ItemIndex := -1;

  //'すべて'を格納
  if arg_AllSet = 1 then begin
    arg_CBox.Items.Add(g_ALL_TEXT);
  end;

  with arg_Query do begin
    First;
    //取得データを格納
    While not EOF do begin
      arg_CBox.Items.Add(FieldByName(arg_FieldByName).AsString);
      Next;
    end;
  end;

{ //'すべて'を格納
  if arg_AllSet = 1 then begin
    arg_CBox.Items.Add(g_ALL_TEXT);
  end; }

  //TEXT表示
  func_Text_TO_CBox(arg_CBox,arg_SpaceSet,arg_AllSet,arg_Text);


end;
//******************************************************************************

//* function name	: func_Query_TO_CBox2
//* func_Query_TO_CBoxの改造 arg_AllSet：にString型を引数として追加し
//* arg_Queryの値の前にarg_AllSetの値をコンボボックスの値してセットする
//* description		: Masterを読み込み、ComboBoxに内容を格納する。
//* Result		: Integer	(RET)	0	: 正常終了
//*						1	: 異常終了
//*
//*
//* < function >
//* function func_Text_TO_CBox2( arg_CBox	: TComboBox;
//*                             arg_SpaceSet	: integer;
//*                             arg_FirstSet		: String;	// Queryの前にセットする値
//*                             arg_Text	: String
//*                           ):Integer;
//*
//******************************************************************************
function func_Query_TO_CBox2( arg_Query 		: TQuery;	//Query
                          arg_FieldByName	: String;	//項目名
                          arg_CBox		: TComboBox;	//コンボボックス
                          arg_SpaceSet		: integer;	//'空白'  有無(0:なし、1:あり)
                          arg_FirstSet		: String;	// Queryの前にセットする値
                          arg_Text		: String 	//初期表示Text
                        ):Integer;
begin
  //戻り値初期化
  Result := 0;

  if arg_Query = nil then Exit;	        //Nil防止確認
  if arg_FieldByName = '' then Exit;	//Nil防止確認
  if arg_CBox = nil then Exit;		//Nil防止確認
  if (arg_SpaceSet <> 0) and (arg_SpaceSet <> 1) then arg_SpaceSet := 0;
  //コンボボックスリストのクリア
  arg_CBox.Items.Clear;

  //'空白'を格納
  if arg_SpaceSet = 1 then begin
    arg_CBox.Items.Add('');
  end;
  arg_CBox.ItemIndex := -1;

  //'格納
  if arg_FirstSet <> '' then begin
    arg_CBox.Items.Add(arg_FirstSet);
  end;

  with arg_Query do begin
    First;
    //取得データを格納
    While not EOF do begin
      arg_CBox.Items.Add(FieldByName(arg_FieldByName).AsString);
      Next;
    end;
  end;

{ //'すべて'を格納
  if arg_AllSet = 1 then begin
    arg_CBox.Items.Add(g_ALL_TEXT);
  end; }

  //TEXT表示
  func_Text_TO_CBox2(arg_CBox,arg_SpaceSet,arg_FirstSet,arg_Text);


end;
//******************************************************************************
//* function name	: func_Text_TO_CBox
//* description		: Textの内容でComboBoxのTextに表示する。
//*
//******************************************************************************
function func_Text_TO_CBox( arg_CBox		: TComboBox;	//コンボボックス
                            arg_SpaceSet	: integer;	//'空白'  有無(0:なし、1:あり)
                            arg_AllSet		: integer;	//'すべて'有無(0:なし、1:あり)
                            arg_Text		: String 	//初期表示Text
                          ):integer;
var
  w_i: integer;
begin
  //戻り値初期化
  Result := 0;
  //ComboBoxのItemにTextがあるか探す
  if arg_Text <> '' then begin
    //該当なし
    if 0 > arg_CBox.Items.IndexOf(arg_Text) then begin
      if arg_AllSet <> 1 then begin	//'すべて'無しの場合
        arg_CBox.Items.Add(arg_Text);
      end else begin			//'すべて'有りの場合
        //最後の'すべて'を消去
        arg_CBox.Items.Delete(arg_CBox.Items.Count - 1);
        //改めてTextと'すべて'を追加
        arg_CBox.Items.Add(arg_Text);
        arg_CBox.Items.Add(g_ALL_TEXT);
      end;
    end;
  end;
  //Text検索
  w_i := arg_CBox.Items.IndexOf(arg_Text);
  //Text表示
  arg_CBox.ItemIndex := w_i;
end;
function func_Text_TO_CBox2( arg_CBox		: TComboBox;	//コンボボックス
                            arg_SpaceSet	: integer;	//'空白'  有無(0:なし、1:あり)
                            arg_FirstSet     	: String;	// Queryの前にセットする値
                            arg_Text		: String 	//初期表示Text
                          ):integer;
var
  w_i: integer;
begin
  //戻り値初期化
  Result := 0;
  //ComboBoxのItemにTextがあるか探す
  if arg_Text <> '' then begin
    //該当なし
    if 0 > arg_CBox.Items.IndexOf(arg_Text) then begin
      if arg_FirstSet = '' then begin	//の場合
        arg_CBox.Items.Add(arg_Text);
      end else begin			//の場合
        //最後の'すべて'を消去
        arg_CBox.Items.Delete(arg_CBox.Items.Count - 1);
        //改めてTextと'すべて'を追加
        arg_CBox.Items.Add(arg_Text);
        arg_CBox.Items.Add(arg_FirstSet);
      end;
    end;
  end;
  //Text検索
  w_i := arg_CBox.Items.IndexOf(arg_Text);
  //Text表示
  arg_CBox.ItemIndex := w_i;
end;
//●機能:端末情報の取得
function func_Get_WinMaster(
                     arg_GroupNo:String; //ｸﾞﾙｰﾌﾟNo
                     arg_Section_Key:string; //ｾｸｼｮﾝｷｰ
                     arg_Data_Key:string;  //ﾃﾞｰﾀｷｰ
                     arg_Get:string   //取得項目名
                      ): string ;
var
  w_i,w_j:integer;
  w_ans:string;
begin
  w_ans := '';
  if arg_GroupNo <> '' then begin
    w_i := StrToInt(arg_GroupNo) - 1;
    if w_i < 0 then
      w_i := 10;
  end
  else
    w_i := 10;

  if DM_DbAcc.GQ_WinMaster_LIST[w_i] <> nil then begin
{
    with DM_DbAcc.GQ_WinMaster_LIST[w_i] do begin
      try
        Close;
        //セクション、データキーの条件クリア
        ParamByName('PSECTION_KEY').Clear;
        ParamByName('PDATA_KEY').Clear;
        if (arg_Section_Key <> '') and (arg_Data_Key <> '') then begin
          //セクション、データキーの条件セット
          ParamByName('PSECTION_KEY').AsString := arg_Section_Key;
          ParamByName('PDATA_KEY').AsString := arg_Data_Key;
          Open;
          Last;
          First;
          if not(Eof) then begin
            w_ans := FieldByName('DATA').AsString;
          end;
        end;
      finally
        Close;
      end;
    end;
}
{
    if DM_DbAcc.GQ_WinMaster_LIST[w_i].Locate('Section_Key;Data_Key',
                                           VarArrayOf([arg_Section_Key,arg_Data_Key]), [loCaseInsensitive]) then
      w_ans := DM_DbAcc.GQ_WinMaster_LIST[w_i].FieldByName(arg_Get).AsString;
}
    with DM_DbAcc.ga_WinList[w_i] do begin
      for w_j := 0 to tWINKEY.Count -1 do begin
        if (tSECTION_KEY[w_j] = arg_Section_Key) and
           (tDATA_KEY[w_j] = arg_Data_Key) then begin

          if UpperCase(arg_Get) = 'WINKEY' then begin
            w_ans := tWINKEY[w_j];
          end else
          if UpperCase(arg_Get) = 'SECTION_KEY' then begin
            w_ans := tSECTION_KEY[w_j];
          end else
          if UpperCase(arg_Get) = 'DATA_KEY' then begin
            w_ans := tDATA_KEY[w_j];
          end else
          if UpperCase(arg_Get) = 'DATA' then begin
            w_ans := tDATA[w_j];
          end else
          if UpperCase(arg_Get) = 'BIKO' then begin
            w_ans := tBIKO[w_j];
          end else
          if UpperCase(arg_Get) = 'OUTPUT_SEQ' then begin
            w_ans := tOUTPUT_SEQ[w_j];
          end;
          Break;
        end;
      end;
    end;
  end;
  Result := w_ans;
end;
//●機能:端末情報の修正、追加
procedure proc_Write_WinMaster(
                     arg_Section_Key:String; //ｾｸｼｮﾝｷｰ
                     arg_Data_Key:String;    //ﾃﾞｰﾀｷｰ
                     arg_Change_Name:String; //変更項目名
                     arg_Change:String;      //変更内容
                     arg_Win_flg:Integer     //端末ｷｰ 0 = g_SYSTEM , 1 = "自端末名"
                      ) ;
var
  w_Win_name:string;
  w_qry:TQuery;
  w_Rec_Count:integer;
begin
  try
    w_qry := TQuery.Create(nil);
    //2001.08.29
    w_qry.DatabaseName := DM_DbAcc.g_WinMaster_DBS.DatabaseName;

    if arg_Win_flg = 0 then
      w_Win_name := g_SYSTEM
    else
      w_Win_name := func_GetMachineName;
    with w_qry do begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT DATA_KEY ');
      SQL.Add('FROM WINMASTER ');
      SQL.Add('WHERE WINKEY = '''+w_Win_name+'''');
      SQL.Add('AND SECTION_KEY = '''+arg_Section_Key+'''');
      SQL.Add('AND DATA_KEY = '''+arg_Data_Key+'''');
      if not Prepared then Prepare;
      Open;
      Last;
      First;
      w_Rec_Count := RecordCount;
    end;

    DM_DbAcc.g_WinMaster_DBS.StartTransaction;
    {2001.08.29 Start}
    with w_qry do begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT DATA_KEY ');
      SQL.Add('FROM WINMASTER ');
      SQL.Add('WHERE WINKEY = '''+w_Win_name+'''');
      SQL.Add('AND SECTION_KEY = '''+arg_Section_Key+'''');
      SQL.Add('AND DATA_KEY = '''+arg_Data_Key+'''');
      SQL.Add('FOR UPDATE');
      if not Prepared then Prepare;
      //Open;
      ExecSQL;
    end;
    {2001.08.29 End}
    with w_qry do begin
      Close;
      SQL.Clear;
      if w_Rec_Count = 0 then begin
        SQL.Add('INSERT INTO WINMASTER ( ');
        SQL.Add(' WINKEY, ');
        SQL.Add(' SECTION_KEY, ');
        SQL.Add(' DATA_KEY, ');
        SQL.Add(' '+arg_Change_Name+' ');
        SQL.Add(' ) VALUES ( ');
        SQL.Add(' :PWINKEY, ');
        SQL.Add(' :PSECTION_KEY, ');
        SQL.Add(' :PDATA_KEY, ');
        SQL.Add(' :PCHANGE ');
        SQL.Add(' ) ');
        ParamByName('PWINKEY').AsString := w_Win_name;           //端末名
        ParamByName('PSECTION_KEY').AsString := arg_Section_Key; //ｾｸｼｮﾝｷｰ
        ParamByName('PDATA_KEY').AsString := arg_Data_Key;       //ﾃﾞｰﾀｷｰ
        ParamByName('PCHANGE').AsString := arg_Change;           //変更項目
      end
      else begin
        SQL.Add('UPDATE WINMASTER');
        SQL.Add('SET '+arg_Change_Name+' = :PCHANGE');
        SQL.Add('WHERE WINKEY = :PWINKEY');
        SQL.Add('AND SECTION_KEY = :PSECTION_KEY');
        SQL.Add('AND DATA_KEY = :PDATA_KEY');
        ParamByName('PWINKEY').AsString := w_Win_name;           //端末名
        ParamByName('PSECTION_KEY').AsString := arg_Section_Key; //ｾｸｼｮﾝｷｰ
        ParamByName('PDATA_KEY').AsString := arg_Data_Key;       //ﾃﾞｰﾀｷｰ
        ParamByName('PCHANGE').AsString := arg_Change;           //変更項目
      end;
      ExecSQL;
    end;
    try
      //2001.08.29
      DM_DbAcc.g_WinMaster_DBS.Commit; // 成功した場合，変更をコミットする
      w_qry.Free;
    except
      raise;
      w_qry.Free;
    end;
  except
    raise;
    w_qry.Free;
  end;
end;
//●機能:タイマー機能取得
function func_Timer(
                     arg_GroupNo:String; //ｸﾞﾙｰﾌﾟNo
                     arg_Program_ID:string //画面No
                      ): Boolean ;
var
  w_ans:string;
  w_Bool:Boolean;
begin
  w_ans := '';
  w_Bool := False;
  //タイマー機能取得
  w_ans := func_Get_WinMaster(arg_GroupNo,arg_Program_ID,g_TIMEKIND,g_GET_DATA);

  if w_ans = '0' then
    w_Bool := False; //機能なし
  if w_ans = '1' then
    w_Bool := True;  //機能あり

  Result := w_Bool;
end;
//●機能:タイマー時間取得
function func_TimerInterval(
                     arg_GroupNo:String; //ｸﾞﾙｰﾌﾟNo
                     arg_Program_ID:string //画面No
                      ): Integer ;
var
  w_ians:integer;
  w_ans:string;
begin
  w_ans := '';
  w_ians := 0;
  //タイマー時間取得
  w_ans := func_Get_WinMaster(arg_GroupNo,arg_Program_ID,g_TIME,g_GET_DATA);

  if w_ans = '' then
    w_ians := 0;    //インターバルなし
  if w_ans <> '' then
    w_ians := StrToInt(w_ans) * 1000;  //インターバルあり

  Result := w_ians;
end;
//●機能:表示最大行取得
function func_RowLimit(
                     arg_GroupNo:String; //ｸﾞﾙｰﾌﾟNo
                     arg_Program_ID:string //画面No
                      ): Integer ;
var
  w_ians:integer;
  w_ans:string;
begin
  w_ans := '';
  w_ians := 0;
  //表示最大行取得
  w_ans := func_Get_WinMaster(arg_GroupNo,arg_Program_ID,g_ROWLIMIT,g_GET_DATA);

  if w_ans = '' then
    w_ians := 0;    //最大表示行なし
  if w_ans <> '' then
    w_ians := StrToInt(w_ans);  //最大表示行あり

  Result := w_ians;
end;
//●機能:患者IDフォーマット形式取得
function func_ID_Format(
                     arg_GroupNo:String; //ｸﾞﾙｰﾌﾟNo
                     arg_Program_ID:string //画面No
                      ): String ;
var
  w_ans:string;
begin
  w_ans := '';
  //患者IDフォーマット形式取得
  w_ans := func_Get_WinMaster(arg_GroupNo,g_FORMAT,g_FORMAT_KANJAID,g_GET_DATA);

  Result := w_ans;
end;
//●機能:０件メッセージ表示取得
function func_ZeroDisplay(
                     arg_GroupNo:String; //ｸﾞﾙｰﾌﾟNo
                     arg_Program_ID:string //画面No
                      ): Boolean ;
var
  w_ians:Boolean;
  w_ans:string;
begin
  w_ans := '';
  //０件メッセージ表示取得
  w_ans := func_Get_WinMaster(arg_GroupNo,arg_Program_ID,g_ZERODISPLAY,g_GET_DATA);

  if w_ans = '0' then
    w_ians := False    //０件メッセージ表示なし
  else
    w_ians := True;    //０件メッセージ表示あり

  Result := w_ians;
end;
//●機能:プリンターの情報取得
procedure proc_PrintInfo(
                     arg_GroupNo:String; //ｸﾞﾙｰﾌﾟNo
                     arg_PrintNo:String; //ﾌﾟﾘﾝﾀNo
                     var Print_name,     //ﾌﾟﾘﾝﾀｰ名
                         print_title,    //帳票ﾀｲﾄﾙ
                         print_port,     //ﾎﾟｰﾄ
                         print_driver:String; //ﾄﾞﾗｲﾊﾞ
                     var copies:Integer  //印刷部数
                      );
var
  w_i,w_print_copy:integer;
  w_P_No,w_sFilter:String;
begin
  if arg_GroupNo <> '' then begin
    w_i := StrToInt(arg_GroupNo) - 1;
    if w_i < 0 then
      w_i := 10;
  end
  else
    w_i := 10;
  if DM_DbAcc.GQ_WinMaster_LIST[w_i] <> nil then begin
    with DM_DbAcc.GQ_WinMaster_LIST[w_i] do begin
      //新規ﾌｨﾙﾀｰ作成
      w_sFilter := 'SECTION_KEY = ''' + g_PRINT_INFO + '''';
      Filter := w_sFilter;
      Filtered := True;
      FindFirst;
//2001.04.24
      w_print_copy := 1; //印刷あり
      copies := w_print_copy;
      While not (Eof) do begin
        //使用プリンタナンバー
        if Gval.Left(FieldByName('DATA_KEY').AsString ,9) = g_PRINTERNO then begin
          if Gval.Right(FieldByName('DATA_KEY').AsString ,2) = arg_PrintNo then begin
            w_P_No := FieldByName('DATA').AsString;
          end;
        end;
        //帳票タイトル
        if Gval.Left(FieldByName('DATA_KEY').AsString ,10) = g_PRINTTITLE then begin
          if Gval.Right(FieldByName('DATA_KEY').AsString ,2) = arg_PrintNo then begin
            print_title := FieldByName('DATA').AsString;
          end;
        end;
        //印刷部数
        if Gval.Left(FieldByName('DATA_KEY').AsString ,6) = g_COPIES then begin
          if Gval.Right(FieldByName('DATA_KEY').AsString ,2) = arg_PrintNo then begin
            if FieldByName('DATA').AsString <> '' then begin
              w_print_copy := FieldByName('DATA').AsInteger;
            end
            else if FieldByName('DATA').AsString = '' then begin
              w_print_copy := 1; //Nullは印刷あり
            end;
//2001.04.24
            //if w_print_copy <= 0 then
            // w_print_copy := 1;
            copies := w_print_copy;
          end;
        end;
        if not FindNext then
          Break;
      end;
      //ﾌｨﾙﾀｰ解除
      Filtered := False;
      //新規ﾌｨﾙﾀｰ作成
      w_sFilter := 'SECTION_KEY = ''' +g_PRINTER_INFO +'''';
      Filter := w_sFilter;
      Filtered := True;
      FindFirst;
      While not (Eof) do begin
        //プリンタ
        if Gval.Left(DM_DbAcc.GQ_WinMaster_LIST[w_i].FieldByName('DATA_KEY').AsString ,11) = g_PRINTERNAME then begin
          //帳票NOプリンタ
          if Gval.Right(FieldByName('DATA_KEY').AsString ,1) = w_P_No then begin
            Print_name := FieldByName('DATA').AsString;
          end;
        end;
        //ポート
        if Gval.Left(DM_DbAcc.GQ_WinMaster_LIST[w_i].FieldByName('DATA_KEY').AsString ,8) = g_PORTNAME then begin
          if Gval.Right(FieldByName('DATA_KEY').AsString ,1) = w_P_No then begin
            print_port := FieldByName('DATA').AsString;
          end;
        end;
        //ドライバ
        if Gval.Left(DM_DbAcc.GQ_WinMaster_LIST[w_i].FieldByName('DATA_KEY').AsString ,10) = g_DRIVERNAME then begin
          if Gval.Right(FieldByName('DATA_KEY').AsString ,1) = w_P_No then begin
            print_driver := FieldByName('DATA').AsString;
          end;
        end;
        if not FindNext then
          Break;
      end;
      //ﾌｨﾙﾀｰ解除
      Filtered := False;
    end;
  end;
end;
//●機能:端末情報の取得(ﾃﾞｰﾀ項目)
function func_Get_WinMaster_DATA(
                     arg_GroupNo:String;     //ｸﾞﾙｰﾌﾟNo
                     arg_Section_Key:string; //ｾｸｼｮﾝｷｰ
                     arg_Data_Key:string     //ﾃﾞｰﾀｷｰ
                      ): string ;
var
  w_ans:string;
begin
  try
    w_ans := '';

    w_ans := func_Get_WinMaster(arg_GroupNo,arg_Section_Key,arg_Data_Key,g_GET_DATA);

    Result := w_ans;
  except
    raise;
  end;
end;
//●機能:端末情報の取得(備考項目)
function func_Get_WinMaster_BIKO(
                     arg_GroupNo:String;     //ｸﾞﾙｰﾌﾟNo
                     arg_Section_Key:string; //ｾｸｼｮﾝｷｰ
                     arg_Data_Key:string     //ﾃﾞｰﾀｷｰ
                      ): string ;
var
  w_ans:string;
begin
  try
    w_ans := '';

    w_ans := func_Get_WinMaster(arg_GroupNo,arg_Section_Key,arg_Data_Key,g_GET_BIKO);

    Result := w_ans;
  except
    raise;
  end;
end;
//●機能:ﾏｽﾀﾃｰﾌﾞﾙのﾘﾌﾚｯｼｭ
procedure proc_TBL_Refresh;
begin
  proc_TBL_Close;
  proc_TBL_Open;
end;
//●機能:端末情報の修正、追加(ﾃﾞｰﾀ項目、自端末のみ)
procedure proc_Write_WinMaster_DATA(
                     arg_Section_Key:String; //ｾｸｼｮﾝｷｰ
                     arg_Data_Key:String;    //ﾃﾞｰﾀｷｰ
                     arg_Change:String       //変更内容
                      );
begin
  try
    proc_Write_WinMaster(arg_Section_Key,arg_Data_Key,g_GET_DATA,arg_Change,1);
  except
    raise;
  end;
end;
//●機能:端末情報の修正、追加(備考項目、自端末のみ)
procedure proc_Write_WinMaster_BIKO(
                     arg_Section_Key:String; //ｾｸｼｮﾝｷｰ
                     arg_Data_Key:String;    //ﾃﾞｰﾀｷｰ
                     arg_Change:String       //変更内容
                      );
begin
  try
    proc_Write_WinMaster(arg_Section_Key,arg_Data_Key,g_GET_BIKO,arg_Change,1);
  except
    raise;
  end;
end;
//●機能:プリンターの情報取得(依頼区分ごと)
procedure proc_Irai_PrintInfo(
                     arg_GroupNo:String; //ｸﾞﾙｰﾌﾟNo
                     arg_PrintNo:String; //ﾌﾟﾘﾝﾀNo
                     var Print_name,     //ﾌﾟﾘﾝﾀｰ名
                         print_title,    //帳票ﾀｲﾄﾙ
                         print_port,     //ﾎﾟｰﾄ
                         print_driver:String; //ﾄﾞﾗｲﾊﾞ
                     var copies:Integer  //印刷部数
                      );
var
  w_i,w_print_copy:integer;
  w_P_No,w_sFilter:String;
begin
  if arg_GroupNo <> '' then begin
    w_i := StrToInt(arg_GroupNo) - 1;
    if w_i < 0 then
      w_i := 10;
  end
  else
    w_i := 10;
  if DM_DbAcc.GQ_WinMaster_LIST[w_i] <> nil then begin
    with DM_DbAcc.GQ_WinMaster_LIST[w_i] do begin
      //新規ﾌｨﾙﾀｰ作成
      w_sFilter := 'SECTION_KEY = ''' + g_IRAI_PRINT_INFO + '''';
      Filter := w_sFilter;
      Filtered := True;
      FindFirst;
//2001.04.24
      w_print_copy := 1; //印刷あり
      copies := w_print_copy;
      While not (Eof) do begin
        //使用プリンタナンバー
        if Gval.Left(FieldByName('DATA_KEY').AsString ,9) = g_PRINTERNO then begin
          if Gval.Right(FieldByName('DATA_KEY').AsString ,2) = arg_PrintNo then begin
            w_P_No := FieldByName('DATA').AsString;
          end;
        end;
        //帳票タイトル
        if Gval.Left(FieldByName('DATA_KEY').AsString ,10) = g_PRINTTITLE then begin
          if Gval.Right(FieldByName('DATA_KEY').AsString ,2) = arg_PrintNo then begin
            print_title := FieldByName('DATA').AsString;
          end;
        end;
        //印刷部数
        if Gval.Left(FieldByName('DATA_KEY').AsString ,6) = g_COPIES then begin
          if Gval.Right(FieldByName('DATA_KEY').AsString ,2) = arg_PrintNo then begin
            w_print_copy := 0;
            if FieldByName('DATA').AsString <> '' then begin
              w_print_copy := FieldByName('DATA').AsInteger;
            end
            else if FieldByName('DATA').AsString = '' then begin
              w_print_copy := 1; //Nullは印刷あり
            end;
//2001.04.24
            //if w_print_copy <= 0 then
            // w_print_copy := 1;
            copies := w_print_copy;
          end;
        end;
        if not FindNext then
          Break;
      end;
      //ﾌｨﾙﾀｰ解除
      Filtered := False;
      //新規ﾌｨﾙﾀｰ作成
      w_sFilter := 'SECTION_KEY = ''' +g_PRINTER_INFO +'''';
      Filter := w_sFilter;
      Filtered := True;
      FindFirst;
      While not (Eof) do begin
        //プリンタ
        if Gval.Left(DM_DbAcc.GQ_WinMaster_LIST[w_i].FieldByName('DATA_KEY').AsString ,11) = g_PRINTERNAME then begin
          //帳票NOプリンタ
          if Gval.Right(FieldByName('DATA_KEY').AsString ,1) = w_P_No then begin
            Print_name := FieldByName('DATA').AsString;
          end;
        end;
        //ポート
        if Gval.Left(DM_DbAcc.GQ_WinMaster_LIST[w_i].FieldByName('DATA_KEY').AsString ,8) = g_PORTNAME then begin
          if Gval.Right(FieldByName('DATA_KEY').AsString ,1) = w_P_No then begin
            print_port := FieldByName('DATA').AsString;
          end;
        end;
        //ドライバ
        if Gval.Left(DM_DbAcc.GQ_WinMaster_LIST[w_i].FieldByName('DATA_KEY').AsString ,10) = g_DRIVERNAME then begin
          if Gval.Right(FieldByName('DATA_KEY').AsString ,1) = w_P_No then begin
            print_driver := FieldByName('DATA').AsString;
          end;
        end;
        if not FindNext then
          Break;
      end;
      //ﾌｨﾙﾀｰ解除
      Filtered := False;
    end;
  end;
end;
//●指定テーブルに指定のフィールドが存在するかをチェック 2003.04.24
function func_Exsist_OraFeildName(arg_Query: TQuery;
                                  arg_TableName,
                                  arg_FeildName: String):Boolean;
begin

  Result := False;
  
  with arg_Query do begin
    try
      Close;
      SQL.Clear;
      SQL.Add('SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS ');
      SQL.Add(' WHERE OWNER       = UPPER(''' + gi_DB_Account + ''') ');
      SQL.Add('   AND TABLE_NAME  = UPPER(''' + arg_TableName + ''') ');
      SQL.Add('   AND COLUMN_NAME = UPPER(''' + arg_FeildName + ''') ');
      Open;
      Last;
      First;
      if not Eof then Result := True;
      Close;
    except
      raise;
    end;
  end;
end;
//●予約時刻を所定の表記に変更 2004.03.29
function func_ChangeKensaStartTime(
                                   arg_GroupNo:String;   //ｸﾞﾙｰﾌﾟNo
                                   arg_StartTime:String  //予約時刻(9999)4桁
                                   ):String;
var
  w_ans:string;
begin
  try
    w_ans := '';

    w_ans := func_Get_WinMaster(arg_GroupNo,g_ON_CALL_SEC,g_ON_CALL_CHG_KEY + arg_StartTime,g_GET_DATA);

    if w_ans = '' then w_ans := Copy(func_Time6To8(arg_StartTime + '00'), 1, 5);
    
    Result := w_ans;
  except
    raise;
  end;
end;

//●初期化処理
initialization
begin
  DM_DbAcc:= nil;
end;

//●終了化処理
finalization
begin
end;

end.
