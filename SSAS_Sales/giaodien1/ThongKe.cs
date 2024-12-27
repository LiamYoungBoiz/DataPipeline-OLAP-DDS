using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Windows.Forms.DataVisualization.Charting;
using Microsoft.AnalysisServices.AdomdClient;

namespace giaodien1
{
    public partial class ThongKe : Form
    {
        private string connectionString = "Data Source=DESKTOP-67M8U5J\\MSSQLSERVER1;"; // Đổi thành tên server SSAS của bạn
        public ThongKe()
        {

            InitializeComponent();
        }
        private DataTable ExecuteMDXQuery(string mdxQuery)
        {
            DataTable dataTable = new DataTable();
            try
            {
                using (AdomdConnection connection = new AdomdConnection(connectionString))
                {
                    connection.Open();
                    AdomdCommand command = new AdomdCommand(mdxQuery, connection);
                    AdomdDataReader reader = command.ExecuteReader();

                    // Thêm cột vào DataTable
                    for (int i = 0; i < reader.FieldCount; i++)
                    {
                        dataTable.Columns.Add(reader.GetName(i));
                    }

                    // Đọc dữ liệu từ SSAS
                    while (reader.Read())
                    {
                        DataRow row = dataTable.NewRow();
                        for (int i = 0; i < reader.FieldCount; i++)
                        {
                            row[i] = reader[i];
                        }
                        dataTable.Rows.Add(row);
                    }
                    reader.Close();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Lỗi truy vấn MDX: {ex.Message}");
            }

            return dataTable;
        }
        private void DisplayDataOnChart(string mdxQuery, string seriesName)
        {
            chart1.Series.Clear();
            chart1.Titles.Clear();

            DataTable data = ExecuteMDXQuery(mdxQuery);

            if (data.Rows.Count > 0)
            {
                Series series = new Series(seriesName)
                {
                    ChartType = SeriesChartType.Column
                };

                foreach (DataRow row in data.Rows)
                {
                    string xValue = row[0] != DBNull.Value ? row[0].ToString() : "N/A";
                    double yValue = row[1] != DBNull.Value ? Convert.ToDouble(row[1]) : 0;
                    series.Points.AddXY(xValue, yValue);
                }

                chart1.Series.Add(series);
                chart1.Titles.Add(seriesName);
            }
            else
            {
                MessageBox.Show("Không có dữ liệu trả về từ truy vấn MDX.");
            }
        }
        private void button1_Click(object sender, EventArgs e)
        {
            string mdxQuery = @"
               SELECT 
                    {[Measures].[Total Sales], [Measures].[Sales Fact Count]} ON COLUMNS,
                    FILTER(
                        EXCEPT(
                            [Time Dimension].[Year].Members, 
                            {[Time Dimension].[Year].[All]}
                        ),
                        [Time Dimension].[Year].CurrentMember.Name <> ""Unknown""
                    ) ON ROWS
                FROM [DDS Fashion Shop]";
            DisplayDataOnChart(mdxQuery, "Doanh thu và Số lượng đơn hàng theo năm");
        }

        private void button2_Click(object sender, EventArgs e)
        {
            string mdxQuery = @"
             SELECT
    {[Measures].[Total Sales]} ON COLUMNS,
    FILTER(
        EXCEPT(
            [Geography Dimension].[Country].Members, 
            {[Geography Dimension].[Country].[All]}
        ),
        [Geography Dimension].[Country].CurrentMember.Name <> ""Unknown""
    ) ON ROWS
FROM [DDS Fashion Shop]
";
            DisplayDataOnChart(mdxQuery, "Doanh thu theo từng đất nước");

        }

        private void button3_Click(object sender, EventArgs e)
        {
            string mdxQuery = @"
             SELECT 
    {[Measures].[Total Sales]} ON COLUMNS,
    FILTER(
        EXCEPT(
            [Product Dimension].[Product Line].Members,
            {[Product Dimension].[Product Line].[All]}
        ),
        [Product Dimension].[Product Line].CurrentMember.Name <> ""Unknown""
    ) ON ROWS
FROM [DDS Fashion Shop]";
            DisplayDataOnChart(mdxQuery, "Doanh thu theo dòng sản phẩm");
        }

        private void button4_Click(object sender, EventArgs e)
        {
            string mdxQuery = @"
               SELECT 
                {[Measures].[Total Sales]} ON COLUMNS,
                FILTER(
                    EXCEPT(
                        [Time Dimension].[Quarter].Members, 
                        {[Time Dimension].[Quarter].[All]}
                    ),
                    [Time Dimension].[Quarter].CurrentMember.Name <> ""Unknown""
                ) ON ROWS
            FROM [DDS Fashion Shop]";
            DisplayDataOnChart(mdxQuery, "Doanh thu theo từng tháng");
        }

        private void button5_Click(object sender, EventArgs e)
        {
            string mdxQuery = @"
               SELECT 
                TOPCOUNT(
                    EXCEPT([Geography Dimension].[City].Members, {[Geography Dimension].[City].[All]}), 
                    5, 
                    [Measures].[Total Sales]
                ) ON ROWS,
                {[Measures].[Total Sales]} ON COLUMNS
            FROM [DDS Fashion Shop]";
            DisplayDataOnChart(mdxQuery, "Top 5 thành phố có doanh thu cao nhất");
        }

        private void chart1_Click(object sender, EventArgs e)
        {

        }

        private void ThongKe_Load(object sender, EventArgs e)
        {

        }
    }
}
