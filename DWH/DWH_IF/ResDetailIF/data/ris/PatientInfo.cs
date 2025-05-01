using System;
using System.Data;
using System.Collections.Generic;
//
using ComLib.log;
using ComLib.database;
using SlnCom;
using ResDetailIF.config;
using ResDetailIF.Main;

namespace ResDetailIF.data.ris
{
	/// <summary>
	/// PATIENTINFO アクセスクラス
	/// </summary>	
	public static class PatientInfo
	{
		#region 定数
		/// <summary>
		/// テーブル名
		/// </summary>
		private const string TABLE_NAME = "PATIENTINFO";
		#endregion

		#region メンバー
		#endregion

		#region [publlc]メソッド
		/// <summary>
		/// Update
		/// </summary>
		/// <param name="kanjaID">患者ID</param>
		/// <param name="data">ResDetailデータ</param>
		/// <returns>T:成功 F:失敗</returns>
		public static bool Update(string kanjaID, ResDetailData data)
		{
			const string CREA_VAL_COL =		"CREATININERESULT";
			const string CREA_DATE_COL =	"CREATININEUPDATEDATE";
			const string EGFR_VAL_COL =		"EGFRRESULT";
			const string EGFR_DATE_COL =	"EGFRUPDATEDATE";

			//データ更新(クレアチニン)
			if (Update(kanjaID, CREA_VAL_COL, CREA_DATE_COL, data.Creatinin) == false)
			{
				return false;
			}

			//データ更新(Egfr)
			if (Update(kanjaID, EGFR_VAL_COL, EGFR_DATE_COL, data.Egfr) == false)
			{
				return false;
			}

			return true;
		}
		#endregion

		#region [private]メソッド
		/// <summary>
		/// Update
		/// </summary>
		/// <param name="kanjaID">患者ID</param>
		/// <param name="valCol">結果値カラム</param>
		/// <param name="dateCol">採取日カラム</param>
		/// <param name="data">ResDetailデータ</param>
		/// <returns>T:成功 F:失敗</returns>
		private static bool Update(string kanjaID, string valCol, string dateCol, ResDetailData.DataSet data)
		{
			//データなし
			if (data.HasValue == false)
			{
				return true;
			}

			string sqlStr = @"UPDATE PATIENTINFO
SET {0} =:COL_VALUE
   ,{1} =:COL_DATE
WHERE KANJA_ID =:KANJA_ID";
			sqlStr = string.Format(sqlStr, valCol, dateCol);

			//パラメータ
			OraParams prms = new OraParams();
			prms.Add("COL_VALUE", 16, data.Value);
			prms.Add("COL_DATE", data.UpdateDate);
			prms.Add("KANJA_ID", 64, kanjaID);

			try
			{
				int count = AppGlobal.RISDB.ExecuteSQL(sqlStr, prms);
				AppGlobal.ApLogger.Info(TABLE_NAME + " [{0}]件 更新", count);
				return true;
			}
			catch (Exception ex)
			{
				AppGlobal.ApLogger.Error(TABLE_NAME + " 更新でエラー発生:" + ex);
				return false;
			}
		}
		#endregion
	}
}
