<%@ Page Language="C#" AutoEventWireup="true" CodeFile="IframePreview.aspx.cs" Inherits="myazh_PreviewPosting" %>
<%@ Register Namespace="AZHControls" TagPrefix="azh" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>

	<title>A Zillion Homes</title>
	<meta http-equiv="content-type" content="text/html; charset=iso-8859-1" />
	<meta name="keywords" content="" />
	<meta name="description" content="" />
	<meta name="robots" content="all" />
	<meta name="revisit-after" content="10 days" />
	<meta name="distribution" content="global" />
	<meta http-equiv="Content-Language" content="en-us" />
	<meta name="language" content="English" />
	<meta name="copyright" content="Copyright 2008 - A Zillion Homes" />
	<link href="http://www.azillionhomes.com/" rel="top" />
	<link href="http://www.azillionhomes.com/site-map.htm" rel="toc" />

	<style type="text/css">
		@import "/includes/css/base.css";
		@import "/includes/css/navigation.css";
		@import "/includes/css/interface.css";
		@import "/includes/css/content.css";
		@import "/includes/css/search-detail.css";
		
		/* reset some styles for iframe display */
		body { background-image: none; background-color: #fff; }
		#envelope { width: 602px; background: none; margin: 0; }
		#contentArea { width: 602px; margin: 0; padding: 0; background: none; }
		#content { width: 602px; border: none; margin: 0; padding: 0; background: none; }
		#mainFocusDetails { margin: 0; }
	</style>
	
	<link rel="stylesheet" type="text/css" href="/includes/css/print.css" media="print" />
	<script type="text/javascript">
	<!--
	sFolderLevel = "../";
	//-->
	</script>
	<script src="/includes/js/functions.js" type="text/javascript"></script>
	<script language="javascript" type="text/javascript" src="/includes/js/imageSwap.js"></script>
	<script language="javascript" type="text/javascript" src="/includes/js/postingTabs.js"></script>
</head>
<body>
<form runat="server">
<a name="top"></a>
    <div id="envelope">

	    <!-- content area container starts here -->
	    <div id="contentArea">
    	
		    <!-- content starts here -->
		    <div id="content">
                <azh:Posting ID="previewPost" runat="server" PreviewMode="true" />
		    </div>
	    </div>
    </div>
</form>
</body>
</html>
