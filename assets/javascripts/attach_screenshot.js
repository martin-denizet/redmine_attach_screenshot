//var screenshotFieldCount = 1;

function hideAttachScreen() {
    document.getElementById('attach_applet').style.display = 'none';
    document.getElementById('attach_applet').innerHTML = '';
}
function deleteAttachScreen(fileId) {
    p.removeChild(document.getElementById(fileId));
}
function addLinkToAttachScreen(fileId) {    
    if (wikiToolbar){
    fileId = fileId.replace("thumb", "screenshot")
	wikiToolbar.encloseSelection("!"+ fileId +"!","");
    }
}
