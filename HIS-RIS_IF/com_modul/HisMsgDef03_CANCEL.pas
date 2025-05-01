unit HisMsgDef03_CANCEL;
{
Å°ã@î\ê‡ñæ
  HISÇÃí êMìdï∂ÇÃíËã`
  èàóùÇÕãLèqÇµÇ»Ç¢Ç±Ç∆
  01ìdï∂íËã`
Å°óöó
êVãKçÏê¨ÅF2004.08.27ÅFíSìñ ëùìc
}
interface //*****************************************************************
//égópÉÜÉjÉbÉg---------------------------------------------------------------
uses
//ÉVÉXÉeÉÄÅ|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|
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
  //FileCtrl,
  Registry,
  ExtCtrls,
//ÉvÉçÉ_ÉNÉgäJî≠ã§í Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|Å|
  HisMsgDef;
//íËêîêÈåæ-------------------------------------------------------------------
const
  //2011.06 DBExpressëŒâû
  (*
  IRAICCOMMANDNO    : Integer = 0;
  IRAICHOSPCODENO   : Integer = 0;
  IRAICPIDNO        : Integer = 0;
  IRAICORDERNO      : Integer = 0;
  IRAICSTARTDATENO  : Integer = 0;
  IRAICSTARTTIMENO  : Integer = 0;
  IRAICOPERATCODENO : Integer = 0;
  IRAICOPERATNAMENO : Integer = 0;
  *)

  IRAICCOMMANDLEN    = 8;
  IRAICHOSPCODELEN   = 2;
  IRAICPIDLEN        = 10;
  IRAICORDERLEN      = 16;
  IRAICSTARTDATELEN  = 8;
  IRAICSTARTTIMELEN  = 4;
  IRAICOPERATCODELEN = 10;
  IRAICOPERATNAMELEN = 20;

  IRAICCOMMANDNAME    = 'ÉRÉ}ÉìÉhñº';
  IRAICHOSPCODENAME   = 'ïaâ@ÉRÅ[Éh';
  IRAICPIDNAME        = 'ä≥é“î‘çÜ';
  IRAICORDERNAME      = 'ÉIÅ[É_î‘çÜ';
  IRAICSTARTDATENAME  = 'äJénì˙';
  IRAICSTARTTIMENAME  = 'äJénéûçè';
  IRAICOPERATCODENAME = 'ëÄçÏé“ÉRÅ[Éh';
  IRAICOPERATNAMENAME = 'ëÄçÏé“ñº';
//ïœêîêÈåæ-------------------------------------------------------------------
var
//ìdï∂ÉtÉHÅ[É}ÉbÉgíËã`ãLâØïî
  g_Stream03_CANCEL     : array[1..G_MSGFNUM_CANCEL] of TStreamField;

  //2011.06 DBExpressëŒâû
  IRAICCOMMANDNO    : Integer = 0;
  IRAICHOSPCODENO   : Integer = 0;
  IRAICPIDNO        : Integer = 0;
  IRAICORDERNO      : Integer = 0;
  IRAICSTARTDATENO  : Integer = 0;
  IRAICSTARTTIMENO  : Integer = 0;
  IRAICOPERATCODENO : Integer = 0;
  IRAICOPERATNAMENO : Integer = 0;

//ä÷êîéËë±Ç´êÈåæ-------------------------------------------------------------

implementation //**************************************************************

//égópÉÜÉjÉbÉg---------------------------------------------------------------
//uses

//íËêîêÈåæ       -------------------------------------------------------------
//const

//ïœêîêÈåæ     ---------------------------------------------------------------
var
  g_wi  : INTEGER;
//ä÷êîéËë±Ç´êÈåæ--------------------------------------------------------------

initialization
begin
  //1
  g_wi := 1;
  g_Stream03_CANCEL[g_wi].name   := g_Stream_Base[COMMON1SDIDNO].name;
  g_Stream03_CANCEL[g_wi].x9     := g_Stream_Base[COMMON1SDIDNO].x9;
  g_Stream03_CANCEL[g_wi].size   := g_Stream_Base[COMMON1SDIDNO].size;
  g_Stream03_CANCEL[g_wi].offset := g_Stream_Base[COMMON1SDIDNO].offset;
  //2
  inc(g_wi);
  g_Stream03_CANCEL[g_wi].name   := g_Stream_Base[COMMON1RVIDNO].name;
  g_Stream03_CANCEL[g_wi].x9     := g_Stream_Base[COMMON1RVIDNO].x9;
  g_Stream03_CANCEL[g_wi].size   := g_Stream_Base[COMMON1RVIDNO].size;
  g_Stream03_CANCEL[g_wi].offset := g_Stream_Base[COMMON1RVIDNO].offset;
  //3
  inc(g_wi);
  g_Stream03_CANCEL[g_wi].name   := g_Stream_Base[COMMON1COMMANDNO].name;
  g_Stream03_CANCEL[g_wi].x9     := g_Stream_Base[COMMON1COMMANDNO].x9;
  g_Stream03_CANCEL[g_wi].size   := g_Stream_Base[COMMON1COMMANDNO].size;
  g_Stream03_CANCEL[g_wi].offset := g_Stream_Base[COMMON1COMMANDNO].offset;
  //4
  inc(g_wi);
  g_Stream03_CANCEL[g_wi].name   := g_Stream_Base[COMMON1STATUSNO].name;
  g_Stream03_CANCEL[g_wi].x9     := g_Stream_Base[COMMON1STATUSNO].x9;
  g_Stream03_CANCEL[g_wi].size   := g_Stream_Base[COMMON1STATUSNO].size;
  g_Stream03_CANCEL[g_wi].offset := g_Stream_Base[COMMON1STATUSNO].offset;
  //5
  inc(g_wi);
  g_Stream03_CANCEL[g_wi].name   := g_Stream_Base[COMMON1DENLENNO].name;
  g_Stream03_CANCEL[g_wi].x9     := g_Stream_Base[COMMON1DENLENNO].x9;
  g_Stream03_CANCEL[g_wi].size   := g_Stream_Base[COMMON1DENLENNO].size;
  g_Stream03_CANCEL[g_wi].offset := g_Stream_Base[COMMON1DENLENNO].offset;
  //14
  inc(g_wi);
  IRAICCOMMANDNO := g_wi;
  g_Stream03_CANCEL[g_wi].name   := IRAICCOMMANDNAME;
  g_Stream03_CANCEL[g_wi].x9     := G_FIELD_C;
  g_Stream03_CANCEL[g_wi].size   := IRAICCOMMANDLEN;
  g_Stream03_CANCEL[g_wi].offset := g_Stream03_CANCEL[g_wi-1].size+g_Stream03_CANCEL[g_wi-1].offset;
  //15
  inc(g_wi);
  IRAICHOSPCODENO := g_wi;
  g_Stream03_CANCEL[g_wi].name   := IRAICHOSPCODENAME;
  g_Stream03_CANCEL[g_wi].x9     := G_FIELD_C;
  g_Stream03_CANCEL[g_wi].size   := IRAICHOSPCODELEN;
  g_Stream03_CANCEL[g_wi].offset := g_Stream03_CANCEL[g_wi-1].size+g_Stream03_CANCEL[g_wi-1].offset;
  //16
  inc(g_wi);
  IRAICPIDNO := g_wi;
  g_Stream03_CANCEL[g_wi].name   := IRAICPIDNAME;
  g_Stream03_CANCEL[g_wi].x9     := G_FIELD_C;
  g_Stream03_CANCEL[g_wi].size   := IRAICPIDLEN;
  g_Stream03_CANCEL[g_wi].offset := g_Stream03_CANCEL[g_wi-1].size+g_Stream03_CANCEL[g_wi-1].offset;
  //17
  inc(g_wi);
  IRAICORDERNO := g_wi;
  g_Stream03_CANCEL[g_wi].name   := IRAICORDERNAME;
  g_Stream03_CANCEL[g_wi].x9     := G_FIELD_C;
  g_Stream03_CANCEL[g_wi].size   := IRAICORDERLEN;
  g_Stream03_CANCEL[g_wi].offset := g_Stream03_CANCEL[g_wi-1].size+g_Stream03_CANCEL[g_wi-1].offset;
  //18
  inc(g_wi);
  IRAICSTARTDATENO := g_wi;
  g_Stream03_CANCEL[g_wi].name   := IRAICSTARTDATENAME;
  g_Stream03_CANCEL[g_wi].x9     := G_FIELD_C;
  g_Stream03_CANCEL[g_wi].size   := IRAICSTARTDATELEN;
  g_Stream03_CANCEL[g_wi].offset := g_Stream03_CANCEL[g_wi-1].size+g_Stream03_CANCEL[g_wi-1].offset;
  //19
  inc(g_wi);
  IRAICSTARTTIMENO := g_wi;
  g_Stream03_CANCEL[g_wi].name   := IRAICSTARTTIMENAME;
  g_Stream03_CANCEL[g_wi].x9     := G_FIELD_C;
  g_Stream03_CANCEL[g_wi].size   := IRAICSTARTTIMELEN;
  g_Stream03_CANCEL[g_wi].offset := g_Stream03_CANCEL[g_wi-1].size+g_Stream03_CANCEL[g_wi-1].offset;
  //20
  inc(g_wi);
  IRAICOPERATCODENO := g_wi;
  g_Stream03_CANCEL[g_wi].name   := IRAICOPERATCODENAME;
  g_Stream03_CANCEL[g_wi].x9     := G_FIELD_C;
  g_Stream03_CANCEL[g_wi].size   := IRAICOPERATCODELEN;
  g_Stream03_CANCEL[g_wi].offset := g_Stream03_CANCEL[g_wi-1].size+g_Stream03_CANCEL[g_wi-1].offset;
  //21
  inc(g_wi);
  IRAICOPERATNAMENO := g_wi;
  g_Stream03_CANCEL[g_wi].name   := IRAICOPERATNAMENAME;
  g_Stream03_CANCEL[g_wi].x9     := G_FIELD_C;
  g_Stream03_CANCEL[g_wi].size   := IRAICOPERATNAMELEN;
  g_Stream03_CANCEL[g_wi].offset := g_Stream03_CANCEL[g_wi-1].size+g_Stream03_CANCEL[g_wi-1].offset;
end;

finalization
begin
//
end;

end.
