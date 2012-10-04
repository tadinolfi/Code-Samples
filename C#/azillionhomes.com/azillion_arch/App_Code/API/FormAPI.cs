using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.ComponentModel;
using System.Linq.Expressions;
using System.Linq.Dynamic;
using Amplify.Utilities;
using System.Collections.Generic;
using System.Text.RegularExpressions;

/// <summary>
/// Summary description for FormAPI
/// </summary>
[DataObject]
public class FormAPI
{
    [DataObjectMethodAttribute(DataObjectMethodType.Select,true)]
    public static IQueryable<Form> GetForms()
    {
        DataClassesDataContext context = new DataClassesDataContext();
        return context.Forms;
    }

    [DataObjectMethodAttribute(DataObjectMethodType.Select, false)]
    public static Form GetFormById(int FormID)
    {
        DataClassesDataContext context = new DataClassesDataContext();
        return context.Forms.Single(n => n.FormID == FormID);
    }

    [DataObjectMethodAttribute(DataObjectMethodType.Insert, false)]
    public static int Insert(string Name, string Description, bool Active)
    {
        DataClassesDataContext context = new DataClassesDataContext();
        Form newForm = new Form { Name = Name, Description = Description, Active = Active };
        context.Forms.InsertOnSubmit(newForm);
        context.SubmitChanges();
        return newForm.FormID;
    }

    public static string GetAZHNumber(int formId, int listingTypeId, int stateId)
    {
        DataClassesDataContext context = new DataClassesDataContext();
        Form theForm = context.Forms.Single(n => n.FormID == formId);
        ListingType theType = context.ListingTypes.Single(n => n.ListingTypeID == listingTypeId);
        State theState = context.States.Single(n => n.StateID == stateId);

        string AZHPrefix = theType.Name.Substring(0, 1) + theForm.Name.Substring(0, 1) + theState.Abbreviation;
        int NewID = 0;
        try
        {
            NewID = context.FormEntries.OrderByDescending(n => n.FormEntryID).First().FormEntryID + 1;
        }
        catch
        {
            NewID = 1;
        }
        return AZHPrefix + NewID.ToString();
    }

    public static string GetEmptyXml(int formId)
    {
        DataClassesDataContext context = new DataClassesDataContext();
        Form xmlForm = context.Forms.Single(n => n.FormID == formId);
        string retXml = "<formentry formid=\"" + xmlForm.FormID.ToString() + "\">";
        foreach (FormSection section in xmlForm.FormSections)
        {
            retXml += "<formsection id=\"" + section.FormSectionID.ToString() + "\" sectionname=\"" + section.SectionName + "\" firstpage=\"" + section.FirstPage.ToString() + "\">";
            foreach (FormField field in section.FormFields)
            {
                retXml += "<field id=\"" + field.FormFieldID.ToString() + "\" fieldname=\"" + field.Name + "\">" + field.DefaultValue + "</field>";
            }
            retXml += "</formsection>";
        }
        retXml += "</formentry>";
        return retXml;
    }

    [DataObjectMethodAttribute(DataObjectMethodType.Select, false)]
    public static IQueryable<FormEntry> SearchPostings(string searchString)
    {
        SearchTerms terms = new SearchTerms(searchString);
        return SearchPostings(terms);
    }

    [DataObjectMethodAttribute(DataObjectMethodType.Select, false)]
    public static IQueryable<FormEntry> SearchPostings(SearchTerms terms)
    {
        DataClassesDataContext context = new DataClassesDataContext();
        IQueryable<FormEntry> searchValues = context.FormEntries.Where(n => n.ListingTypeID == terms.ListingTypeID && n.Completed == true && n.Active == true && n.Expires >= DateTime.Now);
        if (terms.ListingTypeID == 3)
        {
            if (terms.StartDate.Year > 1)
            {
                searchValues = searchValues.Where(n => n.OpenHouseDates.Max().EventDate >= terms.StartDate);
            }
            if (terms.EndDate.Year > 1)
            {
                searchValues = searchValues.Where(n => n.OpenHouseDates.Min().EventDate <= terms.EndDate);
            }
        }
        else
        {
            if (terms.StartDate.Year > 1)
            {
                searchValues = searchValues.Where(n => n.Expires >= terms.StartDate);
            }
            if (terms.EndDate.Year > 1)
            {
                searchValues = searchValues.Where(n => n.Expires <= terms.EndDate.AddDays(1));
            }
        }
        if (terms.FormID > 0)
        {
            searchValues = searchValues.Where(n => n.FormID == terms.FormID);
        }
        if (terms.MinPrice > 0)
        {
            searchValues = searchValues.Where(n => n.Price >= terms.MinPrice);
        }
        if (terms.MaxPrice > 0)
        {
            searchValues = searchValues.Where(n => n.Price <= terms.MaxPrice);
        }
        if (terms.Bedrooms > 0)
        {
            if (terms.Bedrooms == 4)
            {
                searchValues = searchValues.Where(n => n.Bedrooms >= 4);
            }
            else
            {
                searchValues = searchValues.Where(n => n.Bedrooms == terms.Bedrooms);
            }
        }
        if (terms.Baths > 0)
        {
            searchValues = searchValues.Where(n => Convert.ToDouble(n.Bathrooms) >= (double)terms.Baths);
        }
        if (!string.IsNullOrEmpty(terms.Zip))
        {
            searchValues = FilterByZip(terms.Zip, searchValues);
        }
        else if (terms.StateID > 0)
        {
            searchValues = searchValues.Where(n => n.StateID == terms.StateID);
        }
        if (!string.IsNullOrEmpty(terms.Keywords))
        {
            searchValues = FilterByKeywords(terms.Keywords, searchValues);
        }
        switch (terms.Sort)
        {
            case SearchSort.DateAsc:
                searchValues = searchValues.OrderBy(n => n.EntryDate);
                break;
            case SearchSort.DateDesc:
                searchValues = searchValues.OrderByDescending(n => n.EntryDate);
                break;
            case SearchSort.PriceAsc:
                searchValues = searchValues.OrderBy(n => n.Price);
                break;
            case SearchSort.PriceDesc:
                searchValues = searchValues.OrderByDescending(n => n.Price);
                break;
        }
        return searchValues;
    }

    public static IQueryable<FormEntry> FilterByZip(string zipCode, IQueryable<FormEntry> entries)
    {
        string regEx = "^(\\d{5}|\\d{5}\\-\\d{4})$";
        Regex zipRegex = new Regex(regEx);
        DataClassesDataContext context = new DataClassesDataContext();
        List<string> zips = new List<string>();
        if (!zipRegex.IsMatch(zipCode))
        {
            if (zipCode.Contains(","))
            {

                string[] townPart = zipCode.Split(new char[] { ',' });
                if (townPart[1].Trim().Length > 2)
                {
                    State stateMatch = context.States.Where(n => n.Name.ToLower() == townPart[1].Trim().ToLower()).First();
                    IQueryable<Zipcode> zipRows = context.Zipcodes.Where(n => n.City.Trim().ToLower() == townPart[0].Trim().ToLower() && n.Abbreviation.Trim().ToLower() == stateMatch.Abbreviation.Trim().ToLower());
                    if (zipRows.Count() > 0)
                    {
                        zipCode = zipRows.First().Zipcode1;
                    }
                    else
                    {
                        zipCode = "00000";
                    }
                }
                else
                {
                    IQueryable<Zipcode> zipRows = context.Zipcodes.Where(n => n.City.Trim().ToLower() == townPart[0].Trim().ToLower() && n.Abbreviation.Trim().ToLower() == townPart[1].Trim().ToLower());
                    if (zipRows.Count() > 0)
                    {
                        zipCode = zipRows.First().Zipcode1;
                    }
                    else
                    {
                        zipCode = "00000";
                    }
                }
            }
            else
            {
                IQueryable<Zipcode> checkZips = context.Zipcodes.Where(n => n.City.Trim().ToLower() == zipCode.Trim().ToLower());
                if (checkZips.Count() > 0)
                {
                    zipCode = checkZips.First().Zipcode1;
                }
                else
                {
                    zipCode = "00000";
                }
            }
        }
        //Process Zip Code
        try
        {
            List<CityInfo> cities = GeoData.GetNearbyCities(zipCode, 5, false);
            
            foreach (CityInfo city in cities)
            {
                zips.Add(city.Zipcode);
            }
        }
        catch
        {
        }
        IQueryable<FormEntry> retVal = entries.Where(n => zips.Contains(n.ZipCode));
        return retVal;
    }

    public static IQueryable<FormEntry> FilterByKeywords(string keywordString, IQueryable<FormEntry> entries)
    {
        DataClassesDataContext context = new DataClassesDataContext();
        string[] keywords = keywordString.Split(new string[] { ",", " " }, StringSplitOptions.RemoveEmptyEntries);
        IQueryable<FormEntry> newEntries;
        if (keywords.Count() > 0)
        {
            newEntries = entries.Where(n => n.SearchableFields.Contains(keywords[0]));
            for (int i = 1; i < keywords.Length; i++)
            {
                newEntries = newEntries.Concat(entries.Where(n => n.SearchableFields.Contains(keywords[i])));
            }
        }
        else
        {
            newEntries = entries;
        }
        return newEntries;
    }

    public static void ArchiveFormEntry(int formEntryID, string reason)
    {
        DataClassesDataContext context = new DataClassesDataContext();
        FormEntry liveForm = context.FormEntries.Single(f => f.FormEntryID == formEntryID);

        //Clear out related data
        try
        {
            context.SavedFormEntries.DeleteAllOnSubmit(context.SavedFormEntries.Where(s => s.FormEntryID == formEntryID));
            context.SavedSearchFormEntryHistories.DeleteAllOnSubmit(context.SavedSearchFormEntryHistories.Where(s => s.FormEntryID == formEntryID));
            context.FormEntryCaches.DeleteOnSubmit(context.FormEntryCaches.Single(n => n.FormEntryID == formEntryID));
        }
        catch
        {
            //nothing here folks
        }

        //Get Views then delete
        int totalViews = context.FormViews.Count(f => f.FormEntryID == formEntryID);
        if(totalViews > 0)
            context.FormViews.DeleteAllOnSubmit( context.FormViews.Where( n=> n.FormEntryID == formEntryID));
        context.SubmitChanges();

        //Create Archive
        FormEntryArchive newArchive = new FormEntryArchive
        {
            Active = liveForm.Active,
            AZHID = liveForm.AZHID,
            Bathrooms = liveForm.Bathrooms,
            Bedrooms = liveForm.Bedrooms,
            City = liveForm.City,
            Completed = liveForm.Completed,
            Description = liveForm.Description,
            Directions = liveForm.Directions,
            Entry = liveForm.Entry,
            EntryDate = liveForm.EntryDate,
            Expires = liveForm.Expires.Value,
            FormType = liveForm.Form.Name,
            ListingType = liveForm.ListingType.Name,
            Paid = liveForm.Paid,
            Price = liveForm.Price,
            ReasonedRemoved = reason,
            SearchableFields = liveForm.SearchableFields,
            State = liveForm.State.Abbreviation,
            StreetName = liveForm.StreetName,
            StreetNumber = liveForm.StreetNumber,
            TotalViews = totalViews,
            UserInfoID = liveForm.UserInfoID,
            ZipCode = liveForm.ZipCode
        };
        if (liveForm.EventStart.HasValue)
            newArchive.EventStart = liveForm.EventStart.Value;
        else
            newArchive.EventStart = DateTime.Now.AddYears(-100);
        context.FormEntryArchives.InsertOnSubmit(newArchive);
        context.SubmitChanges();

        if(liveForm.FormDocuments.Count > 0)
            context.FormDocuments.DeleteAllOnSubmit(liveForm.FormDocuments);
        if(liveForm.FormEntryCaches.Count > 0)
            context.FormEntryCaches.DeleteAllOnSubmit(liveForm.FormEntryCaches);
        if(liveForm.FormImages.Count > 0)
            context.FormImages.DeleteAllOnSubmit(liveForm.FormImages);
        if(liveForm.FormViews.Count > 0)
            context.FormViews.DeleteAllOnSubmit(liveForm.FormViews);
        if(liveForm.OpenHouseDates.Count > 0)
            context.OpenHouseDates.DeleteAllOnSubmit(liveForm.OpenHouseDates);
        if(liveForm.SavedFormEntries.Count > 0)
            context.SavedFormEntries.DeleteAllOnSubmit(liveForm.SavedFormEntries);
        if(liveForm.SavedSearchFormEntryHistories.Count > 0)
            context.SavedSearchFormEntryHistories.DeleteAllOnSubmit(liveForm.SavedSearchFormEntryHistories);

        context.FormEntries.DeleteOnSubmit(liveForm);
        context.SubmitChanges();
    }
}
