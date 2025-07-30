unit HisMsgDef04_KANJA_Kekka;
{
Å°ã@î\ê‡ñæ
  HISÇÃí êMìdï∂ÇÃíËã`
  èàóùÇÕãLèqÇµÇ»Ç¢Ç±Ç∆
  04ìdï∂íËã`
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
  HisMsgDef
  ;
//íËêîêÈåæ-------------------------------------------------------------------
const
  //2011.06 DBExpressëŒâû
  (*
  KANJACOMMANDNO    : Integer = 0;
  KANJAHOSPCODENO   : Integer = 0;
  KANJAPIDNO        : Integer = 0;
  KANJAPNAMENO      : Integer = 0;
  KANJAPKANANO      : Integer = 0;
  KANJASEXNO        : Integer = 0;
  KANJABIRTHDAYNO   : Integer = 0;
  KANJAPOSTCODE1NO  : Integer = 0;
  KANJAADDRESS1NO   : Integer = 0;
  KANJATEL1NO       : Integer = 0;
  KANJAPOSTCODE2NO  : Integer = 0;
  KANJAADDRESS2NO   : Integer = 0;
  KANJATEL2NO       : Integer = 0;
  KANJABYOUTOIDNO   : Integer = 0;
  KANJABYOUTONAMENO : Integer = 0;
  KANJAROOMIDNO     : Integer = 0;
  KANJAKANGOKBNNO   : Integer = 0;
  KANJAKANJAKBNNO   : Integer = 0;
  KANJAKYUGOKBNNO   : Integer = 0;
  KANJAYOBIKBNNO    : Integer = 0;
  KANJASYOGAINO     : Integer = 0;
  KANJAHEIGHTNO     : Integer = 0;
  KANJAWEIGHTNO     : Integer = 0;
  KANJABLOODABONO   : Integer = 0;
  KANJABLOODRHNO    : Integer = 0;
  KANJAKANSENNO     : Integer = 0;
  KANJAKANSENCOMNO  : Integer = 0;
  KANJAKINKINO      : Integer = 0;
  KANJAKINKICOMNO   : Integer = 0;
  KANJANINSINNO     : Integer = 0;
  KANJADETHDATENO   : Integer = 0;
  *)

  KANJACOMMANDLEN    = 8;
  KANJAHOSPCODELEN   = 2;
  KANJAPIDLEN        = 10;
  KANJAPNAMELEN      = 41;
  KANJAPKANALEN      = 21;
  KANJASEXLEN        = 1;
  KANJABIRTHDAYLEN   = 8;
  KANJAPOSTCODE1LEN  = 7;
  KANJAADDRESS1LEN   = 100;
  KANJATEL1LEN       = 12;
  KANJAPOSTCODE2LEN  = 7;
  KANJAADDRESS2LEN   = 100;
  KANJATEL2LEN       = 12;
  KANJABYOUTOIDLEN   = 4;
  KANJABYOUTONAMELEN = 10;
  KANJAROOMIDLEN     = 4;
  KANJAKANGOKBNLEN   = 1;
  KANJAKANJAKBNLEN   = 1;
  KANJAKYUGOKBNLEN   = 1;
  KANJAYOBIKBNLEN    = 1;
  KANJASYOGAILEN     = 15;
  KANJAHEIGHTLEN     = 5;
  KANJAWEIGHTLEN     = 5;
  KANJABLOODABOLEN   = 1;
  KANJABLOODRHLEN    = 1;
  KANJAKANSENLEN     = 20;
  KANJAKANSENCOMLEN  = 20;
//  KANJAKINKILEN      = 10;
  KANJAKINKILEN      = 20;
  KANJAKINKICOMLEN   = 20;
  KANJANINSINLEN     = 8;
  KANJADETHDATELEN   = 8;

  KANJACOMMANDNAME    = 'ÉRÉ}ÉìÉhñº';
  KANJAHOSPCODENAME   = 'ïaâ@ÉRÅ[Éh';
  KANJAPIDNAME        = 'ä≥é“î‘çÜ';
  KANJAPNAMENAME      = 'ä≥é“éÅñº';
  KANJAPKANANAME      = 'ä≥é“ÉJÉiñº';
  KANJASEXNAME        = 'ê´ï ';
  KANJABIRTHDAYNAME   = 'ê∂îNåéì˙';
  KANJAPOSTCODE1NAME  = 'óXï÷î‘çÜÇP';
  KANJAADDRESS1NAME   = 'èZèäÇP';
  KANJATEL1NAME       = 'ìdòbî‘çÜÇP';
  KANJAPOSTCODE2NAME  = 'óXï÷î‘çÜÇQ';
  KANJAADDRESS2NAME   = 'èZèäÇQ';
  KANJATEL2NAME       = 'ìdòbî‘çÜÇQ';
  KANJABYOUTOIDNAME   = 'ïaìèÉRÅ[Éh';
  KANJABYOUTONAMENAME = 'ïaìèñºèÃ';
  KANJAROOMIDNAME     = 'ïaé∫ÉRÅ[Éh';
  KANJAKANGOKBNNAME   = 'ä≈åÏãÊï™';
  KANJAKANJAKBNNAME   = 'ä≥é“ãÊï™';
  KANJAKYUGOKBNNAME   = 'ã~åÏãÊï™';
  KANJAYOBIKBNNAME    = 'ó\îıãÊï™';
  KANJASYOGAINAME     = 'è·äQèÓïÒ';
  KANJAHEIGHTNAME     = 'êgí∑';
  KANJAWEIGHTNAME     = 'ëÃèd';
  KANJABLOODABONAME   = 'ååâtå^AB';
  KANJABLOODRHNAME    = 'ååâtå^Å{Å|';
  KANJAKANSENNAME     = 'ä¥êıèÓïÒ';
  KANJAKANSENCOMNAME  = 'ä¥êıÉRÉÅÉìÉg';
  KANJAKINKINAME      = 'ã÷äıèÓïÒ';
  KANJAKINKICOMNAME   = 'ã÷äıÉRÉÅÉìÉg';
  KANJANINSINNAME     = 'îDêPì˙';
  KANJADETHDATENAME   = 'éÄñSëﬁâ@ì˙';
//ïœêîêÈåæ-------------------------------------------------------------------
var
//ìdï∂ÉtÉHÅ[É}ÉbÉgíËã`ãLâØïî
  g_Stream04_KANJA : array[1..G_MSGFNUM_KANJA] of TStreamField;

  //2011.06 DBExpressëŒâû
  KANJACOMMANDNO    : Integer = 0;
  KANJAHOSPCODENO   : Integer = 0;
  KANJAPIDNO        : Integer = 0;
  KANJAPNAMENO      : Integer = 0;
  KANJAPKANANO      : Integer = 0;
  KANJASEXNO        : Integer = 0;
  KANJABIRTHDAYNO   : Integer = 0;
  KANJAPOSTCODE1NO  : Integer = 0;
  KANJAADDRESS1NO   : Integer = 0;
  KANJATEL1NO       : Integer = 0;
  KANJAPOSTCODE2NO  : Integer = 0;
  KANJAADDRESS2NO   : Integer = 0;
  KANJATEL2NO       : Integer = 0;
  KANJABYOUTOIDNO   : Integer = 0;
  KANJABYOUTONAMENO : Integer = 0;
  KANJAROOMIDNO     : Integer = 0;
  KANJAKANGOKBNNO   : Integer = 0;
  KANJAKANJAKBNNO   : Integer = 0;
  KANJAKYUGOKBNNO   : Integer = 0;
  KANJAYOBIKBNNO    : Integer = 0;
  KANJASYOGAINO     : Integer = 0;
  KANJAHEIGHTNO     : Integer = 0;
  KANJAWEIGHTNO     : Integer = 0;
  KANJABLOODABONO   : Integer = 0;
  KANJABLOODRHNO    : Integer = 0;
  KANJAKANSENNO     : Integer = 0;
  KANJAKANSENCOMNO  : Integer = 0;
  KANJAKINKINO      : Integer = 0;
  KANJAKINKICOMNO   : Integer = 0;
  KANJANINSINNO     : Integer = 0;
  KANJADETHDATENO   : Integer = 0;

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
  g_Stream04_KANJA[g_wi].name   := g_Stream_Base[COMMON1SDIDNO].name;
  g_Stream04_KANJA[g_wi].x9     := g_Stream_Base[COMMON1SDIDNO].x9;
  g_Stream04_KANJA[g_wi].size   := g_Stream_Base[COMMON1SDIDNO].size;
  g_Stream04_KANJA[g_wi].offset := g_Stream_Base[COMMON1SDIDNO].offset;
  //2
  inc(g_wi);
  g_Stream04_KANJA[g_wi].name   := g_Stream_Base[COMMON1RVIDNO].name;
  g_Stream04_KANJA[g_wi].x9     := g_Stream_Base[COMMON1RVIDNO].x9;
  g_Stream04_KANJA[g_wi].size   := g_Stream_Base[COMMON1RVIDNO].size;
  g_Stream04_KANJA[g_wi].offset := g_Stream_Base[COMMON1RVIDNO].offset;
  //3
  inc(g_wi);
  g_Stream04_KANJA[g_wi].name   := g_Stream_Base[COMMON1COMMANDNO].name;
  g_Stream04_KANJA[g_wi].x9     := g_Stream_Base[COMMON1COMMANDNO].x9;
  g_Stream04_KANJA[g_wi].size   := g_Stream_Base[COMMON1COMMANDNO].size;
  g_Stream04_KANJA[g_wi].offset := g_Stream_Base[COMMON1COMMANDNO].offset;
  //4
  inc(g_wi);
  g_Stream04_KANJA[g_wi].name   := g_Stream_Base[COMMON1STATUSNO].name;
  g_Stream04_KANJA[g_wi].x9     := g_Stream_Base[COMMON1STATUSNO].x9;
  g_Stream04_KANJA[g_wi].size   := g_Stream_Base[COMMON1STATUSNO].size;
  g_Stream04_KANJA[g_wi].offset := g_Stream_Base[COMMON1STATUSNO].offset;
  //5
  inc(g_wi);
  g_Stream04_KANJA[g_wi].name   := g_Stream_Base[COMMON1DENLENNO].name;
  g_Stream04_KANJA[g_wi].x9     := g_Stream_Base[COMMON1DENLENNO].x9;
  g_Stream04_KANJA[g_wi].size   := g_Stream_Base[COMMON1DENLENNO].size;
  g_Stream04_KANJA[g_wi].offset := g_Stream_Base[COMMON1DENLENNO].offset;
  //14
  inc(g_wi);
  KANJACOMMANDNO := g_wi;
  g_Stream04_KANJA[g_wi].name   := KANJACOMMANDNAME;
  g_Stream04_KANJA[g_wi].x9     := G_FIELD_C;
  g_Stream04_KANJA[g_wi].size   := KANJACOMMANDLEN;
  g_Stream04_KANJA[g_wi].offset := g_Stream04_KANJA[g_wi-1].size+g_Stream04_KANJA[g_wi-1].offset;
  //15
  inc(g_wi);
  KANJAHOSPCODENO := g_wi;
  g_Stream04_KANJA[g_wi].name   := KANJAHOSPCODENAME;
  g_Stream04_KANJA[g_wi].x9     := G_FIELD_C;
  g_Stream04_KANJA[g_wi].size   := KANJAHOSPCODELEN;
  g_Stream04_KANJA[g_wi].offset := g_Stream04_KANJA[g_wi-1].size+g_Stream04_KANJA[g_wi-1].offset;
  //16
  inc(g_wi);
  KANJAPIDNO := g_wi;
  g_Stream04_KANJA[g_wi].name   := KANJAPIDNAME;
  g_Stream04_KANJA[g_wi].x9     := G_FIELD_C;
  g_Stream04_KANJA[g_wi].size   := KANJAPIDLEN;
  g_Stream04_KANJA[g_wi].offset := g_Stream04_KANJA[g_wi-1].size+g_Stream04_KANJA[g_wi-1].offset;
  //17
  inc(g_wi);
  KANJAPNAMENO := g_wi;
  g_Stream04_KANJA[g_wi].name   := KANJAPNAMENAME;
  g_Stream04_KANJA[g_wi].x9     := G_FIELD_C;
  g_Stream04_KANJA[g_wi].size   := KANJAPNAMELEN;
  g_Stream04_KANJA[g_wi].offset := g_Stream04_KANJA[g_wi-1].size+g_Stream04_KANJA[g_wi-1].offset;
  //18
  inc(g_wi);
  KANJAPKANANO := g_wi;
  g_Stream04_KANJA[g_wi].name   := KANJAPKANANAME;
  g_Stream04_KANJA[g_wi].x9     := G_FIELD_C;
  g_Stream04_KANJA[g_wi].size   := KANJAPKANALEN;
  g_Stream04_KANJA[g_wi].offset := g_Stream04_KANJA[g_wi-1].size+g_Stream04_KANJA[g_wi-1].offset;
  //19
  inc(g_wi);
  KANJASEXNO := g_wi;
  g_Stream04_KANJA[g_wi].name   := KANJASEXNAME;
  g_Stream04_KANJA[g_wi].x9     := G_FIELD_C;
  g_Stream04_KANJA[g_wi].size   := KANJASEXLEN;
  g_Stream04_KANJA[g_wi].offset := g_Stream04_KANJA[g_wi-1].size+g_Stream04_KANJA[g_wi-1].offset;
  //20
  inc(g_wi);
  KANJABIRTHDAYNO := g_wi;
  g_Stream04_KANJA[g_wi].name   := KANJABIRTHDAYNAME;
  g_Stream04_KANJA[g_wi].x9     := G_FIELD_C;
  g_Stream04_KANJA[g_wi].size   := KANJABIRTHDAYLEN;
  g_Stream04_KANJA[g_wi].offset := g_Stream04_KANJA[g_wi-1].size+g_Stream04_KANJA[g_wi-1].offset;
  //21
  inc(g_wi);
  KANJAPOSTCODE1NO := g_wi;
  g_Stream04_KANJA[g_wi].name   := KANJAPOSTCODE1NAME;
  g_Stream04_KANJA[g_wi].x9     := G_FIELD_C;
  g_Stream04_KANJA[g_wi].size   := KANJAPOSTCODE1LEN;
  g_Stream04_KANJA[g_wi].offset := g_Stream04_KANJA[g_wi-1].size+g_Stream04_KANJA[g_wi-1].offset;
  //22
  inc(g_wi);
  KANJAADDRESS1NO := g_wi;
  g_Stream04_KANJA[g_wi].name   := KANJAADDRESS1NAME;
  g_Stream04_KANJA[g_wi].x9     := G_FIELD_C;
  g_Stream04_KANJA[g_wi].size   := KANJAADDRESS1LEN;
  g_Stream04_KANJA[g_wi].offset := g_Stream04_KANJA[g_wi-1].size+g_Stream04_KANJA[g_wi-1].offset;
  //23
  inc(g_wi);
  KANJATEL1NO := g_wi;
  g_Stream04_KANJA[g_wi].name   := KANJATEL1NAME;
  g_Stream04_KANJA[g_wi].x9     := G_FIELD_C;
  g_Stream04_KANJA[g_wi].size   := KANJATEL1LEN;
  g_Stream04_KANJA[g_wi].offset := g_Stream04_KANJA[g_wi-1].size+g_Stream04_KANJA[g_wi-1].offset;
  //24
  inc(g_wi);
  KANJAPOSTCODE2NO := g_wi;
  g_Stream04_KANJA[g_wi].name   := KANJAPOSTCODE2NAME;
  g_Stream04_KANJA[g_wi].x9     := G_FIELD_C;
  g_Stream04_KANJA[g_wi].size   := KANJAPOSTCODE2LEN;
  g_Stream04_KANJA[g_wi].offset := g_Stream04_KANJA[g_wi-1].size+g_Stream04_KANJA[g_wi-1].offset;
  //25
  inc(g_wi);
  KANJAADDRESS2NO := g_wi;
  g_Stream04_KANJA[g_wi].name   := KANJAADDRESS2NAME;
  g_Stream04_KANJA[g_wi].x9     := G_FIELD_C;
  g_Stream04_KANJA[g_wi].size   := KANJAADDRESS2LEN;
  g_Stream04_KANJA[g_wi].offset := g_Stream04_KANJA[g_wi-1].size+g_Stream04_KANJA[g_wi-1].offset;
  //26
  inc(g_wi);
  KANJATEL2NO := g_wi;
  g_Stream04_KANJA[g_wi].name   := KANJATEL2NAME;
  g_Stream04_KANJA[g_wi].x9     := G_FIELD_C;
  g_Stream04_KANJA[g_wi].size   := KANJATEL2LEN;
  g_Stream04_KANJA[g_wi].offset := g_Stream04_KANJA[g_wi-1].size+g_Stream04_KANJA[g_wi-1].offset;
  //27
  inc(g_wi);
  KANJABYOUTOIDNO := g_wi;
  g_Stream04_KANJA[g_wi].name   := KANJABYOUTOIDNAME;
  g_Stream04_KANJA[g_wi].x9     := G_FIELD_C;
  g_Stream04_KANJA[g_wi].size   := KANJABYOUTOIDLEN;
  g_Stream04_KANJA[g_wi].offset := g_Stream04_KANJA[g_wi-1].size+g_Stream04_KANJA[g_wi-1].offset;
  //28
  inc(g_wi);
  KANJABYOUTONAMENO := g_wi;
  g_Stream04_KANJA[g_wi].name   := KANJABYOUTONAMENAME;
  g_Stream04_KANJA[g_wi].x9     := G_FIELD_C;
  g_Stream04_KANJA[g_wi].size   := KANJABYOUTONAMELEN;
  g_Stream04_KANJA[g_wi].offset := g_Stream04_KANJA[g_wi-1].size+g_Stream04_KANJA[g_wi-1].offset;
  //29
  inc(g_wi);
  KANJAROOMIDNO := g_wi;
  g_Stream04_KANJA[g_wi].name   := KANJAROOMIDNAME;
  g_Stream04_KANJA[g_wi].x9     := G_FIELD_C;
  g_Stream04_KANJA[g_wi].size   := KANJAROOMIDLEN;
  g_Stream04_KANJA[g_wi].offset := g_Stream04_KANJA[g_wi-1].size+g_Stream04_KANJA[g_wi-1].offset;
  //31
  inc(g_wi);
  KANJAKANGOKBNNO := g_wi;
  g_Stream04_KANJA[g_wi].name   := KANJAKANGOKBNNAME;
  g_Stream04_KANJA[g_wi].x9     := G_FIELD_C;
  g_Stream04_KANJA[g_wi].size   := KANJAKANGOKBNLEN;
  g_Stream04_KANJA[g_wi].offset := g_Stream04_KANJA[g_wi-1].size+g_Stream04_KANJA[g_wi-1].offset;
  //32
  inc(g_wi);
  KANJAKANJAKBNNO := g_wi;
  g_Stream04_KANJA[g_wi].name   := KANJAKANJAKBNNAME;
  g_Stream04_KANJA[g_wi].x9     := G_FIELD_C;
  g_Stream04_KANJA[g_wi].size   := KANJAKANJAKBNLEN;
  g_Stream04_KANJA[g_wi].offset := g_Stream04_KANJA[g_wi-1].size+g_Stream04_KANJA[g_wi-1].offset;
  //33
  inc(g_wi);
  KANJAKYUGOKBNNO := g_wi;
  g_Stream04_KANJA[g_wi].name   := KANJAKYUGOKBNNAME;
  g_Stream04_KANJA[g_wi].x9     := G_FIELD_C;
  g_Stream04_KANJA[g_wi].size   := KANJAKYUGOKBNLEN;
  g_Stream04_KANJA[g_wi].offset := g_Stream04_KANJA[g_wi-1].size+g_Stream04_KANJA[g_wi-1].offset;
  //34
  inc(g_wi);
  KANJAYOBIKBNNO := g_wi;
  g_Stream04_KANJA[g_wi].name   := KANJAYOBIKBNNAME;
  g_Stream04_KANJA[g_wi].x9     := G_FIELD_C;
  g_Stream04_KANJA[g_wi].size   := KANJAYOBIKBNLEN;
  g_Stream04_KANJA[g_wi].offset := g_Stream04_KANJA[g_wi-1].size+g_Stream04_KANJA[g_wi-1].offset;
  //35
  inc(g_wi);
  KANJASYOGAINO := g_wi;
  g_Stream04_KANJA[g_wi].name   := KANJASYOGAINAME;
  g_Stream04_KANJA[g_wi].x9     := G_FIELD_C;
  g_Stream04_KANJA[g_wi].size   := KANJASYOGAILEN;
  g_Stream04_KANJA[g_wi].offset := g_Stream04_KANJA[g_wi-1].size+g_Stream04_KANJA[g_wi-1].offset;
  //36
  inc(g_wi);
  KANJAHEIGHTNO := g_wi;
  g_Stream04_KANJA[g_wi].name   := KANJAHEIGHTNAME;
  g_Stream04_KANJA[g_wi].x9     := G_FIELD_N;
  g_Stream04_KANJA[g_wi].size   := KANJAHEIGHTLEN;
  g_Stream04_KANJA[g_wi].offset := g_Stream04_KANJA[g_wi-1].size+g_Stream04_KANJA[g_wi-1].offset;
  //37
  inc(g_wi);
  KANJAWEIGHTNO := g_wi;
  g_Stream04_KANJA[g_wi].name   := KANJAWEIGHTNAME;
  g_Stream04_KANJA[g_wi].x9     := G_FIELD_N;
  g_Stream04_KANJA[g_wi].size   := KANJAWEIGHTLEN;
  g_Stream04_KANJA[g_wi].offset := g_Stream04_KANJA[g_wi-1].size+g_Stream04_KANJA[g_wi-1].offset;
  //38
  inc(g_wi);
  KANJABLOODABONO := g_wi;
  g_Stream04_KANJA[g_wi].name   := KANJABLOODABONAME;
  g_Stream04_KANJA[g_wi].x9     := G_FIELD_C;
  g_Stream04_KANJA[g_wi].size   := KANJABLOODABOLEN;
  g_Stream04_KANJA[g_wi].offset := g_Stream04_KANJA[g_wi-1].size+g_Stream04_KANJA[g_wi-1].offset;
  //39
  inc(g_wi);
  KANJABLOODRHNO := g_wi;
  g_Stream04_KANJA[g_wi].name   := KANJABLOODRHNAME;
  g_Stream04_KANJA[g_wi].x9     := G_FIELD_C;
  g_Stream04_KANJA[g_wi].size   := KANJABLOODRHLEN;
  g_Stream04_KANJA[g_wi].offset := g_Stream04_KANJA[g_wi-1].size+g_Stream04_KANJA[g_wi-1].offset;
  //40
  inc(g_wi);
  KANJAKANSENNO := g_wi;
  g_Stream04_KANJA[g_wi].name   := KANJAKANSENNAME;
  g_Stream04_KANJA[g_wi].x9     := G_FIELD_C;
  g_Stream04_KANJA[g_wi].size   := KANJAKANSENLEN;
  g_Stream04_KANJA[g_wi].offset := g_Stream04_KANJA[g_wi-1].size+g_Stream04_KANJA[g_wi-1].offset;
  //41
  inc(g_wi);
  KANJAKANSENCOMNO := g_wi;
  g_Stream04_KANJA[g_wi].name   := KANJAKANSENCOMNAME;
  g_Stream04_KANJA[g_wi].x9     := G_FIELD_C;
  g_Stream04_KANJA[g_wi].size   := KANJAKANSENCOMLEN;
  g_Stream04_KANJA[g_wi].offset := g_Stream04_KANJA[g_wi-1].size+g_Stream04_KANJA[g_wi-1].offset;
  //42
  inc(g_wi);
  KANJAKINKINO := g_wi;
  g_Stream04_KANJA[g_wi].name   := KANJAKINKINAME;
  g_Stream04_KANJA[g_wi].x9     := G_FIELD_C;
  g_Stream04_KANJA[g_wi].size   := KANJAKINKILEN;
  g_Stream04_KANJA[g_wi].offset := g_Stream04_KANJA[g_wi-1].size+g_Stream04_KANJA[g_wi-1].offset;
  //43
  inc(g_wi);
  KANJAKINKICOMNO := g_wi;
  g_Stream04_KANJA[g_wi].name   := KANJAKINKICOMNAME;
  g_Stream04_KANJA[g_wi].x9     := G_FIELD_C;
  g_Stream04_KANJA[g_wi].size   := KANJAKINKICOMLEN;
  g_Stream04_KANJA[g_wi].offset := g_Stream04_KANJA[g_wi-1].size+g_Stream04_KANJA[g_wi-1].offset;
  //44
  inc(g_wi);
  KANJANINSINNO := g_wi;
  g_Stream04_KANJA[g_wi].name   := KANJANINSINNAME;
  g_Stream04_KANJA[g_wi].x9     := G_FIELD_C;
  g_Stream04_KANJA[g_wi].size   := KANJANINSINLEN;
  g_Stream04_KANJA[g_wi].offset := g_Stream04_KANJA[g_wi-1].size+g_Stream04_KANJA[g_wi-1].offset;
  //45
  inc(g_wi);
  KANJADETHDATENO := g_wi;
  g_Stream04_KANJA[g_wi].name   := KANJADETHDATENAME;
  g_Stream04_KANJA[g_wi].x9     := G_FIELD_C;
  g_Stream04_KANJA[g_wi].size   := KANJADETHDATELEN;
  g_Stream04_KANJA[g_wi].offset := g_Stream04_KANJA[g_wi-1].size+g_Stream04_KANJA[g_wi-1].offset;
end;

finalization
begin
//
end;

end.
