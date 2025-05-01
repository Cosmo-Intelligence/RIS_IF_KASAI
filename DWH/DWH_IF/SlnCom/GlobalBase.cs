using SlnCom;
using ComLib.database;
using ComLib.log;

namespace SlnCom
{
	/// <summary>
	/// アプリケーション共通オブジェクト管理 クラス
	/// </summary>
	public abstract class GlobalBase
	{
		#region メンバー
		/// <summary>
		/// 動作Log
		/// </summary>
		private static ILogger vMapLogger = new Logger(LOG_APPENDER.AP, ConfigBase.LogKeepDays_APP);
		/// <summary>
		/// SqlLog
		/// </summary>
		private static ILogger vMsqlLogger = new Logger(LOG_APPENDER.SQL, ConfigBase.LogKeepDays_SQL);
		/// <summary>
		/// DB接続(RIS)
		/// </summary>
		private static OraCom vMrisDB = null;
		/// <summary>
		/// DB接続(DWH)
		/// </summary>
		private static OraCom vMdwhDB = null;
		#endregion

		#region プロパティ
		/// <summary>
		/// バージョン
		/// </summary>
		public static string SystemVersion
		{
			get;
			set;
		}
		/// <summary>
		/// 動作Log
		/// </summary>
		public static ILogger ApLogger
		{
			get
			{
				return vMapLogger;
			}
		}
		/// <summary>
		/// SqlLog
		/// </summary>
		public static ILogger SqlLogger
		{
			get
			{
				return vMsqlLogger;
			}
		}

		/// <summary>
		/// DB接続(RIS)
		/// </summary>
		public static OraCom RISDB
		{
			get
			{
				if (vMrisDB == null)
				{
					vMrisDB = new OraCom(ConfigBase.RISConnectStr, vMapLogger, vMsqlLogger,
																	ConfigBase.DBConnectRetryCount, ConfigBase.DBConnectRetryInterval);
				}
				return vMrisDB;
			}
		}
		/// <summary>
		/// DB接続(DWH)
		/// </summary>
		public static OraCom DWHDB
		{
			get
			{
				if (vMdwhDB == null)
				{
					vMdwhDB = new OraCom(ConfigBase.DWHConnectStr, vMapLogger, vMsqlLogger,
																	ConfigBase.DBConnectRetryCount, ConfigBase.DBConnectRetryInterval);
				}
				return vMdwhDB;
			}
		}
		#endregion

	}
}
