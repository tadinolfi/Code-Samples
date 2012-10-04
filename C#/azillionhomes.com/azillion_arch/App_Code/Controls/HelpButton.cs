using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;
using AjaxControlToolkit;

namespace AZHControls
{
    /// <summary>
    /// Summary description for HelpButton
    /// </summary>
    public class HelpButton : CompositeControl
    {
        public string Title
        {
            get
            {
                if (ViewState["Title"] != null)
                {
                    return (string)ViewState["Title"];
                }
                else
                {
                    return string.Empty;
                }
            }
            set { ViewState["Title"] = value; }
        }

        public string Message
        {
            get
            {
                if (ViewState["Message"] != null)
                {
                    return (string)ViewState["Message"];
                }
                else
                {
                    return string.Empty;
                }
            }
            set { ViewState["Message"] = value; }
        }

        private LinkButton helpButton;
        private ModalPopupExtender popupExtender;
        private Panel pnlHelpMessage;
        private LinkButton closeButton;
        private Label lblTitle;
        private Label lblMessage;

        protected override void CreateChildControls()
        {
            helpButton = new LinkButton
            {
                ID = "helpButton",
                Text = "Help",
                CssClass = "helpIcon"
            };
            popupExtender = new ModalPopupExtender
            {
                ID = "popupExtender",
                DropShadow = false,
                BackgroundCssClass = "modalBackground",
                TargetControlID = "helpButton",
                PopupControlID = "pnlHelpMessage",
                CancelControlID = "closeButton"
            };
            pnlHelpMessage = new Panel
            {
                ID = "pnlHelpMessage",
                Width = 500,
                CssClass = "modalPopup helpPopup"
            };
            closeButton = new LinkButton
            {
                ID = "closeButton",
                Text = "close",
                CssClass = "closeIcon"
            };
            lblTitle = new Label { ID = "lblTitle", CssClass = "title" };
            lblMessage = new Label { ID = "lblMessage", CssClass = "message" };

            Controls.Add(helpButton);
            pnlHelpMessage.Controls.Add(closeButton);
            pnlHelpMessage.Controls.Add(lblTitle);
            pnlHelpMessage.Controls.Add(lblMessage);
            Controls.Add(pnlHelpMessage);
            Controls.Add(popupExtender);
        }

        public override void RenderControl(System.Web.UI.HtmlTextWriter writer)
        {
            lblTitle.Text = Title;
            lblMessage.Text = Message;
            base.RenderControl(writer);
        }
    }
}