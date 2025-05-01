using System;
using System.Collections.Generic;
using System.Text;
using System.Data.OracleClient;

namespace ComLib.database
{
	/// <summary>
	/// SQL用文字列操作クラス
	/// </summary>
	public static class SqlUtil
	{
		#region SQL用文字列操作
		/// <summary>
		/// パラメータ名取得
		/// </summary>
		/// <param name="column_name">カラム名</param>
		/// <param name="value">設定値</param>
		/// <returns>設定値:NULL以外→":"＋カラム名 NULL→NULL</returns>
		public static string ParamName(string column_name, string value)
		{
			string result = "NULL";
			if (value.Length > 0)
			{
				result = ":" + column_name;
			}
			return result;
		}
		/// <summary>
		/// List から IN ( XX ) に使用する文字列作成
		/// </summary>
		/// <param name="list">リスト</param>
		/// <returns>文字列</returns>
		public static string InStr(List<string> list, bool isQuote)
		{
			string result = "";
			foreach (string item in list)
			{
				if (result != "")
				{
					result += ",";
				}

				if (isQuote == true)
				{
					result += "'" + item + "'";
				}
				else
				{
					result += item;
				}
			}
			return (result == "") ? "''" : result;
		}
		#endregion

		#region パラメータ設定
		/// <summary>
		/// パラメータに値設定(Int)
		/// </summary>
		/// <param name="vIprm">パラメータ</param>
		/// <param name="vIval">値</param>
		public static void SetPrm(OracleParameter vIprm, int vIval)
		{
			if (vIval == int.MinValue)
			{
				vIprm.Value = DBNull.Value;
			}
			else
			{
				vIprm.Value = vIval;
			}
		}
		/// <summary>
		/// パラメータに値設定(decimal)
		/// </summary>
		/// <param name="vIprm">パラメータ</param>
		/// <param name="vIval">値</param>
		public static void SetPrm(OracleParameter vIprm, decimal vIval)
		{
			if (vIval == decimal.MinValue)
			{
				vIprm.Value = vIprm.Value = DBNull.Value;
			}
			else
			{
				vIprm.Value = vIval;
			}
		}
		/// <summary>
		/// パラメータに値設定(datetime)
		/// </summary>
		/// <param name="vIprm">パラメータ</param>
		/// <param name="vIval">値</param>
		public static void SetPrm(OracleParameter vIprm, DateTime vIval)
		{
			if (vIval == DateTime.MinValue)
			{
				vIprm.Value = DBNull.Value;
			}
			else
			{
				vIprm.Value = vIval;
			}
		}
		#endregion
	}
}
