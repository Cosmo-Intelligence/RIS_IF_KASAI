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
	/// ResDetail アクセスクラス
	/// </summary>	
	public static class ResDetail
	{
		#region 定数
		/// <summary>
		/// テーブル名
		/// </summary>
		private const string TABLE_NAME = "RIS_RESDETAIL";
		#endregion

		#region プロパティ
		/// <summary>
		/// 検索用 項目コード
		/// </summary>
		public static string ItemCode
		{
			private get;
			set;
		}
		#endregion

		#region [publlc]メソッド
		/// <summary>
		/// Select
		/// </summary>
		/// <param name="risData">ToHisInfoデータ</param>
		/// <returns>データ</returns>
		public static DataTable Select(DataRow risData)
		{
			string sqlStr = @"SELECT *
FROM RIS_RESDETAIL
WHERE PATIENTNO =:PATIENTNO
AND TESTSIGN >= '1'
AND TESTITEMCODE IN ({0})
ORDER BY COLLECTDATE DESC, COLLECTTIME DESC";

			sqlStr = string.Format(sqlStr, ItemCode);
			//パラメータ
			OraParams prms = new OraParams();
			prms.Add("PATIENTNO", 10, risData.StrVal("MESSAGEID1"));

			//SQL実行
			return AppGlobal.DWHDB.ExecuteDataTable(sqlStr, prms);
		}
		#endregion
	}
}
