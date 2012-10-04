using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using AjaxControlToolkit;
using System.Web.UI;
using System.Collections.Specialized;

namespace AZHControls
{
    /// <summary>
    /// Summary description for AZHField
    /// </summary>
    public class AZHField : CompositeControl
    {
        public AZHField()
        {
        }
        public AZHField(int formFieldID)
        {
            FormFieldID = formFieldID;
            LoadFormField();
        }
        public string Value
        {
            get
            {
                if (ViewState["Value"] != null)
                {
                    return (string)ViewState["Value"];
                }
                else
                {
                    return string.Empty;
                }
            }
            set { ViewState["Value"] = value; }
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

        private int __FormFieldID = 0;
        public int FormFieldID
        {
            get
            {
                if (ViewState["FormFieldID"] != null)
                {
                    return (int)ViewState["FormFieldID"];
                }
                else
                {
                    return __FormFieldID;
                }
            }
            set 
            {
                __FormFieldID = value;
                ViewState["FormFieldID"] = value;
            }
        }

        public string FormFieldType
        {
            get
            {
                if (ViewState["FormFieldType"] != null)
                {
                    return (string)ViewState["FormFieldType"];
                }
                else
                {
                    return "TextBox";
                }
            }
            set { ViewState["FormFieldType"] = value; }
        }
        public string FieldName
        {
            get
            {
                if (ViewState["FieldName"] != null)
                {
                    return (string)ViewState["FieldName"];
                }
                else
                {
                    return "FieldName";
                }
            }
            set { ViewState["FieldName"] = value; }
        }
        public bool AltRow
        {
            get
            {
                if (ViewState["AltRow"] != null)
                {
                    return (bool)ViewState["AltRow"];
                }
                else
                {
                    return false;
                }
            }
            set { ViewState["AltRow"] = value; }
        }
        public bool Required
        {
            get
            {
                if (ViewState["Required"] != null)
                {
                    return (bool)ViewState["Required"];
                }
                else
                {
                    return false;
                }
            }
            set { ViewState["Required"] = value; }
        }
        public string AllowedValues
        {
            get
            {
                if (ViewState["AllowedValues"] != null)
                {
                    return (string)ViewState["AllowedValues"];
                }
                else
                {
                    return string.Empty;
                }
            }
            set { ViewState["AllowedValues"] = value; }
        }
        public string DefaultValue
        {
            get
            {
                if (ViewState["DefaultValue"] != null)
                {
                    return (string)ViewState["DefaultValue"];
                }
                else
                {
                    return string.Empty;
                }
            }
            set { ViewState["DefaultValue"] = value; }
        }
        public string Suffix
        {
            get
            {
                if (ViewState["Suffix"] != null)
                {
                    return (string)ViewState["Suffix"];
                }
                else
                {
                    return string.Empty;
                }
            }
            set { ViewState["Suffix"] = value; }
        }
        public string ValueFormat
        {
            get
            {
                if (ViewState["ValueFormat"] != null)
                {
                    return (string)ViewState["ValueFormat"];
                }
                else
                {
                    return string.Empty;
                }
            }
            set { ViewState["ValueFormat"] = value; }
        }

        public bool ShowError
        {
            get
            {
                if (ViewState["ShowError"] != null)
                {
                    return (bool)ViewState["ShowError"];
                }
                else
                {
                    return true;
                }
            }
            set { ViewState["ShowError"] = value; }
        }
        public int MaxLength
        {
            get
            {
                if (ViewState["MaxLength"] != null)
                {
                    return (int)ViewState["MaxLength"];
                }
                else
                {
                    return 0;
                }
            }
            set { ViewState["MaxLength"] = value; }

        }
        public int ZIndex
        {
            get
            {
                if (ViewState["ZIndex"] != null)
                {
                    return (int)ViewState["ZIndex"];
                }
                else
                {
                    return 0;
                }
            }
            set { ViewState["ZIndex"] = value; }
        }
        
        protected override HtmlTextWriterTag TagKey
        {
            get
            {
                return HtmlTextWriterTag.Div;
            }
        }

        public event EventHandler ValueChanged;

        protected virtual void OnValueChanged(EventArgs e)
        {
            if (ValueChanged != null)
                ValueChanged(this, e);
        }

        private WebControl fieldControl;
        private HtmlGenericControl htmLabel;
        private HtmlGenericControl htmSpan;
        private HtmlGenericControl htmMaxLength;
        private HtmlGenericControl htmPopupWrapper;
        private RequiredFieldValidator reqField;
        private RegularExpressionValidator regField;
        private CompareValidator regType;
        private CalendarExtender datePopup;
        private HelpButton helpButton;

        protected override void CreateChildControls()
        {
            CreateFieldControl();
            htmLabel = new HtmlGenericControl { ID = "htmLabel", TagName = "label" };
            htmLabel.Attributes.Add("for", fieldControl.ClientID);
            htmSpan = new HtmlGenericControl { ID = "htmSpan", TagName = "span" };
            htmSpan.Attributes.Add("class", "required");
            htmSpan.InnerText = "*";
            htmMaxLength = new HtmlGenericControl { ID = "htmMax", TagName = "span" };
            htmMaxLength.Attributes.Add("class", "max");
            htmMaxLength.InnerText = MaxLength.ToString() + " characters allowed";
            htmPopupWrapper = new HtmlGenericControl("div");
            htmPopupWrapper.Attributes.Add("style", "z-index:10000000;position:relative;");
            reqField = new RequiredFieldValidator { ID = "reqField", ControlToValidate = ID + "_fieldControl", Display = ValidatorDisplay.Dynamic, ValidationGroup= ValidationGroup, CssClass="errorMessage", SetFocusOnError = true };
            regField = new RegularExpressionValidator { ID = "regField", ControlToValidate = ID + "_fieldControl", Display = ValidatorDisplay.Dynamic, ValidationGroup = ValidationGroup, CssClass = "errorMessage", SetFocusOnError = true };
            regType = new CompareValidator { ID = "regType", ControlToValidate = ID + "_fieldControl", Display = ValidatorDisplay.Dynamic, ValidationGroup = ValidationGroup, CssClass = "errorMessage", SetFocusOnError = true };
            helpButton = new HelpButton { ID = "helpButton" };

            datePopup = new CalendarExtender { ID = "datePopup", TargetControlID = fieldControl.ID };
            Controls.Add(htmSpan);
            Controls.Add(htmLabel);
            Controls.Add(fieldControl);
            
            if(Required && (FormFieldType.Contains("TextBox") || FormFieldType.Contains("Date")))
                Controls.Add(reqField);
            if (ValueFormat.Contains("Number"))
            {
                regType.Operator = ValidationCompareOperator.DataTypeCheck;
                regType.Type = ValidationDataType.Double;
                regType.ErrorMessage = FieldName + " must be a number";
                Controls.Add(regType);
            }
            if (FormFieldType == "Date")
            {
                htmPopupWrapper.Controls.Add(datePopup);
            }
            if (ZIndex > 0)
            {
                this.Attributes.Add("style", "z-index:" + ZIndex.ToString() + ";");
            }
            
            if (MaxLength > 0)
            {
                Controls.Add(htmMaxLength);
            }
            htmPopupWrapper.Controls.Add(helpButton);
            Controls.Add(htmPopupWrapper);
        }

        protected override void OnPreRender(EventArgs e)
        {
            EnsureChildControls();
            ScriptManager myScriptManager = Page.Master.FindControl("ScriptManager1") as ScriptManager;
            base.OnPreRender(e);
        }

        protected override void Render(System.Web.UI.HtmlTextWriter writer)
        {
            if (FormFieldID > 0)
                LoadFormField();
            
            htmLabel.InnerText = FieldName;
            if (Required)
            {
                if (!ShowError)
                    reqField.Display = ValidatorDisplay.None;
                if (FormFieldType.Contains("TextBox") || FormFieldType.Contains("Date"))
                {
                    reqField.Enabled = true;
                    reqField.ErrorMessage = FieldName + " is required";
                }
            }
            else
            {
                Controls.Remove(htmSpan);
                Controls.Remove(reqField);
            }

            if (!string.IsNullOrEmpty(ToolTip))
            {
                helpButton.Title = "Help for " + FieldName;
                helpButton.Message = ToolTip;
            }
            else
            {
                htmPopupWrapper.Controls.Remove(helpButton);
            }
            switch (FormFieldType)
            {
                case "TextBox:Password":
                    if(Page.IsPostBack)
                        ((TextBox)fieldControl).Attributes.Add("value", Value);
                    ((TextBox)fieldControl).Text = Value;
                    break;
                case "TextBox:SingleLine":
                case "TextBox:MultiLine":
                    ((TextBox)fieldControl).Text = Value;
                    break;
                case "DropDownList":
                    try
                    {
                        if (!string.IsNullOrEmpty(Value))
                            ((DropDownList)fieldControl).SelectedValue = Value;
                    }
                    catch
                    {
                        //Prevents exception when default value no longer exists in list
                    }
                    break;
                case "Checkbox":
                    ((CheckBox)fieldControl).Checked = Value == "True";
                    break;
                case "CheckboxList":
                    string[] values = Value.Split(new string[] { ":" }, StringSplitOptions.RemoveEmptyEntries);
                    foreach (ListItem item in ((ULCheckBoxList)fieldControl).Items)
                    {
                        if (values.Contains(item.Value))
                        {
                            item.Selected = true;
                        }
                    }
                    break;
                case "Dimensions":
                case "Dimensions:Normal":
                case "Dimensions:Mobile":
                    ((DimensionEditor)fieldControl).DimensionValues = Value;
                    break;
                case "Date":
                    if (string.IsNullOrEmpty(Value))
                        Value = DateTime.Now.ToShortDateString();
                    if (Value == "blank")
                        ((TextBox)fieldControl).Text = "";
                    else
                        ((TextBox)fieldControl).Text = Value;
                    break;
                case "Yes/No":
                    if (Value == "Yes" || Value == "1")
                    {
                        ((ULRadioButtonList)fieldControl).Items[0].Selected = true;
                    }
                    else
                    {
                        ((ULRadioButtonList)fieldControl).Items[1].Selected = true;
                    }
                    break;
                default:
                    break;
            }
            SetFieldValue();
            CssClass += " formRow";
            if (AltRow)
                CssClass += " altRowColor";
            base.Render(writer);
        }

        protected void LoadFormField()
        {
            DataClassesDataContext context = new DataClassesDataContext();
            FormField currentField = context.FormFields.Single(n => n.FormFieldID == FormFieldID);
            FormFieldType = currentField.FieldType.RenderControl;
            ValueFormat = currentField.FieldType.ValueFormat.FormatName;
            Required = currentField.Required;
            FieldName = currentField.Name;
            if(string.IsNullOrEmpty(Value))
                Value = currentField.DefaultValue;
            ToolTip = currentField.ToolTip;
            AllowedValues = currentField.AllowedValues;
            DefaultValue = currentField.DefaultValue;
            Suffix = currentField.Suffix;
            if (!string.IsNullOrEmpty(Value) && !string.IsNullOrEmpty(Suffix))
                Value = Value.Replace(Suffix, "");
        }

        protected void CreateFieldControl()
        {
            if(FormFieldID > 0)
                LoadFormField();
            string[] ddlValues;
            switch (FormFieldType)
            {
                case "TextBox:SingleLine":
                case "Date":
                    fieldControl = new TextBox();
                    ((TextBox)fieldControl).TextChanged += new EventHandler(AZHField_Changed);
                    ((TextBox)fieldControl).ValidationGroup = ValidationGroup;
                    break;
                case "TextBox:MultiLine":
                    CssClass += " defaultTextArea";
                    fieldControl = new TextBox { TextMode = TextBoxMode.MultiLine};
                    ((TextBox)fieldControl).TextChanged += new EventHandler(AZHField_Changed);
                    ((TextBox)fieldControl).ValidationGroup = ValidationGroup;
                    break;
                case "TextBox:Password":
                    fieldControl = new TextBox { TextMode = TextBoxMode.Password };
                    ((TextBox)fieldControl).TextChanged += new EventHandler(AZHField_Changed);
                    ((TextBox)fieldControl).ValidationGroup = ValidationGroup;
                    break;
                case "DropDownList":
                    fieldControl = new DropDownList();
                    ((DropDownList)fieldControl).SelectedIndexChanged += new EventHandler(AZHField_Changed);
                    ((DropDownList)fieldControl).ValidationGroup = ValidationGroup;
                    ddlValues = AllowedValues.Split(new string[]{":"}, StringSplitOptions.RemoveEmptyEntries);
                    foreach (string listValue in ddlValues)
                    {
                        ListItem newItem = new ListItem(listValue);
                        if (Value.Contains(listValue))
                        {
                            newItem.Selected = true;
                        }
                        ((DropDownList)fieldControl).Items.Add(newItem);
                    }
                    break;
                case "Checkbox":
                    fieldControl = new CheckBox();
                    if (DefaultValue == "True")
                        ((CheckBox)fieldControl).Checked = true;
                    ((CheckBox)fieldControl).CheckedChanged += new EventHandler(AZHField_Changed);
                    ((CheckBox)fieldControl).ValidationGroup = ValidationGroup;
                    break;
                case "CheckboxList":
                    fieldControl = new ULCheckBoxList { RepeatDirection = System.Web.UI.WebControls.RepeatDirection.Horizontal, RepeatLayout = RepeatLayout.Flow, CssClass = "checkBoxList" };
                    ((ULCheckBoxList)fieldControl).SelectedIndexChanged += new EventHandler(AZHField_Changed);
                    ((ULCheckBoxList)fieldControl).ValidationGroup = ValidationGroup;
                    ddlValues = AllowedValues.Split(new string[] { ":" }, StringSplitOptions.RemoveEmptyEntries);
                    foreach (string listValue in ddlValues)
                    {
                        ListItem newItem = new ListItem(listValue);
                        if (Value.Contains(listValue))
                        {
                            newItem.Selected = true;
                        }
                        ((ULCheckBoxList)fieldControl).Items.Add(newItem);
                    }
                    break;
                case "Dimensions":
                case "Dimensions:Normal":
                    fieldControl = new DimensionEditor { ID = "dimensionEditor" };
                    ((DimensionEditor)fieldControl).ValueChanged += new EventHandler(AZHField_Changed);
                    ((DimensionEditor)fieldControl).ValidationGroup = ValidationGroup;
                    break;
                case "Dimensions:Mobile":
                    fieldControl = new DimensionEditor { ID = "dimensionEditor" };
                    ((DimensionEditor)fieldControl).ValueChanged += new EventHandler(AZHField_Changed);
                    ((DimensionEditor)fieldControl).ValidationGroup = ValidationGroup;
                    ((DimensionEditor)fieldControl).DimensionType = DimensionTypes.Mobile;
                    break;
                case "Yes/No":
                    fieldControl = new ULRadioButtonList  { ID = "yesNo", RepeatLayout = RepeatLayout.Flow, RepeatDirection = System.Web.UI.WebControls.RepeatDirection.Horizontal, CssClass = "radioList" };
                    ((ULRadioButtonList)fieldControl).Items.Add(new ListItem { Text = "Yes", Value = "True" });
                    ((ULRadioButtonList)fieldControl).Items.Add(new ListItem { Text = "No", Value = "False" });
                    ((ULRadioButtonList)fieldControl).SelectedIndexChanged += new EventHandler(AZHField_Changed);
                    ((ULRadioButtonList)fieldControl).ValidationGroup = ValidationGroup;
                    break;
                default:
                    FormFieldType = "TextBox:SingleLine";
                    fieldControl = new TextBox();
                    ((TextBox)fieldControl).TextChanged += new EventHandler(AZHField_Changed);
                    ((TextBox)fieldControl).ValidationGroup = ValidationGroup;
                    break;
            }
            fieldControl.ID = ID + "_fieldControl";
        }

        void AZHField_Changed(object sender, EventArgs e)
        {
            string newValue = Value;
            if (FormFieldType.Contains("TextBox") || FormFieldType.Contains("Date"))
            {
                newValue = ((TextBox)fieldControl).Text;
                if (!string.IsNullOrEmpty(Suffix) && !string.IsNullOrEmpty(newValue))
                {
                    if (!newValue.Contains(Suffix))
                    {
                        newValue += Suffix;
                    }
                }
            }
            if (FormFieldType == "Checkbox")
            {
                newValue = ((CheckBox)fieldControl).Checked.ToString();
            }
            if (FormFieldType == "CheckboxList")
            {
                newValue = "";
                foreach (ListItem item in ((ULCheckBoxList)fieldControl).Items)
                {
                    if (item.Selected)
                    {
                        newValue += item.Value + ":";
                    }
                }
            }
            if (FormFieldType == "DropDownList")
            {
                newValue = ((DropDownList)fieldControl).SelectedValue;
            }
            if (FormFieldType.Contains("Dimensions"))
            {
                newValue = ((DimensionEditor)fieldControl).DimensionValues;
            }
            if (FormFieldType == "Yes/No")
            {
                newValue = ((RadioButtonList)fieldControl).SelectedValue;
            }
            if (newValue != Value)
            {
                Value = newValue;
                OnValueChanged(EventArgs.Empty);
            }
        }

        public string GetFieldValue()
        {
            if (fieldControl == null)
            {
                return string.Empty;
            }
            string newValue = Value;
            if (FormFieldType.Contains("TextBox"))
            {
                return ((TextBox)fieldControl).Text;
            }
            if (FormFieldType == "Checkbox")
            {
                return ((CheckBox)fieldControl).Checked.ToString();
            }
            if (FormFieldType == "CheckboxList")
            {
                newValue = "";
                foreach (ListItem item in ((ULCheckBoxList)fieldControl).Items)
                {
                    if (item.Selected)
                    {
                        newValue += item.Value + ":";
                    }
                }
                return newValue;
            }
            if (FormFieldType == "DropDownList")
            {
                return ((DropDownList)fieldControl).SelectedValue;
            }
            if (FormFieldType.Contains("Dimensions"))
            {
                return ((DimensionEditor)fieldControl).DimensionValues;
            }
            if (FormFieldType == "Yes/No")
            {
                return ((RadioButtonList)fieldControl).SelectedValue;
            }
            return Value;
        }

        protected void SetFieldValue()
        {
        }
    }
}