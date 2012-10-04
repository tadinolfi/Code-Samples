using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;
using System.Web.UI;
using System.Collections.Specialized;
using System.Drawing;
using System.Collections;

namespace AZHControls
{
    public enum DimensionTypes
    {
        Normal,
        Mobile
    }

    public class DimensionEditor : CompositeControl, IPostBackDataHandler
    {
        public string DimensionValues
        {
            get
            {
                if (ViewState["DimensionValues"] != null)
                {
                    return (string)ViewState["DimensionValues"];
                }
                else
                {
                    return string.Empty;
                }
            }
            set { ViewState["DimensionValues"] = value; }
        }

        public string ValidationGroup
        {
            get
            {
                if (ViewState["ValidationGroup"] != null)
                {
                    return (string)ViewState["ValidationGroup"];
                }
                else
                {
                    return string.Empty;
                }
            }
            set { ViewState["ValidationGroup"] = value; }
        }

        public DimensionTypes DimensionType
        {
            get
            {
                if (ViewState["DimensionType"] != null)
                {
                    return (DimensionTypes)ViewState["DimensionType"];
                }
                else
                {
                    return DimensionTypes.Normal;
                }
            }
            set { ViewState["DimensionType"] = value; }
        }

        public event EventHandler ValueChanged;

        public virtual bool LoadPostData(string postDataKey, NameValueCollection postCollection)
        {
            if (DimensionValues != FormatValue())
            {
                DimensionValues = FormatValue();
                return true;
            }
            else
            {
                return false;
            }
        }

        public virtual void RaisePostDataChangedEvent()
        {
            OnValueChanged(EventArgs.Empty);
        }

        protected string FormatValue()
        {
            string values = "";
            for (int i = 0; i < txtDimensions.Count; i++)
            {
                if (!string.IsNullOrEmpty(txtDimensions[i].Text) && !string.IsNullOrEmpty(txtLength[i].Text))
                {
                    string value = txtDimensions[i].Text + ":" + txtWidth[i].Text + ":" + txtLength[i].Text + "|";
                    values += value;
                }
            }
            return values;
        }


        protected virtual void OnValueChanged(EventArgs e)
        {
            if (ValueChanged != null)
                ValueChanged(this, e);
        }

        protected override HtmlTextWriterTag TagKey
        {
            get
            {
                return HtmlTextWriterTag.Div;
            }
        }

        protected override void OnPreRender(EventArgs e)
        {
            base.OnPreRender(e);
            Page.RegisterRequiresPostBack(this);
        }

        private HiddenField hidValue;
        private Panel pnlDimensions;
        private Table tblValues;
        private List<TextBox> txtDimensions;
        private List<TextBox> txtWidth;
        private List<TextBox> txtLength;
        private string[] normalRooms = new string[]
        {
            "Dining Room",
            "Living Room",
            "Family Room",
            "Kitchen",
            "Master Bedroom",
            "Bedroom 2",
            "Bedroom 3",
            "Bedroom 4",
            "Bedroom 5",
            "Den",
            "Office",
            "Exercise Room",
            "Media Room"
        };
        private string[] mobileRooms = new string[]
        {
            "Dining Room",
            "Living Room",
            "Family Room",
            "Kitchen",
            "Master Bedroom",
            "Bedroom 2",
            "Bedroom 3",
            "Den",
            "Office"
        };
        private string[] baseRooms
        {
            get
            {
                string[] retVal = new string[1];
                switch (DimensionType)
                {
                    case DimensionTypes.Normal:
                        retVal = normalRooms;
                        break;
                    case DimensionTypes.Mobile:
                        retVal = mobileRooms;
                        break;
                }
                return retVal;
            }
        }
        private int numberOtherRooms = 5;

        protected override void CreateChildControls()
        {
            hidValue = new HiddenField { ID = UniqueID };
            pnlDimensions = new Panel { ID = "pnlDimensions" };
            tblValues = new Table { CssClass = "dimTable" };
            pnlDimensions.Controls.Add(tblValues);

            txtDimensions = new List<TextBox>();
            txtWidth = new List<TextBox>();
            txtLength = new List<TextBox>();
            int index = 1;
            foreach (string room in baseRooms)
            {
                AddDimensionRow(index, room);
                index++;
            }
            for (int i = baseRooms.Count() + 1; i <= baseRooms.Count() + numberOtherRooms; i++)
            {
                AddDimensionRow(i, string.Empty);
            }
            pnlDimensions.Controls.Add(tblValues);
            Controls.Add(hidValue);
            Controls.Add(pnlDimensions);
        }

        protected void AddDimensionRow(int index, string roomName)
        {
            TableRow newRow = new TableRow();
            string fieldName = "";
            if (string.IsNullOrEmpty(roomName))
            {
                fieldName = "Room";
            }
            TableCell dimTextCell = new TableCell { Text = fieldName, CssClass = "header" };
            newRow.Cells.Add(dimTextCell);

            TableCell dimCtlCell = new TableCell();
            TextBox newDimension = new TextBox { ID = "txtDimension" + index.ToString() };
            newDimension.ValidationGroup = ValidationGroup;
            if (!string.IsNullOrEmpty(roomName))
            {
                newDimension.Text = roomName;
                newDimension.Visible = false;
                Label lblRoomName = new Label();
                lblRoomName.Text = roomName;
                lblRoomName.ForeColor = Color.LightGray;
                dimCtlCell.Controls.Add(lblRoomName);
            }

            dimCtlCell.Controls.Add(newDimension);
            newRow.Cells.Add(dimCtlCell);

            TableCell widTextCell = new TableCell { Text = "Width" };
            newRow.Cells.Add(widTextCell);

            TableCell widCtlCell = new TableCell();
            TextBox newWidth = new TextBox { ID = "txtWidth" + index.ToString(), Width = 30 };
            newWidth.ValidationGroup = ValidationGroup;
            widCtlCell.Controls.Add(newWidth);
            newRow.Cells.Add(widCtlCell);

            TableCell hgtTextCell = new TableCell { Text = "Length" };
            newRow.Cells.Add(hgtTextCell);

            TableCell hgtCtlCell = new TableCell();
            TextBox newLength = new TextBox { ID = "txtLength" + index.ToString(), Width = 30 };
            newLength.ValidationGroup = ValidationGroup;
            hgtCtlCell.Controls.Add(newLength);
            newRow.Cells.Add(hgtCtlCell);

            txtDimensions.Add(newDimension);
            txtWidth.Add(newWidth);
            txtLength.Add(newLength);

            tblValues.Rows.Add(newRow);
        }

        public override void RenderControl(HtmlTextWriter writer)
        {
            int otherRoomOffset = 0;
            string[] roomsArr = DimensionValues.Split(new string[] { "|" }, StringSplitOptions.RemoveEmptyEntries);
            foreach (string room in roomsArr)
            {
                string[] roomParts = room.Split(new char[] { ':' });
                string roomName = roomParts[0];
                string width = roomParts[1];
                string length = roomParts[2];
                if (baseRooms.Contains(roomName))
                {
                    int roomIndex = baseRooms.ToList().IndexOf(roomName);
                    txtDimensions[roomIndex].Text = roomName;
                    txtWidth[roomIndex].Text = width;
                    txtLength[roomIndex].Text = length;
                }
                else
                {
                    int roomIndex = baseRooms.Count() + otherRoomOffset;
                    txtDimensions[roomIndex].Text = roomName;
                    txtLength[roomIndex].Text = length;
                    txtWidth[roomIndex].Text = width;
                    otherRoomOffset++;
                }
            }
            base.RenderControl(writer);
        }
    }
}