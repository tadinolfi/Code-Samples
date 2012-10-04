using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI.HtmlControls;
using System.Web.UI;

namespace AZHCore
{
    public enum PageSection
    {
        General,
        Control,
        MyAZH,
        Rentals,
        Sales,
        Auctions,
        OpenHouses,
        AboutUs,
        SignUp,
        Login,
        Forum
    }

    public enum AZHSection
    {
        Overview,
        MyAccount,
        MyPosting,
        MyBilling
    }   

    public partial class AZHPage : System.Web.UI.Page
    {
        private PageSection __Section;
        private AZHSection __AdminSection;

        public PageSection Section
        {
            get
            {
                if (__Section == null)
                {
                    if (HttpContext.Current.Request.Url.AbsoluteUri.ToLower().Contains("/myazh/"))
                    {
                        return PageSection.MyAZH;
                    }
                    else
                    {
                        return PageSection.General;
                    }
                }
                else
                {
                    return __Section;
                }
            }
            set { __Section = value; }
        }

        public AZHSection AdminSection
        {
            get
            {
                if (__AdminSection == null)
                {
                    return AZHSection.Overview;
                }
                else
                {
                    return __AdminSection;
                }
            }
            set { __AdminSection = value; }
        }

        public bool ShowSearch
        {
            get
            {
                if (ViewState["ShowSearch"] != null)
                {
                    return (bool)ViewState["ShowSearch"];
                }
                else
                {
                    return true;
                }
            }
            set { ViewState["ShowSearch"] = value; }
        }

        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);
            MasterPage rootMaster;
            if (Master != null && Master.Master != null)
            {
                rootMaster = Master.Master;
            }
            else
            {
                rootMaster = Master;
            }
            if (rootMaster != null)
            {
                HtmlGenericControl bodyTag = rootMaster.FindControl("bodyTag") as HtmlGenericControl;
                switch (Section)
                {
                    case PageSection.AboutUs:
                        bodyTag.Attributes.Add("class", "aboutUsTemplate");
                        break;
                    case PageSection.Auctions:
                        bodyTag.Attributes.Add("class", "auctionsTemplate");
                        break;
                    case PageSection.Control:
                    case PageSection.MyAZH:
                        bodyTag.Attributes.Add("class", "myazhTemplate");
                        break;
                    case PageSection.Forum:
                        bodyTag.Attributes.Add("class", "forumTemplate");
                        break;
                    case PageSection.Login:
                        bodyTag.Attributes.Add("class", "loginTemplate");
                        break;
                    case PageSection.OpenHouses:
                        bodyTag.Attributes.Add("class", "openHousesTemplate");
                        break;
                    case PageSection.Rentals:
                        bodyTag.Attributes.Add("class", "rentalsTemplate");
                        break;
                    case PageSection.Sales:
                        bodyTag.Attributes.Add("class", "salesTemplate");
                        break;
                    case PageSection.SignUp:
                        bodyTag.Attributes.Add("class", "signUpTemplate");
                        break;
                }
            }
        }
    }
}