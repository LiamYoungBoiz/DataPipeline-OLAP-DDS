
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO.Packaging;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.SqlServer.Dts.Runtime;
using Application = Microsoft.SqlServer.Dts.Runtime.Application;
using Package = Microsoft.SqlServer.Dts.Runtime.Package;
namespace giaodien
{
    public class ConnectSSIS
    {
        public string ax()
        {
            string dtexecPath = @"C:\Program Files\Microsoft SQL Server\150\DTS\Binn\DTExec.exe";
            string packagePath = @"E:\ETL_DATA\Integration Services Project1\Package.dtsx";

            try
           {
                Process process = new Process();
                process.StartInfo.FileName = dtexecPath;
                process.StartInfo.Arguments = $"/F \"{packagePath}\""; // /F chỉ định file
                process.StartInfo.UseShellExecute = false;
                process.StartInfo.RedirectStandardOutput = true;
                process.StartInfo.RedirectStandardError = true;

                process.Start();

                // Lấy output và error
                string output = process.StandardOutput.ReadToEnd();
                string error = process.StandardError.ReadToEnd();

                // Kiểm tra kết quả thực thi
                if (process.ExitCode == 0)
                {
                    return "Gói SSIS thực thi thành công:\n" + output;
                }
                else
                {
                    return "Gói SSIS gặp lỗi:\n" + error;
                }
            }
            catch (Exception ex)
            {
                return $"Lỗi ngoại lệ: {ex.Message}";
            }
        }
    }
}
