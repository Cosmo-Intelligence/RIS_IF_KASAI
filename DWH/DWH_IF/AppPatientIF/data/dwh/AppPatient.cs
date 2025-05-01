using System;
using System.Data;
using System.Collections.Generic;
//
using ComLib.log;
using ComLib.database;
using ResDetailIF.config;
using SlnCom;

namespace ResDetailIF.data.dwh
{
	/// <summary>
	/// RIS_APPPATIENT アクセスクラス
	/// </summary>	
	public static class AppPatient
	{
		#region 定数
		/// <summary>
		/// テーブル名
		/// </summary>
		private const string TABLE_NAME = "RIS_APPPATIENT";
		#endregion

		#region プロパティ
		#endregion

		#region [publlc]メソッド
		/// <summary>
		/// Select
		/// </summary>
		/// <param name="row">オーダデータ</param>
		/// <returns>データ</returns>
		public static DataTable Select(DataRow row)
		{
			string sqlStr = @"SELECT 
   UPDATEDATE
  ,VISITTIME
FROM RIS_APPPATIENT
WHERE INVALIDSTATUS = '0'
AND VISITSTATUS = '1'
AND PATIENTNO =:PATIENTNO
ORDER BY UPDATEDATE DESC, VISITTIME DESC";

			OraParams prms = new OraParams();
			prms.Add("PATIENTNO", 10, row.StrVal("KANJA_ID"));

			//SQL実行
			DataTable dt = AppGlobal.DWHDB.ExecuteDataTable(sqlStr, prms);
			AppGlobal.ApLogger.Info(TABLE_NAME + " 取得件数[{0}]", dt.Rows.Count);
			return dt;
		}
		#endregion
	}
}
