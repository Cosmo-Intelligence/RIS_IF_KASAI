// -----------------------------------------------------------------------------
//  �yDB�Ǘ��N���X�z
// -----------------------------------------------------------------------------

//------------------------------------------------------------------------------
// ���j�b�g��`
//------------------------------------------------------------------------------
unit Unit_DB;

//------------------------------------------------------------------------------
interface
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// �C���N���[�h
//------------------------------------------------------------------------------
uses
  DBXpress, DBTables, DB, SqlExpr, SysUtils, classes,
  Unit_Log, Unit_Convert;

//------------------------------------------------------------------------------
// �e���J�^��`
//------------------------------------------------------------------------------
type

  {DB�\����}
  T_DbConnect = record
    SrvName : String;     //�T�[�o���i�G�C���A�X���j
    DataBaseName : String;//�f�[�^�x�[�X���iSQL�T�[�o�[�p�j
    UserName: String;     //���[�U��
    Password: String;     //�p�X���[�h
  end;

  {DB�ڑ���{�N���X}
  T_DB = class(TSQLConnection)
  private
    { Private �錾 }
    //�g�����U�N�V�������
    FTD:    TTransactionDesc;
  protected
    //DB�ڑ���\����
    DBC:    T_DbConnect;
    //���O
    FLog:   T_Log;    //�ʏ탍�O�p�I�u�W�F�N�g
    FDbg:   T_Log;    //�f�o�b�N���O�p�I�u�W�F�N�g
  public
    { Public �錾 }
    //�R���X�g���N�^(Create)
    constructor Create(const ConnectInfo: T_DbConnect;
                       const Log, Dbg: T_Log); reintroduce; overload; virtual;
    //DataBase�ڑ��@
    function DBConnect(): Boolean; virtual; abstract;
    //DataBase�ؒf
    function DBDisConnect(): Boolean;
    //�g�����U�N�V�����J�n
    procedure StartTransaction; overload;
    //�R�~�b�g
    procedure Commit; overload;
    //���[���o�b�N
    procedure Rollback; overload;
  end;

  {DB�ڑ��N���X(SQLServer�p)}
  T_SQLDB = class(T_DB)
  public
    constructor Create(const ConnectInfo: T_DbConnect;
                       const Log, Dbg: T_Log); overload; override;
    constructor Create(const Srv, DB, User, Pass: String;
                       const Log, Dbg: T_Log); overload;
    function DBConnect(): boolean; override;
  end;

  {DB�ڑ��N���X(Oracle�p)}
  T_ORADB = class(T_DB)
  public
    constructor Create(const ConnectInfo: T_DbConnect;
                       const Log, Dbg: T_Log); overload; override;
    constructor Create(const DB, User, Pass: String;
                       const Log, Dbg: T_Log); overload;
    function DBConnect(): boolean; override;
  end;

  {SQL���s�N���X}
  T_Query = class
  private
    { Private �錾 }
    MvQuery: TSQLQuery;
    MvCode:  integer;
    MvMsg:   String;
    MvCount: integer;
  protected
    //���O
    FLog:   T_Log;    //�ʏ탍�O�p�I�u�W�F�N�g
    FDbg:   T_Log;    //�f�o�b�N���O�p�I�u�W�F�N�g
  public
    { Public �錾 }
    //�R���X�g���N�^(Create)
    constructor Create(const DB: T_DB;
                       const Log, Dbg: T_Log); overload;
    //�f�X�g���N�^�[
    destructor Destroy(); override;                       
    //���R�[�h�ړ�
    procedure Next();
    function Eof(): boolean;
    //�p�����[�^�tSQL ���s����
    procedure   PrepareQuery(szSQL: String);
    //DB�擾(Open)
    function    OpenQuery(): Integer; overload;
    function    OpenQuery(szSQL: String): Integer; overload;
    function    OpenQuery(szSQL: String;
                            var iCode: Integer;
                            var szMsg: String): Integer; overload;
    //DB�V�K/�X�V(ExecSQL)
    function    ExecSQL(): Integer; overload;
    function    ExecSQL(szSQL: String): Integer; overload;
    function    ExecSQL(szSQL: String;
                          var iCode: Integer;
                          var szMsg: String ): Integer; overload;
    //�G���[���擾(Code�w�肠��)
    procedure   GetErrInfo(const Err: EDBEngineError;
                             var iCode: Integer;
                             var szErr: String); overload;

    procedure   GetErrInfo(const Err: EDatabaseError;
                                var iCode: Integer;
                                var szErr: String); overload;
    //�p�����[�^�ݒ�
    procedure SetParam(const IpName: String; IpVal: String); overload;
    procedure SetParam(const IpName: String; IpVal: integer); overload;
    procedure SetParam(const IpName: String; IpVal: TDateTime; const IpFrm: String); overload;

    //��؂蕶����쐬
    function    GetStrJoint(szJoint: String): String;
    //�t�B�[���h���l�擾
    function    GetInteger(szFldName: String): Integer;
    //�t�B�[���h������擾
    function    GetString(szFldName: String): String; overload;
    //�t�B�[���h������擾
    function    GetString(szFldName: String;
                            iLen: Integer): String; overload;
    //�t�B�[���h������擾
    function    GetString(iFldNo: Integer): String; overload;

    //�t�B�[���h���t�^�擾
    function    GetDate(szFldName: String): TDateTime;

    //COUNT(*)�擾
    function    GetCount(szTable, szWhere: String): Integer;
    //�V�X�e�����Ԏ擾
    function    GetSysDate(): TDateTime;
    function    GetSysDateYMDHNS(): String;
    //�t��
    function    GetSequence(szSeq: String): Integer;
    //
    function    Lock(szTable: String; szWhere: String = ''): Boolean;
    //DB�Đڑ��̕K�v���̌���
    function    NeedRetry(): boolean;

    //
    property Code:  integer read MvCode;
    property Msg:   String  read MvMsg;
    property Count: integer read MvCount;
  end;

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// �e�萔
//------------------------------------------------------------------------------
const
  DATABASE    = 'Database';     //�f�[�^�x�[�X��
  USER_NAME   = 'User_Name';    //���[�U��
  PASSWORD    = 'Password';     //�p�X���[�h

  { �G���[��` }
  DB_ERR_ORA_12545 = '12545';     // �^�[�Q�b�g�z�X�g�Ȃ�
  DB_ERR_ORA_12571 = '12571';     // TNS: �p�P�b�g�E���C�^�[��Q
  DB_ERR_ORA_01034 = '1034';      // Oracle���N��
  DB_ERR_ORA_03113 = '3113';      // Oracle���ڑ�
  DB_ERR_ORA_03114 = '3114';      // Oracle���ڑ�
  DB_ERR_ORA_12560 = '12560';     // �v���g�R���A�_�v�^�G���[
  DB_ERR_ORA_12535 = '12535';     // TNS Time Out

//******************************************************************************
//* T_DB�N���X
//******************************************************************************
//******************************************************************************
//* description   : �R���X�g���N�^(Create)
//******************************************************************************
constructor T_DB.Create(const ConnectInfo: T_DbConnect;
                        const Log, Dbg: T_Log);
begin
  inherited Create( nil );
  //�ڑ����
  DBC:= ConnectInfo;
  //Log
  FLog:= Log;
  FDbg:= Dbg;
end;

//******************************************************************************
//* description   : Oracle DB�ؒf
//*   Result:   Boolean     (RET) True    : ����
//*                               False   : ���s
//*
//******************************************************************************
function T_DB.DBDisConnect(): Boolean;
begin
  try
    // �e���ݒ�
    Connected := False;
    // DB�ؒf
    Close;
    Result := True;
  except
    Result := False;
  end;
end;

//******************************************************************************
//* description   : �g�����U�N�V�����J�n
//******************************************************************************
procedure T_DB.StartTransaction;
begin
  if not InTransaction then
  begin
    FTD.TransactionID := 1;
    FTD.IsolationLevel := xilREADCOMMITTED;
    StartTransaction(FTD);
    FDbg.LOGOUT('�g�����U�N�V���� �J�n ��');
  end;
end;

//******************************************************************************
//* description   : �R�~�b�g
//******************************************************************************
procedure T_DB.Commit;
begin
  if InTransaction then
  begin
    Commit(FTD);
    FDbg.LOGOUT('�R�~�b�g ��');
  end;
end;

//******************************************************************************
//* description   : ���[���o�b�N
//******************************************************************************
procedure T_DB.Rollback;
begin
  if InTransaction then
  begin
    Rollback(FTD);
    FDbg.LOGOUT('���[���o�b�N ��');
  end;
end;


//******************************************************************************
//* T_ORADB�N���X
//******************************************************************************
//******************************************************************************
//* description   : �R���X�g���N�^(Create)
//* Result:
//*
//* ConnectInfo: T_DbConnect      (IN)  �ڑ����\����
//******************************************************************************
constructor T_ORADB.Create(const ConnectInfo: T_DbConnect;
                           const Log, Dbg: T_Log);
begin
  inherited Create(ConnectInfo, Log, Dbg);
end;

//******************************************************************************
//* description   : �R���X�g���N�^(Create)
//* Result:
//*
//* ConnectInfo: 
//******************************************************************************
constructor T_ORADB.Create(const DB, User, Pass: String;
                           const Log, Dbg: T_Log);
var
  ConnectInfo: T_DbConnect;
begin
  ConnectInfo.SrvName:=   DB;
  ConnectInfo.DataBaseName:= '';    //�g�p����
  ConnectInfo.UserName:=  User;
  ConnectInfo.Password:=  Pass;

  inherited Create(ConnectInfo, Log, Dbg);
end;

//******************************************************************************
//* description   : Oracle DB�ڑ�
//*   Result:   Boolean     (RET) True    : ����
//*                               False   : Connect���s
//*
//******************************************************************************
function T_ORADB.DBConnect: boolean;
begin

  if Connected then
  begin
    try
      ExecuteDirect( 'SELECT SYSDATE FROM DUAL' );
    except
      Connected := False;
      Result := False;
      Exit;
    end;
  end;
  try
    // �T�[�o���i�G�C���A�X���j���Ȃ���ΐڑ����Ȃ��B
    if Length(DBC.SrvName) = 0 then begin
      Result := false;
      Exit;
    end;
    // �p�����[�^���ݒ�
    Params.Values['BlobSize'] := '-1';
    Params.Values['DriverName'] := 'Oracle';
    Params.Values['Oracle TransIsolation'] := 'ReadCommited';
    Params.Values[DATABASE]   := DBC.SrvName;
    Params.Values[USER_NAME]  := DBC.UserName;
    Params.Values[PASSWORD]   := DBC.PassWord;
    // �e���ݒ�
    ConnectionName := 'Oracle';
    DriverName := 'Oracle';
    GetDriverFunc := 'getSQLDriverORACLE';
    LibraryName := 'dbexpora.dll';
    LoginPrompt    := False;
    VendorLib := 'oci.dll';
    KeepConnection := True;
    // �ڑ�
    Connected      := True;
    Result := True;
  except
    on Err : Exception do begin
      Result := False;
      FDbg.LOGOUT(Err.Message);
      FLog.LOGOUT(Err.Message);
      Exit;
    end;
  end;

end;

//******************************************************************************
//* T_SQLDB�N���X
//******************************************************************************
//******************************************************************************
//* description   : �R���X�g���N�^(Create)
//* Result:
//*
//* ConnectInfo: T_DbConnect      (IN)  �ڑ����\����
//******************************************************************************
constructor T_SQLDB.Create(const ConnectInfo: T_DbConnect;
                           const Log, Dbg: T_Log);
begin
  inherited Create(ConnectInfo, Log, Dbg);
end;

//******************************************************************************
//* description   : �R���X�g���N�^(Create)
//* Result:
//*
//* Srv:    String   (IN) �ڑ���T�[�o�[
//* DB:     String   (IN) �ڑ���DB��
//* User:   String   (IN) ���[�U�[��
//* Pass:   String   (IN) �p�X���[�h�@
//******************************************************************************
constructor T_SQLDB.Create(const Srv, DB, User, Pass: String;
                           const Log, Dbg: T_Log);
var
  ConnectInfo: T_DbConnect;
begin
  ConnectInfo.SrvName   :=    Srv;
  ConnectInfo.DataBaseName:=  DB;
  ConnectInfo.UserName  :=    User;
  ConnectInfo.Password  :=    Pass;

  inherited Create(ConnectInfo, Log, Dbg);
end;

//******************************************************************************
//* description   : SQLServer DB�ڑ�
//*   Result:   Boolean     (RET) True    : ����
//*                               False   : Connect���s
//*
//******************************************************************************
function T_SQLDB.DBConnect: boolean;
begin
  Result := True;
  if Connected then
  begin
    try
      ExecuteDirect( 'SELECT GETDATE()' );
    except
      Connected := False;
      Result := False;
      Exit;
    end;
  end;
  try
    // �T�[�o���E�f�[�^�x�[�X�����Ȃ���ΐڑ����Ȃ��B
    if ( (Length(DBC.SrvName) = 0) or (Length(DBC.DataBaseName) = 0) ) then begin
      Result := false;
      Exit;
    end;
    // �p�����[�^���ݒ�
    Params.Values['DriverName']:= 'MSSQL';
    Params.Values['DataBase']:=  DBC.DataBaseName;
    Params.Values['HostName']:=  DBC.SrvName;
    Params.Values['User_Name']:= DBC.UserName;
    Params.Values['Password']:=  DBC.Password;
    Params.Values['BlobSize']:=  '-1';
//    Params.Values['ErrorResourceFile']:=
    Params.Values['LocaleCode']:= '0000';
    Params.Values['MSSQL TransIsolation']:= 'ReadCommited';
    Params.Values['OS Authentication']:= 'False';
    // �e���ݒ�
    ConnectionName := 'MSSQLConnection';
    DriverName := 'MSSQL';
    GetDriverFunc := 'getSQLDriverMSSQL';
    LibraryName := 'dbexpmss.dll';
    LoginPrompt    := False;
    VendorLib := 'oledb';
    KeepConnection := True;
    // �ڑ�
    Connected      := True;
  except
    on Err : Exception do begin
      Result := False;
      FDbg.LOGOUT(Err.Message);
      FLog.LOGOUT(Err.Message);
      Exit;
    end;
  end;

end;


//******************************************************************************
//* T_Query�N���X
//******************************************************************************
//******************************************************************************
//* description   : �R���X�g���N�^(Create)
//* Result:
//*
//******************************************************************************
constructor T_Query.Create(const DB: T_DB;
                           const Log, Dbg: T_Log);
begin
  inherited Create();
  //Query�쐬
  MvQuery:= TSQLQuery.Create(nil);
  MvQuery.MaxBlobSize := -1;
  MvQuery.SQLConnection:= DB;

  //���O�o�̓I�u�W�F�N�g�ݒ�
  FLog:= Log;
  FDbg:= Dbg;
end;

//******************************************************************************
//* description   : �f�X�g���N�^�[
//* Result:
//*
//******************************************************************************
destructor T_Query.Destroy;
begin
  MvQuery.Free();
  inherited Destroy;
end;

//******************************************************************************
//* function name : Next;
//*
//* description   : ���R�[�h�ړ�
//*
//*  < function >
//*
//*  < calling sequence>
//*     Next;
//*
//*  < Remarks >
//*
//******************************************************************************
procedure T_Query.Next;
begin
  MvQuery.Next();
end;

//******************************************************************************
//* function name : Eof
//*
//* description   :
//*
//*  < function >
//*
//*  < calling sequence>
//*     Eof: boolean;
//*
//*  < Remarks >
//*
//******************************************************************************
function T_Query.Eof: boolean;
begin
  result:= MvQuery.Eof;
end;

//******************************************************************************
//* function name       : PrepareQuery(szSQL: String): boolean;
//* description         : �N�G�����s�����@�p�����[�^���܂�SQL�p
//*   <function>
//*     SQL(�p�����[�^�܂�)�̎��s����������
//*   <include file>
//*   <calling sequence>
//*     PrepareQuery(szSQL: String): boolean;
//*       return: Integer       (RET)   ���ʃZ�b�g���i�����Ȃ�G���[�j
//*       szSQL: String         (IN)    ���s����N�G��
//*   <remarks>
//******************************************************************************
procedure T_Query.PrepareQuery(szSQL: String);
var
  sFunc:      String;
  sERRMsg:    String;
  iCode:      integer;
  szMsg:      String;
begin
  sFunc := 'PrepareQuery';
  // ���O�o��
  sERRMsg := Format('[%s]: Start', [sFunc]);
  FDbg.LOGOUT(sERRMsg);
  sERRMsg := Format('[%s]: SQL = %s', [sFunc, szSQL]);
  FDbg.LOGOUT(sERRMsg);

  try
    with MvQuery do begin
      SQL.Clear;
      SQL.Add(szSQL);
      Close;          //�O�̂��߃N���[�Y
    end;
  except
    on Err : EDBEngineError do begin
      GetErrInfo(Err, iCode, szMsg);
      // ���O�o��
      sERRMsg := Format('[%s]: ERROR = %s', [sFunc, szMsg]);
      FDbg.LOGOUT(sERRMsg);
    end;
    on Err : EDatabaseError do begin
      GetErrInfo(Err, iCode, szMsg);
      // ���O�o��
      sERRMsg := Format('[%s]: ERROR = %s', [sFunc, szMsg]);
      FDbg.LOGOUT(sERRMsg);
    end;
  end;

  // ���O�o��
  sERRMsg := Format('[%s]: End', [sFunc]);
  FDbg.LOGOUT(sERRMsg);
end;

//******************************************************************************
//* function name       : OpenQuery
//* description         : �N�G�����s(Open)
//*   <function>
//*     SQL�������s���A���ʃZ�b�g���擾����B
//*   <include file>
//*   <calling sequence>
//*     OpenQuery(szSQL: String): Integer;
//*       return: Integer       (RET)   ���ʃZ�b�g���i�����Ȃ�G���[�j
//*       strSQL: String        (IN)    ���s����N�G��
//*   <remarks>
//******************************************************************************
function T_Query.OpenQuery(szSQL: String): Integer;
var
  iCode:    Integer;
  szMsg:    String;
begin
  Result := OpenQuery(szSQL, iCode, szMsg);

  // �G���[���ݒ�
  MvCode := iCode;
  MvMsg  := szMsg;
end;

//******************************************************************************
//* function name       : DBOpenQuery
//* description         : �N�G�����s(Open)
//*   <function>
//*     SQL�������s���A���ʃZ�b�g���擾����B
//*   <include file>
//*   <calling sequence>
//*     OpenQuery(szSQL: String;
//*               var iCode: Integer;
//*               var szMsg: String ): Integer;
//*       return: Integer       (RET)   ���ʃZ�b�g���i�����Ȃ�G���[�j
//*       strSQL: String        (IN)    ���s����N�G��
//*       intCode: String       (OUT)   �G���[�R�[�h
//*       strMsg: String        (OUT)   �G���[���b�Z�[�W
//*   <remarks>
//******************************************************************************
function T_Query.OpenQuery(szSQL: String;
                            var iCode: Integer;
                            var szMsg: String): Integer;
var
  sFunc:      String;
  sERRMsg:    String;
begin
  Result  := -1;
  iCode   := 0;
  szMsg   := '';
  MvCount := 0;

  sFunc := 'OpenQuery';
  // ���O�o��
  sERRMsg := Format('[%s]: Start', [sFunc]);
  FDbg.LOGOUT(sERRMsg);
  sERRMsg := Format('[%s]: SQL = %s', [sFunc, szSQL]);
  FDbg.LOGOUT(sERRMsg);

  try
    with MvQuery do begin
      SQL.Clear;
      SQL.Add(szSQL);
      Close;          //�O�̂��߃N���[�Y
      Open;
      First;
      while not Eof do begin
        Fields.Fields[0].AsString;
        Next;
        Inc( MvCount );
      end;
      First;
      Result := MvCount;
    end
  except
    on Err : EDBEngineError do begin
      GetErrInfo(Err, iCode, szMsg);
      // ���O�o��
      sERRMsg := Format('[%s]: ERROR = %s', [sFunc, szMsg]);
      FDbg.LOGOUT(sERRMsg);
    end;
    on Err : EDatabaseError do begin
      GetErrInfo(Err, iCode, szMsg);
      // ���O�o��
      sERRMsg := Format('[%s]: ERROR = %s', [sFunc, szMsg]);
      FDbg.LOGOUT(sERRMsg);
    end;
  end;

  // ���O�o��
  sERRMsg := Format('[%s]: End', [sFunc]);
  FDbg.LOGOUT(sERRMsg);

end;

//******************************************************************************
//* function name       : OpenQuery
//* description         : �N�G�����s�@�p�����[�^���܂�SQL�p
//*   <function>
//*     SQL�������s���A���ʃZ�b�g���擾����B
//*   <include file>
//*   <calling sequence>
//*     OpenQuery: Integer;
//*       result: integer (RET) ��������
//*   <remarks>
//*     ��� DBPrepareQuery ���ĂсA�p�����[�^�ɒl��ݒ肵����ŌĂяo���K�v����
//******************************************************************************
function T_Query.OpenQuery: Integer;
var
  sFunc:      String;
  sERRMsg:    String;
  iCode:      integer;
  szMsg:      String;
  LvCnt:      integer;
begin
  Result  := -1;
  iCode   := 0;
  szMsg   := '';
  MvCount := 0;

  sFunc := 'OpenQuery';
  // ���O�o��
  sERRMsg := Format('[%s]: Start', [sFunc]);
  FDbg.LOGOUT(sERRMsg);
  try
    with MvQuery do begin
      //�p�����[�^�@Log�o��
      for LvCnt:= 0 to Params.Count -1 do begin
        FDbg.LOGOUT( Format('�p�����[�^ ����: %s, �l: %s', [Params[LvCnt].Name, Params[LvCnt].AsString]) );
      end;
      //�I�[�v��
      Open;
      First;
      //�����擾
      while not Eof do begin
        Fields.Fields[0].AsString;
        Next;
        Inc( MvCount );
      end;
      First;
      result := MvCount;
    end;
  except
    on Err : EDBEngineError do begin
      GetErrInfo(Err, iCode, szMsg);
      // ���O�o��
      sERRMsg := Format('[%s]: ERROR = %s', [sFunc, szMsg]);
      FDbg.LOGOUT(sERRMsg);
      MvMsg:= szMsg;
    end;
    on Err : EDatabaseError do begin
      GetErrInfo(Err, iCode, szMsg);
      // ���O�o��
      sERRMsg := Format('[%s]: ERROR = %s', [sFunc, szMsg]);
      FDbg.LOGOUT(sERRMsg);
      MvMsg:= szMsg;
    end;
  end;

  // ���O�o��
  sERRMsg := Format('[%s]: End', [sFunc]);
  FDbg.LOGOUT(sERRMsg);
end;

//******************************************************************************
//* function name       : OpenQuery
//* description         : �N�G�����s(ExecSQL)
//*   <function>
//*     SQL�������s���A���ʃZ�b�g���擾����B
//*   <include file>
//*   <calling sequence>
//*     ExecSQL(szSQL: String;
//*             var iCode: Integer;
//*             var szMsg: String ): Boolean;
//*       return: Integer       (RET)   True  = ����
//*                                     False = ���s
//*       strSQL: String        (IN)    ���s����N�G��
//*   <remarks>
//******************************************************************************
function T_Query.ExecSQL(szSQL: String): Integer;
var
  iCode:  Integer;
  szMsg:  String;
begin
  Result := ExecSQL(szSQL, iCode, szMsg);

  // �G���[���ݒ�
  MvCode := iCode;
  MvMsg := szMsg;
end;

//******************************************************************************
//* function name       : ExecSQL
//* description         : �N�G�����s(ExecSQL)
//*   <function>
//*     SQL�������s���A���ʃZ�b�g���擾����B
//*   <include file>
//*   <calling sequence>
//*     ExecSQL(szSQL: String;
//*             var iCode: Integer;
//*             var szMsg: String): Boolean;
//*       return: Integer       (RET)   True  = ����
//*                                     False = ���s
//*       strSQL: String        (IN)    ���s����N�G��
//*       intCode: String       (OUT)   �G���[�R�[�h
//*       strMsg: String        (OUT)   �G���[���b�Z�[�W
//*   <remarks>
//******************************************************************************
function T_Query.ExecSQL(szSQL: String;
                          var iCode: Integer;
                          var szMsg: String): Integer;
var
  sFunc:      String;
  sERRMsg:    String;
begin
  Result  := -1;
  iCode   := 0;
  szMsg   := '';

  sFunc := 'ExecSQL';
  // ���O�o��
  sERRMsg := Format('[%s]: Start', [sFunc]);
  FDbg.LOGOUT(sERRMsg);
  sERRMsg := Format('[%s]: SQL = %s', [sFunc, szSQL]);
  FDbg.LOGOUT(sERRMsg);

  try
    with MvQuery do begin
      Close;
      SQL.Clear;
      SQL.Add(szSQL);

      ExecSQL;
      result := RowsAffected;
    end;
  except
    on Err : EDBEngineError do begin
      GetErrInfo(Err, iCode, szMsg);
      // ���O�o��
      sERRMsg := Format('[%s]: ERROR = %s', [sFunc, szMsg]);
      FDbg.LOGOUT(sERRMsg);
    end;
    on Err : EDatabaseError do begin
      GetErrInfo(Err, iCode, szMsg);
      // ���O�o��
      sERRMsg := Format('[%s]: ERROR = %s', [sFunc, szMsg]);
      FDbg.LOGOUT(sERRMsg);
    end;
  end;

  // ���O�o��
  sERRMsg := Format('[%s]: End', [sFunc]);
  FDbg.LOGOUT(sERRMsg);
end;

//******************************************************************************
//* function name       : ExecSQL
//* description         : �N�G�����s�@�p�����[�^���܂�SQL�p
//*   <function>
//*     SQL�������s���A���ʃZ�b�g���擾����B
//*   <include file>
//*   <calling sequence>
//*     ExecSQL(): Integer;
//*       return: Integer       (RET)
//*   <remarks>
//*     ��� DBPrepareQuery ���ĂсA�p�����[�^�ɒl��ݒ肵����ŌĂяo���K�v����
//******************************************************************************
function T_Query.ExecSQL: Integer;
var
  sFunc:      String;
  sERRMsg:    String;
  iCode:      integer;
  szMsg:      String;
  LvCnt:      integer;
begin
  result  := -1;
  MvCode  := 0;
  MvMsg   := '';

  sFunc := 'ExecSQL';
  // ���O�o��
  sERRMsg := Format('[%s]: Start', [sFunc]);
  FDbg.LOGOUT(sERRMsg);

  try
    with MvQuery do begin
      //�p�����[�^�@Log�o��
      for LvCnt:= 0 to Params.Count -1 do begin
        FDbg.LOGOUT( Format('�p�����[�^ ����: %s, �l: %s', [Params[LvCnt].Name, Params[LvCnt].AsString]) );
      end;

      ExecSQL;
      result := RowsAffected;
    end;
  except
    on Err : EDBEngineError do begin
      GetErrInfo(Err, iCode, szMsg);
      // ���O�o��
      sERRMsg := Format('[%s]: ERROR = %s', [sFunc, szMsg]);
      FDbg.LOGOUT(sERRMsg);
      MvMsg:= szMsg;
    end;
    on Err : EDatabaseError do begin
      GetErrInfo(Err, iCode, szMsg);
      // ���O�o��
      sERRMsg := Format('[%s]: ERROR = %s', [sFunc, szMsg]);
      FDbg.LOGOUT(sERRMsg);
      MvMsg:= szMsg;
    end;
  end;

  // ���O�o��
  sERRMsg := Format('[%s]: End', [sFunc]);
  FDbg.LOGOUT(sERRMsg);

end;

//******************************************************************************
//* function name       : SetParam
//* description         : �p�����[�^�ݒ�(������)
//*   <function>
//*
//*   <include file>
//*   <calling sequence>
//*     SetParam(const IpName: String; IpVal: String);
//*
//*   <remarks>
//******************************************************************************
procedure T_Query.SetParam(const IpName: String; IpVal: String);
var
  LvPrm:  TParam;
begin
  LvPrm:= MvQuery.ParamByName(IpName);
  LvPrm.AsString:= IpVal;
end;

//******************************************************************************
//* function name       : SetParam
//* description         : �p�����[�^�ݒ�(����)
//*   <function>
//*
//*   <include file>
//*   <calling sequence>
//*     SetParam(const IpName: String; IpVal: integer);
//*
//*   <remarks>
//******************************************************************************
procedure T_Query.SetParam(const IpName: String; IpVal: integer);
var
  LvPrm:  TParam;
begin
  LvPrm:= MvQuery.ParamByName(IpName);

  if IpVal = INVALID_NUM then begin
    LvPrm.AsString:= '';  
  end
  else begin
    LvPrm.AsString:= IntToStr( IpVal );   //AsInteger �ł̓G���[�ɂȂ�̂ŕ�����ɕϊ�
  end;
end;

//******************************************************************************
//* function name       : SetParam
//* description         : �p�����[�^�ݒ�(���t)
//*   <function>
//*
//*   <include file>
//*   <calling sequence>
//*     SetParam(const IpName: String; IpVal: TDateTime; const IpFrm: String);
//*
//*   <remarks>
//******************************************************************************
procedure T_Query.SetParam(const IpName: String; IpVal: TDateTime;
  const IpFrm: String);
var
  LvPrm:  TParam;
  LvDate: String;
begin
  LvPrm:= MvQuery.ParamByName(IpName);
  //�������t
  if IpVal = INVALID_DATE then begin
    LvPrm.AsString:= '';
  end
  else begin
    DateTimeToString(LvDate, IpFrm, IpVal);
    LvPrm.AsString:= LvDate;  
  end;
end;

//******************************************************************************
//* function name : GetErrInfo
//*
//* description   : OracleȲè�޴װ���ގ擾
//*
//*  < function >
//*
//*  < calling sequence>
//* procedure GetErr(const Err: EDBEngineError;
//*                    var Code: Integer;
//*                    var ErrMsg:String);
//*
//*   Err     : EDBEngineError  (IN)    ��O
//*   Code    : Integer         (OUT)   �擾�����װ����
//*   ErrMsg  : String          (OUT)   �擾�����װү����
//*
//*  < Remarks >
//*
//******************************************************************************
procedure T_Query.GetErrInfo(const Err: EDBEngineError;
                                var iCode: Integer;
                                var szErr: String);
{
  EDBEngineError �̏ꍇ�ɂc�a�G���[�����擾����B
�@Err:EDBEngineError��O�̎��ʎq
�@Code:Oracle�G���[�R�[�h�܂���BDE�G���[�R�[�h
  ErrMsg:�擾�����G���[���b�Z�[�W
}
var
  count: Integer;
begin
  for count := 0 to Err.ErrorCount - 1 do
  begin
    if Err.Errors[count].NativeError <> 0 then
    {Oracle�l�[�e�B�u�G���[��������}
    begin
      {Oracle�G���[���̐ݒ�}
      iCode := Err.Errors[count].NativeError;
      szErr := StringReplace(Err.Errors[count].Message,#$A,'',[rfReplaceAll]);
      exit;
    end;
  end;

  {BDE�G���[�����Ȃ����}
  {��Ԗڂ̃G���[����ݒ�}
  iCode := Err.Errors[0].ErrorCode;
  szErr := Err.Errors[0].Message;
end;

//******************************************************************************
//* function name : GetErrInfo
//*
//* description   : DB�G���[�擾�擾(DBExpress�Ή�)
//*
//*  < function >
//*
//*  < calling sequence>
//* procedure GetErr(const Err: EDatabaseError;
//*                    var Code: Integer;
//*                    var ErrMsg:String);
//*
//*   Err     : EDBEngineError  (IN)    ��O
//*   Code    : Integer         (OUT)   �擾�����װ����
//*   ErrMsg  : String          (OUT)   �擾�����װү����
//*
//*  < Remarks >
//*
//******************************************************************************
procedure T_Query.GetErrInfo(const Err: EDatabaseError;
                                var iCode: Integer;
                                var szErr: String);
begin
  szErr:= Err.Message;
end;

//******************************************************************************
//* function name : GetStrJoint
//*
//* description   : �擾�������ڂ��w�蕶���Ō�������
//*
//*  < function >
//*
//*  < calling sequence>
//* function   GetStrJoint(szJoint: String): String;
//*
//*   Result:   String  (RET)   ����������
//*   szJoint:  String  (IN)    ��������
//*
//*  < Remarks >
//*
//******************************************************************************
function   T_Query.GetStrJoint(szJoint: String): String;
var
  iCnt:   Integer;    // �J�E���^
  szRet:  String;     // ����������
begin
  // ������
  szRet := '';

  // �t�B�[���h�f�[�^�ݒ�
  with MvQuery do begin
    for iCnt := 0 to Fields.Count - 1 do begin
      // ������쐬
      if iCnt < Fields.Count - 1 then
        szRet := szRet + Fields[iCnt].AsString + szJoint
      else
        szRet := szRet + Fields[iCnt].AsString;
    end;
  end;
  Result := szRet;
end;

//******************************************************************************
//* function name : GetInteger
//*
//* description   : �t�B�[���h���l�擾
//*
//*  < function >
//*
//*  < calling sequence>
//* function    GetInteger(szFldName: String): Integer;
//*
//*   Result:     Integer (RET)   �擾���l
//*   szFldName:  String  (IN)    �t�B�[���h����
//*
//*  < Remarks >
//*
//******************************************************************************
function    T_Query.GetInteger(szFldName: String): Integer;
var
  LvField: TField;
begin
  try
    LvField:= MvQuery.FieldByName(szFldName);
    if LvField.IsNull then result:= INVALID_NUM
    else                   result := LvField.AsInteger;
  except
    result:= INVALID_NUM;
  end;
end;

//******************************************************************************
//* function name : GetString
//*
//* description   : �t�B�[���h������擾
//*
//*  < function >
//*
//*  < calling sequence>
//* function    GetString(szFldName: String): String;
//*
//*   Result:     String  (RET)   �擾������
//*   szFldName:  String  (IN)    �t�B�[���h����
//*
//*  < Remarks >
//*
//******************************************************************************
function    T_Query.GetString(szFldName: String): String;
begin
  try
    Result := MvQuery.FieldByName(szFldName).AsString;
  except
    Result := '';
  end;
end;

//******************************************************************************
//* function name : GetString
//*
//* description   : �t�B�[���h������擾
//*
//*  < function >
//*
//*  < calling sequence>
//* function    GetString(szFldName: String;
//*                                iLen: Integer): String;
//*
//*   Result:     String  (RET)   �擾������
//*   szFldName:  String  (IN)    �t�B�[���h����
//*             iLen: Integer       (IN)    �擾������
//*
//*  < Remarks >
//*
//******************************************************************************
function    T_Query.GetString(szFldName: String; iLen: Integer): String;
var
  strWork:      String;
  iAllLen:      Integer;
begin

  strWork := GetString(szFldName);
  iAllLen := Length(strWork);
  if iAllLen > iLen then
  begin
    if mbLeadByte = ByteType( strWork,iLen ) then iLen := iLen-1;
    strWork := Copy( strWork,1,iLen );
  end;

  Result := strWork;
end;

//******************************************************************************
//* function name : GetString
//*
//* description   : �t�B�[���h������擾
//*
//*  < function >
//*
//*  < calling sequence>
//* function    GetString(szFldName: String): String;
//*
//*   Result:     String  (RET)   �擾������
//*   szFldName:  String  (IN)    �t�B�[���h����
//*
//*  < Remarks >
//*
//******************************************************************************
function T_Query.GetString(iFldNo: Integer): String;
begin
  try
    Result := MvQuery.Fields.FieldByNumber(iFldNo).AsString;
  except
    Result := '';
  end;
end;

//******************************************************************************
//* function name : GetDate
//*
//* description   : �t�B�[���h���t�^�擾
//*
//*  < function >
//*
//*  < calling sequence>
//* function    GetDate(szFldName: String): TDate;
//*
//*   Result:     String  (RET)   �擾���t
//*   szFldName:  String  (IN)    �t�B�[���h����
//*
//*  < Remarks >
//*
//******************************************************************************
function T_Query.GetDate(szFldName: String): TDateTime;
var
  LvField: TField;
begin
  try
    LvField:= MvQuery.FieldByName(szFldName);
    if LvField.IsNull then result:= INVALID_DATE
    else                   result:= LvField.AsDateTime;
  except
    Result := INVALID_DATE;
  end;
end;


//******************************************************************************
//* function name : GetCount
//*
//* description   : COUNT(*)�擾
//*
//*  < function >
//*
//*  < calling sequence>
//* GetCount(szTable, szWhere: String); Integer;
//*
//*   Result:     Integer (RET)   �擾�J�E���g��
//*   szTable:    String  (IN)    �e�[�u����
//*                               �� �����e�[�u���̏ꍇ�́u,�v��؂�
//*   szWhere:    String  (IN)    �擾����
//*
//*  < Remarks >
//*
//******************************************************************************
function    T_Query.GetCount(szTable, szWhere: String): Integer;
var
  iRecCnt:    Integer;    // �擾�J�E���g
  szSQL:      String;     // SQL������
  iErrCode:   Integer;    // �G���[�R�[�h
  szErrMsg:   String;     // �G���[���b�Z�[�W
begin
  // SQL������쐬
  szSQL := 'SELECT COUNT(*) '       + #10 +
           'FROM '                  + #10 +
             szTable                + #10 +
           'WHERE '                 + #10 +
             szWhere;

  // SQL���s
  iRecCnt := OpenQuery(szSQL, iErrCode, szErrMsg);
  if iRecCnt < 0 then begin
    Result := (-1);
    exit;
  end;

  // �擾�����ݒ�
  Result := MvQuery.Fields.Fields[0].AsInteger;
end;

//******************************************************************************
//* function name : GetSequence
//*
//* description   : �t��
//*
//*  < function >
//*
//*  < calling sequence>
//* GetSequence(szSeq: String); Integer;
//*
//*   Result:     Integer (RET)   �擾�ԍ�
//*   szSeq:      String  (IN)    �V�[�P���X��
//*
//*  < Remarks >
//*
//******************************************************************************
function    T_Query.GetSequence(szSeq: String): Integer;
var
  szSQL:      String;     // SQL������
  iErrCode:   Integer;    // �G���[�R�[�h
  szErrMsg:   String;     // �G���[���b�Z�[�W
  sFunc:      String;
begin
  sFunc:= 'DBGetSequence';

  // SQL������쐬
  szSQL := '';
  szSQL := szSQL + 'SELECT ' + szSeq + '.NextVal ';
  szSQL := szSQL + 'FROM DUAL';

  szErrMsg := Format('[%s]: Start', [sFunc]);
  FDbg.LOGOUT(szErrMsg);
  szErrMsg := Format('[%s]: SQL = %s', [sFunc, szSQL]);
  FDbg.LOGOUT(szErrMsg);

  result:= -1;

  try
    with MvQuery do begin
      SQL.Clear;
      SQL.Add(szSQL);
      Close;          //�O�̂��߃N���[�Y
      Open;
      First;
      // �V�[�P���X�ԍ��擾
      Result := Fields.Fields[0].AsInteger;
    end;
  except
    on Err : EDBEngineError do begin
      GetErrInfo(Err, iErrCode, szErrMsg);
      // ���O�o��
      szErrMsg := Format('[%s]: ERROR = %s', [sFunc, szErrMsg]);
      FDbg.LOGOUT(szErrMsg);
    end;
    on Err : EDatabaseError do begin
      GetErrInfo(Err, iErrCode, szErrMsg);
      // ���O�o��
      szErrMsg := Format('[%s]: ERROR = %s', [sFunc, szErrMsg]);
      FDbg.LOGOUT(szErrMsg);
    end;
  end;

  // ���O�o��
  szErrMsg := Format('[%s]: End', [sFunc]);
  FDbg.LOGOUT(szErrMsg);
end;

//******************************************************************************
//* function name       : GetSysDate
//* description         : ���ݓ��t�擾
//*   <function>
//*
//*   <include file>
//*   <calling sequence>
//*     GetSysDate: TDateTime;
//*   <remarks>
//******************************************************************************
function T_Query.GetSysDate: TDateTime;
const
  SQL = 'SELECT SYSDATE FROM DUAL';
begin
  OpenQuery(SQL);
  result:= MvQuery.Fields[0].AsDateTime;
end;

//******************************************************************************
//* function name       : GetSysDate
//* description         : ���ݓ��t�擾
//*   <function>
//*
//*   <include file>
//*   <calling sequence>
//*     GetSysDate: TDateTime;
//*   <remarks>
//******************************************************************************
function T_Query.GetSysDateYMDHNS: String;
const
  SQL = 'SELECT SYSDATE FROM DUAL';
var
  wkDateTime: TDateTime;
begin
  try
    OpenQuery(SQL);
    wkDateTime := MvQuery.Fields[0].AsDateTime;
    Result := FormatDateTime('yyyy/mm/dd hh:nn:ss', wkDateTime);
  except
    Result := FormatDateTime('yyyy/mm/dd hh:nn:ss', now);
  end;
end;

//******************************************************************************
//* function name : Lock
//*
//* description   : �e�[�u�����b�N
//*
//*  < function >
//*
//*  < calling sequence>
//* Lock(szTable: String; szWhere: String = ''): Boolean;
//*
//*   Result:     Boolean (RET)   True=����,False=���s
//*   szTable:    String  (IN)    �e�[�u����
//*   szWhere:    String  (IN)    ���b�N���R�[�h����
//*
//*  < Remarks >
//*
//******************************************************************************
function    T_Query.Lock(szTable: String; szWhere: String = ''): Boolean;
var
  iRecCnt:    Integer;    // �擾�J�E���g
  szSQL:      String;     // SQL������
  iErrCode:   Integer;    // �G���[�R�[�h
  szErrMsg:   String;     // �G���[���b�Z�[�W
begin
  Result := True;

  // SQL������쐬
  szSQL := 'SELECT * FROM ' + szTable;
  if szWhere <> '' then begin
    szSQL := szSQL + ' WHERE ' + szWhere;
  end;
  szSQL := szSQL + ' FOR UPDATE NOWAIT';

  // SQL���s
  iRecCnt := OpenQuery(szSQL, iErrCode, szErrMsg);
  if iRecCnt < 0 then Result := False;
end;

//******************************************************************************
//* function name : NeedRetry: boolean;
//*
//* description   : DB�Đڑ��̕K�v���̌���
//*
//*  < function >
//*     DB�Đڑ��̕K�v�����邩�ǂ����𔻒肷��
//*  < calling sequence>
//*     NeedRetry: boolean;
//*
//*   Result:     Boolean (RET)   True= �K�v���� False= �K�v�Ȃ�
//*  < Remarks >
//*
//******************************************************************************
function T_Query.NeedRetry: boolean;
const
  CHECK_SQL = 'SELECT SYSDATE FROM DUAL';
var
  iRslt: integer;
  iCode: integer;
  sMsg:  string;
begin
  result:= false;

  //SQL���s
  iRslt:= OpenQuery(CHECK_SQL, iCode, sMsg);

  if iRslt >= 0 then begin
    FLog.LOGOUT('DB �ڑ��m�F OK');
    //�G���[�Ȃ�
    MvMsg:= '';
    exit;
  end;

  FLog.LOGOUT('�ڑ��m�F�� DB�G���[: ' + sMsg);
  MvMsg:= sMsg;

  //�G���[���͂Ƃɂ����Đڑ������݂�
  result:= true;
end;


end.

