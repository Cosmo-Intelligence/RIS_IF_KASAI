//#define FRAMEWORK_V2
#define FRAMEWORK_V4

using System;
using System.Data;

namespace ComLib.database
{
	/// <summary>
	/// DataRow拡張 クラス
	/// </summary>
	public static class DataRowExtensions
	{
		#region [publlc]メソッド
		/// <summary>
		/// データNULL 確認
		/// </summary>
		/// <param name="field">カラム名</param>
		/// <returns>T:Null F:Not Null</returns>
		public static bool IsNull(this DataRow row, string field)
		{
			if (row.Table.Columns.Contains(field) == true)
			{
				return Convert.IsDBNull(row[field]);
			}
			else
			{
				return false;
			}
		}
		/// <summary>
		/// データ取得(文字列)
		/// </summary>
		/// <param name="field">カラム名</param>
		/// <returns>データ値</returns>
		public static string StrVal(this DataRow row, string field)
		{
			if (row.Table.Columns.Contains(field) == true)
			{
				return row[field].ToString();
			}
			else
			{
				return "";
			}
		}

		#region 数値
		/// <summary>
		/// データ取得(数値)
		/// </summary>
		/// <param name="field">カラム名</param>
		/// <param name="defVal">デフォルト値</param>
		/// <returns>データ値</returns>
		public static int IntVal(this DataRow row, string field, int defVal = int.MinValue)
		{
			string strVal = StrVal(row, field);
			int val;
			if (int.TryParse(strVal, out val) == true)
			{
				return val;
			}
			else
			{
				return defVal;
			}
		}
		/// <summary>
		/// データ取得(数値)
		/// </summary>
		/// <param name="field">カラム名</param>
		/// <param name="defVal">デフォルト値</param>
		/// <returns>データ値</returns>
		/// <remarks>DBNULLをデフォルト値に使用</remarks>
		public static object ObjValInt(this DataRow row, string field, object defVal = null)
		{
			string strVal = StrVal(row, field);
			int val;
			if (int.TryParse(strVal, out val) == true)
			{
				return val;
			}
			else
			{
				return (defVal == null) ? DBNull.Value : defVal;
			}
		}

		/// <summary>
		/// データ取得(数値)
		/// </summary>
		/// <param name="field">カラム名</param>
		/// <param name="defVal">デフォルト値</param>
		/// <returns>データ値</returns>
		public static long LongVal(this DataRow row, string field, long defVal = long.MinValue)
		{
			string strVal = StrVal(row, field);
			long val;
			if (long.TryParse(strVal, out val) == true)
			{
				return val;
			}
			else
			{
				return defVal;
			}
		}
		#endregion

		#region 日付
		/// <summary>
		/// データ取得(日付)
		/// </summary>
		/// <param name="field">カラム名</param>
		/// <param name="defVal">デフォルト値</param>
		/// <returns>データ値</returns>
		public static DateTime DateVal(this DataRow row, string field, DateTime defVal)
		{
			try
			{
#if FRAMEWORK_V2
				return (DateTime)row[field];
#else
				return row.Field<DateTime>(field);
#endif
			}
			catch
			{
				return defVal;
			}
		}
		/// <summary>
		/// データ取得(日付)
		/// </summary>
		/// <param name="field">カラム名</param>
		/// <returns>データ値</returns>
		public static DateTime DateVal(this DataRow row, string field)
		{
			return DateVal(row, field, DateTime.MinValue);
		}
		/// <summary>
		/// データ取得(日付)
		/// </summary>
		/// <param name="field">カラム名</param>
		/// <param name="defVal">デフォルト値</param>
		/// <returns>データ値</returns>
		/// <remarks>DBNULLをデフォルト値に使用</remarks>
		public static object ObjValDate(this DataRow row, string field, object defVal = null)
		{
			try
			{
#if FRAMEWORK_V2
				return (DateTime)row[field];
#else
				return row.Field<DateTime>(field);
#endif
			}
			catch
			{
				return (defVal == null) ? DBNull.Value : defVal;
			}
		}
		/// <summary>
		/// データ取得(日付Nullable)
		/// </summary>
		/// <param name="field">カラム名</param>
		/// <returns>データ値</returns>
		public static DateTime? DateValNullable(this DataRow row, string field)
		{
			if (row.Table.Columns.Contains(field) == true)
			{
				if (Convert.IsDBNull(row[field]) == true)
				{
					return null;
				}
				else
				{
					DateTime? val = new DateTime?();
					val = (DateTime)row[field];
					return val;
				}
			}
			else
			{
				return null;
			}
		}
		/// <summary>
		/// データ取得(日付→文字列)
		/// </summary>
		/// <param name="field">カラム名</param>
		/// <param name="format">フォーマット</param>
		/// <returns>データ値</returns>
		public static string DateToStr(this DataRow row, string field, string format)
		{
			if (row.Table.Columns.Contains(field) == true)
			{
				if (Convert.IsDBNull(row[field]) == true)
				{
					return "";
				}
				else
				{
					DateTime val = (DateTime)row[field];
					return val.ToString(format);
				}
			}
			else
			{
				return "";
			}
		}
		#endregion
		#endregion
	}
}
