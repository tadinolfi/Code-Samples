function showImage(imageId) {
    var image = document.getElementById(imageId);
    var images = document.getElementsByTagName("img");
    for (var i = 0; i < images.length; i++) {
        var imgId = images[i].id;
        if (imgId.substr(0, 3) == "img") {
            images[i].className = "hiddenImage"
        }
    }
    image.className = ""
}

function prevImage() {
    var images = document.getElementsByTagName("img");
    var found = false;
    for (var i = 0; i < images.length; i++) {
        var imgId = images[i].id;
        if (imgId.substr(0, 3) == "img") {
            if (images[i].className != "hiddenImage" && found == false) {
                var showImgInt = parseInt(imgId.substr(3, 1)) - 1;
                if (showImgInt >= 1) {
                    images[i].className = "hiddenImage"
                    var showImgId = "img" + showImgInt;
                    var showImg = document.getElementById(showImgId);
                    showImg.className = ""
                }
                found = true;
            }
        }
    }
}

function nextImage(maxInt) {
    var image = document.getElementById("img1");
    var images = document.getElementsByTagName("img");
    var found = false;
    for (var i = 0; i < images.length; i++) {
        var imgId = images[i].id;
        if (imgId.substr(0, 3) == "img") {
            if (images[i].className != "hiddenImage" && found == false) {
                var showImgInt = parseInt(imgId.substr(3, 1)) + 1;
                if (showImgInt < maxInt) {
                    images[i].className = "hiddenImage"
                    var showImgId = "img" + showImgInt;
                    var showImg = document.getElementById(showImgId);
                    showImg.className = ""
                }
                found = true;
            }
        }
    }
    if (!found) {
        image.className = "hiddenImage"
        image2 = document.getElementById("img2");
        image2.className = ""
    }
}