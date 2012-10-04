using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using AZHControls;
using System.Xml;
using System.Xml.Linq;
using System.IO;
using System.Data;
using Amplify.Utilities;

public partial class myazh_PostingInfo : AZHCore.AZHPage 
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AdminSection = AZHCore.AZHSection.MyPosting;
        ShowSearch = false;

        //Load Form Details
        if (Session["editPostingType"] == null)
            Response.Redirect("ChoosePostingType.aspx");
        DataClassesDataContext context = new DataClassesDataContext();
        int formId = Convert.ToInt32(Session["editPostingType"]);
        int listingTypeId = Convert.ToInt32(Session["listingTypeID"]);
        Form postingForm = context.Forms.Single(n => n.FormID == formId);
        ListingType listingType = context.ListingTypes.Single(n => n.ListingTypeID == listingTypeId);

        //Set Breadcrumb
        string formTypeName = postingForm.Name;
        if (formTypeName.Contains('-'))
            formTypeName = postingForm.Name.Split(new string[] { "-" }, StringSplitOptions.None)[1].Trim();
        lblPostingBreadCrumb.Text = listingType.Name + " &raquo; " + formTypeName;

        //Build Form
        txtPrice.Visible = postingForm.RequiresPrice;
        txtPrice.Required = postingForm.RequiresPrice;
        txtBedrooms.Visible = postingForm.RequiresBedBath;
        txtBedrooms.Required = postingForm.RequiresBedBath;
        txtBathrooms.Visible = postingForm.RequiresBedBath;
        txtBathrooms.Required = postingForm.RequiresBedBath;
        txtTotalRooms.Visible = postingForm.RequiresBedBath;
        txtTotalRooms.Required = postingForm.RequiresBedBath;
        txtTotalRooms.Value = "0";

        if (!postingForm.RequiresBedBath)
        {
            txtBedrooms.Value = "0";
            txtBathrooms.Value = "0";
        }

        if (listingTypeId == 3)
        {
            txtDate.Visible = false;
            divDate.Visible = true;
            txtNumber.Required = true;
        }
        else
        {
            txtDate.Visible = postingForm.RequiresDate;
        }
        pnlTimeStart.Visible = postingForm.RequiresDate;
        pnlTimeEnd.Visible = postingForm.RequiresDate;

        //Load Current Form Data
        FormEntry currentEntry;
        int formEntryId = 0;
        XElement firstPageXml = new XElement("empty");
        if (Session["formEntryId"] != null && !IsPostBack)
        {
            formEntryId = (int)Session["formEntryId"];
            currentEntry = context.FormEntries.Single(n => n.FormEntryID == formEntryId);
            txtTotalRooms.Value = currentEntry.TotalRooms.ToString();
            txtBathrooms.Value = currentEntry.Bathrooms;
            txtBedrooms.Value = currentEntry.Bedrooms.ToString();
            if (currentEntry.Expires.HasValue)
            {
                txtDate.Value = currentEntry.Expires.Value.ToShortDateString();
                txtEnd.Text = currentEntry.Expires.Value.ToShortTimeString();
            }
            if(currentEntry.EventStart.HasValue)
            {
                DateTime eventStart = currentEntry.EventStart.Value;
                txtStart.Text = eventStart.ToShortTimeString();
            }
            txtDescription.Value = currentEntry.Description;
            txtDirections.Value = currentEntry.Directions;
            txtNumber.Value = currentEntry.StreetNumber;
            txtStreet.Value = currentEntry.StreetName;
            txtTown.Value = currentEntry.City;
            txtZipCode.Text = currentEntry.ZipCode;
            txtPrice.Value = currentEntry.Price.ToString();
            ddlState.SelectedValue = currentEntry.StateID.ToString();
            firstPageXml = XDocument.Parse(currentEntry.Entry).Descendants("formsection").Where(n => n.Attribute("firstpage").Value == "True").First();
            if (listingTypeId == 3)
            {
                List<DateTime> entryDates = new List<DateTime>();
                foreach (OpenHouseDate entDate in currentEntry.OpenHouseDates)
                {
                    entryDates.Add(entDate.EventDate);
                }
                MultiDate1.Dates = entryDates;
            }
        }

        //Render Fields
        FormSection infoSection = postingForm.FormSections.Where(n => n.FirstPage == true).First();
        bool altRow = true;
        int zIndex = 90000;
        foreach (FormField infoField in infoSection.FormFields)
        {
            AZHControls.AZHField field = new AZHControls.AZHField(infoField.FormFieldID);
            field.AltRow = altRow;
            field.ID = "field" + infoField.FormFieldID;
            field.ZIndex = zIndex;
            zIndex--;
            if (formEntryId > 0 && !IsPostBack)
            {
                try
                {
                    field.Value = firstPageXml.Descendants("field").Where(n => n.Attribute("id").Value == infoField.FormFieldID.ToString()).First().Value;
                }
                catch
                {
                    field.Value = "";
                }
            }
            pnlFields.Controls.Add(field);
            altRow = !altRow;
        }

        //Check Agency Status
        if (context.Agencies.Where(n => n.OwnerUserInfoID == (int)Session["azhuserid"]).Count() > 0)
        {
            int agencyId = context.Agencies.Where(n => n.OwnerUserInfoID == (int)Session["azhuserid"]).First().AgencyID;
            IQueryable<UserInfo> agencyUsers = context.UserInfos.Where(n => n.AgencyID == agencyId && n.UserInfoID != (int)Session["azhuserid"]).OrderBy(n => n.LastName).OrderBy(n => n.FirstName);
            var userData = from a in agencyUsers
                           select new { name = a.FirstName + " " + a.LastName, userid = a.UserInfoID };
            ddlUserInfo.DataSource = userData;
            ddlUserInfo.DataTextField = "name";
            ddlUserInfo.DataValueField = "userid";
            ddlUserInfo.DataBind();
            pnlOnBehalf.Visible = true;
        }
    }

    protected void lnkPosting_Click(object sender, EventArgs e)
    {
        //Load Form Details
        if (Session["editPostingType"] == null)
            Response.Redirect("ChoosePostingType.aspx");
        DataClassesDataContext context = new DataClassesDataContext();
        int formId = Convert.ToInt32(Session["editPostingType"]);
        int listingTypeId = Convert.ToInt32(Session["listingTypeID"]);
        int stateId = Convert.ToInt32(ddlState.SelectedValue);
        Form postingForm = context.Forms.Single(n => n.FormID == formId);

        //Process Form
        XDocument dataDoc;
        FormEntry currentEntry = null;
        if (Session["formEntryId"] == null)
        {
            dataDoc = XDocument.Parse(FormAPI.GetEmptyXml(formId));
        }
        else
        {
            int formEntryId = (int)Session["formEntryId"];
            currentEntry = context.FormEntries.Single(n => n.FormEntryID == formEntryId);
            dataDoc = XDocument.Parse(currentEntry.Entry);
        }

        XElement firstPage = dataDoc.Elements("formentry").Elements("formsection").Where(n => n.Attributes("firstpage").First().Value == "True").First();

        FormSection postingInfo = postingForm.FormSections.Single(n => n.FirstPage == true);
        foreach (FormField field in postingInfo.FormFields)
        {
            AZHField fieldControl = pnlFields.FindControl("field" + field.FormFieldID.ToString()) as AZHField;

            XElement xmlField = firstPage.Descendants("field").Where(n => n.Attributes("id").First().Value == field.FormFieldID.ToString()).First();
            string value = fieldControl.Value;
            if (value == "")
                value = fieldControl.GetFieldValue();
            xmlField.Value = value;
        }

        bool newEntry = false;
        if (currentEntry == null)
        {
            int entryUserId = Convert.ToInt32(ddlUserInfo.SelectedValue);
            if (entryUserId == 0)
                entryUserId = (int)Session["azhuserid"];
            currentEntry = new FormEntry();
            currentEntry.UserInfoID = entryUserId;
            newEntry = true;
        }
        if (currentEntry.FormEntryID == 0)
        {
            string AZHNumber = FormAPI.GetAZHNumber(formId, listingTypeId, stateId);
            currentEntry.AZHID = AZHNumber;
        }
        currentEntry.City = txtTown.Value;
        currentEntry.TotalRooms = Convert.ToInt32(txtTotalRooms.Value);
        currentEntry.Bathrooms = txtBathrooms.Value;
        currentEntry.Bedrooms = Convert.ToInt32(txtBedrooms.Value);
        currentEntry.Description = txtDescription.Value;
        currentEntry.Directions = txtDirections.Value;
        currentEntry.EntryDate = DateTime.Now;
        currentEntry.FormID = formId;
        currentEntry.Entry = dataDoc.ToString();
        currentEntry.ListingTypeID = listingTypeId;
        currentEntry.Paid = false;
        currentEntry.Price = ParsePrice(txtPrice.Value);
        currentEntry.SearchableFields = "";
        currentEntry.StateID = Convert.ToInt32(ddlState.SelectedValue);
        currentEntry.StreetName = txtStreet.Value;
        currentEntry.StreetNumber = txtNumber.Value;
        currentEntry.ZipCode = txtZipCode.Text;
        if (postingForm.RequiresDate)
        {
            if (listingTypeId != 3)
            {
                currentEntry.Expires = DateTime.Parse(txtDate.Value + " " + txtEnd.Text);
                currentEntry.EventStart = DateTime.Parse(txtDate.Value + " " + txtStart.Text);
            }
            else
            {
                if (MultiDate1.Dates.Count() > 0)
                {
                    currentEntry.Expires = DateTime.Parse(MultiDate1.Dates.Max().ToShortDateString() + " " + txtEnd.Text);
                    currentEntry.EventStart = DateTime.Parse(MultiDate1.Dates.Min().ToShortDateString() + " " + txtStart.Text);
                }
            }
        }
        else
        {
            currentEntry.Expires = DateTime.Now.AddMonths(1);
        }

        if(newEntry)
            context.FormEntries.InsertOnSubmit(currentEntry);
        context.SubmitChanges();

        if (listingTypeId == 3)
        {
            List<DateTime> dateList = MultiDate1.GetValue();
            if(context.OpenHouseDates.Count() > 0)
                context.OpenHouseDates.DeleteAllOnSubmit(currentEntry.OpenHouseDates);
            foreach (DateTime date in dateList)
            {
                OpenHouseDate newDate = new OpenHouseDate{ EventDate = DateTime.Parse(date.ToShortDateString() + " " + txtStart.Text), FormEntryID = currentEntry.FormEntryID};
                context.OpenHouseDates.InsertOnSubmit(newDate);
            }
        }
        context.SubmitChanges();

        //Store New ID in Session
        Session.Add("formEntryId", currentEntry.FormEntryID);
        if (postingForm.FormSections.Count > 1)
            Response.Redirect("PostingDetails.aspx");
        else
            Response.Redirect("PostingPhotos.aspx");
    }

    protected int ParsePrice(string price)
    {
        int retPrice = 0;
        price = price.Split(new string[] { "." }, StringSplitOptions.None)[0];
        if(!string.IsNullOrEmpty(price))
            retPrice = Convert.ToInt32(price.Replace(",", "").Replace("$", ""));
        return retPrice;
    }
    protected void txtZipCode_TextChanged(object sender, EventArgs e)
    {
        DataClassesDataContext context = new DataClassesDataContext();
        IQueryable<Zipcode> zips = context.Zipcodes.Where(n => n.Zipcode1 == txtZipCode.Text);
        if (zips.Count() > 0)
        {
            Zipcode currentZip = zips.First();
            State zipState = context.States.Single(n => n.Abbreviation == currentZip.Abbreviation.Trim());
            ddlState.SelectedValue = zipState.StateID.ToString();
            txtTown.Focus();
        }
    }
}
