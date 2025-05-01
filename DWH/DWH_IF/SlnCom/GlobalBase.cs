using SlnCom;
using ComLib.database;
using ComLib.log;

namespace SlnCom
{
	/// <summary>
	/// �A�v���P�[�V�������ʃI�u�W�F�N�g�Ǘ� �N���X
	/// </summary>
	public abstract class GlobalBase
	{
		#region �����o�[
		/// <summary>
		/// ����Log
		/// </summary>
		private static ILogger vMapLogger = new Logger(LOG_APPENDER.AP, ConfigBase.LogKeepDays_APP);
		/// <summary>
		/// SqlLog
		/// </summary>
		private static ILogger vMsqlLogger = new Logger(LOG_APPENDER.SQL, ConfigBase.LogKeepDays_SQL);
		/// <summary>
		/// DB�ڑ�(RIS)
		/// </summary>
		private static OraCom vMrisDB = null;
		/// <summary>
		/// DB�ڑ�(DWH)
		/// </summary>
		private static OraCom vMdwhDB = null;
		#endregion

		#region �v���p�e�B
		/// <summary>
		/// �o�[�W����
		/// </summary>
		public static string SystemVersion
		{
			get;
			set;
		}
		/// <summary>
		/// ����Log
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
		/// DB�ڑ�(RIS)
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
		/// DB�ڑ�(DWH)
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
