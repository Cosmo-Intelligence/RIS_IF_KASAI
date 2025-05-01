using System;
using System.Data;
using System.Collections.Generic;
//
using ComLib.log;
using ComLib.database;
using ResDetailIF.config;
using SlnCom;

namespace ResDetailIF.data.ris
{
	/// <summary>
	/// �L���[�e�[�u�� �A�N�Z�X�N���X
	/// </summary>	
	public static class QueueTable
	{
		#region �萔
		#endregion

		#region �����o�[
		#endregion

		#region [publlc]���\�b�h
		/// <summary>
		/// Select
		/// </summary>
		/// <returns>�f�[�^</returns>
		public static DataTable Select(DateTime kensaDate)
		{
			//������		Kensa_Date = ����
			//��t����	Status < 10
			//������		INCHAKU_FLG <> '1'
			string sqlStr = @"SELECT OM.RIS_ID, OM.ORDERNO, OM.KANJA_ID
FROM ORDERMAINTABLE OM
  LEFT JOIN EXMAINTABLE EX ON OM.RIS_ID = EX.RIS_ID
  LEFT JOIN PATIENTINFO PT ON OM.KANJA_ID = PT.KANJA_ID
WHERE OM.KENSA_DATE =:KENSA_DATE
AND EX.STATUS < 10
AND NVL(PT.INCHAKU_FLG, '0') <> '1'";

			OraParams prms = new OraParams();
			prms.Add("KENSA_DATE", 8, kensaDate.ToString("yyyyMMdd"));

			//SQL���s
			return AppGlobal.RISDB.ExecuteDataTable(sqlStr, prms);
		}
		#endregion
	}
}
