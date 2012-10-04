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
    public class Posting : CompositeControl
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

        public bool PrintMode
        {
            get
            {
                if (ViewState["PrintMode"] != null)
                {
                    return (bool)ViewState["PrintMode"];
                }
                else
                {
                    return false;
                }
            }
            set { ViewState["PrintMode"] = value; }
        }

        public bool PreviewMode
        {
            get
            {
                if (ViewState["PreviewMode"] != null)
                {
                    return (bool)ViewState["PreviewMode"];
                }
                else
                {
                    return false;
                }
            }
            set { ViewState["PreviewMode"] = value; }
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

        private LinkButton imgNewSearch;
        private LinkButton imgSaveListing;
        private LinkButton imgEmail;
        private LinkButton imgPrint;
        private LinkButton imgLogin;
        private HtmlGenericControl pnlHeader;
        private Panel pnlButtons;
        private Panel pnlInnerContent;
        private Literal litInnerContent;

        protected override void CreateChildControls()
        {
            imgEmail = new LinkButton { ID = "imgEmail", CssClass = "linkButton emailtofriend floatButton", Text = "email" };
            imgNewSearch = new LinkButton { ID = "imgNewSearch", CssClass = "linkButton newsearch floatButton", Text = "new search" };
            imgPrint = new LinkButton { ID = "imgPrint", CssClass = "linkButton print floatButton", Text = "print" };
            imgSaveListing = new LinkButton { ID = "imgSaveListing", CssClass = "linkButton savelisting floatButton", Text = "save listing" };
            imgLogin = new LinkButton { ID = "imgLogin", CssClass = "linkButton logintosave floatButton", Text = "login to save" };

            imgEmail.Click += new EventHandler(imgEmail_Click);
            imgNewSearch.Click += new EventHandler(imgNewSearch_Click);
            imgPrint.Click += new EventHandler(imgPrint_Click);
            imgSaveListing.Click += new EventHandler(imgSaveListing_Click);
            imgLogin.Click += new EventHandler(imgLogin_Click);

            pnlHeader = new HtmlGenericControl { ID = "pnlHeader", TagName = "div" };
            pnlHeader.Attributes.Add("class", "mainFocusDetails");
            pnlButtons = new Panel { ID = "pnlButtons", CssClass = "buttonRow" };
            pnlInnerContent = new Panel { ID = "pnlInnerContent", CssClass= "innerContent" };

            litInnerContent = new Literal { ID = "litInnerContent" };
            
            Controls.Add(pnlHeader);
            pnlButtons.Controls.Add(imgEmail);
            pnlButtons.Controls.Add(imgNewSearch);
            pnlButtons.Controls.Add(imgPrint);
            if (HttpContext.Current.Session["azhuserid"] != null)
            {
                pnlButtons.Controls.Add(imgSaveListing);
            }
            else
            {
                pnlButtons.Controls.Add(imgLogin);
            }
            
            pnlInnerContent.Controls.Add(pnlButtons);
            pnlInnerContent.Controls.Add(litInnerContent);
            Controls.Add(pnlInnerContent);
        }

        void imgLogin_Click(object sender, EventArgs e)
        {
            HttpContext.Current.Response.Redirect("~/Login.aspx");
        }

        void imgSaveListing_Click(object sender, EventArgs e)
        {
            DataClassesDataContext context = new DataClassesDataContext();
            int userInfoId = (int)HttpContext.Current.Session["azhuserid"];
            if (context.SavedFormEntries.Where(n => n.FormEntryID == FormEntryID && n.UserInfoID == userInfoId).Count() == 0)
            {
                SavedFormEntry newSavedListing = new SavedFormEntry { Created = DateTime.Now, FormEntryID = FormEntryID, UserInfoID = userInfoId };
                context.SavedFormEntries.InsertOnSubmit(newSavedListing);
                context.SubmitChanges();
            }
        }

        void imgPrint_Click(object sender, EventArgs e)
        {
            HttpContext.Current.Response.Redirect("~/PrintListing.aspx?postingid=" + FormEntryID.ToString());
        }

        void imgNewSearch_Click(object sender, EventArgs e)
        {
            HttpContext.Current.Session.Remove("currentsearch");
            HttpContext.Current.Response.Redirect("Default.aspx");
        }

        void imgEmail_Click(object sender, EventArgs e)
        {
            HttpContext.Current.Response.Redirect("~/EmailListing.aspx?id=" + FormEntryID.ToString());
        }

        public override void  RenderControl(System.Web.UI.HtmlTextWriter writer)
        {
            if (PrintMode || PreviewMode)
            {
                pnlButtons.Visible = false;
            }
            if (!Page.IsPostBack && PrintMode == false && PreviewMode == false)
            {
                FormView newView = new FormView { ViewDate = DateTime.Now, FormEntryID = FormEntryID, ViewIP = HttpContext.Current.Request.UserHostAddress };
                Context.FormViews.InsertOnSubmit(newView);
                Context.SubmitChanges();
            }

            //If Preview Clear and Refresh Cache
            if(PreviewMode)
            {
                Context.FormEntryCaches.DeleteAllOnSubmit(Context.FormEntryCaches.Where(n => n.FormEntryID == FormEntryID));
                Context.SubmitChanges();
            }

            if (Context.FormEntryCaches.Where(n => n.FormEntryID == FormEntryID).Count() > 0)
            {
                FormEntryCache currentCache = Context.FormEntryCaches.Single(n => n.FormEntryID == FormEntryID);
                pnlHeader.InnerHtml = currentCache.CachedHeader;
                litInnerContent.Text = currentCache.CachedBody;
            }
            else
            {
                if (FormEntryID == 0)
                    throw new ArgumentException("FormEntryID cannot be zero.", "FormEntryID");

                FormEntry currentEntry = Context.FormEntries.Single(n => n.FormEntryID == FormEntryID);
                Form currentForm = Context.Forms.Single(n => n.FormID == currentEntry.FormID);
                XDocument formXml = XDocument.Parse(currentEntry.Entry);
                XElement firstPage = formXml.Elements("formentry").Elements("formsection").Where(n => n.Attributes("firstpage").First().Value == "True").First();

                pnlHeader.InnerHtml = "<div id=\"imgContainer\" class=\"mainFocusImage\">\r\n";
                bool firstImage = true;
                int imageCount = 1;
                string photoPath = ConfigurationManager.AppSettings["imagesdir"];
                if (currentEntry.FormImages.Count > 0)
                {
                    string imageList = "<ul class=\"imageGalleryNav\">\r\n";
                    imageList += "<li class=\"previousImage\"><a href=\"#\" onclick=\"prevImage();\"><span>&laquo;</span> prev</a></li>\r\n";

                    foreach (FormImage image in currentEntry.FormImages)
                    {
                        string style = firstImage ? " " : " class=\"hiddenImage\" ";
                        firstImage = false;
                        pnlHeader.InnerHtml += "<img id=\"img" + imageCount.ToString() + "\" src=\"" + ConfigurationManager.AppSettings["imagesdir"] + "thumbs/" + image.Filename + "\" " + style + " />";
                        imageList += "<li><a href=\"#\" alt=\"" + image.Caption +  "\" onclick=\"showImage('img" + imageCount.ToString() + "');\">" + imageCount.ToString() + "</a></li>\r\n";
                        imageCount++;
                    }

                    imageList += "<li class=\"nextImage\"><a href=\"#\" onclick=\"nextImage(" + imageCount.ToString() + ");\">next <span>&raquo;</span></a></li>\r\n</ul>\r\n";
                    if (PrintMode == false)
                        pnlHeader.InnerHtml += imageList;
                }
                else
                {
                    pnlHeader.InnerHtml += "<img src=\"/images/content/search-detail/" + currentEntry.ListingTypeID.ToString() + "_default.jpg\" alt=\"Default Image\" />";
                }
                pnlHeader.InnerHtml += "</div>";
                
                pnlHeader.InnerHtml += "<div class=\"mainFocusText\">";
                //Add Tabs
                pnlHeader.InnerHtml += "<ul id=\"detailTabs\">";
                pnlHeader.InnerHtml += "<li><a href=\"#\" onclick=\"showGeneral();\" class=\"active\" id=\"generalInfoTab\"><span>General Info</span></a></li>";
                pnlHeader.InnerHtml += "<li><a href=\"#\" onclick=\"showContact();\" id=\"contactInfoTab\"><span>Contact Info</span></a></li>";
                pnlHeader.InnerHtml += "</ul>";
                //Info Content
                pnlHeader.InnerHtml += "<div id=\"generalInfoContent\">";
                if (currentEntry.ListingType.HasPrice)
                {
                    pnlHeader.InnerHtml += "<h2>" + FormatPrice(currentEntry.Price);
                    if (currentEntry.ListingType.MonthlyPrice && currentEntry.FormID != 37 )
                        pnlHeader.InnerHtml += "/month";
                    pnlHeader.InnerHtml += "</h2>\r\n";
                }
                if (currentEntry.ListingType.HasDate)
                {
                    if (currentEntry.ListingTypeID == 3)
                    {
                        string dateString = "<h3 style=\"font-size:110%;\">";
                        foreach (OpenHouseDate ohDate in currentEntry.OpenHouseDates)
                        {
                            dateString += ohDate.EventDate.ToShortDateString() + ", ";
                        }
                        dateString = dateString.Substring(0, dateString.Length - 2);
                        dateString += "<br /> from " + currentEntry.EventStart.Value.ToShortTimeString() + " to " + currentEntry.Expires.Value.ToShortTimeString();
                        dateString += "</h3>";
                        pnlHeader.InnerHtml += dateString;
                    }
                    else
                    {
                        pnlHeader.InnerHtml += "<h3 style=\"font-size:125%;\">" + currentEntry.Expires.Value.ToShortDateString() + ", " + currentEntry.EventStart.Value.ToShortTimeString() + "-" + currentEntry.Expires.Value.ToShortTimeString() + "</h3>\r\n";
                    }
                }
                pnlHeader.InnerHtml += "<h3>" + currentEntry.StreetNumber + " " + currentEntry.StreetName + "</h3>\r\n";
                pnlHeader.InnerHtml += "<ul>\r\n";
                pnlHeader.InnerHtml += "<li>" + currentEntry.City + ", " + currentEntry.State.Abbreviation + " " + currentEntry.ZipCode + "</li>";
                pnlHeader.InnerHtml += "<li>AZH# " + currentEntry.AZHID + "</li>";
                if (currentEntry.Form.RequiresBedBath)
                {
                    string bedroomPlural = currentEntry.Bedrooms == 1 ? " bedroom" : " bedrooms";
                    string bathroomPlural = currentEntry.Bathrooms == "1" ? " bathroom" : " bathrooms";
                    if (currentEntry.TotalRooms > 0)
                    {
                        pnlHeader.InnerHtml += "<li>" + currentEntry.TotalRooms + " total rooms</li>\r\n";
                    }
                    pnlHeader.InnerHtml += "<li>" + currentEntry.Bedrooms + bedroomPlural + "</li>\r\n";
                    pnlHeader.InnerHtml += "<li>" + currentEntry.Bathrooms + bathroomPlural + "</li>\r\n";
                }
                pnlHeader.InnerHtml += "</ul>\r\n";
                pnlHeader.InnerHtml += "<div class=\"dottedDivider\"></div>\r\n";
                if (!string.IsNullOrEmpty(currentEntry.StreetNumber.Trim()))
                {
                    string urlAddress = currentEntry.StreetNumber + " " + currentEntry.StreetName + ", " + currentEntry.City + ", " + currentEntry.State.Abbreviation + " " + currentEntry.ZipCode;
                    string mapUrl = "http://maps.live.com/default.aspx?where1=" + urlAddress;
                    pnlHeader.InnerHtml += "<a target=\"_blank\" href=\"" + mapUrl + "\">Get Directions</a>\r\n";
                }
                pnlHeader.InnerHtml += "</div>";

                //Contact Content
                pnlHeader.InnerHtml += "<div id=\"contactInfoContent\" style=\"display:none;\">";
                pnlHeader.InnerHtml += "<h3>Contact Info:</h3>\r\n";
                pnlHeader.InnerHtml += "<ul>\r\n";
                if (currentEntry.UserInfo.AgencyID > 0)
                {
                    Agency currentAgency = currentEntry.UserInfo.Agencies.First();
                    pnlHeader.InnerHtml += "<li>" + currentAgency.Name + "</li>";
                }
                pnlHeader.InnerHtml += "<li>" + currentEntry.UserInfo.FirstName + " " + currentEntry.UserInfo.LastName + "</li>";
                if (currentEntry.UserInfo.AgencyID > 0)
                {
                    Agency currentAgency = currentEntry.UserInfo.Agencies.First();
                    pnlHeader.InnerHtml += "<li>Office: " + currentAgency.Phone + "</li>";
                    if (!string.IsNullOrEmpty(currentAgency.Website))
                        pnlHeader.InnerHtml += "<li><a href=\"" + currentAgency.Website + "\">" + currentAgency.Website + "</a></li>";
                }
                else
                {
                    pnlHeader.InnerHtml += "<li>Phone: " + currentEntry.UserInfo.Phone + "</li>";
                }
                pnlHeader.InnerHtml += "<li><a href=\"mailto:" + currentEntry.UserInfo.Email + "\">" + currentEntry.UserInfo.Email.Replace('(','[').Replace(')',']') + "</a></li>";
                pnlHeader.InnerHtml += "</ul>\r\n";
                pnlHeader.InnerHtml += "</div>";
                pnlHeader.InnerHtml += "</div>";

                pnlHeader.InnerHtml += "<span class=\"clear\" />";
                IQueryable<FormDocument> documents = Context.FormDocuments.Where(n => n.FormEntryID == FormEntryID);
                
                if (PrintMode == false)
                {
                    litInnerContent.Text = "<ul id=\"jumpLinks\">\r\n";
                    litInnerContent.Text += "<li><strong>Details:</strong></li>\r\n";
                    litInnerContent.Text += "<li class=\"overview\"><a href=\"#overview\">Overview</a></li>\r\n";
                    foreach (XElement section in formXml.Elements("formentry").Elements("formsection").Where(n => n.Attributes("firstpage").First().Value == "False"))
                    {
                        string sectionName = section.Attribute("sectionname").Value;
                        string sectionLink = sectionName.ToLower().Replace(" ", "").Replace("'", "");
                        litInnerContent.Text += "<li><a href=\"#" + sectionLink + "\">" + sectionName + "</a></li>\r\n";
                    }
                    if (documents.Count() > 0)
                        litInnerContent.Text += "<li class=\"last\"><a href=\"#documents\">Documents</a></li>\r\n";
                    litInnerContent.Text += "</ul>\r\n";
                }

                litInnerContent.Text += "<h2>Overview</h2>\r\n";
                litInnerContent.Text += "<div class=\"introText\"><p>" + currentEntry.Description + "</p></div>";

                litInnerContent.Text += "<h3>Directions</h3>\r\n";
                litInnerContent.Text += "<div class=\"introText\"><p>" + currentEntry.Directions + "</p></div>";

                XElement firstSection = formXml.Elements("formentry").Elements("formsection").Where(n => n.Attribute("firstpage").Value == "True").First();
                RenderSection(firstSection, true);
                litInnerContent.Text += "<hr />\r\n";

                foreach (XElement section in formXml.Elements("formentry").Elements("formsection").Where(n => n.Attribute("firstpage").Value != "True"))
                {
                    RenderSection(section, false);
                }

                //Build Documents
                if (documents.Count() > 0)
                {
                    litInnerContent.Text += "<a name=\"documents\"></a>\r\n";
                    litInnerContent.Text += "<h2>Documents</h2>\r\n";
                    litInnerContent.Text += "<ul class=\"documents\">";
                    foreach (FormDocument document in documents)
                    {
                        litInnerContent.Text += "<li>";
                        litInnerContent.Text += "<a href=\"" + ConfigurationManager.AppSettings["filesdir"] + document.Filename + "\">" + document.Name + "</a>";
                        litInnerContent.Text += "</li>";
                    }
                    litInnerContent.Text += "</ul>";
                }

                string header = pnlHeader.InnerText;
                string body = litInnerContent.Text;
                FormEntryCache newCache = new FormEntryCache { CachedBody = body, CachedHeader = header, FormEntryID = FormEntryID };
                Context.FormEntryCaches.InsertOnSubmit(newCache);
                Context.SubmitChanges();
            }
            base.RenderControl(writer);
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

        private string FormatPrice(decimal price)
        {
            string[] priceParts = price.ToString().Split(new char[]{'.'});
            string basePrice = priceParts[0];
            string cents = "00";
            if (priceParts.Length > 1)
            {
                cents = priceParts[1];
            }
            string formatPrice = "";
            while (basePrice.Length > 3)
            {
                formatPrice = "," + basePrice.Substring(basePrice.Length - 3, 3) + formatPrice;
                basePrice = basePrice.Substring(0, basePrice.Length - 3);
            }
            formatPrice = "$" + basePrice + formatPrice + "." + cents;

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
                if(!string.IsNullOrEmpty(fieldValue))
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
                                if (dataField.FieldType.Name == "Price")
                                    fieldValue = FormatPrice((Convert.ToDecimal(fieldValue)));
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
            litInnerContent.Text += "<a href=\"#top\" class=\"backToTop\"><span>&#94;</span> top</a>";
        }
    }
}