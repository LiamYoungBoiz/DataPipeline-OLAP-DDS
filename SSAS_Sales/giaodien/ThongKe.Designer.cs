namespace giaodien
{
    partial class ThongKe
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
            adomdCommand1 = new Microsoft.AnalysisServices.AdomdClient.AdomdCommand();
            btnSanPhamBanCao = new Button();
            btnDoanhThuQuy = new Button();
            btnDoanhThuKhuVuc = new Button();
            btnSanPhamTonKho = new Button();
            btnSoLuongDonCao = new Button();
            SuspendLayout();
            // 
            // adomdCommand1
            // 
            adomdCommand1.ActivityID = new Guid("00000000-0000-0000-0000-000000000000");
            adomdCommand1.CommandStream = null;
            adomdCommand1.CommandText = null;
            adomdCommand1.CommandTimeout = 0;
            adomdCommand1.CommandType = System.Data.CommandType.Text;
            adomdCommand1.Connection = null;
            adomdCommand1.RequestPriority = Microsoft.AnalysisServices.AdomdClient.RequestPriorities.Normal;
            // 
            // btnSanPhamBanCao
            // 
            btnSanPhamBanCao.Location = new Point(454, 38);
            btnSanPhamBanCao.Name = "btnSanPhamBanCao";
            btnSanPhamBanCao.Size = new Size(252, 44);
            btnSanPhamBanCao.TabIndex = 0;
            btnSanPhamBanCao.Text = "Sản phẩm có doanh số bán cao nhất";
            btnSanPhamBanCao.UseVisualStyleBackColor = true;
            btnSanPhamBanCao.Click += btnSanPhamBanCao_Click;
            // 
            // btnDoanhThuQuy
            // 
            btnDoanhThuQuy.Location = new Point(454, 163);
            btnDoanhThuQuy.Name = "btnDoanhThuQuy";
            btnDoanhThuQuy.Size = new Size(252, 42);
            btnDoanhThuQuy.TabIndex = 1;
            btnDoanhThuQuy.Text = "Doanh thu theo quý";
            btnDoanhThuQuy.UseVisualStyleBackColor = true;
            btnDoanhThuQuy.Click += btnDoanhThuQuy_Click;
            // 
            // btnDoanhThuKhuVuc
            // 
            btnDoanhThuKhuVuc.Location = new Point(454, 229);
            btnDoanhThuKhuVuc.Name = "btnDoanhThuKhuVuc";
            btnDoanhThuKhuVuc.Size = new Size(262, 37);
            btnDoanhThuKhuVuc.TabIndex = 2;
            btnDoanhThuKhuVuc.Text = "Doanh thu theo Khu vực";
            btnDoanhThuKhuVuc.UseVisualStyleBackColor = true;
            btnDoanhThuKhuVuc.Click += btnDoanhThuKhuVuc_Click;
            // 
            // btnSanPhamTonKho
            // 
            btnSanPhamTonKho.Location = new Point(454, 292);
            btnSanPhamTonKho.Name = "btnSanPhamTonKho";
            btnSanPhamTonKho.Size = new Size(262, 39);
            btnSanPhamTonKho.TabIndex = 3;
            btnSanPhamTonKho.Text = "Số lượng sản phẩm tồn kho ";
            btnSanPhamTonKho.UseVisualStyleBackColor = true;
            btnSanPhamTonKho.Click += btnSanPhamTonKho_Click;
            // 
            // btnSoLuongDonCao
            // 
            btnSoLuongDonCao.Location = new Point(454, 104);
            btnSoLuongDonCao.Name = "btnSoLuongDonCao";
            btnSoLuongDonCao.Size = new Size(252, 39);
            btnSoLuongDonCao.TabIndex = 4;
            btnSoLuongDonCao.Text = "Thành phố có số lượng đơn cao nhất";
            btnSoLuongDonCao.UseVisualStyleBackColor = true;
            btnSoLuongDonCao.Click += btnSoLuongDonCao_Click;
            // 
            // ThongKe
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(800, 450);
            Controls.Add(btnSoLuongDonCao);
            Controls.Add(btnSanPhamTonKho);
            Controls.Add(btnDoanhThuKhuVuc);
            Controls.Add(btnDoanhThuQuy);
            Controls.Add(btnSanPhamBanCao);
            Name = "ThongKe";
            Text = "ThongKe";
            ResumeLayout(false);
        }

        #endregion

        private Microsoft.AnalysisServices.AdomdClient.AdomdCommand adomdCommand1;
        private Button btnSanPhamBanCao;
        private Button btnDoanhThuQuy;
        private Button btnDoanhThuKhuVuc;
        private Button btnSanPhamTonKho;
        private Button btnSoLuongDonCao;
    }
}