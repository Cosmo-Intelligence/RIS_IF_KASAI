unit main;

interface
            
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IniFiles,
  Gval,
  TcpSocket,HisMsgDef,
  FTcpEmuOrd
  ;

type
  Tfrm_Main = class(TForm)
    GroupBox1: TGroupBox;
    Btn_C2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Btn_C2Click(Sender: TObject);
  private
    { Private 宣言 }
    w_f4:TFrm_TcpEmuOrd;
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
  if g_C_Socket_Info_04.f_Socket_Info.f_Active = '0' then begin
    //表示なし
    Btn_C2.Visible := False;
  end
  //有効の場合
  else begin
    w_f4 := func_TcpEmuOrdOpen(Self,
                             g_C_Socket_Info_04.f_Socket_Info.f_EmuVisible,
                             g_C_Socket_Info_04.f_Socket_Info.f_EmuEnabled,
                             g_C_Socket_Info_04.f_Socket_Info.f_CharCode,
                             g_C_Socket_Info_04.f_IPAdrr,
                             g_C_Socket_Info_04.f_Port,
                             IntToStr(g_C_Socket_Info_04.f_TimeOut),
                             G_MSGKIND_IRAI,
                             G_MSGKIND_START
                             );
  end;
end;
//クライアントボタン
procedure Tfrm_Main.Btn_C2Click(Sender: TObject);
begin
  w_f4.Show;
  w_f4.Caption := '';
  w_f4.Caption := w_f4.Caption + Btn_C2.Caption;
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
