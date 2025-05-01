using System;
using System.Configuration;
using System.Diagnostics;
using System.IO;
//
using ComLib;

namespace SlnCom
{
	/// <summary>
	/// app.Configアクセス クラス
	/// </summary>
	public abstract class ConfigBase
	{
		#region メンバ
		#endregion

		#region [private]メソッド
		#endregion

		#region [public]プロパティ
		/// <summary>
		/// app.configファイルのパス
		/// </summary>
		public static string AppConfigPath
		{
			get
			{
				System.Reflection.Assembly asm = System.Reflection.Assembly.GetExecutingAssembly();
				string configPath = Path.Combine(Path.GetDirectoryName(asm.Location), Process.GetCurrentProcess().ProcessName);
				configPath += ".exe.config";
				return configPath;
			}
		}
		/// <summary>
		/// DB接続文字列(RIS)
		/// </summary>
		public static String RISConnectStr
		{
			get
			{
				return ConfigUtil.StrVal("ConnectionStringRis", "");
			}
		}
		/// <summary>
		/// DB接続文字列(DWH)
		/// </summary>
		public static String DWHConnectStr
		{
			get
			{
				return ConfigUtil.StrVal("ConnectionStringDWH", "");
			}
		}
		/// <summary>
		/// DB接続 リトライ回数
		/// </summary>
		public static int DBConnectRetryCount
		{
			get
			{
				return ConfigUtil.IntVal("ConnectionRetryCount", 3);
			}
		}
		/// <summary>
		/// DB接続 リトライ間隔
		/// </summary>
		public static int DBConnectRetryInterval
		{
			get
			{
				return ConfigUtil.IntVal("ConnectionRetryInterval", 5000);
			}
		}
		/// <summary>
		/// log保存日数(APP)
		/// </summary>
		public static int LogKeepDays_APP
		{
			get
			{
				const int DEF_VAL = 30;

				int val = ConfigUtil.IntVal("LogKeepDays_APP", DEF_VAL);
				return (val >= 0) ? val : DEF_VAL;
			}
		}
		/// <summary>
		/// log保存日数(SQL)
		/// </summary>
		public static int LogKeepDays_SQL
		{
			get
			{
				const int DEF_VAL = 30;

				int val = ConfigUtil.IntVal("LogKeepDays_SQL", DEF_VAL);
				return (val >= 0) ? val : DEF_VAL;
			}
		}
		#endregion
	}
}