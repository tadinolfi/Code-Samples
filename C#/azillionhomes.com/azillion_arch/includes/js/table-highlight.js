/************************************************************************************************************
(C) www.dhtmlgoodies.com
************************************************************************************************************/	
var arrayOfRolloverClasses = new Array();
var activeRow = false;

function highlightTableRow(){
	var tableObj = this.parentNode;
	if(tableObj.tagName!='TABLE')tableObj = tableObj.parentNode;

	if(this!=activeRow){
		this.setAttribute('origCl',this.className);
		this.origCl = this.className;
	}
	this.className = arrayOfRolloverClasses[tableObj.id];
	
	activeRow = this;
	
}

function resetRowStyle(){
	var tableObj = this.parentNode;
	if(tableObj.tagName!='TABLE')tableObj = tableObj.parentNode;

	var origCl = this.getAttribute('origCl');
	if(!origCl)origCl = this.origCl;
	this.className=origCl;
	
}
	
function addTableRolloverEffect(tableId,whichClass){
	arrayOfRolloverClasses[tableId] = whichClass;
	
	var tableObj = document.getElementById(tableId);
	var tBody = tableObj.getElementsByTagName('TBODY');
	if(tBody){
		var rows = tBody[0].getElementsByTagName('TR');
	}else{
		var rows = tableObj.getElementsByTagName('TR');
	}
	for(var no=0;no<rows.length;no++){
		rows[no].onmouseover = highlightTableRow;
		rows[no].onmouseout = resetRowStyle;
	}
	
}