unit pdct_com;
{
■機能説明 （使用予定：あり）
 EXEプロジェクトに固有の共通ルーチン
● DB汎用ツール
汎用－DB_ACCに移管予定－－－－－－－－－－－－－－－－－－－－－－－－－－－－
//●☆使用可☆ 機能（例外無）：DateのBetween句を作成
function func_DateBetween(
       arg_FName:string;   //項目名
       arg_Date1:TDate;    //初め
       arg_Date2:TDate     //終り
       ):string;

//●☆使用可☆機能（例外有）：ListViewの内容をCSVファイル保存
procedure proc_ListViewToFile(
       arg_FName:string;      //保存ファイル名
       arg_ListView:TListView //対象
       );

//●☆使用可☆機能（例外有）：StringGridの内容をCSVファイル保存
procedure proc_StringGridToFile(
       arg_FName:string;          //保存ファイル名
       arg_StringGrid:TStringGrid //対象
       );
//●☆使用可☆機能（例外有）：StringGridの内容をCSVファイル保存
//                            非表示カラムは保存しない
procedure proc_StringGridToFile2(
       arg_FName:string;          //保存ファイル名
       arg_StringGrid:TStringGrid //対象
       );
● lowレベル関数
//●☆使用可☆機能（例外有）：SQLの結果のレコード数を返す
function func_SqlCount(
       arg_DB:TDatabase;          //接続されたDB
       arg_Sql:Tstrings):Integer; //有効なSQL
//●☆使用可☆機能（例外有）：SQLの実行結果を返す 成功：True 失敗：false
function func_SqlExec(
       arg_DB:TDatabase;          //接続されたDB
       arg_Sql:Tstrings):boolean; //有効なSQL

特殊－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
//●☆使用可☆機能（例外無）：ｺｰﾄﾞを名前に変換登録 手技区分
function func_PIND_Change_SYUGI(
       arg_Code:string    //ｺｰﾄﾞ
       ):string;          //名称
//●☆使用可☆機能（例外無）：ｺｰﾄﾞを名前に変換登録 造影剤区分
function func_PIND_Change_ZOUEI(
       arg_Code:string    //ｺｰﾄﾞ
       ):string;          //名称
//●☆使用可☆機能（例外無）：ｺｰﾄﾞを名前に変換登録 撮影進捗  SATUEI
function func_PIND_Change_SATUEI(
       arg_Code:string    //ｺｰﾄﾞ
       ):string;          //名称
//●☆使用可☆機能（例外無）：ｺｰﾄﾞを名前に変換登録 時間外区分
function func_PIND_Change_JIKAN(
       arg_Code:string    //ｺｰﾄﾞ
       ):string;          //名称
//●☆使用可☆機能（例外無）：ｺｰﾄﾞを名前に変換登録 RI実施フラグ
function func_PIND_Change_RI(
       arg_Code:string    //ｺｰﾄﾞ
       ):string;          //名称
//●☆使用可☆機能（例外無）：ｺｰﾄﾞを名前に変換登録 所見依頼フラグ
function func_PIND_Change_SYOKEN(
       arg_Code:string    //ｺｰﾄﾞ
       ):string;          //名称
//●☆使用可☆機能（例外無）：ｺｰﾄﾞを名前に変換登録 検査進捗  KENSIN
function func_PIND_Change_KENSIN(
       arg_Code:string    //ｺｰﾄﾞ
       ):string;          //名称
//●☆使用可☆機能（例外無）：ｺｰﾄﾞを名前に変換登録システム区分
function func_PIND_Change_SYSK(
       arg_Code:string    //ｺｰﾄﾞ
       ):string;          //名称
//●☆使用可☆機能（例外無）：ｺｰﾄﾞを名前に変換 性
function func_PIND_Change_Sex(
       arg_Code:string    //ｺｰﾄﾞ
       ):string;          //名称
//●☆使用可☆機能（例外無）：ｺｰﾄﾞを名前に変換 入外区分
function func_PIND_Change_Nyugai(
       arg_Code:string    //ｺｰﾄﾞ
       ):string;          //名称

● KANRIテーブルの状態制御 関数 群 ---------------------------------------------
管理テーブルの制御ではトランザクションを使うため
呼び出すときはトランザクションを閉じておく必要が有ります
//●★使用可★機能（例外有）：KANRIテーブルの更新権利取得
function func_GetWKAnri(
       arg_DB:TDatabase;         //接続されたDB（必須）
       arg_TanName:string;       //PC名称       （必須）
       arg_ProgId:string;        //プログラムID （必須）
       arg_RisId:string          //RIS識別ID    （必須）
       ):boolean;                //結果True：権利取得成功 False：権利取得失敗
 上記のパラメタで更新権利を取得する
 arg_KanjaId arg_OrderId arg_KensaDate で更新のものが他になければ取得成功する
 それ以外は取得失敗する。

//●★使用可★機能（例外有）：KANRIテーブルの参照権利取得
function func_GetRKAnri(
       arg_DB:TDatabase;         //接続されたDB （必須）
       arg_TanName:string;       //PC名称       （必須）
       arg_ProgId:string;        //プログラムID （必須）
       arg_RisId:string          //RIS識別ID    （必須）
       ):boolean;                //結果True：権利取得成功 False：権利取得失敗
 上記のパラメタで参照権利を取得する
 現状はDBｴﾗｰ等がなければ常に取得成功する。

//●★使用可★機能（例外有）：KANRIテーブルの権利返還
function func_ReleasKAnri(
       arg_DB:TDatabase;         //接続されたDB （必須）
       arg_TanName:string;       //PC名称       （必須）
       arg_ProgId:string;        //プログラムID （必須）
       arg_RisId:string;         //RIS識別ID    （必須）
       arg_SyoriMode:string      //返還権利種 G_KANRI_TBL_RMODE 参照権利 （必須）
                                 //           G_KANRI_TBL_WMODE 更新権利

       ):boolean;                //結果True：成功 False：失敗
 上記のパラメタで取得に成功した権利を、必要なくなったら必ず変換する。

//●★使用可★機能（例外有）：KANRIテーブルの権利全削除
function func_DelKAnri(
       arg_DB:TDatabase;         //接続されたDB （必須）
       arg_TanName:string       //PC名称        （必須）
       ):boolean;                //結果True成功 False失敗
指定arg_TanNameの全権利を一括削除する。通常はMainプログラムの最初に呼び出す。

//●★使用可★機能（例外無）：CardReader状態チェック関数（ＤＢ設定）
function proc_ChkCardPort : Boolean;
//●★使用可★機能（例外無）：CardReader状態チェック関数（通信ポート設定）
function proc_ChkCardPort_Com : integer;
//2002.11.21
//●★使用可★機能（例外有）：KANRIテーブルの更新権利取得
function func_GetWKAnriUketuke(
       arg_DB:TDatabase;         //接続されたDB（必須）
       arg_TanName:string;       //PC名称       （必須）
       arg_ProgId:string;        //プログラムID （必須）
       arg_RisId:string          //RIS識別ID    （必須）
       ):boolean;                //結果True：権利取得成功 False：権利取得失敗
 上記のパラメタで更新権利を取得する
 arg_KanjaId arg_OrderId arg_KensaDate で更新のものが他になければ取得成功する
 それ以外は取得失敗する。


//－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
//使用不可－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
//－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
//●★使用不可★機能（例外有）：NameMSの特定区分をコンボに設定（コンボクリアする）
procedure proc_NameMSToComb(
   arg_Qry:TQuery;
   arg_KBN:string;
   arg_Comb: TComboBox
   );

//●★使用不可★機能（例外有）：NameMSの特定区分をコンボに設定（コンボクリアしない）
procedure proc_NameMSToComb1(
   arg_Qry:TQuery;
   arg_KBN:string;
   arg_Comb: TComboBox
   );

● ユーザの登録確認
//●★使用不可★機能（例外有）：USERMSのUser_nameを確認
function func_ChkUserName(
       arg_DB:TDatabase;         //接続されたDB
       arg_UserName:string       //ユーザ名
       ):boolean;
//●★使用不可★機能（例外有）：USERMSのUser_nameとPASSWORDを確認
function func_ChkUserPass(
       arg_DB:TDatabase;
       arg_UserName:string;
       arg_Password:string
       ):boolean;
//●★使用不可★機能（例外有）：USERMSのUser_nameとclassを確認
function func_ChkUserClass(
       arg_DB:TDatabase;         //接続されたDB
       arg_UserName:string;      //ユーザ名
       arg_Class:string          //クラス
       ):boolean;
//●★使用可★機能（例外無）：ワークリスト予約テーブル用キー項目編集
function func_WorklistInfo_Key_Make(
         //IN
         arg_KanjaID: string;
         arg_OrderNO: string;
         //OUT
         var arg_Rcv_ACCESSION_NUMBER: string;
         var arg_Rcv_PATIENT_ID: string
        ): Boolean;
ワークリスト予約テーブルのキー項目を編集する。
//●★使用可★機能（例外無）：ワークリスト予約テーブル用全項目編集
function func_WorklistInfo_Make(
         //IN
         arg_Query: TQuery;
         arg_Group_No: string;
         arg_SysDate: string;
         arg_SysTime: string;
         arg_KanjaID: string;
         arg_OrderNO: string;
         arg_SimeiKana: string;
         arg_SimeiKanji: string;
         arg_Sex: string;
         arg_BirthDay: string;
         arg_Start_Date: string;
         arg_Start_Time: string;
         arg_Irai_Doctor_Name: string;
         arg_Irai_Section_Name: string;
         arg_Irai_Section_Kana: string;
         arg_KensaKikiName: string;
         arg_Modality_Type: string;
         arg_KensaComment1: string;
         arg_SUID: string;
         //OUT
         var arg_Rcv_SCH_STATION_AE_TITLE: string;
         var arg_Rcv_SCH_PROC_STEP_LOCATION: string;
         var arg_Rcv_SCH_PROC_STEP_START_DATE: string;
         var arg_Rcv_SCH_PROC_STEP_START_TIME: string;
         var arg_Rcv_SCH_PERF_PHYSICIANS_NAME_ROMA: string;
         var arg_Rcv_SCH_PERF_PHYSICIANS_NAME_KANJI: string;
         var arg_Rcv_SCH_PERF_PHYSICIANS_NAME_KANA: string;
         var arg_Rcv_SCH_PROC_STEP_DESCRIPTION: string;
         var arg_Rcv_SCH_PROC_STEP_ID: string;
         var arg_Rcv_COMMENTS_ON_THE_SCH_PROC_STEP: string;
         var arg_Rcv_MODALITY: string;
         var arg_Rcv_REQ_PROC_ID: string;
         var arg_Rcv_STUDY_INSTANCE_UID: string;
         var arg_Rcv_REQ_PROC_DESCRIPTION: string;
         var arg_Rcv_REQUESTING_PHYSICIAN: string;
         var arg_Rcv_REQUESTING_SERVICE: string;
         var arg_Rcv_ACCESSION_NUMBER: string;
         var arg_Rcv_INSTITUTION: string;
         var arg_Rcv_INSTITUTION_ADDRESS: string;
         var arg_Rcv_PATIENT_NAME_ROMA: string;
         var arg_Rcv_PATIENT_NAME_KANJI: string;
         var arg_Rcv_PATIENT_NAME_KANA: string;
         var arg_Rcv_PATIENT_ID: string;
         var arg_Rcv_PATIENT_BIRTH_DATE: string;
         var arg_Rcv_PATIENT_SEX: string;
         var arg_Rcv_PATIENT_WEIGHT: string
        ): Boolean;
ワークリスト予約テーブルの全項目を編集する。
//●★使用可★機能（例外無）：カタカナ→ローマ字変換
function func_Kana_To_Roma(
         arg_Kana: string
         ): string;

番号管理テーブルより指定区分の現在番号を取得し、
＋１した値を返す。また、その結果を現在番号に書き込む。
＋１した結果、指定区分の最大値を超える場合でも値を返すので
呼出側でチェックします。
例外は戻り値に０がセットされている場合です。
【引数説明】
  arg_Database:TQuery; － 書き込み用データベース(必須)
  arg_Query:TQuery;    － 読み込む用クエリー(必須)
  arg_Kubun:string;    － 指定区分(必須)
  arg_Date:string      － 処理日付(日付管理を行う区分のみ指定)－yyyy/mm/dd
//●★使用可★機能（例外有）：現在番号+1取得
function func_Get_NumberControl(
         arg_Database:TDatabase;
         arg_Query:TQuery;
         arg_Kubun:string;
         arg_Date:string
         ):integer;
番号管理テーブルの指定区分の現在番号を更新する。
上記で使用する関数
【引数説明】
  arg_Database:TQuery; － 書き込み用データベース(必須)
  arg_Query:TQuery;    － 読み込む用クエリー(必須)
  arg_Mode:integer;    － １：新規、２：修正
  arg_Kubun:string;    － 指定区分(必須)
  arg_UpdateDate:string－ 処理日付－yyyy/mm/dd
  arg_Now_NO:integer   － 更新の現在番号(必須)
//●★使用可★機能（例外有）：現在番号更新
function func_NumberControl_Update(
         arg_Database:TDatabase;
         arg_Query:TQuery;
         arg_Mode:integer;
         arg_Kubun:string;
         arg_UpdateDate:string;
         arg_Now_NO:integer
         ):Boolean;
//●★使用可★機能（例外無）：全文字列の全角チェック
func_ALL_ZENKAKU_CHECK(arg_text: string):Boolean;
//●★使用可★機能（例外無）：全文字列の半角チェック
func_ALL_HANKAKU_CHECK(arg_text: string):Boolean;
//2002.11.18
//●機能（例外無）：全文字列の半角チェック
func_ALL_HANKAKU_AISUU_CHECK(arg_text: string):Boolean;



■履歴
新規作成：2000.04.12：担当  iwai
修正    ：2000.05.11：担当  iwai
//●機能（例外有）：ListViewの内容をCSVファイル保存
procedure proc_ListViewToFile();
//●機能（例外有）：NameMSの特定区分をコンボに設定（コンボクリアする）
procedure proc_NameMSToComb();
//●機能（例外有）：NameMSの特定区分をコンボに設定（コンボクリアしない）
procedure proc_NameMSToComb1();
を追加
修正    ：2000.11.30：担当  iwai
コード変換処理を追加
func_PIND_Change_Nyugai
func_PIND_Change_Sex
func_PIND_Change_SYSK
func_PIND_Change_KENSIN
func_PIND_Change_SYOKEN
func_PIND_Change_RI
func_PIND_Change_JIKAN
func_PIND_Change_SATUEI
func_PIND_Change_ZOUEI
func_PIND_Change_SYUGI

修正    ：2000.12.04：担当  iwai
帳票番号の定義を追加

修正    ：2000.12.19：担当  iwai
カードリーダのチェック関数を追加

修正    ：2000.12.22：担当  増田
GPCST_NAME_JIKAN_2 = '休日',GPCST_NAME_JIKAN_3 = '当直'
                           ↓
GPCST_NAME_JIKAN_2 = '当直',GPCST_NAME_JIKAN_3 = '休日'
に修正

修正    ：2001.01.11：担当  iwai
管理テーブル制御ルーチンを修正反映
使い方は変更なし
KANRIテーブルの更新権利取得 function func_GetWKAnri
KANRIテーブルの参照権利取得 function func_GetRKAnri
KANRIテーブルの権利返還 function func_ReleasKAnri
KANRIテーブルの権利全削除 function func_DelKAnri

修正    ：2001.01.18：担当  杉山
ワークリスト予約テーブル用キー項目編集 func_WorklistInfo_Key_Make
修正    ：2001.01.18：担当  杉山
ワークリスト予約テーブル用全項目編集 func_WorklistInfo_Make
修正    ：2001.01.18：担当  杉山
カタカナ→ローマ字変換 func_Kana_To_Roma
修正    ：2001.03.15：増田
依頼区分の追加
追加    ：2001.08.31：杉山
現在番号+1取得の追加
現在番号更新の追加
追加    ：2001.09.01：増田
大学統計写真分類の追加
大学統計透視分類の追加
手技区分の追加
追加    ：2001.09.03：増田
造影剤区分の追加
追加    ：2001.09.04：増田
左右名称の初期値追加
追加　　：2001.09.04：小林
職員区分の追加
追加    ：2001.09.05：増田
検査種別の追加
プリセットID番号取得用区分の追加
追加    ：2001.09.06：増田
職種区分を山形用から広島用に変更
追加    ：2001.09.07：増田
func_PIND_Change_KAIKEIを追加
性別を山形用から広島用に変更
入外区分を追加
追加    ：2001.09.10：増田
病棟連絡TEL,帰宅指示を追加
func_PIND_Change_KITAKU,func_PIND_Change_TELを追加
追加    ：2001.09.11：増田
所見要否の追加
func_PIND_Change_SYOKEN_YOUHIの追加
修正    ：2001.09.13：増田
func_PIND_Change_KENSINを広島用に変更
撮影進捗を追加
func_PIND_Change_SATUEISTATUSを追加
追加    ：2001.09.13：杉山
画像確認の追加
func_PIND_Change_GAZOU_KAKUNINの追加
追加    ：2001.09.17：山中
//プリンタタイプ取得の追加
func_Get_PrintType
追加    ：2001.09.20：杉山
病棟連絡TEL,帰宅指示,画像確認の画面用を追加
func_PIND_Change_KITAKU_G,func_PIND_Change_TEL_G,func_PIND_Change_GAZOU_KAKUNIN_Gを追加
追加    ：2001.09.21：小林
プリントタイプの番号取得の追加
追加    ：2001.09.25：小林
//全文字列の全角、半角チェックの追加
func_ALL_ZENKAKU_CHECK,func_ALL_HANKAKU_CHECK
修正    ：2001.10.01：増田
func_PIND_Change_SATUEISTATUSの修正
色替要否の追加
func_PIND_Change_COLOR_YOUHIの追加
追加    ：2002.09.20：高山
左右使用の追加
func_PIND_Change_SAYUUの追加
追加    ：2002.09.24：高山
読影要否の追加
func_PIND_Change_DOKUEIの追加
追加    ：2002.09.24：高山
処置室使用の追加
func_PIND_Change_SHOTIの追加
追加    ：2002.09.24：高山
要造影の追加
func_PIND_Change_YZOUEIの追加
追加    ：2002.09.24：高山
要造影の追加
グリッドカラム幅を書き込み追加
func_Grid_ColumnSize_Writeの追加
追加    ：2002.10.02：高山
グリッドカラム幅を読み込む追加
proc_Grid_ColumnSize_Readの追加
追加    ：2002.10.02：高山
医師立会区分の追加
func_PIND_Change_ISITATIAIの追加
追加    ：2002.10.03：高山
FCR連携の追加
func_PIND_Change_FCRの追加
追加    ：2002.10.05：高山
MPPS対応の追加
func_PIND_Change_MPPSの追加
追加    ：2002.10.05：高山
手技区分名称対応の追加
追加    ：2002.10.08：高山
検査種別を聖路加用に変更
変更　　：2002.10.09：高山
読影要否の追加に項目追加
修正　　：2002.10.15：高山
追加    ：2002.10.21：水野
　検査種別毎のフィルタフラグ項目名の格納タイプ宣言
　検査種別毎のフィルタフラグ項目名の格納変数宣言
患者マスタ項目取得項目追加(患者ID参照)
追加    ：2002.10.22：高山
患者マスタ項目取得項目追加(RIS識別ID参照)
追加    ：2002.10.22：高山
修正    ：2002.10.23：水野
　検査種別毎の患者マスタの検査コメント項目名を格納タイプに追加
追加　　：2002.10.30：谷川
会計送信種別の追加
func_PIND_Change_KAIKEIの追加
追加　　：2002.11.07：増田 貴
画面ID項目追加の
//2002.11.21
追加　　：2002.11.29：谷川
情報項目別マスタ区分の５～１４を追加

KANRIテーブルの更新権利取得 function func_GetWKAnriUketuke
//●機能（例外無）：シェーマ格納ファイル名作成
function func_Make_ShemaName(arg_OrderNO,               //オーダNO
                             arg_MotoFileName: string;  //HISｼｪｰﾏ名
                             arg_Index: integer         //部位NO
                             ):string;                  //格納ﾌｧｲﾙ名


//●★使用可★機能（例外無）：文字変換
func_Moji_Henkan(arg_Moji: string;
                 arg_Flg: Integer  //1:全角→半角、2:半角→全角、3:全角ひらがな→半角カタカナ
                 ): string;
修正　　：2003.02.17：増田
　　　　　　　　　　　ファイル拡張子の切り出しを修正
修正    ：2003.12.06：谷川
　　　　　　　　　　　検査種別を聖マリアンナ用に変更。
修正    ：2003.12.11：谷川
　　　　　　　　　　　伝票印刷フラグの更新処理を追加。
修正    ：2003.12.25：増田
　　　　　　　　　　　RIオーダ番号変換番号（注射・検査）を追加。
修正　　：2004.01.04：谷川
　　　　　　　　　　　Initial設定用関数にE1（プレチェック）画面用を追加。
追加    ：2004.01.13：小泉
                      関数追加（func_GyoumuKbn_Check）。
追加    ：2004.01.22：小泉
                      ReportRisTable設定フラグ(WinMaster用)追加
追加    ：2004.03.25：小泉
                      TensouOrderTable用状態フラグ追加
追加    ：2004.03.31：増田
                      電文NG種類追加
追加    ：2004.04.09：小泉
                      受付時用RISオーダ送信キューフラグ&ダミーID判定関数追加
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
  Registry,
  ExtCtrls,
  ComCtrls,
  StdCtrls,
  Grids,
//プロダクト開発共通－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
  Gval,
  myInitInf,
  pdct_ini,
  ErrorMsg,
  DB_ACC,
  Trace,
  com00, ComSb01,
  OraDate2,
  OraNumber,
  OraStringGrid,
  jis2sjis,
  //2003.10.06 Start************************************************************
  GKitSpreadControl;
  //2003.10.06 end**************************************************************

////型クラス宣言-------------------------------------------------------------
//type
//2002.10.21 検査種別毎のフィルタフラグ項目名の格納タイプ宣言
type TKensaType_Field = record
  Kensa_ID: String;
  FilterName: String;
  KensaCommentName: String;
  end;

//定数宣言-------------------------------------------------------------------

{$INCLUDE'INC_Ris_Card.inc'}

const
//プロダクト固有情報↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
G_HELPFILENAME= 'ris_ych.hlp';      //ヘルプファイル名
//ﾌﾟﾚﾌｨｯｸｽ：GPCST
//■コード及び名称定義
//2001.09.07
// 性別
GPCST_SEX_1='1';
GPCST_SEX_2='2';
GPCST_SEX_3='3';
GPCST_SEX_1_NAME='M';
GPCST_SEX_2_NAME='F';
GPCST_SEX_3_NAME='不明';
GPCST_SEX_3P_NAME='O';
// 入外区分
{2004.01.08
GPCST_NYUGAIKBN_1='1';
GPCST_NYUGAIKBN_2='2';
2004.01.08}
GPCST_NYUGAIKBN_1='2';
GPCST_NYUGAIKBN_2='1';
{2002.10.30
GPCST_NYUGAIKBN_1_NAME='入院';
GPCST_NYUGAIKBN_2_NAME='外来';
2002.10.30}
GPCST_NYUGAIKBN_1_NAME='外来';
GPCST_NYUGAIKBN_2_NAME='入院';
// 会計種別
GPCST_KAIKEITYPE_0='0';
GPCST_KAIKEITYPE_1='1';
GPCST_KAIKEITYPE_2='2';
GPCST_KAIKEITYPE_3='3';
GPCST_KAIKEITYPE_0_NAME='医事';
GPCST_KAIKEITYPE_1_NAME='自費';
GPCST_KAIKEITYPE_2_NAME='校費';
GPCST_KAIKEITYPE_3_NAME='治験';
// 登録システム区分  _SYSK
GPCST_CODE_SYSK_RIS = 'R';
GPCST_CODE_SYSK_HIS = 'H';
GPCST_NAME_SYSK_RIS = 'RIS';
GPCST_NAME_SYSK_HIS = 'HIS';
// 検査進捗 _KENSIN
GPCST_CODE_KENSIN_0 = '0';
GPCST_CODE_KENSIN_1 = '1';
GPCST_CODE_KENSIN_2 = '2';
GPCST_CODE_KENSIN_3 = '3';
GPCST_CODE_KENSIN_4 = '4';
GPCST_NAME_KENSIN_0 = '未受';
GPCST_NAME_KENSIN_1 = '受済';
GPCST_NAME_KENSIN_2 = '検中';
GPCST_NAME_KENSIN_3 = '検済';
GPCST_NAME_KENSIN_4 = '中止';
GPCST_RYAKU_NAME_KENSIN_0 = '未';
GPCST_RYAKU_NAME_KENSIN_1 = '受';
GPCST_RYAKU_NAME_KENSIN_2 = '中';
GPCST_RYAKU_NAME_KENSIN_3 = '済';
GPCST_RYAKU_NAME_KENSIN_4 = '止';
// 検査進捗 _KENSIN_SUB
GPCST_CODE_KENSIN_SUB_5 = '5';
GPCST_CODE_KENSIN_SUB_6 = '6';
GPCST_CODE_KENSIN_SUB_7 = '7';
GPCST_CODE_KENSIN_SUB_8 = '8';
GPCST_CODE_KENSIN_SUB_9 = '9';
GPCST_CODE_KENSIN_SUB_10= '10';
GPCST_NAME_KENSIN_SUB_5 = '呼出';
GPCST_NAME_KENSIN_SUB_6 = '遅刻';
GPCST_NAME_KENSIN_SUB_7 = '確保';
GPCST_NAME_KENSIN_SUB_8 = '保留';
GPCST_NAME_KENSIN_SUB_9 = '再呼';
GPCST_NAME_KENSIN_SUB_10= '再受';
GPCST_RYAKU_NAME_KENSIN_SUB_5 = '呼';
GPCST_RYAKU_NAME_KENSIN_SUB_6 = '遅';
GPCST_RYAKU_NAME_KENSIN_SUB_7 = '確';
GPCST_RYAKU_NAME_KENSIN_SUB_8 = '留';
GPCST_RYAKU_NAME_KENSIN_SUB_9 = '呼';
GPCST_RYAKU_NAME_KENSIN_SUB_10= '受';

// 所見依頼フラグ _SYOKEN
GPCST_CODE_SYOKEN_0 = '0';
GPCST_CODE_SYOKEN_1 = '1';
GPCST_NAME_SYOKEN_0 = '不要';
GPCST_NAME_SYOKEN_1 = '要';
// RI実施フラグ _RI
GPCST_CODE_RI_0 = '0';
GPCST_CODE_RI_1 = '1';
GPCST_NAME_RI_0 = '負荷なし';
GPCST_NAME_RI_1 = '負荷あり';
// 時間外区分  _JIKAN
GPCST_CODE_JIKAN_0 = '0';
GPCST_CODE_JIKAN_1 = '1';
GPCST_CODE_JIKAN_2 = '2';
GPCST_CODE_JIKAN_3 = '3';
GPCST_NAME_JIKAN_0 = '定時';
GPCST_NAME_JIKAN_1 = '予約外';
GPCST_NAME_JIKAN_2 = '休日';
GPCST_NAME_JIKAN_3 = '当直';
// 撮影進捗 _SATUEI
GPCST_CODE_SATUEI_0 = '0';
GPCST_CODE_SATUEI_1 = '1';
GPCST_CODE_SATUEI_2 = '2';
GPCST_NAME_SATUEI_0 = '未撮影';
GPCST_NAME_SATUEI_1 = '撮影済';
GPCST_NAME_SATUEI_2 = '撮影キャンセル';
// 造影剤区分 _ZOUEI
GPCST_CODE_ZOUEI_0 = '0';
GPCST_CODE_ZOUEI_1 = '1';
GPCST_CODE_ZOUEI_2 = '2';
GPCST_CODE_ZOUEI_3 = '3';
GPCST_CODE_ZOUEI_4 = '4';
GPCST_NAME_ZOUEI_0 = '';
GPCST_NAME_ZOUEI_1 = '造影剤';
GPCST_NAME_ZOUEI_2 = '薬剤';
GPCST_NAME_ZOUEI_3 = 'カテ';
GPCST_NAME_ZOUEI_4 = '特材';
// 手技区分 SYUGI
GPCST_CODE_SYUGI_0 = '0';
GPCST_CODE_SYUGI_1 = '1';
GPCST_CODE_SYUGI_2 = '2';
//GPCST_CODE_SYUGI_3 = '3';
GPCST_NAME_SYUGI_0 = '';
GPCST_NAME_SYUGI_1 = '基本';
GPCST_NAME_SYUGI_2 = '処置';
//GPCST_NAME_SYUGI_3 = '以外は手技';
// 職種区分
{GPCST_SYOKUSHU_1='1';
GPCST_SYOKUSHU_2='2';
GPCST_SYOKUSHU_3='3';
GPCST_SYOKUSHU_4='4';
GPCST_SYOKUSHU_1_NAME='医師';
GPCST_SYOKUSHU_2_NAME='技師';
GPCST_SYOKUSHU_3_NAME='看護婦';
GPCST_SYOKUSHU_4_NAME='職員';}
//2001.09.06
GPCST_SYOKUSHU_1='1';
GPCST_SYOKUSHU_2='2';
GPCST_SYOKUSHU_3='3';
GPCST_SYOKUSHU_4='4';
GPCST_SYOKUSHU_1_NAME='医師';
GPCST_SYOKUSHU_2_NAME='事務等';
GPCST_SYOKUSHU_3_NAME='技師';
GPCST_SYOKUSHU_4_NAME='看護師';
//■帳票番号
GPCST_CHUHYO_BASE  = '00';
GPCST_CHUHYO_CH010 = '01';
GPCST_CHUHYO_CH020 = '02';
GPCST_CHUHYO_CH030 = '03';
GPCST_CHUHYO_CH040 = '04';
GPCST_CHUHYO_CH050 = '05';
GPCST_CHUHYO_CH060 = '06';
GPCST_CHUHYO_CH070 = '04';
//■自動再表示タイトル
GPCST_AUTO_DISP_TITLE  = '自動再表示中－';
//2001.09.10
//■帰宅指示
GPCST_KITAKU_0 = '0';
GPCST_KITAKU_1 = '1';
GPCST_KITAKU_0_NAME = '未帰宅';
GPCST_KITAKU_1_NAME = '帰宅済';
//2001.09.10
//■病棟連絡TEL
GPCST_TEL_0 = '0';
GPCST_TEL_1 = '1';
GPCST_TEL_0_NAME = '否';
GPCST_TEL_1_NAME = '要';
//2001.09.11
//■所見要否
GPCST_SYOKEN_YOUHI_0 = '0';
GPCST_SYOKEN_YOUHI_1 = '1';
GPCST_SYOKEN_YOUHI_0_NAME = '不要';
GPCST_SYOKEN_YOUHI_1_NAME = '必要';
// 撮影進捗
GPCST_CODE_SATUEIS_0 = '0';
GPCST_CODE_SATUEIS_1 = '1';
GPCST_CODE_SATUEIS_2 = '2';
GPCST_NAME_SATUEIS_0 = '未';
GPCST_NAME_SATUEIS_1 = '済';
GPCST_NAME_SATUEIS_2 = '中止';
GPCST_NAME_SATUEIS2_0 = '未入力';
GPCST_NAME_SATUEIS2_1 = '入力済';
GPCST_NAME_SATUEIS2_2 = '中止';
//■画像確認
GPCST_GAZOU_KAKUNIN_0 = '0';
GPCST_GAZOU_KAKUNIN_1 = '1';
GPCST_GAZOU_KAKUNIN_0_NAME = '未';
GPCST_GAZOU_KAKUNIN_1_NAME = '済';
//2001.09.20
//■帰宅指示
GPCST_KITAKU_0_G = '0';
GPCST_KITAKU_1_G = '1';
GPCST_KITAKU_0_NAME_G = '未';
GPCST_KITAKU_1_NAME_G = '帰';
//■病棟連絡TEL
GPCST_TEL_0_G = '0';
GPCST_TEL_1_G = '1';
GPCST_TEL_0_NAME_G = '';
GPCST_TEL_1_NAME_G = 'TEL';
//■画像確認
GPCST_GAZOU_KAKUNIN_0_G = '0';
GPCST_GAZOU_KAKUNIN_1_G = '1';
GPCST_GAZOU_KAKUNIN_0_NAME_G = '未';
GPCST_GAZOU_KAKUNIN_1_NAME_G = '済';
//↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
//関数引数の定数//
//管理テーブル
G_KANRI_TBL_RMODE = '0';//参照モード
G_KANRI_TBL_WMODE = '1';//更新モード

//■依頼区分 2001.03.15
GPCST_KBN_10 = '10'; //単純撮影
GPCST_KBN_15 = '15'; //ﾎﾟｰﾀﾌﾞﾙ撮影
GPCST_KBN_20 = '20'; //断層撮影
GPCST_KBN_30 = '30'; //X線造影
GPCST_KBN_50 = '50'; //CT
GPCST_KBN_60 = '60'; //MR
GPCST_KBN_70 = '70'; //RI
GPCST_KBN_80 = '80'; //血管造影
GPCST_KBN_90 = '90'; //骨塩定量
{2001.09.01 Start}
//■大学統計写真分類
CST_DSB = 'DSB';
//■大学統計透視分類
CST_DTB = 'DTB';
//■手技区分
CST_SYUGI = 'SHG';
{2001.09.01 End}
//2001.09.03
//■造影剤区分
CST_ZOUEI = 'ZOE';
//2001.09.04
CST_SAYUU_DEF = 'なし';
//2001.09.03
//■職員区分
CST_SYOKUIN = 'SHK';
{2001.09.05 Start}
//■検査種別
{2003.11.26 変更
GPCST_SYUBETU_01 = '01'; //一般撮影
GPCST_SYUBETU_02 = '02'; //DIP･DIC
GPCST_SYUBETU_03 = '03'; //Portable
GPCST_SYUBETU_04 = '04'; //MMG
GPCST_SYUBETU_05 = '05'; //乳房特殊
GPCST_SYUBETU_06 = '06'; //乳房生検
GPCST_SYUBETU_07 = '07'; //CT
GPCST_SYUBETU_08 = '08'; //MRI
GPCST_SYUBETU_09 = '09'; //XTV
GPCST_SYUBETU_10 = '10'; //血管造影
GPCST_SYUBETU_11 = '11'; //心カテ
GPCST_SYUBETU_12 = '12'; //Echo
GPCST_SYUBETU_13 = '13'; //RI
GPCST_SYUBETU_14 = '14'; //参照画像取込
GPCST_SYUBETU_15 = '15'; //フィルム出力
GPCST_SYUBETU_20 = '20'; //治療計画CT
GPCST_SYUBETU_21 = '21'; //治療位置決め
}

{2003.12.06 変更
GPCST_SYUBETU_01 = '01'; //一般     <撮影系>
GPCST_SYUBETU_02 = '02'; //透視     <検査系>
GPCST_SYUBETU_03 = '03'; //血管     <検査系>
GPCST_SYUBETU_04 = '04'; //CT       <検査系>
GPCST_SYUBETU_05 = '05'; //MRI      <検査系>
GPCST_SYUBETU_06 = '06'; //核医学   <検査系>
GPCST_SYUBETU_07 = '07'; //治療     <検査系>
GPCST_SYUBETU_08 = '08'; //救命一般 <撮影系>
GPCST_SYUBETU_09 = '09'; //救命血管 <検査系>
GPCST_SYUBETU_10 = '10'; //救命CT   <検査系>
GPCST_SYUBETU_11 = '11'; //特殊     <撮影系>
GPCST_SYUBETU_12 = '12'; //骨塩     <検査系>
GPCST_SYUBETU_13 = '';   //未使用
GPCST_SYUBETU_14 = '';   //未使用
GPCST_SYUBETU_15 = '';   //未使用
GPCST_SYUBETU_20 = '';   //未使用
GPCST_SYUBETU_21 = '';   //未使用}

{2003.12.19 変更
GPCST_SYUBETU_11 = '11'; //一般     　　　<撮影系>
GPCST_SYUBETU_12 = '12'; //特殊検査     　<撮影系>
GPCST_SYUBETU_13 = '13'; //透視     　　　<検査系>
GPCST_SYUBETU_14 = '14'; //骨塩       　　<検査系>
GPCST_SYUBETU_15 = '15'; //血管      　　 <検査系>
GPCST_SYUBETU_16 = '16'; //CT   　　　　　<検査系>
GPCST_SYUBETU_17 = '17'; //MR    　　　　 <検査系>
GPCST_SYUBETU_18 = '18'; //核医学　　　　 <検査系>
GPCST_SYUBETU_19 = '19'; //治療 　　　　　<検査系>
GPCST_SYUBETU_20 = '20'; //治療位置決め   <撮影系>
GPCST_SYUBETU_21 = '21'; //治療位置決めCT <検査系>
GPCST_SYUBETU_22 = '22'; //救命一般     　<撮影系>
GPCST_SYUBETU_23 = '23'; //救命血管       <検査系>
GPCST_SYUBETU_24 = '24'; //救命CT         <検査系>
GPCST_SYUBETU_25 = '25';   //未使用
GPCST_SYUBETU_26 = '26';   //未使用
GPCST_SYUBETU_27 = '27';   //未使用}

GPCST_SYUBETU_01 = '01'; //一般     　　　<撮影系>
GPCST_SYUBETU_12 = '12'; //特殊検査     　<撮影系>
GPCST_SYUBETU_03 = '03'; //透視     　　　<検査系>
GPCST_SYUBETU_10 = '10'; //骨塩       　　<検査系>
GPCST_SYUBETU_08 = '08'; //血管      　　 <検査系>
GPCST_SYUBETU_05 = '05'; //CT   　　　　　<検査系>
GPCST_SYUBETU_06 = '06'; //MR    　　　　 <検査系>
GPCST_SYUBETU_07 = '07'; //核医学　　　　 <検査系>
GPCST_SYUBETU_09 = '09'; //治療 　　　　　<検査系>
GPCST_SYUBETU_14 = '14'; //治療位置決め   <撮影系>
GPCST_SYUBETU_15 = '15'; //治療位置決めCT <検査系>
GPCST_SYUBETU_31 = '31'; //救命一般     　<撮影系>
GPCST_SYUBETU_38 = '38'; //別館血管       <検査系>
GPCST_SYUBETU_35 = '35'; //別館CT         <検査系>
GPCST_SYUBETU_13 = '13'; //ｵﾍﾟ室ﾎﾟｰﾀﾌﾞﾙ   <撮影系> 2003.12.19追加



//■プリセットID番号取得用
CST_PRESET = 'PRE';
{2001.09.05 End}
//2001.09.07
//■入外区分取得用
CST_NYUGAI = 'NYU';
//■プリンタタイプ
GPCST_PRI_TYPE_01 = 'レーザー';         //レーザー
GPCST_PRI_TYPE_02 = 'ラベル';           //ラベル
GPCST_PRI_TYPE_03 = 'ドットインパクト'; //ドットインパクト
//2001.09.21
//■プリンタタイプ
GPCST_PRI_TYPE_NO_01 = '1';     //レーザー
GPCST_PRI_TYPE_NO_02 = '2';     //レベル
GPCST_PRI_TYPE_NO_03 = '3';     //ドットインパクト
//2001.11.10
GPCST_SATUEISITU_KYUKYU = '救急'; //撮影室=救急
//2002.09.20
//■色替要否
GPCST_COLOR_YOUHI_0 = '0';
GPCST_COLOR_YOUHI_1 = '1';
GPCST_COLOR_YOUHI_0_NAME = '不要';
GPCST_COLOR_YOUHI_1_NAME = '必要';
//2002.09.24
//■左右使用
GPCST_SAYUU_0 = '0';
GPCST_SAYUU_1 = '1';
GPCST_SAYUU_0_NAME = 'しない';
GPCST_SAYUU_1_NAME = 'する';
//2002.09.24
//■読影要否
GPCST_DOKUEI_0 = '0';
GPCST_DOKUEI_1 = '1';
GPCST_DOKUEI_2 = '2';
GPCST_DOKUEI_0_NAME = '不要';
GPCST_DOKUEI_1_NAME = '必要';
GPCST_DOKUEI_2_NAME = '緊急';
//2002.09.24
//■処置室使用
GPCST_SHOTI_0 = '0';
GPCST_SHOTI_1 = '1';
GPCST_SHOTI_0_NAME = 'しない';
GPCST_SHOTI_1_NAME = 'する';
GPCST_SHOTI_0_RYAKU_NAME = '';
GPCST_SHOTI_1_RYAKU_NAME = '使';
//2002.09.24
//■要造影
GPCST_YZOUEI_0 = '0';
GPCST_YZOUEI_1 = '1';
GPCST_YZOUEI_0_NAME = '';
GPCST_YZOUEI_1_NAME = '○';
//2002.09.24
//■処理区分
GPCST_SYORI_1 = '01';
GPCST_SYORI_2 = '02';
GPCST_SYORI_3 = '03';
GPCST_SYORI_1_NAME = '新規';
GPCST_SYORI_2_NAME = '更新';
GPCST_SYORI_3_NAME = '削除';
//2002.10.03
//■放科医師立会区分
GPCST_ISITATIAI_0 = '0';
GPCST_ISITATIAI_1 = '1';
GPCST_ISITATIAI_0_NAME = '立会なし';
GPCST_ISITATIAI_1_NAME = '立会あり';
GPCST_ISITATIAI_0_RyakuNAME = 'しない';
GPCST_ISITATIAI_1_RyakuNAME = 'する';
GPCST_ISITATIAI_0_RYAKU = '';
GPCST_ISITATIAI_1_RYAKU = '有';
//2002.10.03
//■デジタイズ進捗
GPCST_DEJITAI_0 = '0';
GPCST_DEJITAI_1 = '1';
GPCST_DEJITAI_0_NAME = '未';
GPCST_DEJITAI_1_NAME = '済';
//■検像進捗
GPCST_KENZOU_0 = '0';
GPCST_KENZOU_1 = '1';
GPCST_KENZOU_2 = '2';
GPCST_KENZOU_0_NAME = '再';
GPCST_KENZOU_1_NAME = '未';
GPCST_KENZOU_2_NAME = '済';
//2002.10.05
//■FCR連携
GPCST_FCR_0 = '0';
GPCST_FCR_1 = '1';
GPCST_FCR_0_NAME = 'しない';
GPCST_FCR_1_NAME = 'する';
//2002.10.05
//■MPPS対応
GPCST_MPPS_0 = '0';
GPCST_MPPS_1 = '1';
GPCST_MPPS_0_NAME = 'しない';
GPCST_MPPS_1_NAME = 'する';

GPCST_ERR_0 = '0';
GPCST_ERR_1 = '1';
GPCST_ERR_0_NAME = 'しない';
GPCST_ERR_1_NAME = 'する';
//2002.10.05
//■手技区分名
//GPCST_SHG_1_NAME = '基本';
GPCST_SHG_1_NAME = '加算'; //2004.02.01 koba
GPCST_SHG_2_NAME = '処置';
//■会計送信種別
GPCST_KAIKEI_0 = '0';
GPCST_KAIKEI_1 = '1'  ;
GPCST_KAIKEI_0_NAME = 'しない';
GPCST_KAIKEI_1_NAME = 'する'  ;

//■区分ﾏｽﾀID
GPCST_KBN_ID_SHOKEN   = '3';
GPCST_KBN_ID_KENSAKBN = '4';
GPCST_KBN_ID_3D = '16';
GPCST_KBN_ID_Cancel = '15';

//■RIオーダ区分
GPCST_RI_ORDER_0 = '0';
GPCST_RI_ORDER_1 = '1'  ;
GPCST_RI_ORDER_2 = '2'  ;
GPCST_RI_ORDER_0_NAME = 'なし';
GPCST_RI_ORDER_1_NAME = '注射'  ;
GPCST_RI_ORDER_2_NAME = '検査'  ;
//■画面ID項目
GPCST_GAMEN_0 ='B1';   //受付準備一覧画面ID
GPCST_GAMEN_1 ='E1';   //放部Dr.指示画面ID
GPCST_GAMEN_2 ='D1';   //当日受付一覧画面ID
GPCST_GAMEN_3 ='G1';   //撮影業務画面ID
GPCST_GAMEN_4 ='H1';   //検査業務一覧画面ID
GPCST_GAMEN_5 ='J1';   //Portable業務画面ID
GPCST_GAMEN_6 ='K1';   //RI業務画面ID
CPCST_GAMEN_7 ='N1';   //フィルム業務画面ID
GPCST_GAMEN_8 ='F1';   //検像業務画面ID
GPCST_GAMEN_9 ='X3';   //検査台帳一覧画面ID
GPCST_GAMEN_10='P1';   //患者実績一覧画面
//■オーダ指示コメント
GPCST_ORDER_COMMENT_131 = '131';//検査後診察無し
GPCST_ORDER_COMMENT_132 = '132';//検査後診察有り
//■感染症
GPCST_MRSA_SECTION_KEY = 'NAMECARDPRINT';
GPCST_MRSA_CODE_KEY = 'MRSACODE';
GPCST_MRSA_NAME_KEY = 'MRSANAME';

CST_PATH_GRID_COLUMNS   : string = 'C:\ris\columns\';//ｸﾞﾘｯﾄﾞｶﾗﾑｻｲｽﾞ保存先
//■Web用 指定条件　
{2004.03.09
GPCST_WED_KANJAID = 'patientid';
GPCST_WED_KENSADAY = 'date';
GPCST_WED_ORDERNO = 'accession';
GPCST_WED_MODALITY = 'modality';
2004.03.09}
//2004.03.09
GPCST_WED_KANJAID = 'ID';
GPCST_WED_KENSADAY = 'DATE';
//2004.03.29 GPCST_WED_ORDERNO = 'ODERNO';
GPCST_WED_ORDERNO = 'ORDERNO';
GPCST_WED_MODALITY = 'MODALITY';
//■依頼医指示中止情報
GPCST_FUTUUDOKUEI_CODE         = '101'; //普通読影
GPCST_KINKYUUDOKUEI_CODE       = '102'; //緊急読影
GPCST_DOKUHOKA_CODE            = '111'; //独歩可
GPCST_KURUMAISU_CODE           = '112'; //車椅子
GPCST_SUTORECCHA_CODE          = '113'; //ストレッチャー
GPCST_BED_CODE                 = '114'; //ベッド
GPCST_NINSINNASI_CODE          = '121'; //妊娠なし
GPCST_NINSINARI_CODE           = '122'; //妊娠有り
GPCST_NINSINFUMEI_CODE         = '123'; //心身不明
GPCST_KESASAGOSINSATUNASI_CODE = '131'; //検査後診察なし
GPCST_KENSAGOSANSATUARI_CODE   = '132'; //検査後診察あり
GPCST_CALLFUYOU_CODE           = '141'; //Call不要
GPCST_DRCALL_CODE              = '142'; //撮影時担当医Call
GPCST_BYOUSITU_CODE            = '201'; //病室
GPCST_SHUJUTUSITU_CODE         = '202'; //手術室
GPCST_KAIFUKUSITU_CODE         = '203'; //回復室
GPCST_KINKYUDORAISITU_CODE     = '204'; //緊急ドライ室
GPCST_KINKYUWETOSITU_CODE      = '205'; //緊急ウェット室
GPCST_GAIRAI_CODE              = '206'; //外来
GPCST_JINKINOUSEIJOU_CODE      = '301'; //腎機能正常
GPCST_JINKINOUIJOU_CODE        = '302'; //腎機能異常
GPCST_JINKINOUFUMEI_CODE       = '303'; //腎機能不明
GPCST_ZENSOKUNASI_CODE         = '311'; //喘息なし
GPCST_ZENSOKUARI_CODE          = '312'; //喘息あり
//2003.05.30
GPCST_ZENSOKUFUMEI_CODE        = '313'; //喘息不明
//2003.05.30 end
GPCST_YODONASI_CODE            = '321'; //ヨードアレルギーなし
GPCST_YODOARI_CODE             = '322'; //ヨードアレルギーあり
GPCST_YODOFUMEI_CODE           = '323'; //ヨードアレルギー不明
GPCST_TAINAIKINZOKUNASI_CODE   = '341'; //体内金属なし確認済み
GPCST_TAINAIKINZOKUARI_CODE    = '342'; //体内金属あり
GPCST_PESUMEKAARI_CODE         = '343'; //ペースメーカーあり
GPCST_HEISHONASI_CODE          = '351'; //閉所恐怖症なし
GPCST_HEISHOARI_CODE           = '352'; //閉所恐怖症あり
GPCST_BUSUKOPANKA_CODE         = '361'; //ブスコパン可
GPCST_BUSUKOPANHI_CODE         = '362'; //ブスコパン否
GPCST_GURUKAGONKA_CODE         = '371'; //ブス禁ーグルカゴン可
GPCST_GURUKAGONKIN_CODE        = '372'; //ブス禁ーグルカゴン禁
GPCST_OMUTUNASI_CODE           = '381'; //おむつ等なし
GPCST_OMUTUARI_CODE            = '382'; //おむつ等あり
GPCST_JUNYUNASI_CODE           = '391'; //授乳なし
GPCST_JUNYUCHU_CODE            = '392'; //授乳中

//2002.11.18
//■情報項目別マスタ区分/ID
CST_KMS = 'KMS';
CST_KMS_ID_1 = '1';
CST_KMS_ID_2 = '2';
CST_KMS_ID_5 = '5';   //連絡メモ：患者状態  2002.11.29
CST_KMS_ID_6 = '6';   //連絡メモ：メッセージ
CST_KMS_ID_7 = '7';   //連絡メモ：技師業務
CST_KMS_ID_8 = '8';   //撮影実施：誰が
CST_KMS_ID_9 = '9';   //撮影実施：どうした
CST_KMS_ID_10 = '10'; //Dr指示：造影有無
CST_KMS_ID_11 = '11'; //Dr指示：タイミング
CST_KMS_ID_12 = '12'; //Dr指示：撮像範囲
CST_KMS_ID_13 = '13'; //Dr指示：特殊撮影
CST_KMS_ID_14 = '14'; //検像コメント
CST_KMS_ID_17 = '17'; //フィルム枚数
//2003.12.09
CST_KMS_ID_18 = '18'; //備考
CST_KMS_ID_19 = '19'; //治療用　新/継
CST_KMS_ID_20 = '20'; //治療用　線原種類
CST_KMS_ID_21 = '21'; //mAs
CST_KMS_ID_22 = '22'; //ｽｷｬﾝ数

//2002.11.19
//■情報項目別マスタ区分
GPCST_SOUSIN_FLG_0 = '0';
GPCST_SOUSIN_FLG_1 = '1';
GPCST_SOUSIN_FLG_0_NAME = '未';
GPCST_SOUSIN_FLG_1_NAME = '済';

//2002.11.20
//日付のFormat
CST_FORMATDATE_0='YYYYMMDD';
CST_FORMATDATE_1='YYYY/MM/DD';
CST_FORMATDATE_2='YYYY/MM/DD HH:NN';
CST_FORMATDATE_3='YYYY/MM/DD HH:MM:SS';
CST_FORMATDATE_4='HHMMSS';
CST_FORMATDATE_5='HH:MM:SS';

//2002.11.21
//業務詳細画面ﾎﾞﾀﾝ操作
GPCST_BUTTON_0 = '0';  //保存のみ
GPCST_BUTTON_1 = '1';  //検査保留
GPCST_BUTTON_2 = '2';  //実施
GPCST_BUTTON_3 = '3';  //検像終了
GPCST_BUTTON_4 = '4';  //清算済

CST_ENG_TUKI_1='Jan';
CST_ENG_TUKI_2='Feb';
CST_ENG_TUKI_3='Mar';
CST_ENG_TUKI_4='Apr';
CST_ENG_TUKI_5='May';
CST_ENG_TUKI_6='Jun';
CST_ENG_TUKI_7='Jul';
CST_ENG_TUKI_8='Aug';
CST_ENG_TUKI_9='Sep';
CST_ENG_TUKI_10='Oct';
CST_ENG_TUKI_11='Nov';
CST_ENG_TUKI_12='Dec';

//MWM用送信、受信文字
GPCST_JUSIN_MOJI = 'START';
GPCST_JUSIN_MOJI_LEN = 5;
GPCST_SOUSIN_MOJI_1 = 'OK';
GPCST_SOUSIN_MOJI_2 = 'NG';
GPCST_SOUSIN_MOJI_LEN = 2;
//優先
GPCST_YUUSEN_0='0';
GPCST_YUUSEN_1='1';
GPCST_YUUSEN_2='2';
GPCST_YUUSEN_0_RYAKUNAME='';
GPCST_YUUSEN_1_RYAKUNAME='承';
GPCST_YUUSEN_2_RYAKUNAME='優';

GPCST_INFKBN_FU='FU';   //受付
GPCST_INFKBN_FC='FC';   //受付キャンセル {2002.12.17]
GPCST_INFKBN_FO='F0';   //実施
GPCST_INFKBN_F1='F1';   //中止           {2002.12.17]
GPCST_INFKBN_FY='FY';   //予約           {2003.01.07]
GPCST_INFKBN_FH='FH';   //保留
GPCST_SYORIKBN_01='01'; //新規
GPCST_SYORIKBN_02='02'; //更新
GPCST_SYORIKBN_03='03'; //削除
GPCST_JOUTAIKBN_3='3'; //実施
GPCST_JOUTAIKBN_7='7'; //中止

//ダイレクト印刷フラグ
GPCST_DIRECT_FLG='1';

GPCST_FCR = 'FCR';
GPCST_FPD = 'FPD';

{2003.05.07 start}
GPCST_NEW_FEILD_NAME = 'MWMCARET_FLG';
GPCST_MWM_TYPE_FLG_0 = '0';
GPCST_MWM_TYPE_FLG_0_NAME = '不要';
GPCST_MWM_TYPE_FLG_1 = '1';
GPCST_MWM_TYPE_FLG_1_NAME = '必要';
{2003.05.07 end}

//2003.12.11
//検査機器マスタ表示Flg用
GPCST_HYOJI_FLG_0 = '0';
GPCST_HYOJI_FLG_0_NAME = 'しない';
GPCST_HYOJI_FLG_1 = '1';
GPCST_HYOJI_FLG_1_NAME = 'する';

//伝票印刷フラグ  2003.12.11
GPCST_DENPYO_INSATU_FLG_1 = '1';

//患者紹介フラグ  2003.12.11
GPCST_KANJA_SYOKAIFLG_0 = '0';
GPCST_KANJA_SYOKAIFLG_1 = '1';

//精算フラグ 2003.12.12
GSPCST_SEISAN_FLG_0 = '0';
GSPCST_SEISAN_FLG_0_NAME = '未精算';
GSPCST_SEISAN_FLG_1 = '1';
GSPCST_SEISAN_FLG_1_NAME = '精算済';

//2003.10.13--------------------------------------------------------------------
GPCST_SATUEIJISSI_NAME = '★☆撮影実施者★☆';
//2003.10.13--------------------------------------------------------------------
GSPCST_GYOUMU_KBN_1 = '1';
GSPCST_GYOUMU_KBN_1_NAME = '日勤';
GSPCST_GYOUMU_KBN_2 = '2';
GSPCST_GYOUMU_KBN_2_NAME = '当直';
GSPCST_GYOUMU_KBN_3 = '3';
GSPCST_GYOUMU_KBN_3_NAME = '深夜';
GSPCST_GYOUMU_KBN_4 = '4';
GSPCST_GYOUMU_KBN_4_NAME = '緊急';

GSPCST_PORTABLE_FLG_0 = '0';
GSPCST_PORTABLE_FLG_1 = '1';
GSPCST_PORTABLE_FLG_2 = '2';
GSPCST_PORTABLE_FLG_3 = '3'; //2004.04.21

//同意書区分 2003.12.15
GPCST_DOUISHO_KBN_0 = '0';
GPCST_DOUISHO_KBN_0_NAME = 'なし';
GPCST_DOUISHO_KBN_1 = '1';
GPCST_DOUISHO_KBN_1_NAME = 'あり';

//受信マスタテーブル
//状態F 2003.12.16
GPCST_JOUTAI_FLG_0 = '0';
GPCST_JOUTAI_FLG_0_NAME = '表示';
GPCST_JOUTAI_FLG_1 = '1';
GPCST_JOUTAI_FLG_1_NAME = '確認済み';
GPCST_JOUTAI_FLG_3 = '3';
GPCST_JOUTAI_FLG_3_NAME = '削除';
//処理区分 2003.12.16
GPCST_JUSHIN_SHORI_1 = '1';
GPCST_JUSHIN_SHORI_1_NAME = '新規';
GPCST_JUSHIN_SHORI_2 = '2';
GPCST_JUSHIN_SHORI_2_NAME = '変更';
GPCST_JUSHIN_SHORI_3 = '3';
GPCST_JUSHIN_SHORI_3_NAME = '削除';
//マスタ区分 2003.12.18
GPCST_JUSHIN_MASTERTYPE_1 =  '1';
GPCST_JUSHIN_MASTERTYPE_1_NAME  = '撮影手技';
GPCST_JUSHIN_MASTERTYPE_11 = '11';
GPCST_JUSHIN_MASTERTYPE_11_NAME = '部位';
GPCST_JUSHIN_MASTERTYPE_12 = '12';
GPCST_JUSHIN_MASTERTYPE_12_NAME = '指示';
GPCST_JUSHIN_MASTERTYPE_13 = '13';
GPCST_JUSHIN_MASTERTYPE_13_NAME = '薬剤';
GPCST_JUSHIN_MASTERTYPE_14 = '14';
GPCST_JUSHIN_MASTERTYPE_14_NAME = '器材';
GPCST_JUSHIN_MASTERTYPE_15 = '15';
GPCST_JUSHIN_MASTERTYPE_15_NAME = 'ﾌｨﾙﾑ';
GPCST_JUSHIN_MASTERTYPE_16 = '16';
GPCST_JUSHIN_MASTERTYPE_16_NAME = '撮影方法';
GPCST_JUSHIN_MASTERTYPE_17 = '17';
GPCST_JUSHIN_MASTERTYPE_17_NAME = '加算';
GPCST_JUSHIN_MASTERTYPE_18 = '18';
GPCST_JUSHIN_MASTERTYPE_18_NAME = '造影剤';
GPCST_JUSHIN_MASTERTYPE_C =  'C';
GPCST_JUSHIN_MASTERTYPE_C_NAME  = '担当者マスタ';
//部位未送信F
GPCST_MISOUSIN_FLG_1 = '1'; //未送信
GPCST_MISOUSIN_FLG_1_NAME = '未送信'; //未送信
GPCST_MISOUSIN_FLG_N = '0';  //送信
GPCST_MISOUSIN_FLG_N_NAME = '送信';  //送信
//チャージ未使用F
GPCST_CHARGE_FLG_1 = '1'; //未使用
GPCST_CHARGE_FLG_1_NAME = '不可'; //未使用
GPCST_CHARGE_FLG_N = '0';  //使用
GPCST_CHARGE_FLG_N_NAME = '可'; //使用
//閉経区分
GPCST_HEIKEI_KBN_1 = '1';
GPCST_HEIKEI_KBN_1_NAME = '後';
GPCST_HEIKEI_KBN_0 = '0';
GPCST_HEIKEI_KBN_0_NAME = '前';
//月経規則
GPCST_GEKKEI_KBN_1 = '1';
GPCST_GEKKEI_KBN_1_NAME = '不規則';
GPCST_GEKKEI_KBN_0 = '0';
GPCST_GEKKEI_KBN_0_NAME = 'ほぼ規則的';
//月経調査票必要
GPCST_GEKKEI_FLG_0 = '0';
GPCST_GEKKEI_FLG_0_NAME = '不要';
GPCST_GEKKEI_FLG_1 = '1';
GPCST_GEKKEI_FLG_1_NAME = '必要';
//ポータブルフラグ
GPCST_PORTABLE_FLG_0 = '0';
GPCST_PORTABLE_FLG_0_NAME = '通常';
GPCST_PORTABLE_FLG_1 = '1';
GPCST_PORTABLE_FLG_1_NAME = 'ポータブル';
GPCST_PORTABLE_FLG_2 = '2';
GPCST_PORTABLE_FLG_2_NAME = '手術室';
GPCST_PORTABLE_FLG_3 = '3';           //2004.06.15
GPCST_PORTABLE_FLG_3_NAME = 'その他'; //2004.06.15
//2003.12.25
//RIオーダ番号変換番号（注射・検査）
GPCST_RIORDER_NO_CHUSYA = '0';
GPCST_RIORDER_NO_KENSA  = '6';

//2004.01.22
//ReportRisTable設定フラグ(WinMaster用)
GPCST_REPORT_FLG_1 = '1';
GPCST_REPORT_FLG_1_NAME = 'あり';
GPCST_REPORT_FLG_0 = '0';
GPCST_REPORT_FLG_0_NAME = 'なし';

GPCST_MISIYOU_FLG_1 = '1';
GPCST_MISIYOU_FLG_1_NAME = '未使用';
GPCST_MISIYOU_FLG_0 = '0';
GPCST_MISIYOU_FLG_0_NAME = '使用';

//RISオーダ送信キュー作成設定  2004.02.05
GPCST_RISORDERSOUSIN_FLG_0 = '0';
GPCST_RISORDERSOUSIN_FLG_0_NAME = 'なし';
GPCST_RISORDERSOUSIN_FLG_1 = '1';
GPCST_RISORDERSOUSIN_FLG_1_NAME = '通常'; //'あり'; //2004.04.09
//2004.04.09
GPCST_RISORDERSOUSIN_FLG_2 = '2';
GPCST_RISORDERSOUSIN_FLG_2_NAME = 'HISなしRepあり';

//2004.03.25--
//転送オーダーテーブル
//確認F
GPCST_TENSOU_KAKUNIN_FLG_0 = '0';
GPCST_TENSOU_KAKUNIN_FLG_0_NAME = '表示';
GPCST_TENSOU_KAKUNIN_FLG_1 = '1';
GPCST_TENSOU_KAKUNIN_FLG_1_NAME = '確認済み';
GPCST_TENSOU_KAKUNIN_FLG_3 = '3';
GPCST_TENSOU_KAKUNIN_FLG_3_NAME = '削除';
//情報種別
GPCST_TENSOU_INFKBN_F0 = 'F0';
GPCST_TENSOU_INFKBN_FU = 'FU';
GPCST_TENSOU_INFKBN_FC = 'FC';
GPCST_TENSOU_INFKBN_F1 = 'F1';
GPCST_TENSOU_INFKBN_F0_NAME = '実施情報';
GPCST_TENSOU_INFKBN_FU_NAME = '検査受付';
GPCST_TENSOU_INFKBN_FC_NAME = '受付キャンセル';
GPCST_TENSOU_INFKBN_F1_NAME = '検査中止';
GPCST_TENSOU_INFKBN_JISSHI_NAME = '実施情報';
GPCST_TENSOU_INFKBN_UKETUKE_NAME = '受付情報';
GPCST_TENSOU_INFKBN_KANJA_NAME = '患者情報要求';
GPCST_TENSOU_INFKBN_JUSHIN_NAME = '受信ｵｰﾀﾞﾃｰﾌﾞﾙ';   //2004.05.04
//状態メッセージ
GPCST_TENSOU_JOUTAI_01 = '01';
GPCST_TENSOU_JOUTAI_02 = '02';
GPCST_TENSOU_JOUTAI_03 = '03';
GPCST_TENSOU_JOUTAI_04 = '04';
//2004.03.31
GPCST_TENSOU_JOUTAI_66 = '66';
GPCST_TENSOU_JOUTAI_77 = '77';
GPCST_TENSOU_JOUTAI_88 = '88';
GPCST_TENSOU_JOUTAI_99 = '99';
GPCST_TENSOU_JOUTAI_01_NAME = '成功';
GPCST_TENSOU_JOUTAI_02_NAME = '電文エラー';
GPCST_TENSOU_JOUTAI_03_NAME = '通信エラー';
GPCST_TENSOU_JOUTAI_04_NAME = 'ユーザ確認';
//2004.03.31
GPCST_TENSOU_JOUTAI_66_NAME = '送信済電文エラー';
GPCST_TENSOU_JOUTAI_77_NAME = '送信済例外エラー';
GPCST_TENSOU_JOUTAI_88_NAME = '進捗エラー';
GPCST_TENSOU_JOUTAI_99_NAME = '未送信例外エラー';
//送信フラグ
GPCST_TENSOU_SOUSHINFLG_0 = '0';
GPCST_TENSOU_SOUSHINFLG_1 = '1';
GPCST_TENSOU_SOUSHINFLG_0_NAME = '未';
GPCST_TENSOU_SOUSHINFLG_1_NAME = '済';
//登録種別
GPCST_TENSOU_SYORIKBN_01 = '01';
GPCST_TENSOU_SYORIKBN_02 = '02';
GPCST_TENSOU_SYORIKBN_03 = '03';
GPCST_TENSOU_SYORIKBN_01_NAME = '新規';
GPCST_TENSOU_SYORIKBN_02_NAME = '更新';
GPCST_TENSOU_SYORIKBN_03_NAME = '削除';
//--2004.03.25
//■フィルム整理票印刷
GPCST_FILMLABEL_1 = '1';     //
GPCST_FILMLABEL_2 = '2';     //
GPCST_FILMLABEL_3 = '3';     //

GPCST_FILMLABEL_1_NAME = '保留・検査済';     //
GPCST_FILMLABEL_2_NAME = '検査済のみ';     //
GPCST_FILMLABEL_3_NAME = 'なし';     //

//2004.05.04--
//受信オーダテーブル
//シェーマ取得フラグ
GPCST_JUSHIN_SHEMA_0 ='0';
GPCST_JUSHIN_SHEMA_1 ='1';
GPCST_JUSHIN_SHEMA_2 ='2';
GPCST_JUSHIN_SHEMA_0_NAME ='シェーマ未取得';
GPCST_JUSHIN_SHEMA_1_NAME ='シェーマ取得済み';
GPCST_JUSHIN_SHEMA_2_NAME ='失敗';

//2004.05.05 ->
//撮影場所区分（病室マスタ）
GPCST_CODE_BYK_1 = '1';   //本館
GPCST_CODE_BYK_2 = '2';   //別館
GPCST_CODE_BYK_3 = '3';   //救命
//<-

type  //照合データ構造体
  TTUKA_SHUGI = record
      KBN        : TStringList;      //区分
      KBN_NAME   : TStringList;      //区分名称
      KBN_ID     : TStringList;      //区分ID
      NAME       : TStringList;      //名称
      ID         : TStringList;      //ID
      SUBNAME    : TStringList;      //ｻﾌﾞ区分名称
      SUBID      : TStringList;      //ｻﾌﾞ区分ID
      IJISU      : TStringList;      //医事数
      IJITANI    : TStringList;      //医事単位
      JISSAISU   : TStringList;      //実際数
      JISSAITANI : TStringList;      //実際単位
      SHORI_FLG  : TStringList;      //処理ﾌﾗｸﾞ　1：追加　2：修正　3：削除
      DB_FLG     : TStringList;      //DBﾌﾗｸﾞ　
  end;

var
//シェーマ領域
g_Shema_OrderNO: string;
g_Shema_KanjaID: string;
g_Shema_KanjaName: string;
g_Shema_Bui_File: array[0..9] of string;
g_Shema_Bui_Name:  array[0..9] of string;
g_Shema_Bui_Comment: array[0..9] of string;
g_Shema_DirM: array[0..9] of string;
g_Shema_DirS: array[0..9] of string;
g_Shema_File: array[0..9] of string;
g_Shema_Client_File: array[0..9] of string;
g_Shema_HTML_Original_File: string;
g_Shema_HTML_File: string;
//画像表示領域
g_Gazou_HTML_File: string; //

//RISオーダ送信キュー作成設定  2004.02.05
g_RIS_Order_Sousin_Flg :String;    //0：転送オーダにキュー作成なし 1：転送オーダにキュー作成


//変数宣言-------------------------------------------------------------------
//var
//関数手続き宣言-------------------------------------------------------------
//●機能（例外有）：NameMSの特定区分をコンボに設定（コンボクリアする）
procedure proc_NameMSToComb(
   arg_Qry:TQuery;
   arg_KBN:string;
   arg_Comb: TComboBox
   );
//●機能（例外有）：NameMSの特定区分をコンボに設定（コンボクリアしない）
procedure proc_NameMSToComb1(
   arg_Qry:TQuery;
   arg_KBN:string;
   arg_Comb: TComboBox
   );
//●機能（例外有）：ListViewの内容を作成
procedure proc_ListViewToFile(
       arg_FName:string;      //保存ファイル名
       arg_ListView:TListView //対象
       );
//●機能（例外有）：StringGridの内容をcsvに保存
procedure proc_StringGridToFile(
       arg_FName:string;          //保存ファイル名
       arg_StringGrid:TStringGrid //対象
       );
//●機能（例外有）：StringGridの内容をcsvに保存
//                  非表示カラムは保存しない
procedure proc_StringGridToFile2(
       arg_FName:string;          //保存ファイル名
       arg_StringGrid:TStringGrid //対象
       );
//●機能（例外無）：DateのBetween句を作成
function func_DateBetween(
       arg_FName:string;   //項目名
       arg_Date1:TDate;    //初め
       arg_Date2:TDate     //終り
       ):string;
//●機能（例外有）：KANRIテーブルの権利全削除
function func_DelKAnri(
       arg_DB:TDatabase;         //接続されたDB
       arg_TanName:string       //PC名称
       ):boolean;                //結果True成功 False失敗
//●機能（例外有）：KANRIテーブルの権利返還
function func_ReleasKAnri(
       arg_DB:TDatabase;         //接続されたDB
       arg_TanName:string;       //PC名称
       arg_ProgId:string;        //プログラムID
       arg_RisId:string;         //RIS識別ID
       arg_SyoriMode:string      //返還権利種 G_KANRI_TBL_RMODE 参照権利
                                 //           G_KANRI_TBL_WMODE 更新権利

       ):boolean;                //結果True成功 False失敗
//●機能（例外有）：KANRIテーブルの参照権利取得
function func_GetRKAnri(
       arg_DB:TDatabase;         //接続されたDB
       arg_TanName:string;       //PC名称
       arg_ProgId:string;        //プログラムID
       arg_RisId:string          //RIS識別ID
       ):boolean;                //結果True成功 False失敗
//●機能（例外有）：KANRIテーブルの更新権利取得
function func_GetWKAnri(
       arg_DB:TDatabase;         //接続されたDB
       arg_TanName:string;       //PC名称
       arg_ProgId:string;        //プログラムID
       arg_RisId:string          //RIS識別ID
       ):boolean;                //結果True成功 False失敗

//2002.11.28
//●機能（例外有）：KANRIテーブルの更新権利取得
function func_GetWKAnriUketuke(
       arg_DB:TDatabase;         //接続されたDB
       arg_TanName:string;       //PC名称
       arg_ProgId:string;        //プログラムID
       arg_RisId:string          //RIS識別ID
       ):boolean;                //結果True成功 False失敗
//●機能（例外有）：USERMSのUser_nameを確認
function func_ChkUserName(
       arg_DB:TDatabase;
       arg_UserName:string
       ):boolean;
//●機能（例外有）：USERMSのUser_nameとPASSWORDを確認
function func_ChkUserPass(
       arg_DB:TDatabase;
       arg_UserName:string;
       arg_Password:string
       ):boolean;
//●機能（例外有）：USERMSのUser_nameとclassを確認
function func_ChkUserClass(
       arg_DB:TDatabase;         //接続されたDB
       arg_UserName:string;      //ユーザ名
       arg_Class:string          //クラス
       ):boolean;
//●機能（例外有）：SQLの結果のレコード数を返す
function func_SqlCount(
       arg_DB:TDatabase;
       arg_Sql:Tstrings):Integer;
//●機能（例外有）：SQLの実行結果を返す
function func_SqlExec(
       arg_DB:TDatabase;          //接続されたDB
       arg_Sql:Tstrings):boolean; //有効なSQL
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 手技区分
function func_PIND_Change_SYUGI(
       arg_Code:string    //ｺｰﾄﾞ
       ):string;          //名称
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 造影剤区分
function func_PIND_Change_ZOUEI(
       arg_Code:string    //ｺｰﾄﾞ
       ):string;          //名称
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 撮影進捗  SATUEI
function func_PIND_Change_SATUEI(
       arg_Code:string    //ｺｰﾄﾞ
       ):string;          //名称
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 時間外区分
function func_PIND_Change_JIKAN(
       arg_Code:string    //ｺｰﾄﾞ
       ):string;          //名称
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 RI実施フラグ
function func_PIND_Change_RI(
       arg_Code:string    //ｺｰﾄﾞ
       ):string;          //名称
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 所見依頼フラグ
function func_PIND_Change_SYOKEN(
       arg_Code:string    //ｺｰﾄﾞ
       ):string;          //名称
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 検査進捗  KENSIN
function func_PIND_Change_KENSIN(
       arg_Code:string;    //ｺｰﾄﾞ
       arg_SubCode:string    //ｺｰﾄﾞ
       ):string;          //名称
//●機能（例外無）：ｺｰﾄﾞを略名前に変換登録 検査進捗  KENSIN
function func_PIND_Change_KENSIN_Ryaku(
       arg_Code:string    //ｺｰﾄﾞ
       ):string;          //名称
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録システム区分
function func_PIND_Change_SYSK(
       arg_Code:string    //ｺｰﾄﾞ
       ):string;          //名称

//●機能（例外無）：ｺｰﾄﾞを名前に変換 性
function func_PIND_Change_Sex(
       arg_Code:string    //ｺｰﾄﾞ
       ):string;          //名称
//●機能（例外無）：ｺｰﾄﾞを名前に変換 入外区分
function func_PIND_Change_Nyugai(
       arg_Code:string    //ｺｰﾄﾞ
       ):string;          //名称

//●機能（例外無）：ワークリスト予約テーブル用キー項目編集
function func_WorklistInfo_Key_Make(
         //IN
         arg_KanjaID: string;
         arg_OrderNO: string;
         //OUT
         var arg_Rcv_ACCESSION_NUMBER: string;
         var arg_Rcv_PATIENT_ID: string
        ): Boolean;
//●機能（例外無）：ワークリスト予約テーブル用全項目編集
function func_WorklistInfo_Make(
         //IN
         arg_Query: TQuery;
         arg_Group_No: string;
         arg_SysDate: string;
         arg_SysTime: string;
         arg_KanjaID: string;
         arg_OrderNO: string;
         arg_SimeiKana: string;
         arg_SimeiKanji: string;
         arg_Sex: string;
         arg_BirthDay: string;
         arg_Start_Date: string;
         arg_Start_Time: string;
         arg_Irai_Doctor_Name: string;
         arg_Irai_Section_Name: string;
         arg_Irai_Section_Kana: string;
         arg_KensaKikiName: string;
         arg_Modality_Type: string;
         arg_KensaComment1: string;
         arg_SUID: string;
         //OUT
         var arg_Rcv_SCH_STATION_AE_TITLE: string;
         var arg_Rcv_SCH_PROC_STEP_LOCATION: string;
         var arg_Rcv_SCH_PROC_STEP_START_DATE: string;
         var arg_Rcv_SCH_PROC_STEP_START_TIME: string;
         var arg_Rcv_SCH_PERF_PHYSICIANS_NAME_ROMA: string;
         var arg_Rcv_SCH_PERF_PHYSICIANS_NAME_KANJI: string;
         var arg_Rcv_SCH_PERF_PHYSICIANS_NAME_KANA: string;
         var arg_Rcv_SCH_PROC_STEP_DESCRIPTION: string;
         var arg_Rcv_SCH_PROC_STEP_ID: string;
         var arg_Rcv_COMMENTS_ON_THE_SCH_PROC_STEP: string;
         var arg_Rcv_MODALITY: string;
         var arg_Rcv_REQ_PROC_ID: string;
         var arg_Rcv_STUDY_INSTANCE_UID: string;
         var arg_Rcv_REQ_PROC_DESCRIPTION: string;
         var arg_Rcv_REQUESTING_PHYSICIAN: string;
         var arg_Rcv_REQUESTING_SERVICE: string;
         var arg_Rcv_ACCESSION_NUMBER: string;
         var arg_Rcv_INSTITUTION: string;
         var arg_Rcv_INSTITUTION_ADDRESS: string;
         var arg_Rcv_PATIENT_NAME_ROMA: string;
         var arg_Rcv_PATIENT_NAME_KANJI: string;
         var arg_Rcv_PATIENT_NAME_KANA: string;
         var arg_Rcv_PATIENT_ID: string;
         var arg_Rcv_PATIENT_BIRTH_DATE: string;
         var arg_Rcv_PATIENT_SEX: string;
         var arg_Rcv_PATIENT_WEIGHT: string
        ): Boolean;
//●機能（例外無）：カタカナ→ローマ字変換
function func_Kana_To_Roma(
         arg_Kana: string
         ): string;
//●★使用可★機能（例外有）：現在番号+1取得
function func_Get_NumberControl(
         arg_Database:TDatabase;
         arg_Query:TQuery;
         arg_Kubun:string;
         arg_Date:string
         ):integer;
//●★使用可★機能（例外有）：現在番号更新
function func_NumberControl_Update(
         arg_Database:TDatabase;
         arg_Query:TQuery;
         arg_Mode:integer;
         arg_Kubun:string;
         arg_UpdateDate:string;
         arg_Now_NO:integer
         ):Boolean;
//●機能（例外無）：ｺｰﾄﾞを名前に変換 会計種別
function func_PIND_Change_KAIKEI(arg_Code:string):string;
//●機能（例外無）：ｺｰﾄﾞを名前に変換 帰宅指示
function func_PIND_Change_KITAKU(arg_Code:string):string;
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 病院連絡TEL
function func_PIND_Change_TEL(arg_Code:string):string;
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 所見要否
function func_PIND_Change_SYOKEN_YOUHI(arg_Code:string):string;//名称
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 撮影進捗
function func_PIND_Change_SATUEISTATUS(arg_Code:string):string;//名称
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 画像確認
function func_PIND_Change_GAZOU_KAKUNIN(arg_Code:string):string;//名称

//●機能（例外無）：ｺｰﾄﾞを名前に変換 帰宅指示
function func_PIND_Change_KITAKU_G(arg_Code:string):string;
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 病院連絡TEL
function func_PIND_Change_TEL_G(arg_Code:string):string;
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 画像確認
function func_PIND_Change_GAZOU_KAKUNIN_G(arg_Code:string):string;//名称

//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 色替要否
function func_PIND_Change_COLOR_YOUHI(arg_Code:string):string;//名称
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 左右使用
function func_PIND_Change_SAYUU(arg_Code:string):string;//名称
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 読影要否
function func_PIND_Change_DOKUEI(arg_Code:string):string;//名称
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 処置室使用
function func_PIND_Change_SHOTI(arg_Code:string):string;//名称
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 処置室使用・略称
function func_PIND_Change_SHOTI_RYAKU(arg_Code:string):string;//名称
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 要造影
function func_PIND_Change_YZOUEI(arg_Code:string):string;//名称
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 放科医師立会
function func_PIND_Change_ISITATIAI(arg_Code:string):string;//名称
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 放科医師立会・略称
function func_PIND_Change_ISITATIAI_RYAKU(arg_Code:string):string;//名称
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 FCR連携
function func_PIND_Change_FCR(arg_Code:string):string;//名称
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 MPPS対応
function func_PIND_Change_MPPS(arg_Code:string):string;//名称
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 エラー回避
function func_PIND_Change_Err(arg_Code:string):string;//名称
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 会計送信種別
function func_PIND_Change_KAIKEISOUSIN(arg_Code:string):string;//名称
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 RIオーダ区分
function func_PIND_Change_RI_ORDER(arg_Code:string):string;//名称

//●機能（例外無）：プリンタタイプ取得
function func_Get_PrintType(arg_Type:String):String;
//●機能（例外無）：全文字列の全角チェック
function func_ALL_ZENKAKU_CHECK(arg_text: string):Boolean;
//●機能（例外無）：全文字列の半角チェック
function func_ALL_HANKAKU_CHECK(arg_text: string):Boolean;
//2002.11.18
//●機能（例外無）：全文字列の半角チェック
function func_ALL_HANKAKU_AISUU_CHECK(arg_text: string):Boolean;
//2002.10.02 追加
//●機能（例外無）：グリッドカラム幅を書き込む
function func_Grid_ColumnSize_Write(arg_Grid: TStringGrid; arg_Name,arg_No: string):Boolean;
//●機能（例外無）：グリッドカラム幅を読み込む
procedure proc_Grid_ColumnSize_Read(arg_Grid: TStringGrid; arg_Name,arg_No: string; var arg_Column: TStringList);
//●機能（例外無）：グリッドカラム幅をセットする
procedure proc_Grid_ColumnSize_Set(arg_Grid: TStringGrid; arg_Name,arg_No: string);
//2002.10.21 追加
//2002.10.23 修正 検査コメント項目名を格納
//●機能（例外無）：検査種別毎のフィルタフラグ項目名の格納変数セット
function func_SetKensaTypeFilter_Flg(arg_Query: TQuery):Boolean;
//●機能（例外無）：検査種別IDでフィルタフラグ項目名を返す
function func_GetFilter_Flg_Name(arg_KensaType_ID: String):String;
//2002.10.23 追加
//●機能（例外無）：検査種別IDで検査コメント項目名を返す
function func_GetKensa_Comment_Name(arg_KensaType_ID: String):String;
//2004.04.09--
//●機能（例外無）：RISオーダ時の転送オーダ、転送Reportテーブルへのキュー作成判定
//　詳細　ダミー患者判定、オーダ作成時のレポート送信キュー作成判定、RISオーダ時のHIS、Report送信判定
//　注意事項　関数使用前にproc_SetOrderSoushin関数が実行されている事が前提
function func_Check_CueAndDummy(arg_SysKbn:String;arg_KanjaID:String;arg_Mode:integer):Boolean;
//●機能（例外無）：RISオーダ送信フラグセット
procedure proc_SetOrderSoushin;
//--2004.04.09
//●機能（例外無）： ダミー患者判定 2004.08.06
function func_Check_DummyKanja(arg_KanjaID:string  //患者ID
                               ):Boolean;

function GetWeekInfo(Day:String;Week,SName:TPanel):Boolean;
var
  //2002.10.21 検査種別毎のフィルタフラグ項目名の格納変数宣言
  ga_KENSA_TYPE_FEILD: array of TKensaType_Field;
  gi_KENSA_TYPE_FIELD_COUNT: Integer;
  g_TuikaShugi_info:TTUKA_SHUGI;
//2002.10.22
//●機能（例外無）：患者IDより患者情報取得
function func_KanjaInfo_Make(
         //IN
         arg_Query: TQuery;
         arg_Query2: TQuery;
         arg_KanjaID: string;
         //OUT
         var arg_SimeiKanji: string;      //漢字氏名
         var arg_SimeiKana: string;       //カナ氏名
         var arg_Sex: string;             //性別
         var arg_BirthDay: string;        //生年月日
         var arg_Age: string;             //年齢
         var arg_Byoutou_ID: string;      //病棟ID
         var arg_Byoutou: string;         //病棟名称
         var arg_Byousitu_ID: string;     //病室ID
         var arg_Byousitu: string;        //病室名称
         var arg_Kanja_Nyugaikbn: string; //患者入外区分
         var arg_Kanja_Nyugai: string;    //患者入外区分名称
         var arg_Section_ID: string;      //診療科ID
         var arg_Section: string;         //診療科
         var arg_Sincyo: string;          //身長
         var arg_Taijyu: string           //体重
        ): Boolean;
//●機能（例外無）：RIS識別IDより患者情報取得
function func_KanjaOrderInfo_Make(
         //IN
         arg_Query: TQuery;
         arg_Query2: TQuery;
         arg_RIS_ID: string;
         //OUT
         var arg_KanjaID: string;               //患者ID
         var arg_SimeiKanji: string;            //漢字氏名
         var arg_SimeiRoma: string;             //英字氏名
         var arg_Sex: string;                   //性別
         var arg_BirthDay: string;              //生年月日
         var arg_Age: string;                   //年齢
         var arg_Byoutou_ID: string;            //病棟ID
         var arg_Byoutou: string;               //病棟名称
         var arg_Byousitu_ID: string;           //病室ID
         var arg_Byousitu: string;              //病室名称
         var arg_Kanja_Nyugaikbn: string;       //患者入外区分
         var arg_Kanja_Nyugai_Name: string;     //患者入外区分名称
         var arg_Section_ID: string;            //診療科ID
         var arg_Section: string;               //診療科
         var arg_Sincyo: string;                //身長
         var arg_Taijyu: string;                //体重
         var arg_Irai_Name: string;             //依頼科名称
         var arg_Irai_SectionID: string;        //依頼科ID
         var arg_Denpyo_NyugaiKbn: string;      //伝票入外区分(伝票病棟)
         var arg_Denpyo_NyugaiName: string;     //伝票入外区分名称(伝票病棟)
         var arg_Denpyo_ByoutouID: string;      //伝票病棟ID
         var arg_IraiDoctor: string;            //依頼医師名
         var arg_Section_Tel1: string;          //依頼科連絡先(上４桁)
         var arg_Section_Tel2: string           //依頼科連絡先(上４桁以降)
        ): Boolean;

//テキスト用ログ作成
procedure proc_Append_Log(arg_DispID:String;      //画面ID
                          arg_Disp_Name:String;    //画面名称
                          arg_Msg:String;          //処理名称
                          arg_str,arg_str2:String);//予備1.2

//●機能（例外無）：シェーマ格納ファイル名作成
function func_Make_ShemaName(arg_OrderNO,               //オーダNO
                             arg_MotoFileName: string;  //HISｼｪｰﾏ名
                             arg_Index: integer         //部位NO
                             ):string;                  //格納ﾌｧｲﾙ名

//2002.12.06 ソフィスケート追加　←
//●機能（例外無）：進捗フラグによる受付番号表示・非表示値を返す
function func_GetUke_No(arg_Main,arg_Sub: String):Bool;
//●機能（例外無）：進捗フラグによる色のキーコードを返す
function func_GetColor_Key(arg_Main,arg_Sub: String):String;
//●機能（例外無）：優先フラグによる優先名を返す
function func_GetYuusen_Name(arg_Yuusen: String):String;
//●機能（例外無）：ﾃﾞｼﾞﾀｲｽﾞ区分によるﾃﾞｼﾞﾀｲｽﾞ名を返す
function func_GetDejitaizu_Name(arg_Dejitaizu: String):String;
//●機能（例外無）：WAVEファイルのDirを返す
function func_GetWav_Name:String;  //2002.12.08
//2002.12.06 ソフィスケート追加　←


//2002.10.22

//●機能（例外無）：文字変換
function func_Moji_Henkan(arg_Moji: string;
                          arg_Flg: Integer  //1:全角→半角、2:半角→全角、3:全角ひらがな→半角カタカナ
                          ): string;
//同日他検査取得 戻り値：検査種別略称 進捗略称 EX. X未 C中
function func_Make_Takensa(arg_RIS_ID, arg_KanjaID,
     arg_Date: String): String;
//同日他検査取得 戻り値：他検中フラグ 検査種別略称 進捗略称 EX. X未 C中   2003.10.07
function func_Make_Takensa2(arg_RIS_ID,arg_KanjaID,arg_Date,
                            arg_Main,arg_Sub:String;
                            var arg_v_takenchuu:String):String;

//メイン、サブステータスから進捗略称取得
function func_Stetas_Info_Ryaku(arg_Main_Sts,
      arg_Sub_Sts: String): String;


//●機能（例外無）：検査種別毎のネームカードの帳票Noを取得
function func_Get_NameCard_ID_No(arg_KensaTypeID:string): string;

//●機能（例外無）：受付票印刷検査種別毎の可否のを取得
function func_Get_UketukePrint_No(arg_KensaTypeID:string): Boolean;

//●機能（例外無）：帳票毎のダイレクト印刷フラグの取得取得
function func_Get_DirectFlg(
                    arg_Query: TQuery;
                    arg_CyohyouNo: string):string;

//●機能（例外無）：端末毎にイニシャル設定された種別から各業務毎有効な種別のみを取り出す
function func_Check_Initiali_Kensa(
                 arg_PrgId: string;
                 arg_Initiali_Kensa: string): string;

//●機能（例外無）：端末毎にイニシャル設定された実施装置から種別に紐付く有効な実施装置のみを取り出す
function func_Check_Initiali_Souti(
                 arg_PrgId: string;
                 arg_Query: TQuery;
                 arg_Initiali_Kensa: string;
                 arg_Initiali_Souti: string): string;

//2003.10.06 Start**************************************************************
//●機能（例外無）：グリッドカラム幅を書き込む(Gkit)
function func_Gkit_ColumnSize_Write(arg_GGrid: TGKitSpreadControl; arg_Name,arg_No: string):Boolean;
//●機能（例外無）：グリッドカラム幅を読み込む(Gkit)
procedure proc_Gkit_ColumnSize_Read(arg_GGrid: TGKitSpreadControl; arg_Name,arg_No: string; var arg_Column: string);
//●機能（例外無）：グリッドカラム幅をセットする(Gkit)
procedure proc_Gkit_ColumnSize_Set(arg_GGrid: TGKitSpreadControl; arg_Name,arg_No: string);
//2003.10.06 end****************************************************************

//●機能（例外無）：伝票印刷フラグの更新
function func_Update_Denpyo_Insatu_flg(arg_DB:TDatabase          //ﾃﾞｰﾀﾍﾞｰｽ
                                       ;arg_Key_RIS_ID:string     //RIS_ID (複数カンマ区切り)
                                       ;var arg_Err:string
                                       ): Boolean;
//●機能（例外無）：伝票印刷フラグの更新(核医学)
function func_Update_Denpyo_Insatu_flg_RI(arg_DB:TDatabase          //ﾃﾞｰﾀﾍﾞｰｽ
                                       ;arg_Key_RIS_ID:string     //RIS_ID (複数カンマ区切り)
                                       ;var arg_Err:string
                                       ): Boolean;

//2004.01.13
//●機能：現在時刻を元に業務区分を返す
function func_GyoumuKbn_Check(arg_KensaType:string;arg_Query:TQuery):string;

//●実績メインのRIS部位番号最大値を更新 2004.03.29
// トランザクションが開始されている事が前提
// 必ず実施処理で実績メイン、実績部位更新後にこの関数を呼び出す
// 実績メイン、実績部位と同じタイミングでコミット（同じトランザクション処理）
function func_Up_ExRis_Bui_No_Max(arg_RisID:string; //RIS識別ID
                              arg_Query:TQuery      //Query
                              ):Boolean;

//●実績メインのRIS部位番号最大値を更新（オーダ作成時） 2004.03.30
// 現状の実績部位のRIS部位番号最大値で更新
function func_Up_Pre_ExRis_Bui_No_Max(arg_RisID:string; //RIS識別ID
                                      arg_Query:TQuery      //Query
                                      ):Boolean;
                              
implementation

uses DB; //**************************************************************

//使用ユニット---------------------------------------------------------------
//uses

//定数宣言       -------------------------------------------------------------
const
//テーブル情報
CST_TBL_KANRI      = 'KanriTable';//管理テーブル名
CST_TBLIN_TAN_NAME = 'tan_name';  //管理テーブル項目名 端末名
CST_TBLIN_PRODID   = 'prog_id';   //管理テーブル項目名 プログラムID
CST_TBLIN_RISID    = 'ris_id';    //管理テーブル項目名 RIS識別ID
CST_TBLIN_SYORIMODE= 'syori_mode';//管理テーブル項目名 モード


//ディレクトリ情報（未使用）
//CST_COREP_DIR_NAME='co_rep\';
//CST_DUMMYIMAGE_DIR_NAME='Image\';
//CST_COREPORT_DIR_NAME='co_reptemp\';
//CST_OPENDEF_DIR_NAME='';
//CST_SAVEDEF_DIR_NAME='';
//CST_MRDRAW_EXEPATH='MRDraw\';
//CST_MRDRAW_INIPATH='MRDraw\';
//CST_MRDRAW_TEMPPATH='drawtemp\';
//CST_MRDRAW_SAVEPATH='drawsave\';
//CST_PPUP_EXEPATH='PlanID\';

//2004.01.13
//業務区分時刻設定
//祭日
CST_GYOKBN_SAI_2_S='08:30:00';     //当直Start
CST_GYOKBN_SAI_2_E='23:59:59';     //当直End
CST_GYOKBN_SAI_3_S='00:00:00';     //深夜Start
CST_GYOKBN_SAI_3_E='08:29:59';     //深夜End
//日曜
CST_GYOKBN_SUN_2_S='08:30:00';     //当直Start
CST_GYOKBN_SUN_2_E='23:59:59';     //当直End
CST_GYOKBN_SUN_3_S='00:00:00';     //深夜Start
CST_GYOKBN_SUN_3_E='08:29:59';     //深夜End
//土曜（第１,第３）
CST_GYOKBN_SAT_13_2_S='08:30:00';  //当直Start
CST_GYOKBN_SAT_13_2_E='23:59:59';  //当直End
CST_GYOKBN_SAT_13_3_S='00:00:00';  //深夜Start
CST_GYOKBN_SAT_13_3_E='08:29:59';  //深夜End
//土曜（第２,第４,第５）
CST_GYOKBN_SAT_245_1_S='08:30:00'; //日勤Start
CST_GYOKBN_SAT_245_1_E='13:30:59'; //日勤End
CST_GYOKBN_SAT_245_2_S='13:31:00'; //当直Start
CST_GYOKBN_SAT_245_2_E='23:59:59'; //当直End
CST_GYOKBN_SAT_245_3_S='00:00:00'; //深夜Start
CST_GYOKBN_SAT_245_3_E='08:29:59'; //深夜End
//平日
CST_GYOKBN_NOR_1_S='08:30:00';     //日勤Start
CST_GYOKBN_NOR_1_E='17:00:59';     //日勤End
CST_GYOKBN_NOR_2_S='17:01:00';     //当直Start
CST_GYOKBN_NOR_2_E='23:59:59';     //当直End
CST_GYOKBN_NOR_3_S='00:00:00';     //深夜Start
CST_GYOKBN_NOR_3_E='08:29:59';     //深夜End

//変数宣言     ---------------------------------------------------------------
//var
//関数手続き宣言--------------------------------------------------------------
//使用可能関数－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－


//名称コード変換処理－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－

//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 手技区分
function func_PIND_Change_SYUGI(
       arg_Code:string    //ｺｰﾄﾞ
       ):string;          //名称
var
   w_Res:string;
begin
  IF arg_Code=GPCST_CODE_SYUGI_0 THEN w_Res:= GPCST_NAME_SYUGI_0
  ELSE
  IF arg_Code=GPCST_CODE_SYUGI_1 THEN w_Res:= GPCST_NAME_SYUGI_1
  ELSE
  IF arg_Code=GPCST_CODE_SYUGI_2 THEN w_Res:= GPCST_NAME_SYUGI_2
{  ELSE
  IF arg_Code=GPCST_CODE_SYUGI_3 THEN w_Res:= GPCST_NAME_SYUGI_3}
  ELSE
  IF arg_Code=GPCST_NAME_SYUGI_0 THEN w_Res:= GPCST_CODE_SYUGI_0
  ELSE
  IF arg_Code=GPCST_NAME_SYUGI_1 THEN w_Res:= GPCST_CODE_SYUGI_1
  ELSE
  IF arg_Code=GPCST_NAME_SYUGI_2 THEN w_Res:= GPCST_CODE_SYUGI_2
//  ELSE
//  IF arg_Code=GPCST_NAME_SYUGI_3 THEN w_Res:= GPCST_CODE_SYUGI_3
  ELSE w_Res:= '';
  result:=w_Res;
end;
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 造影剤区分
function func_PIND_Change_ZOUEI(
       arg_Code:string    //ｺｰﾄﾞ
       ):string;          //名称
var
   w_Res:string;
begin
  IF arg_Code=GPCST_CODE_ZOUEI_0 THEN w_Res:= GPCST_NAME_ZOUEI_0
  ELSE
  IF arg_Code=GPCST_CODE_ZOUEI_1 THEN w_Res:= GPCST_NAME_ZOUEI_1
  ELSE
  IF arg_Code=GPCST_CODE_ZOUEI_2 THEN w_Res:= GPCST_NAME_ZOUEI_2
  ELSE
  IF arg_Code=GPCST_CODE_ZOUEI_3 THEN w_Res:= GPCST_NAME_ZOUEI_3
  ELSE
  IF arg_Code=GPCST_NAME_ZOUEI_0 THEN w_Res:= GPCST_CODE_ZOUEI_0
  ELSE
  IF arg_Code=GPCST_NAME_ZOUEI_1 THEN w_Res:= GPCST_CODE_ZOUEI_1
  ELSE
  IF arg_Code=GPCST_NAME_ZOUEI_2 THEN w_Res:= GPCST_CODE_ZOUEI_2
  ELSE
  IF arg_Code=GPCST_NAME_ZOUEI_3 THEN w_Res:= GPCST_CODE_ZOUEI_3
  ELSE w_Res:= '';
  result:=w_Res;
end;
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 撮影進捗  SATUEI
function func_PIND_Change_SATUEI(
       arg_Code:string    //ｺｰﾄﾞ
       ):string;          //名称
var
   w_Res:string;
begin
  IF arg_Code=GPCST_CODE_SATUEI_0 THEN w_Res:= GPCST_NAME_SATUEI_0
  ELSE
  IF arg_Code=GPCST_CODE_SATUEI_1 THEN w_Res:= GPCST_NAME_SATUEI_1
  ELSE
  IF arg_Code=GPCST_CODE_SATUEI_2 THEN w_Res:= GPCST_NAME_SATUEI_2
  ELSE
  IF arg_Code=GPCST_NAME_SATUEI_0 THEN w_Res:= GPCST_CODE_SATUEI_0
  ELSE
  IF arg_Code=GPCST_NAME_SATUEI_1 THEN w_Res:= GPCST_CODE_SATUEI_1
  ELSE
  IF arg_Code=GPCST_NAME_SATUEI_2 THEN w_Res:= GPCST_CODE_SATUEI_2
  ELSE w_Res:= '';
  result:=w_Res;
end;
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 時間外区分
function func_PIND_Change_JIKAN(
       arg_Code:string    //ｺｰﾄﾞ
       ):string;          //名称
var
   w_Res:string;
begin
  IF arg_Code=GPCST_CODE_JIKAN_0 THEN w_Res:= GPCST_NAME_JIKAN_0
  ELSE
  IF arg_Code=GPCST_CODE_JIKAN_1 THEN w_Res:= GPCST_NAME_JIKAN_1
  ELSE
  IF arg_Code=GPCST_CODE_JIKAN_2 THEN w_Res:= GPCST_NAME_JIKAN_2
  ELSE
  IF arg_Code=GPCST_CODE_JIKAN_3 THEN w_Res:= GPCST_NAME_JIKAN_3
  ELSE
  IF arg_Code=GPCST_NAME_JIKAN_0 THEN w_Res:= GPCST_CODE_JIKAN_0
  ELSE
  IF arg_Code=GPCST_NAME_JIKAN_1 THEN w_Res:= GPCST_CODE_JIKAN_1
  ELSE
  IF arg_Code=GPCST_NAME_JIKAN_2 THEN w_Res:= GPCST_CODE_JIKAN_2
  ELSE
  IF arg_Code=GPCST_NAME_JIKAN_3 THEN w_Res:= GPCST_CODE_JIKAN_3
  ELSE w_Res:= '';
  result:=w_Res;
end;

//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 RI実施フラグ
function func_PIND_Change_RI(
       arg_Code:string    //ｺｰﾄﾞ
       ):string;          //名称
var
   w_Res:string;
begin
  IF arg_Code=GPCST_CODE_RI_0 THEN w_Res:= GPCST_NAME_RI_0
  ELSE
  IF arg_Code=GPCST_CODE_RI_1 THEN w_Res:= GPCST_NAME_RI_1
  ELSE
  IF arg_Code=GPCST_NAME_RI_0 THEN w_Res:= GPCST_CODE_RI_0
  ELSE
  IF arg_Code=GPCST_NAME_RI_1 THEN w_Res:= GPCST_CODE_RI_1
  ELSE w_Res:= '';
  result:=w_Res;
end;
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 所見依頼フラグ
function func_PIND_Change_SYOKEN(
       arg_Code:string    //ｺｰﾄﾞ
       ):string;          //名称
var
   w_Res:string;
begin
  IF arg_Code=GPCST_CODE_SYOKEN_0 THEN w_Res:= GPCST_NAME_SYOKEN_0
  ELSE
  IF arg_Code=GPCST_CODE_SYOKEN_1 THEN w_Res:= GPCST_NAME_SYOKEN_1
  ELSE
  IF arg_Code=GPCST_NAME_SYOKEN_0 THEN w_Res:= GPCST_CODE_SYOKEN_0
  ELSE
  IF arg_Code=GPCST_NAME_SYOKEN_1 THEN w_Res:= GPCST_CODE_SYOKEN_1
  ELSE w_Res:= '';
  result:=w_Res;
end;
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 検査進捗  KENSIN
function func_PIND_Change_KENSIN(
       arg_Code:string;    //ｺｰﾄﾞ
       arg_SubCode:string    //ｺｰﾄﾞ
       ):string;          //名称
var
   w_Res:string;
begin
  //2001.09.13
  //'0'
  if arg_Code = GPCST_CODE_KENSIN_0 then begin
    //'未受付'
    if arg_SubCode = '' then
      w_Res := GPCST_NAME_KENSIN_0
    else if arg_SubCode = GPCST_CODE_KENSIN_SUB_5 then
      w_Res := GPCST_NAME_KENSIN_SUB_5
    else if arg_SubCode = GPCST_CODE_KENSIN_SUB_6 then
      w_Res := GPCST_NAME_KENSIN_SUB_6
  end
  //'1'
  else if arg_Code = GPCST_CODE_KENSIN_1 then begin
    //'未受付'
    if arg_SubCode = '' then
      w_Res := GPCST_NAME_KENSIN_1
    else if arg_SubCode = GPCST_CODE_KENSIN_SUB_7 then
      w_Res := GPCST_NAME_KENSIN_SUB_7;
  end
  //'2'
  else if arg_Code = GPCST_CODE_KENSIN_2 then begin
    //'検査中'
    if arg_SubCode = '' then
      w_Res := GPCST_NAME_KENSIN_2
    else if arg_SubCode = GPCST_CODE_KENSIN_SUB_8 then
      w_Res := GPCST_NAME_KENSIN_SUB_8
    else if arg_SubCode = GPCST_CODE_KENSIN_SUB_9 then
      w_Res := GPCST_NAME_KENSIN_SUB_9
    else if arg_SubCode = GPCST_CODE_KENSIN_SUB_10 then
      w_Res := GPCST_NAME_KENSIN_SUB_10;
  end
  //'3'
  else if arg_Code = GPCST_CODE_KENSIN_3 then begin
    //'検査済'
    w_Res := GPCST_NAME_KENSIN_3;
  end
  //'4'
  else if arg_Code = GPCST_CODE_KENSIN_4 then begin
    //'中止'
    w_Res := GPCST_NAME_KENSIN_4;
  end


  //'未受付'
  else if arg_Code = GPCST_NAME_KENSIN_0 then
    w_Res := GPCST_CODE_KENSIN_0
  else if arg_SubCode = GPCST_NAME_KENSIN_SUB_5 then
    w_Res := GPCST_CODE_KENSIN_SUB_5
  else if arg_SubCode = GPCST_NAME_KENSIN_SUB_6 then
    w_Res := GPCST_CODE_KENSIN_SUB_6
  //'受付済'
  else if arg_Code = GPCST_NAME_KENSIN_1 then
    w_Res := GPCST_CODE_KENSIN_1
  else if arg_SubCode = GPCST_NAME_KENSIN_SUB_7 then
    w_Res := GPCST_CODE_KENSIN_SUB_7
  //'検査中'
  else if arg_Code = GPCST_NAME_KENSIN_2 then
    //'2'
    w_Res := GPCST_CODE_KENSIN_2
  else if arg_SubCode = GPCST_NAME_KENSIN_SUB_8 then
    w_Res := GPCST_CODE_KENSIN_SUB_8
  else if arg_SubCode = GPCST_NAME_KENSIN_SUB_9 then
    w_Res := GPCST_CODE_KENSIN_SUB_9
  else if arg_SubCode = GPCST_NAME_KENSIN_SUB_10 then
    w_Res := GPCST_CODE_KENSIN_SUB_10
  //'検査済'
  else if arg_Code = GPCST_NAME_KENSIN_3 then begin
    //'3'
    w_Res := GPCST_CODE_KENSIN_3;
  end
  //'中止'
  else if arg_Code = GPCST_NAME_KENSIN_4 then begin
    //'4'
    w_Res := GPCST_CODE_KENSIN_4;
  end
  //それ以外
  else
    w_Res := '';
  //戻り値
  result:=w_Res;
end;
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 検査進捗  KENSIN
function func_PIND_Change_KENSIN_Ryaku(
       arg_Code:string    //ｺｰﾄﾞ
       ):string;          //名称
var
   w_Res:string;
begin
  //2001.09.13
  //'0'
  if arg_Code = GPCST_CODE_KENSIN_0 then
    //'未受付'
    w_Res := GPCST_RYAKU_NAME_KENSIN_0
  //'1'
  else if arg_Code = GPCST_CODE_KENSIN_1 then
    //'受付済'
    w_Res := GPCST_RYAKU_NAME_KENSIN_1
  //'2'
  else if arg_Code = GPCST_CODE_KENSIN_2 then
    //'検査中'
    w_Res := GPCST_RYAKU_NAME_KENSIN_2
  //'3'
  else if arg_Code = GPCST_CODE_KENSIN_3 then
    //'検査済'
    w_Res := GPCST_RYAKU_NAME_KENSIN_3
  //'4'
  else if arg_Code = GPCST_CODE_KENSIN_4 then
    //'中止'
    w_Res := GPCST_RYAKU_NAME_KENSIN_4
  //'未受付'
  else if arg_Code = GPCST_RYAKU_NAME_KENSIN_0 then
    //'0'
    w_Res := GPCST_CODE_KENSIN_0
  //'受付済'
  else if arg_Code = GPCST_RYAKU_NAME_KENSIN_1 then
    //'1'
    w_Res := GPCST_CODE_KENSIN_1
  //'検査中'
  else if arg_Code = GPCST_RYAKU_NAME_KENSIN_2 then
    //'2'
    w_Res := GPCST_CODE_KENSIN_2
  //'検査済'
  else if arg_Code = GPCST_RYAKU_NAME_KENSIN_3 then
    //'3'
    w_Res := GPCST_CODE_KENSIN_3
  //'中止'
  else if arg_Code = GPCST_RYAKU_NAME_KENSIN_4 then
    //'4'
    w_Res := GPCST_CODE_KENSIN_4
  //それ以外
  else
    w_Res := '';
  //戻り値
  result:=w_Res;
end;

//●機能（例外無）：ｺｰﾄﾞを名前に変換登録システム区分
function func_PIND_Change_SYSK(
       arg_Code:string    //ｺｰﾄﾞ
       ):string;          //名称
var
   w_Res:string;
begin
  IF arg_Code=GPCST_CODE_SYSK_RIS THEN w_Res:= GPCST_NAME_SYSK_RIS
  ELSE
  IF arg_Code=GPCST_CODE_SYSK_HIS THEN w_Res:= GPCST_NAME_SYSK_HIS
  ELSE
  IF arg_Code=GPCST_NAME_SYSK_RIS THEN w_Res:= GPCST_CODE_SYSK_RIS
  ELSE
  IF arg_Code=GPCST_NAME_SYSK_HIS THEN w_Res:= GPCST_CODE_SYSK_HIS
  ELSE w_Res:= '';
  result:=w_Res;
end;
//●機能（例外無）：ｺｰﾄﾞを名前に変換 性
function func_PIND_Change_Sex(
       arg_Code:string    //ｺｰﾄﾞ
       ):string;          //名称
var
   w_Res:string;
begin
  IF arg_Code=GPCST_SEX_1 THEN w_Res:= GPCST_SEX_1_NAME
  ELSE
  IF arg_Code=GPCST_SEX_2 THEN w_Res:= GPCST_SEX_2_NAME
  ELSE
  IF arg_Code=GPCST_SEX_1_NAME THEN w_Res:= GPCST_SEX_1
  ELSE
  IF arg_Code=GPCST_SEX_2_NAME THEN w_Res:= GPCST_SEX_2
  ELSE w_Res:= '';
  result:=w_Res;
end;
//●機能（例外無）：ｺｰﾄﾞを名前に変換 入外区分
function func_PIND_Change_Nyugai(
       arg_Code:string    //ｺｰﾄﾞ
       ):string;          //名称
var
   w_Res:string;
begin
  IF arg_Code=GPCST_NYUGAIKBN_1 THEN w_Res:= GPCST_NYUGAIKBN_1_NAME
  ELSE
  IF arg_Code=GPCST_NYUGAIKBN_2 THEN w_Res:= GPCST_NYUGAIKBN_2_NAME
  ELSE
  IF arg_Code=GPCST_NYUGAIKBN_1_NAME THEN w_Res:= GPCST_NYUGAIKBN_1
  ELSE
  IF arg_Code=GPCST_NYUGAIKBN_2_NAME THEN w_Res:= GPCST_NYUGAIKBN_2
  ELSE w_Res:= '';

  result:=w_Res;
end;
//名称コード変換処理↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
//↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑

//表形式ｺﾝﾄﾛｰﾙのファイル出力処理－－－－－－－－－－－－－－－－－－－－－－－－

//●機能（例外有）：StringGridの内容をcsvに保存
procedure proc_StringGridToFile(
       arg_FName:string;          //保存ファイル名
       arg_StringGrid:TStringGrid //対象
       );
var
    w_Rowcount  : integer;
    w_Colcount  : integer;
    w_CSVFile   : TextFile;
    w_string    : string;

begin
    //--- 新規ﾌｧｲﾙを作成し開く(CSV) ---
    AssignFile(w_CSVFile,arg_FName);
    if FileExists(arg_FName) then
    begin
        if DeleteFile(arg_FName) then
        begin
          Rewrite(w_CSVFile);
        end
        else
        begin
          raise T_ESysExcep.Create(
            '場所：リストのファイル保存中。' + #13#10 +
            '原因：ファイルを削除できません。' + #13#10 +
            '対処：ファイルの共有等を解除して下さい。'
                              );
          exit;
        end;
    end
    else
    begin
        Rewrite(w_CSVFile);
    end;
    try
     //CSV書き込み
     //列名
     w_string := '';
     for w_Colcount:=0 to arg_StringGrid.ColCount-1 do
     begin
       if w_Colcount > 0 then  w_string :=  w_string + ',';
       w_string := w_string + '"' + arg_StringGrid.Cells[w_Colcount, 0] + '"' ;
     end;
     Writeln(w_CSVFile,w_string);        //ﾃﾞｰﾀｾｯﾄ
     //内容
     for w_Rowcount:=2 to arg_StringGrid.RowCount-1 do
     begin
        w_string := '';
        for w_Colcount:=0 to arg_StringGrid.ColCount-1 do
        begin
          if w_Colcount > 0 then  w_string :=  w_string + ',';
          w_string := w_string + '"' + arg_StringGrid.Cells[w_Colcount, w_Rowcount] + '"';
        end;
        Writeln(w_CSVFile,w_string);        //ﾃﾞｰﾀｾｯﾄ
     end;
     Flush(w_CSVFile);
     CloseFile(w_CSVFile);                    //CSVﾌｧｲﾙｸﾛｰｽﾞ
    except
        CloseFile(w_CSVFile);                //CSVﾌｧｲﾙｸﾛｰｽﾞ
        raise;
    end;//except
end;

//●機能（例外有）：StringGridの内容をcsvに保存
//                  非表示カラムは保存しない
procedure proc_StringGridToFile2(
       arg_FName:string;          //保存ファイル名
       arg_StringGrid:TStringGrid //対象
       );
var
    w_Rowcount  : integer;
    w_Colcount  : integer;
    w_CSVFile   : TextFile;
    w_string    : string;

begin
    //--- 新規ﾌｧｲﾙを作成し開く(CSV) ---
    AssignFile(w_CSVFile,arg_FName);
    if FileExists(arg_FName) then
    begin
        if DeleteFile(arg_FName) then
        begin
          Rewrite(w_CSVFile);
        end
        else
        begin
          raise T_ESysExcep.Create(
            '場所：リストのファイル保存中。' + #13#10 +
            '原因：ファイルを削除できません。' + #13#10 +
            '対処：ファイルの共有等を解除して下さい。'
                              );
          exit;
        end;
    end
    else
    begin
        Rewrite(w_CSVFile);
    end;
    try
     //CSV書き込み
     //列名
     w_string := '';
     for w_Colcount:=0 to arg_StringGrid.ColCount-1 do
     begin
       if arg_StringGrid.ColWidths[w_Colcount] > 0 then begin
         if w_Colcount > 0 then  w_string :=  w_string + ',';
         w_string := w_string + '"' + arg_StringGrid.Cells[w_Colcount, 0] + '"' ;
       end;
     end;
     Writeln(w_CSVFile,w_string);        //ﾃﾞｰﾀｾｯﾄ
     //内容
     for w_Rowcount:=2 to arg_StringGrid.RowCount-1 do
     begin
        w_string := '';
        for w_Colcount:=0 to arg_StringGrid.ColCount-1 do
        begin
          if arg_StringGrid.ColWidths[w_Colcount] > 0 then begin
            if w_Colcount > 0 then  w_string :=  w_string + ',';
            w_string := w_string + '"' + arg_StringGrid.Cells[w_Colcount, w_Rowcount] + '"';
          end;
        end;
        Writeln(w_CSVFile,w_string);        //ﾃﾞｰﾀｾｯﾄ
     end;
     Flush(w_CSVFile);
     CloseFile(w_CSVFile);                    //CSVﾌｧｲﾙｸﾛｰｽﾞ
    except
        CloseFile(w_CSVFile);                //CSVﾌｧｲﾙｸﾛｰｽﾞ
        raise;
    end;//except
end;

//●機能（例外有）：ListViewの内容を作成
procedure proc_ListViewToFile(
       arg_FName:string;      //保存ファイル名
       arg_ListView:TListView //対象
       );
var
    w_Rowcount  : integer;
    w_Colcount  : integer;
    w_CSVFile   : TextFile;
    w_string    : string;

begin
    //--- 新規ﾌｧｲﾙを作成し開く(CSV) ---
    AssignFile(w_CSVFile,arg_FName);
    if FileExists(arg_FName) then
    begin
        if DeleteFile(arg_FName) then
        begin
          Rewrite(w_CSVFile);
        end
        else
        begin
          raise T_ESysExcep.Create(
            '場所：リストのファイル保存中。' + #13#10 +
            '原因：ファイルを削除できません。' + #13#10 +
            '対処：ファイルの共有等を解除して下さい。'
                              );
          exit;
        end;
    end
    else
    begin
        Rewrite(w_CSVFile);
    end;
    try
     //CSV書き込み
     //列名
     for w_Colcount:=0 to  arg_ListView.Columns.Count-1 do
     begin
       if w_Colcount > 0 then  w_string :=  w_string + ',';
       w_string := w_string + '"' + arg_ListView.Columns[w_Colcount].Caption + '"' ;
     end;
     Writeln(w_CSVFile,w_string);        //ﾃﾞｰﾀｾｯﾄ
     //内容
     for w_Rowcount:=0 to  arg_ListView.Items.Count-1 do
     begin
        w_string := '"' +arg_ListView.Items[w_Rowcount].caption + '"';
        for w_Colcount:=0 to  arg_ListView.Items[w_Rowcount].SubItems.Count-1 do
        begin
          w_string := w_string + ',';
          w_string := w_string + '"' + arg_ListView.Items[w_Rowcount].SubItems[w_Colcount] + '"';
        end;
        Writeln(w_CSVFile,w_string);        //ﾃﾞｰﾀｾｯﾄ
     end;
     Flush(w_CSVFile);
     CloseFile(w_CSVFile);                    //CSVﾌｧｲﾙｸﾛｰｽﾞ
    except
        CloseFile(w_CSVFile);                //CSVﾌｧｲﾙｸﾛｰｽﾞ
        raise;
    end;//except
end;

//表形式ｺﾝﾄﾛｰﾙのファイル出力処理↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
//↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑

//ＳＱＬの一般処理処理－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
//●機能（例外無）：DateのBetween句を作成
function func_DateBetween(
       arg_FName:string;   //項目名
       arg_Date1:TDate;    //初め
       arg_Date2:TDate     //終り
       ):string;
var
   w_Res:string;
begin

  w_Res := ' To_Char(' + arg_FName + ',''yyyymmdd'') ';
  w_Res := w_Res + ' between ';
  w_Res := w_Res + '''' + FormatDateTime('yyyymmdd',arg_Date1) + '''' ;
  w_Res := w_Res + ' and ' ;
  w_Res := w_Res + '''' + FormatDateTime('yyyymmdd',arg_Date2) + '''' ;
  result:=w_Res;

end;

//●機能（例外有）：SQLの結果のレコード数を返す
function func_SqlCount(
       arg_DB:TDatabase;
       arg_Sql:Tstrings):Integer;
var
  w_Qry:TQuery;
begin
  w_Qry:=TQuery.Create(nil);
  try
    w_Qry.Close;
    w_Qry.DatabaseName :=arg_DB.DatabaseName;
    w_Qry.SQL.AddStrings(arg_Sql);
    w_Qry.Open;
    w_Qry.Last;
    result:=w_Qry.RecordCount;
    w_Qry.Close;
  finally
    w_Qry.Free;
  end;
end;

//●機能（例外有）：SQLの実行結果を返す
{$HINTS OFF}
function func_SqlExec(
       arg_DB:TDatabase;          //接続されたDB
       arg_Sql:Tstrings):boolean; //有効なSQL
var
  w_Qry:TQuery;
begin
  w_Qry:=TQuery.Create(nil);
  result:=False;
  try
    w_Qry.Close;
    w_Qry.DatabaseName :=arg_DB.DatabaseName;
    w_Qry.SQL.Clear;
    w_Qry.SQL.AddStrings(arg_Sql);
    try
      w_Qry.ExecSQL;
      result:=True;
    except
      result:=False;
      raise;
    end;
  finally
    w_Qry.Free;
  end;
end;
{$HINTS ON}
//表形式ｺﾝﾄﾛｰﾙのファイル出力処理↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
//↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑

//管理テーブル処理－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
//●機能（例外有）：KANRIテーブルの権利全削除
{$HINTS OFF}
function func_DelKAnri(
       arg_DB:TDatabase;         //接続されたDB
       arg_TanName:string       //PC名称
       ):boolean;                //結果True成功 False失敗
var
   w_ExecSql:string;
   w_Strings:TStrings;
   res:integer;
   rtn:boolean;
begin
//１．初期値等設定
  result := false;
//２．権利取得
//２．１トランザクション獲得
  arg_DB.StartTransaction;
//２．２状態問合わせ
  try
    //当該端末のすべてを削除
    w_ExecSql:= 'Delete ';
    w_ExecSql:= w_ExecSql + ' from  '+ CST_TBL_KANRI +' ';
    w_ExecSql:= w_ExecSql + ' where ';
    w_ExecSql:= w_ExecSql + '       ( ' + CST_TBLIN_TAN_NAME + '   = ''' + arg_TanName + ''')';
    w_Strings:= func_StrToTStrList('');
    try
      w_Strings.Add(w_ExecSql);
      rtn := func_SqlExec(arg_DB,w_Strings);
      if rtn then
      begin
        arg_DB.Commit;
        result:=True;
      end
      else
      begin
        arg_DB.Rollback;
        result:=false;
      end;
    finally
      w_Strings.Free;
    end;
    exit;
  except
    arg_DB.Rollback;
    result:=false;
    raise;
    exit;
  end;
end;
{$HINTS ON}
//●機能（例外有）：KANRIテーブルの権利返還
{$HINTS OFF}
function func_ReleasKAnri(
       arg_DB:TDatabase;         //接続されたDB
       arg_TanName:string;       //PC名称
       arg_ProgId:string;        //プログラムID
       arg_RisId:string;         //RIS識別ID
       arg_SyoriMode:string      //返還権利種 G_KANRI_TBL_RMODE 参照権利
                                 //           G_KANRI_TBL_WMODE 更新権利
       ):boolean;                //結果True成功 False失敗
var
   w_ExecSql:string;
   w_Strings:TStrings;
   res:integer;
   rtn:boolean;
begin
//１．初期値等設定
  result := false;
//２．権利取得
//２．１トランザクション獲得
  arg_DB.StartTransaction;
//２．２状態問合わせ
  try
    w_ExecSql:= 'Delete ';
    w_ExecSql:= w_ExecSql + ' from  '+ CST_TBL_KANRI +' ';
    w_ExecSql:= w_ExecSql + ' where ';
    w_ExecSql:= w_ExecSql + '       ( ' + CST_TBLIN_SYORIMODE + ' = ' + arg_SyoriMode  + ')';
    w_ExecSql:= w_ExecSql + '   and ';
    w_ExecSql:= w_ExecSql + '       ( ' + CST_TBLIN_RISID + '     = ''' + arg_RisId + ''')';
    w_ExecSql:= w_ExecSql + '   and ';
    w_ExecSql:= w_ExecSql + '       ( ' + CST_TBLIN_PRODID + '    = ''' + arg_ProgId  + ''')';
    w_ExecSql:= w_ExecSql + '   and ';
    w_ExecSql:= w_ExecSql + '       ( ' + CST_TBLIN_TAN_NAME + '  = ''' + arg_TanName + ''')';
    w_Strings:= func_StrToTStrList('');
    try
      w_Strings.Add(w_ExecSql);
      rtn := func_SqlExec(arg_DB,w_Strings);
      if rtn then
      begin
        arg_DB.Commit;
        result:=True;
      end
      else
      begin
        arg_DB.Rollback;
        result:=false;
      end;
    finally
      w_Strings.Free;
    end;
    exit;
  except
    arg_DB.Rollback;
    result:=false;
    raise;
    exit;
  end;
end;
{$HINTS ON}

//●機能（例外有）：KANRIテーブルの参照権利取得
{$HINTS OFF}
function func_GetRKAnri(
       arg_DB:TDatabase;         //接続されたDB
       arg_TanName:string;       //PC名称
       arg_ProgId:string;        //プログラムID
       arg_RisId:string          //RIS識別ID
       ):boolean;                //結果True成功 False失敗
var
   w_SelectSql:string;
   w_ExecSql:string;
   w_Strings:TStrings;
   res:integer;
   rtn:boolean;
begin
//１．初期値等設定
  result := false;
//２．権利取得
//２．１トランザクション獲得
  arg_DB.StartTransaction;
//２．２状態問合わせ
  try
    //状態遷移条件 すべて
    w_SelectSql:= 'select * ';
    w_SelectSql:= w_SelectSql + ' from  '+ CST_TBL_KANRI +' ';
    w_SelectSql:= w_SelectSql + ' where ';
    w_SelectSql:= w_SelectSql + '       ( ' + CST_TBLIN_SYORIMODE + ' = ' + G_KANRI_TBL_RMODE  + ')';
    w_SelectSql:= w_SelectSql + '   and ';
    w_SelectSql:= w_SelectSql + '       ( ' + CST_TBLIN_RISID   + '   = '''   + arg_RisId + ''')';
    w_SelectSql:= w_SelectSql + '   and ';
    w_SelectSql:= w_SelectSql + '       ( ' + CST_TBLIN_PRODID    + ' = '''   + arg_ProgId + ''')';
    w_SelectSql:= w_SelectSql + '   and ';
    w_SelectSql:= w_SelectSql + '       ( ' + CST_TBLIN_TAN_NAME  + ' = '''   + arg_TanName + ''')';

    w_Strings:= func_StrToTStrList('');
    try
      w_Strings.Add(w_SelectSql);
      res:=func_SqlCount(arg_DB,w_Strings);
      if res=0 then
      begin
//２．３権利取得
// なければ権利取得宣言
        w_ExecSql:= 'insert into '+ CST_TBL_KANRI +' (';
        w_ExecSql:= w_ExecSql + ' ' + CST_TBLIN_TAN_NAME  + ', ';
        w_ExecSql:= w_ExecSql + ' ' + CST_TBLIN_PRODID    + ', ';
        w_ExecSql:= w_ExecSql + ' ' + CST_TBLIN_RISID     + ', ';
        w_ExecSql:= w_ExecSql + ' ' + CST_TBLIN_SYORIMODE + ' ';
        w_ExecSql:= w_ExecSql + ' ) values (';
        w_ExecSql:= w_ExecSql + '''' + arg_TanName       + ''',';
        w_ExecSql:= w_ExecSql + '''' + arg_ProgId        + ''',';
        w_ExecSql:= w_ExecSql + '''' + arg_RisId         + ''',';
        w_ExecSql:= w_ExecSql + ''   + G_KANRI_TBL_RMODE +')';
        w_Strings.Clear;
        w_Strings.Add(w_ExecSql);
        rtn := func_SqlExec(arg_DB,w_Strings);
        if rtn then
        begin
          arg_DB.Commit;
          result:=True;
        end
        else
        begin
          arg_DB.Rollback;
          result:=false;
        end;
      end
      else
      begin
//２．４権利取得できない(参照取得は他で使用中でもOK)
//参照情報を常に残す時はUpdate文でカウントをアップする処理となる
//更新側でこれをみれば参照中かの判別はつく
          arg_DB.Rollback;
          result:=True;
      end;
    finally
      w_Strings.Free;
    end;
    exit;
  except
    arg_DB.Rollback;
    result:=false;
    raise;
    exit;
  end;
end;
{$HINTS ON}

//●機能（例外有）：KANRIテーブルの更新権利取得
{$HINTS OFF}
function func_GetWKAnri(
       arg_DB:TDatabase;         //接続されたDB
       arg_TanName:string;       //PC名称
       arg_ProgId:string;        //プログラムID
       arg_RisId:string          //RIS識別ID
       ):boolean;                //結果True成功 False失敗
var
   w_SelectSql:string;
   w_ExecSql:string;
   w_Strings:TStrings;
   res:integer;
   rtn:boolean;
begin
//１．初期値等設定
  result := false;
//２．権利取得
//２．１トランザクション獲得
  arg_DB.StartTransaction;
//２．２状態問合わせ
  try
    //状態遷移条件 arg_OrderId arg_OrderId arg_KensaDate の不存在
    //更新モードのものがいないときで参照はOK
    w_SelectSql:= 'select * ';
    w_SelectSql:= w_SelectSql + ' from  '+ CST_TBL_KANRI +' ';
    w_SelectSql:= w_SelectSql + ' where ';
    w_SelectSql:= w_SelectSql + '       ( ' + CST_TBLIN_SYORIMODE + '    = ' + G_KANRI_TBL_WMODE  + ')';
    w_SelectSql:= w_SelectSql + '   and ';
    w_SelectSql:= w_SelectSql + '       ( ' + CST_TBLIN_RISID + '   = '''   + arg_RisId + ''')';

    w_Strings:= func_StrToTStrList('');
    try
      w_Strings.Add(w_SelectSql);
      res:=func_SqlCount(arg_DB,w_Strings);
      if res=0 then
      begin
//２．３権利取得
        w_ExecSql:= 'insert into '+ CST_TBL_KANRI +' (';
        w_ExecSql:= w_ExecSql + ' ' + CST_TBLIN_TAN_NAME  + ', ';
        w_ExecSql:= w_ExecSql + ' ' + CST_TBLIN_PRODID    + ', ';
        w_ExecSql:= w_ExecSql + ' ' + CST_TBLIN_RISID     + ', ';
        w_ExecSql:= w_ExecSql + ' ' + CST_TBLIN_SYORIMODE + ' ';
        w_ExecSql:= w_ExecSql + ' ) values (';
        w_ExecSql:= w_ExecSql + '''' + arg_TanName       + ''',';
        w_ExecSql:= w_ExecSql + '''' + arg_ProgId        + ''',';
        w_ExecSql:= w_ExecSql + '''' + arg_RisId         + ''',';
        w_ExecSql:= w_ExecSql + ''   + G_KANRI_TBL_WMODE + ')';
        w_Strings.Clear;
        w_Strings.Add(w_ExecSql);
        rtn := func_SqlExec(arg_DB,w_Strings);
        if rtn then
        begin
          arg_DB.Commit;
          result:=True;
        end
        else
        begin
          arg_DB.Rollback;
          result:=false;
        end;
      end
      else
      begin
//２．４権利取得できない(他で使用中)
          arg_DB.Rollback;
          result:=false;
      end;
    finally
      w_Strings.Free;
    end;
    exit;
  except
    arg_DB.Rollback;
    result:=false;
    raise;
    exit;
  end;
end;
{$HINTS ON}
//●機能（例外有）：KANRIテーブルの更新権利取得
{$HINTS OFF}
function func_GetWKAnriUketuke(
       arg_DB:TDatabase;         //接続されたDB
       arg_TanName:string;       //PC名称
       arg_ProgId:string;        //プログラムID
       arg_RisId:string          //RIS識別ID
       ):boolean;                //結果True成功 False失敗
var
   w_SelectSql:string;
   w_ExecSql:string;
   w_Strings:TStrings;
   res:integer;
   rtn:boolean;
begin
//１．初期値等設定
  result := false;
//２．権利取得
{
//２．１トランザクション獲得
  arg_DB.StartTransaction;
}
//２．２状態問合わせ
  try
    //状態遷移条件 arg_OrderId arg_OrderId arg_KensaDate の不存在
    //更新モードのものがいないときで参照はOK
    w_SelectSql:= 'select * ';
    w_SelectSql:= w_SelectSql + ' from  '+ CST_TBL_KANRI +' ';
    w_SelectSql:= w_SelectSql + ' where ';
    w_SelectSql:= w_SelectSql + '       ( ' + CST_TBLIN_SYORIMODE + '    = ' + G_KANRI_TBL_WMODE  + ')';
    w_SelectSql:= w_SelectSql + '   and ';
    w_SelectSql:= w_SelectSql + '       ( ' + CST_TBLIN_RISID + '   = '''   + arg_RisId + ''')';

    w_Strings:= func_StrToTStrList('');
    try
      w_Strings.Add(w_SelectSql);
      res:=func_SqlCount(arg_DB,w_Strings);
      if res=0 then begin
//２．３権利取得
        w_ExecSql:= 'insert into '+ CST_TBL_KANRI +' (';
        w_ExecSql:= w_ExecSql + ' ' + CST_TBLIN_TAN_NAME  + ', ';
        w_ExecSql:= w_ExecSql + ' ' + CST_TBLIN_PRODID    + ', ';
        w_ExecSql:= w_ExecSql + ' ' + CST_TBLIN_RISID     + ', ';
        w_ExecSql:= w_ExecSql + ' ' + CST_TBLIN_SYORIMODE + ' ';
        w_ExecSql:= w_ExecSql + ' ) values (';
        w_ExecSql:= w_ExecSql + '''' + arg_TanName       + ''',';
        w_ExecSql:= w_ExecSql + '''' + arg_ProgId        + ''',';
        w_ExecSql:= w_ExecSql + '''' + arg_RisId         + ''',';
        w_ExecSql:= w_ExecSql + ''   + G_KANRI_TBL_WMODE + ')';
        w_Strings.Clear;
        w_Strings.Add(w_ExecSql);
        rtn := func_SqlExec(arg_DB,w_Strings);
        if rtn then begin
//          arg_DB.Commit;
          result:=True;
        end
        else begin
//          arg_DB.Rollback;
          result:=false;
        end;
      end
      else begin
//２．４権利取得できない(他で使用中)
//          arg_DB.Rollback;
          result:=false;
      end;
    finally
      w_Strings.Free;
    end;
    exit;
  except
//    arg_DB.Rollback;
    result:=false;
    raise;
    exit;
  end;
end;

//管理テーブル処理
//↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑


//使用可能関数↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
//↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
//↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
//↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
//↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
//↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
//↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑

//●機能（例外有）：NameMSの特定区分をコンボに設定（コンボクリアする）
procedure proc_NameMSToComb(
   arg_Qry:TQuery;
   arg_KBN:string;
   arg_Comb: TComboBox
   );
begin
  arg_Comb.Items.clear;
  proc_NameMSToComb1(
                arg_Qry,
                arg_KBN,
                arg_Comb);
end;

//●機能（例外有）：NameMSの特定区分をコンボに設定（コンボクリアしない）
procedure proc_NameMSToComb1(
   arg_Qry:TQuery;
   arg_KBN:string;
   arg_Comb: TComboBox
   );
begin
  arg_Qry.Close;
  arg_Qry.SQL.clear;
  arg_Qry.SQL.Add('select ');
  arg_Qry.SQL.Add('    kbn, ');
  arg_Qry.SQL.Add('    name ');
  arg_Qry.SQL.Add('  from ');
  arg_Qry.SQL.Add('    namems ');
  arg_Qry.SQL.Add('  where ');
  arg_Qry.SQL.Add('    kbn = ''' + arg_KBN + '''' );
  arg_Qry.SQL.Add('  order by ');
  arg_Qry.SQL.Add('    output_seq ');
  arg_Qry.Open;
  try
    arg_Qry.First;
    while not(arg_Qry.Eof)  do
    begin
      arg_Comb.Items.Add( arg_Qry.FieldByName('name').AsString);
      arg_Qry.Next
    end;
    arg_Comb.ItemIndex := -1;
  finally
    arg_Qry.Close;
  end;
end;


//ユーザ名確認－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
//●機能（例外有）：USERMSのUser_nameを確認
function func_ChkUserName(
       arg_DB:TDatabase;
       arg_UserName:string
       ):boolean;
var
   w_Str:string;
   w_Strings:TStrings;
   res:integer;
begin
  result := false;
  w_Str  := 'select user_name from userms ';
  w_Str  := w_Str + 'where user_name= '''+ arg_UserName+ '''';

  w_Strings:= func_StrToTStrList('');
  try
    w_Strings.Add(w_Str);
    res:=func_SqlCount(arg_DB,w_Strings);

    if res>0 then result:=true;

  finally
    w_Strings.Free;
  end;
  exit;
end;
//●機能（例外有）：USERMSのUser_nameとPASSWORDを確認
function func_ChkUserPass(
       arg_DB:TDatabase;
       arg_UserName:string;
       arg_Password:string
       ):boolean;
var
   w_Str:string;
   w_Strings:TStrings;
   res:integer;
begin
  result := false;
  w_Str  := 'select user_name from userms ';
  w_Str  := w_Str + 'where ';
  w_Str  := w_Str + '      user_name = '''+ arg_UserName+ '''';
  w_Str  := w_Str + ' and ';
  w_Str  := w_Str + '      password  = '''+ arg_Password+ '''';

  w_Strings:= func_StrToTStrList('');
  try
    w_Strings.Add(w_Str);
    res:=func_SqlCount(arg_DB,w_Strings);

    if res>0 then result:=true;

  finally
    w_Strings.Free;
  end;
  exit;
end;

//●機能（例外有）：USERMSのUser_nameとclassを確認
function func_ChkUserClass(
       arg_DB:TDatabase;         //接続されたDB
       arg_UserName:string;      //ユーザ名
       arg_Class:string          //クラス
       ):boolean;
var
   w_Str:string;
   w_Strings:TStrings;
   res:integer;
begin
  result := false;
  w_Str  := 'select user_name from userms ';
  w_Str  := w_Str + 'where (user_name = '''+ arg_UserName + ''')';
  w_Str  := w_Str + '  and (class     = '+ arg_Class    + ')';

  w_Strings:= func_StrToTStrList('');
  try
    w_Strings.ADD(w_Str);
    res:=func_SqlCount(arg_DB,w_Strings);

    if res>0 then result:=true;

  finally
    w_Strings.Free;
  end;
  exit;
end;
//ユーザ名確認処理↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑

//●機能（例外無）：ワークリスト予約テーブル用キー項目編集
function func_WorklistInfo_Key_Make(
         //IN
         arg_KanjaID: string;
         arg_OrderNO: string;
         //OUT
         var arg_Rcv_ACCESSION_NUMBER: string;
         var arg_Rcv_PATIENT_ID: string
        ): Boolean;
begin
  Result := True;
//ワークリスト予約テーブルキー項目編集

//17.受付番号
  //患者ID＋オーダNO
  //...'-'をとる 2001.02.15
  arg_Rcv_ACCESSION_NUMBER := Trim(StringReplace(arg_KanjaID,'-','',[rfReplaceAll]))
                            + arg_OrderNO;
//23.患者ID
  //
  arg_Rcv_PATIENT_ID := arg_KanjaID;
end;
//ワークリスト予約テーブル用キー項目編集↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑

//●機能（例外無）：ワークリスト予約テーブル用全項目編集
function func_WorklistInfo_Make(
         //IN
         arg_Query: TQuery;
         arg_Group_No: string;
         arg_SysDate: string;
         arg_SysTime: string;
         arg_KanjaID: string;
         arg_OrderNO: string;
         arg_SimeiKana: string;
         arg_SimeiKanji: string;
         arg_Sex: string;
         arg_BirthDay: string;
         arg_Start_Date: string;
         arg_Start_Time: string;
         arg_Irai_Doctor_Name: string;
         arg_Irai_Section_Name: string;
         arg_Irai_Section_Kana: string;
         arg_KensaKikiName: string;
         arg_Modality_Type: string;
         arg_KensaComment1: string;
         arg_SUID: string;
         //OUT
         var arg_Rcv_SCH_STATION_AE_TITLE: string;
         var arg_Rcv_SCH_PROC_STEP_LOCATION: string;
         var arg_Rcv_SCH_PROC_STEP_START_DATE: string;
         var arg_Rcv_SCH_PROC_STEP_START_TIME: string;
         var arg_Rcv_SCH_PERF_PHYSICIANS_NAME_ROMA: string;
         var arg_Rcv_SCH_PERF_PHYSICIANS_NAME_KANJI: string;
         var arg_Rcv_SCH_PERF_PHYSICIANS_NAME_KANA: string;
         var arg_Rcv_SCH_PROC_STEP_DESCRIPTION: string;
         var arg_Rcv_SCH_PROC_STEP_ID: string;
         var arg_Rcv_COMMENTS_ON_THE_SCH_PROC_STEP: string;
         var arg_Rcv_MODALITY: string;
         var arg_Rcv_REQ_PROC_ID: string;
         var arg_Rcv_STUDY_INSTANCE_UID: string;
         var arg_Rcv_REQ_PROC_DESCRIPTION: string;
         var arg_Rcv_REQUESTING_PHYSICIAN: string;
         var arg_Rcv_REQUESTING_SERVICE: string;
         var arg_Rcv_ACCESSION_NUMBER: string;
         var arg_Rcv_INSTITUTION: string;
         var arg_Rcv_INSTITUTION_ADDRESS: string;
         var arg_Rcv_PATIENT_NAME_ROMA: string;
         var arg_Rcv_PATIENT_NAME_KANJI: string;
         var arg_Rcv_PATIENT_NAME_KANA: string;
         var arg_Rcv_PATIENT_ID: string;
         var arg_Rcv_PATIENT_BIRTH_DATE: string;
         var arg_Rcv_PATIENT_SEX: string;
         var arg_Rcv_PATIENT_WEIGHT: string
        ): Boolean;
begin
  Result := True;
//ワークリスト予約テーブル全項目編集

//1.予約済ｽﾃｰｼｮﾝAE名称
  //...検査機器名称
  //...なし 2001.02.15
  arg_Rcv_SCH_STATION_AE_TITLE := '';//arg_KensaKikiName;
//2.予約済手続きｽﾃｯﾌﾟ場所
  //...検査機器名称(予約のないものは1.予約済ｽﾃｰｼｮﾝAE名称に同じ)
  if arg_KensaKikiName <> '' then begin
    arg_Rcv_SCH_PROC_STEP_LOCATION := arg_KensaKikiName;
  end else begin
    arg_Rcv_SCH_PROC_STEP_LOCATION := arg_Rcv_SCH_STATION_AE_TITLE;
  end;
//3.予約済手続きｽﾃｯﾌﾟ開始日付
  //...DATE型
  arg_Rcv_SCH_PROC_STEP_START_DATE := '';
  if Length(Trim(arg_Start_Date)) = 10 then begin
    arg_Rcv_SCH_PROC_STEP_START_DATE := Trim(arg_Start_Date);
  end else begin
    arg_Rcv_SCH_PROC_STEP_START_DATE := func_Date8To10(Trim(arg_Start_Date));
  end;
//4.予約済手続きｽﾃｯﾌﾟ開始時刻
  //...DATE型(開始日付＋開始時刻)
  arg_Rcv_SCH_PROC_STEP_START_TIME := '';
  if Length(Trim(arg_Start_Time)) = 8 then begin
    arg_Rcv_SCH_PROC_STEP_START_TIME := arg_Rcv_SCH_PROC_STEP_START_DATE
                                      + ' '
                                      + Trim(arg_Start_Time);
  end else begin
    arg_Rcv_SCH_PROC_STEP_START_TIME := arg_Rcv_SCH_PROC_STEP_START_DATE
                                      + ' '
                                      + func_Time6To8(Trim(arg_Start_Time));
  end;
//5.予約された実行医師名(ROMA)
  //...固定(INIマスタより取得)
  arg_Rcv_SCH_PERF_PHYSICIANS_NAME_ROMA := func_Get_WinMaster_DATA(arg_Group_No,g_WORKLIST_INFO,g_WORKLIST_I_ROMA);
//6.予約された実行医師名(漢字)
  //...固定(INIマスタより取得)
  arg_Rcv_SCH_PERF_PHYSICIANS_NAME_KANJI := func_Get_WinMaster_DATA(arg_Group_No,g_WORKLIST_INFO,g_WORKLIST_I_KANJI);
  arg_Rcv_SCH_PERF_PHYSICIANS_NAME_KANJI := Trim(StringReplace(arg_Rcv_SCH_PERF_PHYSICIANS_NAME_KANJI, ' ', '　', [rfReplaceAll]));
//7.予約された実行医師名(カナ)
  //...固定(INIマスタより取得)
  arg_Rcv_SCH_PERF_PHYSICIANS_NAME_KANA := func_Get_WinMaster_DATA(arg_Group_No,g_WORKLIST_INFO,g_WORKLIST_I_KANA);
  arg_Rcv_SCH_PERF_PHYSICIANS_NAME_KANA := HanToZen(arg_Rcv_SCH_PERF_PHYSICIANS_NAME_KANA);
  arg_Rcv_SCH_PERF_PHYSICIANS_NAME_KANA := StringReplace(arg_Rcv_SCH_PERF_PHYSICIANS_NAME_KANA, ' ', '　', [rfReplaceAll]);
//8.予約済手続きｽﾃｯﾌﾟ記述
  //...なし
  arg_Rcv_SCH_PROC_STEP_DESCRIPTION := '';
//9.予約済手続きｽﾃｯﾌﾟID
  //...17.受付番号に同じ(患者ID＋オーダNO)
  //...'-'をとる 2001.02.15
  arg_Rcv_SCH_PROC_STEP_ID := Trim(StringReplace(arg_KanjaID,'-','',[rfReplaceAll]))
                            + arg_OrderNO;
//10.予約済手続きｽﾃｯﾌﾟコメント
  //...検査コメント
  arg_Rcv_COMMENTS_ON_THE_SCH_PROC_STEP := Trim(arg_KensaComment1);
//11.モダリティ
  //...依頼区分モダリティタイプ
  arg_Rcv_MODALITY := arg_Modality_Type;
//12.依頼済手続きID
  //...17.受付番号に同じ(患者ID＋オーダNO)
  //...'-'をとる 2001.02.15
  arg_Rcv_REQ_PROC_ID := Trim(StringReplace(arg_KanjaID,'-','',[rfReplaceAll]))
                       + arg_OrderNO;
//13.検査インスタンスUID
  arg_Rcv_STUDY_INSTANCE_UID := arg_SUID;
//14.依頼済手続き記述
  //...8.予約済手続きｽﾃｯﾌﾟ記述に同じ
  arg_Rcv_REQ_PROC_DESCRIPTION := '';
//15.依頼医師
  //...全角変換
  arg_Rcv_REQUESTING_PHYSICIAN := Trim(StringReplace(Trim(arg_Irai_Doctor_Name), ' ', '　', [rfReplaceAll]));
//16.依頼部門
  //...CT、MRはローマ字変換
  if (arg_Rcv_MODALITY = 'CT') or
     (arg_Rcv_MODALITY = 'MR') then begin
    arg_Rcv_REQUESTING_SERVICE := func_Kana_To_Roma(Trim(arg_Irai_Section_Kana));
  end
  //...CT、MR以外は漢字
  else begin
    arg_Rcv_REQUESTING_SERVICE := Trim(StringReplace(Trim(arg_Irai_Section_Name), ' ', '　', [rfReplaceAll]));
  end;
//17.受付番号
  //患者ID＋オーダNO
  //...'-'をとる 2001.02.15
  arg_Rcv_ACCESSION_NUMBER := Trim(StringReplace(arg_KanjaID,'-','',[rfReplaceAll]))
                            + arg_OrderNO;
//18.施設名
  //...固定(INIマスタより取得)
  arg_Rcv_INSTITUTION := func_Get_WinMaster_DATA(arg_Group_No,g_HOSP,g_HOSP_NAME);
//19.施設住所
  //...固定(INIマスタより取得)
  arg_Rcv_INSTITUTION_ADDRESS := func_Get_WinMaster_DATA(arg_Group_No,g_HOSP,g_HOSP_ADDRESS);
//20.患者名(ROMA)
  //...カナ→ローマ字変換
  arg_Rcv_PATIENT_NAME_ROMA := func_Kana_To_Roma(arg_SimeiKana);
//21.患者名(漢字)
  //...全角変換
  arg_Rcv_PATIENT_NAME_KANJI := Trim(StringReplace(arg_SimeiKanji, ' ', '　', [rfReplaceAll]));
//22.患者名(カナ)
  //
  arg_Rcv_PATIENT_NAME_KANA := arg_SimeiKana;
  arg_Rcv_PATIENT_NAME_KANA := HanToZen(arg_Rcv_PATIENT_NAME_KANA);
  arg_Rcv_PATIENT_NAME_KANA := StringReplace(arg_Rcv_PATIENT_NAME_KANA, ' ', '　', [rfReplaceAll]);
//23.患者ID
  //
  arg_Rcv_PATIENT_ID := arg_KanjaID;
//24.患者の誕生日
  //...DATE型
  arg_Rcv_PATIENT_BIRTH_DATE := '';
  if arg_BirthDay <> '' then begin
    if Length(Trim(arg_BirthDay)) = 10 then begin
      arg_Rcv_PATIENT_BIRTH_DATE := Trim(arg_BirthDay);
    end else begin
      arg_Rcv_PATIENT_BIRTH_DATE := func_Date8To10(Trim(arg_BirthDay));
    end;
  end;
//25.患者の性別
  //...M:男、F:女
  if (arg_Sex <> GPCST_SEX_1) and
     (arg_Sex <> GPCST_SEX_2) then begin
     arg_Sex := func_PIND_Change_Sex(arg_Sex);
  end;
  arg_Rcv_PATIENT_SEX := arg_Sex;
//26.患者の体重
  //...なし
  arg_Rcv_PATIENT_WEIGHT := '';
end;
//ワークリスト予約テーブル用全項目編集↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑

//●機能（例外無）：カタカナ→ローマ字変換
// MS-IME2 for Windowsのローマ字とカナの対応表
function func_Kana_To_Roma(
         arg_Kana: string
         ): string;
var
  w_i,w_ii: integer;
  w_t: integer;
  w_Get_Kana: string;
  w_Get_Roma: string;
  w_Roma: string;

  w_Before_Kana: string;
  w_After_Kana: string;
  w_LTU: Boolean;
//ア～ワ行及び濁点等
type TNAMEAREA_1 = array[1..242] of String;
const
  Kana_Area_Max = 242;
  Kana_Area : TNAMEAREA_1 =
       (
        'ｱ',	'ｲ',	'ｳ',	'ｴ',	'ｵ',
        'ｶ',	'ｷ',	'ｸ',	'ｹ',	'ｺ',
        'ｻ',	'ｼ',	'ｽ',	'ｾ',	'ｿ',
        'ﾀ',	'ﾁ',	'ﾂ',	'ﾃ',	'ﾄ',
        'ﾅ',	'ﾆ',	'ﾇ',	'ﾈ',	'ﾉ',
        'ﾊ',	'ﾋ',	'ﾌ',	'ﾍ',	'ﾎ',
        'ﾏ',	'ﾐ',	'ﾑ',	'ﾒ',	'ﾓ',
        'ﾔ',		'ﾕ',		'ﾖ',
        'ﾗ',	'ﾘ',	'ﾙ',	'ﾚ',	'ﾛ',
        'ﾜ',	'ｦ',			'ﾝ',
        		'ｳﾞ',
        'ｶﾞ',	'ｷﾞ',	'ｸﾞ',	'ｹﾞ',	'ｺﾞ',
        'ｻﾞ',	'ｼﾞ',	'ｽﾞ',	'ｾﾞ',	'ｿﾞ',
        'ﾀﾞ',	'ﾁﾞ',	'ﾂﾞ',	'ﾃﾞ',	'ﾄﾞ',
        'ﾊﾞ',	'ﾋﾞ',	'ﾌﾞ',	'ﾍﾞ',	'ﾎﾞ',
        'ﾊﾟ',	'ﾋﾟ',	'ﾌﾟ',	'ﾍﾟ',	'ﾎﾟ',
        'ｳｧ',	'ｳｨ',		'ｳｪ',	'ｳｫ',
        'ｸｧ',	'ｸｨ',	'ｸｩ',	'ｸｪ',	'ｸｫ',
        'ｽｧ',	'ｽｨ',	'ｽｩ',	'ｽｪ',	'ｽｫ',
        'ﾂｧ',	'ﾂｨ',		'ﾂｪ',	'ﾂｫ',
        'ﾄｧ',	'ﾄｨ', 	'ﾄｩ',	'ﾄｪ',	'ﾄｫ',
        'ﾌｧ',	'ﾌｨ',	'ﾌｩ',	'ﾌｪ',	'ﾌｫ',
        'ｳﾞｧ',	'ｳﾞｨ',		'ｳﾞｪ',	'ｳﾞｫ',
        'ｸﾞｧ',	'ｸﾞｨ',	'ｸﾞｩ',	'ｸﾞｪ',	'ｸﾞｫ',
        'ﾄﾞｧ',	'ﾄﾞｨ',	'ﾄﾞｩ',	'ﾄﾞｪ',	'ﾄﾞｫ',
        'ｷｬ',	'ｷｨ',	'ｷｭ', 	'ｷｪ',	'ｷｮ',
        'ｸｬ',		'ｸｭ',		'ｸｮ',
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
        'ｬ',		'ｭ',		'ｮ',
        'ｯ',
        'ﾟ',	'ﾞ',	'ｰ',
        '!',	'"',	'#',	'$',	'%',
        '&',	'''',	'(',	')',	'=',
        '^',	'~',	'\',	'|',	'｢',
        '{',	'@',	'`',	'｣',	'}',
        ':',	'*',	';',	'+',	'_',
        '･',	'?',	'｡',	'>',	'､',
        '<',	'/',    '.',
        '0',	'1',	'2',	'3',	'4',
        '5',	'6',	'7',	'8',	'9'
       );
  Roma_Area : TNAMEAREA_1 =
       (
        'A',	'I',	'U',	'E',	'O',
        'KA',	'KI',	'KU',	'KE',	'KO',
        'SA',	'SHI',	'SU', 	'SE',	'SO',
        'TA',	'CHI',	'TSU',	'TE',	'TO',
        'NA',	'NI',	'NU',	'NE',	'NO',
        'HA',	'HI',	'FU',	'HE',	'HO',
        'MA',	'MI',	'MU',	'ME',	'MO',
        'YA',		'YU',		'YO',
        'RA',	'RI',	'RU',	'RE',	'RO',
        'WA',	'WO',			'N',
        		'VU',
        'GA',	'GI',	'GU',	'GE',	'GO',
        'ZA',	'JI',	'ZU',	'ZE',	'ZO',
        'DA',	'DI',	'DU',	'DE',	'DO',
        'BA',	'BI',	'BU',	'BE',	'BO',
        'PA',	'PI',	'PU',	'PE',	'PO',
        'WHA',	'WHI',		'WHE',	'WHO',
        'QWA',	'QWI',	'QWU',	'QWE',	'QWO',
        'SWA',	'SWI',	'SWU',	'SWE',	'SWO',
        'TSA',	'TSI',		'TSE',	'TSO',
        'TWA',	'TWI',	'TWU',	'TWE',	'TWO',
        'FWA',	'FWI',	'FWU',	'FWE',	'FWO',
        'VA',	'VI',		'VE',	'VO',
        'GWA',	'GWI',	'GWU',	'GWE',	'GWO',
        'DWA',	'DWI',	'DWU',	'DWE',	'DWO',
        'KYA',	'KYI',	'KYU',	'KYE',	'KYO',
        'QYA',		'QYU',		'QYO',
        'SYA',	'SYI',	'SYU',	'SYE',	'SYO',
        'CHA',	'CYI',	'CHU',	'CHE',	'CHO',
        'THA',	'THI',	'THU',	'THE',	'THO',
        'NYA',	'NYI',	'NYU',	'NYE',	'NYO',
        'HYA',	'HYI',	'HYU',	'HYE',	'HYO',
        'MYA',	'MYI',	'MYU',	'MYE',	'MYO',
        'RYA',	'RYI',	'RYU',	'RYE',	'RYO',
        'GYA',	'GYI',	'GYU',	'GYE',	'GYO',
        'JYA',	'JYI',	'JYU',	'JYE',	'JYO',
        'DYA',	'DYI',	'DYU',	'DYE',	'DYO',
        'DHA',	'DHI',	'DHU',	'DHE',	'DHO',
        'BYA',	'BYI',	'BYU',	'BYE',	'BYO',
        'PYA',	'PYI',	'PYU',	'PYE',	'PYO',
        'LA',	'LI',	'LU',	'LE',	'LO',
        'LYA',		'LYU',		'LYO',
        'LTU',
        'ﾟ',	'ﾞ',	'-',
        '!',	'"',	'#',	'$',	'%',
        '&',	'''',	'(',	')',	'=',
        '^',	'~',	'\',	'|',	'｢',
        '{',	'@',	'`',	'｣',	'}',
        ':',	'*',	';',	'+',	'_',
        '･',	'?',	'｡',	'>',	'､',
        '<',	'/',    '.',
        '0',	'1',	'2',	'3',	'4',
        '5',	'6',	'7',	'8',	'9'
       );
begin
  Result := '';
  arg_Kana := Trim(arg_Kana);
  w_Roma := '';
  w_LTU := False;

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

    w_Get_Roma := '';
    for w_t := 1 to Kana_Area_Max do begin
      if Kana_Area[w_t] = w_Get_Kana then begin
        w_Get_Roma := Roma_Area[w_t];
        Break;
      end;
    end;
    if w_Get_Roma = '' then begin
      if w_ii <> w_i then begin
        w_i := w_ii;
        w_Get_Kana := Copy(arg_Kana,w_i,1);
        for w_t := 1 to Kana_Area_Max do begin
          if Kana_Area[w_t] = w_Get_Kana then begin
            w_Get_Roma := Roma_Area[w_t];
            Break;
          end;
        end;
      end;
    end;

    if w_Get_Roma = '' then begin
      if w_LTU = True then begin
        w_Get_Roma := 'LTU';
        w_LTU := False;
      end;
      w_Get_Roma := w_Get_Roma + ' ';
    end
    else begin
      if w_LTU = True then begin
        w_Get_Roma := Copy(w_Get_Roma, 1, 1) + w_Get_Roma;
        w_LTU := False;
      end;
      //前に「ﾝ」があって、母音の場合
      if (w_Before_Kana = 'ﾝ') and
         ((w_Get_Kana = 'ｱ') or
          (w_Get_Kana = 'ｲ') or
          (w_Get_Kana = 'ｳ') or
          (w_Get_Kana = 'ｴ') or
          (w_Get_Kana = 'ｵ') ) then begin
        w_Get_Roma := 'N' + w_Get_Roma;
      end;
    end;

    //結合
    w_Roma := w_Roma + w_Get_Roma;

    //次へ
    w_i := w_i + 1;
  end;

  //最後にｯが残っている時
  if w_LTU = True then begin
    w_Roma := w_Roma + 'LTU';
  end;

  Result := Trim(w_Roma);
end;
//カタカナ→ローマ字変換処理↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑


//●★使用可★機能（例外有）：現在番号+1取得
function func_Get_NumberControl(
         arg_Database:TDatabase;
         arg_Query:TQuery;
         arg_Kubun:string;
         arg_Date:string
         ):integer;
var
  w_NO: integer;
  w_Date: string;
  w_Sys_Date: string;
  w_Year: string;
begin
  Result := 0;
  w_NO := 0;
  //指定区分なしはエラー
  if arg_Kubun = '' then
    Exit;
  //日付管理ありはシステム日付にする
  if arg_Date <> '' then
    arg_Date := FormatDateTime('YYYY/MM/DD', func_GetDBSysDate(arg_Query));
  //受付№は年度により切り替えるため日付管理にする
  if arg_Kubun = 'UNO' then
    arg_Date := FormatDateTime('YYYY/MM/DD', func_GetDBSysDate(arg_Query));
{2002.11.22
  //受付№は20001～
  if arg_Kubun = 'UNO' then
    w_NO := 20000;
2002.11.22}
  //12番は601～
  if arg_Kubun = 'S12' then
    w_NO := 600;
  //13番は401～
  if arg_Kubun = 'S13' then
    w_NO := 400;
  //15番は101～
  if arg_Kubun = 'S15' then
    w_NO := 100;
  //16番は501～
  if arg_Kubun = 'S16' then
    w_NO := 500;
  //17番は201～
  if arg_Kubun = 'S17' then
    w_NO := 200;
  //19番は301～
  if arg_Kubun = 'S19' then
    w_NO := 300;
  //救急は901～
  if arg_Kubun = 'S99' then
    w_NO := 900;
//番号管理より指定区分の現在番号＋１を求める
  arg_Database.StartTransaction;
  try
    with arg_Query do begin
      Close;
      SQL.Clear;
      SQL.Add ('SELECT ');
      SQL.Add (' nb.* ');
      SQL.Add (' FROM NUMBERCONTROLTABLE nb ');
      SQL.Add (' WHERE nb.KANRI_ID = :PKANRI_ID ');
      SQL.Add (' for update ');
      if not Prepared then Prepare;
      ParamByName('PKANRI_ID').AsString := arg_Kubun;
      //Open;
      //First;
      ExecSQL;
    end;
    with arg_Query do begin
      Close;
      SQL.Clear;
      SQL.Add ('SELECT ');
      SQL.Add (' nb.* ');
      SQL.Add (' FROM NUMBERCONTROLTABLE nb ');
      SQL.Add (' WHERE nb.KANRI_ID = :PKANRI_ID ');
      if not Prepared then Prepare;
      ParamByName('PKANRI_ID').AsString := arg_Kubun;
      Open;
      First;
    end;
//...レコードあり
    if not(arg_Query.Eof) then begin
      //...日付管理なし
      if arg_Date = '' then begin
        if arg_Query.FieldByName('NOW_NO').AsString <> '' then begin
          w_NO := arg_Query.FieldByName('NOW_NO').AsInteger;
          //+1する
          w_NO := w_NO + 1;
        end;
      end
    //...日付管理あり
      else begin
{2002.11.22
        //「受付№」は年度により切り替える
        if arg_Kubun = 'UNO' then begin
          if arg_Query.FieldByName('UPDATEDATE').AsString <> '' then begin
            w_Year := FormatDateTime('YYYY', arg_Query.FieldByName('UPDATEDATE').AsDateTime);
            //年が異なる場合は新たに始める
            if w_Year <> Copy(arg_Date,1,4) then begin
              //+1する
              w_NO := w_NO + 1;
            end
            //年が同じ場合は元に＋１する
            else begin
              w_NO := arg_Query.FieldByName('NOW_NO').AsInteger;
              //+1する
              w_NO := w_NO + 1;
            end;
          end
          else begin
            //+1する
            w_NO := w_NO + 1;
          end;
        end
        //通常
        else begin
          if arg_Query.FieldByName('UPDATEDATE').AsString <> '' then begin
            w_Date := FormatDateTime('YYYY/MM/DD', arg_Query.FieldByName('UPDATEDATE').AsDateTime);
            //日付が異なる場合は新たに始める
            if w_Date <> arg_Date then begin
              //+1する
              w_NO := w_NO + 1;
            end
            //日付が同じ場合は元に＋１する
            else begin
              w_NO := arg_Query.FieldByName('NOW_NO').AsInteger;
              //+1する
              w_NO := w_NO + 1;
            end;
          end
          else begin
            //+1する
            w_NO := w_NO + 1;
          end;
        end;
2002.11.22}
        if arg_Query.FieldByName('UPDATEDATE').AsString <> '' then begin
          w_Date := FormatDateTime('YYYY/MM/DD', arg_Query.FieldByName('UPDATEDATE').AsDateTime);
          //日付が異なる場合は新たに始める
          if w_Date <> arg_Date then begin
            //+1する
            w_NO := w_NO + 1;
          end
          //日付が同じ場合は元に＋１する
          else begin
            w_NO := arg_Query.FieldByName('NOW_NO').AsInteger;
            //+1する
            w_NO := w_NO + 1;
          end;
        end
        else begin
          //+1する
          w_NO := w_NO + 1;
        end;
      end;
      if w_NO <= 0 then begin
        arg_Database.Rollback; // コミットで失敗した場合，変更を取り消す
        Exit;
      end;
      //番号管理テーブル更新
      w_Sys_Date := FormatDateTime('YYYY/MM/DD', func_GetDBSysDate(arg_Query));
      if not func_NumberControl_Update(arg_Database, arg_Query, 2, arg_Kubun, w_Sys_Date, w_NO) then begin
        arg_Database.Rollback; // コミットで失敗した場合，変更を取り消す
        Exit;
      end;
      arg_Database.Commit; // 成功した場合，変更をコミットする
    end
//...レコードなし
    else begin
      //レコードがない場合は新たに始める
      //+1する
      w_NO := w_NO + 1;
      //番号管理テーブル追加
      w_Sys_Date := FormatDateTime('YYYY/MM/DD', func_GetDBSysDate(arg_Query));
      if not func_NumberControl_Update(arg_Database, arg_Query, 1, arg_Kubun, w_Sys_Date, w_NO) then begin
        arg_Database.Rollback; // コミットで失敗した場合，変更を取り消す
        Exit;
      end;
      arg_Database.Commit; // 成功した場合，変更をコミットする
    end;
  except
    on E: Exception do begin
      arg_Database.Rollback; // 失敗した場合，変更を取り消す
      Exit;
    end;
  end;
  //
  Result := w_NO;
end;
//●★使用可★機能（例外有）：現在番号更新
function func_NumberControl_Update(
         arg_Database:TDatabase;
         arg_Query:TQuery;
         arg_Mode:integer;
         arg_Kubun:string;
         arg_UpdateDate:string;
         arg_Now_NO:integer
         ):Boolean;
begin
  Result := False;
  if (arg_Mode <> 1) and  //追加
     (arg_Mode <> 2) then //修正
    Exit;
//更新開始
//  arg_Database.StartTransaction;
  try
{
    with arg_Query do begin
      Close;
      SQL.Clear;
      SQL.Add ('SELECT ');
      SQL.Add (' nb.* ');
      SQL.Add (' FROM NUMBERCONTROLTABLE nb ');
      SQL.Add (' WHERE nb.KANRI_ID = :PKANRI_ID ');
      SQL.Add (' for update ');
      if not Prepared then Prepare;
      ParamByName('PKANRI_ID').AsString := arg_Kubun;
      //Open;
      //First;
      ExecSQL;
    end;
}
    //追加処理
    if arg_Mode = 1 then begin
      with arg_Query do begin
        Close;
        SQL.Clear;
        SQL.Add ('INSERT INTO NUMBERCONTROLTABLE ');
        SQL.Add ('(');
        SQL.Add (' KANRI_ID,');
        SQL.Add (' UPDATEDATE,');
        SQL.Add (' NOW_NO ');
        SQL.Add (') VALUES ( ');
        SQL.Add (' :PKANRI_ID,');
        SQL.Add (' :PUPDATEDATE,');
        SQL.Add (' :PNOW_NO ');
        SQL.Add (')');
        if not Prepared then Prepare;
        ParamByName('PKANRI_ID').AsString := arg_Kubun;
        ParamByName('PUPDATEDATE').AsDate := func_StrToDate(arg_UpdateDate);
        ParamByName('PNOW_NO').AsInteger  := arg_Now_NO;
        ExecSQL;
      end;
    end
    //修正処理
    else begin
      with arg_Query do begin
        Close;
        SQL.Clear;
        SQL.Add('UPDATE NUMBERCONTROLTABLE SET ');
        SQL.Add(' UPDATEDATE = :PUPDATEDATE ');
        SQL.Add(',NOW_NO = :PNOW_NO ');
        SQL.Add('WHERE ');
        SQL.Add(' KANRI_ID = :PKEYCODE ');
        if not Prepared then Prepare;
        ParamByName('PUPDATEDATE').AsDate := func_StrToDate(arg_UpdateDate);
        ParamByName('PNOW_NO').AsInteger  := arg_Now_NO;
        //キー
        ParamByName('PKEYCODE').AsString  := arg_Kubun;
        ExecSQL;
      end;
    end;
{
    try
      arg_Database.Commit; // 成功した場合，変更をコミットする
    except
      on E: Exception do begin
        arg_Database.Rollback; // コミットで失敗した場合，変更を取り消す
        Exit;
      end;
    end;
}
  except
    on M:T_ESysExcep do begin
//      arg_Database.Rollback; // コミットで失敗した場合，変更を取り消す
      Exit;
    end;
    on E: Exception do begin
//      arg_Database.Rollback; // 失敗した場合，変更を取り消す
      Exit;
    end;
  end;
//正常
  Result := True;
end;
//番号管理テーブル現在番号編集↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
//2001.09.07
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 会計種別
function func_PIND_Change_KAIKEI(arg_Code:string):string;//名称
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_KAIKEITYPE_0 then
    //'医事'
    w_Res := GPCST_KAIKEITYPE_0_NAME
  //arg_Code = '1'
  else if arg_Code = GPCST_KAIKEITYPE_1 then
    //'自費'
    w_Res := GPCST_KAIKEITYPE_1_NAME
  //arg_Code = '2'
  else if arg_Code = GPCST_KAIKEITYPE_2 then
    //'校費'
    w_Res := GPCST_KAIKEITYPE_2_NAME
  //arg_Code = '3'
  else if arg_Code = GPCST_KAIKEITYPE_3 then
    //'治療'
    w_Res := GPCST_KAIKEITYPE_3_NAME
  //arg_Code = '医事'
  else if arg_Code = GPCST_KAIKEITYPE_0_NAME then
    //'0'
    w_Res := GPCST_KAIKEITYPE_0
  //arg_Code = '自費'
  else if arg_Code = GPCST_KAIKEITYPE_1_NAME then
    //'1'
    w_Res := GPCST_KAIKEITYPE_1
  //arg_Code = '校費'
  else if arg_Code = GPCST_KAIKEITYPE_2_NAME then
    //'2'
    w_Res := GPCST_KAIKEITYPE_2
  //arg_Code = '治療'
  else if arg_Code = GPCST_KAIKEITYPE_3_NAME then
    //'3'
    w_Res := GPCST_KAIKEITYPE_3
  else
    w_Res:= '';
  result:=w_Res;
end;
//2001.09.10
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 帰宅指示
function func_PIND_Change_KITAKU(arg_Code:string):string;//名称
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_KITAKU_0 then
    //'未帰宅'
    w_Res := GPCST_KITAKU_0_NAME
  //arg_Code = '1'
  else if arg_Code = GPCST_KITAKU_1 then
    //'帰宅済'
    w_Res := GPCST_KITAKU_1_NAME
  //arg_Code = '未帰宅'
  else if arg_Code = GPCST_KITAKU_0_NAME then
    //'0'
    w_Res := GPCST_KITAKU_0
  //arg_Code = '帰宅済'
  else if arg_Code = GPCST_KITAKU_1_NAME then
    //'1'
    w_Res := GPCST_KITAKU_1
  //arg_Code = ''
  else if arg_Code = '' then
    //'未帰宅'
    w_Res := GPCST_KITAKU_0_NAME
  else
    w_Res := '';
  result:=w_Res;
end;
//2001.09.10
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 病院連絡TEL
function func_PIND_Change_TEL(arg_Code:string):string;//名称
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_TEL_0 then
    //'否'
    w_Res := GPCST_TEL_0_NAME
  //arg_Code = '1'
  else if arg_Code = GPCST_TEL_1 then
    //'要'
    w_Res := GPCST_TEL_1_NAME
  //arg_Code = '否'
  else if arg_Code = GPCST_TEL_0_NAME then
    //'0'
    w_Res := GPCST_TEL_0
  //arg_Code = '要'
  else if arg_Code = GPCST_TEL_1_NAME then
    //'1'
    w_Res := GPCST_TEL_1
  //arg_Code = ''
  else if arg_Code = '' then
    //'否'
    w_Res := GPCST_TEL_0_NAME
  else
    w_Res := '';
  result:=w_Res;
end;
//2001.09.11
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 所見要否
function func_PIND_Change_SYOKEN_YOUHI(arg_Code:string):string;//名称
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_SYOKEN_YOUHI_0 then
    //'不要'
    w_Res := GPCST_SYOKEN_YOUHI_0_NAME
  //arg_Code = '1'
  else if arg_Code = GPCST_SYOKEN_YOUHI_1 then
    //'必要'
    w_Res := GPCST_SYOKEN_YOUHI_1_NAME
  //arg_Code = '不要'
  else if arg_Code = GPCST_SYOKEN_YOUHI_0_NAME then
    //'0'
    w_Res := GPCST_SYOKEN_YOUHI_0
  //arg_Code = '必要'
  else if arg_Code = GPCST_SYOKEN_YOUHI_1_NAME then
    //'1'
    w_Res := GPCST_SYOKEN_YOUHI_1
  //arg_Code = ''
  else if arg_Code = '' then
    //'不要'
    w_Res := GPCST_SYOKEN_YOUHI_0_NAME
  else
    w_Res := '';
  result:=w_Res;
end;
//2001.09.13
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 撮影進捗
function func_PIND_Change_SATUEISTATUS(arg_Code:string):string;//名称
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_CODE_SATUEIS_0 then
    //'未撮影'
    w_Res := GPCST_NAME_SATUEIS_0
  //arg_Code = '1'
  else if arg_Code = GPCST_CODE_SATUEIS_1 then
    //'撮影済'
    w_Res := GPCST_NAME_SATUEIS_1
  //arg_Code = '2'
  else if arg_Code = GPCST_CODE_SATUEIS_2 then
    //'中止'
    w_Res := GPCST_NAME_SATUEIS_2
  //arg_Code = '未撮影'
  else if arg_Code = GPCST_NAME_SATUEIS_0 then
    //'0'
    w_Res := GPCST_CODE_SATUEIS_0
  //arg_Code = '撮影済'
  else if arg_Code = GPCST_NAME_SATUEIS_1 then
    //'1'
    w_Res := GPCST_CODE_SATUEIS_1
  //arg_Code = '中止'
  else if arg_Code = GPCST_NAME_SATUEIS_2 then
    //'2'
    w_Res := GPCST_CODE_SATUEIS_2
  else
    w_Res := '';
  result:=w_Res;
end;
//2001.09.13
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 画像確認
function func_PIND_Change_GAZOU_KAKUNIN(arg_Code:string):string;//名称
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_GAZOU_KAKUNIN_0 then
    //'未'
    w_Res := GPCST_GAZOU_KAKUNIN_0_NAME
  //arg_Code = '1'
  else if arg_Code = GPCST_GAZOU_KAKUNIN_1 then
    //'済'
    w_Res := GPCST_GAZOU_KAKUNIN_1_NAME
  //arg_Code = '未'
  else if arg_Code = GPCST_GAZOU_KAKUNIN_0_NAME then
    //'0'
    w_Res := GPCST_GAZOU_KAKUNIN_0
  //arg_Code = '済'
  else if arg_Code = GPCST_GAZOU_KAKUNIN_1_NAME then
    //'1'
    w_Res := GPCST_GAZOU_KAKUNIN_1
  //arg_Code = ''
  else if arg_Code = '' then
    //'未'
    w_Res := GPCST_GAZOU_KAKUNIN_0_NAME
  else
    w_Res := '';
  result:=w_Res;
end;
//2001.09.20
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 帰宅指示
function func_PIND_Change_KITAKU_G(arg_Code:string):string;//名称
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_KITAKU_0_G then
    //'未'
    w_Res := GPCST_KITAKU_0_NAME_G
  //arg_Code = '1'
  else if arg_Code = GPCST_KITAKU_1_G then
    //'帰'
    w_Res := GPCST_KITAKU_1_NAME_G
  //arg_Code = '未'
  else if arg_Code = GPCST_KITAKU_0_NAME_G then
    //'0'
    w_Res := GPCST_KITAKU_0_G
  //arg_Code = '帰'
  else if arg_Code = GPCST_KITAKU_1_NAME_G then
    //'1'
    w_Res := GPCST_KITAKU_1_G
  //arg_Code = ''
  else if arg_Code = '' then
    //'未'
    w_Res := GPCST_KITAKU_0_NAME_G
  else
    w_Res := '';
  result:=w_Res;
end;
//2001.09.20
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 病院連絡TEL
function func_PIND_Change_TEL_G(arg_Code:string):string;//名称
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_TEL_0_G then
    //'否'
    w_Res := GPCST_TEL_0_NAME_G
  //arg_Code = '1'
  else if arg_Code = GPCST_TEL_1_G then
    //'要'
    w_Res := GPCST_TEL_1_NAME_G
  //arg_Code = ''
  else if arg_Code = GPCST_TEL_0_NAME_G then
    //'0'
    w_Res := GPCST_TEL_0_G
  //arg_Code = 'TEL'
  else if arg_Code = GPCST_TEL_1_NAME_G then
    //'1'
    w_Res := GPCST_TEL_1_G
  //arg_Code = ''
  else if arg_Code = '' then
    //''
    w_Res := GPCST_TEL_0_NAME_G
  else
    w_Res := '';
  result:=w_Res;
end;
//2001.09.20
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 画像確認
function func_PIND_Change_GAZOU_KAKUNIN_G(arg_Code:string):string;//名称
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_GAZOU_KAKUNIN_0_G then
    //'未'
    w_Res := GPCST_GAZOU_KAKUNIN_0_NAME_G
  //arg_Code = '1'
  else if arg_Code = GPCST_GAZOU_KAKUNIN_1_G then
    //'済'
    w_Res := GPCST_GAZOU_KAKUNIN_1_NAME_G
  //arg_Code = '未'
  else if arg_Code = GPCST_GAZOU_KAKUNIN_0_NAME_G then
    //'0'
    w_Res := GPCST_GAZOU_KAKUNIN_0_G
  //arg_Code = '済'
  else if arg_Code = GPCST_GAZOU_KAKUNIN_1_NAME_G then
    //'1'
    w_Res := GPCST_GAZOU_KAKUNIN_1_G
  //arg_Code = ''
  else if arg_Code = '' then
    //'未'
    w_Res := GPCST_GAZOU_KAKUNIN_0_NAME_G
  else
    w_Res := '';
  result:=w_Res;
end;

//2001/09/17
//●機能（例外無）：プリンタタイプを取得
function func_Get_PrintType(arg_Type:String):String;//名称
var
   w_Res:string;
begin
  w_Res:='';

  //レーザー
  if arg_Type = '1' then
     w_Res:=GPCST_PRI_TYPE_01;
  //ラベル
  if arg_Type = '2' then
     w_Res:=GPCST_PRI_TYPE_02;
  //ドットインパクト
  if arg_Type = '3' then
     w_Res:=GPCST_PRI_TYPE_03;

  result:=w_Res;
end;
//2001.09.25
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

//2002.09.20
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 色替要否
function func_PIND_Change_COLOR_YOUHI(arg_Code:string):string;//名称
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_COLOR_YOUHI_0 then
    //'不要'
    w_Res := GPCST_COLOR_YOUHI_0_NAME
  //arg_Code = '1'
  else if arg_Code = GPCST_COLOR_YOUHI_1 then
    //'必要'
    w_Res := GPCST_COLOR_YOUHI_1_NAME
  //arg_Code = '不要'
  else if arg_Code = GPCST_COLOR_YOUHI_0_NAME then
    //'0'
    w_Res := GPCST_COLOR_YOUHI_0
  //arg_Code = '必要'
  else if arg_Code = GPCST_COLOR_YOUHI_1_NAME then
    //'1'
    w_Res := GPCST_COLOR_YOUHI_1
  //arg_Code = ''
  else if arg_Code = '' then
    //'不要'
    w_Res := GPCST_COLOR_YOUHI_0_NAME
  else
    w_Res := '';
  result:=w_Res;
end;
//2002.09.24
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 左右使用
function func_PIND_Change_SAYUU(arg_Code:string):string;//名称
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_SAYUU_0 then
    //'不要'
    w_Res := GPCST_SAYUU_0_NAME
  //arg_Code = '1'
  else if arg_Code = GPCST_SAYUU_1 then
    //'必要'
    w_Res := GPCST_SAYUU_1_NAME
  //arg_Code = '不要'
  else if arg_Code = GPCST_SAYUU_0_NAME then
    //'0'
    w_Res := GPCST_SAYUU_0
  //arg_Code = '必要'
  else if arg_Code = GPCST_SAYUU_1_NAME then
    //'1'
    w_Res := GPCST_SAYUU_1
  //arg_Code = ''
  else if arg_Code = '' then
    //'不要'
    w_Res := GPCST_SAYUU_0_NAME
  else
    w_Res := '';
  result:=w_Res;
end;
//2002.09.24
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 読影要否
function func_PIND_Change_DOKUEI(arg_Code:string):string;//名称
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_DOKUEI_0 then
    //'不要'
    w_Res := GPCST_DOKUEI_0_NAME
  //arg_Code = '1'
  else if arg_Code = GPCST_DOKUEI_1 then
    //'必要'
    w_Res := GPCST_DOKUEI_1_NAME
  //arg_Code = '2'
  else if arg_Code = GPCST_DOKUEI_2 then
    //'省略'
    w_Res := GPCST_DOKUEI_2_NAME
  //arg_Code = '不要'
  else if arg_Code = GPCST_DOKUEI_0_NAME then
    //'0'
    w_Res := GPCST_DOKUEI_0
  //arg_Code = '必要'
  else if arg_Code = GPCST_DOKUEI_1_NAME then
    //'1'
    w_Res := GPCST_DOKUEI_1
  //arg_Code = '省略'
  else if arg_Code = GPCST_DOKUEI_2_NAME then
    //'2'
    w_Res := GPCST_DOKUEI_2
  //arg_Code = ''
  else if arg_Code = '' then
    //'不要'
    w_Res := GPCST_DOKUEI_0_NAME
  else
    w_Res := '';
  result:=w_Res;
end;
//2002.09.24
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 処置室使用
function func_PIND_Change_SHOTI(arg_Code:string):string;//名称
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_SHOTI_0 then
    //'不要'
    w_Res := GPCST_SHOTI_0_NAME
  //arg_Code = '1'
  else if arg_Code = GPCST_SHOTI_1 then
    //'必要'
    w_Res := GPCST_SHOTI_1_NAME
  //arg_Code = '不要'
  else if arg_Code = GPCST_SHOTI_0_NAME then
    //'0'
    w_Res := GPCST_SHOTI_0
  //arg_Code = '必要'
  else if arg_Code = GPCST_SHOTI_1_NAME then
    //'1'
    w_Res := GPCST_SHOTI_1
  //arg_Code = ''
  else if arg_Code = '' then
    //'不要'
    w_Res := GPCST_SHOTI_0_NAME
  else
    w_Res := '';
  result:=w_Res;
end;
//2002.12.14
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 処置室使用・略称
function func_PIND_Change_SHOTI_RYAKU(arg_Code:string):string;//名称
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_SHOTI_0 then
    //'不要'
    w_Res := GPCST_SHOTI_0_RYAKU_NAME
  //arg_Code = '1'
  else if arg_Code = GPCST_SHOTI_1 then
    //'必要'
    w_Res := GPCST_SHOTI_1_RYAKU_NAME
  //arg_Code = '不要'
  else if arg_Code = GPCST_SHOTI_0_RYAKU_NAME then
    //'0'
    w_Res := GPCST_SHOTI_0
  //arg_Code = '必要'
  else if arg_Code = GPCST_SHOTI_1_RYAKU_NAME then
    //'1'
    w_Res := GPCST_SHOTI_1
  //arg_Code = ''
  else if arg_Code = '' then
    //'不要'
    w_Res := GPCST_SHOTI_0_RYAKU_NAME
  else
    w_Res := '';
  result:=w_Res;
end;
//2002.09.24
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 要造影
function func_PIND_Change_YZOUEI(arg_Code:string):string;//名称
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_YZOUEI_0 then
    //'不要'
    w_Res := GPCST_YZOUEI_0_NAME
  //arg_Code = '1'
  else if arg_Code = GPCST_YZOUEI_1 then
    //'必要'
    w_Res := GPCST_YZOUEI_1_NAME
  //arg_Code = '不要'
  else if arg_Code = GPCST_YZOUEI_0_NAME then
    //'0'
    w_Res := GPCST_YZOUEI_0
  //arg_Code = '必要'
  else if arg_Code = GPCST_YZOUEI_1_NAME then
    //'1'
    w_Res := GPCST_YZOUEI_1
  //arg_Code = ''
  else if arg_Code = '' then
    //'不要'
    w_Res := GPCST_YZOUEI_0_NAME
  else
    w_Res := '';
  result:=w_Res;
end;

//●機能（例外無）：グリッドカラム幅を書き込む
function func_Grid_ColumnSize_Write(arg_Grid: TStringGrid; arg_Name,arg_No: string):Boolean;
var
  TxtFile: TextFile;
  w_Dir_Name: string;
  w_File_Name: string;
  w_Record: string[255];
  i: integer;
begin
  Result := True;
//  w_File_Name := CST_PATH_GRID_COLUMNS + arg_Name + '_' + arg_No + '.txt';
  w_File_Name := gi_columndir_DIR + arg_Name + '_' + arg_No + '.txt';
  w_Dir_Name  := ExtractFileDir(w_File_Name);
  if not(DirectoryExists(w_Dir_Name)) then begin
    if not(CreateDir(w_Dir_Name)) then begin
      //raise Exception.Create('Cannot Create ' + w_Dir_Name);
      Exit;
    end;
  end;

  w_Record := '';
  for i := 0 to (arg_Grid.ColCount - 1) do begin
    w_Record := w_Record + IntToStr(arg_Grid.ColWidths[i]) + ',';
  end;
  if Length(w_Record) > 0 then begin
    w_Record := Copy(w_Record, 1, Length(w_Record) - 1);
  end;
  //書き込み
  try
    AssignFile(TxtFile, w_File_Name);
    Rewrite(TxtFile);
    try
      Writeln(TxtFile, w_Record);
    finally
      Flush(TxtFile);
      CloseFile(TxtFile);
    end;
  except
    raise Exception.Create('Cannot AssignFile ' + w_File_Name);
  end;
end;


//●機能（例外無）：グリッドカラム幅を読み込む
procedure proc_Grid_ColumnSize_Read(arg_Grid: TStringGrid; arg_Name,arg_No: string; var arg_Column: TStringList);
var
  TxtFile: TextFile;
  w_File_Name: string;
  w_Record: string[255];
  w_Grid_Size: TStringList;
  w_Text_Size: TStringList;
  i: integer;
begin
//  w_File_Name := CST_PATH_GRID_COLUMNS + arg_Name + '_' + arg_No + '.txt';
  w_File_Name := gi_columndir_DIR + arg_Name + '_' + arg_No + '.txt';
  w_Grid_Size := TStringList.Create;
  w_Text_Size := TStringList.Create;
  try
    for i := 0 to (arg_Grid.ColCount - 1) do begin
      w_Grid_Size.Add(IntToStr(arg_Grid.ColWidths[i]));
    end;
    if FileExists(w_File_Name) then begin
      //１行のみ読み込む
      try
        AssignFile(TxtFile, w_File_Name);
        Reset(TxtFile);
        try
          while not Eof(TxtFile) do
          begin
            Readln(TxtFile, w_Record);
            //読み込んだ行にﾃﾞｰﾀが存在する場合
            if Length(Trim(w_Record)) > 0 then
            begin
              w_Text_Size.CommaText := w_Record;
              Break;
            end;
          end;
        finally
          CloseFile(TxtFile);
        end;
      except
        raise Exception.Create('Cannot AssignFile ' + w_File_Name);
      end;
    end;
    //カラム幅を戻す
    if w_Grid_Size.Count <> w_Text_Size.Count then begin
      arg_Column.Text := w_Grid_Size.Text;
      Exit;
    end;
    arg_Column.Text := w_Text_Size.Text;
    Exit;
  finally
    w_Grid_Size.Free;
    w_Text_Size.Free;
  end;
end;
//●機能（例外無）：グリッドカラム幅をセットする
procedure proc_Grid_ColumnSize_Set(arg_Grid: TStringGrid; arg_Name,arg_No: string);
var
  w_Cols: TStringList;
  w_Col: integer;
begin
  w_Cols := TStringList.Create;
  try
    //カラム幅読み込み
    proc_Grid_ColumnSize_Read(arg_Grid, arg_Name, arg_No, w_Cols);
    if w_Cols.Count = arg_Grid.ColCount then begin
      //幅変更
      for w_Col := 0 to (arg_Grid.ColCount - 1) do begin
        arg_Grid.ColWidths[w_Col] := StrToInt(w_Cols.Strings[w_Col]);
      end;
    end
    else begin
      //カラム幅格納
      func_Grid_ColumnSize_Write(arg_Grid, arg_Name, arg_No);
    end;
  finally
    w_Cols.Free;
  end;
end;
//2002.10.03
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 放科医師立会区分
function func_PIND_Change_ISITATIAI(arg_Code:string):string;//名称
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_ISITATIAI_0 then
    //'立会なし'
    w_Res := GPCST_ISITATIAI_0_NAME
  //arg_Code = '1'
  else if arg_Code = GPCST_ISITATIAI_1 then
    //'立会あり'
    w_Res := GPCST_ISITATIAI_1_NAME
  //arg_Code = '立会なし'
  else if arg_Code = GPCST_ISITATIAI_0_NAME then
    //'0'
    w_Res := GPCST_ISITATIAI_0
  //arg_Code = '立会あり'
  else if arg_Code = GPCST_ISITATIAI_1_NAME then
    //'1'
    w_Res := GPCST_ISITATIAI_1
  //arg_Code = ''
  else if arg_Code = '' then
    //'立会なし'
    w_Res := GPCST_ISITATIAI_0_NAME
  else
    w_Res := '';
  result:=w_Res;
end;
//2002.12.14
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 放科医師立会区分
function func_PIND_Change_ISITATIAI_RYAKU(arg_Code:string):string;//名称
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_ISITATIAI_0 then
    //'立会なし'
    w_Res := GPCST_ISITATIAI_0_RYAKU
  //arg_Code = '1'
  else if arg_Code = GPCST_ISITATIAI_1 then
    //'立会あり'
    w_Res := GPCST_ISITATIAI_1_RYAKU
  //arg_Code = '立会なし'
  else if arg_Code = GPCST_ISITATIAI_0_RYAKU then
    //'0'
    w_Res := GPCST_ISITATIAI_0
  //arg_Code = '立会あり'
  else if arg_Code = GPCST_ISITATIAI_1_RYAKU then
    //'1'
    w_Res := GPCST_ISITATIAI_1
  //arg_Code = ''
  else if arg_Code = '' then
    //'立会なし'
    w_Res := GPCST_ISITATIAI_0_RYAKU
  else
    w_Res := '';
  result:=w_Res;
end;
//2002.10.05
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 FCR連携
function func_PIND_Change_FCR(arg_Code:string):string;//名称
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_FCR_0 then
    //'不要'
    w_Res := GPCST_FCR_0_NAME
  //arg_Code = '1'
  else if arg_Code = GPCST_FCR_1 then
    //'必要'
    w_Res := GPCST_FCR_1_NAME
  //arg_Code = '不要'
  else if arg_Code = GPCST_FCR_0_NAME then
    //'0'
    w_Res := GPCST_FCR_0
  //arg_Code = '必要'
  else if arg_Code = GPCST_FCR_1_NAME then
    //'1'
    w_Res := GPCST_FCR_1
  //arg_Code = ''
  else if arg_Code = '' then
    //'不要'
    w_Res := GPCST_FCR_0_NAME
  else
    w_Res := '';
  result:=w_Res;
end;
//2002.10.05
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 MPPS対応
function func_PIND_Change_MPPS(arg_Code:string):string;//名称
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_MPPS_0 then
    //'不要'
    w_Res := GPCST_MPPS_0_NAME
  //arg_Code = '1'
  else if arg_Code = GPCST_MPPS_1 then
    //'必要'
    w_Res := GPCST_MPPS_1_NAME
  //arg_Code = '不要'
  else if arg_Code = GPCST_MPPS_0_NAME then
    //'0'
    w_Res := GPCST_MPPS_0
  //arg_Code = '必要'
  else if arg_Code = GPCST_MPPS_1_NAME then
    //'1'
    w_Res := GPCST_MPPS_1
  //arg_Code = ''
  else if arg_Code = '' then
    //'不要'
    w_Res := GPCST_MPPS_0_NAME
  else
    w_Res := '';
  result:=w_Res;
end;
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 エラー回避   2004.01.16
function func_PIND_Change_Err(arg_Code:string):string;//名称
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_ERR_0 then
    //'不要'
    w_Res := GPCST_ERR_0_NAME
  //arg_Code = '1'
  else if arg_Code = GPCST_ERR_1 then
    //'必要'
    w_Res := GPCST_ERR_1_NAME
  //arg_Code = '不要'
  else if arg_Code = GPCST_ERR_0_NAME then
    //'0'
    w_Res := GPCST_ERR_0
  //arg_Code = '必要'
  else if arg_Code = GPCST_ERR_1_NAME then
    //'1'
    w_Res := GPCST_ERR_1
  //arg_Code = ''
  else if arg_Code = '' then
    //'不要'
    w_Res := GPCST_ERR_0_NAME
  else
    w_Res := '';
  result:=w_Res;
end;
//2002.10.30
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 会計送信種別
function func_PIND_Change_KAIKEISOUSIN(arg_Code:string):string;//名称
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_KAIKEI_0 then
    //'しない'
    w_Res := GPCST_KAIKEI_0_NAME
  //arg_Code = '1'
  else if arg_Code = GPCST_KAIKEI_1 then
    //'する'
    w_Res := GPCST_KAIKEI_1_NAME
  //arg_Code = 'しない'
  else if arg_Code = GPCST_KAIKEI_0_NAME then
    //'0'
    w_Res := GPCST_KAIKEI_0
  //arg_Code = 'する'
  else if arg_Code = GPCST_KAIKEI_1_NAME then
    //'1'
    w_Res := GPCST_KAIKEI_1
  //arg_Code = ''
  else if arg_Code = '' then
    //'しない'
    w_Res := GPCST_KAIKEI_0_NAME
  else
    w_Res := '';
  result:=w_Res;
end;
//2002.11.06
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 RIオーダ区分
function func_PIND_Change_RI_ORDER(arg_Code:string):string;//名称
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_RI_ORDER_0 then
    //'なし'
    w_Res := GPCST_RI_ORDER_0_NAME
  //arg_Code = '1'
  else if arg_Code = GPCST_RI_ORDER_1 then
    //'注射'
    w_Res := GPCST_RI_ORDER_1_NAME
  //arg_Code = '2'
  else if arg_Code = GPCST_RI_ORDER_2 then
    //'検査'
    w_Res := GPCST_RI_ORDER_2_NAME
  //arg_Code = 'なし'
  else if arg_Code = GPCST_RI_ORDER_0_NAME then
    //'0'
    w_Res := GPCST_RI_ORDER_0
  //arg_Code = '注射'
  else if arg_Code = GPCST_RI_ORDER_1_NAME then
    //'1'
    w_Res := GPCST_RI_ORDER_1
  //arg_Code = '検査'
  else if arg_Code = GPCST_RI_ORDER_2_NAME then
    //'1'
    w_Res := GPCST_RI_ORDER_2
  //arg_Code = ''
  else if arg_Code = '' then
    //'なし'
    w_Res := GPCST_RI_ORDER_0_NAME
  else
    w_Res := '';
  result:=w_Res;
end;

//2002.10.21
//2002.10.23 修正 検査コメント項目名を格納
//●機能：検査種別毎のフィルタフラグ項目名の格納変数セット
function func_SetKensaTypeFilter_Flg(arg_Query: TQuery):Boolean;
var
  wi_Filter: Integer;
  ws_Count: String;
begin
  wi_Filter := 0;


  try
    with arg_Query do begin
      Close;
      SQL.Clear;
      SQL.Add ('SELECT KENSATYPE_ID ');
      SQL.Add ('FROM KensaTypeMaster ');
      SQL.Add ('ORDER BY KENSATYPE_ID');
      if not Prepared then Prepare;
      Open;
      Last;
      gi_KENSA_TYPE_FIELD_COUNT := RecordCount;

      if gi_KENSA_TYPE_FIELD_COUNT = 0 then begin
        gi_KENSA_TYPE_FIELD_COUNT := -1;
      end else begin
        SetLength(ga_KENSA_TYPE_FEILD, gi_KENSA_TYPE_FIELD_COUNT);

        First;
        //取得データを格納
        While not EOF do begin
          wi_Filter := wi_Filter + 1;
          ga_KENSA_TYPE_FEILD[wi_Filter-1].Kensa_ID         := FieldByName('KENSATYPE_ID').AsString;
          ws_Count := IntToStr(wi_Filter);
          if Length(ws_Count) = 1 then ws_Count             := '0' + ws_Count;
          ga_KENSA_TYPE_FEILD[wi_Filter-1].FilterName       := 'FILTER_FLG' + ws_Count;
          ga_KENSA_TYPE_FEILD[wi_Filter-1].KensaCommentName := 'KENSA_COMMENT_' + ws_Count;
          Next;
        end;
      end;
      Close;
    end;
    result:=True;
  except
    on E: Exception do begin
      raise;
    end;
  end;
end;
//2002.10.21
//●機能：検査種別IDでフィルタフラグ項目名を返す
function func_GetFilter_Flg_Name(arg_KensaType_ID: String):String;
var
  wi_count: Integer;
begin
  //該当する検査種別IDからフィルタフラグ項目名を指定
  for wi_count := 0 to gi_KENSA_TYPE_FIELD_COUNT -1 do begin
    if ga_KENSA_TYPE_FEILD[wi_count].Kensa_ID = arg_KensaType_ID then begin
      Result := ga_KENSA_TYPE_FEILD[wi_count].FilterName;
      Break;
    end;
  end;
end;
//2002.10.23
//●機能（例外無）：検査種別IDで検査コメント項目名を返す
function func_GetKensa_Comment_Name(arg_KensaType_ID: String):String;
var
  wi_count: Integer;
begin
  //該当する検査種別IDから検査コメント項目名を指定
  for wi_count := 0 to gi_KENSA_TYPE_FIELD_COUNT -1 do begin
    if ga_KENSA_TYPE_FEILD[wi_count].Kensa_ID = arg_KensaType_ID then begin
      Result := ga_KENSA_TYPE_FEILD[wi_count].KensaCommentName;
      Break;
    end;
  end;
end;

//2002.10.22
//●機能（例外無）：患者IDより患者情報取得
function func_KanjaInfo_Make(
         //IN
         arg_Query: TQuery;
         arg_Query2: TQuery;
         arg_KanjaID: string;
         //OUT
         var arg_SimeiKanji: string;      //漢字氏名
         var arg_SimeiKana: string;       //カナ氏名
         var arg_Sex: string;             //性別
         var arg_BirthDay: string;        //生年月日
         var arg_Age: string;             //年齢
         var arg_Byoutou_ID: string;      //病棟ID
         var arg_Byoutou: string;         //病棟名称
         var arg_Byousitu_ID: string;     //病室ID
         var arg_Byousitu: string;        //病室名称
         var arg_Kanja_Nyugaikbn: string; //患者入外区分
         var arg_Kanja_Nyugai: string;    //患者入外区分名称
         var arg_Section_ID: string;      //診療科ID
         var arg_Section: string;         //診療科
         var arg_Sincyo: string;          //身長
         var arg_Taijyu: string           //体重
        ): Boolean;
var
  w_BirthDay: TDate;
  w_Sys_Date: TDateTime;     // システム日付
begin
  Result := False;
  //患者マスタより患者情報取得取得
  try
    with arg_Query do begin
      Close;
      SQL.Clear;
      SQL.Add ('SELECT km.KANJAID, km.KANJISIMEI, km.ROMASIMEI, km.SEX, km.KANJA_NYUGAIKBN ');
      SQL.Add ('      ,km.SECTION_ID,km.BYOUTOU_ID,km.SINCYO,km.TAIJYU,km.BYOUSITU_ID,km.PROFILE_TYPES ');
      SQL.Add ('      ,Trim(TO_CHAR(km.BIRTHDAY,''00000000'')) BIRTHDAY ');
      SQL.Add ('      ,ku.KUBUN_NAME AS SEX_NAME ');
      SQL.Add ('      ,s1.SECTION_NAME AS SINRYO_NAME ');
      SQL.Add ('      ,KANASIMEI ');   //2003.12.19
      SQL.Add ('FROM  KANJAMASTER km,KUBUNMASTER ku ');
      SQL.Add ('     ,SECTIONMASTER s1 ');
      SQL.Add ('WHERE  km.KANJAID = ''' + arg_KanjaID  + '''');
    {2004.01.14 start}
      //SQL.Add ('  AND  s1.SECTION_ID  = km.SECTION_ID');
      SQL.Add ('  AND  s1.SECTION_ID(+)  = km.SECTION_ID');
    {2004.01.14 end}
      SQL.Add ('  AND  ku.KUBUN(+) = ''' + 'SEX' + '''');
      SQL.Add ('  AND  ku.KUBUN_ID(+) = km.SEX');
      if not Prepared then Prepare;
      Open;
      Last;
      First;
      if not(Eof) then begin
        //取得データを格納
        //漢字氏名
        arg_SimeiKanji := FieldByName('KANJISIMEI').AsString;
        //カナ氏名
//      arg_SimeiKana := FieldByName('ROMASIMEI').AsString; 2003.12.19
        arg_SimeiKana := FieldByName('KANASIMEI').AsString;

        //性別
        arg_Sex         := FieldByName('SEX_NAME').AsString;
        //生年月日
        //年齢
        if FieldByName('BIRTHDAY').AsString <> '' then begin
          w_BirthDay := func_StrToDate(func_Date8To10(FieldByName('BIRTHDAY').AsString));
          arg_BirthDay := FormatDateTime('YYYY/MM/DD', w_BirthDay);
          //システム日付取得
          w_Sys_Date      := func_GetDBSysDate(arg_Query2);
          arg_Age := IntToStr(func_GetAgeofCase(w_BirthDay, w_Sys_Date, 0));
        end;
        //患者入外区分チェック
        arg_Kanja_Nyugaikbn := FieldByName('KANJA_NYUGAIKBN').AsString;
        arg_Byoutou_ID      := FieldByName('BYOUTOU_ID').AsString;
        arg_Byousitu_ID     := FieldByName('BYOUSITU_ID').AsString;
        if FieldByName('KANJA_NYUGAIKBN').AsString = GPCST_NYUGAIKBN_2 then begin
          //患者入外区分(入院)
          arg_Kanja_Nyugai := GPCST_NYUGAIKBN_2_NAME;
          //病棟取得
          with arg_Query2 do begin
            Close;
            SQL.Clear;
            SQL.Add ('SELECT b1.BYOUTOU_NAME ');
            SQL.Add ('FROM  BYOUTOUMASTER b1 ');
            SQL.Add ('WHERE  b1.BYOUTOU_ID  = ''' + arg_Byoutou_ID + '''');
            if not Prepared then Prepare;
            Open;
            Last;
            First;
            //病棟名称
            arg_Byoutou  := FieldByName('BYOUTOU_NAME').AsString;
          end;
          //病棟取得
          with arg_Query2 do begin
            Close;
            SQL.Clear;
            SQL.Add ('SELECT bs.BYOUSITU_NAME ');
            SQL.Add ('FROM  BYOUSITUMASTER bs ');
            SQL.Add ('WHERE  bs.BYOUSITU_ID = ''' + arg_Byousitu_ID + '''');
            if not Prepared then Prepare;
            Open;
            Last;
            First;
            //病室名称
            arg_Byousitu     := FieldByName('BYOUSITU_NAME').AsString;
          end;
        end else
          if FieldByName('KANJA_NYUGAIKBN').AsString = GPCST_NYUGAIKBN_1 then begin
            //患者入外区分(外来)
            arg_Kanja_Nyugai := GPCST_NYUGAIKBN_1_NAME;
            //病棟名称
            arg_Byoutou      := '';
            //病室名称
            arg_Byousitu     := '';
        end;
        //診療科
        arg_Section_ID  := FieldByName('SECTION_ID').AsString;
        arg_Section     := FieldByName('SINRYO_NAME').AsString;
        //身長
        arg_Sincyo      := FieldByName('SINCYO').AsString;
        //体重
        arg_Taijyu      := FieldByName('TAIJYU').AsString;

        result:=True;
      end;
    end;
  except
    on E: Exception do begin
      raise;
    end;
  end;

end;
//●機能（例外無）：RIS識別IDより患者情報取得
function func_KanjaOrderInfo_Make(
         //IN
         arg_Query: TQuery;
         arg_Query2: TQuery;
         arg_RIS_ID: string;
         //OUT
         var arg_KanjaID: string;               //患者ID
         var arg_SimeiKanji: string;            //漢字氏名
         var arg_SimeiRoma: string;             //英字氏名
         var arg_Sex: string;                   //性別
         var arg_BirthDay: string;              //生年月日
         var arg_Age: string;                   //年齢
         var arg_Byoutou_ID: string;            //病棟ID
         var arg_Byoutou: string;               //病棟名称
         var arg_Byousitu_ID: string;           //病室ID
         var arg_Byousitu: string;              //病室名称
         var arg_Kanja_Nyugaikbn: string;       //患者入外区分
         var arg_Kanja_Nyugai_Name: string;     //患者入外区分名称
         var arg_Section_ID: string;            //診療科ID
         var arg_Section: string;               //診療科
         var arg_Sincyo: string;                //身長
         var arg_Taijyu: string;                //体重
         var arg_Irai_Name: string;             //依頼科名称
         var arg_Irai_SectionID: string;        //依頼科ID
         var arg_Denpyo_NyugaiKbn: string;      //伝票入外区分(伝票病棟)
         var arg_Denpyo_NyugaiName: string;     //伝票入外区分名称(伝票病棟)
         var arg_Denpyo_ByoutouID: string;      //伝票病棟ID
         var arg_IraiDoctor: string;            //依頼医師名
         var arg_Section_Tel1: string;          //依頼科連絡先(上４桁)
         var arg_Section_Tel2: string           //依頼科連絡先(上４桁以降)
        ): Boolean;
var
  w_BirthDay: TDate;
  w_KensaDay: TDate;
Begin
  //オーダメインマスタより患者情報取得取得
  try
    with arg_Query do begin
      Close;
      SQL.Clear;
      SQL.Add ('SELECT om.KANJAID,om.KENSA_DATE,om.KENSA_DATE_AGE,om.DENPYO_NYUGAIKBN, om.IRAI_SECTION_ID ');
      SQL.Add ('      ,om.IRAI_DOCTOR_NAME,om.DENPYO_BYOUTOU_ID ');
      SQL.Add ('      ,km.KANJAID, km.KANJISIMEI, km.ROMASIMEI, km.SEX, km.KANJA_NYUGAIKBN ');
      SQL.Add ('      ,km.SECTION_ID,km.BYOUTOU_ID,km.SINCYO,km.TAIJYU,km.BYOUSITU_ID ');
      SQL.Add ('      ,Trim(TO_CHAR(km.BIRTHDAY,''00000000'')) BIRTHDAY ');
      SQL.Add ('      ,ku.KUBUN_NAME AS SEX_NAME ');
      SQL.Add ('      ,s1.SECTION_NAME AS SINRYO_NAME,s2.SECTION_NAME AS IRAI_NAME,s2.SECTION_TEL ');
      SQL.Add ('      ,om.Irai_Doctor_Renraku  ');
      SQL.Add ('FROM  ORDERMAINTABLE om,KANJAMASTER km,KUBUNMASTER ku ');
      SQL.Add ('     ,SECTIONMASTER s1,SECTIONMASTER s2 ');
      SQL.Add ('WHERE  om.RIS_ID = ''' + arg_RIS_ID  + '''');
      SQL.Add ('  AND  om.KANJAID     = km.KANJAID');
    {2004.01.14 start}
      //SQL.Add ('  AND  s1.SECTION_ID  = km.SECTION_ID');
      //SQL.Add ('  AND  s2.SECTION_ID  = om.IRAI_SECTION_ID');
      SQL.Add ('  AND  s1.SECTION_ID(+)  = km.SECTION_ID');
      SQL.Add ('  AND  s2.SECTION_ID(+)  = om.IRAI_SECTION_ID');
    {2004.01.14 end}
      SQL.Add ('  AND  ku.KUBUN(+) = ''' + 'SEX' + '''');
      SQL.Add ('  AND  ku.KUBUN_ID(+) = km.SEX');
      if not Prepared then Prepare;
      Open;
      Last;
      First;
        //取得データを格納
        //患者ID
        arg_KanjaID := FieldByName('KANJAID').AsString;
        //漢字氏名
        arg_SimeiKanji := FieldByName('KANJISIMEI').AsString;
        //英字氏名
        arg_SimeiRoma := FieldByName('ROMASIMEI').AsString;
        //性別
        arg_Sex         := FieldByName('SEX_NAME').AsString;
        //生年月日
        if FieldByName('BIRTHDAY').AsString <> '' then begin
          w_BirthDay := func_StrToDate(func_Date8To10(FieldByName('BIRTHDAY').AsString));
          arg_BirthDay := FormatDateTime('YYYY/MM/DD', w_BirthDay);
          //年齢
          if FieldByName('KENSA_DATE').AsString <> '' then begin
            w_KensaDay := func_StrToDate(func_Date8To10(FieldByName('KENSA_DATE').AsString));
            arg_Age := IntToStr(func_GetAgeofCase(w_BirthDay, w_KensaDay, 0));
          end;
        end;
        //患者入外区分チェック
        arg_Kanja_Nyugaikbn := FieldByName('KANJA_NYUGAIKBN').AsString;
        arg_Byoutou_ID      := FieldByName('BYOUTOU_ID').AsString;
        arg_Byousitu_ID     := FieldByName('BYOUSITU_ID').AsString;
{★No.5062 2003.05.07 start★}
        arg_Section_Tel1    := '';
{★No.5062 2003.05.07 end★}
        if FieldByName('KANJA_NYUGAIKBN').AsString = GPCST_NYUGAIKBN_2 then begin
          //患者入外区分(入院)
          arg_Kanja_Nyugai_Name:= GPCST_NYUGAIKBN_2_NAME;
          //病棟取得
          with arg_Query2 do begin
            Close;
            SQL.Clear;
            SQL.Add ('SELECT b1.BYOUTOU_NAME, b1.BYOUTOU_TEL ');
            SQL.Add ('FROM  BYOUTOUMASTER b1 ');
            SQL.Add ('WHERE  b1.BYOUTOU_ID  = ''' + arg_Byoutou_ID + '''');
            if not Prepared then Prepare;
            Open;
            Last;
            First;
            //病棟名称
            arg_Byoutou      := FieldByName('BYOUTOU_NAME').AsString;
{★No.5062 2003.05.07 start★}
            //病棟連絡先
            arg_Section_Tel1 := FieldByName('BYOUTOU_TEL').AsString;
{★No.5062 2003.05.07 end★}
          end;
          //病室取得
          with arg_Query2 do begin
            Close;
            SQL.Clear;
            SQL.Add ('SELECT bs.BYOUSITU_NAME ');
            SQL.Add ('FROM  BYOUSITUMASTER bs ');
            SQL.Add ('WHERE  bs.BYOUSITU_ID = ''' + arg_Byousitu_ID + '''');
            if not Prepared then Prepare;
            Open;
            Last;
            First;
            //病室名称
            arg_Byousitu     := FieldByName('BYOUSITU_NAME').AsString;
          end;
        end else
          if FieldByName('KANJA_NYUGAIKBN').AsString = GPCST_NYUGAIKBN_1 then begin
            //患者入外区分(外来)
            arg_Kanja_Nyugai_Name := GPCST_NYUGAIKBN_1_NAME;
            //病棟名称
            arg_Byoutou      := '';
            //病室名称
            arg_Byousitu     := '';
        end;
        //診療科
        arg_Section_ID  := FieldByName('SECTION_ID').AsString;
        arg_Section     := FieldByName('SINRYO_NAME').AsString;
        //身長
        arg_Sincyo      := FieldByName('SINCYO').AsString;
        //体重
        arg_Taijyu      := FieldByName('TAIJYU').AsString;
        //依頼科
        arg_Irai_Name   := FieldByName('IRAI_NAME').AsString;
        arg_Irai_SectionID   := FieldByName('IRAI_SECTION_ID').AsString;
        //伝票入外区分チェック
        arg_Denpyo_NyugaiKbn := FieldByName('DENPYO_NYUGAIKBN').AsString;
        arg_Denpyo_ByoutouID := FieldByName('DENPYO_BYOUTOU_ID').AsString;
        if FieldByName('DENPYO_NYUGAIKBN').AsString = GPCST_NYUGAIKBN_2 then begin
          //病棟取得
          with arg_Query2 do begin
            Close;
            SQL.Clear;
            SQL.Add ('SELECT BYOUTOU_NAME ');
            SQL.Add ('FROM  BYOUTOUMASTER  ');
            SQL.Add ('WHERE  BYOUTOU_ID  = ''' + arg_Denpyo_ByoutouID + '''');
            if not Prepared then Prepare;
            Open;
            Last;
            First;
            //伝票病棟名称
            arg_Denpyo_NyugaiName := FieldByName('BYOUTOU_NAME').AsString;
          end;
        end else
        if FieldByName('DENPYO_NYUGAIKBN').AsString = GPCST_NYUGAIKBN_1 then begin
          //伝票病棟名称
          arg_Denpyo_NyugaiName := GPCST_NYUGAIKBN_1_NAME;
        end;
        //依頼医師名称
        arg_IraiDoctor  := FieldByName('IRAI_DOCTOR_NAME').AsString;
        //依頼情報連絡先/PB
//        arg_Section_Tel1 := COPY(FieldByName('SECTION_TEL').AsString,1,4);
//        arg_Section_Tel2 := COPY(FieldByName('SECTION_TEL').AsString,5,16);
{★No.5062 2003.05.07 start★}
//        arg_Section_Tel1 := FieldByName('SECTION_TEL').AsString;
        //患者入外区分(外来)の時はオーダメインの依頼科連絡先
        if FieldByName('KANJA_NYUGAIKBN').AsString = GPCST_NYUGAIKBN_1 then
          arg_Section_Tel1 := FieldByName('SECTION_TEL').AsString;
{★No.5062 2003.05.07 end★}
        arg_Section_Tel2 := FieldByName('Irai_Doctor_Renraku').AsString;
      end;
    result:=True;
  except
    on E: Exception do begin
      raise;
    end;
  end;

end;

procedure proc_Append_Log(arg_DispID:String;      //画面ID
                          arg_Disp_Name:String;    //画面名称
                          arg_Msg:String;          //処理名称
                          arg_str,arg_str2:String);//予備1.2
var
    LogFile: TextFile;
    w_Log: string;
    wBack_Name1: string;
    wBack_Name2: string;
    wBack_Name3: string;
    hd,Size: Integer;
    w_date:TDateTime;

    w_LogPath: string;
    w_Log_File:String;
    //INI情報の取得
    w_Qry:TQuery;
const
  CST_KAIGYO=#13#10;
begin
  w_Qry := TQuery.Create(nil);
  try
    w_Qry.DatabaseName := DM_DbAcc.DBs_MSter.DatabaseName;
    if arg_str <> '' then
      arg_str := StringReplace(arg_str, CST_KAIGYO, '', [rfReplaceAll]);
    if arg_str2 <> '' then
      arg_str2 := StringReplace(arg_str2, CST_KAIGYO, '', [rfReplaceAll]);

    //パス設定
    w_LogPath:=G_EnvPath;
{
    //キーの値を読む。
    w_LogPath:= func_ReadIniKeyVale(
                                   g_LOG_SECSION,
                                   g_LOG_PATH_KEY,
                                   w_LogPath);
    w_LogPath := func_ChngVal(w_LogPath);

}    // フォルダが存在していない場合にはフォルダを用意する。
    if (DirectoryExists(w_LogPath)=False) then
      ForceDirectories(w_LogPath);


    //ログファイル名決定
    w_Log_File := 'stmr.log';

    if FileExists(w_LogPath  + w_Log_File) then begin
      // ログのサイズを確認する。
      wBack_Name1 := ChangeFileExt(w_LogPath  + w_Log_File, '.bak1');
      wBack_Name2 := ChangeFileExt(w_LogPath  + w_Log_File, '.bak2');
      wBack_Name3 := ChangeFileExt(w_LogPath  + w_Log_File, '.bak3');
      hd := SysUtils.FileOpen(w_LogPath + w_Log_File, fmOpenRead or fmShareDenyWrite);
      Size := GetFileSize(hd, nil);
      FileClose(hd);
      // 一定サイズを超えた場合は、バックアップをとる。

      if Size > 600000 then
      begin
        if FileExists(wBack_Name3) then DeleteFile(PChar(wBack_Name3));
        if FileExists(wBack_Name2) then RenameFile(wBack_Name2, wBack_Name3);
        if FileExists(wBack_Name1) then RenameFile(wBack_Name1, wBack_Name2);
        RenameFile(w_LogPath + w_Log_File, wBack_Name1);
        AssignFile(LogFile, w_LogPath + w_Log_File);
        Rewrite(LogFile);
      end
      else begin
        AssignFile(LogFile,w_LogPath + w_Log_File);
        Append(LogFile);
      end;
    end
    else begin
      try
        AssignFile(LogFile,w_LogPath + w_Log_File);
        Rewrite(LogFile);
      except
        Exit;
      end;
    end;
    try
      //ｻｰﾊﾞｰの時刻所得
      w_date:= func_GetDBSysDate(w_Qry);
      //ﾛｸﾞ作成
      w_Log :=  FormatDateTime('YYYY/MM/DD HH:MM',w_date)
              +  ' 【画面】' + arg_DispID + ' '+ arg_Disp_Name  + ' 【処理】'   + arg_Msg;
      if Length(arg_str) > 0 then
        w_Log := w_Log +#13#10 +  StringOfChar(' ',17) +'【ﾒｯｾｰｼﾞ1】' + arg_str;
      if Length(arg_str2) > 0 then
        w_Log := w_Log +#13#10 +  StringOfChar(' ',17) +'【ﾒｯｾｰｼﾞ2】' + arg_str2;
      Writeln(LogFile, w_Log);
    finally
      Flush(LogFile);
      CloseFile(LogFile);
    end;
  finally
    w_Qry.Free;
  end;
end;
//●機能（例外無）：シェーマ格納ファイル名作成
function func_Make_ShemaName(arg_OrderNO,               //オーダNO
                             arg_MotoFileName: string;  //HISｼｪｰﾏ名
                             arg_Index: integer         //部位NO
                             ):string;                  //格納ﾌｧｲﾙ名
var
  w_P: integer;
  w_Kakuchosi: string;
  w_i:Integer;
begin
  Result := '';
  if arg_MotoFileName = '' then
    Exit;
  //if arg_Index = 0 then
  //  Exit;
  //2003.02.17
  w_P := 0;
  //HISｼｪｰﾏ名より拡張子位置取得
  for w_i := Length(arg_MotoFileName) downto 1 do begin
    if Copy(arg_MotoFileName,w_i,1) = '.' then begin
      w_P := w_i;
      Break;
    end;
  end;
  //HISｼｪｰﾏ名より拡張子位置取得
  //w_P := Pos('.',arg_MotoFileName);
  if w_P <= 0 then
    Exit;

  w_Kakuchosi := Copy(arg_MotoFileName,w_P,Length(arg_MotoFileName)-w_P+1);

  //格納ﾌｧｲﾙ名作成（ﾌｧｲﾙ名="ｵｰﾀﾞNO_ｼｪｰﾏ部位NO.HISｼｪｰﾏ拡張子"）
  Result := arg_OrderNO + '_' + FormatFloat('00',arg_Index) + w_Kakuchosi;
end;

//●機能（例外無）：進捗フラグによる受付番号表示・非表示値を返す
function func_GetUke_No(arg_Main,
                        arg_Sub: String
                        ):Bool;
begin
  Result := False; //非表示
  if arg_Main = GPCST_CODE_KENSIN_0 then Exit;
  if arg_Main = GPCST_CODE_KENSIN_2 then begin
//2003.01.09 SUBSTATUSの参照をNAMEからCODEに変更
//    if (arg_Sub = GPCST_NAME_KENSIN_SUB_8) or
//       (arg_Sub = GPCST_NAME_KENSIN_SUB_9) then begin
      if (arg_Sub = GPCST_CODE_KENSIN_SUB_8) or
       (arg_Sub = GPCST_CODE_KENSIN_SUB_9) then begin
      Exit;
    end;
  end;
  Result := True; //表示可能
end;
//●機能（例外無）：進捗フラグによる色のキーコードを返す
function func_GetColor_Key(arg_Main,
                           arg_Sub: String
                           ):String;
begin
  Result := '';
  //未受
  if arg_Main = GPCST_CODE_KENSIN_0 then begin
    //未受
    if arg_Sub = '' then begin
      Result := 'MIUKE';
      Exit;
    end;
    //未受＆呼出
    if arg_Sub = GPCST_CODE_KENSIN_SUB_5 then begin
      Result := 'YOBIDASI';
      Exit;
    end;
    //未受＆遅刻
    if arg_Sub = GPCST_CODE_KENSIN_SUB_6 then begin
      Result := 'TIKOKU';
      Exit;
    end;
  end;
  //受済
  if arg_Main = GPCST_CODE_KENSIN_1 then begin
    //受済
    if arg_Sub = '' then begin
      Result := 'UKEZUMI';
      Exit;
    end;
    //受済＆確保
    if arg_Sub = GPCST_CODE_KENSIN_SUB_7 then begin
      Result := 'KAKUHO';
      Exit;
    end;
  end;
  //検中
  if arg_Main = GPCST_CODE_KENSIN_2 then begin
    //検中
    if arg_Sub = '' then begin
      Result := 'KENCYUU';
      Exit;
    end;
    //検中＆再呼出
    if arg_Sub = GPCST_CODE_KENSIN_SUB_9 then begin
      Result := 'SAIYOBI';
      Exit;
    end;
    //検中＆再受付
    if arg_Sub = GPCST_CODE_KENSIN_SUB_10 then begin
      Result := 'SAIUKE';
      Exit;
    end;
    //検中＆保留
    if arg_Sub = GPCST_CODE_KENSIN_SUB_8 then begin
      Result := 'HORYUU';
      Exit;
    end;
  end;
  //検済
  if arg_Main = GPCST_CODE_KENSIN_3 then begin
    Result := 'KENZUMI';
    Exit;
  end;
  //中止
  if arg_Main = GPCST_CODE_KENSIN_4 then begin
    Result := 'CYUUSI';
    Exit;
  end;
end;
//●機能（例外無）：優先フラグによる優先名を返す
function func_GetYuusen_Name(arg_Yuusen: String):String;
begin
  Result := '';
 if arg_Yuusen = GPCST_YUUSEN_0 then begin
   Result := GPCST_YUUSEN_0_RYAKUNAME;
   Exit;
 end;
 if arg_Yuusen = GPCST_YUUSEN_1 then begin
   Result := GPCST_YUUSEN_1_RYAKUNAME;
   Exit;
 end;
 if arg_Yuusen = GPCST_YUUSEN_2 then begin
   Result := GPCST_YUUSEN_2_RYAKUNAME;
   Exit;
 end;
end;
//●機能（例外無）：ﾃﾞｼﾞﾀｲｽﾞ区分によるﾃﾞｼﾞﾀｲｽﾞ名を返す
function func_GetDejitaizu_Name(arg_Dejitaizu: String):String;
begin
  Result := '';
  if arg_Dejitaizu = GPCST_DEJITAI_0 then begin
    Result := GPCST_DEJITAI_0_NAME;
  end;
  if arg_Dejitaizu = GPCST_DEJITAI_1 then begin
    Result := GPCST_DEJITAI_1_NAME;
  end;
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
//●機能（例外無）：WAVEファイルのDirを返す
function func_GetWav_Name:String;
//var
//  w_Ini : TIniFile;
//  w_Home,w_File : String;
begin
//  w_Ini := TIniFile.Create(GetCurrentDir+'\'+ g_DOCSYS_INI_NAME);
//  try
//    w_Home := w_Ini.ReadString(g_COMMON_SECSION,g_HOMEDIR_KEY,'');
//    w_File := w_Ini.ReadString(g_DIRINF_SECSION,'wavedir','');
//    Result := StringReplace(w_File,'%HOMEDIR%',w_Home,[rfReplaceAll]);
     Result := gi_WAVEDIR_DIR;
//  finally
//    w_Ini.Free;
//  end;
end;

//******************************************************************************
//  処理概要  イベント
//  処理内容  メインステータスとサブステータスからステータスを判断する
//  引数      メイン、サブステータス:String
//  戻り値    略進捗名称
//******************************************************************************
function func_Stetas_Info_Ryaku(arg_Main_Sts,arg_Sub_Sts:String):String;
begin
  //未受
  if (arg_Main_Sts = GPCST_CODE_KENSIN_0) and (arg_Sub_Sts = '') then
    Result := GPCST_RYAKU_NAME_KENSIN_0
  //呼出
  else if (arg_Main_Sts = GPCST_CODE_KENSIN_0) and (arg_Sub_Sts = GPCST_CODE_KENSIN_SUB_5) then
    Result := GPCST_RYAKU_NAME_KENSIN_SUB_5
  //遅刻
  else if (arg_Main_Sts = GPCST_CODE_KENSIN_0) and (arg_Sub_Sts = GPCST_CODE_KENSIN_SUB_6) then
    Result := GPCST_RYAKU_NAME_KENSIN_SUB_6
  //受付済
  else if (arg_Main_Sts = GPCST_CODE_KENSIN_1) and (arg_Sub_Sts = '') then
    Result := GPCST_RYAKU_NAME_KENSIN_1
  //確保
  else if (arg_Main_Sts = GPCST_CODE_KENSIN_1) and (arg_Sub_Sts = GPCST_CODE_KENSIN_SUB_7) then
    Result := GPCST_RYAKU_NAME_KENSIN_SUB_7
  //検中　
  else if (arg_Main_Sts = GPCST_CODE_KENSIN_2) and (arg_Sub_Sts = '') then
    Result := GPCST_RYAKU_NAME_KENSIN_2
  //保留
  else if (arg_Main_Sts = GPCST_CODE_KENSIN_2) and (arg_Sub_Sts = GPCST_CODE_KENSIN_SUB_8) then
    Result := GPCST_RYAKU_NAME_KENSIN_SUB_8
  //再呼
  else if (arg_Main_Sts = GPCST_CODE_KENSIN_2) and (arg_Sub_Sts = GPCST_CODE_KENSIN_SUB_9) then
    Result := GPCST_RYAKU_NAME_KENSIN_SUB_9
  //再受
  else if (arg_Main_Sts = GPCST_CODE_KENSIN_2) and (arg_Sub_Sts = GPCST_CODE_KENSIN_SUB_10) then
    Result := GPCST_RYAKU_NAME_KENSIN_SUB_10
  //検済
  else if (arg_Main_Sts = GPCST_CODE_KENSIN_3) and (arg_Sub_Sts = '') then
    Result := GPCST_RYAKU_NAME_KENSIN_3
  //中止
  else if (arg_Main_Sts = GPCST_CODE_KENSIN_4) and (arg_Sub_Sts = '') then
    Result := GPCST_RYAKU_NAME_KENSIN_4;
end;
//******************************************************************************
//  処理概要  他検査取得イベント
//  処理内容  グリッドに表示する他検査項目についての処理
//  引数      RIS ID,患者ID、検査日:String yyyymmdd
//  戻り値    他検査
//******************************************************************************
function func_Make_Takensa(arg_RIS_ID,arg_KanjaID,arg_Date:String):String;
var
  w_Qry:TQuery;
  ws_Kensa_Name:String;
  ws_Kensa_Shuberu_Ryaku:String;
  ws_Line,ws_Line1:String;
  w_i:Integer;
  ws_Kensa_Flg,ws_Kensa_Status_Flg,ws_KensaSub_Status_Flg:String;
begin
  w_Qry := TQuery.Create(Nil);
  try
    w_Qry.DatabaseName := DM_DbAcc.DBs_MSter.DatabaseName;
    //オーダメインから情報の取得
    with w_Qry do begin
      //閉じる
      Close;
      //前回SQL文のクリア
      SQL.Clear;
      //SQL文作成
      SQL.Add('SELECT Exm.KanjaID,Exm.RIS_ID,Exm.Kensa_Date, ');
      SQL.Add('       Exm.Call_Tikoku_Date,Exm.Uketuke_Update_Date,Exm.Kensa_Horyuu_Date,Exm.Jisseki_Update_Date, ');
      SQL.Add('       Exm.KensaSubStatus_Flg,Exm.KensaStatus_Flg,  ');
      SQL.Add('       NVL(Exm.KensaSubStatus_Flg,Exm.KensaStatus_Flg) As KensaStatus,  ');
      SQL.Add('       Km.KENSATYPE_RYAKUNAME, ');
      SQL.Add('       Orm.Kensa_StartTime ');
      SQL.Add('FROM EXMAINTABLE Exm, ORDERMAINTABLE Orm, KensaTypeMaster Km');
      SQL.Add('WHERE Exm.KanjaID = :PKanjaID');
      SQL.Add('  AND Exm.RIS_ID <> :PRIS_ID');
      SQL.Add('  AND Exm.Kensa_Date = :PKensa_Date');
      SQL.Add('  AND Exm.KENSATYPE_ID = Km.KENSATYPE_ID(+) ');
      SQL.Add('  AND Exm.RIS_ID = Orm.RIS_ID');
      SQL.Add('ORDER BY Orm.Kensa_StartTime,Km.KENSATYPE_ID ');

      //問い合わせ確認
      if not Prepared then
        //問い合わせ処理
        Prepare;
      //RIS識別ID
      ParamByName('PRIS_ID').AsString := arg_RIS_ID;
      ParamByName('PKanjaID').AsString := arg_KanjaID;
      ParamByName('PKensa_Date').AsString := arg_Date;
      //開く
      Open;
      //最後のレコードに移動
      Last;
      //最初のレコードに移動
      First;
      //データなし
      if (w_Qry.RecordCount = 0)  then
        //処理終了
        Exit
      else begin
        ws_Line:='';
        for w_i := 1 to w_Qry.RecordCount do begin
          ws_Kensa_Shuberu_Ryaku := '';
          ws_Kensa_Name := '';
          //検査時刻
          ws_Kensa_Flg := w_Qry.FieldByName('KensaStatus').AsString;
          ws_Kensa_Status_Flg := w_Qry.FieldByName('KensaStatus_Flg').AsString;
          ws_KensaSub_Status_Flg := w_Qry.FieldByName('KensaSubStatus_Flg').AsString;
          //検査種別略称
          ws_Kensa_Shuberu_Ryaku := w_Qry.FieldByName('KensaType_RyakuName').AsString;
          //検査進捗
          ws_Kensa_Name := func_Stetas_Info_Ryaku(ws_Kensa_Status_Flg,ws_KensaSub_Status_Flg);
          ws_Line1 := '';
          ws_Line1 := ws_Kensa_Shuberu_Ryaku + ws_Kensa_Name;
          if w_i = 1 then
            ws_Line := ws_Line1
          else
            ws_Line :=  ws_Line + ' ' +ws_Line1;
          Next;
        end;
      end;

    end;
  finally
    if w_Qry <> Nil then begin
      w_Qry.Close;
      w_Qry.Free;
    end;

  end;
  Result := ws_Line;
end;
//******************************************************************************
//  処理概要  他検査取得イベント   2003.10.07
//  処理内容  グリッドに表示する他検査項目についての処理
//  引数      RIS ID,患者ID,検査日,メイン進捗,サブ進捗:String yyyymmdd
//  戻り値    他検査,他検中フラグ
//******************************************************************************
function func_Make_Takensa2(arg_RIS_ID,arg_KanjaID,arg_Date,
                            arg_Main,arg_Sub:String;
                            var arg_v_takenchuu:String):String;
var
  w_Qry:TQuery;
  ws_Kensa_Name:String;
  ws_Kensa_Shuberu_Ryaku:String;
  ws_Line,ws_Line1:String;
  w_i:Integer;
  ws_Kensa_Flg,ws_Kensa_Status_Flg,ws_KensaSub_Status_Flg:String;
begin
  w_Qry := TQuery.Create(Nil);
  arg_v_takenchuu := '';
  try
    w_Qry.DatabaseName := DM_DbAcc.DBs_MSter.DatabaseName;
    //オーダメインから情報の取得
    with w_Qry do begin
      //閉じる
      Close;
      //前回SQL文のクリア
      SQL.Clear;
      //SQL文作成
      SQL.Add('SELECT Exm.KanjaID,Exm.RIS_ID,Exm.Kensa_Date, ');
      SQL.Add('       Exm.Call_Tikoku_Date,Exm.Uketuke_Update_Date,Exm.Kensa_Horyuu_Date,Exm.Jisseki_Update_Date, ');
      SQL.Add('       Exm.KensaSubStatus_Flg,Exm.KensaStatus_Flg,  ');
      SQL.Add('       NVL(Exm.KensaSubStatus_Flg,Exm.KensaStatus_Flg) As KensaStatus,  ');
      SQL.Add('       Km.KENSATYPE_RYAKUNAME, ');
      SQL.Add('       Orm.Kensa_StartTime ');
      SQL.Add('FROM EXMAINTABLE Exm, ORDERMAINTABLE Orm, KensaTypeMaster Km');
      SQL.Add('WHERE Exm.KanjaID = :PKanjaID');
      SQL.Add('  AND Exm.RIS_ID <> :PRIS_ID');
      SQL.Add('  AND Exm.Kensa_Date = :PKensa_Date');
      SQL.Add('  AND Exm.KENSATYPE_ID = Km.KENSATYPE_ID(+) ');
      SQL.Add('  AND Exm.RIS_ID = Orm.RIS_ID');
      SQL.Add('ORDER BY Orm.Kensa_StartTime,Km.KENSATYPE_ID ');

      //問い合わせ確認
      if not Prepared then
        //問い合わせ処理
        Prepare;
      //RIS識別ID
      ParamByName('PRIS_ID').AsString := arg_RIS_ID;
      ParamByName('PKanjaID').AsString := arg_KanjaID;
      ParamByName('PKensa_Date').AsString := arg_Date;
      //開く
      Open;
      //最後のレコードに移動
      Last;
      //最初のレコードに移動
      First;
      //データなし
      if (w_Qry.RecordCount = 0)  then
        //処理終了
        Exit
      else begin
        ws_Line:='';
        for w_i := 1 to w_Qry.RecordCount do begin
          ws_Kensa_Shuberu_Ryaku := '';
          ws_Kensa_Name := '';
          //検査時刻
          ws_Kensa_Flg := w_Qry.FieldByName('KensaStatus').AsString;
          ws_Kensa_Status_Flg := w_Qry.FieldByName('KensaStatus_Flg').AsString;
          ws_KensaSub_Status_Flg := w_Qry.FieldByName('KensaSubStatus_Flg').AsString;
          //検査種別略称
          ws_Kensa_Shuberu_Ryaku := w_Qry.FieldByName('KensaType_RyakuName').AsString;
          //検査進捗
          ws_Kensa_Name := func_Stetas_Info_Ryaku(ws_Kensa_Status_Flg,ws_KensaSub_Status_Flg);
          ws_Line1 := '';
          ws_Line1 := ws_Kensa_Shuberu_Ryaku + ws_Kensa_Name;
          if w_i = 1 then
            ws_Line := ws_Line1
          else
            ws_Line :=  ws_Line + ' ' +ws_Line1;
          if ((arg_Main = GPCST_CODE_KENSIN_0) and (arg_Sub = '')) or
             (arg_Sub = GPCST_CODE_KENSIN_SUB_5) or
             ((arg_Main = GPCST_CODE_KENSIN_1) and (arg_Sub = '')) then
          begin
            if ((ws_Kensa_Status_Flg = GPCST_CODE_KENSIN_2) and
                (ws_KensaSub_Status_Flg = '')) or
              (ws_KensaSub_Status_Flg = GPCST_CODE_KENSIN_SUB_5) or
              (ws_KensaSub_Status_Flg = GPCST_CODE_KENSIN_SUB_7) then
            begin
              arg_v_takenchuu := '1';
            end;
          end;

          Next;
        end;
      end;

    end;
  finally
    if w_Qry <> Nil then begin
      w_Qry.Close;
      w_Qry.Free;
    end;

  end;
  Result := ws_Line;
end;
//******************************************************************************
//  処理概要  検査種別毎の単票の帳票No    ネームカード
//  処理内容  検査種別IDで使用する単票の帳票Noを取得
//  引数      検査種別ID
//  戻り値    単票の帳票No
//　修正：2003.12.30
//        聖マリアンナ用にﾈｰﾑｶｰﾄﾞから単票用に変更。
//******************************************************************************
function func_Get_NameCard_ID_No(arg_KensaTypeID:string): string;
begin
  Result := '';
  //Portable指示票
  if arg_KensaTypeID = GPCST_SYUBETU_13 then begin //ｵﾍﾟ室ﾎﾟｰﾀﾌﾞﾙ
    Result := '201';
  end else
  //RI患者指示票
  if arg_KensaTypeID = GPCST_SYUBETU_07 then begin   //RI
    Result := '202';
  end else begin
  //フィルム整理表
    Result := '203';
  end;

end;
function func_Get_UketukePrint_No(arg_KensaTypeID:string): Boolean;
begin

  Result := False;
  if (arg_KensaTypeID = GPCST_SYUBETU_01) or  //一般
     (arg_KensaTypeID = GPCST_SYUBETU_03) or  //透視
     (arg_KensaTypeID = GPCST_SYUBETU_05) or  //CT
     (arg_KensaTypeID = GPCST_SYUBETU_06) or  //MR
     (arg_KensaTypeID = GPCST_SYUBETU_10) or  //骨塩
     (arg_KensaTypeID = GPCST_SYUBETU_12) or  //特殊検査
     (arg_KensaTypeID = GPCST_SYUBETU_08) or  //血管
     (arg_KensaTypeID = GPCST_SYUBETU_09) or  //治療 　
     (arg_KensaTypeID = GPCST_SYUBETU_14) or  //治療位置決め
     //2004.05.03 (arg_KensaTypeID = GPCST_SYUBETU_15)     //治療位置決めCT
     (arg_KensaTypeID = GPCST_SYUBETU_15) or  //治療位置決めCT
     (arg_KensaTypeID = GPCST_SYUBETU_31) or  //救命一般
     (arg_KensaTypeID = GPCST_SYUBETU_07) or  //核医学
     (arg_KensaTypeID = GPCST_SYUBETU_38) or  //別館血管
     (arg_KensaTypeID = GPCST_SYUBETU_35)     //別館CT
  then Result := True;

end;
//******************************************************************************
//  処理概要  帳票毎のダイレクト印刷フラグを取得
//  処理内容  帳票Noで帳票マスタよりダイレクト印刷フラグを取得
//  引数      接続済みクエリー、帳票No
//  戻り値    ダイレクト印刷フラグ
//******************************************************************************
function func_Get_DirectFlg(
                    arg_Query: TQuery;
                    arg_CyohyouNo: string):string;
var
  w_CyohyouNo:string;
begin
  Result := '';

  w_CyohyouNo := arg_CyohyouNo;
  if (arg_CyohyouNo = '103A') or
     (arg_CyohyouNo = '103B') or
     (arg_CyohyouNo = '103C') or
     (arg_CyohyouNo = '103D') then begin
    w_CyohyouNo := '103';
  end;

  try
    with arg_Query do begin
      //閉じる
      Close;
      //前回SQL文のクリア
      SQL.Clear;
      //SQL文作成
      SQL.Add('SELECT * ');
      SQL.Add('FROM CYOHYOUMASTER ');
      SQL.Add('WHERE CYOHYOU_NO = :CYOHYOU_NO');
      //問い合わせ確認
      if not Prepared then Prepare;
      //帳票No
      ParamByName('CYOHYOU_NO').AsString := w_CyohyouNo;
      //開く
      Open;
      //最後のレコードに移動
      Last;
      //最初のレコードに移動
      First;
      if not(Eof) then begin
        Result := FieldByName('DEFAULT_FLG').AsString;
      end;
    end;
  finally
    arg_Query.Close;
  end;
end;
//******************************************************************************
//  処理概要  各業務毎有効な種別のみを取り出す
//  処理内容  端末毎にイニシャル設定された種別から各業務毎有効な種別のみを取り出す
//  引数      画面ID、カンマ区切りの検査種別ID
//  戻り値    カンマ区切りの検査種別ID
//  修正：2003.12.07：谷川
//                    検査種別を聖マリアンナ用に変更
//******************************************************************************
function func_Check_Initiali_Kensa(
                 arg_PrgId: string;
                 arg_Initiali_Kensa: string): string;
var
  w_Strs : TStrings;
  w_i: Integer;
  w_ret: Integer;
  w_Return:string;
begin

  Result := '';

  w_Return := '';

  if arg_Initiali_Kensa = '' then Exit;

  w_Strs := TStringList.Create;

  try
    try
      w_Strs := func_StrToTStrList(arg_Initiali_Kensa);
      w_ret := w_Strs.Count;
    except
      w_ret := 0;
    end;

    if w_ret = 0 then Exit;

    //撮影業務
    if arg_PrgId = 'G1' then begin
      for w_i := 0 to w_Strs.Count -1 do begin
{2003.12.07
        if (w_Strs[w_i] = GPCST_SYUBETU_01) or
           (w_Strs[w_i] = GPCST_SYUBETU_02) or
           (w_Strs[w_i] = GPCST_SYUBETU_04) or
           (w_Strs[w_i] = GPCST_SYUBETU_05) or
           (w_Strs[w_i] = GPCST_SYUBETU_06) then begin}
        //2003.12.19変更
        if (w_Strs[w_i] = GPCST_SYUBETU_01) or            //一般
           (w_Strs[w_i] = GPCST_SYUBETU_12) or            //特殊検査
           (w_Strs[w_i] = GPCST_SYUBETU_14) or            //治療位置決め
           (w_Strs[w_i] = GPCST_SYUBETU_31) then begin    //救命一般
          if w_Return <> '' then
            w_Return := w_Return + ',' + w_Strs[w_i]
          else
            w_Return := w_Return + w_Strs[w_i];
        end;
      end;
    end else
    //検査業務
    if arg_PrgId = 'H1' then begin
      for w_i := 0 to w_Strs.Count -1 do begin
{2003.12.07
        if (w_Strs[w_i] = GPCST_SYUBETU_07) or
           (w_Strs[w_i] = GPCST_SYUBETU_08) or
           (w_Strs[w_i] = GPCST_SYUBETU_09) or
           (w_Strs[w_i] = GPCST_SYUBETU_10) or
           (w_Strs[w_i] = GPCST_SYUBETU_11) or
           (w_Strs[w_i] = GPCST_SYUBETU_12) then begin}
        //2003.12.19変更
        if (w_Strs[w_i] = GPCST_SYUBETU_03) or           //透視
           (w_Strs[w_i] = GPCST_SYUBETU_10) or           //骨塩
           (w_Strs[w_i] = GPCST_SYUBETU_08) or           //血管
           (w_Strs[w_i] = GPCST_SYUBETU_05) or           //CT
           (w_Strs[w_i] = GPCST_SYUBETU_06) or           //MR
           (w_Strs[w_i] = GPCST_SYUBETU_09) or           //治療
           (w_Strs[w_i] = GPCST_SYUBETU_15) or           //治療位置決めCT
           (w_Strs[w_i] = GPCST_SYUBETU_38) or           //救命血管
           (w_Strs[w_i] = GPCST_SYUBETU_35) then begin   //救命CT
          if w_Return <> '' then
            w_Return := w_Return + ',' + w_Strs[w_i]
          else
            w_Return := w_Return + w_Strs[w_i];
        end;
      end;
    end else
    //Portable業務 2003.12.19
    if arg_PrgId = 'J1' then begin
      for w_i := 0 to w_Strs.Count -1 do begin
        if (w_Strs[w_i] = GPCST_SYUBETU_01) or           //一般
           (w_Strs[w_i] = GPCST_SYUBETU_12) or           //特殊検査
           (w_Strs[w_i] = GPCST_SYUBETU_14) or           //治療位置決め
           (w_Strs[w_i] = GPCST_SYUBETU_31) or           //救命一般
           (w_Strs[w_i] = GPCST_SYUBETU_13) then begin   //ｵﾍﾟ室ﾎﾟｰﾀﾌﾞﾙ
          if w_Return <> '' then
            w_Return := w_Return + ',' + w_Strs[w_i]
          else
            w_Return := w_Return + w_Strs[w_i];
        end;
      end;
    end else
    //RI業務
    if arg_PrgId = 'K1' then begin
      for w_i := 0 to w_Strs.Count -1 do begin
//      if (w_Strs[w_i] = GPCST_SYUBETU_13) then begin 2003.12.07
        if (w_Strs[w_i] = GPCST_SYUBETU_07) then begin //2003.12.19
          if w_Return <> '' then
            w_Return := w_Return + ',' + w_Strs[w_i]
          else
            w_Return := w_Return + w_Strs[w_i];
        end;
      end;
    end else
    //プレチェック 2004.01.04
    if arg_PrgId = 'E1' then begin
      for w_i := 0 to w_Strs.Count -1 do begin
        if (w_Strs[w_i] = GPCST_SYUBETU_03) or           //透視
           (w_Strs[w_i] = GPCST_SYUBETU_10) or           //骨塩
           (w_Strs[w_i] = GPCST_SYUBETU_08) or           //血管
           (w_Strs[w_i] = GPCST_SYUBETU_05) or           //CT
           (w_Strs[w_i] = GPCST_SYUBETU_06) or           //MR
           (w_Strs[w_i] = GPCST_SYUBETU_07) or           //核医学
           (w_Strs[w_i] = GPCST_SYUBETU_09) or           //治療
           (w_Strs[w_i] = GPCST_SYUBETU_15) or           //治療位置決めCT
           (w_Strs[w_i] = GPCST_SYUBETU_38) or           //救命血管
           (w_Strs[w_i] = GPCST_SYUBETU_35) then begin   //救命CT
          if w_Return <> '' then
            w_Return := w_Return + ',' + w_Strs[w_i]
          else
            w_Return := w_Return + w_Strs[w_i];
        end;
      end;
    end else
    //その他
    begin
      w_Return := arg_Initiali_Kensa;
    end;

    Result := w_Return;
  finally
    w_Strs.Free;
  end;

end;
//******************************************************************************
//  処理概要  各業務毎有効な実施装置のみを取り出す
//  処理内容  端末毎にイニシャル設定された実施装置から種別に紐付く有効な実施装置のみを取り出す
//  引数      画面ID、接続済みクエリ、カンマ区切りの検査種別ID、カンマ区切りの検査機器ID
//  戻り値    カンマ区切りの検査機器ID
//  修正：2003.12.07：谷川
//                    聖マリアンナ用に検査種別を変更。
//******************************************************************************
function func_Check_Initiali_Souti(
                 arg_PrgId: string;
                 arg_Query: TQuery;
                 arg_Initiali_Kensa: string;
                 arg_Initiali_Souti: string): string;
var
  w_StrsK,w_StrsS : TStrings;
  w_i,w_j,w_Exists: Integer;
  w_ret: Integer;
  w_Filter:string;
  w_Return:string;
begin

  Result := '';

  w_Return := '';

  if arg_Initiali_Souti = '' then Exit;
  
  w_StrsS := TStringList.Create;

  try
    try
      w_StrsS := func_StrToTStrList(arg_Initiali_Souti);
      w_ret := w_StrsS.Count;
    except
      w_ret := 0;
    end;

    if w_ret = 0 then Exit;

    with arg_Query do begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT KENSAKIKI_ID FROM KENSAKIKIMASTER ');

      if arg_Initiali_Kensa = '' then begin
        //撮影業務
        if arg_PrgId = 'G1' then begin
{2003.12.07
          SQL.Add(' WHERE (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_01) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_02) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_04) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_05) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_06) + ' = ''1'') ');}
          //2003.12.19
          SQL.Add(' WHERE (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_01) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_12) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_14) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_31) + ' = ''1'') ');
        end else
        //検査業務
        if arg_PrgId = 'H1' then begin
{2003.12.07
          SQL.Add(' WHERE (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_07) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_08) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_09) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_10) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_11) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_12) + ' = ''1'') ');}
          //2003.12.19
          SQL.Add(' WHERE (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_03) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_10) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_08) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_05) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_06) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_09) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_15) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_38) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_35) + ' = ''1'') ');
        end else
        //Portable業務
        if arg_PrgId = 'J1' then begin
//          SQL.Add(' WHERE (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_03) + ' = ''1'') '); 2003.12.08
          //2003.12.19
          SQL.Add(' WHERE (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_01) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_12) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_14) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_31) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_13) + ' = ''1'') ');
        end else
        //プレチェック
        if arg_PrgId = 'E1' then begin
          SQL.Add(' WHERE (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_03) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_10) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_08) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_05) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_06) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_07) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_09) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_15) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_38) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_35) + ' = ''1'') ');
        end else
        //RI業務
        if arg_PrgId = 'K1' then begin
//        SQL.Add(' WHERE (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_13) + ' = ''1'') '); 2003.12.07
          //2003.12.19
          SQL.Add(' WHERE (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_07) + ' = ''1'') ');
        end;

      end else
      begin
        w_StrsK := TStringList.Create;
        try
          try
            w_StrsK := func_StrToTStrList(arg_Initiali_Kensa);
            w_ret := w_StrsK.Count;
          except
            w_ret := 0;
          end;

          if w_ret = 0 then Exit;

          w_j := 0;

          for w_i := 0 to w_StrsK.Count -1 do begin
            w_Filter := func_GetFilter_Flg_Name(w_StrsK[w_i]);

            if w_Filter <> '' then begin
              w_j := w_j + 1;
              if w_j = 1 then begin
                SQL.Add('WHERE (' + w_Filter + ' = ''1'')');
              end else begin
                SQL.Add('   OR (' + w_Filter + ' = ''1'')');
              end;
            end;
          end;
        finally
          w_StrsK.Free;
        end;
      end;

      SQL.Add('ORDER BY DISP_CODE ');

      //問い合わせ確認
      if not Prepared then Prepare;
      Open;
      //最後のレコードに移動
      Last;
      //最初のレコードに移動
      First;
      w_Exists := 0;
      while not(Eof) do begin
        for w_i := 0 to w_StrsS.Count-1 do begin
          if w_StrsS[w_i] = FieldByName('KENSAKIKI_ID').AsString then begin
            if w_Return <> '' then
              w_Return := w_Return + ',' + FieldByName('KENSAKIKI_ID').AsString
            else
              w_Return := w_Return + FieldByName('KENSAKIKI_ID').AsString;
            w_Exists := w_Exists + 1;
            Break;
          end;
        end;
        Next;
      end;
      if RecordCount = w_Exists then begin
        w_Return := '';
      end;
    end;

    Result := w_Return;
  finally
    w_StrsS.Free;
  end;

end;
//2003.10.06 Start**************************************************************
//******************************************************************************
//●機能（例外無）：グリッドカラム幅を書き込む
//******************************************************************************
function func_Gkit_ColumnSize_Write(arg_GGrid: TGKitSpreadControl; arg_Name,arg_No: string):Boolean;
var
  TxtFile: TextFile;
  w_Dir_Name: string;
  w_File_Name: string;
  w_Record: string[255];
  i: integer;
begin
  Result := True;
  w_File_Name := gi_columndir_DIR + arg_Name + '_' + arg_No + '.txt';
  w_Dir_Name  := ExtractFileDir(w_File_Name);
  if not(DirectoryExists(w_Dir_Name)) then begin
    if not(CreateDir(w_Dir_Name)) then begin
      Exit;
    end;
  end;

  w_Record := '';
  w_Record := arg_GGrid.ColsWidth;
  //書き込み
  try
    AssignFile(TxtFile, w_File_Name);
    Rewrite(TxtFile);
    try
      Writeln(TxtFile, w_Record);
    finally
      Flush(TxtFile);
      CloseFile(TxtFile);
    end;
  except
    raise Exception.Create('Cannot AssignFile ' + w_File_Name);
  end;
end;
//******************************************************************************
//●機能（例外無）：グリッドカラム幅を読み込む
//******************************************************************************
procedure proc_Gkit_ColumnSize_Read(arg_GGrid: TGKitSpreadControl; arg_Name,arg_No: string; var arg_Column: string);
var
  TxtFile: TextFile;
  w_File_Name: string;
  w_Record: string[255];
begin
  w_File_Name := gi_columndir_DIR + arg_Name + '_' + arg_No + '.txt';
  try
    if FileExists(w_File_Name) then begin
      //１行のみ読み込む
      try
        AssignFile(TxtFile, w_File_Name);
        Reset(TxtFile);
        try
          while not Eof(TxtFile) do begin
            Readln(TxtFile, w_Record);
            //読み込んだ行にﾃﾞｰﾀが存在する場合
            if Length(Trim(w_Record)) > 0 then begin
              arg_Column := w_Record;
              Break;
            end;
          end;
        finally
          CloseFile(TxtFile);
        end;
      except
        raise Exception.Create('Cannot AssignFile ' + w_File_Name);
      end;
    end;
  finally
  end;
end;
//******************************************************************************
//●機能（例外無）：グリッドカラム幅をセットする
//******************************************************************************
procedure proc_Gkit_ColumnSize_Set(arg_GGrid: TGKitSpreadControl; arg_Name,arg_No: string);
var
  w_Cols: string;
begin
  try
    //カラム幅読み込み
    proc_Gkit_ColumnSize_Read(arg_GGrid, arg_Name, arg_No, w_Cols);
    if w_Cols <> '' then begin
      arg_GGrid.ColsWidth := w_Cols;
    end;
  finally
  end;
end;
//2003.10.06 end**************************************************************

//2003.12.11*********************************************************************
//●機能（例外無）：伝票印刷フラグの更新
//******************************************************************************
function func_Update_Denpyo_Insatu_flg(arg_DB:TDatabase          //ﾃﾞｰﾀﾍﾞｰｽ
                                       ;arg_Key_RIS_ID:string     //RIS_ID (複数カンマ区切り)
                                       ;var arg_Err:string
                                       ): Boolean;
var
  w_RisID_List:TStrings;
  w_Qry:TQuery;
  i:Integer;
  ws_RisID:String;
begin
  Result := True;

  if arg_Key_RIS_ID = '' then Exit;

  w_RisID_List := TStringList.Create;
  w_Qry := TQuery.Create(nil);
  try
    w_Qry.DatabaseName := arg_DB.DatabaseName;

    w_RisID_List.CommaText := arg_Key_RIS_ID;

    arg_DB.StartTransaction;
    for i:= 0 to w_RisID_List.Count -1 do begin
      ws_RisID := w_RisID_List[i];
      with w_Qry do begin
        Close;
        SQL.Clear;
        SQL.Add('UPDATE ORDERMAINTABLE SET ');
        SQL.Add('DENPYO_INSATU_FLG = :PDENPYO_INSATU_FLG ');
        SQL.Add('WHERE RIS_ID = :PRISID');

        ParamByName('PRISID').AsString := ws_RisID;

        ParamByName('PDENPYO_INSATU_FLG').AsString := GPCST_DENPYO_INSATU_FLG_1;
        //書き込み
        try
          ExecSQL;
        except
          Raise;
        end;
      end;
    end;
    try
      arg_DB.Commit; // 成功した場合，変更をコミットする
    except
      on E: Exception do begin
        arg_DB.Rollback; // コミットで失敗した場合，変更を取り消す
        arg_Err := E.Message;
        Result := False;
      end;
    end;
  finally
    FreeAndNil(w_RisID_List);
    FreeAndNil(w_Qry);
  end;

end;

//2004.03.11*********************************************************************
//●機能（例外無）：伝票印刷フラグの更新 (核医学用)
//******************************************************************************
function func_Update_Denpyo_Insatu_flg_RI(arg_DB:TDatabase          //ﾃﾞｰﾀﾍﾞｰｽ
                                       ;arg_Key_RIS_ID:string     //RIS_ID (複数カンマ区切り)
                                       ;var arg_Err:string
                                       ): Boolean;
var
  w_RisID_List:TStrings;
  w_Qry:TQuery;
  i:Integer;
  ws_RisID:String;
begin
  Result := True;

  if arg_Key_RIS_ID = '' then Exit;

  w_RisID_List := TStringList.Create;
  w_Qry := TQuery.Create(nil);
  try
    w_Qry.DatabaseName := arg_DB.DatabaseName;

    w_RisID_List.CommaText := arg_Key_RIS_ID;

    arg_DB.StartTransaction;
    for i:= 0 to w_RisID_List.Count -1 do begin
      ws_RisID := w_RisID_List[i];
      with w_Qry do begin
        Close;
        SQL.Clear;
        SQL.Add('UPDATE ORDERMAINTABLE SET ');
        SQL.Add('DENPYO_INSATU_FLG = to_number(nvl(DENPYO_INSATU_FLG,''0''))+1 ');
        SQL.Add('WHERE RIS_ID = :PRISID');

        ParamByName('PRISID').AsString := ws_RisID;

        //書き込み
        try
          ExecSQL;
        except
          Raise;
        end;
      end;
    end;
    try
      arg_DB.Commit; // 成功した場合，変更をコミットする
    except
      on E: Exception do begin
        arg_DB.Rollback; // コミットで失敗した場合，変更を取り消す
        arg_Err := E.Message;
        Result := False;
      end;
    end;
  finally
    FreeAndNil(w_RisID_List);
    FreeAndNil(w_Qry);
  end;

end;

//2004.01.13
function func_GyoumuKbn_Check(arg_KensaType:string; //検査種別
                              arg_Query:TQuery      //Query
                              ):string;
var
  w_Today:TDateTime; //日付+時刻
  w_Date:TDate; //日にち
  w_Time:TTime; //時刻
  w_Day:string; //日数部分
  w_Week:integer; //1:日 2:月... 7：土 8：祭日

  //2004.05.12
  wi_Time:integer; //時刻（数字型）
begin
//
  //現在時刻取得
  w_Today:=func_GetDBSysDate(arg_Query);
  w_Week:=DayOfWeek(w_Today);
  w_Date:=StrToDate(Copy(DateTimeToStr(w_Today),1,10));
  w_Time:=StrToTime(Copy(DateTimeToStr(w_Today),12,8));

  //2004.05.12
  //現在時刻（数字型）
  wi_Time:=StrToint(FormatDateTime('hhnnss',w_Today));

  //祭日チェック
  with arg_Query do begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT HIZUKE ');
    SQL.Add('  FROM CalendarMaster ');
    SQL.Add(' WHERE HIZUKE=:PHIZUKE ');
    SQL.Add('  ');
    ParamByName('PHIZUKE').AsString:=DateToStr(w_Today);
    if not Prepared then Prepare;
    Open;
    Last;
    First;
    if RecordCount>0 then begin
      //祭日
      w_Week:=8;
    end;
  end;

  if w_Week = 8 then begin
    //祭日
    //日付取得
    //if (StrToTime(CST_GYOKBN_SAI_2_S)<=w_Time) and (w_Time<=StrToTime(CST_GYOKBN_SAI_2_E)) then begin
    //文字列で判定(1/1000秒を比較できない為)2004.05.12
    if (StrToInt(func_Time8To6(CST_GYOKBN_SAI_2_S))<= wi_Time) and (wi_Time<=StrToInt(func_Time8To6(CST_GYOKBN_SAI_2_E))) then begin
      //当直
      Result:=GSPCST_GYOUMU_KBN_2;
      Exit;
    end
    //2004.05.12 else if (StrToTime(CST_GYOKBN_SAI_3_S)<=w_Time) and (w_Time<=StrToTime(CST_GYOKBN_SAI_3_E)) then begin
    //文字列で判定(1/1000秒を比較できない為)2004.05.12
    else if (StrToInt(func_Time8To6(CST_GYOKBN_SAI_3_S))<=wi_Time) and (wi_Time<=StrToInt(func_Time8To6(CST_GYOKBN_SAI_3_E))) then begin
      //深夜
      Result:=GSPCST_GYOUMU_KBN_3;
      Exit;
    end
    else begin
      //2004.05.12 //緊急
      //2004.05.12 Result:=GSPCST_GYOUMU_KBN_4;
      //日勤
      Result:=GSPCST_GYOUMU_KBN_1;
      Exit;
    end;
  end
  else if w_Week = 1 then begin
    //日曜日
    //2004.05.12 if (StrToTime(CST_GYOKBN_SUN_2_S)<=w_Time) and (w_Time<=StrToTime(CST_GYOKBN_SUN_2_E)) then begin
    //文字列で判定(1/1000秒を比較できない為)2004.05.12
    if (StrToInt(func_Time8To6(CST_GYOKBN_SUN_2_S))<=wi_Time) and (wi_Time<=StrToInt(func_Time8To6(CST_GYOKBN_SUN_2_E))) then begin
      //当直
      Result:=GSPCST_GYOUMU_KBN_2;
      Exit;
    end
    //2004.05.12 else if (StrToTime(CST_GYOKBN_SUN_3_S)<=w_Time) and (w_Time<=StrToTime(CST_GYOKBN_SUN_3_E)) then begin
    //文字列で判定(1/1000秒を比較できない為)2004.05.12
    else if (StrToInt(func_Time8To6(CST_GYOKBN_SUN_3_S))<=wi_Time) and (wi_Time<=StrToInt(func_Time8To6(CST_GYOKBN_SUN_3_E))) then begin
      //深夜
      Result:=GSPCST_GYOUMU_KBN_3;
      Exit;
    end
    else begin
      //2004.05.12 //緊急
      //2004.05.12 Result:=GSPCST_GYOUMU_KBN_4;
      //日勤
      Result:=GSPCST_GYOUMU_KBN_1;
      Exit;
    end;
  end
  else if w_Week = 7 then begin
    //土曜日
    w_Day:=Copy(DateToStr(w_Date),9,2);
    if (StrToInt(w_Day)<8) or ((StrToInt(w_Day)>=15) and (StrToInt(w_Day)<=21)) then begin
      //第１,３週
      //2004.05.12 if (StrToTime(CST_GYOKBN_SAT_13_2_S)<=w_Time) and (w_Time<=StrToTime(CST_GYOKBN_SAT_13_2_E)) then begin
      //文字列で判定(1/1000秒を比較できない為)2004.05.12
      if (StrToInt(func_Time8To6(CST_GYOKBN_SAT_13_2_S))<=wi_Time) and (wi_Time<=StrToInt(func_Time8To6(CST_GYOKBN_SAT_13_2_E))) then begin
        //当直
        Result:=GSPCST_GYOUMU_KBN_2;
        Exit;
      end
      //2004.05.12 else if (StrToTime(CST_GYOKBN_SAT_13_3_S)<=w_Time) and (w_Time<=StrToTime(CST_GYOKBN_SAT_13_3_E)) then begin
      //文字列で判定(1/1000秒を比較できない為)2004.05.12
      else if (StrToInt(func_Time8To6(CST_GYOKBN_SAT_13_3_S))<=wi_Time) and (wi_Time<=StrToInt(func_Time8To6(CST_GYOKBN_SAT_13_3_E))) then begin
        //深夜
        Result:=GSPCST_GYOUMU_KBN_3;
        Exit;
      end
      else begin
        //2004.05.12 //緊急
        //2004.05.12 Result:=GSPCST_GYOUMU_KBN_4;
        //日勤
        Result:=GSPCST_GYOUMU_KBN_1;
        Exit;
      end;
    end
    else begin
      //第２,４,５週
      //2004.05.12 if (StrToTime(CST_GYOKBN_SAT_245_1_S)<=w_Time) and (w_Time<=StrToTime(CST_GYOKBN_SAT_245_1_E)) then begin
      //文字列で判定(1/1000秒を比較できない為)2004.05.12
      if (StrToInt(func_Time8To6(CST_GYOKBN_SAT_245_1_S))<=wi_Time) and (wi_Time<=StrToInt(func_Time8To6(CST_GYOKBN_SAT_245_1_E))) then begin
        //日勤
        if arg_KensaType=GPCST_SYUBETU_01 then
          //一般撮影
          Result:=GSPCST_GYOUMU_KBN_1
        else
          //2004.05.12 Result:=GSPCST_GYOUMU_KBN_4;
          Result:=GSPCST_GYOUMU_KBN_1;
        Exit;
      end
      //2004.05.12 else if (StrToTime(CST_GYOKBN_SAT_245_2_S)<=w_Time) and (w_Time<=StrToTime(CST_GYOKBN_SAT_245_2_E)) then begin
      //文字列で判定(1/1000秒を比較できない為)2004.05.12
      else if (StrToInt(func_Time8To6(CST_GYOKBN_SAT_245_2_S))<=wi_Time) and (wi_Time<=StrToInt(func_Time8To6(CST_GYOKBN_SAT_245_2_E))) then begin
        //当直
        Result:=GSPCST_GYOUMU_KBN_2;
        Exit;
      end
      //2004.05.12 else if (StrToTime(CST_GYOKBN_SAT_245_3_S)<=w_Time) and (w_Time<=StrToTime(CST_GYOKBN_SAT_245_3_E)) then begin
      //文字列で判定(1/1000秒を比較できない為)2004.05.12
      else if (StrToInt(func_Time8To6(CST_GYOKBN_SAT_245_3_S))<=wi_Time) and (wi_Time<=StrToInt(func_Time8To6(CST_GYOKBN_SAT_245_3_E))) then begin
        //深夜
        Result:=GSPCST_GYOUMU_KBN_3;
        Exit;
      end
      else begin
        //2004.05.12 //緊急
        //2004.05.12 Result:=GSPCST_GYOUMU_KBN_4;
        //日勤
        Result:=GSPCST_GYOUMU_KBN_1;
        Exit;
      end;
    end;
  end
  else begin
    //平日
    //2004.05.12 if (StrToTime(CST_GYOKBN_NOR_1_S)<=w_Time) and (w_Time<=StrToTime(CST_GYOKBN_NOR_1_E)) then begin
    //文字列で判定(1/1000秒を比較できない為)2004.05.12
    if (StrToInt(func_Time8To6(CST_GYOKBN_NOR_1_S))<=wi_Time) and (wi_Time<=StrToInt(func_Time8To6(CST_GYOKBN_NOR_1_E))) then begin
      //日勤
      if arg_KensaType=GPCST_SYUBETU_01 then
        //一般撮影
        Result:=GSPCST_GYOUMU_KBN_1
      else
        //2004.05.12 Result:=GSPCST_GYOUMU_KBN_4;
        Result:=GSPCST_GYOUMU_KBN_1;
      Exit;
    end
    //2004.05.12 else if (StrToTime(CST_GYOKBN_NOR_2_S)<=w_Time) and (w_Time<=StrToTime(CST_GYOKBN_NOR_2_E)) then begin
    //文字列で判定(1/1000秒を比較できない為)2004.05.12
    else if (StrToInt(func_Time8To6(CST_GYOKBN_NOR_2_S))<=wi_Time) and (wi_Time<=StrToInt(func_Time8To6(CST_GYOKBN_NOR_2_E))) then begin
      //当直
      Result:=GSPCST_GYOUMU_KBN_2;
      Exit;
    end
    //2004.05.12 else if (StrToTime(CST_GYOKBN_NOR_3_S)<=w_Time) and (w_Time<=StrToTime(CST_GYOKBN_NOR_3_E)) then begin
    //文字列で判定(1/1000秒を比較できない為)2004.05.12
    else if (StrToInt(func_Time8To6(CST_GYOKBN_NOR_3_S))<=wi_Time) and (wi_Time<=StrToInt(func_Time8To6(CST_GYOKBN_NOR_3_E))) then begin
      //深夜
      Result:=GSPCST_GYOUMU_KBN_3;
      Exit;
    end
    else begin
      //2004.05.12 //緊急
      //2004.05.12 Result:=GSPCST_GYOUMU_KBN_4;
      //日勤
      Result:=GSPCST_GYOUMU_KBN_1;
      Exit;
    end;
  end;

end;

//●実績メインのRIS部位番号最大値を更新（実施時） 2004.03.29
// トランザクションが開始されている事が前提
// 必ず実施処理で実績メイン、実績部位更新後にこの関数を呼び出す
// 実績メイン、実績部位と同じタイミングでコミット（同じトランザクション処理）
function func_Up_ExRis_Bui_No_Max(arg_RisID:string; //RIS識別ID
                              arg_Query:TQuery      //Query
                              ):Boolean;
var
  w_MaxNo:string;
  w_Sel_Query: TQuery;
  w_New_Bui_No: Integer;
  w_New_Bui_No_Max: Integer;
begin
  w_MaxNo := '';
  //検済、中止のオーダで部位番号の最大値を取得
  with arg_Query do begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT max(nvl(exb.RIS_BUI_NO,0)) MAX_NO ');
    SQL.Add('  FROM EXBUITABLE exb, EXMAINTABLE exm ');
    SQL.Add(' WHERE exb.RIS_ID = exm.RIS_ID ');
    SQL.Add('   AND exm.RIS_ID = :PRIS_ID ');
    SQL.Add('   AND ((exm.KENSASTATUS_FLG = ''' + GPCST_CODE_KENSIN_3 + ''') ');
    SQL.Add('     OR (exm.KENSASTATUS_FLG = ''' + GPCST_CODE_KENSIN_4 + ''')) ');
    SQL.Add('  ');
    ParamByName('PRIS_ID').AsString:=arg_RisID;
    if not Prepared then Prepare;
    Open;
    Last;
    First;
    if not Eof then begin
      //最大値取得
      w_MaxNo := FieldByName('MAX_NO').AsString;
    end;
    Close;
  end;

  //最大値が取得できない時は処理終了
  if w_MaxNo = '' then Exit;

  w_New_Bui_No_Max := StrToInt(w_MaxNo);
  w_New_Bui_No     := 0;

  w_Sel_Query := TQuery.Create(nil);
  try
    w_Sel_Query.DatabaseName := arg_Query.DatabaseName;

    w_Sel_Query.Close;
    w_Sel_Query.SQL.Clear;
    w_Sel_Query.SQL.Add('SELECT exb.NO, nvl(exm.RIS_BUI_NO_MAX,0) RIS_BUI_NO_NEW ');
    w_Sel_Query.SQL.Add('  FROM EXBUITABLE exb, EXMAINTABLE exm ');
    w_Sel_Query.SQL.Add(' WHERE exm.RIS_ID = exb.RIS_ID ');
    w_Sel_Query.SQL.Add('   AND exm.RIS_ID = :PRIS_ID ');
    w_Sel_Query.SQL.Add('   AND exb. RIS_BUI_NO is null ');
    w_Sel_Query.SQL.Add(' ORDER BY NO ');
    w_Sel_Query.ParamByName('PRIS_ID').AsString:=arg_RisID;
    if not w_Sel_Query.Prepared then w_Sel_Query.Prepare;
    w_Sel_Query.Open;
    w_Sel_Query.Last;
    w_Sel_Query.First;
    if not w_Sel_Query.Eof then w_New_Bui_No := w_Sel_Query.FieldByName('RIS_BUI_NO_NEW').AsInteger;
    while not w_Sel_Query.Eof do begin
      w_New_Bui_No := w_New_Bui_No + 1;
      arg_Query.SQL.Clear;
      arg_Query.SQL.Add('UPDATE EXBUITABLE SET ');
      arg_Query.SQL.Add(' RIS_BUI_NO = :PRIS_BUI_NO ');
      arg_Query.SQL.Add(' WHERE RIS_ID = :PRIS_ID ');
      arg_Query.SQL.Add('   AND NO = :PNO ');
      if not arg_Query.Prepared then arg_Query.Prepare;
      arg_Query.ParamByName('PRIS_ID').AsString      := arg_RisID;
      arg_Query.ParamByName('PNO').AsInteger         := w_Sel_Query.FieldByName('NO').AsInteger;
      arg_Query.ParamByName('PRIS_BUI_NO').AsInteger := w_New_Bui_No;
      arg_Query.ExecSQL;
      arg_Query.Close;

      w_Sel_Query.Next;
    end;
  finally
    w_Sel_Query.Close;
    FreeAndNil(w_Sel_Query);
  end;

  if w_New_Bui_No_Max < w_New_Bui_No then w_New_Bui_No_Max := w_New_Bui_No;

  //実績メインのRIS部位番号最大値を更新
  with arg_Query do begin
    Close;
    SQL.Clear;
    SQL.Add('UPDATE EXMAINTABLE SET ');
    SQL.Add(' RIS_BUI_NO_MAX = :PRIS_BUI_NO_MAX ');
    SQL.Add('WHERE ');
    SQL.Add(' RIS_ID = :PRIS_ID ');
    SQL.Add('  AND nvl(RIS_BUI_NO_MAX,0) < ' + IntToStr(w_New_Bui_No_Max) + ' ');  //MAXが大きくなる場合だけ
    if not Prepared then Prepare;
    ParamByName('PRIS_BUI_NO_MAX').AsInteger  := w_New_Bui_No_Max;
    //キー
    ParamByName('PRIS_ID').AsString  := arg_RisID;
    ExecSQL;
  end;

end;

//●実績メインのRIS部位番号最大値を更新（オーダ作成時） 2004.03.30
// 現状の実績部位のRIS部位番号最大値で更新
function func_Up_Pre_ExRis_Bui_No_Max(arg_RisID:string; //RIS識別ID
                                      arg_Query:TQuery      //Query
                                      ):Boolean;
var
  w_MaxNo:string;
begin
  w_MaxNo := '';
  try
  //部位番号の最大値を取得
  with arg_Query do begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT max(nvl(RIS_BUI_NO,0)) MAX_NO ');
    SQL.Add('  FROM EXBUITABLE ');
    SQL.Add(' WHERE RIS_ID = :PRIS_ID ');
    SQL.Add('  ');
    ParamByName('PRIS_ID').AsString:=arg_RisID;
    if not Prepared then Prepare;
    Open;
    Last;
    First;
    if not Eof then begin
      //最大値取得
      w_MaxNo := FieldByName('MAX_NO').AsString;
    end;
    Close;
  end;

  //最大値が取得できない時は処理終了
  if w_MaxNo = '' then Exit;

  //実績メインのRIS部位番号最大値を更新
  with arg_Query do begin
    Close;
    SQL.Clear;
    SQL.Add('UPDATE EXMAINTABLE SET ');
    SQL.Add(' RIS_BUI_NO_MAX = :PRIS_BUI_NO_MAX ');
    SQL.Add('WHERE ');
    SQL.Add(' RIS_ID = :PRIS_ID ');
    if not Prepared then Prepare;
    ParamByName('PRIS_BUI_NO_MAX').AsString  := w_MaxNo;
    //キー
    ParamByName('PRIS_ID').AsString  := arg_RisID;
    ExecSQL;
    Close;
  end;

  except
    arg_Query.Close;
    raise;
  end;

end;
//2004.04.09
//●機能（例外無）：RISオーダ時の転送オーダ、転送Reportテーブルへのキュー作成判定
//　詳細　ダミー患者判定、オーダ作成時のレポート送信キュー作成判定、RISオーダ時のHIS、Report送信判定
//　注意事項　関数使用前にproc_SetOrderSoushin関数が実行されている事が前提
function func_Check_CueAndDummy(arg_SysKbn:string;   //システム区分
                                arg_KanjaID:string;  //患者ID
                                arg_Mode:integer     //0:受付実施Report登録 1:受付実施転送オーダ登録  2:オーダ作成Report登録
                               ):Boolean;
var
//wb_Kanja:Boolean;
//wb_Order:Boolean;
//wb_Report:Boolean;
ws_Yoyaku:string;
begin
//

  Result:=False;
  //wb_Order:=True;
  //wb_Report:=True;

  //ダミー患者ID判定
  if func_Get_WinMaster_DATA('',g_DUMMYKANJA,g_DUMMYKANJA_KEY+arg_KanjaID)<> '' then Exit;

  //システム区分がHISオーダの場合
  if arg_SysKbn=GPCST_CODE_SYSK_HIS then begin
    Result:=True;
    Exit;
  end;

  //0:受付実施Report登録
  if arg_Mode=0 then begin
    //Report送信なし
    if g_RIS_Order_Sousin_Flg=GPCST_RISORDERSOUSIN_FLG_0 then Exit;
  end else
  //1:受付実施転送オーダ登録
  if arg_Mode=1 then begin
    //HIS送信なし
    if ((g_RIS_Order_Sousin_Flg=GPCST_RISORDERSOUSIN_FLG_0 )  or
        (g_RIS_Order_Sousin_Flg=GPCST_RISORDERSOUSIN_FLG_2 )) then Exit;
  end else
  //2:オーダ作成Report登録
  if arg_Mode=2 then begin
    //Report送信なし
    if g_RIS_Order_Sousin_Flg=GPCST_RISORDERSOUSIN_FLG_0 then Exit;
    //オーダ作成時のレポート送信キュー作成設定を取得
    ws_Yoyaku:=func_Get_WinMaster_DATA('',g_REPORT,g_REPORT_YOYAKU);
    //Report送信キュー作成なし
    if ws_Yoyaku<>GPCST_REPORT_FLG_1 then Exit;
  end;

  Result:=True;


  {2004.04.09
  //ダミー患者ID判定
  if func_Get_WinMaster_DATA('',g_DUMMYKANJA,g_DUMMYKANJA_KEY+arg_KanjaID)<> '' then
    //ﾀﾞﾐｰID
      //wb_Kanja:=False
    //ﾀﾞﾐｰIDなのでResult=Falseのまま処理終了
    Exit
  else
    //ﾀﾞﾐｰIDじゃない
    wb_Kanja:=True;

  //システム区分判定
  if arg_SysKbn=GPCST_CODE_SYSK_HIS then begin
    Result:=True;
    Exit;
  end;

  //RISオーダ送信キュー判定
  if arg_Mode=1 then begin

    //受付実施転送オーダ
    if ((g_RIS_Order_Sousin_Flg=GPCST_RISORDERSOUSIN_FLG_0 )  or
        (g_RIS_Order_Sousin_Flg=GPCST_RISORDERSOUSIN_FLG_2 )) then
      wb_Order:=False
    else
      wb_Order:=True;

  end
  else if arg_Mode=0 then begin

    //受付実施Report
    if (g_RIS_Order_Sousin_Flg=GPCST_RISORDERSOUSIN_FLG_1 ) or
       (g_RIS_Order_Sousin_Flg=GPCST_RISORDERSOUSIN_FLG_2 ) then
      wb_Order:=True
    else
      wb_Order:=False;

  end
  else if arg_Mode=2 then begin

    //オーダ作成時Report登録

    if (g_RIS_Order_Sousin_Flg=GPCST_RISORDERSOUSIN_FLG_1 ) or
       (g_RIS_Order_Sousin_Flg=GPCST_RISORDERSOUSIN_FLG_2 ) then
      wb_Order:=True
    else
      wb_Order:=False;

    ws_Yoyaku:=func_Get_WinMaster_DATA('',g_REPORT,g_REPORT_YOYAKU);
    if (ws_Yoyaku=GPCST_REPORT_FLG_1) then
      wb_Report:=True
    else
      wb_Report:=False;

  end;

  if (wb_Kanja=True)  and
     (wb_Order=True)  and
     (wb_Report=True) then
    Result:=True
  else
    Result:=False;
  2004.04.09}
end;
//2004.01.09
//●機能（例外無）：RISオーダ送信フラグセット
procedure proc_SetOrderSoushin;
begin
//
  g_RIS_Order_Sousin_Flg := func_Get_WinMaster_DATA(g_PARAM01_GP00,g_RISORDER,g_RISORDER_SOUSIN);
  if (g_RIS_Order_Sousin_Flg <> GPCST_RISORDERSOUSIN_FLG_1) and
     (g_RIS_Order_Sousin_Flg <> GPCST_RISORDERSOUSIN_FLG_2) then
    g_RIS_Order_Sousin_Flg := GPCST_RISORDERSOUSIN_FLG_0;
end;
//●機能（例外無）： ダミー患者判定 2004.08.06
function func_Check_DummyKanja(arg_KanjaID:string  //患者ID
                               ):Boolean;
begin
  Result := False;
  if func_Get_WinMaster_DATA('',g_DUMMYKANJA,g_DUMMYKANJA_KEY + arg_KanjaID) <> '' then
    Result := True;

end;
//●機能（例外無）：日付から、曜日、祝日マスタ)備考をせっとする
function GetWeekInfo(Day:String; Week,SName:TPanel):Boolean;
Var
  DDate:Tdate;
  Qry:TQuery;
begin
  Result := False;
  Week.Caption := '';
  Week.Font.Color := clWindowText;

  SName.Caption := '';
  SName.Font.Color := clWindowText;
  if Day = '' then Exit;

  DDate := StrtoDate(Day);
  case DayOfWeek(DDate) of
    1: begin
         Week.Caption := '日曜日';
         Week.Font.Color := clRed;
       end;
    2: Week.Caption := '月曜日';
    3: Week.Caption := '火曜日';
    4: Week.Caption := '水曜日';
    5: Week.Caption := '木曜日';
    6: Week.Caption := '金曜日';
    7: begin
         Week.Caption := '土曜日';
         Week.Font.Color := clBlue;
       end;
  end;
  Qry := TQuery.Create(Nil);
  try
    Qry.DatabaseName := DM_DbAcc.DBs_MSter.DatabaseName;
    with Qry do begin
      //閉じる
      Close;
      //前回SQL文のクリア
      SQL.Clear;
      //SQL文作成
      SQL.Add('SELECT BIKO ');
      SQL.Add('FROM CALENDARMASTER ');
      SQL.Add('WHERE HIZUKE = :PHIZUKE ');
      if not Prepared then Prepare;
      ParamByName('PHIZUKE').AsString := Day;
      Open;
      Last;
      First;
      if (Qry.RecordCount > 0)  then begin
        SName.Caption := Qry.FieldByName('BIKO').AsString;
        SName.Font.Color := clRed;
      end;
    end;
  finally
    FreeAndNil(Qry);
  end;

  Result := True;
end;

initialization
begin
//
end;

finalization
begin
//
end;

end.
