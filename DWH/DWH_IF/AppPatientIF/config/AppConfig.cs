using System;
using System.Collections.Generic;
using System.Configuration;
using System.Diagnostics;
using System.IO;
//
using ComLib;
using SlnCom;

namespace ResDetailIF.config
{
	/// <summary>
	/// app.Config�A�N�Z�X �N���X
	/// </summary>
	public class AppConfig : ConfigBase
	{
		/// <summary>
		/// �R���X�g���N�^
		/// </summary>
		private AppConfig()
		{
			//private �R���X�g���N�^
		}

		#region �����o
		#endregion

		#region [private]���\�b�h
		#endregion

		#region [public]�v���p�e�B
		/// <summary>
		/// ���������Ԋu
		/// </summary>
		public static int CycleInterval
		{
			get
			{
				const int DEF_VAL = 10000;

				int val = ConfigUtil.IntVal("CycleInterval", DEF_VAL);
				return (val >= 0) ? val : DEF_VAL;
			}
		}
		#endregion
	}
}