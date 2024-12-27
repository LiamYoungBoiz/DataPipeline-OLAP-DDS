namespace giaodien1
{
    partial class TruyVanMDX
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
            this.txtTruyVanMDX = new System.Windows.Forms.RichTextBox();
            this.dataGridView1 = new System.Windows.Forms.DataGridView();
            this.btnThucHien = new System.Windows.Forms.Button();
            this.btnXuat = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).BeginInit();
            this.SuspendLayout();
            // 
            // txtTruyVanMDX
            // 
            this.txtTruyVanMDX.Location = new System.Drawing.Point(532, 12);
            this.txtTruyVanMDX.Name = "txtTruyVanMDX";
            this.txtTruyVanMDX.Size = new System.Drawing.Size(238, 246);
            this.txtTruyVanMDX.TabIndex = 0;
            this.txtTruyVanMDX.Text = "";
            this.txtTruyVanMDX.TextChanged += new System.EventHandler(this.txtTruyVanMDX_TextChanged);
            // 
            // dataGridView1
            // 
            this.dataGridView1.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridView1.Location = new System.Drawing.Point(3, 12);
            this.dataGridView1.Name = "dataGridView1";
            this.dataGridView1.RowHeadersWidth = 51;
            this.dataGridView1.RowTemplate.Height = 24;
            this.dataGridView1.Size = new System.Drawing.Size(508, 426);
            this.dataGridView1.TabIndex = 1;
            // 
            // btnThucHien
            // 
            this.btnThucHien.Location = new System.Drawing.Point(532, 282);
            this.btnThucHien.Name = "btnThucHien";
            this.btnThucHien.Size = new System.Drawing.Size(98, 60);
            this.btnThucHien.TabIndex = 2;
            this.btnThucHien.Text = "thực hiện";
            this.btnThucHien.UseVisualStyleBackColor = true;
            this.btnThucHien.Click += new System.EventHandler(this.btnThucHien_Click);
            // 
            // btnXuat
            // 
            this.btnXuat.Location = new System.Drawing.Point(672, 282);
            this.btnXuat.Name = "btnXuat";
            this.btnXuat.Size = new System.Drawing.Size(98, 60);
            this.btnXuat.TabIndex = 3;
            this.btnXuat.Text = "xuất pdf";
            this.btnXuat.UseVisualStyleBackColor = true;
            this.btnXuat.Click += new System.EventHandler(this.btnXuat_Click);
            // 
            // TruyVanMDX
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(791, 450);
            this.Controls.Add(this.btnXuat);
            this.Controls.Add(this.btnThucHien);
            this.Controls.Add(this.dataGridView1);
            this.Controls.Add(this.txtTruyVanMDX);
            this.Name = "TruyVanMDX";
            this.Text = "TruyVanMDX";
            this.Load += new System.EventHandler(this.TruyVanMDX_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.RichTextBox txtTruyVanMDX;
        private System.Windows.Forms.DataGridView dataGridView1;
        private System.Windows.Forms.Button btnThucHien;
        private System.Windows.Forms.Button btnXuat;
    }
}