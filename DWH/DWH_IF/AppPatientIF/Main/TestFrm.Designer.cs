﻿namespace ResDetailIF.Main
{
	partial class TestFrm
	{
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.IContainer components = null;

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		/// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
		protected override void Dispose(bool disposing)
		{
			if (disposing && (components != null))
			{
				components.Dispose();
			}
			base.Dispose(disposing);
		}

		#region Windows Form Designer generated code

		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.button1 = new System.Windows.Forms.Button();
			this.SuspendLayout();
			// 
			// button1
			// 
			this.button1.Location = new System.Drawing.Point(39, 20);
			this.button1.Name = "button1";
			this.button1.Size = new System.Drawing.Size(75, 23);
			this.button1.TabIndex = 0;
			this.button1.Text = "実行";
			this.button1.UseVisualStyleBackColor = true;
			this.button1.Click += new System.EventHandler(this.button1_Click);
			// 
			// TestFrm
			// 
			this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.ClientSize = new System.Drawing.Size(292, 273);
			this.Controls.Add(this.button1);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
			this.Name = "TestFrm";
			this.ShowIcon = false;
			this.Text = "DWH 来院情報";
			this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.TestFrm_FormClosed);
			this.ResumeLayout(false);

		}

		#endregion

		private System.Windows.Forms.Button button1;
	}
}