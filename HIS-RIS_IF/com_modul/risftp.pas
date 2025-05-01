unit risftp;
{
���@�\����
 ���ʕ�
  1.INI�t�@�C�����̓Ǎ���
    func_FtpReadiniFile();
  2.Ftp�_�E�����[�h
    func_FtpDLoad();
������
�V�K�쐬�F2002.02.07�F�S�� iwai

}
interface //*****************************************************************
//�g�p���j�b�g---------------------------------------------------------------
uses
//�V�X�e���|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
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
  Math,
  //NMFtp,
  IdFTP,
  IdFTPCommon,
//�v���_�N�g�J�����ʁ|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
  Gval
  ;

////�^�N���X�錾-------------------------------------------------------------
type   //Ftp�ʐM���^�C�v
  TFtp_Info = record
     f_FtpServerName   :  string; //Ftp�T�[�o �R���s���[�^DNS���܂���IP�A�h���X
     f_FtpServerPort   :  string; //Ftp�T�[�o�|�[�g�ԍ�
     f_FtpServerVender :  string; //Ftp�T�[�o�v���b�g�t�H�[�����
     f_FtpServerUID    :  string; //Ftp�T�[�o���[�UID
     f_FtpServerPSW    :  string; //Ftp�T�[�o���[�U�p�X���[�h
     f_FtpServerTimeOut:  string; //Ftp�T�[�o LOGIN���������^�C���E�g
     f_FtpDevice       :  string; //Ftp�T�[�o �L�����u��
     f_FtpPath         :  string; //Ftp�T�[�o �t�@�C���p�X
     f_FtpFileName     :  string; //Ftp�T�[�o �t�@�C����
     f_FtpFileMode     :  string; //Ftp�T�[�o �t�@�C���]�����[�h
     f_FtpFwType       :  string; //Ftp�T�[�o �t�@�C�A�E�H�[���^�C�v
     f_FtpFwUID        :  string; //Ftp�T�[�o �t�@�C�A�E�H�[�����[�UID
     f_FtpFwPSW        :  string; //Ftp�T�[�o �t�@�C�A�E�H�[���p�X���[�h
     f_FtpProxy        :  string; //Ftp�T�[�o �v���N�V�[
     f_FtpProxyPort    :  string; //Ftp�T�[�o �v���N�V�[�|�[�g�ԍ�
     f_FtpDPathM       :  string; //�󂯎��p�X(���C��)
     f_FtpDPathS       :  string; //�󂯎��p�X(�T�u)
     f_FtpDFileName    :  string; //�󂯎��t�@�C����
     f_FtpDrive        :  string; //�摜�ۑ��h���C�u
     f_FtpSleepTime    :  string; //�ҋ@����
  end;

//�萔�錾-------------------------------------------------------------------
const
//G_FTP_INI_FNAME = 'ris_sys.ini';
  G_FTP_INI_FNAME = 'ris_ftp.ini';
  //�Z�N�V�����FFTP���
  g_FTP_SECSION    = 'FTP' ;
    g_FTP_SVR_NAME_KEY     = 'FtpServerName';//�L�[
      g_FTP_SVR_NAME_DEF   = '';//
    g_FTP_SVR_PORT_KEY     = 'FtpServerPort';//�L�[
      g_FTP_SVR_PORT_DEF   = '21';//
    g_FTP_SVR_VENDER_KEY   = 'FtpServerVender';//�L�[
      g_FTP_SVR_VENDER_DEF = '';//
    g_FTP_SVR_UID_KEY      = 'FtpServerUID';//�L�[
      g_FTP_SVR_UID_DEF    = '';//
    g_FTP_SVR_PSW_KEY      = 'FtpServerPSW';//�L�[
      g_FTP_SVR_PSW_DEF    = '';//
    g_FTP_SVR_TOUT_KEY     = 'FtpServerTimeOut';//�L�[
      g_FTP_SVR_TOUT_DEF   = '900';//�b
    g_FTP_DEV_KEY          = 'FtpDevice';//�L�[
      g_FTP_DEV_DEF        = '';//�L�[
    g_FTP_PATH_KEY         = 'FtpPath';//�L�[
      g_FTP_PATH_DEF       = '';//
    g_FTP_FNAME_KEY        = 'FtpFileName';//�L�[
      g_FTP_FNAME_DEF      = '';//
    g_FTP_DPATHM_KEY       = 'FtpDPathM';//�L�[
      g_FTP_DPATHM_DEF     = '';//
    g_FTP_DPATHS_KEY       = 'FtpDPathS';//�L�[
      g_FTP_DPATHS_DEF     = '';//
    g_FTP_DFNAME_KEY       = 'FtpDFileName';//�L�[
      g_FTP_DFNAME_DEF     = '';//
    g_FTP_FMODE_KEY        = 'FtpFileMode';//�L�[
      g_FTP_FMODE_DEF      = 'BIN';//
    g_FTP_FWTYPE_KEY       = 'FtpFwType';//�L�[
      g_FTP_FWTYPE_DEF     = '';//
    g_FTP_FWUID_KEY        = 'FtpFwUID';//�L�[
      g_FTP_FWUID_DEF      = '';//
    g_FTP_FWPSW_KEY        = 'FtpFwPSW';//�L�[
      g_FTP_FWPSW_DEF      = '';//
    g_FTP_PROXY_KEY        = 'FtpProxy';//�L�[
      g_FTP_PROXY_DEF      = '';//�L�[
    g_FTP_PROXY_PORT_KEY   = 'FtpProxyPort';//�L�[
      g_FTP_PROXY_PORT_DEF = '';//�L�[
    g_FTP_DRIVE_KEY   = 'FtpDrive';//�L�[
      g_FTP_DRIVE_DEF = 'D';//�L�[
    g_FTP_SLEEP_KEY   = 'FtpSleepTime';//�L�[
      g_FTP_SLEEP_DEF = '5';//�L�[

//�Q�ƒ萔-----------------------------------------------------------------

//�ϐ��錾-------------------------------------------------------------------
var
//���s�����---------------------
   g_Exe_Name   : string;
   g_Exe_FName  : string;
//INI�t�@�C���ꏊ-------------------
   g_FtpIniPath : string;
//INI�t�@�C�����-------------------
//FTP����
   g_Ftp_Info          :  TFtp_Info;

//�֐��葱���錾-------------------------------------------------------------
//Ini�t�@�C�����ǂݏo��
function  func_FtpReadiniFile(
      arg_IniFile:string;     //INI�t�@�C���̑��݃t���p�X�w��
  var arg_Ftp_Info:TFtp_Info  //Ftp���i�[��
      ): Boolean;             //True�F���� False�F�ُ�
//�t�@�C���̃_�E�����[�h
function func_FtpDLoad(
      arg_FtpInfo : TFtp_Info;  //Ftp���i�[��
      arg_SrcFileName:string;   //�_�E�����[�h���t�@�C����
      arg_DesDirMName:string;   //�_�E�����[�h��f�B���N�g����(���C��)
      arg_DesDirSName:string;   //�_�E�����[�h��f�B���N�g����(�T�u)
      arg_DesFileName:string;   //�_�E�����[�h��t�@�C����
      arg_FtpMode    :integer;  //Ftp�]�����[�h 1 2 3
  var arg_ErrFlg     :string;   //�G���[�������̌��� '0':����,'1':�ڑ��G���[,'2':�擾���s,'3':���̑�
  Var arg_ErrMsg:string         //�G���[�������b�Z�[�W
      //arg_F:TFailureEvent       //�G���[�����ʒm�C�x���g
      ):Boolean;                //True�F���� False�F�ُ�
function func_FtpConnect(
      arg_FtpInfo : TFtp_Info;  //Ftp���
  var arg_ErrFlg  :string;   //�G���[�������̌��� '0':����,'1':�ڑ��G���[,'2':�擾���s,'3':���̑�
  var arg_ErrMsg  :string    //�G���[�������̌������b�Z�[�W�̒~��
      //arg_F:TFailureEvent       //�G���[�����ʒm�C�x���g
      ):Boolean;                //True�F���� False�F�ُ�
//�t�@�C���̃A�b�v���[�h
function func_FtpUPLoad(
      arg_FtpInfo : TFtp_Info;     //Ftp���i�[��
      arg_UpFolerMainName:string;  //�A�b�v���[�h��t�H���_��(���C��)
      arg_UpFolerSubName:string;   //�A�b�v���[�h��t�H���_��(�T�u)
      arg_UpFolerSub2Name:string;  //�A�b�v���[�h��t�H���_��(�T�u"���Ҕԍ�")
      arg_UpFileFullPas:string;    //�A�b�v���[�h�t�@�C���t���p�X�i�t�@�C�����܂ށj
      arg_FtpMode    :integer;     //Ftp�]�����[�h 1 2 3
  var arg_ErrFlg     :string;   //�G���[�������̌��� '0':����,'1':�ڑ��G���[,'2':�]�����s,'3':���̑�
  Var arg_ErrMsg:string         //�G���[�������b�Z�[�W
      //arg_F:TFailureEvent       //�G���[�����ʒm�C�x���g
      ):Boolean;                //True�F���� False�F�ُ�

implementation //**************************************************************

//�g�p���j�b�g---------------------------------------------------------------
//uses

//�萔�錾       -------------------------------------------------------------
const
 G_VERSION_STR = 'Ver1.0.0.0';
 G_MODE_ASCII  = 'MODE_ASCII';
 G_MODE_IMAGE  = 'MODE_IMAGE';
 G_MODE_BYTE   = 'MODE_IMAGE';
//INI�t�@�C������`---------------------------------------------------------
//const

//���̑��萔-----------------------------------------------------------------

//�ϐ��錾     ---------------------------------------------------------------
//var

//�֐��葱���錾--------------------------------------------------------------
//-----------------------------------------------------------------------------
//3.INI�t�@�C���n
//-----------------------------------------------------------------------------
(**
���@�\INI�t�@�C���Ǎ��� ����
�����F
  arg_Ini : TIniFile;
  arg_Section:string;
  arg_Key:string;
  arg_Def:string
��O�F����
���A�l�F
**)
function func_IniReadString(
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
                               arg_Def
                               );
  if not(func_IsNullStr(w_string)) then begin
    result := w_string;
  end
  else begin
    result := arg_Def;
  end;
end;
(**
���@�\INI�t�@�C���Ǎ��� ���l
�����F
  arg_Ini : TIniFile;
  arg_Section:string;
  arg_Key:string;
  arg_Def:string
��O�F����
���A�l�F
**)
function func_IniReadInt(
                         arg_Ini : TIniFile;
                         arg_Section:string;
                         arg_Key:string;
                         arg_Def:string
                         ):Longint;
var
  w_string:string;
begin
  w_string:=arg_Ini.ReadString(
                               arg_Section,
                               arg_Key,
                               arg_Def
                               );
  if not(func_IsNullStr(w_string)) then begin
    result := StrToIntDef(w_string,0);
  end
  else begin
    result := StrToIntDef(arg_Def,0);
  end;
end;

//���@�\ INI�t�@�C���̓Ǎ���
//�����Farg_IniFile
//     arg_IniFile   INI�t�@�C���̑��݃t���p�X�w��
//     arg_Ftp_Info  Ftp���i�[��
//��O�F�Ȃ�
//���A�l�FTrue�F���� False�F�ُ�
function func_FtpReadiniFile(
      arg_IniFile:string;
  var arg_Ftp_Info:TFtp_Info
      ):Boolean;
var
  w_ini: TIniFile;
begin
  Result:=True;
  try
    w_ini:=TIniFile.Create(arg_IniFile);
    try
      //FTP���
      arg_Ftp_Info.f_FtpServerName :=
            func_IniReadString(
                               w_ini,
                               g_FTP_SECSION,
                               g_FTP_SVR_NAME_KEY,
                               g_FTP_SVR_NAME_DEF);
      arg_Ftp_Info.f_FtpServerPort :=
            func_IniReadString(
                               w_ini,
                               g_FTP_SECSION,
                               g_FTP_SVR_PORT_KEY,
                               g_FTP_SVR_PORT_DEF);
      arg_Ftp_Info.f_FtpServerVender :=
            func_IniReadString(
                               w_ini,
                               g_FTP_SECSION,
                               g_FTP_SVR_VENDER_KEY,
                               g_FTP_SVR_VENDER_DEF);
      arg_Ftp_Info.f_FtpServerUID :=
            func_IniReadString(
                               w_ini,
                               g_FTP_SECSION,
                               g_FTP_SVR_UID_KEY,
                               g_FTP_SVR_UID_DEF);
      arg_Ftp_Info.f_FtpServerPSW :=
            func_IniReadString(
                               w_ini,
                               g_FTP_SECSION,
                               g_FTP_SVR_PSW_KEY,
                               g_FTP_SVR_PSW_DEF);
      arg_Ftp_Info.f_FtpServerTimeOut :=
            func_IniReadString(
                               w_ini,
                               g_FTP_SECSION,
                               g_FTP_SVR_TOUT_KEY,
                               g_FTP_SVR_TOUT_DEF);
      arg_Ftp_Info.f_FtpDevice :=
            func_IniReadString(
                               w_ini,
                               g_FTP_SECSION,
                               g_FTP_DEV_KEY,
                               g_FTP_DEV_DEF);
      arg_Ftp_Info.f_FtpPath :=
            func_IniReadString(
                               w_ini,
                               g_FTP_SECSION,
                               g_FTP_PATH_KEY,
                               g_FTP_PATH_DEF);
      arg_Ftp_Info.f_FtpFileName :=
            func_IniReadString(
                               w_ini,
                               g_FTP_SECSION,
                               g_FTP_FNAME_KEY,
                               g_FTP_FNAME_DEF);
      arg_Ftp_Info.f_FtpDPathM :=
            func_IniReadString(
                               w_ini,
                               g_FTP_SECSION,
                               g_FTP_DPATHM_KEY,
                               g_FTP_DPATHM_DEF);
      arg_Ftp_Info.f_FtpDPathS :=
            func_IniReadString(
                               w_ini,
                               g_FTP_SECSION,
                               g_FTP_DPATHS_KEY,
                               g_FTP_DPATHS_DEF);
      arg_Ftp_Info.f_FtpDFileName :=
            func_IniReadString(
                               w_ini,
                               g_FTP_SECSION,
                               g_FTP_DFNAME_KEY,
                               g_FTP_DFNAME_DEF);

      arg_Ftp_Info.f_FtpDrive :=
            func_IniReadString(
                               w_ini,
                               g_FTP_SECSION,
                               g_FTP_DRIVE_KEY,
                               g_FTP_DRIVE_DEF);
      arg_Ftp_Info.f_FtpSleepTime :=
               IntToStr(func_IniReadInt(
                               w_ini,
                               g_FTP_SECSION,
                               g_FTP_SLEEP_KEY,
                               g_FTP_SLEEP_DEF));


      arg_Ftp_Info.f_FtpFileMode :=
            func_IniReadString(
                               w_ini,
                               g_FTP_SECSION,
                               g_FTP_FMODE_KEY,
                               g_FTP_FMODE_DEF);
      arg_Ftp_Info.f_FtpFwType :=
            func_IniReadString(
                               w_ini,
                               g_FTP_SECSION,
                               g_FTP_FWTYPE_KEY,
                               g_FTP_FWTYPE_DEF);
      arg_Ftp_Info.f_FtpFwUID :=
            func_IniReadString(
                               w_ini,
                               g_FTP_SECSION,
                               g_FTP_FWUID_KEY,
                               g_FTP_FWUID_DEF);
      arg_Ftp_Info.f_FtpFwPSW :=
            func_IniReadString(
                               w_ini,
                               g_FTP_SECSION,
                               g_FTP_FWPSW_KEY,
                               g_FTP_FWPSW_DEF);
      arg_Ftp_Info.f_FtpProxy :=
            func_IniReadString(
                               w_ini,
                               g_FTP_SECSION,
                               g_FTP_PROXY_KEY,
                               g_FTP_PROXY_DEF);
      arg_Ftp_Info.f_FtpProxyPort :=
            func_IniReadString(
                               w_ini,
                               g_FTP_SECSION,
                               g_FTP_PROXY_PORT_KEY,
                               g_FTP_PROXY_PORT_DEF);

    finally
      w_ini.Free;
    end;
    exit;
  except
    Result:=False;
    exit;
  end;

end;
(**
���@�\ Ftp�T�[�o����t�@�C���̃_�E�����[�h
�����F
  arg_FtpInfo    :TFtp_Info;
  arg_SrcFileName:string;
  arg_DesDirMName:string;
  arg_DesDirSName:string;
  arg_DesFileName:string;
  arg_FtpMode    :string;
  arg_ErrFlg     :string;
  arg_ErrMsg     :string�G

��O�F����
���A�l�FTrue:���� False�F�ُ�
**)
function func_FtpDLoad(
      arg_FtpInfo : TFtp_Info;  //Ftp���
      arg_SrcFileName:string;   //�_�E�����[�h�Ώۃt�@�C����
      arg_DesDirMName:string;   //�_�E�����[�h��f�B���N�g����(���C��)
      arg_DesDirSName:string;   //�_�E�����[�h��f�B���N�g����(�T�u)
      arg_DesFileName:string;   //�_�E�����[�h�惍�[�J���t�@�C����
      arg_FtpMode    :integer;  //�]�����[�h123
  var arg_ErrFlg     :string;   //�G���[�������̌��� '0':����,'1':�ڑ��G���[,'2':�擾���s,'3':���̑�
  var arg_ErrMsg     :string    //�G���[�������̌������b�Z�[�W�̒~��
      //arg_F:TFailureEvent       //�G���[�����ʒm�C�x���g
      ):Boolean;                //True�F���� False�F�ُ�
var
  //w_Ftp:TNMFTP;   //FTP�I�u�W�F�N�g
  w_Ftp:TIdFTP;   //FTP�I�u�W�F�N�g
  w_SPath:string; //�\�[�X�t�@�C���p�X
  w_SFile:string; //�\�[�X�t�@�C��
  w_DPath:string; //�f�X�g�t�@�C���p�X

  w_FileDir: string;
begin
//0.�������� �N���A������
  arg_ErrMsg:='';
  w_SPath:='';
  arg_ErrFlg := '0';
  try
//1.FTP�I�u�W�F�N�g�̍쐬
    w_Ftp:=TIdFTP.Create(nil);
    try
//2.���̐ݒ�
      //w_Ftp.ParseList:=true;
      w_Ftp.Passive:=False;
      //w_Ftp.OnFailure:=arg_F;
   //2.1�K�{
      //���葤IP�܂��̓}�V����
      w_Ftp.Host := arg_FtpInfo.f_FtpServerName;
      //���葤���O�C�����[�U�[
      w_Ftp.Username := arg_FtpInfo.f_FtpServerUID;
      //���葤���O�C���p�X���[�h
      w_Ftp.Password := arg_FtpInfo.f_FtpServerPSW;
   //2.2�I�v�V����
      //�g�p�|�[�g
      if not(func_IsNullStr(arg_FtpInfo.f_FtpServerPort)) then
        w_Ftp.Port := StrToIntDef(arg_FtpInfo.f_FtpServerPort,21);

      if not(func_IsNullStr(arg_FtpInfo.f_FtpDevice)) then begin
          w_SPath:=w_SPath+arg_FtpInfo.f_FtpDevice;
      end;
//3.FTP��Connect
      try
        w_Ftp.Connect;
      except
        on E: Exception do begin
          arg_ErrFlg := '1';
          arg_ErrMsg := '�T�[�o�̐ڑ��Ɏ��s���܂����B�u'+ E.Message + '�v';
          Result := False;
          Exit;
        end;
      end;
      try
//4.���Ɛ�̃f�B���N�g���𐮂���
//4.1 ���FTNMFTP.ChangeDir
        if not(func_IsNullStr(arg_FtpInfo.f_FtpPath)) then begin
          w_SPath:=w_SPath+arg_FtpInfo.f_FtpPath;
          w_Ftp.ChangeDir(w_SPath);
        end;

        if (func_IsNullStr(arg_SrcFileName)) then begin
          w_SFile:=arg_FtpInfo.f_FtpPath;
        end
        else begin
          w_SFile:=arg_SrcFileName;
        end;
//4.2 ��F���[�J���h���C�u�f�B���N�g���̐ݒ�
        if (func_IsNullStr(arg_DesFileName)) then begin
          if (func_IsNullStr(arg_DesDirMName)) and
             (func_IsNullStr(arg_DesDirSName)) then begin
            w_DPath:=arg_FtpInfo.f_FtpDPathM+arg_FtpInfo.f_FtpDPathS+arg_FtpInfo.f_FtpDFileName;
          end
          else begin
            w_DPath:=arg_DesDirMName+arg_DesDirSName+arg_FtpInfo.f_FtpDFileName;
          end;
        end
        else begin
          if (func_IsNullStr(arg_DesDirMName)) and
             (func_IsNullStr(arg_DesDirSName)) then begin
            w_DPath:=arg_FtpInfo.f_FtpDPathM+arg_FtpInfo.f_FtpDPathS+arg_DesFileName;
          end
          else begin
            w_DPath:=arg_DesDirMName+arg_DesDirSName+arg_DesFileName;
          end;
        end;
//4.2.1 ��f�B���N�g���m�F
        w_FileDir := ExtractFileDir(w_DPath);
        if not(DirectoryExists(w_FileDir)) then begin
          if not CreateDir(w_FileDir) then
            raise Exception.Create('Cannot create '+w_FileDir);
        end;
//4.3�]��Mode�ݒ�
        if (arg_FtpMode<>1) and        //ASCII
           (arg_FtpMode<>2) and        //�C���[�W
           (arg_FtpMode<>3) then begin //�o�C�g
          //�C���[�W�E�o�C�g
          w_Ftp.TransferType := ftBinary;
        end
        else begin
          if arg_FtpMode = 1 then
            //ASCII
            w_Ftp.TransferType := ftASCII
          else
            //�C���[�W�E�o�C�g
            w_Ftp.TransferType := ftBinary;
        end;
//5.�_�E�����[�h
        try
          w_Ftp.Get(w_SFile,w_DPath,True);
        except
          on E: Exception do begin
            arg_ErrFlg := '2';
            arg_ErrMsg := 'FTP�T�[�o�ɊY���t�@�C��������܂���ł����B�t�@�C���p�X���F' + arg_SrcFileName;
            Result := False;
            Exit;
          end;
        end;
//6.FTP��DisConnect
      Finally
        w_Ftp.Disconnect;
      end;
//7.FTP�I�u�W�F�N�g�̉��
    Finally
      w_Ftp.Free;
    end;
//8.���A�l�̐ݒ�
    result:=True;
    exit;
//10.�G���[��O����
  except
    on E: Exception do
    begin
      arg_ErrMsg := arg_ErrMsg+E.Message;
      arg_ErrFlg := '3';
      Result:=False;
      exit;
    end;
  end;

end;
(**
���@�\ Ftp�T�[�o�̐ڑ��m�F
�����F
  arg_FtpInfo    :TFtp_Info;
  arg_ErrFlg     :string;
  arg_ErrMsg     :string�G

��O�F����
���A�l�FTrue:���� False�F�ُ�
**)
function func_FtpConnect(
      arg_FtpInfo : TFtp_Info;  //Ftp���
  var arg_ErrFlg  :string;   //�G���[�������̌��� '0':����,'1':�ڑ��G���[,'2':�擾���s,'3':���̑�
  var arg_ErrMsg  :string    //�G���[�������̌������b�Z�[�W�̒~��
      //arg_F:TFailureEvent       //�G���[�����ʒm�C�x���g
      ):Boolean;                //True�F���� False�F�ُ�
var
  //w_Ftp:TNMFTP;   //FTP�I�u�W�F�N�g
  w_Ftp:TIdFTP;   //FTP�I�u�W�F�N�g
  w_SPath:String;
begin
//0.�������� �N���A������
  arg_ErrMsg:='';
  w_SPath:='';
  arg_ErrFlg := '0';
  try
//1.FTP�I�u�W�F�N�g�̍쐬
    w_Ftp:=TIdFTP.Create(nil);
    try
//2.���̐ݒ�
      //w_Ftp.ParseList:=true;
      w_Ftp.Passive:=False;
      //w_Ftp.OnFailure:=arg_F;
   //2.1�K�{
      //���葤IP�܂��̓}�V����
      w_Ftp.Host := arg_FtpInfo.f_FtpServerName;
      //���葤���O�C�����[�U�[
      w_Ftp.Username := arg_FtpInfo.f_FtpServerUID;
      //���葤���O�C���p�X���[�h
      w_Ftp.Password := arg_FtpInfo.f_FtpServerPSW;
   //2.2�I�v�V����
      //�g�p�|�[�g
      if not(func_IsNullStr(arg_FtpInfo.f_FtpServerPort)) then
        w_Ftp.Port := StrToIntDef(arg_FtpInfo.f_FtpServerPort,21);

      if not(func_IsNullStr(arg_FtpInfo.f_FtpDevice)) then begin
          w_SPath:=w_SPath+arg_FtpInfo.f_FtpDevice;
      end;
      try
//3.FTP��Connect
        try
          w_Ftp.Connect;
        except
          on E: Exception do begin
            arg_ErrFlg := '1';
            arg_ErrMsg := '�T�[�o�̐ڑ��Ɏ��s���܂����B�u'+ E.Message + '�v';
            Result := False;
            Exit;
          end;
        end;
//6.FTP��DisConnect
      Finally
        w_Ftp.Disconnect;
      end;
//7.FTP�I�u�W�F�N�g�̉��
    Finally
      w_Ftp.Free;
    end;
//8.���A�l�̐ݒ�
    result:=True;
    exit;
//10.�G���[��O����
  except
    on E: Exception do
    begin
      arg_ErrMsg := arg_ErrMsg+E.Message;
      arg_ErrFlg := '3';
      Result:=False;
      exit;
    end;
  end;

end;
//�t�@�C���̃A�b�v���[�h
function func_FtpUPLoad(
      arg_FtpInfo : TFtp_Info;     //Ftp���i�[��
      arg_UpFolerMainName:string;  //�A�b�v���[�h��t�H���_��(���C��)
      arg_UpFolerSubName:string;   //�A�b�v���[�h��t�H���_��(�T�u"�����ԍ�")
      arg_UpFolerSub2Name:string;  //�A�b�v���[�h��t�H���_��(�T�u"���Ҕԍ�")
      arg_UpFileFullPas:string;    //�A�b�v���[�h�t�@�C���t���p�X�i�t�@�C�����܂ށj
      arg_FtpMode    :integer;     //Ftp�]�����[�h 1 2 3
  var arg_ErrFlg     :string;   //�G���[�������̌��� '0':����,'1':�ڑ��G���[,'2':�]�����s,'3':���̑�
  Var arg_ErrMsg:string         //�G���[�������b�Z�[�W
      ):Boolean;                //True�F���� False�F�ُ�
var
  w_Ftp:TIdFTP;   //FTP�I�u�W�F�N�g
  WSLDList: TStrings;
  w_SPath:String;
  WILoop: Integer;
  WBFlg: Boolean;
  WSImagePas: String;
begin
  //0.�������� �N���A������
  arg_ErrMsg:='';
  arg_ErrFlg := '0';
  try
    //1.FTP�I�u�W�F�N�g�̍쐬
    w_Ftp:=TIdFTP.Create(nil);
    try
      //2.���̐ݒ�
      w_Ftp.Passive:=False;
      //2.1�K�{
      //���葤IP�܂��̓}�V����
      w_Ftp.Host := arg_FtpInfo.f_FtpServerName;
      //���葤���O�C�����[�U�[
      w_Ftp.Username := arg_FtpInfo.f_FtpServerUID;
      //���葤���O�C���p�X���[�h
      w_Ftp.Password := arg_FtpInfo.f_FtpServerPSW;
      //2.2�I�v�V����
      //�g�p�|�[�g
      if not(func_IsNullStr(arg_FtpInfo.f_FtpServerPort)) then
        w_Ftp.Port := StrToIntDef(arg_FtpInfo.f_FtpServerPort,21);

      if not(func_IsNullStr(arg_FtpInfo.f_FtpDevice)) then begin
        w_SPath := w_SPath+arg_FtpInfo.f_FtpDevice;
      end;
      //3.FTP�̐ڑ��m�F
      try
        w_Ftp.Connect;
      except
        on E: Exception do begin
          arg_ErrFlg := '1';
          arg_ErrMsg := '�T�[�o�̐ڑ��Ɏ��s���܂����B�u'+ E.Message + '�v';
          Result := False;
          Exit;
        end;
      end;
      //4.�J�����g�f�B���N�g���̕ύX
      try
        w_Ftp.ChangeDir(arg_UpFolerMainName);
      except
        on E:Exception do
        begin
          arg_ErrFlg := '3';
          arg_ErrMsg := '�J�����g�f�B���N�g���̕ύX�Ɏ��s���܂����B�u' +
                        arg_UpFolerMainName + '�v�i' + E.Message + '�j';
          Result := False;
          Exit;
        end;
      end;
      try
        WSLDList := TStringList.Create;

        //5.�T�u�f�B���N�g���̑��݊m�F
        //5.1�J�����g�f�B���N�g���̃t�H���_�܂��̓t�@�C�������ׂĎ擾
        w_Ftp.List(WSLDList, '', False);
        //������
        WBFlg := False;
        //�擾�f�[�^��
        for WILoop := 0 to WSLDList.Count - 1 do
        begin
          //�t�H���_�̏ꍇ
          if w_Ftp.Size(WSLDList.Strings[WILoop]) = -1 then
          begin
            //�i�[��t�H���_�����łɂ���ꍇ
            if WSLDList.Strings[WILoop] = arg_UpFolerSubName then
            begin
              //�t���O�ݒ�
              WBFlg := True;
              //�����I��
              Break;
            end;
          end;
        end;
        //���ꖼ�̃t�H���_���Ȃ��ꍇ
        if not WBFlg then
        begin
          try
            w_Ftp.MakeDir(arg_UpFolerSubName);
            w_Ftp.ChangeDir(arg_UpFolerSubName);
          except
            on E:Exception do
            begin
              arg_ErrFlg := '3';
              arg_ErrMsg := '�f�B���N�g���̍쐬�Ɏ��s���܂����B�u' +
                            arg_UpFolerSubName + '�v�i' + E.Message + '�j';
              Result := False;
              Exit;
            end;
          end;
        end
        //����t�H���_������ꍇ
        else
        begin
          //�J�����g�f�B���N�g���̕ύX
          try
            w_Ftp.ChangeDir(arg_UpFolerSubName);
          except
            on E:Exception do
            begin
              arg_ErrFlg := '3';
              arg_ErrMsg := '�J�����g�f�B���N�g���̕ύX�Ɏ��s���܂����B�u' +
                            arg_UpFolerSubName + '�v�i' + E.Message + '�j';
              Result := False;
              Exit;
            end;
          end;
        end;

        {
        FreeAndNil(WSLDList);
        WSLDList := TStringList.Create;

        //5.�T�u�f�B���N�g���̑��݊m�F
        //5.1�J�����g�f�B���N�g���̃t�H���_�܂��̓t�@�C�������ׂĎ擾
        w_Ftp.List(WSLDList, '', False);
        //������
        WBFlg := False;
        //�擾�f�[�^��
        for WILoop := 0 to WSLDList.Count - 1 do
        begin
          //�t�H���_�̏ꍇ
          if w_Ftp.Size(WSLDList.Strings[WILoop]) = -1 then
          begin
            //�i�[��t�H���_�����łɂ���ꍇ
            if WSLDList.Strings[WILoop] = arg_UpFolerSub2Name then
            begin
              //�t���O�ݒ�
              WBFlg := True;
              //�����I��
              Break;
            end;
          end;
        end;
        //���ꖼ�̃t�H���_���Ȃ��ꍇ
        if not WBFlg then
        begin
          try
            w_Ftp.MakeDir(arg_UpFolerSub2Name);
            w_Ftp.ChangeDir(arg_UpFolerSub2Name);
          except
            on E:Exception do
            begin
              arg_ErrFlg := '3';
              arg_ErrMsg := '�f�B���N�g���̍쐬�Ɏ��s���܂����B�u' +
                            arg_UpFolerSub2Name + '�v�i' + E.Message + '�j';
              Result := False;
              Exit;
            end;
          end;
        end
        //����t�H���_������ꍇ
        else
        begin
          //�J�����g�f�B���N�g���̕ύX
          try
            w_Ftp.ChangeDir(arg_UpFolerSub2Name);
          except
            on E:Exception do
            begin
              arg_ErrFlg := '3';
              arg_ErrMsg := '�J�����g�f�B���N�g���̕ύX�Ɏ��s���܂����B�u' +
                            arg_UpFolerSub2Name + '�v�i' + E.Message + '�j';
              Result := False;
              Exit;
            end;
          end;
        end;
      }
      finally
        if WSLDList <> nil then
          FreeAndNil(WSLDList);
      end;

      //6.�]��Mode�ݒ�
      if (arg_FtpMode<>1) and   //ASCII
         (arg_FtpMode<>2) and   //�C���[�W
         (arg_FtpMode<>3) then  //�o�C�g
      begin 
        //�C���[�W�E�o�C�g
        w_Ftp.TransferType := ftBinary;
      end
      else
      begin
        if arg_FtpMode = 1 then
          //ASCII
          w_Ftp.TransferType := ftASCII
        else
          //�C���[�W�E�o�C�g
          w_Ftp.TransferType := ftBinary;
      end;
      //7.�t�@�C���̓]��
      try
        // �摜�t�H���_�̃h���C�u�̂ݕύX
        WSImagePas := arg_FtpInfo.f_FtpDrive + Copy(arg_UpFileFullPas, 2, Length(arg_UpFileFullPas));
        {
        //if FileSetAttr(WSImagePas, faAnyFile) = 0 then
        if FileSetAttr(WSImagePas, faReadOnly) = 0 then
        begin
          arg_ErrFlg := '2';
          arg_ErrMsg := '�t�@�C����PUT�Ɏ��s���܂����B�u' +
                        arg_UpFileFullPas + '�v�i�t�@�C���̑����̕ύX�G���[�j';
          Result := False;
          Exit;
        end;
        }
        // �t�@�C���]��
        w_Ftp.Put(WSImagePas, ExtractFileName(WSImagePas));
      except
        on E:Exception do
        begin
          arg_ErrFlg := '2';
          arg_ErrMsg := '�t�@�C����PUT�Ɏ��s���܂����B�u' +
                        arg_UpFileFullPas + '�v�i' + E.Message + '�j';
          Result := False;
          Exit;
        end;
      end;
    //8.FTP�I�u�W�F�N�g�̉��
    Finally
      w_Ftp.Free;
    end;
    //9.���A�l�̐ݒ�
    result := True;
    exit;
    //10.�G���[��O����
  except
    on E: Exception do
    begin
      arg_ErrMsg := arg_ErrMsg+E.Message;
      arg_ErrFlg := '3';
      Result:=False;
      exit;
    end;
  end;
end;

//-----------------------------------------------------------------------------
initialization
begin

//1)�N��PASS���m��
     g_FtpIniPath := ExtractFilePath( ParamStr(0) );
//�R�}���hEXE�t�@�C����
     g_Exe_FName  := ExtractFileName( ParamStr(0) );
//�R�}���hEXE�t�@�C�����v���t�B�b�N�X
     g_Exe_Name   := ChangeFileExt( g_Exe_FName, '' );
//�f�t�H���g�ŋN���f�B���N�g����INI��ǂݍ���
    func_FtpReadiniFile(g_FtpIniPath + G_FTP_INI_FNAME,g_Ftp_Info);
end;

finalization
begin
//
end;

end.
