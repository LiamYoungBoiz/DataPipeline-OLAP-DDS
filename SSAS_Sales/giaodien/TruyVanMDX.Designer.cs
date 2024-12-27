namespace giaodien
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
            dataGridView1 = new DataGridView();
            txtTruyVanMDX = new RichTextBox();
            btnThucHien = new Button();
            btnXuat = new Button();
            ((System.ComponentModel.ISupportInitialize)dataGridView1).BeginInit();
            SuspendLayout();
            // 
            // dataGridView1
            // 
            dataGridView1.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridView1.Location = new Point(1, -1);
            dataGridView1.Name = "dataGridView1";
            dataGridView1.RowHeadersWidth = 51;
            dataGridView1.Size = new Size(464, 447);
            dataGridView1.TabIndex = 0;
            dataGridView1.CellContentClick += dataGridView1_CellContentClick;
            // 
            // txtTruyVanMDX
            // 
            txtTruyVanMDX.Location = new Point(471, -1);
            txtTruyVanMDX.Name = "txtTruyVanMDX";
            txtTruyVanMDX.Size = new Size(330, 291);
            txtTruyVanMDX.TabIndex = 1;
            txtTruyVanMDX.Text = "";
            txtTruyVanMDX.TextChanged += this.txtTruyVanMDX_TextChanged;
            // 
            // btnThucHien
            // 
            btnThucHien.Location = new Point(471, 296);
            btnThucHien.Name = "btnThucHien";
            btnThucHien.Size = new Size(87, 46);
            btnThucHien.TabIndex = 2;
            btnThucHien.Text = "Thực hiện";
            btnThucHien.UseVisualStyleBackColor = true;
            btnThucHien.Click += btnThucHien_Click;
            // 
            // btnXuat
            // 
            btnXuat.Location = new Point(685, 296);
            btnXuat.Name = "btnXuat";
            btnXuat.Size = new Size(94, 46);
            btnXuat.TabIndex = 4;
            btnXuat.Text = "Xuất";
            btnXuat.UseVisualStyleBackColor = true;
            btnXuat.Click += btnXuat_Click;
            // 
            // TruyVanMDX
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(800, 450);
            Controls.Add(btnXuat);
            Controls.Add(btnThucHien);
            Controls.Add(txtTruyVanMDX);
            Controls.Add(dataGridView1);
            Name = "TruyVanMDX";
            Text = "TruyVanMDX";
            ((System.ComponentModel.ISupportInitialize)dataGridView1).EndInit();
            ResumeLayout(false);
        }

        #endregion

        private DataGridView dataGridView1;
        private RichTextBox txtTruyVanMDX;
        private Button btnThucHien;
        private Button btnXuat;
    }
}