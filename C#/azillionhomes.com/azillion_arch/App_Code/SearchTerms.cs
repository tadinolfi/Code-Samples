using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;


public enum SearchSort
{
    PriceDesc,
    PriceAsc,
    DateDesc,
    DateAsc
}

public class SearchTerms
{
    public int ListingTypeID { get; set; }
    public int FormID { get; set; }
    public int MinPrice { get; set; }
    public int MaxPrice { get; set; }
    public DateTime StartDate { get; set; }
    public DateTime EndDate { get; set; }
    public string Zip { get; set; }
    public string Keywords { get; set; }
    public int Baths { get; set; }
    public int Bedrooms { get; set; }
    public int StateID { get; set; }
    private SearchSort __Sort;
    public SearchSort Sort {
        get
        {
            if (__Sort == null)
            {
                return SearchSort.DateDesc;
            }
            else
            {
                return __Sort;
            }
        }
        set { __Sort = value; }
    }

    public SearchTerms()
    {
    }

    public SearchTerms(string searchString)
    {
        string[] values = searchString.Split(new string[] { "|" }, StringSplitOptions.None);
        ListingTypeID = Convert.ToInt32(values[0]);
        FormID = Convert.ToInt32(values[1]);
        if(!string.IsNullOrEmpty(values[2]))
            MinPrice = Convert.ToInt32(values[2]);
        if (!string.IsNullOrEmpty(values[3]))
            MaxPrice = Convert.ToInt32(values[3]);
        if (!string.IsNullOrEmpty(values[4]))
            StartDate = DateTime.Parse(values[4]);
        if (!string.IsNullOrEmpty(values[5]))
            EndDate = DateTime.Parse(values[5]);
        Zip = values[6];
        Keywords = values[7];
        if (values.Count() > 8 && !string.IsNullOrEmpty(values[8]))
            Bedrooms = Convert.ToInt32(values[8]);
        if (values.Count() > 9 && !string.IsNullOrEmpty(values[9]))
            Baths = Convert.ToInt32(values[9]);
        if (values.Count() > 10 && !string.IsNullOrEmpty(values[10]))
            Sort = (SearchSort)Enum.Parse(typeof(SearchSort), values[10], true);
        if (values.Count() > 11 && !string.IsNullOrEmpty(values[10]))
            StateID = Convert.ToInt32(values[11]);
    }

    public string GetSearchString()
    {
        string searchString = ListingTypeID.ToString() + "|";
        searchString += FormID.ToString() + "|";
        searchString += MinPrice.ToString() + "|";
        searchString += MaxPrice.ToString() + "|";
        searchString += StartDate.ToShortDateString() + "|";
        searchString += EndDate.ToShortDateString() + "|";
        searchString += Zip + "|";
        searchString += Keywords + "|";
        searchString += Bedrooms.ToString() + "|";
        searchString += Baths.ToString() + "|";
        searchString += Sort.ToString() + "|";
        searchString += StateID.ToString() + "|";
        return searchString;
    }
}