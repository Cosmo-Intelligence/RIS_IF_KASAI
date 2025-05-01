using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace ResDetailIF.Main
{
	/// <summary>
	/// デバック用フォーム
	/// </summary>
	public partial class TestFrm : Form
	{
		#region メンバー
		/// <summary>
		/// ファサード
		/// </summary>
		private AppFacade facade = new AppFacade();
		#endregion

		#region コンストラクタ
		/// <summary>
		/// コンストラクタ
		/// </summary>
		public TestFrm()
		{
			InitializeComponent();
		}
		#endregion

		#region イベント
		/// <summary>
		/// FormClosed
		/// </summary>
		/// <param name="sender">呼び出し元</param>
		/// <param name="e">パラメータ</param>
		private void TestFrm_FormClosed(object sender, FormClosedEventArgs e)
		{
			facade.Dispose();
		}
		/// <summary>
		/// 実行 Click
		/// </summary>
		/// <param name="sender">呼び出し元</param>
		/// <param name="e">パラメータ</param>
		private void button1_Click(object sender, EventArgs e)
		{
			facade.MainProc();
		}
		#endregion
	}
}
