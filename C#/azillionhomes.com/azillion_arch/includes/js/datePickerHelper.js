var m_names = new Array("January", "February", "March", 
"April", "May", "June", "July", "August", "September", 
"October", "November", "December");

function getTitleDiv(containerID)
{
    containerID = "_" + containerID + "Container";
    var container = document.getElementById(containerID);
    var childDivs = container.getElementsByTagName("div");
    
     for (var i = 0; i < childDivs.length; i++) { 
        className = childDivs[i].className;
        if (className == "calendarTitle") {
            return childDivs[i];
        }
     }
     return null;
}

function incrementMonth(containerID)
{
    var titleDiv = getTitleDiv(containerID);
    var dateBits = titleDiv.innerHTML.split(" ");
    var newDate = new Date(dateBits[0] + " 1, " + dateBits[1] + " 00:00:00");
    var modDate = AddMonth(newDate, true);
    titleDiv.innerHTML = m_names[modDate.getMonth()] + " " + modDate.getFullYear();
}

function decrementMonth(containerID)
{
    var titleDiv = getTitleDiv(containerID);
    var dateBits = titleDiv.innerHTML.split(" ");
    var newDate = new Date(dateBits[0] + " 1, " + dateBits[1] + " 00:00:00");
    var modDate = AddMonth(newDate, false);
    titleDiv.innerHTML = m_names[modDate.getMonth()] + " " + modDate.getFullYear();
}

function AddMonth(date, isFuture)
{
    var month = date.getMonth();
    var year = date.getFullYear();
    
    if (isFuture && month == 11)
    {
        date.setMonth(0);
        date.setYear(year+1);
    }
    else if (isFuture)
    {
        date.setMonth(month+1);
    }
    else if (!isFuture && month == 0)
    {
        date.setMonth(11);
        date.setYear(year-1);
    }
    else if (!isFuture)
    {
        date.setMonth(month-1);
    }
    
    return date;
}