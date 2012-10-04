<%@ Page Title="" Language="C#" MasterPageFile="~/main.master" AutoEventWireup="true" CodeFile="Investors.aspx.cs" Inherits="AboutUs_Investors" %>

<asp:Content ID="headContent" runat="server" ContentPlaceHolderID="headContent">
    <style type="text/css">
		@import "/includes/css/secondary.css";
	</style>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="mainContent" runat="server">
			<h1><span>About Us</span></h1>
			
			<!-- innerContent added to add padding around content -->
			<div id="innerContent">
			
				<ul id="jumpLinks">
					<li><strong>About Us:</strong></li>
			        <li class="overview"><a href="Default.aspx">Overview</a></li>
			        <li><a href="Benefits.aspx">Benefits</a></li>
			        <li><a href="Pricing.aspx">Pricing</a></li>
			        <li class="last"><a href="Investors.aspx" id="selectedPage">Investors</a></li>
				</ul>
				
				<div id="introText">Etiam sit amet lorem a velit volutpat interdum. Etiam a lectus ut libero tincidunt consectetuer. Fusce a diam. Integer et arcu. Sed ante elit, placerat auctor, interdum ac, egestas a, orci. Mauris felis. Sed luctus dui vel orci. Nulla facilisi. Nam lobortis.</div>
				
				<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec et sapien. Proin sed mi et mauris tincidunt semper. Nunc diam. Duis massa magna, nonummy nec, convallis ac, ultricies a, elit. Maecenas eu dolor. Curabitur in mauris nec quam elementum iaculis. Pellentesque id nulla vitae enim placerat egestas. Phasellus sit amet mauris. Integer magna nunc, mollis sit amet, varius id, imperdiet vel, orci. Phasellus eros quam, blandit ac, nonummy sit amet, tempus in, nulla. Phasellus pulvinar enim sed eros. Nulla id augue. Donec auctor, tortor ultrices eleifend egestas, nisi est nonummy felis, eget elementum nisl metus vitae ipsum. Fusce sit amet felis. Vestibulum id sapien. Curabitur pellentesque elit nec tellus.</p>
			
				<p class="noDots">Proin nisl ante, semper sit amet, iaculis et, euismod sed, erat. Sed tincidunt purus ac magna. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos. Nunc pellentesque iaculis sapien. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos. Cras id tortor. Sed interdum tortor. Fusce ac nunc. Mauris scelerisque ultrices quam. Donec ac nibh. Integer venenatis venenatis ante. Praesent sit amet tellus. Ut tempor. Vestibulum eleifend, ante eu egestas tincidunt, libero mi tempus orci, vel consequat magna justo sit amet augue. Pellentesque sapien dui, fermentum sed, dictum ut, aliquet at, neque.</p>
							
			</div>
</asp:Content>
