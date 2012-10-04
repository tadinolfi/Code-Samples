function toggle(ID){
	if (document.getElementById){
		document.getElementById(ID);
		if (document.getElementById('answer' + ID).style.display == "none"){
			document.getElementById('answer' + ID).style.display = "block"
			document.getElementById('answer' + ID).style.backgroundColor = "#5b87b2";
			document.getElementById('question' + ID).style.backgroundColor = "#5b87b2";
			document.getElementById('question' + ID).style.backgroundImage = "url(images/content/bg-faq-arrow-1.gif)";
			document.getElementById('question' + ID).style.backgroundRepeat = "no-repeat";
			document.getElementById('question' + ID).style.backgroundPosition = "20px 15px";
		} else {
		document.getElementById('answer' + ID).style.display = "none";
		document.getElementById('answer' + ID).style.backgroundColor = "#36618f";
		document.getElementById('question' + ID).style.backgroundColor = "#36618f";
		document.getElementById('question' + ID).style.backgroundImage = "url(images/content/bg-faq-arrow-0.gif)";
		document.getElementById('question' + ID).style.backgroundRepeat = "no-repeat";
		document.getElementById('question' + ID).style.backgroundPosition = "20px 15px";
		}
	}
}