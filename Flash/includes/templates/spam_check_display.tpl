<script src="includes/js/jquery.js"></script>
<script>
	$(function() {
		var temp = '';
		if((temp = self.parent.getMessage()) == false) temp = '';
		$('#SpamCheck_Message').load('index.php?Page=Newsletters&Action=CheckSpam', temp);
	});
</script>
<style type="text/css" media="all">
	#SpamCheck_Container {
		padding: 0px;
		margin: 0px;
		width: auto;
	}

	#SpamCheck_Message {
		font-family:Tahoma,Arial;
		font-size:11px;
	}

	#SpamCheck_Loading {
	}

	div.spamRule_Success {
		vertical-align: middle;
		padding: 4px 3px 4px 3px;
	}

	div.spamRule_Success img {
		vertical-align: middle;
		padding-left: 2px;
		padding-right: 2px;
	}

	div.spamRuleBroken_row {
		background-color: #F9F9F9;
		display: block;
		clear: both;
	}

	div.spamRuleBroken_row_rulename {
		float: left;
		padding: 3px 0px 3px 5px;
	}

	div.spamRuleBroken_row_rulescore {
		float: right;
		width: 80px;
		text-align: right;
		padding: 3px 15px 3px 5px;
	}

	div.spamRuleBroken_graph {
		border: 1px gray solid;
		height:5px;
		background-color:#eeeeee;
	}
</style>
<div id="SpamCheck_Container">
	<div class="Text">%%LNG_Spam_Guide_Intro%%</div>
	<br />
	<div id="SpamCheck_MessageContainer">
		<div id="SpamCheck_Message">
			<div id="SpamCheck_Loading"><img src="images/loading.gif" alt="loading..." /></div>
			<br />
			%%LNG_Spam_Loading%%
		</div>
		<br />
	</div>
</div>