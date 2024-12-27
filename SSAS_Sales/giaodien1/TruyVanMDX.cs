using iTextSharp.text;
using iTextSharp.text.pdf;
using Microsoft.AnalysisServices.AdomdClient;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Xml.Linq;

namespace giaodien1
{
    public partial class TruyVanMDX : Form
    {
        public TruyVanMDX()
        {
            InitializeComponent();
        }

        private void btnThucHien_Click(object sender, EventArgs e)
        {
            // Lấy câu truy vấn MDX từ TextBox
            string mdxQuery = txtTruyVanMDX.Text.Trim();

            if (string.IsNullOrEmpty(mdxQuery))
            {
                MessageBox.Show("Vui lòng nhập câu truy vấn MDX.");
                return;
            }

            // Kết nối và thực thi truy vấn MDX
            try
            {
                string serverName = "DESKTOP-67M8U5J\\MSSQLSERVER1";  // Địa chỉ máy chủ SSAS
                using (AdomdConnection connection = new AdomdConnection($"Data Source={serverName};"))
                {
                    connection.Open();

                    // Thiết lập AdomdCommand để thực thi truy vấn MDX
                    AdomdCommand command = new AdomdCommand(mdxQuery, connection);

                    // Thực thi truy vấn và lấy dữ liệu
                    AdomdDataReader reader = command.ExecuteReader();

                    // Tạo một DataTable để chứa dữ liệu
                    DataTable dataTable = new DataTable();

                    // Lấy tên các cột từ DataReader và thêm vào DataTable
                    for (int i = 0; i < reader.FieldCount; i++)
                    {
                        dataTable.Columns.Add(reader.GetName(i));
                    }

                    // Đọc dữ liệu từ DataReader và thêm vào DataTable
                    while (reader.Read())
                    {
                        DataRow row = dataTable.NewRow();
                        for (int i = 0; i < reader.FieldCount; i++)
                        {
                            row[i] = reader[i];
                        }
                        dataTable.Rows.Add(row);
                    }

                    // Đưa dữ liệu vào DataGridView
                    dataGridView1.DataSource = dataTable;

                    // Đóng kết nối
                    reader.Close();
                    connection.Close();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Lỗi thực thi truy vấn MDX: {ex.Message}");
            }
        }

        private void btnXuat_Click(object sender, EventArgs e)
        {
            try
            {
                // Đặt đường dẫn lưu file
                string folderPath = @"E:\10000_XayDungKhoDuLieuPhanTichKinhDoanhCuaHangBanQuanAo\SSAS_Sales\luufile";
                string filePath = Path.Combine(folderPath, "output.pdf");

                // Kiểm tra xem thư mục có tồn tại không, nếu không thì tạo mới
                if (!Directory.Exists(folderPath))
                {
                    Directory.CreateDirectory(folderPath);
                }

                // Tạo một đối tượng Document PDF
                Document doc = new Document();

                // Tạo đối tượng PdfWriter để xuất PDF ra file
                PdfWriter.GetInstance(doc, new FileStream(filePath, FileMode.Create));

                // Mở Document để thêm nội dung
                doc.Open();

                // Tạo bảng để hiển thị dữ liệu từ DataGridView
                PdfPTable pdfTable = new PdfPTable(dataGridView1.ColumnCount);

                // Thêm tên các cột vào PDF
                for (int i = 0; i < dataGridView1.ColumnCount; i++)
                {
                    pdfTable.AddCell(dataGridView1.Columns[i].HeaderText);
                }

                // Thêm dữ liệu từ DataGridView vào PDF
                foreach (DataGridViewRow row in dataGridView1.Rows)
                {
                    foreach (DataGridViewCell cell in row.Cells)
                    {
                        if (cell.Value != null)
                            pdfTable.AddCell(cell.Value.ToString());
                        else
                            pdfTable.AddCell(""); // Nếu ô trống, thêm giá trị trống
                    }
                }

                // Thêm bảng vào document PDF
                doc.Add(pdfTable);

                // Đóng document để lưu file PDF
                doc.Close();

                // Thông báo thành công
                MessageBox.Show("Xuất dữ liệu ra PDF thành công!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Lỗi khi xuất dữ liệu ra PDF: {ex.Message}", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void txtTruyVanMDX_TextChanged(object sender, EventArgs e)
        {

        }

        private void TruyVanMDX_Load(object sender, EventArgs e)
        {

        }
    }
}
