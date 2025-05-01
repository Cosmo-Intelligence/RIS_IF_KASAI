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
		/// <param name="inchakuDate">院着日時</param>
		/// <returns>T:成功 F:失敗</returns>
		public static bool Update(string kanjaID, DateTime inchakuDate)
		{
			//INCHAKU_FLG = 1 (到着済)
			string sqlStr = @"UPDATE PATIENTINFO
SET INCHAKU_DATE =:INCHAKU_DATE
   ,INCHAKU_FLG ='1'
WHERE KANJA_ID =:KANJA_ID";

			//パラメータ
			OraParams prms = new OraParams();
			prms.Add("INCHAKU_DATE", inchakuDate);
			prms.Add("KANJA_ID", 64, kanjaID);;
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
