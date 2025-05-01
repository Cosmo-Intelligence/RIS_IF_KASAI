//******************************************************************************
//* unit name   : U_IFData
//* author      : M.Suzuki(ForeSight)
//* description : DICOM�摜�v���@�\�|DICOM�摜�����@�\�Ԃ̃C���^�t�F�[�X
//******************************************************************************
unit U_IFData;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, DateUtils;

type
  {DICOM�摜���݊m�F���ʃf�[�^�Z�b�g}
  RES_DATASET = record
    StudyUID:	        String;         //StudyInstanceUID
    SeriesUID:	        String;         //SeriesInstanceUID
    ImageNum:	        Integer;        //Image��
    SOPUID:             array of String;//SOPInstanceUID
  end;

  {JPEG/DICOM�t�@�C���ۑ�����}
  DICOM_RESULT = record
    FileName:           String;         //�t�@�C����
    StudyUID:           String;         //StudyInstanceUID
    SeriesUID:          String;         //SeriesInstanceUID
    SOPUID:             String;         //SOPInstanceUID
    Reason:             Integer;        //���s���R
  end;

  {�ʐM�w�b�_}
  TO_IFHeader = class( TObject )
    private
      StreamData:	String;         //�d���f�[�^

      {��M�f�[�^���f�R�[�h}
      function	        Decode: Boolean;
      {�C���X�^���X���G���R�[�h}
      procedure         Encode;

    public
      CreateDate:	TDateTime;      //�쐬����
      DataKind:         String;         //�v�����
      DataSize:	        Integer;        //�ʕ��f�[�^�T�C�Y

      {�R���X�g���N�^}
      constructor	Create; overload;
      constructor	Create( Buffer: String; intLen: Integer ); overload;

      {������}
      procedure         Clear;
      {��M�f�[�^���C���X�^���X�ɃZ�b�g}
      function	        ReadBuffer( Buffer: String; intLen: Integer ): Boolean;
      {�C���X�^���X���瑗�M�f�[�^�𐶐�}
      function          WriteBuffer( var Buffer: String ): Integer;
  end;

  {DICOM�摜���݊m�F�|�v��}
  TO_IFCHKRequest = class( TObject )
    private
      StreamData:	String;         //�d���f�[�^

      {��M�f�[�^���f�R�[�h}
      function	        Decode: Boolean;

    public
      InstitutionID:	String;         //�{��ID
      PatientID:	String;         //����ID
      StudyDate:	TDateTime;      //������
      Modality:	        String;         //���_���e�B

      {�R���X�g���N�^}
      constructor	Create; overload;
      constructor	Create( Buffer: String; intLen: Integer ); overload;

      {������}
      procedure         Clear;
      {��M�f�[�^���C���X�^���X�ɃZ�b�g}
      function	        ReadBuffer( Buffer: String; intLen: Integer ): Boolean;
  end;

  {DICOM�摜���݊m�F�|����}
  TO_IFCHKResponse = class( TObject )
    private
      StreamData:	String;         //�d���f�[�^

      {�C���X�^���X���G���R�[�h}
      procedure         Encode;

    public
      Result:		Integer;        //�m�F���ʏ�
      DataSetNum:	Integer;        //�f�[�^�Z�b�g��
      DataSet:	        array of RES_DATASET;//�f�[�^�Z�b�g

      {�R���X�g���N�^}
      constructor	Create;
      {�f�X�g���N�^}
      destructor        Destroy; reintroduce;

      {������}
      procedure         Clear;
      {�C���X�^���X���瑗�M�f�[�^�𐶐�}
      function          WriteBuffer( var Buffer: String ): Integer;
  end;

  {JPEG/DICOM�t�@�C���ۑ��|�v��}
  TO_IFSTGRequest = class( TObject )
    private
      StreamData:	String;         //�d���f�[�^

      {��M�f�[�^���f�R�[�h}
      function	        Decode: Boolean;

    public
      InstitutionID:	String;         //�{��ID
      PatientID:	String;         //����ID
      PatientName:	String;         //���Җ�
      Sex:		String;         //����
      BirthDate:	TDateTime;      //���N����
      StudyDate:	TDateTime;      //������
      Modality:	        String;         //���_���e�B
      Region:		String;         //����
      StudyComment:	String;         //�����R�����g
      FileNum:	        Integer;        //�t�@�C����
      FileName:         array of String;//�t�@�C����

      {�R���X�g���N�^}
      constructor	Create; overload;
      constructor	Create( Buffer: String; intLen: Integer ); overload;
      {�f�X�g���N�^}
      destructor        Destroy; reintroduce;

      {������}
      procedure         Clear;
      {��M�f�[�^���C���X�^���X�ɃZ�b�g}
      function	        ReadBuffer( Buffer: String; intLen: Integer ): Boolean;
      {�R���g���[���R�[�h�`�F�b�N}
      function          CheckCtlCode( strCheck: String ): Boolean;
  end;

  {JPEG/DICOM�t�@�C���ۑ��|����}
  TO_IFSTGResponse = class( TObject )
    private
      StreamData:	String;         //�d���f�[�^
      Succeed:          array of DICOM_RESULT;//�����t�@�C�����
      Failed:           array of DICOM_RESULT;//���s�t�@�C�����

      {�C���X�^���X���G���R�[�h}
      procedure         Encode;

    public

      {�R���X�g���N�^}
      constructor	Create;
      {�f�X�g���N�^}
      destructor        Destroy; reintroduce;

      {������}
      procedure         Clear;
      {�����t�@�C�����擾}
      function          SuccessNum: Integer;
      {���s�t�@�C�����擾}
      function          FailNum: Integer;
      {�����t�@�C�����ǉ�}
      procedure         Add( FileName,StudyUID,SeriesUID,SOPUID: String ); overload;
      {���s�t�@�C�����ǉ�}
      procedure         Add( FileName: String; Reason: Integer ); overload;
      {�C���X�^���X���瑗�M�f�[�^�𐶐�}
      function          WriteBuffer( var Buffer: String ): Integer;
  end;

  {DICOM�t�@�C���擾�|�v��}
  TO_IFGETRequest = class( TObject )
    private
      StreamData:	String;         //�d���f�[�^

      {��M�f�[�^���f�R�[�h}
      function	        Decode: Boolean;

    public
      RequestLevel:	Integer;        //�v�����x��
      UID:		String;         //UID

      {�R���X�g���N�^}
      constructor	Create; overload;
      constructor	Create( Buffer: String; intLen: Integer ); overload;

      {������}
      procedure         Clear;
      {��M�f�[�^���C���X�^���X�ɃZ�b�g}
      function	        ReadBuffer( Buffer: String; intLen: Integer ): Boolean;
  end;

  {DICOM�t�@�C���擾�|����}
  TO_IFGETResponse = class( TObject )
    private
      StreamData:	String;         //�d���f�[�^

      {�C���X�^���X���G���R�[�h}
      procedure         Encode;

    public
      Result:           Integer;        //�m�F���ʏ�
      DataSetNum:       Integer;        //�f�[�^�Z�b�g��
      DataSet:          array of RES_DATASET;//�f�[�^�Z�b�g

      {�R���X�g���N�^}
      constructor	Create;
      {�f�X�g���N�^}
      destructor        Destroy; reintroduce;

      {������}
      procedure         Clear;
      {�C���X�^���X���瑗�M�f�[�^�𐶐�}
      function          WriteBuffer( var Buffer: String ): Integer;
  end;


implementation

//------------------------------------------------------------------------------
//�ʐM�w�b�_
//------------------------------------------------------------------------------
//******************************************************************************
//* function name       : TO_IFHeader.Create
//* description         : �R���X�g���N�^
//*   <function>
//*     �e�C���X�^���X������������B
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
//* description         : �R���X�g���N�^
//*   <function>
//*     �e�C���X�^���X������������B
//*   <include file>
//*   <calling sequence>
//*     TO_IFHeader.Create( Buffer: String; intLen: Integer );
//*       Buffer: String        (IN) ��M�f�[�^
//*       intLen: Integer       (IN) ��M�f�[�^��
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
//* description         : ������
//*   <function>
//*     �e�C���X�^���X������������B
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
//* description         : ��M�f�[�^���C���X�^���X�ɃZ�b�g
//*   <function>
//*     �w�蕶������C���X�^���X�ɃZ�b�g���A�f�R�[�h����B
//*   <include file>
//*   <calling sequence>
//*     TO_IFHeader.ReadBuffer( Buffer: String; intLen: Integer ): Boolean;
//*       return: Boolean       (RET) True=����,False=���s
//*       Buffer: String        (IN) ��M�f�[�^
//*       intLen: Integer       (IN) ��M�f�[�^��
//*   <remarks>
//******************************************************************************
function TO_IFHeader.ReadBuffer( Buffer: String; intLen: Integer ): Boolean;
begin
  StreamData := Copy( Buffer,1,intLen );
  Result := Decode;
end;

//******************************************************************************
//* function name       : TO_IFHeader.WriteBuffer
//* description         : �C���X�^���X���瑗�M�f�[�^�𐶐�
//*   <function>
//*     �C���X�^���X����d���f�[�^�𐶐�����B
//*   <include file>
//*   <calling sequence>
//*     TO_IFHeader.WriteBuffer( var Buffer: String ): Integer;
//*       return: Integer       (RET) ���������d����
//*       Buffer: String        (OUT) �d���f�[�^
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
//* description         : �f�R�[�h
//*   <function>
//*     �d���f�[�^����͂��A�e�C���X�^���X�l�ɃZ�b�g����B
//*   <include file>
//*   <calling sequence>
//*     TO_IFHeader.Decode: Boolean;
//*       return: Boolean       (RET) True=����,False=���s
//*   <remarks>
//******************************************************************************
function TO_IFHeader.Decode: Boolean;
var
  tmpYear:      String;         //�쐬�����i�N�j
  tmpMonth:	String;         //�쐬�����i���j
  tmpDay:	String;         //�쐬�����i���j
  tmpHour:	String;         //�쐬�����i���j
  tmpMin:	String;         //�쐬�����i���j
  tmpSec:	String;         //�쐬�����i�b�j
  tmpKind:	String;         //�v�����
  tmpSize:	String;         //�ʕ��f�[�^�T�C�Y

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
//* description         : �G���R�[�h
//*   <function>
//*     �e�C���X�^���X����d���f�[�^�𐶐�����B
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
//DICOM�摜���݊m�F
//------------------------------------------------------------------------------
//******************************************************************************
//* function name       : TO_IFCHKRequest.Create
//* description         : �R���X�g���N�^
//*   <function>
//*     �e�C���X�^���X������������B
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
//* description         : �R���X�g���N�^
//*   <function>
//*     �e�C���X�^���X������������B
//*   <include file>
//*   <calling sequence>
//*     TO_IFCHKRequest.Create( Buffer: String; intLen: Integer );
//*       Buffer: String        (IN) ��M�f�[�^
//*       intLen: Integer       (IN) ��M�f�[�^��
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
//* description         : ������
//*   <function>
//*     �e�C���X�^���X������������B
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
//* description         : ��M�f�[�^���C���X�^���X�ɃZ�b�g
//*   <function>
//*     �w�蕶������C���X�^���X�ɃZ�b�g���A�f�R�[�h����B
//*   <include file>
//*   <calling sequence>
//*     TO_IFCHKRequest.ReadBuffer( Buffer: String; intLen: Integer ): Boolean;
//*       return: Boolean       (RET) True=����,False=���s
//*       Buffer: String        (IN) ��M�f�[�^
//*       intLen: Integer       (IN) ��M�f�[�^��
//*   <remarks>
//******************************************************************************
function TO_IFCHKRequest.ReadBuffer( Buffer: String; intLen: Integer ): Boolean;
begin
  StreamData := Copy( Buffer,1,intLen );
  Result := Decode;
end;

//******************************************************************************
//* function name       : TO_IFCHKRequest.Decode
//* description         : �f�R�[�h
//*   <function>
//*     �d���f�[�^����͂��A�e�C���X�^���X�l�ɃZ�b�g����B
//*   <include file>
//*   <calling sequence>
//*     TO_IFCHKRequest.Decode: Boolean;
//*       return: Boolean       (RET) True=����,False=���s
//*   <remarks>
//******************************************************************************
function TO_IFCHKRequest.Decode: Boolean;
var
  tmpYear:	String;         //�������i�N�j
  tmpMonth:	String;         //�������i���j
  tmpDay:	String;         //�������i���j

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
//* description         : �R���X�g���N�^
//*   <function>
//*     �e�C���X�^���X������������B
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
//* description         : ������
//*   <function>
//*     �e�C���X�^���X������������B
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
//* description         : �f�X�g���N�^
//*   <function>
//*     �e�C���X�^���X���������B
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
//* description         : �C���X�^���X���瑗�M�f�[�^�𐶐�
//*   <function>
//*     �C���X�^���X����d���f�[�^�𐶐�����B
//*   <include file>
//*   <calling sequence>
//*     TO_IFCHKResponse.WriteBuffer( var Buffer: String ): Integer;
//*       return: Integer       (RET) ���������d����
//*       Buffer: String        (OUT) �d���f�[�^
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
//* description         : �G���R�[�h
//*   <function>
//*     �e�C���X�^���X����d���f�[�^�𐶐�����B
//*   <include file>
//*   <calling sequence>
//*     TO_IFCHKResponse.Encode;
//*   <remarks>
//******************************************************************************
procedure TO_IFCHKResponse.Encode;
var
  ii:           Integer;        //���[�v�J�E���^
  jj:           Integer;        //���[�v�J�E���^
  SOPlen:       Integer;        //SOPInstanceUID�L��������
  SOPMaxlen:    Integer;        //SOPInstanceUID���ڍő啶����

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
//JPEG/DICOM�t�@�C���ۑ�
//------------------------------------------------------------------------------
//******************************************************************************
//* function name       : TO_IFSTGRequest.Create
//* description         : �R���X�g���N�^
//*   <function>
//*     �e�C���X�^���X������������B
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
//* description         : �R���X�g���N�^
//*   <function>
//*     �e�C���X�^���X������������B
//*   <include file>
//*   <calling sequence>
//*     TO_IFSTGRequest.Create( Buffer: String; intLen: Integer );
//*       Buffer: String        (IN) ��M�f�[�^
//*       intLen: Integer       (IN) ��M�f�[�^��
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
//* description         : �f�X�g���N�^
//*   <function>
//*     �e�C���X�^���X���������B
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
//* description         : ������
//*   <function>
//*     �e�C���X�^���X������������B
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
//* description         : ��M�f�[�^���C���X�^���X�ɃZ�b�g
//*   <function>
//*     �w�蕶������C���X�^���X�ɃZ�b�g���A�f�R�[�h����B
//*   <include file>
//*   <calling sequence>
//*     TO_IFSTGRequest.ReadBuffer( Buffer: String; intLen: Integer ): Boolean;
//*       return: Boolean       (RET) True=����,False=���s
//*       Buffer: String        (IN) ��M�f�[�^
//*       intLen: Integer       (IN) ��M�f�[�^��
//*   <remarks>
//******************************************************************************
function TO_IFSTGRequest.ReadBuffer( Buffer: String; intLen: Integer ): Boolean;
begin
  StreamData := Copy( Buffer,1,intLen );
  Result := Decode;
end;

//******************************************************************************
//* function name       : TO_IFSTGRequest.Decode
//* description         : �f�R�[�h
//*   <function>
//*     �d���f�[�^����͂��A�e�C���X�^���X�l�ɃZ�b�g����B
//*   <include file>
//*   <calling sequence>
//*     TO_IFSTGRequest.Decode: Boolean;
//*       return: Boolean       (RET) True=����,False=���s
//*   <remarks>
//******************************************************************************
function TO_IFSTGRequest.Decode: Boolean;
var
  tmpYear:	String;         //�N
  tmpMonth:	String;         //��
  tmpDay:	String;         //��
  ii:		Integer;        //���[�v�J�E���^
  pos:		Integer;        //�����ʒu

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
//* description         : �R���g���[���`�F�b�N
//*   <function>
//*     �w�蕶����ɃR���g���[���R�[�h�i'\'�����ESC�ȊO�̐��䕶���j�����邩
//*     �`�F�b�N����B
//*   <include file>
//*   <calling sequence>
//*     TO_IFSTGRequest.CheckCtlCode( strCheck: String ): Boolean;
//*       return: Boolean       (RET) True=����,False=�Ȃ�
//*       strCheck: String      (IN) �`�F�b�N���镶����
//*   <remarks>
//******************************************************************************
function TO_IFSTGRequest.CheckCtlCode( strCheck: String ): Boolean;
var
  len:          Integer;        //���[�v�J�E���^
  ii:           Integer;        //���[�v�J�E���^
  chrCheck:     PChar;          //�`�F�b�N����

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
//* description         : �R���X�g���N�^
//*   <function>
//*     �e�C���X�^���X������������B
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
//* description         : �f�X�g���N�^
//*   <function>
//*     �e�C���X�^���X���������B
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
//* description         : ������
//*   <function>
//*     �e�C���X�^���X������������B
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
//* description         : �����t�@�C�����擾
//*   <function>
//*     �o�^����Ă��鐬���t�@�C���̐���Ԃ��B
//*   <include file>
//*   <calling sequence>
//*     TO_IFSTGResponse.SuccessNum: Integer;
//*       return: Integer       (RET) �����t�@�C����
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
//* description         : ���s�t�@�C�����擾
//*   <function>
//*     �o�^����Ă��鎸�s�t�@�C���̐���Ԃ��B
//*   <include file>
//*   <calling sequence>
//*     TO_IFSTGResponse.FailNum: Integer;
//*       return: Integer       (RET) ���s�t�@�C����
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
//* description         : �����t�@�C�����ǉ�
//*   <function>
//*     �����t�@�C������ǉ�����B
//*   <include file>
//*   <calling sequence>
//*     TO_IFSTGResponse.Add( FileName,StudyUID,SeriesUID,SOPUID: String );
//*       FileName: String      (IN) �t�@�C����
//*       StudyUID: String      (IN) StudyInstanceUID
//*       SeriesUID: String     (IN) SeriesInstanceUID
//*       SOPUID: String        (IN) SOPInstanceUID
//*   <remarks>
//******************************************************************************
procedure TO_IFSTGResponse.Add( FileName,StudyUID,SeriesUID,SOPUID: String );
var
  num:          Integer;        //�t�@�C����

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
//* description         : ���s�t�@�C�����ǉ�
//*   <function>
//*     ���s�t�@�C������ǉ�����B
//*   <include file>
//*   <calling sequence>
//*     TO_IFSTGResponse.Add( FileName: String; Reason: Integer );
//*       FileName: String      (IN) �t�@�C����
//*       Reason: Integer       (IN) ���s���R
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
//* description         : �C���X�^���X���瑗�M�f�[�^�𐶐�
//*   <function>
//*     �C���X�^���X����d���f�[�^�𐶐�����B
//*   <include file>
//*   <calling sequence>
//*     TO_IFSTGResponse.WriteBuffer( var Buffer: String ): Integer;
//*       return: Integer       (RET) ���������d����
//*       Buffer: String        (OUT) �d���f�[�^
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
//* description         : �G���R�[�h
//*   <function>
//*     �e�C���X�^���X����d���f�[�^�𐶐�����B
//*   <include file>
//*   <calling sequence>
//*     TO_IFSTGResponse.Encode;
//*   <remarks>
//******************************************************************************
procedure TO_IFSTGResponse.Encode;
var
  num:          Integer;        //�t�@�C����
  ii:           Integer;        //���[�v�J�E���^
  strSucceed:   String;         //�����t�@�C���f�[�^
  strFailed:    String;         //���s�t�@�C���f�[�^
  strReason:    String;         //���s���R�f�[�^

begin
  //�����t�@�C��
  num := SuccessNum;
  strSucceed := Format( '%.3d',[num] );
  for ii := 0 to num-1 do
  begin
    strSucceed := strSucceed + Format( '%-23s%-64s%-64s%-64s',[Succeed[ii].FileName,Succeed[ii].StudyUID,Succeed[ii].SeriesUID,Succeed[ii].SOPUID] );
  end;

  //���s�t�@�C��
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
//DICOM�t�@�C���擾
//------------------------------------------------------------------------------
//******************************************************************************
//* function name       : TO_IFGETRequest.Create
//* description         : �R���X�g���N�^
//*   <function>
//*     �e�C���X�^���X������������B
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
//* description         : �R���X�g���N�^
//*   <function>
//*     �e�C���X�^���X������������B
//*   <include file>
//*   <calling sequence>
//*     TO_IFGETRequest.Create( Buffer: String; intLen: Integer );
//*       Buffer: String        (IN) ��M�f�[�^
//*       intLen: Integer       (IN) ��M�f�[�^��
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
//* description         : ������
//*   <function>
//*     �e�C���X�^���X������������B
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
//* description         : ��M�f�[�^���C���X�^���X�ɃZ�b�g
//*   <function>
//*     �w�蕶������C���X�^���X�ɃZ�b�g���A�f�R�[�h����B
//*   <include file>
//*   <calling sequence>
//*     TO_IFGETRequest.ReadBuffer( Buffer: String; intLen: Integer ): Boolean;
//*       return: Boolean       (RET) True=����,False=���s
//*       Buffer: String        (IN) ��M�f�[�^
//*       intLen: Integer       (IN) ��M�f�[�^��
//*   <remarks>
//******************************************************************************
function TO_IFGETRequest.ReadBuffer( Buffer: String; intLen: Integer ): Boolean;
begin
  StreamData := Copy( Buffer,1,intLen );
  Result := Decode;
end;

//******************************************************************************
//* function name       : TO_IFGETRequest.Decode
//* description         : �f�R�[�h
//*   <function>
//*     �d���f�[�^����͂��A�e�C���X�^���X�l�ɃZ�b�g����B
//*   <include file>
//*   <calling sequence>
//*     TO_IFGETRequest.Decode: Boolean;
//*       return: Boolean       (RET) True=����,False=���s
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
//* description         : �R���X�g���N�^
//*   <function>
//*     �e�C���X�^���X������������B
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
//* description         : ������
//*   <function>
//*     �e�C���X�^���X������������B
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
//* description         : �f�X�g���N�^
//*   <function>
//*     �e�C���X�^���X���������B
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
//* description         : �C���X�^���X���瑗�M�f�[�^�𐶐�
//*   <function>
//*     �C���X�^���X����d���f�[�^�𐶐�����B
//*   <include file>
//*   <calling sequence>
//*     TO_IFGETResponse.WriteBuffer( var Buffer: String ): Integer;
//*       return: Integer       (RET) ���������d����
//*       Buffer: String        (OUT) �d���f�[�^
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
//* description         : �G���R�[�h
//*   <function>
//*     �e�C���X�^���X����d���f�[�^�𐶐�����B
//*   <include file>
//*   <calling sequence>
//*     TO_IFGETResponse.Encode;
//*   <remarks>
//******************************************************************************
procedure TO_IFGETResponse.Encode;
var
  ii:           Integer;        //���[�v�J�E���^
  jj:           Integer;        //���[�v�J�E���^
  SOPlen:       Integer;        //SOPInstanceUID�L��������
  SOPMaxlen:    Integer;        //SOPInstanceUID���ڍő啶����

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

