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
using System.Security.Principal;

/// <summary>
/// Summary description for UserAPI
/// </summary>
public class UserAPI
{
    #region Data Access Methods

    public static int Insert(int userTypeID, string username, string password, string firstName, string lastName, string securityQuestion, string securityAnswer)
    {
        return Insert(userTypeID, username, password, firstName, lastName, securityQuestion, securityAnswer, 0);
    }

    public static int Insert(int userTypeID, string username, string password, string firstName, string lastName, string securityQuestion, string securityAnswer, int agencyID)
    {
        string encodedPassword = FormsAuthentication.HashPasswordForStoringInConfigFile(password, "SHA1");
        string confirmCode = new Guid().ToString().Substring(0, 10);
        UserInfo newUser = new UserInfo { 
            UserTypeID = userTypeID, 
            AgencyID = agencyID, 
            Login = username, 
            Password = encodedPassword, 
            FirstName = firstName, 
            LastName = lastName, 
            SecurityQuestion = securityQuestion, 
            SecurityAnswer = securityAnswer, 
            LastLogin = DateTime.Now, 
            ConfimCode = confirmCode };
        return Insert(newUser);
    }

    public static int Insert(UserInfo newUser)
    {
        DataClassesDataContext context = new DataClassesDataContext();
        context.UserInfos.InsertOnSubmit(newUser);
        context.SubmitChanges();
        return newUser.UserInfoID;
    }

    public static bool Update(int userInfoId, int userTypeID, string username, string firstName, string lastName, string securityQuestion, string securityAnswer, int agencyID)
    {
        DataClassesDataContext context = new DataClassesDataContext();
        UserInfo updateUser = context.UserInfos.Single(n => n.UserInfoID == userInfoId);
        if(userTypeID > 0)
            updateUser.UserTypeID = userTypeID;
        if(!string.IsNullOrEmpty(username))
            updateUser.Login = username;
        if(!string.IsNullOrEmpty(firstName))
            updateUser.FirstName = firstName;
        if(!string.IsNullOrEmpty(lastName))
            updateUser.LastName = lastName;
        if (!string.IsNullOrEmpty(securityQuestion))
            updateUser.SecurityQuestion = securityQuestion;
        if (!string.IsNullOrEmpty(securityAnswer))
            updateUser.SecurityAnswer = securityAnswer;
        if (agencyID > 0)
            updateUser.AgencyID = agencyID;
        try
        {
            context.SubmitChanges();
            return true;
        }
        catch
        {
            return false;
        }
    }

    #endregion Data Access Methods

    #region Authetication Methods

    public static void AuthenticateUser(string login, bool remember)
    {
        DataClassesDataContext context = new DataClassesDataContext();
        UserInfo currentUser = context.UserInfos.Single(n => n.Login == login);
        HttpContext.Current.Session.Add("azhuserid", currentUser.UserInfoID);
        HttpContext.Current.Session.Add("azhuser", login);
        if (remember)
        {
            HttpCookie remCookie = new HttpCookie("azhuser", login);
            HttpContext.Current.Response.Cookies.Add(remCookie);
        }
    }

    public static bool VerifyUser()
    {
        if (HttpContext.Current.Session["azhuser"] != null)
        {
            return true;
        }
        else
        {
            if (HttpContext.Current.Request.Cookies.AllKeys.Contains("azhuser"))
            {
                string login = HttpContext.Current.Request.Cookies["azhuser"].Value;
                DataClassesDataContext context = new DataClassesDataContext();
                UserInfo currentUser = context.UserInfos.Single(n => n.Login == login);
                HttpContext.Current.Session.Add("azhuserid", currentUser.UserInfoID);
                HttpContext.Current.Session.Add("azhuser", login);
                return true;
            }
            else
            {
                return false;
            }
        }
    }

    public static void Logout()
    {
        FormsAuthentication.SignOut();
    }

    #endregion Authentication Methods

    #region Static Methods

    public static UserInfo GetUserByLogin(string login)
    {
        DataClassesDataContext context = new DataClassesDataContext();
        return context.UserInfos.Single(n => n.Login == login);
    }

    #endregion Static Methods
}
