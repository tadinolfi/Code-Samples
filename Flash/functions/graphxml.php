<?php

error_reporting(6143);
ini_set("display_errors","1");

require(dirname(__FILE__) . '/sendstudio_functions.php');

class GraphXML extends SendStudio_Functions
{
	var $animation;
	var $graphType;
	var $plotMode;
	var $graphSeries;
	var $graphTitle;
	var $graphSettings;
	
	function GraphXML()
	{	
		$this->LoadLanguageFile();
	}
	
	function Process()
	{
		$action = (isset($_GET['Action'])) ? strtolower(urldecode($_GET['Action'])) : null;
		$subaction = (isset($_GET['Subaction'])) ? strtolower(urldecode($_GET['Subaction'])) : null;
		$session = &GetSession();
		$user = &GetUser();
		$graph = $_GET['Graph'];
		$this->GenerateGraphSettings($graph);
		$renderMe = $this->CreateGraph($graph);
		$this->Render($renderMe);
	}
	
	private function Render($cont)
	{
		print '<?xml version="1.0" encoding="UTF-8" ?>' . "\n";
		print $cont;
	}
	
	private function CreateGraph($graph)
	{
		$data = $this->GenerateGraphData($graph);
		$shell = '<anychart>' . 
					 '  <settings><animation' . $this->animation . '/></settings>' . "\n" .
					 '  <charts>' . "\n" .
					 '    <chart plot_type="' . $this->graphType . '">' . "\n" .
					 '      <data_plot_settings' . $this->plotMode . '>' . "\n" .
					 '        ' . $this->graphSeries . "\n" .
					 '      </data_plot_settings>' . "\n" .
					 '      <data>' . "\n" .
					 '        ' . $data . "\n" .
					 '      </data>' . "\n" .
					 '      <chart_settings>' . "\n" .
					 '        ' . $this->graphTitle . "\n" .
					 '        ' . $this->graphSettings . "\n" .
					 '      </chart_settings>' . "\n" .
					 '    </chart>' . "\n" .
					 '  </charts>' . "\n" .
					 '</anychart>';
		return $shell;
	}
	
	private function GenerateGraphData($graph)
	{
		$shell = '';
		switch($graph)
		{
			case 'dashboard':
				$shell = '<series name="Email Campaign Summary Chart">' . "\n";
				$statsapi = $this->GetApi('Stats'); 
				$summary = $statsapi->GetNewsletterSummary($statsapi->GetMostRecent(), false, 1000);
				$shell .= '          ' . $this->CreatePoint('Opened', $summary['emailopens_unique'], '#F98F25');
				$shell .= '          ' . $this->CreatePoint('Unopened', $summary['htmlrecipients'] + $summary['textrecipients'] + $summary['multipartrecipients'] - $summary['emailopens_unique'], '#FFBE21');
				$shell .= '          ' . $this->CreatePoint('Bounced', $summary['bouncecount_unknown'] + $summary['bouncecount_hard'] + $summary['bouncecount_soft'], '#84B221');
				$shell .= '        </series>';
				break;
			case 'summary': //this function is recursive of the one above it aside from the one difference. It checks the ID since it gets one.
				$shell = '<series name="Email Campaign Summary Chart">' . "\n";
				$statsapi = $this->GetApi('Stats'); 
				$summary = $statsapi->GetNewsletterSummary($_GET['id'], false, 1000);
				$shell .= '          ' . $this->CreatePoint('Opened', $summary['emailopens_unique'], '#F98F25');
				$shell .= '          ' . $this->CreatePoint('Unopened', $summary['htmlrecipients'] + $summary['textrecipients'] + $summary['multipartrecipients'] - $summary['emailopens_unique'], '#FFBE21');
				$shell .= '          ' . $this->CreatePoint('Bounced', $summary['bouncecount_unknown'] + $summary['bouncecount_hard'] + $summary['bouncecount_soft'], '#84B221');
				$shell .= '        </series>';
				break;
		}
		//die(print $shell);
		return $shell;
	}
	
	private function CreatePoint($name, $value, $color)
	{
		if($value == '' || $value == 0)
		{
			return '';
		}
		return '<point name="' . $name . '" y="' . $value . '" color="' . $color . '"/>' . "\n";
	}
	
	private function GenerateGraphSettings($graph)
	{
		switch($graph)
		{
			case 'dashboard':
				$this->animation = ' enabled="True" ';
				$this->graphType = 'Pie';
				$this->plotMode = ' enable_3d_mode="True"';
				$this->graphSeries = '<pie_series>' .
									 '          <tooltip_settings enabled="true">' . "\n" .
									 '            <format>' . "\n" .
									 '              {%Name} - {%YPercentOfSeries}{numDecimals:2}%' . "\n" .
									 '            </format>' . "\n" .
									 '          </tooltip_settings>' . "\n" .
									 '          <label_settings enabled="True">' . "\n" .
									 '            <font color="White">' . "\n" .
									 '              <effects>' . "\n" .
									 '                <drop_shadow enabled="True"/>' . "\n" .
									 '              </effects>' . "\n" .
									 '            </font>' . "\n" .
									 '            <position anchor="Center" valign="Center" halign="Center" padding="0"/>' . "\n" .
									 '            <format>{%YPercentOfSeries}{numDecimals:1}%</format>' . "\n" .
									 '          </label_settings>' . "\n" .
									 '        </pie_series>';
				$this->graphTitle = '<title enabled="False" />';
				$this->graphSettings = '<chart_background>' . "\n" .
									   '          <corners type="Square" />' . "\n" .
									   '          <border enabled="False" />' . "\n" .
									   '          <fill enabled="False" />' . "\n" .
									   '        </chart_background>';
				break;
			case 'summary':
				$this->animation = ' enabled="True" ';
				$this->graphType = 'Pie';
				$this->plotMode = ' enable_3d_mode="True"';
				$this->graphSeries = '<pie_series>' .
									 '          <tooltip_settings enabled="true">' . "\n" .
									 '            <format>' . "\n" .
									 '              {%Name} - {%YPercentOfSeries}{numDecimals:2}%' . "\n" .
									 '            </format>' . "\n" .
									 '          </tooltip_settings>' . "\n" .
									 '          <label_settings enabled="True">' . "\n" .
									 '            <font color="White">' . "\n" .
									 '              <effects>' . "\n" .
									 '                <drop_shadow enabled="True"/>' . "\n" .
									 '              </effects>' . "\n" .
									 '            </font>' . "\n" .
									 '            <position anchor="Center" valign="Center" halign="Center" padding="0"/>' . "\n" .
									 '            <format>{%YPercentOfSeries}{numDecimals:1}%</format>' . "\n" .
									 '          </label_settings>' . "\n" .
									 '        </pie_series>';
				$this->graphTitle = '<title enabled="False" />';
				$this->graphSettings = '<title>' . "\n" .
									   '          <text>Email Campaign Summary Chart</text>' . "\n" .
									   '        </title>' . "\n" .
									   '        <chart_background>' . "\n" .
									   '          <corners type="Square" />' . "\n" .
									   '          <border enabled="False" />' . "\n" .
									   '          <fill enabled="False" />' . "\n" .
									   '        </chart_background>' . "\n" .
									   '        <legend enabled="true" ignore_auto_item="True" columns="1" width="30%">' . "\n" .
									   '          <title enabled="false" />' . "\n" .
									   '          <columns_separator enabled="false" />' . "\n" .
									   '          <items>' . "\n" .
									   '            <item source="points" series="Email Campaign Summary Chart">' . "\n" .
									   '              <text>{%Icon} {%Name} {%YPercentOfSeries}{numDecimals:2}% ({%Value}{numDecimals:0})</text>' . "\n" .
									   '            </item>' . "\n" .
									   '          </items>' . "\n" .
									   '        </legend>';
				break;
		}
	}		
}
				