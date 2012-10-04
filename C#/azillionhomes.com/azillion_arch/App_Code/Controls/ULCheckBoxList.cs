using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;
using System.Web.UI;

namespace AZHControls
{
    /// <summary>
    /// Summary description for ULCheckBoxList
    /// </summary>
    public class ULCheckBoxList : CheckBoxList
    {
        protected override void Render(HtmlTextWriter writer)
        {
            // We start our un-ordered list tag.
            writer.WriteBeginTag("ul");

            // If the CssClass property has been assigned, we will add
            // the attribute here in our <ul> tag.
            if (this.CssClass.Length > 0)
            {
                writer.WriteAttribute("class", this.CssClass);
            }

            // We need to close off the <ul> tag, but we are not ready
            // to add the closing </ul> tag yet.
            writer.Write(">");

            // Now we will render each child item, which in this case
            // would be our checkboxes.
            for (int i = 0; i < this.Items.Count; i++)
            {
                // We start the <li> (list item) tag.
                writer.WriteFullBeginTag("li");

                this.RenderItem(ListItemType.Item, i, new RepeatInfo(), writer);

                // Close the list item tag. Some people think this is not
                // necessary, but it is for both XHTML and semantic reasons.
                writer.WriteEndTag("li");
            }

            // We finish off by closing our un-ordered list tag.
            writer.WriteEndTag("ul");
        }
    }
}