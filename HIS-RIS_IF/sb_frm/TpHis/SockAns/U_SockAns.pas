//******************************************************************************
//* unit name   : U_SockAns
//* author      : M.Suzuki
//* description :
//******************************************************************************
unit U_SockAns;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IniFiles, ExtCtrls, FileCtrl, ShellAPI, Menus, ScktComp, StdCtrls, DateUtils,
   IdException, Syncobjs;

const
  CAPTIONNAME = 'ソケット受信ツール %s';

type
  {送受信定義}
  TIOKind = (IOK_IN,IOK_OUT);

  TCheckRequestThread = class( TServerClientThread )
    private
      strLogMsg:        String;         //ログメッセージ
      strResMes:        String;         //通信ログ用エラーメッセージ

      procedure WriteLogFile;

    public
      procedure ClientExecute; override;

  end;

  TF_SockAns = class(TForm)
    RadioGroup1: TRadioGroup;
    Edit2: TEdit;
    Label2: TLabel;
    Button1: TButton;
    procedure WMDropFiles(var msg: TWMDROPFILES); message WM_DROPFILES;
    procedure CheckBox1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    published
      CheckSocket:        TServerSocket;  //データベース
      Memo1:              TMemo;          //デバッグログ表示

      {コンストラクタ}
      procedure FormCreate( Sender: TObject );
      {デストラクタ}
      procedure FormDestroy( Sender: TObject );

      {DICOM画像存在確認}
      procedure CheckRequestGetThread( Sender: TObject;
                                       ClientSocket: TServerClientWinSocket;
                                       var SocketThread: TServerClientThread );

    private
      function  WriteLogFile( Comment: String): Boolean;
  end;

var
  F_SockAns:             TF_SockAns;
  gSendOK:              Boolean;

  {INIファイル項目}
  gPORT_CHK_REQ:        Integer;
  FFileName: String;

implementation

{$R *.dfm}

//==============================================================================
// WMDropFiles(var msg: TWMDROPFILES)
//==============================================================================
procedure TF_SockAns.WMDropFiles(var msg: TWMDROPFILES);
var
  buf:  array[0..10000] of char;
begin

  msg.Result := 0;

  DragQueryFile( msg.Drop,Cardinal(-1),NIL,0 );
  DragQueryFile( msg.Drop,0,buf,sizeof( buf ) );
  FFileName := buf;
  F_SockAns.Caption := Format(CAPTIONNAME,[FFileName]);

  DragFinish( msg.Drop );
end;

//******************************************************************************
//* function name       : TF_SockAns.FormCreate
//* description         : コンストラクタ
//*   <function>
//*     各インスタンスを初期化し、アプリケーションを開始する。
//*   <include file>
//*   <calling sequence>
//*     TF_SockAns.FormCreate( Sender: TObject );
//*       Sender: TObject       (IN) 呼び出し元コンポーネント
//*   <remarks>
//******************************************************************************
procedure TF_SockAns.FormCreate( Sender: TObject );
begin
  FFileName := '';
  F_SockAns.Caption := Format(CAPTIONNAME,['']);
  DragAcceptFiles(Handle, True);

  gSendOK := True;

  //要求受信ポートオープン
  CheckSocket := TServerSocket.Create(Self);
  CheckSocket.OnGetThread := CheckRequestGetThread;
  CheckSocket.ServerType := stThreadBlocking;
end;

//******************************************************************************
//* function name       : TF_SockAns.FormDestroy
//* description         : デストラクタ
//*   <function>
//*     各インスタンスを解放し、アプリケーションを終了する。
//*   <include file>
//*   <calling sequence>
//*     TF_SockAns.FormDestroy( Sender: TObject );
//*       Sender: TObject       (IN) 呼び出し元コンポーネント
//*   <remarks>
//******************************************************************************
procedure TF_SockAns.FormDestroy( Sender: TObject );
begin
  //受信ポートクローズ
  CheckSocket.Close;
  if Assigned(CheckSocket) then FreeAndNil(CheckSocket);
end;

//******************************************************************************
//* function name       : TF_SockAns.CheckRequestGetThread
//* description         : DICOM画像存在確認電文処理スレッド生成
//*   <function>
//*     DICOM画像存在確認電文の処理を行うスレッドを生成する。
//*   <include file>
//*   <calling sequence>
//*     TF_SockAns.CheckRequestGetThread( Sender: TObject;
//*                                           ClientSocket: TServerClientWinSocket;
//*                                           var SocketThread: TServerClientThread  );
//*       Sender: TObject       (IN) 呼び出し元コンポーネント
//*       ClientSocket: TServerClientWinSocket (IN) クライアントソケット
//*       SocketThread: TServerClientThread (OUT) 生成スレッド
//*   <remarks>
//******************************************************************************
procedure TF_SockAns.CheckRequestGetThread( Sender: TObject;
                                                ClientSocket: TServerClientWinSocket;
                                                var SocketThread: TServerClientThread );
begin
  SocketThread := TCheckRequestThread.Create( False,ClientSocket );
end;

//******************************************************************************
//* function name       : TF_SockAns.WriteLogFile
//* description         : ログファイル出力
//*   <function>
//*     ログファイルにメッセージを出力
//*     （メッセージレベル≦ログ出力レベルのもののみ出力）
//*   <include file>
//*   <calling sequence>
//*     TF_SockAns.WriteLogFile( Comment: String; LogLevel: Integer ): Boolean;
//*       return: Boolean       (RET)   True=成功,False=失敗
//*       Comment: String       (IN)    メッセージ
//*       LogLevel: Integer     (IN)    メッセージレベル
//*   <remarks>
//******************************************************************************
function TF_SockAns.WriteLogFile( Comment: String): Boolean;
var
  messtr:       String;         //ログメッセージ
begin
  Result := False;

  messtr := FormatDateTime( 'yyyy/mm/dd hh:nn:ss ',Now ) + Comment;
  Memo1.Lines.Add( messtr );
end;

//******************************************************************************
//* function name       : TCheckRequestThread.ClientExecute
//* description         : DICOM画像存在確認電文処理スレッド処理
//*   <function>
//*   <include file>
//*   <calling sequence>
//*     TCheckRequestThread.ClientExecute;
//*   <remarks>
//******************************************************************************
procedure TCheckRequestThread.ClientExecute;
var
  Stream:       TWinSocketStream;       //受信電文データ
  Buffer:       String;                 //受信バッファ
  strIn:        String;                 //電文データ
  nRead:        Integer;                //読み込み長
  strHeader:    String;                 //応答電文ヘッダデータ
  strHost:      String;                 //要求ホスト名
  strAddr:      String;                 //要求ホストアドレス
  fp:   TextFile;
  lbuf: char;
  vLresCd: String;
  vLbuf: array[0..16]of Char;
  vLcnt:        Integer;
begin
  strResMes := '';

  strHost := ClientSocket.RemoteHost;
  strAddr := ClientSocket.RemoteAddress;
  strLogMsg := '要求を受信しました。Host='+strHost+'('+strAddr+')';
  Synchronize( WriteLogFile );

  //受信データ読み込み
  Stream := TWinSocketStream.Create(ClientSocket, 60000);
  try
{
    //通信ヘッダ読み込み
    Buffer := '';
    strIn := '';
    SetLength(Buffer, 64);
    Stream.Read(Buffer[1], 64);
    StrIn := Buffer;

    //個別データ読み込み
    Buffer := '';
    SetLength(Buffer, 10000);
    nRead := Stream.Read(Buffer[1], 7500-64);
    if nRead = 0 then
    begin
      strLogMsg := 'Size Error';
      Synchronize( WriteLogFile );
      ClientSocket.Close;
      Exit;
    end;
    SetLength (Buffer, nRead);
    StrIn := StrIn + Buffer;
}
    strIn := '';
    SetLength(Buffer, 4823);
    Stream.Read(Buffer[1], 4823);
    strIn := Buffer;
(*
    sleep(1000);

    SetLength(Buffer, 4804);
    Stream.Read(Buffer[1], 4804);
    strIn := strIn + Buffer;
*)


    strLogMsg := '受信バッファ取得終了';
    Synchronize( WriteLogFile );

    strLogMsg := '      '
               + '----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8----+----9----+----0'
               + '----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8----+----9----+----0'
               + '----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8----+----9----+----0'
               + '----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8----+----9----+----0'
               + '----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8----+----9----+----0'
               + '----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8----+----9----+----0'
               + '----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8----+----9----+----0'
               + '----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8----+----9----+----0'
               + '----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8----+----9----+----0';
    Synchronize( WriteLogFile );
    strLogMsg := 'Recv:[' + strIn + ']';
    Synchronize( WriteLogFile );

(*
    while not gSendOK do
    begin
      sleep(100);
    end;
*)

    if FFileName <> '' then
    begin
      AssignFile( fp,FFileName );
      Reset( fp );
      strHeader := '';
      while not Eof( fp ) do
      begin
        Read( fp,lbuf );
        strHeader := strHeader + lbuf;
      end;
      CloseFile( fp );
    end
    else
    begin

      strHeader := Copy(StrIn, 1, 32);
      case F_SockAns.RadioGroup1.ItemIndex of
        0: begin
          strHeader[21] := '0';
          strHeader[22] := '0';
          strHeader[23] := '0';
          strHeader[24] := '0';
          strHeader[25] := '0';
          strHeader[26] := '0';
          end;
        1: begin
          strHeader[21] := '9';
          strHeader[22] := '9';
          strHeader[23] := '9';
          strHeader[24] := '9';
          strHeader[25] := '9';
          strHeader[26] := '9';
          end;
      end;

      strHeader[27] := '0';
      strHeader[28] := '0';
      strHeader[29] := '0';
      strHeader[30] := '0';
      strHeader[31] := '3';
      strHeader[32] := '2';

//      strHeader[14] := '0';
    end;
    strLogMsg := '      '
               + '----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8----+----9----+----0'
               + '----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8----+----9----+----0'
               + '----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8----+----9----+----0'
               + '----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8----+----9----+----0'
               + '----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8----+----9----+----0'
               + '----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8----+----9----+----0'
               + '----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8----+----9----+----0'
               + '----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8----+----9----+----0'
               + '----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8----+----9----+----0';
    Synchronize( WriteLogFile );
    strLogMsg := 'Send:[' + strHeader + ']';
    Synchronize( WriteLogFile );
    Stream.Write( PChar(strHeader)^,Length(strHeader) );

    strLogMsg := 'SendEnd:[' + strHeader + ']';
    Synchronize( WriteLogFile );
  finally
    Stream.Free;
  end;
end;

//******************************************************************************
//* function name       : WriteLogFile
//* description         :
//*   <function>
//*     DICOM画像存在確認電文処理スレッド処理
//*   <include file>
//*   <calling sequence>
//*     ClientExecute()
//*   <remarks>
//******************************************************************************
procedure TCheckRequestThread.WriteLogFile;
begin
  F_SockAns.WriteLogFile( Format( '[%x]',[ThreadID] ) + strLogMsg );
end;

procedure TF_SockAns.CheckBox1Click(Sender: TObject);
begin
  gSendOK := not gSendOK;
end;

procedure TF_SockAns.Button1Click(Sender: TObject);
begin
  if Button1.Caption = 'Open' then
  begin
    CheckSocket.Port := StrToIntDef(Edit2.Text,7001);
    CheckSocket.Open;
    WriteLogFile(Format('受信ポート%dをオープンしました。',[CheckSocket.Port]) );
    Button1.Caption := 'Close';
  end
  else
  begin
    CheckSocket.Close;
    WriteLogFile( '受信ポートをクローズしました。' );
    Button1.Caption := 'Open';
  end;

end;

end.

