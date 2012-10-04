var contactTabID = "contactInfoTab";
var contactContentID = "contactInfoContent";
var generalTabID = "generalInfoTab";
var generalContentID = "generalInfoContent";
var contactTab = null;
var contactContent = null;
var generalTab = null;
var generalContent = null;

function showGeneral() {
    getElements();
    contactTab.className = "";
    contactContent.style.display = "none";
    generalTab.className = "active";
    generalContent.style.display = "block";
}

function showContact() {
    getElements();
    contactTab.className = "active";
    contactContent.style.display = "block";
    generalTab.className = "";
    generalContent.style.display = "none";
}

function getElements() {
    contactTab = document.getElementById(contactTabID);
    contactContent = document.getElementById(contactContentID);
    generalTab = document.getElementById(generalTabID);
    generalContent = document.getElementById(generalContentID);
}