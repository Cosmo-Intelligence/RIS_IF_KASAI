namespace ResDetailIF.Main
{
	partial class srvResDetailIF
    {
        /// <summary> 
        /// 必要なデザイナー変数です。
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// 使用中のリソースをすべてクリーンアップします。
        /// </summary>
        /// <param name="disposing">マネージ リソースが破棄される場合 true、破棄されない場合は false です。</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region コンポーネント デザイナーで生成されたコード

        /// <summary> 
        /// デザイナー サポートに必要なメソッドです。このメソッドの内容を 
        /// コード エディターで変更しないでください。
        /// </summary>
        private void InitializeComponent()
        {
			this.timerCycle = new System.Timers.Timer();
			((System.ComponentModel.ISupportInitialize)(this.timerCycle)).BeginInit();
			// 
			// timerCycle
			// 
			this.timerCycle.Enabled = true;
			this.timerCycle.Interval = 5000D;
			this.timerCycle.Elapsed += new System.Timers.ElapsedEventHandler(this.timerCycle_Elapsed);
			// 
			// srvResDetailIF
			// 
			this.ServiceName = "srvResDetailIF";
			((System.ComponentModel.ISupportInitialize)(this.timerCycle)).EndInit();

        }

        #endregion

		private System.Timers.Timer timerCycle;
    }
}
