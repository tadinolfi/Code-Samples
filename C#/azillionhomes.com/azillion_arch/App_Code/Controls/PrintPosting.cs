using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Xml.Linq;
using System.Configuration;

namespace AZHControls
{
    public class PrintPosting : CompositeControl
    {
        public int FormEntryID
        {
            get
            {
                if (ViewState["FormEntryID"] != null)
                {
                    return (int)ViewState["FormEntryID"];
                }
                else
                {
                    return 0;
                }
            }
            set { ViewState["FormEntryID"] = value; }
        }

        private DataClassesDataContext __Context;
        public DataClassesDataContext Context
        {
            get
            {
                if (__Context == null)
                    __Context = new DataClassesDataContext();
                return __Context;
            }
        }

        protected override System.Web.UI.HtmlTextWriterTag TagKey
        {
            get
            {
                return System.Web.UI.HtmlTextWriterTag.Div;
            }
        }

        private Literal litInnerContent;

        protected override void CreateChildControls()
        {
            litInnerContent = new Literal { ID = "litInnerContent" };
            Controls.Add(litInnerContent);
        }

        public override void  RenderControl(System.Web.UI.HtmlTextWriter writer)
        {

            if (FormEntryID == 0)
                throw new ArgumentException("FormEntryID cannot be zero.", "FormEntryID");

            FormEntry currentEntry = Context.FormEntries.Single(n => n.FormEntryID == FormEntryID);
            Form currentForm = Context.Forms.Single(n => n.FormID == currentEntry.FormID);
            XDocument formXml = XDocument.Parse(currentEntry.Entry);
            XElement firstPage = formXml.Elements("formentry").Elements("formsection").Where(n => n.Attributes("firstpage").First().Value == "True").First();

            //Header
            litInnerContent.Text += "<div class=\"header\">";
            litInnerContent.Text += "<img src=\"images/interface/logo-print.gif\" alt=\"AZH Logo\" />";
            litInnerContent.Text += "<div class=\"details\">";
            litInnerContent.Text += "<strong class=\"azhid\">AZH# " + currentEntry.AZHID + "</strong>";
            litInnerContent.Text += "<strong class=\"type\">" + currentEntry.Form.Name + "</strong>";
            litInnerContent.Text += "</div>";
            litInnerContent.Text += "<address>";
            litInnerContent.Text += "<span class=\"street\">" + currentEntry.StreetNumber + " " + currentEntry.StreetName + "</span>\r\n";
            litInnerContent.Text += "<span class=\"location\">" + currentEntry.City + ", " + currentEntry.State.Abbreviation + " " + currentEntry.ZipCode + "</span>";
            litInnerContent.Text += "</address>";

            string headerText = "";

            if (currentEntry.ListingType.HasPrice)
            {
                headerText += FormatPrice(currentEntry.Price);
                if (currentEntry.ListingType.MonthlyPrice)
                    headerText += "/month";
            }

            if (currentEntry.ListingType.HasDate)
            {
                if(currentEntry.ListingType.HasPrice)
                    headerText += "</h2><h2 class=\"price dates\"><br />";
                if (currentEntry.ListingTypeID == 3)
                {
                    string dateList = "";
                    foreach (OpenHouseDate ohDate in currentEntry.OpenHouseDates)
                    {
                        if (ohDate.EventDate > DateTime.Now)
                        {
                            dateList += ohDate.EventDate.ToShortDateString() + ", ";
                        }
                    }
                    headerText += dateList.Substring(0, dateList.Length - 2);
                    headerText += " at ";
                }
                else
                {
                    headerText += currentEntry.EventStart.Value.ToShortDateString();
                    headerText += ", ";
                }

                headerText += currentEntry.EventStart.Value.ToShortTimeString() + "-" + currentEntry.Expires.Value.ToShortTimeString();
            }

            litInnerContent.Text += "<h2 class=\"price\">" + headerText + "</h2>";

            litInnerContent.Text += "</div>";
            
            //First Row
            litInnerContent.Text += "<div class=\"row\">";
            
            string photoPath = ConfigurationManager.AppSettings["imagesdir"] + "/thumbs/";
            if (currentEntry.FormImages.Count > 0)
                photoPath = photoPath + currentEntry.FormImages.First().Filename;
            else
                photoPath = "/images/content/search-details/default.gif";
            litInnerContent.Text += "<div class=\"leftSection firstImage\"><img src=\"" + photoPath + "\" /></div>\r\n\r\n";
            litInnerContent.Text += "<div class=\"rightSection first\">";
            string bedroomPlural = currentEntry.Bedrooms == 1 ? " bedroom" : " bedrooms";
            string bathroomPlural = currentEntry.Bathrooms == "1" ? " bathroom" : " bathrooms";
            litInnerContent.Text += "<table><tr>";
            litInnerContent.Text += "<td class=\"heading\">Bedrooms</td><td>" + currentEntry.Bedrooms + bedroomPlural + "</td><td class=\"spacerColumn\"></td>\r\n";
            litInnerContent.Text += "<td class=\"heading\">Bathrooms</td><td>" + currentEntry.Bathrooms + bathroomPlural + "</td>\r\n";
            litInnerContent.Text += "</tr><tr>";
            litInnerContent.Text += "<td class=\"heading\">Total Rooms</td><td>" + currentEntry.TotalRooms + " rooms" + "</td>\r\n";
            litInnerContent.Text += "<td colspan=\"2\"></td></tr></table>";
            XElement firstSection = formXml.Elements("formentry").Elements("formsection").Where(n => n.Attribute("firstpage").Value == "True").First();
            RenderSection(firstSection, true);

            litInnerContent.Text += "<div class=\"contactInfo\">";

            litInnerContent.Text += "<h3>Contact Info:</h3>\r\n";

            litInnerContent.Text += "<strong class=\"name\">" + currentEntry.UserInfo.FirstName + " " + currentEntry.UserInfo.LastName + "</strong>";
            if(!string.IsNullOrEmpty(currentEntry.UserInfo.Phone))
                litInnerContent.Text += "<span class=\"phone\">" + currentEntry.UserInfo.Phone + "</span>";
            litInnerContent.Text += "<span class=\"email\">" + currentEntry.UserInfo.Email + "</span><br />";
            if (currentEntry.UserInfo.AgencyID > 0)
            {
                Agency currentAgency = currentEntry.UserInfo.Agencies.First();
                litInnerContent.Text += "<strong class=\"agencyName\">" + currentAgency.Name + "</strong>";
                litInnerContent.Text += "<address>";
                litInnerContent.Text += "<span class=\"street\">" + currentAgency.Address1;
                if (!string.IsNullOrEmpty(currentAgency.Address2))
                    litInnerContent.Text += "<br />" + currentAgency.Address2;
                litInnerContent.Text += "</span>";
                litInnerContent.Text += "<span class=\"location\">" + currentAgency.City + ", " + currentAgency.State.Abbreviation + " " + currentAgency.ZipCode + "</span>";
                litInnerContent.Text += "</address>";
                litInnerContent.Text += "<div class=\"phoneurl\">";
                litInnerContent.Text += "<span class=\"phone\">" + currentAgency.Phone + "</span>";
                litInnerContent.Text += "<span class=\"url\">" + currentAgency.Website + "</span>";
                litInnerContent.Text += "</div>";
                
            }


            litInnerContent.Text += "</div>\r\n";
            
            litInnerContent.Text += "</div>\r\n";
            litInnerContent.Text += "<span class=\"clear\" />";
            litInnerContent.Text += "</div>\r\n\r\n";

            litInnerContent.Text += "<div class=\"row overview\">";
            litInnerContent.Text += "<h2>Overview</h2>\r\n";
            litInnerContent.Text += "<div class=\"introText\"><p>" + currentEntry.Description + "</p></div>";
            litInnerContent.Text += "</div>\r\n\r\n";

            bool rightSection = false;
            foreach (XElement section in formXml.Elements("formentry").Elements("formsection").Where(n => n.Attribute("firstpage").Value != "True"))
            {
                if (rightSection)
                {
                    litInnerContent.Text += "<div class=\"rightSection\">";
                }
                else
                {
                    litInnerContent.Text += "<div class=\"row\">";
                    litInnerContent.Text += "<div class=\"leftSection\">";
                }
                RenderSection(section, false);
                litInnerContent.Text += "</div>";
                if (rightSection)
                {
                    litInnerContent.Text += "<span class=\"clear\" />";
                    litInnerContent.Text += "</div>";
                }
                rightSection = !rightSection;
            }
            litInnerContent.Text += "<div class=\"row\" style=\"padding:10px;font-size:9px;\">The information contained herein is from sources deemed reliable, but is not guaranteed by A Zillion homes, LLC. A Zillion Homes, LLC assumes no responsibility for matters legal in character, nor does it render an opinion as to the title, which is assumed to be good. All data is subject to change of price, error, omissions, other conditions or withdrawal without notice.</div>";
            litInnerContent.RenderControl(writer);
        }

        protected void CloseTable(int cellCount)
        {
            if (cellCount == 2)
            {
                litInnerContent.Text += "<td colspan=\"3\"></td></tr>";
            }
            else
            {
                litInnerContent.Text += "</tr>";
            }
            litInnerContent.Text += "</table>";
        }

        private string FormatPrice(int price)
        {
            string basePrice = price.ToString();
            string formatPrice = "";
            while (basePrice.Length > 3)
            {
                formatPrice = "," + basePrice.Substring(basePrice.Length - 3, 3) + formatPrice;
                basePrice = basePrice.Substring(0, basePrice.Length - 3);
            }
            formatPrice = "$" + basePrice + formatPrice;

            return formatPrice;
        }

        private void RenderSection(XElement section, bool firstPage)
        {
            if (!firstPage)
            {
                string sectionName = section.Attribute("sectionname").Value;
                string sectionLink = sectionName.ToLower().Replace(" ", "").Replace("'", "");
                litInnerContent.Text += "<a name=\"" + sectionLink + "\"></a>\r\n";
                litInnerContent.Text += "<h2>" + sectionName + "</h2>\r\n";
            }

            bool inTable = false;
            int cellCount = 0;

            foreach (XElement field in section.Descendants("field"))
            {
                string fieldValue = field.Value;
                if (!string.IsNullOrEmpty(fieldValue))
                {
                    int formFieldID = Convert.ToInt32(field.Attribute("id").Value);
                    try
                    {
                        FormField dataField = Context.FormFields.Single(n => n.FormFieldID == formFieldID);
                        switch (dataField.FieldType.RenderControl)
                        {
                            case "TextBox:MultiLine":
                                if (inTable) { CloseTable(cellCount); inTable = false; }
                                litInnerContent.Text += "<h3>" + dataField.Name + "</h3>";
                                litInnerContent.Text += "<p>" + fieldValue + "</p>";
                                break;
                            case "CheckboxList":
                                if (inTable) { CloseTable(cellCount); inTable = false; }
                                litInnerContent.Text += "<h3>" + dataField.Name + "</h3>";
                                litInnerContent.Text += "<p>" + fieldValue.Replace(":", ", ") + "</p>";
                                break;
                            case "Dimensions":
                                if (inTable) { CloseTable(cellCount); inTable = false; }
                                litInnerContent.Text += "<h3>" + dataField.Name + "</h3>";
                                string output = "<table class=\"roomDimensions\">\r\n";
                                string[] rooms = fieldValue.Split(new string[] { "|" }, StringSplitOptions.RemoveEmptyEntries);
                                foreach (string room in rooms)
                                {
                                    string[] values = room.Split(new string[] { ":" }, StringSplitOptions.None);
                                    string sqft = (Convert.ToInt32(values[1]) * Convert.ToInt32(values[2])).ToString();
                                    output += "<tr>";
                                    output += "<td class=\"heading\">" + values[0] + ":</td>";
                                    output += "<td class=\"height\"><strong>H:</strong> " + values[1] + "</td>";
                                    output += "<td class=\"width\"><strong>W:</strong> " + values[2] + "</td>";
                                    output += "<td class=\"squareFootage\"><strong>Sq. Footage:</strong> " + sqft + "</td>";
                                    output += "</tr>";
                                }
                                output += "</table>";
                                litInnerContent.Text += output;
                                break;
                            case "Yes/No":
                                if (!inTable)
                                {
                                    litInnerContent.Text += "<table class=\"dottedBorderTable\">";
                                    litInnerContent.Text += "<tr>\r\n";
                                    inTable = true;
                                }
                                litInnerContent.Text += "<td width=\"22%\" class=\"heading fieldCell\">" + dataField.Name + "</td>\r\n";
                                litInnerContent.Text += "<td width=\"22%\" class=\"fieldCell\">";
                                litInnerContent.Text += fieldValue == "True" ? "Yes" : "No";
                                litInnerContent.Text += "</td>\r\n";
                                cellCount += 2;
                                if (cellCount == 4)
                                {
                                    litInnerContent.Text += "</tr><tr>\r\n";
                                    cellCount = 0;
                                }
                                else
                                {
                                    litInnerContent.Text += "<td class=\"spacerColumn\"></td>\r\n";
                                }
                                break;
                            default:
                                if (!inTable)
                                {
                                    litInnerContent.Text += "<table class=\"dottedBorderTable\">";
                                    litInnerContent.Text += "<tr>\r\n";
                                    inTable = true;
                                }
                                litInnerContent.Text += "<td width=\"22%\" class=\"heading fieldCell\">" + dataField.Name + "</td>\r\n";
                                litInnerContent.Text += "<td width=\"22%\" class=\"fieldCell\">" + fieldValue + "</td>\r\n";
                                cellCount += 2;
                                if (cellCount == 4)
                                {
                                    litInnerContent.Text += "</tr><tr>\r\n";
                                    cellCount = 0;
                                }
                                else
                                {
                                    litInnerContent.Text += "<td class=\"spacerColumn\"></td>\r\n";
                                }
                                break;
                        }
                    }
                    catch
                    {
                    }
                }
            }
            if (inTable) { CloseTable(cellCount); }
        }
    }
}