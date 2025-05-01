unit main;

interface
            
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IniFiles,
  Gval,
  TcpSocket,HisMsgDef,
  FTcpEmuC,FTcpEmuS
  ;

type
  Tfrm_Main = class(TForm)
    GroupBox1: TGroupBox;
    Btn_C1: TButton;
    GroupBox2: TGroupBox;
    Btn_S2: TButton;
    Btn_S3: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Btn_C1Click(Sender: TObject);
    procedure Btn_S2Click(Sender: TObject);
    procedure Btn_C5Click(Sender: TObject);
    procedure Btn_S3Click(Sender: TObject);
    procedure Btn_S5Click(Sender: TObject);
  private
    { Private 宣言 }
    w_f1:TFrm_TcpEmuC;

    w_s2:TFrm_TcpEmuS;
    w_s3:TFrm_TcpEmuS;
    function func_IniReadString(
                                arg_Ini : TIniFile;
                                arg_Section:string;
                                arg_Key:string;
                                arg_Def:string
                                ):string;
  public
    { Public 宣言 }
  end;

var
  frm_Main: Tfrm_Main;

implementation

{$R *.DFM}

procedure Tfrm_Main.FormCreate(Sender: TObject);
var
  w_ini: TIniFile;
begin
  func_TcpReadiniFile;
  w_ini:=TIniFile.Create(g_TcpIniPath + G_TCPINI_FNAME);
  g_C_Socket_Info_01.f_IPAdrr :=
        func_IniReadString(
                           w_ini,
                           g_C_SOCKET_SECSION + '1',
                           g_SOCKET_SIP_KEY,
                           g_SOCKET_SIP);
  g_C_Socket_Info_01.f_Port :=
        func_IniReadString(
                           w_ini,
                           g_C_SOCKET_SECSION + '1',
                           g_SOCKET_SPORT_KEY,
                           g_SOCKET_SPORT);

  g_C_Socket_Info_02.f_IPAdrr :=
        func_IniReadString(
                           w_ini,
                           g_C_SOCKET_SECSION + '2',
                           g_SOCKET_SIP_KEY,
                           g_SOCKET_SIP);
  g_C_Socket_Info_02.f_Port :=
        func_IniReadString(
                           w_ini,
                           g_C_SOCKET_SECSION + '2',
                           g_SOCKET_SPORT_KEY,
                           g_SOCKET_SPORT);

  g_C_Socket_Info_03.f_IPAdrr :=
        func_IniReadString(
                           w_ini,
                           g_C_SOCKET_SECSION + '3',
                           g_SOCKET_SIP_KEY,
                           g_SOCKET_SIP);
  g_C_Socket_Info_03.f_Port :=
        func_IniReadString(
                           w_ini,
                           g_C_SOCKET_SECSION + '3',
                           g_SOCKET_SPORT_KEY,
                           g_SOCKET_SPORT);

  g_C_Socket_Info_04.f_IPAdrr :=
        func_IniReadString(
                           w_ini,
                           g_C_SOCKET_SECSION + '4',
                           g_SOCKET_SIP_KEY,
                           g_SOCKET_SIP);
  g_C_Socket_Info_04.f_Port :=
        func_IniReadString(
                           w_ini,
                           g_C_SOCKET_SECSION + '4',
                           g_SOCKET_SPORT_KEY,
                           g_SOCKET_SPORT);

  g_C_Socket_Info_05.f_IPAdrr :=
        func_IniReadString(
                           w_ini,
                           g_C_SOCKET_SECSION + '5',
                           g_SOCKET_SIP_KEY,
                           g_SOCKET_SIP);
  g_C_Socket_Info_05.f_Port :=
        func_IniReadString(
                           w_ini,
                           g_C_SOCKET_SECSION + '5',
                           g_SOCKET_SPORT_KEY,
                           g_SOCKET_SPORT);

  g_S_Socket_Info_01.f_Port :=
        func_IniReadString(
                           w_ini,
                           g_S_SOCKET_SECSION + '1',
                           g_SOCKET_PORT_KEY,
                           g_SOCKET_PORT);
  g_S_Socket_Info_02.f_Port :=
        func_IniReadString(
                           w_ini,
                           g_S_SOCKET_SECSION + '2',
                           g_SOCKET_PORT_KEY,
                           g_SOCKET_PORT);
  g_S_Socket_Info_03.f_Port :=
        func_IniReadString(
                           w_ini,
                           g_S_SOCKET_SECSION + '3',
                           g_SOCKET_PORT_KEY,
                           g_SOCKET_PORT);
  g_S_Socket_Info_04.f_Port :=
        func_IniReadString(
                           w_ini,
                           g_S_SOCKET_SECSION + '4',
                           g_SOCKET_PORT_KEY,
                           g_SOCKET_PORT);
  g_S_Socket_Info_05.f_Port :=
        func_IniReadString(
                           w_ini,
                           g_S_SOCKET_SECSION + '5',
                           g_SOCKET_PORT_KEY,
                           g_SOCKET_PORT);
  //無効の場合
  if g_C_Socket_Info_01.f_Socket_Info.f_Active = '0' then begin
    //表示なし
    Btn_C1.Visible := False;
  end
  //有効の場合
  else begin
    w_f1 := func_TcpEmuCOpen(Self,
                             g_C_Socket_Info_01.f_Socket_Info.f_EmuVisible,
                             g_C_Socket_Info_01.f_Socket_Info.f_EmuEnabled,
                             g_C_Socket_Info_01.f_Socket_Info.f_CharCode,
                             g_C_Socket_Info_01.f_IPAdrr,
                             g_C_Socket_Info_01.f_Port,
                             IntToStr(g_C_Socket_Info_01.f_TimeOut),
                             G_MSGKIND_IRAI,
                             G_MSGKIND_START
                             );
  end;
  //無効の場合
  if g_S_Socket_Info_02.f_Socket_Info.f_Active = '0' then begin
    //表示なし
    Btn_S2.Visible := False;
  end
  //有効の場合
  else begin
    w_s2 := func_TcpEmuSOpen(Self,
                             g_S_Socket_Info_02.f_Socket_Info.f_EmuVisible,
                             g_S_Socket_Info_02.f_Socket_Info.f_EmuEnabled,
                             g_S_Socket_Info_02.f_Socket_Info.f_CharCode,
                             g_S_Socket_Info_02.f_Port,
                             IntToStr(g_C_Socket_Info_02.f_TimeOut),
                             G_MSGKIND_UKETUKE,
                             G_MSGKIND_START
                             );
  end;
  //無効の場合
  if g_S_Socket_Info_03.f_Socket_Info.f_Active = '0' then begin
    //表示なし
    Btn_S3.Visible := False;
  end
  //有効の場合
  else begin
    w_s3 := func_TcpEmuSOpen(Self,
                             g_S_Socket_Info_03.f_Socket_Info.f_EmuVisible,
                             g_S_Socket_Info_03.f_Socket_Info.f_EmuEnabled,
                             g_S_Socket_Info_03.f_Socket_Info.f_CharCode,
                             g_S_Socket_Info_03.f_Port,
                             IntToStr(g_S_Socket_Info_03.f_TimeOut),
                             G_MSGKIND_JISSI,
                             G_MSGKIND_START
                             );
  end;
end;
//クライアントボタン
procedure Tfrm_Main.Btn_C1Click(Sender: TObject);
begin
  w_f1.Show;
  w_f1.Caption := '';
  w_f1.Caption := w_f1.Caption + Btn_C1.Caption;
end;

procedure Tfrm_Main.Btn_C5Click(Sender: TObject);
begin
end;
//サーバボタン
procedure Tfrm_Main.Btn_S2Click(Sender: TObject);
begin
  w_s2.Show;
  w_s2.Caption := '';
  w_s2.Caption := w_s2.Caption + Btn_S2.Caption;
end;

procedure Tfrm_Main.Btn_S3Click(Sender: TObject);
begin
  w_s3.Show;
  w_s3.Caption := '';
  w_s3.Caption := w_s3.Caption + Btn_S3.Caption;
end;

procedure Tfrm_Main.Btn_S5Click(Sender: TObject);
begin
end;
(**
●機能INIファイル読込み 文字
引数：
  arg_Ini : TIniFile;
  arg_Section:string;
  arg_Key:string;
  arg_Def:string
例外：無し
復帰値：
**)
function Tfrm_Main.func_IniReadString(
                            arg_Ini : TIniFile;
                            arg_Section:string;
                            arg_Key:string;
                            arg_Def:string
                            ):string;
var
  w_string:string;
begin
   w_string:=arg_Ini.ReadString(
                           arg_Section,
                           arg_Key,
                           arg_Def);
   if not(func_IsNullStr(w_string)) then
   begin
     result := w_string;
   end
   else
   begin
     result := arg_Def;
   end;

end;

end.
