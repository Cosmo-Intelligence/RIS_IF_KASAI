//******************************************************************************
//* unit name   : U_IFData
//* author      : M.Suzuki(ForeSight)
//* description : DICOM画像要求機能－DICOM画像応答機能間のインタフェース
//******************************************************************************
unit U_IFData;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, DateUtils;

type
  {DICOM画像存在確認結果データセット}
  RES_DATASET = record
    StudyUID:	        String;         //StudyInstanceUID
    SeriesUID:	        String;         //SeriesInstanceUID
    ImageNum:	        Integer;        //Image数
    SOPUID:             array of String;//SOPInstanceUID
  end;

  {JPEG/DICOMファイル保存結果}
  DICOM_RESULT = record
    FileName:           String;         //ファイル名
    StudyUID:           String;         //StudyInstanceUID
    SeriesUID:          String;         //SeriesInstanceUID
    SOPUID:             String;         //SOPInstanceUID
    Reason:             Integer;        //失敗理由
  end;

  {通信ヘッダ}
  TO_IFHeader = class( TObject )
    private
      StreamData:	String;         //電文データ

      {受信データをデコード}
      function	        Decode: Boolean;
      {インスタンスをエンコード}
      procedure         Encode;

    public
      CreateDate:	TDateTime;      //作成日時
      DataKind:         String;         //要求種別
      DataSize:	        Integer;        //個別部データサイズ

      {コンストラクタ}
      constructor	Create; overload;
      constructor	Create( Buffer: String; intLen: Integer ); overload;

      {初期化}
      procedure         Clear;
      {受信データをインスタンスにセット}
      function	        ReadBuffer( Buffer: String; intLen: Integer ): Boolean;
      {インスタンスから送信データを生成}
      function          WriteBuffer( var Buffer: String ): Integer;
  end;

  {DICOM画像存在確認－要求}
  TO_IFCHKRequest = class( TObject )
    private
      StreamData:	String;         //電文データ

      {受信データをデコード}
      function	        Decode: Boolean;

    public
      InstitutionID:	String;         //施設ID
      PatientID:	String;         //患者ID
      StudyDate:	TDateTime;      //検査日
      Modality:	        String;         //モダリティ

      {コンストラクタ}
      constructor	Create; overload;
      constructor	Create( Buffer: String; intLen: Integer ); overload;

      {初期化}
      procedure         Clear;
      {受信データをインスタンスにセット}
      function	        ReadBuffer( Buffer: String; intLen: Integer ): Boolean;
  end;

  {DICOM画像存在確認－応答}
  TO_IFCHKResponse = class( TObject )
    private
      StreamData:	String;         //電文データ

      {インスタンスをエンコード}
      procedure         Encode;

    public
      Result:		Integer;        //確認結果状況
      DataSetNum:	Integer;        //データセット数
      DataSet:	        array of RES_DATASET;//データセット

      {コンストラクタ}
      constructor	Create;
      {デストラクタ}
      destructor        Destroy; reintroduce;

      {初期化}
      procedure         Clear;
      {インスタンスから送信データを生成}
      function          WriteBuffer( var Buffer: String ): Integer;
  end;

  {JPEG/DICOMファイル保存－要求}
  TO_IFSTGRequest = class( TObject )
    private
      StreamData:	String;         //電文データ

      {受信データをデコード}
      function	        Decode: Boolean;

    public
      InstitutionID:	String;         //施設ID
      PatientID:	String;         //患者ID
      PatientName:	String;         //患者名
      Sex:		String;         //性別
      BirthDate:	TDateTime;      //生年月日
      StudyDate:	TDateTime;      //検査日
      Modality:	        String;         //モダリティ
      Region:		String;         //部位
      StudyComment:	String;         //検査コメント
      FileNum:	        Integer;        //ファイル数
      FileName:         array of String;//ファイル名

      {コンストラクタ}
      constructor	Create; overload;
      constructor	Create( Buffer: String; intLen: Integer ); overload;
      {デストラクタ}
      destructor        Destroy; reintroduce;

      {初期化}
      procedure         Clear;
      {受信データをインスタンスにセット}
      function	        ReadBuffer( Buffer: String; intLen: Integer ): Boolean;
      {コントロールコードチェック}
      function          CheckCtlCode( strCheck: String ): Boolean;
  end;

  {JPEG/DICOMファイル保存－応答}
  TO_IFSTGResponse = class( TObject )
    private
      StreamData:	String;         //電文データ
      Succeed:          array of DICOM_RESULT;//成功ファイル情報
      Failed:           array of DICOM_RESULT;//失敗ファイル情報

      {インスタンスをエンコード}
      procedure         Encode;

    public

      {コンストラクタ}
      constructor	Create;
      {デストラクタ}
      destructor        Destroy; reintroduce;

      {初期化}
      procedure         Clear;
      {成功ファイル数取得}
      function          SuccessNum: Integer;
      {失敗ファイル数取得}
      function          FailNum: Integer;
      {成功ファイル情報追加}
      procedure         Add( FileName,StudyUID,SeriesUID,SOPUID: String ); overload;
      {失敗ファイル情報追加}
      procedure         Add( FileName: String; Reason: Integer ); overload;
      {インスタンスから送信データを生成}
      function          WriteBuffer( var Buffer: String ): Integer;
  end;

  {DICOMファイル取得－要求}
  TO_IFGETRequest = class( TObject )
    private
      StreamData:	String;         //電文データ

      {受信データをデコード}
      function	        Decode: Boolean;

    public
      RequestLevel:	Integer;        //要求レベル
      UID:		String;         //UID

      {コンストラクタ}
      constructor	Create; overload;
      constructor	Create( Buffer: String; intLen: Integer ); overload;

      {初期化}
      procedure         Clear;
      {受信データをインスタンスにセット}
      function	        ReadBuffer( Buffer: String; intLen: Integer ): Boolean;
  end;

  {DICOMファイル取得－応答}
  TO_IFGETResponse = class( TObject )
    private
      StreamData:	String;         //電文データ

      {インスタンスをエンコード}
      procedure         Encode;

    public
      Result:           Integer;        //確認結果状況
      DataSetNum:       Integer;        //データセット数
      DataSet:          array of RES_DATASET;//データセット

      {コンストラクタ}
      constructor	Create;
      {デストラクタ}
      destructor        Destroy; reintroduce;

      {初期化}
      procedure         Clear;
      {インスタンスから送信データを生成}
      function          WriteBuffer( var Buffer: String ): Integer;
  end;


implementation

//------------------------------------------------------------------------------
//通信ヘッダ
//------------------------------------------------------------------------------
//******************************************************************************
//* function name       : TO_IFHeader.Create
//* description         : コンストラクタ
//*   <function>
//*     各インスタンスを初期化する。
//*   <include file>
//*   <calling sequence>
//*     TO_IFHeader.Create;
//*   <remarks>
//******************************************************************************
constructor TO_IFHeader.Create;
begin
  Clear;
end;

//******************************************************************************
//* function name       : TO_IFHeader.Create
//* description         : コンストラクタ
//*   <function>
//*     各インスタンスを初期化する。
//*   <include file>
//*   <calling sequence>
//*     TO_IFHeader.Create( Buffer: String; intLen: Integer );
//*       Buffer: String        (IN) 受信データ
//*       intLen: Integer       (IN) 受信データ長
//*   <remarks>
//******************************************************************************
constructor TO_IFHeader.Create( Buffer: string; intLen: Integer );
begin
  Clear;
  StreamData := Copy( Buffer,1,intLen );
  Decode;
end;

//******************************************************************************
//* function name       : TO_IFHeader.Clear
//* description         : 初期化
//*   <function>
//*     各インスタンスを初期化する。
//*   <include file>
//*   <calling sequence>
//*     TO_IFHeader.Clear;
//*   <remarks>
//******************************************************************************
procedure TO_IFHeader.Clear;
begin
  StreamData := '';
  CreateDate := 0;
  DataKind := '';
  DataSize := 0;
end;

//******************************************************************************
//* function name       : TO_IFHeader.ReadBuffer
//* description         : 受信データをインスタンスにセット
//*   <function>
//*     指定文字列をインスタンスにセットし、デコードする。
//*   <include file>
//*   <calling sequence>
//*     TO_IFHeader.ReadBuffer( Buffer: String; intLen: Integer ): Boolean;
//*       return: Boolean       (RET) True=成功,False=失敗
//*       Buffer: String        (IN) 受信データ
//*       intLen: Integer       (IN) 受信データ長
//*   <remarks>
//******************************************************************************
function TO_IFHeader.ReadBuffer( Buffer: String; intLen: Integer ): Boolean;
begin
  StreamData := Copy( Buffer,1,intLen );
  Result := Decode;
end;

//******************************************************************************
//* function name       : TO_IFHeader.WriteBuffer
//* description         : インスタンスから送信データを生成
//*   <function>
//*     インスタンスから電文データを生成する。
//*   <include file>
//*   <calling sequence>
//*     TO_IFHeader.WriteBuffer( var Buffer: String ): Integer;
//*       return: Integer       (RET) 生成した電文長
//*       Buffer: String        (OUT) 電文データ
//*   <remarks>
//******************************************************************************
function TO_IFHeader.WriteBuffer( var Buffer: String ): Integer;
begin
  Encode;
  Buffer := StreamData;

  Result := Length( Buffer );
end;

//******************************************************************************
//* function name       : TO_IFHeader.Decode
//* description         : デコード
//*   <function>
//*     電文データを解析し、各インスタンス値にセットする。
//*   <include file>
//*   <calling sequence>
//*     TO_IFHeader.Decode: Boolean;
//*       return: Boolean       (RET) True=成功,False=失敗
//*   <remarks>
//******************************************************************************
function TO_IFHeader.Decode: Boolean;
var
  tmpYear:      String;         //作成日時（年）
  tmpMonth:	String;         //作成日時（月）
  tmpDay:	String;         //作成日時（日）
  tmpHour:	String;         //作成日時（時）
  tmpMin:	String;         //作成日時（分）
  tmpSec:	String;         //作成日時（秒）
  tmpKind:	String;         //要求種別
  tmpSize:	String;         //個別部データサイズ

begin
  Result := True;

  tmpYear := '';
  tmpMonth := '';
  tmpDay := '';
  tmpHour := '';
  tmpMin := '';
  tmpSec := '';
  tmpKind := '';
  tmpSize := '';

  CreateDate := 0;
  DataKind := '';
  DataSize := 0;

  tmpYear := Trim( Copy( StreamData,1,4 ) );
  tmpMonth := Trim( Copy( StreamData,5,2 ) );
  tmpDay := Trim( Copy( StreamData,7,2 ) );
  tmpHour := Trim( Copy( StreamData,9,2 ) );
  tmpMin := Trim( Copy( StreamData,11,2 ) );
  tmpSec := Trim( Copy( StreamData,13,2 ) );
  tmpSize := Trim( Copy( StreamData,18,8 ) );

  try
    CreateDate := StrToDateTime( tmpYear + '/' + tmpMonth + '/' + tmpDay + ' ' +
                                 tmpHour + ':' + tmpMin + ':' + tmpSec );
  except
    Result := False;
  end;

  DataKind := Trim( Copy( StreamData,15,3 ) );

  try
    DataSize := StrToInt( tmpSize );
  except
    Result := False;
  end;

end;

//******************************************************************************
//* function name       : TO_IFHeader.Encode
//* description         : エンコード
//*   <function>
//*     各インスタンスから電文データを生成する。
//*   <include file>
//*   <calling sequence>
//*     TO_IFHeader.Encode;
//*   <remarks>
//******************************************************************************
procedure TO_IFHeader.Encode;
begin
  StreamData := FormatDateTime( 'yyyymmddhhnnss',CreateDate );
  StreamData := StreamData + DataKind;
  StreamData := StreamData + Format( '%.8d      ',[DataSize] );
end;

//------------------------------------------------------------------------------
//DICOM画像存在確認
//------------------------------------------------------------------------------
//******************************************************************************
//* function name       : TO_IFCHKRequest.Create
//* description         : コンストラクタ
//*   <function>
//*     各インスタンスを初期化する。
//*   <include file>
//*   <calling sequence>
//*     TO_IFCHKRequest.Create;
//*   <remarks>
//******************************************************************************
constructor TO_IFCHKRequest.Create;
begin
  Clear;
end;

//******************************************************************************
//* function name       : TO_IFCHKRequest.Create
//* description         : コンストラクタ
//*   <function>
//*     各インスタンスを初期化する。
//*   <include file>
//*   <calling sequence>
//*     TO_IFCHKRequest.Create( Buffer: String; intLen: Integer );
//*       Buffer: String        (IN) 受信データ
//*       intLen: Integer       (IN) 受信データ長
//*   <remarks>
//******************************************************************************
constructor TO_IFCHKRequest.Create( Buffer: string; intLen: Integer );
begin
  Clear;
  StreamData := Copy( Buffer,1,intLen );
  Decode;
end;

//******************************************************************************
//* function name       : TO_IFCHKRequest.Clear
//* description         : 初期化
//*   <function>
//*     各インスタンスを初期化する。
//*   <include file>
//*   <calling sequence>
//*     TO_IFCHKRequest.Clear;
//*   <remarks>
//******************************************************************************
procedure TO_IFCHKRequest.Clear;
begin
  StreamData := '';
  InstitutionID := '';
  PatientID := '';
  StudyDate := 0;
  Modality := '';
end;

//******************************************************************************
//* function name       : TO_IFCHKRequest.ReadBuffer
//* description         : 受信データをインスタンスにセット
//*   <function>
//*     指定文字列をインスタンスにセットし、デコードする。
//*   <include file>
//*   <calling sequence>
//*     TO_IFCHKRequest.ReadBuffer( Buffer: String; intLen: Integer ): Boolean;
//*       return: Boolean       (RET) True=成功,False=失敗
//*       Buffer: String        (IN) 受信データ
//*       intLen: Integer       (IN) 受信データ長
//*   <remarks>
//******************************************************************************
function TO_IFCHKRequest.ReadBuffer( Buffer: String; intLen: Integer ): Boolean;
begin
  StreamData := Copy( Buffer,1,intLen );
  Result := Decode;
end;

//******************************************************************************
//* function name       : TO_IFCHKRequest.Decode
//* description         : デコード
//*   <function>
//*     電文データを解析し、各インスタンス値にセットする。
//*   <include file>
//*   <calling sequence>
//*     TO_IFCHKRequest.Decode: Boolean;
//*       return: Boolean       (RET) True=成功,False=失敗
//*   <remarks>
//******************************************************************************
function TO_IFCHKRequest.Decode: Boolean;
var
  tmpYear:	String;         //検査日（年）
  tmpMonth:	String;         //検査日（月）
  tmpDay:	String;         //検査日（日）

begin
  Result := True;

  tmpYear := '';
  tmpMonth := '';
  tmpDay := '';
  InstitutionID := '';
  PatientID := '';
  StudyDate := 0;
  Modality := '';

  tmpYear := Trim( Copy( StreamData,43,4 ) );
  tmpMonth := Trim( Copy( StreamData,47,2 ) );
  tmpDay := Trim( Copy( StreamData,49,2 ) );

  InstitutionID := Trim( Copy( StreamData,1,10 ) );
  PatientID := Trim( Copy( StreamData,11,32 ) );
  try
    StudyDate := StrToDate( tmpYear + '/' + tmpMonth + '/' + tmpDay );
  except
    Result := False;
  end;
  Modality := Trim( Copy( StreamData,51,16 ) );

end;

//******************************************************************************
//* function name       : TO_IFCHKResponse.Create
//* description         : コンストラクタ
//*   <function>
//*     各インスタンスを初期化する。
//*   <include file>
//*   <calling sequence>
//*     TO_IFCHKResponse.Create;
//*   <remarks>
//******************************************************************************
constructor TO_IFCHKResponse.Create;
begin
  Clear;
end;

//******************************************************************************
//* function name       : TO_IFCHKResponse.Clear
//* description         : 初期化
//*   <function>
//*     各インスタンスを初期化する。
//*   <include file>
//*   <calling sequence>
//*     TO_IFCHKResponse.Clear;
//*   <remarks>
//******************************************************************************
procedure TO_IFCHKResponse.Clear;
begin
  StreamData := '';
  Self.Result := 0;
  DataSetNum := 0;
  SetLength( DataSet,0 );
end;

//******************************************************************************
//* function name       : TO_IFCHKResponse.Destroy
//* description         : デストラクタ
//*   <function>
//*     各インスタンスを解放する。
//*   <include file>
//*   <calling sequence>
//*     TO_IFCHKResponse.Destroy;
//*   <remarks>
//******************************************************************************
destructor TO_IFCHKResponse.Destroy;
begin
  Clear;
end;

//******************************************************************************
//* function name       : TO_IFCHKResponse.WriteBuffer
//* description         : インスタンスから送信データを生成
//*   <function>
//*     インスタンスから電文データを生成する。
//*   <include file>
//*   <calling sequence>
//*     TO_IFCHKResponse.WriteBuffer( var Buffer: String ): Integer;
//*       return: Integer       (RET) 生成した電文長
//*       Buffer: String        (OUT) 電文データ
//*   <remarks>
//******************************************************************************
function TO_IFCHKResponse.WriteBuffer( var Buffer: String ): Integer;
begin
  Encode;
  Buffer := StreamData;

  Result := Length( Buffer );
end;

//******************************************************************************
//* function name       : TO_IFCHKResponse.Encode
//* description         : エンコード
//*   <function>
//*     各インスタンスから電文データを生成する。
//*   <include file>
//*   <calling sequence>
//*     TO_IFCHKResponse.Encode;
//*   <remarks>
//******************************************************************************
procedure TO_IFCHKResponse.Encode;
var
  ii:           Integer;        //ループカウンタ
  jj:           Integer;        //ループカウンタ
  SOPlen:       Integer;        //SOPInstanceUID有効文字数
  SOPMaxlen:    Integer;        //SOPInstanceUID項目最大文字数

begin
  StreamData := Format( '%1d%.2d',[Self.Result,DataSetNum] );

  if Self.Result <> 0 then
  begin
    StreamData := StreamData + StringOfChar( ' ',10 );
    Exit;
  end;

  for ii := 0 to DataSetNum-1 do
  begin
    StreamData := StreamData + Format( '%-64s%-64s%.3d',[DataSet[ii].StudyUID,DataSet[ii].SeriesUID,DataSet[ii].ImageNum] );
    SOPlen := 0;
    SOPMaxlen := (64*DataSet[ii].ImageNum)+(1*(DataSet[ii].ImageNum-1));
    for jj := 0 to DataSet[ii].ImageNum-1 do
    begin
      SOPlen := SOPlen + Length( DataSet[ii].SOPUID[jj] );

      StreamData := StreamData + Format( '%s',[DataSet[ii].SOPUID[jj]] );
      if jj < DataSet[ii].ImageNum-1 then
      begin
        StreamData := StreamData + ',';
        inc( SOPlen );
      end;
    end;
    StreamData := StreamData + StringOfChar( ' ',(SOPMaxlen-SOPlen) );
  end;
  StreamData := StreamData + StringOfChar( ' ',10 );

end;

//------------------------------------------------------------------------------
//JPEG/DICOMファイル保存
//------------------------------------------------------------------------------
//******************************************************************************
//* function name       : TO_IFSTGRequest.Create
//* description         : コンストラクタ
//*   <function>
//*     各インスタンスを初期化する。
//*   <include file>
//*   <calling sequence>
//*     TO_IFSTGRequest.Create;
//*   <remarks>
//******************************************************************************
constructor TO_IFSTGRequest.Create;
begin
  Clear;
end;

//******************************************************************************
//* function name       : TO_IFSTGRequest.Create
//* description         : コンストラクタ
//*   <function>
//*     各インスタンスを初期化する。
//*   <include file>
//*   <calling sequence>
//*     TO_IFSTGRequest.Create( Buffer: String; intLen: Integer );
//*       Buffer: String        (IN) 受信データ
//*       intLen: Integer       (IN) 受信データ長
//*   <remarks>
//******************************************************************************
constructor TO_IFSTGRequest.Create( Buffer: String; intLen: Integer );
begin
  Clear;
  StreamData := Copy( Buffer,1,intLen );
  Decode;
end;

//******************************************************************************
//* function name       : TO_IFSTGRequest.Destroy
//* description         : デストラクタ
//*   <function>
//*     各インスタンスを解放する。
//*   <include file>
//*   <calling sequence>
//*     TO_IFSTGRequest.Destroy;
//*   <remarks>
//******************************************************************************
destructor TO_IFSTGRequest.Destroy;
begin
  Clear;
end;

//******************************************************************************
//* function name       : TO_IFSTGRequest.Clear
//* description         : 初期化
//*   <function>
//*     各インスタンスを初期化する。
//*   <include file>
//*   <calling sequence>
//*     TO_IFSTGRequest.Clear;
//*   <remarks>
//******************************************************************************
procedure TO_IFSTGRequest.Clear;
begin
  StreamData := '';
  InstitutionID := '';
  PatientID := '';
  PatientName := '';
  Sex := '';
  BirthDate := 0;
  StudyDate := 0;
  Modality := '';
  Region := '';
  StudyComment := '';
  FileNum := 0;
  SetLength( FileName,0 );
end;

//******************************************************************************
//* function name       : TO_IFSTGRequest.ReadBuffer
//* description         : 受信データをインスタンスにセット
//*   <function>
//*     指定文字列をインスタンスにセットし、デコードする。
//*   <include file>
//*   <calling sequence>
//*     TO_IFSTGRequest.ReadBuffer( Buffer: String; intLen: Integer ): Boolean;
//*       return: Boolean       (RET) True=成功,False=失敗
//*       Buffer: String        (IN) 受信データ
//*       intLen: Integer       (IN) 受信データ長
//*   <remarks>
//******************************************************************************
function TO_IFSTGRequest.ReadBuffer( Buffer: String; intLen: Integer ): Boolean;
begin
  StreamData := Copy( Buffer,1,intLen );
  Result := Decode;
end;

//******************************************************************************
//* function name       : TO_IFSTGRequest.Decode
//* description         : デコード
//*   <function>
//*     電文データを解析し、各インスタンス値にセットする。
//*   <include file>
//*   <calling sequence>
//*     TO_IFSTGRequest.Decode: Boolean;
//*       return: Boolean       (RET) True=成功,False=失敗
//*   <remarks>
//******************************************************************************
function TO_IFSTGRequest.Decode: Boolean;
var
  tmpYear:	String;         //年
  tmpMonth:	String;         //月
  tmpDay:	String;         //日
  ii:		Integer;        //ループカウンタ
  pos:		Integer;        //文字位置

begin
  Result := True;

  InstitutionID := Trim( Copy( StreamData,1,10 ) );
  PatientID := Trim( Copy( StreamData,11,32 ) );
  PatientName := Trim( Copy( StreamData,43,64 ) );
  Sex := Copy( StreamData,107,1 );

  tmpYear := '';
  tmpMonth := '';
  tmpDay := '';
  tmpYear := Copy( StreamData,108,4 );
  tmpMonth := Copy( StreamData,112,2 );
  tmpDay := Copy( StreamData,114,2 );
  try
    BirthDate := StrToDateTime( tmpYear + '/' + tmpMonth + '/' + tmpDay );
  except
    Result := False;
  end;

  tmpYear := '';
  tmpMonth := '';
  tmpDay := '';
  tmpYear := Copy( StreamData,116,4 );
  tmpMonth := Copy( StreamData,120,2 );
  tmpDay := Copy( StreamData,122,2 );
  try
    StudyDate := StrToDateTime( tmpYear + '/' + tmpMonth + '/' + tmpDay );
  except
    Result := False;
  end;

  Modality := Trim( Copy( StreamData,124,16 ) );
  Region := Trim( Copy( StreamData,140,16 ) );
  StudyComment := Trim( Copy( StreamData,156,64 ) );
  FileNum := StrToIntDef( Copy( StreamData,220,3 ),0 );
  SetLength( FileName,FileNum );

  pos := 223;
  for ii := 1 to FileNum do
  begin
    FileName[ii-1] := Trim( Copy( StreamData,pos,23 ) );
    pos := pos + 24;
  end;

end;

//******************************************************************************
//* function name       : TO_IFSTGRequest.CheckCtlCode
//* description         : コントロールチェック
//*   <function>
//*     指定文字列にコントロールコード（'\'およびESC以外の制御文字）があるか
//*     チェックする。
//*   <include file>
//*   <calling sequence>
//*     TO_IFSTGRequest.CheckCtlCode( strCheck: String ): Boolean;
//*       return: Boolean       (RET) True=あり,False=なし
//*       strCheck: String      (IN) チェックする文字列
//*   <remarks>
//******************************************************************************
function TO_IFSTGRequest.CheckCtlCode( strCheck: String ): Boolean;
var
  len:          Integer;        //ループカウンタ
  ii:           Integer;        //ループカウンタ
  chrCheck:     PChar;          //チェック文字

begin
  Result := False;

  len := Length( strCheck );
  chrCheck := PChar( strCheck );
  for ii := 0 to len-1 do
  begin
    if (chrCheck[ii] = '\') or ((Byte(chrCheck[ii]) <> $1b) and (Byte(chrCheck[ii]) < $20)) then
    begin
      Result := True;
      Exit;
    end;
  end;

end;

//******************************************************************************
//* function name       : TO_IFSTGResponse.Create
//* description         : コンストラクタ
//*   <function>
//*     各インスタンスを初期化する。
//*   <include file>
//*   <calling sequence>
//*     TO_IFSTGResponse.Create;
//*   <remarks>
//******************************************************************************
constructor TO_IFSTGResponse.Create;
begin
  Clear;
end;

//******************************************************************************
//* function name       : TO_IFSTGResponse.Destroy
//* description         : デストラクタ
//*   <function>
//*     各インスタンスを解放する。
//*   <include file>
//*   <calling sequence>
//*     TO_IFSTGResponse.Destroy;
//*   <remarks>
//******************************************************************************
destructor TO_IFSTGResponse.Destroy;
begin
  Clear;
end;

//******************************************************************************
//* function name       : TO_IFSTGResponse.Clear
//* description         : 初期化
//*   <function>
//*     各インスタンスを初期化する。
//*   <include file>
//*   <calling sequence>
//*     TO_IFSTGResponse.Clear;
//*   <remarks>
//******************************************************************************
procedure TO_IFSTGResponse.Clear;
begin
  StreamData := '';
  SetLength( Succeed,0 );
  SetLength( Failed,0 );
end;

//******************************************************************************
//* function name       : TO_IFSTGResponse.SuccessNum
//* description         : 成功ファイル数取得
//*   <function>
//*     登録されている成功ファイルの数を返す。
//*   <include file>
//*   <calling sequence>
//*     TO_IFSTGResponse.SuccessNum: Integer;
//*       return: Integer       (RET) 成功ファイル数
//*   <remarks>
//******************************************************************************
function TO_IFSTGResponse.SuccessNum: Integer;
begin
  Result := high( Succeed );
  if Result < 0 then
    Result := 0
  else
    inc( Result );
end;

//******************************************************************************
//* function name       : TO_IFSTGResponse.FailNum
//* description         : 失敗ファイル数取得
//*   <function>
//*     登録されている失敗ファイルの数を返す。
//*   <include file>
//*   <calling sequence>
//*     TO_IFSTGResponse.FailNum: Integer;
//*       return: Integer       (RET) 失敗ファイル数
//*   <remarks>
//******************************************************************************
function TO_IFSTGResponse.FailNum: Integer;
begin
  Result := high( Failed );
  if Result < 0 then
    Result := 0
  else
    inc( Result );
end;

//******************************************************************************
//* function name       : TO_IFSTGResponse.Add
//* description         : 成功ファイル情報追加
//*   <function>
//*     成功ファイル情報を追加する。
//*   <include file>
//*   <calling sequence>
//*     TO_IFSTGResponse.Add( FileName,StudyUID,SeriesUID,SOPUID: String );
//*       FileName: String      (IN) ファイル名
//*       StudyUID: String      (IN) StudyInstanceUID
//*       SeriesUID: String     (IN) SeriesInstanceUID
//*       SOPUID: String        (IN) SOPInstanceUID
//*   <remarks>
//******************************************************************************
procedure TO_IFSTGResponse.Add( FileName,StudyUID,SeriesUID,SOPUID: String );
var
  num:          Integer;        //ファイル数

begin
  num := SuccessNum;
  SetLength( Succeed,num+1 );

  Succeed[num].FileName := FileName;
  Succeed[num].StudyUID := StudyUID;
  Succeed[num].SeriesUID := SeriesUID;
  Succeed[num].SOPUID := SOPUID;
  Succeed[num].Reason := 0;
end;

//******************************************************************************
//* function name       : TO_IFSTGResponse.Add
//* description         : 失敗ファイル情報追加
//*   <function>
//*     失敗ファイル情報を追加する。
//*   <include file>
//*   <calling sequence>
//*     TO_IFSTGResponse.Add( FileName: String; Reason: Integer );
//*       FileName: String      (IN) ファイル名
//*       Reason: Integer       (IN) 失敗理由
//*   <remarks>
//******************************************************************************
procedure TO_IFSTGResponse.Add( FileName: String; Reason: Integer );
var
  num:          Integer;

begin
  num := FailNum;
  SetLength( Failed,num+1 );

  Failed[num].FileName := FileName;
  Failed[num].Reason := Reason;
end;

//******************************************************************************
//* function name       : TO_IFSTGResponse.WriteBuffer
//* description         : インスタンスから送信データを生成
//*   <function>
//*     インスタンスから電文データを生成する。
//*   <include file>
//*   <calling sequence>
//*     TO_IFSTGResponse.WriteBuffer( var Buffer: String ): Integer;
//*       return: Integer       (RET) 生成した電文長
//*       Buffer: String        (OUT) 電文データ
//*   <remarks>
//******************************************************************************
function TO_IFSTGResponse.WriteBuffer( var Buffer: String ): Integer;
begin
  Encode;
  Buffer := StreamData;

  Result := Length( Buffer );
end;

//******************************************************************************
//* function name       : TO_IFSTGResponse.Encode
//* description         : エンコード
//*   <function>
//*     各インスタンスから電文データを生成する。
//*   <include file>
//*   <calling sequence>
//*     TO_IFSTGResponse.Encode;
//*   <remarks>
//******************************************************************************
procedure TO_IFSTGResponse.Encode;
var
  num:          Integer;        //ファイル数
  ii:           Integer;        //ループカウンタ
  strSucceed:   String;         //成功ファイルデータ
  strFailed:    String;         //失敗ファイルデータ
  strReason:    String;         //失敗理由データ

begin
  //成功ファイル
  num := SuccessNum;
  strSucceed := Format( '%.3d',[num] );
  for ii := 0 to num-1 do
  begin
    strSucceed := strSucceed + Format( '%-23s%-64s%-64s%-64s',[Succeed[ii].FileName,Succeed[ii].StudyUID,Succeed[ii].SeriesUID,Succeed[ii].SOPUID] );
  end;

  //失敗ファイル
  num := FailNum;
  strFailed := Format( '%.3d',[num] );
  strReason := '';
  for ii := 0 to num-1 do
  begin
    strFailed := strFailed + Format( '%-23s',[Failed[ii].FileName] );
    strReason := strReason + Format( '%1d',[Failed[ii].Reason] );
    if ii < num-1 then
    begin
      strFailed := strFailed + ',';
      strReason := strReason + ',';
    end;
  end;

  StreamData := strSucceed + strFailed + strReason + StringOfChar( ' ',10 );
end;

//------------------------------------------------------------------------------
//DICOMファイル取得
//------------------------------------------------------------------------------
//******************************************************************************
//* function name       : TO_IFGETRequest.Create
//* description         : コンストラクタ
//*   <function>
//*     各インスタンスを初期化する。
//*   <include file>
//*   <calling sequence>
//*     TO_IFGETRequest.Create;
//*   <remarks>
//******************************************************************************
constructor TO_IFGETRequest.Create;
begin
  Clear;
end;

//******************************************************************************
//* function name       : TO_IFGETRequest.Create
//* description         : コンストラクタ
//*   <function>
//*     各インスタンスを初期化する。
//*   <include file>
//*   <calling sequence>
//*     TO_IFGETRequest.Create( Buffer: String; intLen: Integer );
//*       Buffer: String        (IN) 受信データ
//*       intLen: Integer       (IN) 受信データ長
//*   <remarks>
//******************************************************************************
constructor TO_IFGETRequest.Create( Buffer: string; intLen: Integer );
begin
  Clear;
  StreamData := Copy( Buffer,1,intLen );
  Decode;
end;

//******************************************************************************
//* function name       : TO_IFGETRequest.Clear
//* description         : 初期化
//*   <function>
//*     各インスタンスを初期化する。
//*   <include file>
//*   <calling sequence>
//*     TO_IFGETRequest.Clear;
//*   <remarks>
//******************************************************************************
procedure TO_IFGETRequest.Clear;
begin
  StreamData := '';
  RequestLevel := 0;
  UID := '';
end;

//******************************************************************************
//* function name       : TO_IFGETRequest.ReadBuffer
//* description         : 受信データをインスタンスにセット
//*   <function>
//*     指定文字列をインスタンスにセットし、デコードする。
//*   <include file>
//*   <calling sequence>
//*     TO_IFGETRequest.ReadBuffer( Buffer: String; intLen: Integer ): Boolean;
//*       return: Boolean       (RET) True=成功,False=失敗
//*       Buffer: String        (IN) 受信データ
//*       intLen: Integer       (IN) 受信データ長
//*   <remarks>
//******************************************************************************
function TO_IFGETRequest.ReadBuffer( Buffer: String; intLen: Integer ): Boolean;
begin
  StreamData := Copy( Buffer,1,intLen );
  Result := Decode;
end;

//******************************************************************************
//* function name       : TO_IFGETRequest.Decode
//* description         : デコード
//*   <function>
//*     電文データを解析し、各インスタンス値にセットする。
//*   <include file>
//*   <calling sequence>
//*     TO_IFGETRequest.Decode: Boolean;
//*       return: Boolean       (RET) True=成功,False=失敗
//*   <remarks>
//******************************************************************************
function TO_IFGETRequest.Decode: Boolean;
begin
  Result := True;

  try
    RequestLevel := StrToInt( Copy( StreamData,1,1 ) );
  except
    Result := False;
  end;

  UID := Trim( Copy( StreamData,2,64 ) );

end;

//******************************************************************************
//* function name       : TO_IFGETResponse.Create
//* description         : コンストラクタ
//*   <function>
//*     各インスタンスを初期化する。
//*   <include file>
//*   <calling sequence>
//*     TO_IFGETResponse.Create;
//*   <remarks>
//******************************************************************************
constructor TO_IFGETResponse.Create;
begin
  Clear;
end;

//******************************************************************************
//* function name       : TO_IFGETResponse.Clear
//* description         : 初期化
//*   <function>
//*     各インスタンスを初期化する。
//*   <include file>
//*   <calling sequence>
//*     TO_IFGETResponse.Clear;
//*   <remarks>
//******************************************************************************
procedure TO_IFGETResponse.Clear;
begin
  StreamData := '';
  Self.Result := 0;
  DataSetNum := 0;
  SetLength( DataSet,0 );
end;

//******************************************************************************
//* function name       : TO_IFGETResponse.Destroy
//* description         : デストラクタ
//*   <function>
//*     各インスタンスを解放する。
//*   <include file>
//*   <calling sequence>
//*     TO_IFGETResponse.Destroy;
//*   <remarks>
//******************************************************************************
destructor TO_IFGETResponse.Destroy;
begin
  Clear;
end;

//******************************************************************************
//* function name       : TO_IFGETResponse.WriteBuffer
//* description         : インスタンスから送信データを生成
//*   <function>
//*     インスタンスから電文データを生成する。
//*   <include file>
//*   <calling sequence>
//*     TO_IFGETResponse.WriteBuffer( var Buffer: String ): Integer;
//*       return: Integer       (RET) 生成した電文長
//*       Buffer: String        (OUT) 電文データ
//*   <remarks>
//******************************************************************************
function TO_IFGETResponse.WriteBuffer( var Buffer: String ): Integer;
begin
  Encode;
  Buffer := StreamData;

  Result := Length( Buffer );
end;

//******************************************************************************
//* function name       : TO_IFGETResponse.Encode
//* description         : エンコード
//*   <function>
//*     各インスタンスから電文データを生成する。
//*   <include file>
//*   <calling sequence>
//*     TO_IFGETResponse.Encode;
//*   <remarks>
//******************************************************************************
procedure TO_IFGETResponse.Encode;
var
  ii:           Integer;        //ループカウンタ
  jj:           Integer;        //ループカウンタ
  SOPlen:       Integer;        //SOPInstanceUID有効文字数
  SOPMaxlen:    Integer;        //SOPInstanceUID項目最大文字数

begin
  StreamData := Format( '%1d%.2d',[Result,DataSetNum] );

  if Result <> 0 then
  begin
    StreamData := StreamData + StringOfChar( ' ',10 );
    Exit;
  end;

  for ii := 0 to DataSetNum-1 do
  begin
    StreamData := StreamData + Format( '%-64s%-64s%.3d',[DataSet[ii].StudyUID,DataSet[ii].SeriesUID,DataSet[ii].ImageNum] );
    SOPlen := 0;
    SOPMaxlen := (64*DataSet[ii].ImageNum)+(1*(DataSet[ii].ImageNum-1));
    for jj := 0 to DataSet[ii].ImageNum-1 do
    begin
      SOPlen := SOPlen + Length( DataSet[ii].SOPUID[jj] );

      StreamData := StreamData + Format( '%s',[DataSet[ii].SOPUID[jj]] );
      if jj < DataSet[ii].ImageNum-1 then
      begin
        StreamData := StreamData + ',';
        inc( SOPlen );
      end;
    end;
    StreamData := StreamData + StringOfChar( ' ',(SOPMaxlen-SOPlen) );
  end;
  StreamData := StreamData + StringOfChar( ' ',10 );
end;

end.

