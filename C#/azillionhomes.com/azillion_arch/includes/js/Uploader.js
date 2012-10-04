function addTitle(radUpload, args) {
    var currentLiElement = args.get_row();
    var firstInput = currentLiElement.getElementsByTagName("input")[0];

    //Create the container
    var containerDiv = document.createElement("div");
    containerDiv.className = "AdditionalInputs";
    
    //Create the Title Input and Labels
    var titleInput = CreateInput("Title", "text");
    titleInput.className = "TextField";
    titleInput.id = titleInput.name = radUpload.getID(titleInput.name);
    var titleLabel = CreateLabel("Caption/Title", titleInput.id);
    var fileLabel = CreateLabel("File", radUpload.getID());

    //Append
    containerDiv.appendChild(titleLabel);
    containerDiv.appendChild(titleInput);
    var firstNode = currentLiElement.childNodes[0];
    currentLiElement.insertBefore(fileLabel, firstNode);
    currentLiElement.insertBefore(containerDiv, fileLabel);
}

function CreateLabel(text, associatedControlId) {
    var label = document.createElement("label");
    label.innerHTML = text;
    label.setAttribute("for", associatedControlId);
    label.style.fontSize = 12;

    return label;
}

function CreateInput(inputName, type) {
    var input = document.createElement("input");
    input.type = type;
    input.name = inputName;

    return input;
}