unit DB_ACC;
{
���@�\����
  DB�̐ڑ��Ǘ�
  ���g�p����
    ��Ԏn�߂ɁAfunc_DBMST_Open�֐����Ă�ł��������B
    ��func_DBMST_Open ���@�\:�K�v��Ͻ��̵����(��ذ)
    �������邱�Ƃɂ���āA�F���A�[�����̎擾�A�C���A�ǉ��A
    �^�C�}�[�@�\�A���ԁA�\���ő�s�A�v�����^�[�̏��擾�֐����g�p�\�ɂȂ�܂��B
  ���ǉ�����
    �����C���̸�ٰ�ߔԍ��́A'00'���w�肵�Ă��������B
    ����ٰ�ߔԍ��������Ƃ��Ă���ꍇ�́A��ذ����ݎ��Ɏw�肵����ٰ�ߔԍ����g�p���Ă��������B 
������
�V�K�쐬�F2000.04.10�F�S�� iwai
�C��    �F2000.04.10�F�S�� iwai
Error Msg�֐���ǉ�
�C���F2000.11.02�Fiwai
�Z�b�V�����̃O���[�v�����q�h�r�Ή�
�ǉ��F2000.11.06:���c
function func_DBMST_Open(arg_GroupNo:String): boolean ;
procedure proc_DBMST_Close(arg_GroupNo:String);
function func_Color(arg_GroupNo:String;
                    arg_Section_Key:string;
                    arg_Data_Key:string
                    ): string ;
��ǉ�

�ǉ��F2000.11.08:���c
procedure proc_TBL_Open;
procedure proc_TBL_Close;
function func_Section_Key(arg_GroupNo:String): TStrings ;
function func_Data_Key(arg_GroupNo:String): TStrings ;
��ǉ�

�C���F2000.11.10:���c
function func_DBMST_Open(arg_GroupNo:String): boolean ;
procedure proc_DBMST_Close(arg_GroupNo:String);
function func_Color(arg_GroupNo:String;
                    arg_Section_Key:string;
                    arg_Data_Key:string
                    ): string ;
procedure proc_TBL_Open;
procedure proc_TBL_Close;
���C��

�폜�F2000.11.10:���c
function func_Section_Key(arg_GroupNo:String): TStrings ;
function func_Data_Key(arg_GroupNo:String): TStrings ;
���폜

�ǉ��F2000.11.20:���c
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
��ǉ�

�C���F2000.11.20:���c
function func_Color(arg_GroupNo:String;
                    arg_Data_Key:string
                    ): string ;
���C��

�ǉ��F2000.11.21:���c
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
��ǉ�

�C���F2000.11.21:���c
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

���C��

�ǉ��F2000.12.01:���c
procedure proc_Irai_PrintInfo(
                     arg_GroupNo:String;
                     arg_PrintNo:String;
                     var Print_name,
                         print_title,
                         print_port,
                         print_driver:String;
                     var copies:Integer
                      );
��ǉ�

�ǉ��F2000.12.08:���c
  g_MODE_KYOUTYOU = 'KYOUTYOU';    //�����J���[Ӱ��(�ް���)
��ǉ�

�C���F2000.12.08:���c
  g_SYSTEM = 'SYSTEM'  �� g_SYSTEM = '*'; //���і�
���C��

�C���F2000.12.19�F���c DB_ACC����"const"���ړ�

�C���F2001.04.07:���R
function func_ID_Format(arg_GroupNo:String;
                        arg_Program_ID:string
                       ): String ;
function func_ZeroDisplay(arg_GroupNo:String;
                          arg_Program_ID:string
                         ): Boolean ;
��ǉ�

�C���F2001.08.29:iwai
�Z�b�V�����̓��ꉻ�ɔ����ύX

�C���F2001.08.29:���c
�@�@�Z�b�V�����̓��ꉻ�ɔ����ύX

�C���F2001.09.04:iwai
�@�@���b�Z�[�W�֐��ɏڍׂ����邽�߂�
�@�@�֐����I�[�o���[�h����B
�C���F2001.09.14:iwai
    MsgID�擾�������V�K�쐬
}

interface

uses
//�V�X�e���|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
  Windows, Messages,
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,StdCtrls,
  DBTables,Db, Variants,
//�v���_�N�g�J�����ʁ|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
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
    { Private �錾 }
  public
    { Public �錾 }
    ga_DBList : array of TRC_Db;
    gs_ErrCodMs:TStrings;
    gs_ErrMsgMs:TStrings;
    gs_MsgID:TStrings; //2001.09.14
    gs_ErrCodLogMod:TStrings;
    gs_ErrIcon:TStrings;
    ga_QRY_count:integer; //��ذؽĐ�
    ga_TBL:TTable; //WINMASTER
    ga_TDS:TDataSource; //�ް����
    ga_Qry_name:String; //Ͻ�̧�ٖ�
    ga_Order_name:String; //���ް�޲��
    g_Qry_Flg:string;

    //2002.12.17
    ga_WinList : array of TRC_WIN_DATA;
    //2001.08.29
    g_WinMaster_DBS:TDatabase; //WINMASTER�p�f�[�^�x�[�X
    //��ذؽ�(�eϽ�����)
    GQ_WinMaster_LIST:array of TQuery;

    function  func_DBSysDate:TDateTime;
    //���@�\:DB�̖��̂�order by��̃Z�b�g
    procedure proc_DBMst_order;
    //���@�\:�K�v��Ͻ���ð��ٵ����
    procedure proc_TBL_First;
  end;
//DB�擾�֐�
function func_GetDB(arg_FromName : string) : TDatabase ;
//DB�J���֐�
function funcFreeDB(arg_FromName : string) : boolean ;
//���@�\:�����x��IF��MSGBOX�iOK���݂̂݁j
function func_DBMsgType1(
                     arg_Cap: string;   //�^�C�g��
                     arg_ProID: string; //�v���O����ID
                     arg_ErrorNo: string; //�G���[NO�D
                     arg_Addstring:string //�t�ѕ�����
                                         ):integer;overload; //���A�l�FIDOK
function func_DBMsgType1(
                     arg_Cap: string;      //�^�C�g��
                     arg_ProID: string;    //�v���O����ID
                     arg_ErrorNo: string;  //�G���[NO�D
                     arg_Addstring:string; //�t�ѕ�����
                     arg_TForm:TForm       //�I�[�iForm
                                         ):integer;overload; //���A�l�FIDOK
function func_DBMsgType1(
                     arg_Cap: string;      //�^�C�g��
                     arg_ProID: string;    //�v���O����ID
                     arg_ErrorNo: string;  //�G���[NO�D
                     arg_Addstring:string; //�t�ѕ�����
                     arg_Detailsstring:string; //�ڍו�����
                     arg_TForm:TForm       //�I�[�iForm
                                         ):integer;overload; //���A�l�FIDOK

function func_DBMsgType2(
                     arg_Cap: string;   //�^�C�g��
                     arg_ProID: string; //�v���O����ID
                     arg_ErrorNo: string; //�G���[NO�D
                     arg_Addstring:string //�t�ѕ�����
                                         ):integer;overload; //���A�l�FIDOK IDCANCEL
function func_DBMsgType2(
                     arg_Cap: string;      //�^�C�g��
                     arg_ProID: string;    //�v���O����ID
                     arg_ErrorNo: string;  //�G���[NO�D
                     arg_Addstring:string; //�t�ѕ�����
                     arg_TForm:TForm       //�I�[�iForm
                                         ):integer;overload; //���A�l�FIDOK

//���@�\:�����x��IF��MSGBOX�i���݂Ȃ��\���j
procedure proc_DBMsgType3S(
                     arg_TForm:TForm; //���͕s�ɂ���e̫�� nil�F�e�Ȃ�
                     arg_Cap: string; //�^�C�g��
                     arg_ProID: string; //�v���O����ID
                     arg_ErrorNo: string; //�G���[NO�D
                     arg_Addstring:string //�t�ѕ�����
                                         );
//���@�\:�����x��IF��MSGBOX�i���݂Ȃ������j
procedure proc_DBMsgType3E(
                     arg_TForm:TForm //���͕s����������e̫�� nil�F�e�Ȃ�
                      );

//���@�\:�K�v��Ͻ��̵����(��ذ)
function func_DBMST_Open(
                     arg_GroupNo:String //Ͻ��̵���݂������ٰ��No
                      ): boolean ;
{��"func_DBMST_Open"�ڍא���
    �E���� arg_GroupNo�F��ٰ��No�bString(2)
    �E�߂�l boolean(��O����������̂Ō��Ȃ��Ă��g�p�\)
    �E�ڍא���
      ��ٰ��No���w�肷�邱�Ƃɂ����
      �[��Ͻ��̸�ذ����݂��ł���B
    �����C���̸�ٰ�ߔԍ��́A'00'���w�肵�Ă��������B
      ���C���̏ꍇ�́ADB_ACC�̸ش�Ď��ɸ�ذ���쐬����悤�ɕύX�����̂�
      �֐����Ă΂Ȃ��Ăิذ�͵���݂���Ă��܂��B
      (�������֐����Ă�ł�����Ă����܂��܂���B)}
//���@�\:Ͻ��̸۰��(��ذ)
procedure proc_DBMST_Close(
                     arg_GroupNo:String //Ͻ��̸۰�ނ������ٰ��No
                      );
{��"proc_DBMST_Close"�ڍא���
    �E���� arg_GroupNo�F��ٰ��No�bString(2)
    �E�߂�l �Ȃ�
    �E�ڍא���
      ��ٰ��No���w�肷�邱�Ƃɂ����
      �[��Ͻ��̸�ذ�۰�ނ��ł���B
    �����C���̸�ٰ�ߔԍ��́A'00'���w�肵�Ă��������B
    ����ذ����ݎ��̸�ٰ�ߔԍ��ŌĂяo���Ă��������B}
//���@�\:�K�v�ȐF���
function func_Color(
                     arg_GroupNo:String; //��ٰ��No
                     arg_Data_Key:string   //�ް���
                      ): string ;
{��"func_Color"�ڍא���
    �E���� arg_GroupNo �F��ٰ��No�bString(2)
           arg_Data_Key�F�ް���  �bString
           (arg_Section_Key�͍폜���܂����B)
    �E�߂�l String
    �E�ڍא���
      ��ٰ��No�A�ް������w�肷�邱�Ƃɂ����
      �F�����擾�ł���B
    �����C���̸�ٰ�ߔԍ��́A'00'���w�肵�Ă��������B
    ����ذ����ݎ��̸�ٰ�ߔԍ��ŌĂяo���Ă��������B}
//���@�\:�K�v��Ͻ��̵����(ð���)
procedure proc_TBL_Open;
{��"proc_TBL_Open"�ڍא���
    �E���� �Ȃ�
    �E�߂�l �Ȃ�
    �E�ڍא���
      �[��Ͻ���ð��ق�����݂��ł���B
    ��ð��ق̍ŐV�����擾����ꍇ�́A
      "proc_TBL_Refresh"(��گ���֐�)��
      �g�p���Ă��������B}
//���@�\:Ͻ��̸۰��(ð���)
procedure proc_TBL_Close;
{��"proc_TBL_Close"�ڍא���
    �E���� �Ȃ�
    �E�߂�l �Ȃ�
    �E�ڍא���
      �[��Ͻ���ð��ق��۰�ނ��ł���B
    ��ð��ق̍ŐV�����擾����ꍇ�́A
      "proc_TBL_Refresh"(��گ���֐�)��
      �g�p���Ă��������B}
//******************************************************************************
//* function name	: func_Query_TO_CBox
//* description		: Master��ǂݍ��݁AComboBox�ɓ��e���i�[����B
//* Result		: Integer	(RET)	0	: ����I��
//*						1	: �ُ�I��
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
                          arg_FieldByName	: String;	//���ږ�
                          arg_CBox		: TComboBox;	//�R���{�{�b�N�X
                          arg_SpaceSet		: integer;	//'��'  �L��(0:�Ȃ��A1:����)
                          arg_AllSet		: integer;	//'���ׂ�'�L��(0:�Ȃ��A1:����)
                          arg_Text		: String 	//�����\��Text
                        ):Integer;
function func_Query_TO_CBox2( arg_Query 		: TQuery;	//Query
                          arg_FieldByName	: String;	//���ږ�
                          arg_CBox		: TComboBox;	//�R���{�{�b�N�X
                          arg_SpaceSet		: integer;	//'��'  �L��(0:�Ȃ��A1:����)
                          arg_FirstSet		: String;	// Query�̑O�ɃZ�b�g����l
                          arg_Text		: String 	//�����\��Text
                        ):Integer;
//******************************************************************************
//* function name	: func_Text_TO_CBox
//* description		: Text�̓��e��ComboBox��Text�ɕ\������B
//*
//******************************************************************************
function func_Text_TO_CBox( arg_CBox		: TComboBox;	//�R���{�{�b�N�X
                            arg_SpaceSet	: integer;	//'��'  �L��(0:�Ȃ��A1:����)
                            arg_AllSet		: integer;	//'���ׂ�'�L��(0:�Ȃ��A1:����)
                            arg_Text		: String 	//�����\��Text
                          ):Integer;
function func_Text_TO_CBox2( arg_CBox		: TComboBox;	//�R���{�{�b�N�X
                            arg_SpaceSet	: integer;	//'��'  �L��(0:�Ȃ��A1:����)
                            arg_FirstSet    	: String;	// Query�̑O�ɃZ�b�g����l
                            arg_Text		: String 	//�����\��Text
                          ):Integer;
//���@�\:�[�����̎擾
function func_Get_WinMaster(
                     arg_GroupNo:String; //��ٰ��No
                     arg_Section_Key:string; //����ݷ�
                     arg_Data_Key:string;  //�ް���
                     arg_Get:string   //�擾���ږ�
                      ): string ;
{��"func_Get_WinMaster"�ڍא���
    �E���� arg_GroupNo    �F��ٰ��No  �bString(2)
           arg_Section_Key�F����ݷ�   �bString
           arg_Data_Key   �F�ް���    �bString
           arg_Get        �F�擾���ږ��bString (�擾������ð��ٍ��ږ�)
    �E�߂�l String
    �E�ڍא���
      ��ٰ��No�A����ݷ��A�ް����A�擾���ږ����w�肷�邱�Ƃɂ����
      �[�������擾�ł���B
    �����C���̸�ٰ�ߔԍ��́A'00'���w�肵�Ă��������B
    ����ذ����ݎ��̸�ٰ�ߔԍ��ŌĂяo���Ă��������B
    ��"func_Get_WinMaster_DATA"�A"func_Get_WinMaster_BIKO"���A
      �g�p�����������������Ȃ��Ďg���₷���Ǝv���܂��B}
//���@�\:�^�C�}�[�@�\�擾
function func_Timer(
                     arg_GroupNo:String; //��ٰ��No
                     arg_Program_ID:string //���No
                      ): Boolean ;
{��"func_Timer"�ڍא���
    �E���� arg_GroupNo   �F��ٰ��No�bString(2)
           arg_Program_ID�F���No  �bString
    �E�߂�l Boolean(True = �^�C�}�[�@�\���� False = �^�C�}�[�@�\�Ȃ�)
    �E�ڍא���
      ��ٰ��No�A���No���w�肷�邱�Ƃɂ����
      �w����No�Ń^�C�}�[�@�\���K�v���ǂ����擾�ł���B
    �����C���̸�ٰ�ߔԍ��́A'00'���w�肵�Ă��������B
    ����ذ����ݎ��̸�ٰ�ߔԍ��ŌĂяo���Ă��������B}
//���@�\:�^�C�}�[���Ԏ擾
function func_TimerInterval(
                     arg_GroupNo:String; //��ٰ��No
                     arg_Program_ID:string //���No
                      ): Integer ;
{��"func_TimerInterval"�ڍא���
    �E���� arg_GroupNo   �F��ٰ��No�bString(2)
           arg_Program_ID�F���No  �bString
    �E�߂�l Integer
    �E�ڍא���
      ��ٰ��No�A���No���w�肷�邱�Ƃɂ����
      �w����No�ł̃^�C�}�[����(�������)���擾�ł���B
    �����C���̸�ٰ�ߔԍ��́A'00'���w�肵�Ă��������B
    ����ذ����ݎ��̸�ٰ�ߔԍ��ŌĂяo���Ă��������B}
//���@�\:�\���ő�s�擾
function func_RowLimit(
                     arg_GroupNo:String; //��ٰ��No
                     arg_Program_ID:string //���No
                      ): Integer ;
{��"func_RowLimit"�ڍא���
    �E���� arg_GroupNo   �F��ٰ��No�bString(2)
           arg_Program_ID�F���No  �bString
    �E�߂�l Integer
    �E�ڍא���
      ��ٰ��No�A���No���w�肷�邱�Ƃɂ����
      �w����No�ł̌����̕\���ő�s���擾�ł���B
    �����C���̸�ٰ�ߔԍ��́A'00'���w�肵�Ă��������B
    ����ذ����ݎ��̸�ٰ�ߔԍ��ŌĂяo���Ă��������B}
//���@�\:����ID�t�H�[�}�b�g�`���擾
function func_ID_Format(
                     arg_GroupNo:String; //��ٰ��No
                     arg_Program_ID:string //���No
                      ): String ;
{��"func_ID_Format"�ڍא���
    �E���� arg_GroupNo   �F��ٰ��No�bString(2)
           arg_Program_ID�F���No  �bString
    �E�߂�l String
    �E�ڍא���
      ��ٰ��No�A���No���w�肷�邱�Ƃɂ����
      ����ID�̃t�H�[�}�b�g�`�����擾�ł���B(���No�͖��g�p)
    �����C���̸�ٰ�ߔԍ��́A'00'���w�肵�Ă��������B
    ����ذ����ݎ��̸�ٰ�ߔԍ��ŌĂяo���Ă��������B}
//���@�\:�O�����b�Z�[�W�\���擾
function func_ZeroDisplay(
                     arg_GroupNo:String; //��ٰ��No
                     arg_Program_ID:string //���No
                      ): Boolean ;
{��"func_ZeroDisplay"�ڍא���
    �E���� arg_GroupNo   �F��ٰ��No�bString(2)
           arg_Program_ID�F���No  �bString
    �E�߂�l Boolean
    �E�ڍא���
      ��ٰ��No�A���No���w�肷�邱�Ƃɂ����
      �w����No�ł̌����̂O�����b�Z�[�W�\�����擾�ł���B
    �����C���̸�ٰ�ߔԍ��́A'00'���w�肵�Ă��������B
    ����ذ����ݎ��̸�ٰ�ߔԍ��ŌĂяo���Ă��������B}
//���@�\:�v�����^�[�̏��擾(�[������)
procedure proc_PrintInfo(
                     arg_GroupNo:String; //��ٰ��No
                     arg_PrintNo:String; //�����No
                     var Print_name,     //��������
                         print_title,    //���[����
                         print_port,     //�߰�
                         print_driver:String; //��ײ��
                     var copies:Integer  //�������
                      );
{��"proc_PrintInfo"�ڍא���
    �E���� arg_GroupNo�F��ٰ��No�bString(2)
           arg_PrintNo�F�����No �bString
    �E�ڍא���
      ��ٰ��No�A�����No���w�肷�邱�Ƃɂ����
      �w�������No�����������A���[���فA�߰āA��ײ�ށA����������擾�ł���B
      (var�ȉ��̈����̏��ɁA�ϐ����Z�b�g���Ă����邱�Ƃɂ����
       ���������A���[���فA�߰āA��ײ�ށA����������擾�ł���B)
      (�[������)
    ����ذ����ݎ��̸�ٰ�ߔԍ��ŌĂяo���Ă��������B}
//���@�\:�[�����̏C���A�ǉ�
procedure proc_Write_WinMaster(
                     arg_Section_Key:String; //����ݷ�
                     arg_Data_Key:String;    //�ް���
                     arg_Change_Name:String; //�ύX���ږ�
                     arg_Change:String;      //�ύX���e
                     arg_Win_flg:Integer     //�[���� 0 = g_SYSTEM , 1 = "���[����"
                      ) ;
{��"proc_Write_WinMaster"�ڍא���
    �E���� arg_Section_Key�F����ݷ�   �bString
           arg_Data_Key   �F�ް���    �bString
           arg_Change_Name�F�ύX���ږ��bString (�ύX������ð��ٍ��ږ�)
           arg_Change     �F�ύX���e  �bString
           arg_Win_flg    �F�[���� 0 = g_SYSTEM , 1 = "���[����"�bInteger
    �E�߂�l �Ȃ�
    �E�ڍא���
      �[�����A����ݷ��A�ް����ŕύX����ں��ގw�肷��B
      �ύX���ږ��ŕύX���鍀�ڂ��w�肷��B
      �ύX���e�͕ύX���镶������Z�b�g����B
      arg_Win_flg�Œ[���� 0 = "SYSTEM" , 1 = "���[����"�����肷��B
    ���[�����̏C���A�ǉ������[���̍��ڂ�ύX����ꍇ�́A
      "proc_Write_WinMaster_DATA"�A"proc_Write_WinMaster_BIKO"���A
      �g�p�����������������Ȃ��Ďg���₷���Ǝv���܂��B}
//���@�\:�[�����̎擾(�ް�����)
function func_Get_WinMaster_DATA(
                     arg_GroupNo:String;     //��ٰ��No
                     arg_Section_Key:string; //����ݷ�
                     arg_Data_Key:string     //�ް���
                      ): string ;
{��"func_Get_WinMaster_DATA"�ڍא���
    �E���� arg_GroupNo    �F��ٰ��No  �bString(2)
           arg_Section_Key�F����ݷ�   �bString
           arg_Data_Key   �F�ް���    �bString
    �E�߂�l String
    �E�ڍא���
      ��ٰ��No�A����ݷ��A�ް������w�肷�邱�Ƃɂ����
      �[�����(�ް�����)���擾�ł���B
    �����C���̸�ٰ�ߔԍ��́A'00'���w�肵�Ă��������B
    ����ذ����ݎ��̸�ٰ�ߔԍ��ŌĂяo���Ă��������B}
//���@�\:�[�����̎擾(���l����)
function func_Get_WinMaster_BIKO(
                     arg_GroupNo:String;     //��ٰ��No
                     arg_Section_Key:string; //����ݷ�
                     arg_Data_Key:string     //�ް���
                      ): string ;
{��"func_Get_WinMaster_BIKO"�ڍא���
    �E���� arg_GroupNo    �F��ٰ��No  �bString(2)
           arg_Section_Key�F����ݷ�   �bString
           arg_Data_Key   �F�ް���    �bString
    �E�߂�l String
    �E�ڍא���
      ��ٰ��No�A����ݷ��A�ް������w�肷�邱�Ƃɂ����
      �[�����(���l����)���擾�ł���B
    �����C���̸�ٰ�ߔԍ��́A'00'���w�肵�Ă��������B
    ����ذ����ݎ��̸�ٰ�ߔԍ��ŌĂяo���Ă��������B}
//���@�\:�[�����̏C���A�ǉ�(�ް����ځA���[���̂�)
procedure proc_Write_WinMaster_DATA(
                     arg_Section_Key:String; //����ݷ�
                     arg_Data_Key:String;    //�ް���
                     arg_Change:String       //�ύX���e
                      );
{��"proc_Write_WinMaster_DATA"�ڍא���
    �E���� arg_Section_Key�F����ݷ�   �bString
           arg_Data_Key   �F�ް���    �bString
           arg_Change     �F�ύX���e  �bString
    �E�߂�l �Ȃ�
    �E�ڍא���
      ����ݷ��A�ް����ŕύX����ں��ގw�肷��B
      �ύX���e�͕ύX���镶������Z�b�g����B
      �ύX�́A���[�����ް����ڂ����ł��B}
//���@�\:�[�����̏C���A�ǉ�(���l���ځA���[���̂�)
procedure proc_Write_WinMaster_BIKO(
                     arg_Section_Key:String; //����ݷ�
                     arg_Data_Key:String;    //�ް���
                     arg_Change:String       //�ύX���e
                      );
{��"proc_Write_WinMaster_BIKO"�ڍא���
    �E���� arg_Section_Key�F����ݷ�   �bString
           arg_Data_Key   �F�ް���    �bString
           arg_Change     �F�ύX���e  �bString
    �E�߂�l �Ȃ�
    �E�ڍא���
      ����ݷ��A�ް����ŕύX����ں��ގw�肷��B
      �ύX���e�͕ύX���镶������Z�b�g����B
      �ύX�́A���[���̔��l���ڂ����ł��B}
//���@�\:Ͻ�ð��ق���گ��
procedure proc_TBL_Refresh;
{��"proc_TBL_Refresh"�ڍא���
    �E���� �Ȃ�
    �E�߂�l �Ȃ�
    �E�ڍא���
      ð��ق�۰�ށA����݂��čŐV������ذ��ɓW�J}
//���@�\:�v�����^�[�̏��擾(�˗��敪����)
procedure proc_Irai_PrintInfo(
                     arg_GroupNo:String; //��ٰ��No
                     arg_PrintNo:String; //�����No
                     var Print_name,     //��������
                         print_title,    //���[����
                         print_port,     //�߰�
                         print_driver:String; //��ײ��
                     var copies:Integer  //�������
                      );
{��"proc_Irai_PrintInfo"�ڍא���
    �E���� arg_GroupNo�F��ٰ��No�bString(2)
           arg_PrintNo�F�����No �bString
    �E�ڍא���
      ��ٰ��No�A�����No���w�肷�邱�Ƃɂ����
      �w�������No�����������A���[���فA�߰āA��ײ�ށA����������擾�ł���B
      (var�ȉ��̈����̏��ɁA�ϐ����Z�b�g���Ă����邱�Ƃɂ����
       ���������A���[���فA�߰āA��ײ�ށA����������擾�ł���B)
      (�˗��敪����)
    ����ذ����ݎ��̸�ٰ�ߔԍ��ŌĂяo���Ă��������B}

//���[���}�X�^�̃f�[�^���ڊg���ɑΉ� 2003.01.30
function func_Get_WinData1to20(arg_Query: TQuery):String;

//���w��e�[�u���Ɏw��̃t�B�[���h�����݂��邩���`�F�b�N 2003.04.24
function func_Exsist_OraFeildName(arg_Query: TQuery;
                                  arg_TableName,
                                  arg_FeildName: String):Boolean;

//���\�񎞍�������̕\�L�ɕύX 2004.03.29
function func_ChangeKensaStartTime(
                                   arg_GroupNo:String;   //��ٰ��No
                                   arg_StartTime:String  //�\�񎞍�(9999)4��
                                   ):String;


var
  DM_DbAcc: TDM_DbAcc;


{const
  g_ALL_TEXT = '���ׂ�';
  g_SCREENCOLOR = 'SCREENCOLOR';   //����ݷ�
  g_MODE_YOYAKU = 'MODE1';         //�\��n��ʃJ���[Ӱ��(�ް���)
  g_MODE_UKETUKE = 'MODE2';        //��t�n��ʃJ���[Ӱ��(�ް���)
  g_MODE_JISEKI = 'MODE3';         //���ьn��ʃJ���[Ӱ��(�ް���)
  g_MODE_SANSYOU = 'MODE8';        //�Q�ƌn��ʃJ���[Ӱ��(�ް���)
  g_MODE_MENTE = 'MODE9';          //�}�X�^�����e�n��ʃJ���[Ӱ��(�ް���)
  g_MODE_INPUT = 'INPUT';          //�K�{���̓J���[Ӱ��(�ް���)
  g_MODE_KYOUTYOU = 'KYOUTYOU';    //�����J���[Ӱ��(�ް���)
  g_GET_DATA = 'DATA';             //�擾���ږ�"�ް�"
  g_GET_BIKO = 'BIKO';             //�擾���ږ�"���l"
  g_TIMEKIND = 'TIMEKIND';         //�^�C�}�[�@�\�擾
  g_TIME = 'TIME';                 //�^�C�}�[���Ԏ擾
  g_ROWLIMIT = 'ROWLIMIT';         //�\���ő�s�擾
  g_PRINTER_INFO = 'PRINTER_INFO'; //�v�����^�[���擾
  g_PRINTERNAME = 'PRINTERNAME';   //�v�����^�[���擾
  g_DISPNAME = 'DISPNAME';         //���[�^�C�g���擾
  g_PORTNAME = 'PORTNAME';         //�|�[�g�擾
  g_DRIVERNAME = 'DRIVERNAME';     //�h���C�o�擾
  g_SYSTEM = '*';                  //���і�
  g_COPIES = 'COPIES';             //�������
  g_PRINT_INFO = 'PRINT_INFO';     //�v�����^�[���擾(�[������)
  g_PRINTERNO = 'PRINTERNO';       //�v�����^�[���擾
  g_PRINTTITLE = 'PRINTTITLE';     //���[���َ擾
  g_IRAI_PRINT_INFO = 'IRAI_PRINT_INFO';     //�v�����^�[���擾(�˗��敪����)}

implementation
{$R *.DFM}

const
  PLACE_DB_ACC = '�f�[�^�x�[�X�ւ̐ڑ�';
  ERRMSG_001 = '�����ݒ�̍ő�ڑ����𒴂��܂����B';
  TAISHOMSG_001 = '�ő�ڑ����𒴂��ڑ��ɂ͎��Ԃ�������܂��B';
  g_DBNAME_HEDER = 'DB_';
  g_MASTER_NAME = 'WINMASTER'; //Ͻ���
  g_TBL_NAME = 'T_WINMASTER'; //ð��ٖ�
  g_TDS_NAME = 'DS_WINMASTER'; //�ް������
  g_ORDER_NAME = 'WinKey'; //���ް�޲��̍��ږ�
  g_QRY_COUNT = 11; //��ذؽĐ�
  g_NOT_GROUP_NO = '00'; //��ٰ��No�ȊO
  //2001.08.29
  g_WINMASTER_DBSNAME = 'WinmasterDBS'; //Winmaster�p�f�[�^�x�[�X��

//���@�\:DB�̃V�X�e������
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

//���@�\:�c�a�ڑ����䏉������
//Error:��O����
procedure TDM_DbAcc.DM_DbAccCreate(Sender: TObject);
var
    w_MaxDBList :integer; //�c�a�ڑ��̍ő�ێ���
    wi_DBi:integer; //�c�a�ڑ��Q�Ƃh�m�c�d�w
    w_i:integer;
    w_s:string;
begin
  //�������ς݂Ȃ牽�����Ȃ�
  if (DM_DbAcc <> nil) and (DM_DbAcc <> self) then
  begin
     Abort;
  end;
try
//1) ���ƂȂ�DB�ڑ����̐ݒ�
//��ʂ̖{�ڑ��Ƃ͕ʂɃV�X�e������p�Ƃ��ăZ�b�V������ڑ�����
//�i����F���ԏ����̂݁j�j
  DBs_MSter.Connected := false;
  DBs_MSter.Params.Clear;
  DBs_MSter.Params.Add( 'USER NAME=' + gi_DB_Account);
  DBs_MSter.Params.Add( 'PASSWORD=' + gi_DB_Pass);
  DBs_MSter.AliasName:=gi_DB_Name;
  DBs_MSter.Connected := false; //2001.08.29
  //DBs_MSter.Connected :=true; //2001.08.29
  //Q_Pass.DatabaseName := DBs_MSter.DatabaseName;

//2) ini���̓ǂݍ���
  w_MaxDBList := g_DB_CONECT_MAX;
//DB�ڑ����̓ǂݍ��݁i�f�t�H���g�͂W�j

//3) �Ǘ���̊l��
  SetLength (ga_DBList , w_MaxDBList);
//4) DB�̍쐬�Ɛڑ�
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
//5)ERR���̏�����
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
    gs_ErrMsgMs.Add('DB�̃G���[���b�Z�[�W����ł��B');
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
  //��ٰ�ߔԍ��ȊO�̸�ذ���쐬
  func_DBMST_Open(g_NOT_GROUP_NO);
except
  on E: Exception do
  begin
    func_MsgType1(
                  g_CST_SYSERR,
                  'DB�ڑ��������ɁA�G���[���N���܂����B'+ #13#10 +
                   E.Message,
                   '',
                   nil
                );
    Raise;
  end;
end;

end;

//���@�\:
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

//���@�\:�ڑ��ς�DB�̎擾
//̫�і��̐ڑ��ς�DB���擾����
//Error:��O����
{$HINTS OFF}
function func_GetDB(arg_FromName : string) : TDatabase ;
var
    wi_DBi:integer; //�c�a�ڑ��Q�Ƃh�m�c�d�w
    w_resMSG:Word; //MSGBOX���A�l
begin
  result:=nil;
//�P�j�Ǘ�̫�т�۰�ނ���Ă��Ȃ����۰�ނ���
  if DM_DbAcc=nil then DM_DbAcc:=TDM_DbAcc.Create(nil);
//�Q�j�Ǘ�����������ē����̫�і���DB������΂����
//������΋��̫�і��𕜋A�l�Ƃ���
//������������͎��Ԃ�������|��\�����č쐬�ڑ��������s���B
  //�Q�j�P�����̫�і���DB
  for wi_DBi:=0 to high(DM_DbAcc.ga_DBList)  do
  begin
    if DM_DbAcc.ga_DBList[wi_DBi].tStr_FormName = arg_FromName then
    begin
       result:=DM_DbAcc.ga_DBList[wi_DBi].tObj_DBase;
       exit;
    end;
  end;
  //�Q�j�R ���̫�і���DB
  for wi_DBi:=0 to high(DM_DbAcc.ga_DBList)  do
  begin
    if DM_DbAcc.ga_DBList[wi_DBi].tStr_FormName = '' then
    begin
       DM_DbAcc.ga_DBList[wi_DBi].tStr_FormName:=arg_FromName;
       result:=DM_DbAcc.ga_DBList[wi_DBi].tObj_DBase;
       exit;
    end;
  end;
  //�R�j massage�ʒm
{
  w_resMSG:=func_MsgDlg(
                        PLACE_DB_ACC + '�ŁA',
                        ERRMSG_001,
                        TAISHOMSG_001,
                        mtInformation,
                        [mbOK],
                        0
                        );
}
  //�S�j �V�K�쐬
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

//���@�\:�g�p���Ȃ��Ȃ����c�a�ڑ��̊J��
//Error: �����Ȃ�
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

//���@�\:�����x��IF��MSGBOX�iOK���݂̂݁j
function func_DBMsgType1Base(
                     arg_Cap      : string;     //�^�C�g��
                     arg_ProID    : string;     //�v���O����ID
                     arg_ErrorNo  : string;     //�G���[NO�D
                     arg_Addstring: string;     //�t�ѕ�����
                     arg_Detail   : string;     //�ڍו�����
                     arg_TForm    : TForm       //�I�[�iForm
                                         ):integer; //���A�l�FIDOK
var
  w_s:string;
  w_logmod:string;
  w_i:integer;
  w_Icon:string;
  w_MsgID:string;  //2001.09.14
begin
//DBMaster�`�F�b�N
   if DM_DbAcc.gs_ErrCodMs=nil then
   begin
     result:=IDOK;
     exit;
   end;
//DBMaster����
   w_i := DM_DbAcc.gs_ErrCodMs.IndexOf(arg_ProID+arg_ErrorNo);
   if w_i=-1 then//�Ώۂ�MSG���������̓f�t�H���g��ݒ�
   begin
     if G_SYSERROR00 = arg_ErrorNo then
     begin//00�͂��ׂļ��ѴׂƂ���B
       w_i := DM_DbAcc.gs_ErrCodMs.IndexOf(G_SYSPID+G_SYSERROR00);
       if w_i=-1 then
       begin//���݂��Ȃ����b�Z�[�W
         w_i := DM_DbAcc.gs_ErrCodMs.Count - 1;
       end;
     end
     else
     begin//���݂��Ȃ����b�Z�[�W
       w_i := DM_DbAcc.gs_ErrCodMs.Count - 1;
     end;
   end;
//���b�Z�[�W�����ݒ�
   w_s:=DM_DbAcc.gs_ErrMsgMs[w_i];
   w_Icon:=DM_DbAcc.gs_ErrIcon[w_i];
   //2001.09.14
   w_MsgID:=DM_DbAcc.gs_MsgID[w_i];
//���b�Z�[�W�\��
   result:=func_MsgType1(
                        arg_Cap,
                        w_s + arg_Addstring,
                        w_Icon,
                        w_MsgID,
                        arg_Detail,
                        arg_TForm
                        );
//Log�o��
   w_logmod:=DM_DbAcc.gs_ErrCodLogMod[w_i];
   proc_TraceMsgLog(
                 arg_ProID+arg_ErrorNo,
                 w_s + arg_Addstring,
                 w_logmod
                 );

end;
function func_DBMsgType1(
                     arg_Cap: string;   //�^�C�g��
                     arg_ProID: string; //�v���O����ID
                     arg_ErrorNo: string; //�G���[NO�D
                     arg_Addstring:string //�t�ѕ�����
                                         ):integer;overload; //���A�l�FIDOK
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
                     arg_Cap: string;      //�^�C�g��
                     arg_ProID: string;    //�v���O����ID
                     arg_ErrorNo: string;  //�G���[NO�D
                     arg_Addstring:string; //�t�ѕ�����
                     arg_TForm:TForm       //�I�[�iForm
                                         ):integer;overload; //���A�l�FIDOK
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
                     arg_Cap: string;      //�^�C�g��
                     arg_ProID: string;    //�v���O����ID
                     arg_ErrorNo: string;  //�G���[NO�D
                     arg_Addstring:string; //�t�ѕ�����
                     arg_Detailsstring:string; //�ڍו�����
                     arg_TForm:TForm       //�I�[�iForm
                                         ):integer;overload; //���A�l�FIDOK
begin
   result:=func_DBMsgType1Base(
                   arg_Cap,
                   arg_ProID,
                   arg_ErrorNo,
                   arg_Addstring,
                   arg_Detailsstring,
                   arg_TForm);
end;


//���@�\:�����x��IF��MSGBOX�iOK���݂̂݁j
function func_DBMsgType2Base(
                     arg_Cap: string;   //�^�C�g��
                     arg_ProID: string; //�v���O����ID
                     arg_ErrorNo: string; //�G���[NO�D
                     arg_Addstring:string; //�t�ѕ�����
                     arg_TForm:TForm       //�I�[�iForm
                                         ):integer; //���A�l�FIDOK IDCANCEL
var
  w_logmod:string;
  w_Icon:string;
  w_res:string;
  w_s:string;
  w_i:integer;
  w_MsgID:string;//2001.09.14

begin
//DBMaster�`�F�b�N
   //�d�l�ł���K�v�Ȃ��B
//DBMaster����
   w_i:=DM_DbAcc.gs_ErrCodMs.IndexOf(arg_ProID+arg_ErrorNo);
   if w_i=-1 then w_i:=DM_DbAcc.gs_ErrCodMs.Count-1;
//���b�Z�[�W�����ݒ�
   w_s:=DM_DbAcc.gs_ErrMsgMs[w_i];
   w_Icon:=DM_DbAcc.gs_ErrIcon[w_i];
   //2001.09.14
   w_MsgID:=DM_DbAcc.gs_MsgID[w_i];
//���b�Z�[�W�\��
   result:=func_MsgType2(
                        arg_Cap,
                        w_s + arg_Addstring,
                        w_Icon,
                        w_MsgID,
                        arg_TForm
                        );
//Log�o��
   w_logmod:=DM_DbAcc.gs_ErrCodLogMod[w_i];
   if IDOK =  result then
   begin
     w_res:='(OK)'
   end
   else
   begin
     w_res:='(��ݾ�)'
   end;
   proc_TraceMsgLog(
                 arg_ProID+arg_ErrorNo,
                 w_s + arg_Addstring+w_res,
                 w_logmod
                 );

end;
function func_DBMsgType2(
                     arg_Cap: string;   //�^�C�g��
                     arg_ProID: string; //�v���O����ID
                     arg_ErrorNo: string; //�G���[NO�D
                     arg_Addstring:string //�t�ѕ�����
                                         ):integer;overload; //���A�l�FIDOK
begin
   result:=func_DBMsgType2Base(arg_Cap,arg_ProID,arg_ErrorNo,arg_Addstring,nil);
end;
function func_DBMsgType2(
                     arg_Cap: string;      //�^�C�g��
                     arg_ProID: string;    //�v���O����ID
                     arg_ErrorNo: string;  //�G���[NO�D
                     arg_Addstring:string; //�t�ѕ�����
                     arg_TForm:TForm       //�I�[�iForm
                                         ):integer;overload; //���A�l�FIDOK
begin
   result:=func_DBMsgType2Base(arg_Cap,arg_ProID,arg_ErrorNo,arg_Addstring,arg_TForm);
end;

//���@�\:�����x��IF��MSGBOX�i���݂Ȃ��\���j
procedure proc_DBMsgType3S(
                     arg_TForm:TForm; //���͕s�ɂ���e̫�� nil�F�e�Ȃ�
                     arg_Cap: string; //�^�C�g��
                     arg_ProID: string; //�v���O����ID
                     arg_ErrorNo: string; //�G���[NO�D
                     arg_Addstring:string //�t�ѕ�����
                                         );
var
  w_s:string;
  w_Icon:string;
  w_i:integer;
begin
//DBMaster�`�F�b�N
   //�d�l�ł���K�v�Ȃ��B
//DBMaster����
   w_i:=DM_DbAcc.gs_ErrCodMs.IndexOf(arg_ProID+arg_ErrorNo);
   if w_i=-1 then w_i:=DM_DbAcc.gs_ErrCodMs.Count-1;
//���b�Z�[�W�����ݒ�
   w_s:=DM_DbAcc.gs_ErrMsgMs[w_i];
   w_Icon:=DM_DbAcc.gs_ErrIcon[w_i];
//���b�Z�[�W�\��
   proc_MsgType3S(
                 arg_TForm,
                 arg_Cap,
                 w_s + arg_Addstring
                        );
end;
//���@�\:�����x��IF��MSGBOX�i���݂Ȃ������j
procedure proc_DBMsgType3E(
                     arg_TForm:TForm //���͕s����������e̫�� nil�F�e�Ȃ�
                      );
begin
   proc_MsgType3E(arg_TForm);
end;
//���@�\:DB�̖��̂�order by��̃Z�b�g
procedure TDM_DbAcc.proc_DBMst_order;
begin
  ga_Qry_name := g_MASTER_NAME;
  ga_Order_name := g_ORDER_NAME;
  ga_QRY_count := g_QRY_COUNT;
  g_Qry_Flg := '0';
end;

//���@�\:�K�v�ȃ}�X�^�̵����
function func_DBMST_Open(
                     arg_GroupNo:String //�}�X�^�̵���݂�����t�H�[��No
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

    //��ذؽč쐬
    SetLength (DM_DbAcc.GQ_WinMaster_LIST , DM_DbAcc.ga_QRY_count); //�[���}�X�^
    SetLength (DM_DbAcc.ga_WinList , DM_DbAcc.ga_QRY_count); //�[���}�X�^

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

//���@�\:�}�X�^�̸۰��
procedure proc_DBMST_Close(
                     arg_GroupNo:String //�}�X�^�̸۰�ނ������ٰ��No
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
//���@�\:�F���̊l��
function func_Color(
                     arg_GroupNo:String; //��ٰ��No
                     arg_Data_Key:string  //�ް���
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
//���@�\:Ͻ�ð��فA�ް�����̍쐬
procedure TDM_DbAcc.proc_TBL_First;
begin
  //WINMASTER�p�f�[�^�x�[�X�쐬
  if g_WinMaster_DBS = nil then begin
    //�f�[�^�x�[�X�i�[�ϐ��쐬
    g_WinMaster_DBS := TDatabase.Create(nil);
    //�f�[�^�x�[�X�쐬
    g_WinMaster_DBS := func_GetDB(g_WINMASTER_DBSNAME);
  end;
  //ð��ق̍쐬
  if ga_TBL = nil then begin
    ga_TBL := TTable.Create(nil);
    ga_TBL.DatabaseName := g_WinMaster_DBS.DatabaseName;
    ga_TBL.TableName := g_MASTER_NAME; //WINMASTER
    ga_TBL.Name := g_TBL_NAME;
  end;
  //�ް�����̍쐬
  if ga_TDS = nil then begin
    ga_TDS := TDataSource.Create(nil);
    ga_TDS.DataSet := ga_TBL;
    ga_TDS.Name := g_TDS_NAME;
  end;
  //ð��ٵ����
  if ga_TBL <> nil then
    ga_TBL.Open;
end;
//���@�\:�K�v��Ͻ��̵����(ð���)
procedure proc_TBL_Open;
begin
  DM_DbAcc.proc_TBL_First;
end;
//���@�\:Ͻ��̸۰��(ð���)
procedure proc_TBL_Close;
begin
  if DM_DbAcc.ga_TBL <> nil then
    DM_DbAcc.ga_TBL.Close;
end;
//******************************************************************************
//* function name	: func_Query_TO_CBox
//* description		: Master��ǂݍ��݁AComboBox�ɓ��e���i�[����B
//* Result		: Integer	(RET)	0	: ����I��
//*						1	: �ُ�I��
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
                          arg_FieldByName	: String;	//���ږ�
                          arg_CBox		: TComboBox;	//�R���{�{�b�N�X
                          arg_SpaceSet		: integer;	//'��'  �L��(0:�Ȃ��A1:����)
                          arg_AllSet		: integer;	//'���ׂ�'�L��(0:�Ȃ��A1:����)
                          arg_Text		: String 	//�����\��Text
                        ):Integer;
begin
  //�߂�l������
  Result := 0;

  if arg_Query = nil then Exit;	        //Nil�h�~�m�F
  if arg_FieldByName = '' then Exit;	//Nil�h�~�m�F
  if arg_CBox = nil then Exit;		//Nil�h�~�m�F
  if (arg_SpaceSet <> 0) and (arg_SpaceSet <> 1) then arg_SpaceSet := 0;
  if (arg_AllSet <> 0) and (arg_AllSet <> 1) then arg_AllSet := 0;

  //�R���{�{�b�N�X���X�g�̃N���A
  arg_CBox.Items.Clear;

  //'��'���i�[
  if arg_SpaceSet = 1 then begin
    arg_CBox.Items.Add('');
  end;
  arg_CBox.ItemIndex := -1;

  //'���ׂ�'���i�[
  if arg_AllSet = 1 then begin
    arg_CBox.Items.Add(g_ALL_TEXT);
  end;

  with arg_Query do begin
    First;
    //�擾�f�[�^���i�[
    While not EOF do begin
      arg_CBox.Items.Add(FieldByName(arg_FieldByName).AsString);
      Next;
    end;
  end;

{ //'���ׂ�'���i�[
  if arg_AllSet = 1 then begin
    arg_CBox.Items.Add(g_ALL_TEXT);
  end; }

  //TEXT�\��
  func_Text_TO_CBox(arg_CBox,arg_SpaceSet,arg_AllSet,arg_Text);


end;
//******************************************************************************

//* function name	: func_Query_TO_CBox2
//* func_Query_TO_CBox�̉��� arg_AllSet�F��String�^�������Ƃ��Ēǉ���
//* arg_Query�̒l�̑O��arg_AllSet�̒l���R���{�{�b�N�X�̒l���ăZ�b�g����
//* description		: Master��ǂݍ��݁AComboBox�ɓ��e���i�[����B
//* Result		: Integer	(RET)	0	: ����I��
//*						1	: �ُ�I��
//*
//*
//* < function >
//* function func_Text_TO_CBox2( arg_CBox	: TComboBox;
//*                             arg_SpaceSet	: integer;
//*                             arg_FirstSet		: String;	// Query�̑O�ɃZ�b�g����l
//*                             arg_Text	: String
//*                           ):Integer;
//*
//******************************************************************************
function func_Query_TO_CBox2( arg_Query 		: TQuery;	//Query
                          arg_FieldByName	: String;	//���ږ�
                          arg_CBox		: TComboBox;	//�R���{�{�b�N�X
                          arg_SpaceSet		: integer;	//'��'  �L��(0:�Ȃ��A1:����)
                          arg_FirstSet		: String;	// Query�̑O�ɃZ�b�g����l
                          arg_Text		: String 	//�����\��Text
                        ):Integer;
begin
  //�߂�l������
  Result := 0;

  if arg_Query = nil then Exit;	        //Nil�h�~�m�F
  if arg_FieldByName = '' then Exit;	//Nil�h�~�m�F
  if arg_CBox = nil then Exit;		//Nil�h�~�m�F
  if (arg_SpaceSet <> 0) and (arg_SpaceSet <> 1) then arg_SpaceSet := 0;
  //�R���{�{�b�N�X���X�g�̃N���A
  arg_CBox.Items.Clear;

  //'��'���i�[
  if arg_SpaceSet = 1 then begin
    arg_CBox.Items.Add('');
  end;
  arg_CBox.ItemIndex := -1;

  //'�i�[
  if arg_FirstSet <> '' then begin
    arg_CBox.Items.Add(arg_FirstSet);
  end;

  with arg_Query do begin
    First;
    //�擾�f�[�^���i�[
    While not EOF do begin
      arg_CBox.Items.Add(FieldByName(arg_FieldByName).AsString);
      Next;
    end;
  end;

{ //'���ׂ�'���i�[
  if arg_AllSet = 1 then begin
    arg_CBox.Items.Add(g_ALL_TEXT);
  end; }

  //TEXT�\��
  func_Text_TO_CBox2(arg_CBox,arg_SpaceSet,arg_FirstSet,arg_Text);


end;
//******************************************************************************
//* function name	: func_Text_TO_CBox
//* description		: Text�̓��e��ComboBox��Text�ɕ\������B
//*
//******************************************************************************
function func_Text_TO_CBox( arg_CBox		: TComboBox;	//�R���{�{�b�N�X
                            arg_SpaceSet	: integer;	//'��'  �L��(0:�Ȃ��A1:����)
                            arg_AllSet		: integer;	//'���ׂ�'�L��(0:�Ȃ��A1:����)
                            arg_Text		: String 	//�����\��Text
                          ):integer;
var
  w_i: integer;
begin
  //�߂�l������
  Result := 0;
  //ComboBox��Item��Text�����邩�T��
  if arg_Text <> '' then begin
    //�Y���Ȃ�
    if 0 > arg_CBox.Items.IndexOf(arg_Text) then begin
      if arg_AllSet <> 1 then begin	//'���ׂ�'�����̏ꍇ
        arg_CBox.Items.Add(arg_Text);
      end else begin			//'���ׂ�'�L��̏ꍇ
        //�Ō��'���ׂ�'������
        arg_CBox.Items.Delete(arg_CBox.Items.Count - 1);
        //���߂�Text��'���ׂ�'��ǉ�
        arg_CBox.Items.Add(arg_Text);
        arg_CBox.Items.Add(g_ALL_TEXT);
      end;
    end;
  end;
  //Text����
  w_i := arg_CBox.Items.IndexOf(arg_Text);
  //Text�\��
  arg_CBox.ItemIndex := w_i;
end;
function func_Text_TO_CBox2( arg_CBox		: TComboBox;	//�R���{�{�b�N�X
                            arg_SpaceSet	: integer;	//'��'  �L��(0:�Ȃ��A1:����)
                            arg_FirstSet     	: String;	// Query�̑O�ɃZ�b�g����l
                            arg_Text		: String 	//�����\��Text
                          ):integer;
var
  w_i: integer;
begin
  //�߂�l������
  Result := 0;
  //ComboBox��Item��Text�����邩�T��
  if arg_Text <> '' then begin
    //�Y���Ȃ�
    if 0 > arg_CBox.Items.IndexOf(arg_Text) then begin
      if arg_FirstSet = '' then begin	//�̏ꍇ
        arg_CBox.Items.Add(arg_Text);
      end else begin			//�̏ꍇ
        //�Ō��'���ׂ�'������
        arg_CBox.Items.Delete(arg_CBox.Items.Count - 1);
        //���߂�Text��'���ׂ�'��ǉ�
        arg_CBox.Items.Add(arg_Text);
        arg_CBox.Items.Add(arg_FirstSet);
      end;
    end;
  end;
  //Text����
  w_i := arg_CBox.Items.IndexOf(arg_Text);
  //Text�\��
  arg_CBox.ItemIndex := w_i;
end;
//���@�\:�[�����̎擾
function func_Get_WinMaster(
                     arg_GroupNo:String; //��ٰ��No
                     arg_Section_Key:string; //����ݷ�
                     arg_Data_Key:string;  //�ް���
                     arg_Get:string   //�擾���ږ�
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
        //�Z�N�V�����A�f�[�^�L�[�̏����N���A
        ParamByName('PSECTION_KEY').Clear;
        ParamByName('PDATA_KEY').Clear;
        if (arg_Section_Key <> '') and (arg_Data_Key <> '') then begin
          //�Z�N�V�����A�f�[�^�L�[�̏����Z�b�g
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
//���@�\:�[�����̏C���A�ǉ�
procedure proc_Write_WinMaster(
                     arg_Section_Key:String; //����ݷ�
                     arg_Data_Key:String;    //�ް���
                     arg_Change_Name:String; //�ύX���ږ�
                     arg_Change:String;      //�ύX���e
                     arg_Win_flg:Integer     //�[���� 0 = g_SYSTEM , 1 = "���[����"
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
        ParamByName('PWINKEY').AsString := w_Win_name;           //�[����
        ParamByName('PSECTION_KEY').AsString := arg_Section_Key; //����ݷ�
        ParamByName('PDATA_KEY').AsString := arg_Data_Key;       //�ް���
        ParamByName('PCHANGE').AsString := arg_Change;           //�ύX����
      end
      else begin
        SQL.Add('UPDATE WINMASTER');
        SQL.Add('SET '+arg_Change_Name+' = :PCHANGE');
        SQL.Add('WHERE WINKEY = :PWINKEY');
        SQL.Add('AND SECTION_KEY = :PSECTION_KEY');
        SQL.Add('AND DATA_KEY = :PDATA_KEY');
        ParamByName('PWINKEY').AsString := w_Win_name;           //�[����
        ParamByName('PSECTION_KEY').AsString := arg_Section_Key; //����ݷ�
        ParamByName('PDATA_KEY').AsString := arg_Data_Key;       //�ް���
        ParamByName('PCHANGE').AsString := arg_Change;           //�ύX����
      end;
      ExecSQL;
    end;
    try
      //2001.08.29
      DM_DbAcc.g_WinMaster_DBS.Commit; // ���������ꍇ�C�ύX���R�~�b�g����
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
//���@�\:�^�C�}�[�@�\�擾
function func_Timer(
                     arg_GroupNo:String; //��ٰ��No
                     arg_Program_ID:string //���No
                      ): Boolean ;
var
  w_ans:string;
  w_Bool:Boolean;
begin
  w_ans := '';
  w_Bool := False;
  //�^�C�}�[�@�\�擾
  w_ans := func_Get_WinMaster(arg_GroupNo,arg_Program_ID,g_TIMEKIND,g_GET_DATA);

  if w_ans = '0' then
    w_Bool := False; //�@�\�Ȃ�
  if w_ans = '1' then
    w_Bool := True;  //�@�\����

  Result := w_Bool;
end;
//���@�\:�^�C�}�[���Ԏ擾
function func_TimerInterval(
                     arg_GroupNo:String; //��ٰ��No
                     arg_Program_ID:string //���No
                      ): Integer ;
var
  w_ians:integer;
  w_ans:string;
begin
  w_ans := '';
  w_ians := 0;
  //�^�C�}�[���Ԏ擾
  w_ans := func_Get_WinMaster(arg_GroupNo,arg_Program_ID,g_TIME,g_GET_DATA);

  if w_ans = '' then
    w_ians := 0;    //�C���^�[�o���Ȃ�
  if w_ans <> '' then
    w_ians := StrToInt(w_ans) * 1000;  //�C���^�[�o������

  Result := w_ians;
end;
//���@�\:�\���ő�s�擾
function func_RowLimit(
                     arg_GroupNo:String; //��ٰ��No
                     arg_Program_ID:string //���No
                      ): Integer ;
var
  w_ians:integer;
  w_ans:string;
begin
  w_ans := '';
  w_ians := 0;
  //�\���ő�s�擾
  w_ans := func_Get_WinMaster(arg_GroupNo,arg_Program_ID,g_ROWLIMIT,g_GET_DATA);

  if w_ans = '' then
    w_ians := 0;    //�ő�\���s�Ȃ�
  if w_ans <> '' then
    w_ians := StrToInt(w_ans);  //�ő�\���s����

  Result := w_ians;
end;
//���@�\:����ID�t�H�[�}�b�g�`���擾
function func_ID_Format(
                     arg_GroupNo:String; //��ٰ��No
                     arg_Program_ID:string //���No
                      ): String ;
var
  w_ans:string;
begin
  w_ans := '';
  //����ID�t�H�[�}�b�g�`���擾
  w_ans := func_Get_WinMaster(arg_GroupNo,g_FORMAT,g_FORMAT_KANJAID,g_GET_DATA);

  Result := w_ans;
end;
//���@�\:�O�����b�Z�[�W�\���擾
function func_ZeroDisplay(
                     arg_GroupNo:String; //��ٰ��No
                     arg_Program_ID:string //���No
                      ): Boolean ;
var
  w_ians:Boolean;
  w_ans:string;
begin
  w_ans := '';
  //�O�����b�Z�[�W�\���擾
  w_ans := func_Get_WinMaster(arg_GroupNo,arg_Program_ID,g_ZERODISPLAY,g_GET_DATA);

  if w_ans = '0' then
    w_ians := False    //�O�����b�Z�[�W�\���Ȃ�
  else
    w_ians := True;    //�O�����b�Z�[�W�\������

  Result := w_ians;
end;
//���@�\:�v�����^�[�̏��擾
procedure proc_PrintInfo(
                     arg_GroupNo:String; //��ٰ��No
                     arg_PrintNo:String; //�����No
                     var Print_name,     //��������
                         print_title,    //���[����
                         print_port,     //�߰�
                         print_driver:String; //��ײ��
                     var copies:Integer  //�������
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
      //�V�K̨����쐬
      w_sFilter := 'SECTION_KEY = ''' + g_PRINT_INFO + '''';
      Filter := w_sFilter;
      Filtered := True;
      FindFirst;
//2001.04.24
      w_print_copy := 1; //�������
      copies := w_print_copy;
      While not (Eof) do begin
        //�g�p�v�����^�i���o�[
        if Gval.Left(FieldByName('DATA_KEY').AsString ,9) = g_PRINTERNO then begin
          if Gval.Right(FieldByName('DATA_KEY').AsString ,2) = arg_PrintNo then begin
            w_P_No := FieldByName('DATA').AsString;
          end;
        end;
        //���[�^�C�g��
        if Gval.Left(FieldByName('DATA_KEY').AsString ,10) = g_PRINTTITLE then begin
          if Gval.Right(FieldByName('DATA_KEY').AsString ,2) = arg_PrintNo then begin
            print_title := FieldByName('DATA').AsString;
          end;
        end;
        //�������
        if Gval.Left(FieldByName('DATA_KEY').AsString ,6) = g_COPIES then begin
          if Gval.Right(FieldByName('DATA_KEY').AsString ,2) = arg_PrintNo then begin
            if FieldByName('DATA').AsString <> '' then begin
              w_print_copy := FieldByName('DATA').AsInteger;
            end
            else if FieldByName('DATA').AsString = '' then begin
              w_print_copy := 1; //Null�͈������
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
      //̨�������
      Filtered := False;
      //�V�K̨����쐬
      w_sFilter := 'SECTION_KEY = ''' +g_PRINTER_INFO +'''';
      Filter := w_sFilter;
      Filtered := True;
      FindFirst;
      While not (Eof) do begin
        //�v�����^
        if Gval.Left(DM_DbAcc.GQ_WinMaster_LIST[w_i].FieldByName('DATA_KEY').AsString ,11) = g_PRINTERNAME then begin
          //���[NO�v�����^
          if Gval.Right(FieldByName('DATA_KEY').AsString ,1) = w_P_No then begin
            Print_name := FieldByName('DATA').AsString;
          end;
        end;
        //�|�[�g
        if Gval.Left(DM_DbAcc.GQ_WinMaster_LIST[w_i].FieldByName('DATA_KEY').AsString ,8) = g_PORTNAME then begin
          if Gval.Right(FieldByName('DATA_KEY').AsString ,1) = w_P_No then begin
            print_port := FieldByName('DATA').AsString;
          end;
        end;
        //�h���C�o
        if Gval.Left(DM_DbAcc.GQ_WinMaster_LIST[w_i].FieldByName('DATA_KEY').AsString ,10) = g_DRIVERNAME then begin
          if Gval.Right(FieldByName('DATA_KEY').AsString ,1) = w_P_No then begin
            print_driver := FieldByName('DATA').AsString;
          end;
        end;
        if not FindNext then
          Break;
      end;
      //̨�������
      Filtered := False;
    end;
  end;
end;
//���@�\:�[�����̎擾(�ް�����)
function func_Get_WinMaster_DATA(
                     arg_GroupNo:String;     //��ٰ��No
                     arg_Section_Key:string; //����ݷ�
                     arg_Data_Key:string     //�ް���
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
//���@�\:�[�����̎擾(���l����)
function func_Get_WinMaster_BIKO(
                     arg_GroupNo:String;     //��ٰ��No
                     arg_Section_Key:string; //����ݷ�
                     arg_Data_Key:string     //�ް���
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
//���@�\:Ͻ�ð��ق���گ��
procedure proc_TBL_Refresh;
begin
  proc_TBL_Close;
  proc_TBL_Open;
end;
//���@�\:�[�����̏C���A�ǉ�(�ް����ځA���[���̂�)
procedure proc_Write_WinMaster_DATA(
                     arg_Section_Key:String; //����ݷ�
                     arg_Data_Key:String;    //�ް���
                     arg_Change:String       //�ύX���e
                      );
begin
  try
    proc_Write_WinMaster(arg_Section_Key,arg_Data_Key,g_GET_DATA,arg_Change,1);
  except
    raise;
  end;
end;
//���@�\:�[�����̏C���A�ǉ�(���l���ځA���[���̂�)
procedure proc_Write_WinMaster_BIKO(
                     arg_Section_Key:String; //����ݷ�
                     arg_Data_Key:String;    //�ް���
                     arg_Change:String       //�ύX���e
                      );
begin
  try
    proc_Write_WinMaster(arg_Section_Key,arg_Data_Key,g_GET_BIKO,arg_Change,1);
  except
    raise;
  end;
end;
//���@�\:�v�����^�[�̏��擾(�˗��敪����)
procedure proc_Irai_PrintInfo(
                     arg_GroupNo:String; //��ٰ��No
                     arg_PrintNo:String; //�����No
                     var Print_name,     //��������
                         print_title,    //���[����
                         print_port,     //�߰�
                         print_driver:String; //��ײ��
                     var copies:Integer  //�������
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
      //�V�K̨����쐬
      w_sFilter := 'SECTION_KEY = ''' + g_IRAI_PRINT_INFO + '''';
      Filter := w_sFilter;
      Filtered := True;
      FindFirst;
//2001.04.24
      w_print_copy := 1; //�������
      copies := w_print_copy;
      While not (Eof) do begin
        //�g�p�v�����^�i���o�[
        if Gval.Left(FieldByName('DATA_KEY').AsString ,9) = g_PRINTERNO then begin
          if Gval.Right(FieldByName('DATA_KEY').AsString ,2) = arg_PrintNo then begin
            w_P_No := FieldByName('DATA').AsString;
          end;
        end;
        //���[�^�C�g��
        if Gval.Left(FieldByName('DATA_KEY').AsString ,10) = g_PRINTTITLE then begin
          if Gval.Right(FieldByName('DATA_KEY').AsString ,2) = arg_PrintNo then begin
            print_title := FieldByName('DATA').AsString;
          end;
        end;
        //�������
        if Gval.Left(FieldByName('DATA_KEY').AsString ,6) = g_COPIES then begin
          if Gval.Right(FieldByName('DATA_KEY').AsString ,2) = arg_PrintNo then begin
            w_print_copy := 0;
            if FieldByName('DATA').AsString <> '' then begin
              w_print_copy := FieldByName('DATA').AsInteger;
            end
            else if FieldByName('DATA').AsString = '' then begin
              w_print_copy := 1; //Null�͈������
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
      //̨�������
      Filtered := False;
      //�V�K̨����쐬
      w_sFilter := 'SECTION_KEY = ''' +g_PRINTER_INFO +'''';
      Filter := w_sFilter;
      Filtered := True;
      FindFirst;
      While not (Eof) do begin
        //�v�����^
        if Gval.Left(DM_DbAcc.GQ_WinMaster_LIST[w_i].FieldByName('DATA_KEY').AsString ,11) = g_PRINTERNAME then begin
          //���[NO�v�����^
          if Gval.Right(FieldByName('DATA_KEY').AsString ,1) = w_P_No then begin
            Print_name := FieldByName('DATA').AsString;
          end;
        end;
        //�|�[�g
        if Gval.Left(DM_DbAcc.GQ_WinMaster_LIST[w_i].FieldByName('DATA_KEY').AsString ,8) = g_PORTNAME then begin
          if Gval.Right(FieldByName('DATA_KEY').AsString ,1) = w_P_No then begin
            print_port := FieldByName('DATA').AsString;
          end;
        end;
        //�h���C�o
        if Gval.Left(DM_DbAcc.GQ_WinMaster_LIST[w_i].FieldByName('DATA_KEY').AsString ,10) = g_DRIVERNAME then begin
          if Gval.Right(FieldByName('DATA_KEY').AsString ,1) = w_P_No then begin
            print_driver := FieldByName('DATA').AsString;
          end;
        end;
        if not FindNext then
          Break;
      end;
      //̨�������
      Filtered := False;
    end;
  end;
end;
//���w��e�[�u���Ɏw��̃t�B�[���h�����݂��邩���`�F�b�N 2003.04.24
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
//���\�񎞍�������̕\�L�ɕύX 2004.03.29
function func_ChangeKensaStartTime(
                                   arg_GroupNo:String;   //��ٰ��No
                                   arg_StartTime:String  //�\�񎞍�(9999)4��
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

//������������
initialization
begin
  DM_DbAcc:= nil;
end;

//���I��������
finalization
begin
end;

end.
