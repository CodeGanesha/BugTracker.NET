<%@ Page language="C#" CodeBehind="delete_comment.aspx.cs" Inherits="btnet.delete_comment" AutoEventWireup="True" %>
<%@ Register TagPrefix="uc1" Namespace="btnet.Controls" Assembly="BugTracker.Web" %>

<!--
Copyright 2002-2011 Corey Trager
Distributed under the terms of the GNU General Public License
-->
<!-- #include file = "inc.aspx" -->

<script language="C#" runat="server">


SQLString sql;

Security security;

void Page_Init (object sender, EventArgs e) {ViewStateUserKey = Session.SessionID;}

///////////////////////////////////////////////////////////////////////
void Page_Load(Object sender, EventArgs e)
{

    MainMenu.SelectedItem = Util.get_setting("PluralBugLabel", "bugs");
	Util.do_not_cache(Response);
	
	if (security.user.is_admin || security.user.can_edit_and_delete_posts)
	{
		//
	}
	else
	{
		Response.Write ("You are not allowed to use this page.");
		Response.End();
	}

	if (IsPostBack)
	{
		// do delete here

		sql = new SQLString(@"delete bug_posts where bp_id = @bpid");
        sql = sql.AddParameterWithValue("bpid", Util.sanitize_integer(row_id.Value));
		btnet.DbUtil.execute_nonquery(sql);
		Response.Redirect ("edit_bug.aspx?id=" + btnet.Util.sanitize_integer(redirect_bugid.Value));
	}
	else
	{

		string bug_id = Util.sanitize_integer(Request["bug_id"]);
		redirect_bugid.Value = bug_id;

		int permission_level = btnet.Bug.get_bug_permission_level(Convert.ToInt32(bug_id), security);
		if (permission_level != Security.PERMISSION_ALL)
		{
			Response.Write("You are not allowed to edit this item");
			Response.End();
		}

		titl.InnerText = Util.get_setting("AppTitle","BugTracker.NET") + " - "
			+ "delete comment";

		string id = Util.sanitize_integer(Request["id"]);

		back_href.HRef = "edit_bug.aspx?id=" + bug_id;

		sql = new SQLString(@"select bp_comment from bug_posts where bp_id = @bpid");
		sql = sql.AddParameterWithValue("bpid", id);

		DataRow dr = btnet.DbUtil.get_datarow(sql);

		// show the first few chars of the comment
		string s = Convert.ToString(dr["bp_comment"]);
		int len = 20;
		if (s.Length < len) {len = s.Length;}

		confirm_href.InnerText = "confirm delete of comment: "
				+ s.Substring(0,len)
				+ "...";

		row_id.Value = id;
	}


}

</script>

<html>
<head>
<title id="titl" runat="server">btnet edit attachment</title>
<link rel="StyleSheet" href="btnet.css" type="text/css">
</head>
<body>
<uc1:MainMenu runat="server" ID="MainMenu"/>
<p>
<div class=align>
<p>&nbsp</p>
<a id="back_href" runat="server" href="">back to <% Response.Write(Util.get_setting("SingularBugLabel","bug")); %></a>

<p>or<p>

<script>
function submit_form()
{
    var frm = document.getElementById("frm");
    frm.submit();
    return true;
}

</script>
<form runat="server" id="frm">
<a id="confirm_href" runat="server" href="javascript: submit_form()"></a>
<input type="hidden" id="row_id" runat="server">
<input type="hidden" id="redirect_bugid" runat="server">
</form>


</div>
<% Response.Write(Application["custom_footer"]); %></body>
</html>


