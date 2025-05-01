using System;
using System.Configuration;
using System.Diagnostics;
using System.IO;
//
using ComLib;

namespace SlnCom
{
	/// <summary>
	/// app.Config�A�N�Z�X �N���X
	/// </summary>
	public abstract class ConfigBase
	{
		#region �����o
		#endregion

		#region [private]���\�b�h
		#endregion

		#region [public]�v���p�e�B
		/// <summary>
		/// app.config�t�@�C���̃p�X
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
		/// DB�ڑ�������(RIS)
		/// </summary>
		public static String RISConnectStr
		{
			get
			{
				return ConfigUtil.StrVal("ConnectionStringRis", "");
			}
		}
		/// <summary>
		/// DB�ڑ�������(DWH)
		/// </summary>
		public static String DWHConnectStr
		{
			get
			{
				return ConfigUtil.StrVal("ConnectionStringDWH", "");
			}
		}
		/// <summary>
		/// DB�ڑ� ���g���C��
		/// </summary>
		public static int DBConnectRetryCount
		{
			get
			{
				return ConfigUtil.IntVal("ConnectionRetryCount", 3);
			}
		}
		/// <summary>
		/// DB�ڑ� ���g���C�Ԋu
		/// </summary>
		public static int DBConnectRetryInterval
		{
			get
			{
				return ConfigUtil.IntVal("ConnectionRetryInterval", 5000);
			}
		}
		/// <summary>
		/// log�ۑ�����(APP)
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
		/// log�ۑ�����(SQL)
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