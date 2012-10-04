using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Drawing;
using System.Configuration;

/// <summary>
/// Summary description for ImageTools
/// </summary>
public class ImageTools
{
    public static void ResizeImage(string filename, int width, int height, string directory, bool square)
    {
        string filePath = HttpContext.Current.Server.MapPath(ConfigurationManager.AppSettings["postimagesdir"]);
        Image newImage = Image.FromFile(filePath + filename);
        double imgRatio = (double)newImage.Width / (double)newImage.Height;
        double targetRatio = (double)width / (double)height;

        int newWidth = 0;
        int newHeight = 0;

        if (imgRatio > targetRatio)
        {
            //image wider aspect than target
            newWidth = width;
            newHeight = Convert.ToInt32(Math.Floor((width / (double)newImage.Width) * (double)newImage.Height));
        }
        else if (targetRatio > imgRatio)
        {
            //image taller aspect than target
            newWidth = Convert.ToInt32(Math.Floor((height / (double)newImage.Height) * (double)newImage.Width));
            newHeight = height;
        }
        else
        {
            newWidth = width;
            newHeight = height;
        }

        Image thumbImage = newImage.GetThumbnailImage(newWidth, newHeight, null, IntPtr.Zero);

        Graphics graphic = Graphics.FromImage(thumbImage);
        graphic.CompositingQuality = System.Drawing.Drawing2D.CompositingQuality.HighQuality;
        graphic.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBicubic;
        graphic.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;

        Rectangle thumbRect = new Rectangle(0, 0, newWidth, newHeight);
        graphic.DrawImage(newImage, thumbRect);

        thumbImage.Save(filePath + directory + "/" + filename);
        newImage.Dispose();
        thumbImage.Dispose();
    }

    protected static bool ThumbnailCallback() { return false; }
}
