using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Drawing;
using System.Drawing.Imaging;
using System.Drawing.Drawing2D;

public partial class CaptchaImageGen : System.Web.UI.Page
{
    private Random random = new Random();

    private void Page_Load(object sender, System.EventArgs e)
    {
        // Create a CAPTCHA image using the text stored in the Session object.
        string random = GenerateRandomCode();
        Session["CaptchaImageText"] = random;
        CaptchaImage ci = new CaptchaImage(random, 200, 50, "Century Schoolbook");

        // Change the response headers to output a JPEG image.
        this.Response.Clear();
        this.Response.ContentType = "image/jpeg";

        // Write the image to the response stream in JPEG format.
        ci.Image.Save(this.Response.OutputStream, ImageFormat.Jpeg);

        // Dispose of the CAPTCHA image object.
        ci.Dispose();
    }

    private string GenerateRandomCode()
    {
        string s = "";
        for (int i = 0; i < 6; i++)
            s = String.Concat(s, this.random.Next(10).ToString());
        return s;
    }

}
