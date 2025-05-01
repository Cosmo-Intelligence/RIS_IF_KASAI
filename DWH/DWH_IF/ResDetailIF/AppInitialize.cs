using System;
using System.IO;
using System.Diagnostics;
//
using ComLib;
using ComLib.log;
using ResDetailIF.config;

namespace ResDetailIF
{
	/// <summary>
	/// �A�v���P�[�V�������������� �N���X
	/// </summary>
	public static class AppInitialize
	{
		#region [public]���\�b�h
		/// <summary>
		/// �A�v���P�[�V�������������s
		/// </summary>
		/// <returns>�������� T:���� F:���s</returns>
		public static bool Execute()
		{
			//config�t�@�C�����݃`�F�b�N
			if (File.Exists(AppConfig.AppConfigPath) == false)
			{
				return false;
			}
			//Log4net�ݒ�Ǎ�
			log4net.Config.XmlConfigurator.Configure(new FileInfo(AppConfig.AppConfigPath));

			//Config��`�`�F�b�N(DB)
			if (ConnectionConfig() == false)
			{
				return false;
			}

			//IP�A�h���X�擾
			NetWork.Initailize();
			AppGlobal.ApLogger.Info("�z�X�g��[{0}] IP�A�h���X[{1}]", NetWork.HostName, NetWork.IpAddress);

			/*
			//db�ڑ��`�F�b�N
			if (this.CheckOraConnection() == false)
			{
				return false;
			}
			*/
			//����I��
			return true;
		}

		#endregion

		#region [private]���\�b�h
		/// <summary>
		/// DB�ڑ��ݒ�̓ǂݍ���
		/// </summary>
		/// <returns>�������� T:���� F:���s</returns>
		private static bool ConnectionConfig()
		{
			if (AppConfig.RISConnectStr == "")
			{
				AppGlobal.ApLogger.Warn("RIS DB�ڑ������񂪐ݒ肳��Ă��܂���");
				return false;
			}
			AppGlobal.ApLogger.Info("RIS DB�ڑ�������:" + AppConfig.RISConnectStr);

			if (AppConfig.DWHConnectStr == "")
			{
				AppGlobal.ApLogger.Warn("DWH DB�ڑ������񂪐ݒ肳��Ă��܂���");
				return false;
			}
			AppGlobal.ApLogger.Info("DWH DB�ڑ�������:" + AppConfig.DWHConnectStr);
			return true;
		}
		#endregion
	}
}
