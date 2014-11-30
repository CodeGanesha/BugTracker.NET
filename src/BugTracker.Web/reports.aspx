<%@ Page language="C#" CodeBehind="reports.aspx.cs" Inherits="btnet.reports" AutoEventWireup="True" %>
<%@ Register TagPrefix="uc1" Namespace="btnet.Controls" Assembly="BugTracker.Web" %>

<!--
Copyright 2002-2011 Corey Trager
Distributed under the terms of the GNU General Public License
-->
<!-- #include file = "inc.aspx" -->

<script language="C#" runat="server">


DataSet ds;

Security security;

void Page_Load(Object sender, EventArgs e)
{

	Util.do_not_cache(Response);
	

	if (security.user.is_admin || security.user.can_use_reports || security.user.can_edit_reports)
	{
		//
	}
	else
	{
		Response.Write ("You are not allowed to use this page.");
		Response.End();
	}

	titl.InnerText = Util.get_setting("AppTitle","BugTracker.NET") + " - "
		+ "reports";

	SQLString sql;
    	if (security.user.is_admin || security.user.can_edit_reports)
	{
sql = new SQLString(@"
select
rp_desc [report],
case
	when rp_chart_type = 'pie' then
		'<a target=''_blank'' href=''view_report.aspx?view=chart&id=' + convert(varchar, rp_id) + '''>pie</a>'
	when rp_chart_type = 'line' then
		'<a target=''_blank'' href=''view_report.aspx?view=chart&id=' + convert(varchar, rp_id) + '''>line</a>'
	when rp_chart_type = 'bar' then
		'<a target=''_blank'' href=''view_report.aspx?view=chart&id=' + convert(varchar, rp_id) + '''>bar</a>'
	else
		'&nbsp;' end [view<br>chart],
'<a target=''_blank'' href=''view_report.aspx?view=data&id=' + convert(varchar, rp_id) + '''>data</a>' [view<br>data],
'<a href=''edit_report.aspx?id=' + convert(varchar, rp_id) + '''>edit</a>' [edit], 
'<a href=''delete_report.aspx?id=' + convert(varchar, rp_id) + '''>delete</a>' [delete]
from reports order by rp_desc");

	} else {
        sql = new SQLString(@"
select
rp_desc [report],
case
	when rp_chart_type = 'pie' then
		'<a target=''_blank'' href=''view_report.aspx?view=chart&id=' + convert(varchar, rp_id) + '''>pie</a>'
	when rp_chart_type = 'line' then
		'<a target=''_blank'' href=''view_report.aspx?view=chart&id=' + convert(varchar, rp_id) + '''>line</a>'
	when rp_chart_type = 'bar' then
		'<a target=''_blank'' href=''view_report.aspx?view=chart&id=' + convert(varchar, rp_id) + '''>bar</a>'
	else
		'&nbsp;' end [view<br>chart],
'<a target=''_blank'' href=''view_report.aspx?view=data&id=' + convert(varchar, rp_id) + '''>data</a>' [view<br>data]
from reports order by rp_desc");
	}

    ds = btnet.DbUtil.get_dataset(sql);

}


</script>

<html>
<head>
<title id="titl" runat="server">btnet reports</title>
<link rel="StyleSheet" href="btnet.css" type="text/css">
<script type="text/javascript" language="JavaScript" src="sortable.js"></script>
</head>

<body>
<uc1:MainMenu runat="server" ID="MainMenu" SelectedItem="reports"/>

<div class=align>
</p>

<% if (security.user.is_admin || security.user.can_edit_reports) { %>
<a href='edit_report.aspx'>add new report</a>&nbsp;&nbsp;&nbsp;&nbsp;
<% } %>

<a href='dashboard.aspx'>dashboard</a>

<%

if (ds.Tables[0].Rows.Count > 0)
{
	SortableHtmlTable.create_from_dataset(
		Response, ds, "", "", false);

}
else
{
	Response.Write ("No reports in the database.");
}

%>
</div>
<% Response.Write(Application["custom_footer"]); %></body>
</html>
